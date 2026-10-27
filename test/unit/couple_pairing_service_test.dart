import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nikahin_app/data/remote/firestore_rest_service.dart';
import 'package:nikahin_app/data/services/couple_pairing_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group('CouplePairingService & PairingCodeData Tests', () {
    test('normalizeCode and formatCodeForDisplay handle various formats', () {
      expect(CouplePairingService.normalizeCode('NK-8F2X9A'), equals('8F2X9A'));
      expect(CouplePairingService.normalizeCode('nk-8f2x9a'), equals('8F2X9A'));
      expect(CouplePairingService.normalizeCode('8F2 X9A'), equals('8F2X9A'));
      expect(CouplePairingService.normalizeCode('NK8F2X9A'), equals('8F2X9A'));
      expect(CouplePairingService.normalizeCode('8F2X9A'), equals('8F2X9A'));

      expect(CouplePairingService.formatCodeForDisplay('8F2X9A'), equals('NK-8F2-X9A'));
      expect(CouplePairingService.formatCodeForDisplay('NK-8F2X9A'), equals('NK-8F2-X9A'));
    });

    test('PairingCodeData expiration and active checks', () {
      final activeCode = PairingCodeData(
        code: 'ABCDEF',
        creatorUid: 'user_1',
        creatorName: 'Rivaldi',
        weddingId: 'wedding_1',
        creatorRole: 'GROOM',
        expiresAt: DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch,
        status: 'active',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      expect(activeCode.isExpired, isFalse);
      expect(activeCode.isActive, isTrue);

      final expiredCode = PairingCodeData(
        code: 'XYZ123',
        creatorUid: 'user_1',
        creatorName: 'Rivaldi',
        weddingId: 'wedding_1',
        creatorRole: 'GROOM',
        expiresAt: DateTime.now().subtract(const Duration(minutes: 5)).millisecondsSinceEpoch,
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(hours: 49)).millisecondsSinceEpoch,
      );

      expect(expiredCode.isExpired, isTrue);
      expect(expiredCode.isActive, isFalse);

      final claimedCode = PairingCodeData(
        code: 'CLM456',
        creatorUid: 'user_1',
        creatorName: 'Rivaldi',
        weddingId: 'wedding_1',
        creatorRole: 'GROOM',
        expiresAt: DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch,
        status: 'claimed',
        claimedByUid: 'user_2',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      expect(claimedCode.isExpired, isFalse);
      expect(claimedCode.isActive, isFalse);
    });

    test('generatePairingCode creates valid 6-char code and stores it', () async {
      final Map<String, dynamic> firestoreStorage = {};

      final mockClient = MockClient((request) async {
        final path = request.url.path;
        if (request.method == 'PATCH') {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          firestoreStorage[path] = body['fields'];
          return http.Response(jsonEncode({'name': path, 'fields': body['fields']}), 200);
        } else if (request.method == 'GET') {
          if (firestoreStorage.containsKey(path)) {
            return http.Response(jsonEncode({'name': path, 'fields': firestoreStorage[path]}), 200);
          }
          return http.Response(jsonEncode({'error': {'code': 404, 'message': 'Not found'}}), 404);
        }
        return http.Response('', 200);
      });

      final firestore = FirestoreRestService(
        apiKey: 'fake_key',
        projectId: 'nikahin-app',
        client: mockClient,
      );

      final service = CouplePairingService(firestore: firestore);

      final pairing = await service.generatePairingCode(
        creatorUid: 'uid_rivaldi',
        creatorName: 'Rivaldi',
        weddingId: 'wedding_rivaldi_alya',
        creatorRole: 'GROOM',
      );

      expect(pairing, isNotNull);
      expect(pairing!.code.length, equals(6));
      expect(pairing.creatorUid, equals('uid_rivaldi'));
      expect(pairing.weddingId, equals('wedding_rivaldi_alya'));
      expect(pairing.creatorRole, equals('GROOM'));
      expect(pairing.status, equals('active'));
    });

    test('verifyAndClaimPairingCode rejects self-pairing, expired, and claimed codes', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final mockCodes = <String, Map<String, dynamic>>{
        'SELF01': {
          'creatorUid': {'stringValue': 'user_me'},
          'creatorName': {'stringValue': 'Me'},
          'weddingId': {'stringValue': 'w1'},
          'creatorRole': {'stringValue': 'GROOM'},
          'expiresAt': {'integerValue': '${now + 100000}'},
          'status': {'stringValue': 'active'},
        },
        'EXPD01': {
          'creatorUid': {'stringValue': 'user_other'},
          'creatorName': {'stringValue': 'Other'},
          'weddingId': {'stringValue': 'w2'},
          'creatorRole': {'stringValue': 'BRIDE'},
          'expiresAt': {'integerValue': '${now - 10000}'},
          'status': {'stringValue': 'active'},
        },
        'CLMD01': {
          'creatorUid': {'stringValue': 'user_other'},
          'creatorName': {'stringValue': 'Other'},
          'weddingId': {'stringValue': 'w3'},
          'creatorRole': {'stringValue': 'BRIDE'},
          'expiresAt': {'integerValue': '${now + 100000}'},
          'status': {'stringValue': 'claimed'},
          'claimedByUid': {'stringValue': 'user_someone'},
        },
      };

      final mockClient = MockClient((request) async {
        final path = request.url.path;
        if (request.method == 'GET') {
          for (final entry in mockCodes.entries) {
            if (path.contains(entry.key)) {
              return http.Response(jsonEncode({'name': path, 'fields': entry.value}), 200);
            }
          }
          return http.Response(jsonEncode({'error': {'code': 404, 'message': 'Not found'}}), 404);
        }
        return http.Response(jsonEncode({'name': path}), 200);
      });

      final firestore = FirestoreRestService(
        apiKey: 'fake_key',
        projectId: 'nikahin-app',
        client: mockClient,
      );

      final service = CouplePairingService(firestore: firestore);

      // 1. Self Pairing
      final selfRes = await service.verifyAndClaimPairingCode(
        rawCode: 'NK-SELF01',
        partnerUid: 'user_me',
        partnerRole: 'BRIDE',
      );
      expect(selfRes.status, equals(CouplePairingStatus.selfPairingNotAllowed));

      // 2. Expired Code
      final expRes = await service.verifyAndClaimPairingCode(
        rawCode: 'EXPD01',
        partnerUid: 'user_partner',
        partnerRole: 'GROOM',
      );
      expect(expRes.status, equals(CouplePairingStatus.expiredCode));

      // 3. Already Claimed
      final clmRes = await service.verifyAndClaimPairingCode(
        rawCode: 'CLMD01',
        partnerUid: 'user_partner',
        partnerRole: 'GROOM',
      );
      expect(clmRes.status, equals(CouplePairingStatus.alreadyClaimed));
    });

    test('verifyAndClaimPairingCode successfully links partner and workspace', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final patchedPaths = <String>[];

      final mockClient = MockClient((request) async {
        final path = request.url.path;
        if (request.method == 'GET') {
          if (path.contains('VALD01')) {
            return http.Response(
              jsonEncode({
                'name': path,
                'fields': {
                  'creatorUid': {'stringValue': 'uid_creator'},
                  'creatorName': {'stringValue': 'Rivaldi'},
                  'weddingId': {'stringValue': 'w_shared'},
                  'creatorRole': {'stringValue': 'GROOM'},
                  'expiresAt': {'integerValue': '${now + 100000}'},
                  'status': {'stringValue': 'active'},
                }
              }),
              200,
            );
          } else if (path.contains('weddings/w_shared')) {
            return http.Response(
              jsonEncode({
                'name': path,
                'fields': {
                  'members': {
                    'arrayValue': {
                      'values': [
                        {'stringValue': 'uid_creator'}
                      ]
                    }
                  }
                }
              }),
              200,
            );
          }
          return http.Response(jsonEncode({'error': {'code': 404, 'message': 'Not found'}}), 404);
        } else if (request.method == 'PATCH') {
          patchedPaths.add(path);
          return http.Response(jsonEncode({'name': path}), 200);
        }
        return http.Response('', 200);
      });

      final firestore = FirestoreRestService(
        apiKey: 'fake_key',
        projectId: 'nikahin-app',
        client: mockClient,
      );

      final service = CouplePairingService(firestore: firestore);

      final result = await service.verifyAndClaimPairingCode(
        rawCode: 'NK-VALD01',
        partnerUid: 'uid_partner',
        partnerRole: 'BRIDE',
      );

      expect(result.isSuccess, isTrue);
      expect(result.status, equals(CouplePairingStatus.success));
      expect(result.weddingId, equals('w_shared'));
      expect(result.creatorUid, equals('uid_creator'));

      // Check that all 4 updates were dispatched:
      // 1. pairing_codes/VALD01
      // 2. weddings/w_shared
      // 3. users/uid_partner
      // 4. users/uid_creator
      expect(patchedPaths.any((p) => p.contains('pairing_codes/VALD01')), isTrue);
      expect(patchedPaths.any((p) => p.contains('weddings/w_shared')), isTrue);
      expect(patchedPaths.any((p) => p.contains('users/uid_partner')), isTrue);
      expect(patchedPaths.any((p) => p.contains('users/uid_creator')), isTrue);
    });
  });
}
