import '../local/database.dart';
import '../../domain/models/wedding_models.dart';
import 'firestore_rest_service.dart';

class SyncManager {
  final AppDatabase db;
  final FirestoreRestService firestore;
  String? userId;
  String? idToken;
  bool isSyncEnabled;

  SyncManager({
    required this.db,
    required this.firestore,
    this.userId,
    this.idToken,
    this.isSyncEnabled = false,
  });

  void configure({String? newUserId, String? newIdToken, bool? enabled}) {
    if (newUserId != null) userId = newUserId;
    if (newIdToken != null) idToken = newIdToken;
    if (enabled != null) isSyncEnabled = enabled;
  }

  /// 2-Phase Pull from Firestore to Drift Database
  Future<bool> pullAll() async {
    if (!isSyncEnabled || userId == null) return false;

    try {
      final userPath = 'users/$userId';

      // Phase 1: Parent Profiles first
      final remoteProfiles = await firestore.getCollection(
        collectionPath: '$userPath/wedding_profiles',
        idToken: idToken,
      );

      for (final raw in remoteProfiles) {
        final profile = WeddingProfile.fromFirestoreMap(raw, raw['id'] ?? '');
        await db.insertProfile(profile);
      }

      // Phase 2: Children collections in parallel
      await Future.wait([
        _pullExpenses(userPath),
        _pullGuests(userPath),
        _pullVendors(userPath),
        _pullTasks(userPath),
        _pullCommittee(userPath),
        _pullEventsAndRundown(userPath),
        _pullSeserahan(userPath),
        _pullDocuments(userPath),
      ]);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _pullExpenses(String userPath) async {
    final rawExpenses = await firestore.getCollection(
      collectionPath: '$userPath/wedding_expenses',
      idToken: idToken,
    );
    for (final raw in rawExpenses) {
      final id = raw['id'] ?? raw['expenseId'] ?? '';
      final expense = WeddingExpense.fromFirestoreMap(raw, id);
      await db.insertExpense(expense);
    }

    final rawTerms = await firestore.getCollection(
      collectionPath: '$userPath/wedding_payment_terms',
      idToken: idToken,
    );
    for (final raw in rawTerms) {
      final id = raw['id'] ?? raw['termId'] ?? '';
      final term = WeddingPaymentTerm.fromFirestoreMap(raw, id);
      await db.insertPaymentTerm(term);
    }
  }

  Future<void> _pullGuests(String userPath) async {
    final rawGuests = await firestore.getCollection(
      collectionPath: '$userPath/wedding_guests',
      idToken: idToken,
    );
    for (final raw in rawGuests) {
      final id = raw['id'] ?? raw['guestId'] ?? '';
      final guest = WeddingGuest.fromFirestoreMap(raw, id);
      await db.insertGuest(guest);
    }
  }

  Future<void> _pullVendors(String userPath) async {
    final rawVendors = await firestore.getCollection(
      collectionPath: '$userPath/wedding_vendors',
      idToken: idToken,
    );
    for (final raw in rawVendors) {
      final id = raw['id'] ?? raw['vendorId'] ?? '';
      final vendor = WeddingVendor.fromFirestoreMap(raw, id);
      await db.insertVendor(vendor);
    }
  }

  Future<void> _pullTasks(String userPath) async {
    final rawTasks = await firestore.getCollection(
      collectionPath: '$userPath/wedding_tasks',
      idToken: idToken,
    );
    for (final raw in rawTasks) {
      final id = raw['id'] ?? raw['taskId'] ?? '';
      final task = WeddingTask.fromFirestoreMap(raw, id);
      await db.insertTask(task);
    }
  }

  Future<void> _pullCommittee(String userPath) async {
    final rawCommittee = await firestore.getCollection(
      collectionPath: '$userPath/wedding_committee',
      idToken: idToken,
    );
    for (final raw in rawCommittee) {
      final id = raw['id'] ?? raw['memberId'] ?? '';
      final member = WeddingCommitteeMember.fromFirestoreMap(raw, id);
      await db.insertCommittee(member);
    }
  }

  Future<void> _pullEventsAndRundown(String userPath) async {
    final rawEvents = await firestore.getCollection(
      collectionPath: '$userPath/wedding_events',
      idToken: idToken,
    );
    for (final raw in rawEvents) {
      final id = raw['id'] ?? raw['eventId'] ?? '';
      final event = WeddingEvent.fromFirestoreMap(raw, id);
      await db.insertEvent(event);
    }

    final rawItems = await firestore.getCollection(
      collectionPath: '$userPath/wedding_rundown_items',
      idToken: idToken,
    );
    for (final raw in rawItems) {
      final id = raw['id'] ?? raw['itemId'] ?? '';
      final item = WeddingRundownItem.fromFirestoreMap(raw, id);
      await db.insertRundownItem(item);
    }
  }

  Future<void> _pullSeserahan(String userPath) async {
    final rawSeserahan = await firestore.getCollection(
      collectionPath: '$userPath/wedding_seserahan',
      idToken: idToken,
    );
    for (final raw in rawSeserahan) {
      final id = raw['id'] ?? raw['itemId'] ?? '';
      final item = WeddingSeserahan.fromFirestoreMap(raw, id);
      await db.insertSeserahan(item);
    }
  }

  Future<void> _pullDocuments(String userPath) async {
    final rawDocs = await firestore.getCollection(
      collectionPath: '$userPath/wedding_documents',
      idToken: idToken,
    );
    for (final raw in rawDocs) {
      final id = raw['id'] ?? raw['docId'] ?? '';
      final doc = WeddingDocument.fromFirestoreMap(raw, id);
      await db.insertDocument(doc);
    }
  }

  // Push single items
  Future<void> pushProfile(WeddingProfile p) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_profiles/${p.id}',
      data: p.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteProfile(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_profiles/$id',
      idToken: idToken,
    );
  }

  Future<void> pushExpense(WeddingExpense e) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_expenses/${e.expenseId}',
      data: e.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteExpense(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_expenses/$id',
      idToken: idToken,
    );
  }
}
