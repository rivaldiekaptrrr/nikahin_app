import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthResponse {
  final String idToken;
  final String email;
  final String localId;

  AuthResponse({
    required this.idToken,
    required this.email,
    required this.localId,
  });
}

class FirestoreRestService {
  final String? projectId;
  final String? apiKey;

  FirestoreRestService({
    this.projectId,
    this.apiKey,
  });

  /// Sign up with email & password via Firebase Auth REST or local fallback
  Future<AuthResponse?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    if (apiKey != null && apiKey!.isNotEmpty) {
      try {
        final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey');
        final response = await http.post(
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
          );
        }
      } catch (_) {}
    }
    // Local / Offline fallback auth
    if (email.contains('@') && password.length >= 6) {
      return AuthResponse(
        idToken: 'offline_token_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        localId: 'offline_user_${email.hashCode}',
      );
    }
    return null;
  }

  /// Sign in with email & password via Firebase Auth REST or local fallback
  Future<AuthResponse?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (apiKey != null && apiKey!.isNotEmpty) {
      try {
        final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');
        final response = await http.post(
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
          );
        }
      } catch (_) {}
    }
    // Local / Offline fallback auth
    if (email.contains('@') && password.length >= 6) {
      return AuthResponse(
        idToken: 'offline_token_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        localId: 'offline_user_${email.hashCode}',
      );
    }
    return null;
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail({required String email}) async {
    if (apiKey != null && apiKey!.isNotEmpty) {
      try {
        final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey');
        final response = await http.post(
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
      'https://firestore.googleapis.com/v1/projects/${projectId ?? "nikahin-app"}/databases/(default)/documents';

  /// Save or update a document via REST API
  Future<bool> putDocument({
    required String path,
    required Map<String, dynamic> data,
    String? idToken,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$path${apiKey != null ? "?key=$apiKey" : ""}');
      final firestoreFields = _toFirestoreFields(data);
      final body = jsonEncode({'fields': firestoreFields});

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
        body: body,
      );

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
      final url = Uri.parse('$_baseUrl/$path${apiKey != null ? "?key=$apiKey" : ""}');
      final response = await http.delete(
        url,
        headers: {
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Get all documents in a collection via REST API
  Future<List<Map<String, dynamic>>> getCollection({
    required String collectionPath,
    String? idToken,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/$collectionPath${apiKey != null ? "?key=$apiKey" : ""}');
      final response = await http.get(
        url,
        headers: {
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
      );

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
}
