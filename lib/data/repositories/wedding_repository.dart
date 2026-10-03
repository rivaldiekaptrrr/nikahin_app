import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/database.dart';
import '../local/seed_data.dart';
import '../remote/firestore_rest_service.dart';
import '../remote/sync_manager.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/uuid_utils.dart';

// Providers
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final firestoreServiceProvider = Provider<FirestoreRestService>((ref) {
  return FirestoreRestService();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  final db = ref.watch(databaseProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  return SyncManager(db: db, firestore: firestore);
});

final weddingRepositoryProvider = Provider<WeddingRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final sync = ref.watch(syncManagerProvider);
  return WeddingRepository(db: db, sync: sync);
});

class ActiveProfileIdNotifier extends Notifier<String> {
  @override
  String build() => 'profile_rivaldi_alya';

  @override
  set state(String value) => super.state = value;
}

final activeProfileIdProvider =
    NotifierProvider<ActiveProfileIdNotifier, String>(ActiveProfileIdNotifier.new);

final activeProfileProvider = StreamProvider<WeddingProfile?>((ref) {
  final repo = ref.watch(weddingRepositoryProvider);
  return repo.watchSingleProfile();
});

class WeddingRepository {
  final AppDatabase db;
  final SyncManager sync;

  WeddingRepository({
    required this.db,
    required this.sync,
  });

  // ==================== PROFILES (SINGLE PROFILE) ====================
  Stream<List<WeddingProfile>> watchAllProfiles() => db.watchAllProfiles();
  Stream<WeddingProfile?> watchSingleProfile() => db.watchSingleProfile();
  Future<WeddingProfile?> getSingleProfile() => db.getSingleProfile();
  Future<WeddingProfile?> getProfile(String id) => db.getProfileById(id);

  Future<void> createProfile(WeddingProfile profile, {bool seedDefaults = true}) async {
    await db.insertProfile(profile);
    await sync.pushProfile(profile);

    if (seedDefaults) {
      // Seed default tasks
      final tasks = SeedData.generateDefaultTasks(profile.id, profile.weddingDate);
      await db.insertTasksBatch(tasks);

      // Seed default documents based on religion
      final docs = SeedData.generateDefaultDocuments(profile.id, profile.religionType);
      await db.insertDocumentsBatch(docs);

      // Seed default events
      final events = SeedData.generateDefaultEvents(profile.id, profile.weddingDate);
      await db.insertEventsBatch(events);
    }
  }

  Future<void> updateProfile(WeddingProfile profile) async {
    await db.updateProfile(profile);
    await sync.pushProfile(profile);
  }

  Future<void> deleteProfile(String id) async {
    await db.deleteProfile(id); // Drift automatically cascades and deletes all children
    await sync.deleteRemoteProfile(id);
  }

  // ==================== EXPENSES & TERMS ====================
  Stream<List<WeddingExpense>> watchExpenses(String profileId) => db.watchExpenses(profileId);

  Future<void> createExpense(WeddingExpense expense) async {
    await db.insertExpense(expense);
    await sync.pushExpense(expense);
  }

  Future<void> updateExpense(WeddingExpense expense) async {
    await db.updateExpense(expense);
    await sync.pushExpense(expense);
  }

  Future<void> deleteExpense(String expenseId) async {
    await db.deleteExpense(expenseId);
    await sync.deleteRemoteExpense(expenseId);
  }

  Stream<List<WeddingPaymentTerm>> watchPaymentTerms(String expenseId) => db.watchPaymentTerms(expenseId);

  Future<void> createPaymentTerm(WeddingPaymentTerm term) async {
    await db.insertPaymentTerm(term);
  }

  Future<void> updatePaymentTerm(WeddingPaymentTerm term) async {
    await db.updatePaymentTerm(term);
  }

  Future<void> deletePaymentTerm(String termId, String expenseId) async {
    await db.deletePaymentTerm(termId, expenseId);
  }

  Future<void> recordPayment({
    required WeddingExpense expense,
    required String termName,
    required double amount,
    required int dueDate,
  }) async {
    final term = WeddingPaymentTerm(
      termId: UuidUtils.generateId(),
      expenseId: expense.expenseId,
      termName: termName,
      amount: amount,
      dueDate: dueDate,
      isPaid: true,
      paidDate: DateTime.now().millisecondsSinceEpoch,
    );

    final newPaid = expense.totalPaid + amount;
    final status = (newPaid >= expense.totalEstimated && expense.totalEstimated > 0)
        ? 'FULLY_PAID'
        : (newPaid > 0 ? 'PARTIAL_DP' : 'UNPAID');

    await db.recordPaymentTx(
      term: term,
      expense: expense,
      newTotalPaid: newPaid,
      newPaymentStatus: status,
    );
    await sync.pushExpense(expense.copyWith(totalPaid: newPaid, paymentStatus: status));
  }

  Future<void> removePaymentTerm({
    required WeddingPaymentTerm term,
    required WeddingExpense expense,
  }) async {
    final newPaid = (expense.totalPaid - term.amount).clamp(0.0, double.infinity);
    final status = (newPaid >= expense.totalEstimated && expense.totalEstimated > 0)
        ? 'FULLY_PAID'
        : (newPaid > 0 ? 'PARTIAL_DP' : 'UNPAID');

    await db.removePaymentTermTx(
      termId: term.termId,
      expenseId: expense.expenseId,
      expense: expense,
      newTotalPaid: newPaid,
      newPaymentStatus: status,
    );
    await sync.pushExpense(expense.copyWith(totalPaid: newPaid, paymentStatus: status));
  }

  // ==================== EXPENSE PAGINATION ====================
  Future<List<WeddingExpense>> getExpensesPaginated(
    String profileId, {
    int limit = 20,
    int offset = 0,
    String? categoryFilter,
  }) =>
      db.getExpensesPaginated(profileId, limit: limit, offset: offset, categoryFilter: categoryFilter);

  Future<int> countExpenses(String profileId, {String? categoryFilter}) =>
      db.countExpenses(profileId, categoryFilter: categoryFilter);

  // ==================== GUESTS ====================
  Stream<List<WeddingGuest>> watchGuests(String profileId) => db.watchGuests(profileId);

  Future<List<WeddingGuest>> getGuestsPaginated(
    String profileId, {
    int limit = 20,
    int offset = 0,
    String? searchQuery,
    String? rsvpFilter,
  }) =>
      db.getGuestsPaginated(profileId, limit: limit, offset: offset, searchQuery: searchQuery, rsvpFilter: rsvpFilter);

  Future<int> countGuests(String profileId, {String? searchQuery, String? rsvpFilter}) =>
      db.countGuests(profileId, searchQuery: searchQuery, rsvpFilter: rsvpFilter);

  Future<void> createGuest(WeddingGuest guest) async {
    await db.insertGuest(guest);
  }

  Future<void> createGuestsBatch(List<WeddingGuest> guests) async {
    await db.insertGuestsBatch(guests);
  }

  Future<void> updateGuest(WeddingGuest guest) async {
    await db.updateGuest(guest);
  }

  Future<void> deleteGuest(String guestId) async {
    await db.deleteGuest(guestId);
  }

  // ==================== VENDORS ====================
  Stream<List<WeddingVendor>> watchVendors(String profileId) => db.watchVendors(profileId);

  Future<void> createVendor(WeddingVendor vendor) async {
    await db.insertVendor(vendor);
  }

  Future<void> updateVendor(WeddingVendor vendor) async {
    await db.updateVendor(vendor);
  }

  Future<void> deleteVendor(String vendorId) async {
    await db.deleteVendor(vendorId);
  }

  // ==================== TASKS ====================
  Stream<List<WeddingTask>> watchTasks(String profileId) => db.watchTasks(profileId);

  Future<void> createTask(WeddingTask task) async {
    await db.insertTask(task);
  }

  Future<void> toggleTaskCompletion(WeddingTask task, bool completed) async {
    final updated = task.copyWith(
      isCompleted: completed,
      completedDate: completed ? DateTime.now().millisecondsSinceEpoch : null,
    );
    await db.updateTask(updated);
  }

  Future<void> updateTask(WeddingTask task) async {
    await db.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    await db.deleteTask(taskId);
  }

  // ==================== COMMITTEE ====================
  Stream<List<WeddingCommitteeMember>> watchCommittee(String profileId) => db.watchCommittee(profileId);

  Future<void> createCommittee(WeddingCommitteeMember member) async {
    await db.insertCommittee(member);
  }

  Future<void> updateCommittee(WeddingCommitteeMember member) async {
    await db.updateCommittee(member);
  }

  Future<void> deleteCommittee(String memberId) async {
    await db.deleteCommittee(memberId);
  }

  // ==================== EVENTS & RUNDOWN ====================
  Stream<List<WeddingEvent>> watchEvents(String profileId) => db.watchEvents(profileId);

  Future<void> createEvent(WeddingEvent event) async {
    await db.insertEvent(event);
  }

  Future<void> updateEvent(WeddingEvent event) async {
    await db.updateEvent(event);
  }

  Future<void> deleteEvent(String eventId) async {
    await db.deleteEvent(eventId);
  }

  Stream<List<WeddingRundownItem>> watchRundownItems(String eventId) => db.watchRundownItems(eventId);

  Future<void> createRundownItem(WeddingRundownItem item) async {
    await db.insertRundownItem(item);
  }

  Future<void> updateRundownItem(WeddingRundownItem item) async {
    await db.updateRundownItem(item);
  }

  Future<void> deleteRundownItem(String itemId) async {
    await db.deleteRundownItem(itemId);
  }

  // ==================== SESERAHAN ====================
  Stream<List<WeddingSeserahan>> watchSeserahan(String profileId) => db.watchSeserahan(profileId);

  Future<void> createSeserahan(WeddingSeserahan item) async {
    await db.insertSeserahan(item);
  }

  Future<void> updateSeserahan(WeddingSeserahan item) async {
    await db.updateSeserahan(item);
  }

  Future<void> deleteSeserahan(String itemId) async {
    await db.deleteSeserahan(itemId);
  }

  // ==================== DOCUMENTS ====================
  Stream<List<WeddingDocument>> watchDocuments(String profileId) => db.watchDocuments(profileId);

  Future<void> createDocument(WeddingDocument doc) async {
    await db.insertDocument(doc);
  }

  Future<void> toggleDocumentCompletion(WeddingDocument doc, bool completed) async {
    final updated = doc.copyWith(isCompleted: completed);
    await db.updateDocument(updated);
  }

  Future<void> updateDocument(WeddingDocument doc) async {
    await db.updateDocument(doc);
  }

  Future<void> deleteDocument(String docId) async {
    await db.deleteDocument(docId);
  }

  // ==================== BACKUP & RESTORE ====================
  Future<Map<String, dynamic>> exportFullBackup(String profileId) => db.exportFullBackup(profileId);

  Future<void> restoreFullBackup(Map<String, dynamic> backupData) async {
    await db.restoreFullBackup(backupData);
    final profileMap = backupData['profile'] as Map<String, dynamic>?;
    if (profileMap != null && profileMap['id'] != null) {
      final profile = WeddingProfile.fromFirestoreMap(profileMap, profileMap['id'] as String);
      await sync.pushProfile(profile);
    }
  }
}
