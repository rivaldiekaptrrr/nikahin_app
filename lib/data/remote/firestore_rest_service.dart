import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/config/firebase_config.dart';
import '../../domain/models/access_level.dart';
import '../local/preferences_manager.dart';

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

  /// Sign in / exchange Google ID Token with Firebase Auth via accounts:signInWithIdp
  Future<AuthResponse?> signInWithGoogleIdToken({
    required String googleIdToken,
  }) async {
    if (isRemoteConfigured && googleIdToken.isNotEmpty) {
      try {
        final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=$apiKey');
        final response = await _client.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'postBody': 'id_token=$googleIdToken&providerId=google.com',
            'requestUri': 'http://localhost',
            'returnIdpCredential': true,
            'returnSecureToken': true,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return AuthResponse(
            idToken: data['idToken'] ?? googleIdToken,
            email: data['email'] ?? '',
            localId: data['localId'] ?? '',
            refreshToken: data['refreshToken'],
          );
        }
      } catch (_) {}
    }
    return null;
  }

  /// Send password reset email via Firebase Auth REST API
  /// Returns null on success, or an error message on failure.
  Future<String?> sendPasswordResetEmail({required String email}) async {
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
        if (response.statusCode == 200) {
          return null; // Sukses terkirim!
        } else {
          return _parseFirebaseAuthError(response.body);
        }
      } catch (e) {
        return 'Gagal menghubungi server. Periksa koneksi internet Anda.';
      }
    }
    return email.contains('@') ? null : 'Format email tidak valid.';
  }

  /// Exchange refreshToken for a new idToken via Google Secure Token API
  Future<String?> refreshIdToken({String? refreshToken}) async {
    if (!isRemoteConfigured) return null;
    final token = refreshToken ?? await AppPreferences.getRefreshToken();
    if (token == null || token.isEmpty) return null;

    try {
      final url = Uri.parse('https://securetoken.googleapis.com/v1/token?key=$apiKey');
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'grant_type=refresh_token&refresh_token=$token',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newIdToken = data['id_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;
        if (newIdToken != null && newIdToken.isNotEmpty) {
          await AppPreferences.setIdToken(newIdToken);
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await AppPreferences.setRefreshToken(newRefreshToken);
          }
          return newIdToken;
        }
      }
    } catch (_) {}
    return null;
  }

  String get _baseUrl =>
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  /// Save or update a document via REST API
  /// 
  /// Jika [updateMask] disediakan, hanya field tersebut yang diperbarui (Partial Update)
  /// sehingga field lain yang sudah ada pada dokumen tidak akan terhapus.
  Future<bool> putDocument({
    required String path,
    required Map<String, dynamic> data,
    String? idToken,
    List<String>? updateMask,
  }) async {
    try {
      final token = idToken ?? await AppPreferences.getIdToken();
      final queryParams = <String>[];
      if (apiKey.isNotEmpty) queryParams.add('key=$apiKey');
      if (updateMask != null && updateMask.isNotEmpty) {
        for (final field in updateMask) {
          queryParams.add('updateMask.fieldPaths=$field');
        }
      }
      final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
      final url = Uri.parse('$_baseUrl/$path$queryString');
      final firestoreFields = _toFirestoreFields(data);
      final body = jsonEncode({'fields': firestoreFields});

      var response = await _client
          .patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        final refreshedToken = await refreshIdToken();
        if (refreshedToken != null && refreshedToken != token) {
          response = await _client
              .patch(
                url,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $refreshedToken',
                },
                body: body,
              )
              .timeout(const Duration(seconds: 10));
        }
      }

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
      final token = idToken ?? await AppPreferences.getIdToken();
      final url = Uri.parse('$_baseUrl/$path${apiKey.isNotEmpty ? "?key=$apiKey" : ""}');
      var response = await _client
          .delete(
            url,
            headers: {
              if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        final refreshedToken = await refreshIdToken();
        if (refreshedToken != null && refreshedToken != token) {
          response = await _client
              .delete(
                url,
                headers: {
                  'Authorization': 'Bearer $refreshedToken',
                },
              )
              .timeout(const Duration(seconds: 10));
        }
      }

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
      final token = idToken ?? await AppPreferences.getIdToken();
      final url = Uri.parse('$_baseUrl/$path${apiKey.isNotEmpty ? "?key=$apiKey" : ""}');
      var response = await _client
          .get(
            url,
            headers: {
              if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        final refreshedToken = await refreshIdToken();
        if (refreshedToken != null && refreshedToken != token) {
          response = await _client
              .get(
                url,
                headers: {
                  'Authorization': 'Bearer $refreshedToken',
                },
              )
              .timeout(const Duration(seconds: 10));
        }
      }

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
      updateMask: ['accessLevel', 'updatedAt'],
    );
  }

  /// Delete user document (For Admin Dashboard)
  Future<bool> deleteUser(String targetUserId, {String? idToken}) async {
    return deleteDocument(
      path: 'users/$targetUserId',
      idToken: idToken,
    );
  }

  /// Get all documents in a collection via REST API (with pagination & 401 auto-retry)
  Future<List<Map<String, dynamic>>> getCollection({
    required String collectionPath,
    String? idToken,
  }) async {
    try {
      final results = <Map<String, dynamic>>[];
      String? pageToken;
      String? currentToken = idToken ?? await AppPreferences.getIdToken();
      bool hasRetriedAuth = false;

      do {
        final queryParams = <String>[];
        if (apiKey.isNotEmpty) queryParams.add('key=$apiKey');
        queryParams.add('pageSize=300');
        if (pageToken != null && pageToken.isNotEmpty) {
          queryParams.add('pageToken=$pageToken');
        }

        final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
        final url = Uri.parse('$_baseUrl/$collectionPath$queryString');

        var response = await _client
            .get(
              url,
              headers: {
                if (currentToken != null && currentToken.isNotEmpty)
                  'Authorization': 'Bearer $currentToken',
              },
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 401 && !hasRetriedAuth) {
          hasRetriedAuth = true;
          final refreshedToken = await refreshIdToken();
          if (refreshedToken != null && refreshedToken != currentToken) {
            currentToken = refreshedToken;
            response = await _client
                .get(
                  url,
                  headers: {
                    'Authorization': 'Bearer $currentToken',
                  },
                )
                .timeout(const Duration(seconds: 10));
          }
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final decoded = jsonDecode(response.body);
          final documents = decoded['documents'] as List<dynamic>? ?? [];
          for (final doc in documents) {
            final fields = doc['fields'] as Map<String, dynamic>? ?? {};
            final name = doc['name'] as String? ?? '';
            final docId = name.split('/').last;
            final mapped = _fromFirestoreFields(fields);
            mapped['id'] = docId;
            results.add(mapped);
          }
          pageToken = decoded['nextPageToken'] as String?;
        } else {
          break;
        }
      } while (pageToken != null && pageToken.isNotEmpty);

      return results;
    } catch (_) {}
    return [];
  }

  Map<String, dynamic> _toFirestoreFields(Map<String, dynamic> map) {
    final fields = <String, dynamic>{};
    map.forEach((key, value) {
      fields[key] = _toFirestoreValue(value);
    });
    return fields;
  }

  Map<String, dynamic> _toFirestoreValue(dynamic value) {
    if (value == null) {
      return {'nullValue': null};
    } else if (value is bool) {
      return {'booleanValue': value};
    } else if (value is int) {
      return {'integerValue': value.toString()};
    } else if (value is double) {
      return {'doubleValue': value};
    } else if (value is String) {
      return {'stringValue': value};
    } else if (value is List) {
      return {
        'arrayValue': {
          'values': value.map((v) => _toFirestoreValue(v)).toList(),
        }
      };
    } else if (value is Map<String, dynamic>) {
      return {
        'mapValue': {
          'fields': _toFirestoreFields(value),
        }
      };
    }
    return {'stringValue': value.toString()};
  }

  Map<String, dynamic> _fromFirestoreFields(Map<String, dynamic> fields) {
    final result = <String, dynamic>{};
    fields.forEach((key, value) {
      result[key] = _fromFirestoreValue(value);
    });
    return result;
  }

  dynamic _fromFirestoreValue(dynamic firestoreValue) {
    if (firestoreValue is Map<String, dynamic>) {
      if (firestoreValue.containsKey('stringValue')) {
        return firestoreValue['stringValue'];
      } else if (firestoreValue.containsKey('integerValue')) {
        return int.tryParse(firestoreValue['integerValue'].toString()) ?? 0;
      } else if (firestoreValue.containsKey('doubleValue')) {
        return (firestoreValue['doubleValue'] as num).toDouble();
      } else if (firestoreValue.containsKey('booleanValue')) {
        return firestoreValue['booleanValue'];
      } else if (firestoreValue.containsKey('nullValue')) {
        return null;
      } else if (firestoreValue.containsKey('timestampValue')) {
        return firestoreValue['timestampValue'];
      } else if (firestoreValue.containsKey('arrayValue')) {
        final list = firestoreValue['arrayValue']?['values'] as List<dynamic>? ?? [];
        return list.map((item) => _fromFirestoreValue(item)).toList();
      } else if (firestoreValue.containsKey('mapValue')) {
        final fields = firestoreValue['mapValue']?['fields'] as Map<String, dynamic>? ?? {};
        return _fromFirestoreFields(fields);
      }
    }
    return firestoreValue;
  }

  String _parseFirebaseAuthError(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      final rawError = decoded['error']?['message'] as String? ?? '';

      if (rawError.contains('EMAIL_EXISTS')) {
        return 'Email ini sudah terdaftar. Silakan login ke akun Anda.';
      } else if (rawError.contains('EMAIL_NOT_FOUND')) {
        return 'Email tidak terdaftar di sistem Nikahin.';
      } else if (rawError.contains('INVALID_LOGIN_CREDENTIALS') ||
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
