import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nikahin_app/data/remote/firestore_rest_service.dart';

void main() {
  group('FirestoreRestService Unit Tests', () {
    test('signUpWithEmail offline fallback produces local AuthResponse', () async {
      final service = FirestoreRestService(apiKey: '', projectId: 'nikahin-test');
      final res = await service.signUpWithEmail(email: 'test@nikahin.app', password: 'password123');

      expect(res, isNotNull);
      expect(res!.email, equals('test@nikahin.app'));
      expect(res.localId, startsWith('offline_user_'));
      expect(res.isSuccess, isTrue);
    });

    test('signInWithEmail offline fallback produces local AuthResponse', () async {
      final service = FirestoreRestService(apiKey: '', projectId: 'nikahin-test');
      final res = await service.signInWithEmail(email: 'user@nikahin.app', password: 'password123');

      expect(res, isNotNull);
      expect(res!.email, equals('user@nikahin.app'));
      expect(res.isSuccess, isTrue);
    });

    test('signUpWithEmail parses Firebase Auth errors cleanly', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': {
              'code': 400,
              'message': 'EMAIL_EXISTS',
            }
          }),
          400,
        );
      });

      final service = FirestoreRestService(
        apiKey: 'fake_key',
        projectId: 'nikahin-test',
        client: mockClient,
      );

      final res = await service.signUpWithEmail(email: 'exists@nikahin.app', password: 'password123');

      expect(res, isNotNull);
      expect(res!.isSuccess, isFalse);
      expect(res.errorMessage, contains('Email ini sudah terdaftar'));
    });

    test('putDocument formats fields and sends PATCH request successfully', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, equals('PATCH'));
        expect(request.headers['Content-Type'], equals('application/json'));
        return http.Response('{"name": "doc_1"}', 200);
      });

      final service = FirestoreRestService(
        apiKey: 'fake_key',
        projectId: 'nikahin-test',
        client: mockClient,
      );

      final success = await service.putDocument(
        path: 'users/u1/wedding_profiles/p1',
        data: {
          'groomName': 'Rivaldi',
          'budgetCap': 50000000.0,
          'isCompleted': false,
        },
      );

      expect(success, isTrue);
    });

    test('getCollection parses document list properly', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'documents': [
              {
                'name': 'projects/test/databases/(default)/documents/users/u1/wedding_profiles/p1',
                'fields': {
                  'groomName': {'stringValue': 'Rivaldi'},
                  'brideName': {'stringValue': 'Alya'},
                }
              }
            ]
          }),
          200,
        );
      });

      final service = FirestoreRestService(
        apiKey: 'fake_key',
        projectId: 'nikahin-test',
        client: mockClient,
      );

      final list = await service.getCollection(collectionPath: 'users/u1/wedding_profiles');

      expect(list.length, equals(1));
      expect(list.first['id'], equals('p1'));
      expect(list.first['groomName'], equals('Rivaldi'));
      expect(list.first['brideName'], equals('Alya'));
    });
  });
}
