import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/data/local/database.dart';
import 'package:nikahin_app/data/remote/firestore_rest_service.dart';
import 'package:nikahin_app/data/remote/sync_manager.dart';
import 'package:nikahin_app/domain/models/wedding_models.dart';

void main() {
  late AppDatabase db;
  late FirestoreRestService firestore;
  late SyncManager syncManager;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    firestore = FirestoreRestService(apiKey: '', projectId: 'test-project');
    syncManager = SyncManager(
      db: db,
      firestore: firestore,
      userId: 'test_user_1',
      isSyncEnabled: false,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('SyncManager Unit Tests', () {
    test('pullAll returns false when isSyncEnabled is false', () async {
      final res = await syncManager.pullAll();
      expect(res, isFalse);
    });

    test('configure updates userId and enabled flag', () {
      syncManager.configure(newUserId: 'user_xyz', enabled: true);
      expect(syncManager.userId, equals('user_xyz'));
      expect(syncManager.isSyncEnabled, isTrue);
    });

    test('pushExpense skips execution safely when disabled', () async {
      final expense = WeddingExpense(
        expenseId: 'exp_test_1',
        weddingProfileId: 'prof_1',
        category: 'CATERING',
        title: 'Katering Utama',
        totalEstimated: 35000000.0,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Should not throw or fail
      await syncManager.pushExpense(expense);
    });
  });
}
