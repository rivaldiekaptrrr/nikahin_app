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

  /// Push all local database items for a profile up to Firestore Cloud
  Future<bool> pushAll(String profileId) async {
    if (!isSyncEnabled || userId == null) return false;

    try {
      final profile = await db.getProfileById(profileId);
      if (profile != null) {
        await pushProfile(profile);
      }

      final expenses = await db.watchExpenses(profileId).first;
      for (final e in expenses) {
        await pushExpense(e);
        final terms = await db.getPaymentTermsForExpense(e.expenseId);
        for (final t in terms) {
          await pushPaymentTerm(t);
        }
      }

      final guests = await db.watchGuests(profileId).first;
      for (final g in guests) {
        await pushGuest(g);
      }

      final vendors = await db.watchVendors(profileId).first;
      for (final v in vendors) {
        await pushVendor(v);
      }

      final tasks = await db.watchTasks(profileId).first;
      for (final t in tasks) {
        await pushTask(t);
      }

      final committee = await db.watchCommittee(profileId).first;
      for (final m in committee) {
        await pushCommittee(m);
      }

      final events = await db.watchEvents(profileId).first;
      for (final ev in events) {
        await pushEvent(ev);
        final items = await db.watchRundownItems(ev.eventId).first;
        for (final item in items) {
          await pushRundownItem(item);
        }
      }

      final seserahan = await db.watchSeserahan(profileId).first;
      for (final s in seserahan) {
        await pushSeserahan(s);
      }

      final documents = await db.watchDocuments(profileId).first;
      for (final d in documents) {
        await pushDocument(d);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  // ==================== PULL HELPER METHODS ====================

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

  // ==================== PUSH & DELETE REMOTE METHODS ====================

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

  Future<void> pushPaymentTerm(WeddingPaymentTerm t) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_payment_terms/${t.termId}',
      data: t.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemotePaymentTerm(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_payment_terms/$id',
      idToken: idToken,
    );
  }

  Future<void> pushGuest(WeddingGuest g) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_guests/${g.guestId}',
      data: g.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteGuest(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_guests/$id',
      idToken: idToken,
    );
  }

  Future<void> pushVendor(WeddingVendor v) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_vendors/${v.vendorId}',
      data: v.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteVendor(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_vendors/$id',
      idToken: idToken,
    );
  }

  Future<void> pushTask(WeddingTask t) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_tasks/${t.taskId}',
      data: t.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteTask(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_tasks/$id',
      idToken: idToken,
    );
  }

  Future<void> pushCommittee(WeddingCommitteeMember m) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_committee/${m.memberId}',
      data: m.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteCommittee(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_committee/$id',
      idToken: idToken,
    );
  }

  Future<void> pushEvent(WeddingEvent e) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_events/${e.eventId}',
      data: e.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteEvent(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_events/$id',
      idToken: idToken,
    );
  }

  Future<void> pushRundownItem(WeddingRundownItem item) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_rundown_items/${item.itemId}',
      data: item.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteRundownItem(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_rundown_items/$id',
      idToken: idToken,
    );
  }

  Future<void> pushSeserahan(WeddingSeserahan s) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_seserahan/${s.itemId}',
      data: s.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteSeserahan(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_seserahan/$id',
      idToken: idToken,
    );
  }

  Future<void> pushDocument(WeddingDocument d) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.putDocument(
      path: 'users/$userId/wedding_documents/${d.docId}',
      data: d.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteDocument(String id) async {
    if (!isSyncEnabled || userId == null) return;
    await firestore.deleteDocument(
      path: 'users/$userId/wedding_documents/$id',
      idToken: idToken,
    );
  }
}
