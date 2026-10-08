import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/config/firebase_config.dart';
import '../../domain/models/access_level.dart';

class AuthResponse {
  final String idToken;
  final String email;
  final String localId;
  final String? refreshToken;
  final String? errorMessage;

  AuthResponse({
    required this.idToken,
    required this.email,
    required this.localId,
    this.refreshToken,
    this.errorMessage,
  });

  bool get isSuccess => errorMessage == null;
}

class FirestoreRestService {
  final String projectId;
  final String apiKey;
  final http.Client _client;

  FirestoreRestService({
    String? projectId,
    String? apiKey,
    http.Client? client,
  })  : projectId = projectId ?? FirebaseConfig.projectId,
        apiKey = apiKey ?? FirebaseConfig.apiKey,
        _client = client ?? http.Client();

  bool get isRemoteConfigured => apiKey.isNotEmpty && projectId.isNotEmpty;

  /// Sign up with email & password via Firebase Auth REST or local fallback
  Future<AuthResponse?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    if (isRemoteConfigured) {
      try {
        final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey');
        final response = await _client.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return AuthResponse(
            idToken: data['idToken'] ?? '',
            email: data['email'] ?? email,
            localId: data['localId'] ?? '',
            refreshToken: data['refreshToken'],
          );
        } else {
          final errorMsg = _parseFirebaseAuthError(response.body);
          return AuthResponse(
            idToken: '',
            email: email,
            localId: '',
            errorMessage: errorMsg,
          );
        }
      } catch (e) {
        // Fallback or network error
      }
    }

    // Local / Offline fallback auth
    if (email.contains('@') && password.length >= 6) {
      return AuthResponse(
        idToken: 'offline_token_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        localId: 'offline_user_${email.hashCode.abs()}',
      );
    }
    return null;
  }

  /// Sign in with email & password via Firebase Auth REST or local fallback
  Future<AuthResponse?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (isRemoteConfigured) {
      try {
        final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');
        final response = await _client.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return AuthResponse(
            idToken: data['idToken'] ?? '',
            email: data['email'] ?? email,
            localId: data['localId'] ?? '',
            refreshToken: data['refreshToken'],
          );
        } else {
          final errorMsg = _parseFirebaseAuthError(response.body);
          return AuthResponse(
            idToken: '',
            email: email,
            localId: '',
            errorMessage: errorMsg,
          );
        }
      } catch (_) {}
    }

    // Local / Offline fallback auth
    if (email.contains('@') && password.length >= 6) {
      return AuthResponse(
        idToken: 'offline_token_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        localId: 'offline_user_${email.hashCode.abs()}',
      );
    }
    return null;
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail({required String email}) async {
    if (isRemoteConfigured) {
      try {
        final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey');
        final response = await _client.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'requestType': 'PASSWORD_RESET',
            'email': email,
          }),
        );
        return response.statusCode == 200;
      } catch (_) {}
    }
    return email.contains('@');
  }

  String get _baseUrl =>
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  /// Save or update a document via REST API
  Future<bool> putDocument({
    required String path,
    required Map<String, dynamic> data,
    String? idToken,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$path${apiKey.isNotEmpty ? "?key=$apiKey" : ""}');
      final firestoreFields = _toFirestoreFields(data);
      final body = jsonEncode({'fields': firestoreFields});

      final response = await _client
          .patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (idToken != null && idToken.isNotEmpty) 'Authorization': 'Bearer $idToken',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Delete a document via REST API
  Future<bool> deleteDocument({
    required String path,
    String? idToken,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$path${apiKey.isNotEmpty ? "?key=$apiKey" : ""}');
      final response = await _client
          .delete(
            url,
            headers: {
              if (idToken != null && idToken.isNotEmpty) 'Authorization': 'Bearer $idToken',
            },
          )
          .timeout(const Duration(seconds: 10));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Get a single document by path
  Future<Map<String, dynamic>?> getDocument({
    required String path,
    String? idToken,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$path${apiKey.isNotEmpty ? "?key=$apiKey" : ""}');
      final response = await _client
          .get(
            url,
            headers: {
              if (idToken != null && idToken.isNotEmpty) 'Authorization': 'Bearer $idToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final fields = decoded['fields'] as Map<String, dynamic>? ?? {};
        final name = decoded['name'] as String? ?? '';
        final docId = name.split('/').last;
        final mapped = _fromFirestoreFields(fields);
        mapped['id'] = docId;
        return mapped;
      }
    } catch (_) {}
    return null;
  }

  /// Get user info document
  Future<AppUserInfo?> getUserInfo(String userId, {String? idToken}) async {
    final raw = await getDocument(path: 'users/$userId', idToken: idToken);
    if (raw != null) {
      return AppUserInfo.fromFirestoreMap(raw, userId);
    }
    return null;
  }

  /// Sync/save user info document
  Future<bool> syncUserInfo(AppUserInfo user, {String? idToken}) async {
    return putDocument(
      path: 'users/${user.uid}',
      data: user.toFirestoreMap(),
      idToken: idToken,
    );
  }

  /// Get all registered users (For Admin Dashboard)
  Future<List<AppUserInfo>> getAllAppUsers({String? idToken}) async {
    final rawList = await getCollection(collectionPath: 'users', idToken: idToken);
    return rawList.map((raw) => AppUserInfo.fromFirestoreMap(raw, raw['id'] ?? '')).toList();
  }

  /// Update user access level (For Admin Dashboard)
  Future<bool> updateUserAccessLevel(String targetUserId, AccessLevel newLevel, {String? idToken}) async {
    return putDocument(
      path: 'users/$targetUserId',
      data: {
        'accessLevel': newLevel.code,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      idToken: idToken,
    );
  }

  /// Get all documents in a collection via REST API
  Future<List<Map<String, dynamic>>> getCollection({
    required String collectionPath,
    String? idToken,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$collectionPath${apiKey.isNotEmpty ? "?key=$apiKey" : ""}');
      final response = await _client
          .get(
            url,
            headers: {
              if (idToken != null && idToken.isNotEmpty) 'Authorization': 'Bearer $idToken',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final documents = decoded['documents'] as List<dynamic>? ?? [];
        return documents.map((doc) {
          final fields = doc['fields'] as Map<String, dynamic>? ?? {};
          final name = doc['name'] as String? ?? '';
          final docId = name.split('/').last;
          final mapped = _fromFirestoreFields(fields);
          mapped['id'] = docId;
          return mapped;
        }).toList();
      }
    } catch (_) {}
    return [];
  }

  Map<String, dynamic> _toFirestoreFields(Map<String, dynamic> map) {
    final fields = <String, dynamic>{};
    map.forEach((key, value) {
      if (value == null) {
        fields[key] = {'nullValue': null};
      } else if (value is bool) {
        fields[key] = {'booleanValue': value};
      } else if (value is int) {
        fields[key] = {'integerValue': value.toString()};
      } else if (value is double) {
        fields[key] = {'doubleValue': value};
      } else if (value is String) {
        fields[key] = {'stringValue': value};
      } else if (value is Map<String, dynamic>) {
        fields[key] = {'mapValue': {'fields': _toFirestoreFields(value)}};
      }
    });
    return fields;
  }

  Map<String, dynamic> _fromFirestoreFields(Map<String, dynamic> fields) {
    final result = <String, dynamic>{};
    fields.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        if (value.containsKey('stringValue')) {
          result[key] = value['stringValue'];
        } else if (value.containsKey('integerValue')) {
          result[key] = int.tryParse(value['integerValue'].toString()) ?? 0;
        } else if (value.containsKey('doubleValue')) {
          result[key] = (value['doubleValue'] as num).toDouble();
        } else if (value.containsKey('booleanValue')) {
          result[key] = value['booleanValue'];
        } else if (value.containsKey('nullValue')) {
          result[key] = null;
        }
      }
    });
    return result;
  }

  String _parseFirebaseAuthError(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      final rawError = decoded['error']?['message'] as String? ?? '';

      if (rawError.contains('EMAIL_EXISTS')) {
        return 'Email ini sudah terdaftar. Silakan login ke akun Anda.';
      } else if (rawError.contains('INVALID_LOGIN_CREDENTIALS') ||
          rawError.contains('EMAIL_NOT_FOUND') ||
          rawError.contains('INVALID_PASSWORD')) {
        return 'Email atau kata sandi tidak cocok. Silakan periksa kembali.';
      } else if (rawError.contains('WEAK_PASSWORD')) {
        return 'Kata sandi terlalu pendek. Gunakan minimal 6 karakter.';
      } else if (rawError.contains('USER_DISABLED')) {
        return 'Akun pengguna ini telah dinonaktifkan oleh sistem.';
      } else if (rawError.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        return 'Terlalu banyak percobaan gagal. Silakan coba beberapa saat lagi.';
      } else if (rawError.isNotEmpty) {
        return rawError;
      }
    } catch (_) {}
    return 'Terjadi kesalahan autentikasi. Silakan coba lagi.';
  }
}
