import '../local/database.dart';
import '../../domain/models/wedding_models.dart';
import 'firestore_rest_service.dart';

class SyncManager {
  final AppDatabase db;
  final FirestoreRestService firestore;
  String? userId;
  String? activeWeddingId;
  String? idToken;
  bool isSyncEnabled;

  SyncManager({
    required this.db,
    required this.firestore,
    this.userId,
    this.activeWeddingId,
    this.idToken,
    this.isSyncEnabled = false,
  });

  /// Path dasar sinkronisasi (shared wedding workspace jika ada, atau fallback ke user single workspace)
  String get syncBasePath {
    if (activeWeddingId != null && activeWeddingId!.isNotEmpty) {
      return 'weddings/$activeWeddingId';
    }
    return 'users/$userId';
  }

  void configure({
    String? newUserId,
    String? newActiveWeddingId,
    String? newIdToken,
    bool? enabled,
  }) {
    if (newUserId != null) userId = newUserId;
    if (newActiveWeddingId != null) activeWeddingId = newActiveWeddingId;
    if (newIdToken != null) idToken = newIdToken;
    if (enabled != null) isSyncEnabled = enabled;
  }

  /// 2-Phase Pull from Firestore to Drift Database with Atomic SQLite Transaction
  Future<bool> pullAll({void Function()? onSyncComplete}) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return false;

    try {
      final basePath = syncBasePath;

      // Phase 1: Fetch remote collections in parallel into in-memory lists
      final results = await Future.wait([
        firestore.getCollection(collectionPath: '$basePath/wedding_profiles', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_expenses', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_payment_terms', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_guests', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_vendors', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_tasks', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_committee', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_events', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_rundown_items', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_seserahan', idToken: idToken),
        firestore.getCollection(collectionPath: '$basePath/wedding_documents', idToken: idToken),
      ]);

      final remoteProfiles = results[0];
      final remoteExpenses = results[1];
      final remoteTerms = results[2];
      final remoteGuests = results[3];
      final remoteVendors = results[4];
      final remoteTasks = results[5];
      final remoteCommittee = results[6];
      final remoteEvents = results[7];
      final remoteRundown = results[8];
      final remoteSeserahan = results[9];
      final remoteDocs = results[10];

      // Phase 2: Atomic SQLite Transaction via Drift
      // Wrapping all database writes inside a transaction guarantees database integrity
      await db.transaction(() async {
        if (remoteProfiles.isNotEmpty) {
          for (final raw in remoteProfiles) {
            final profile = WeddingProfile.fromFirestoreMap(raw, raw['id'] ?? '');
            await db.insertProfile(profile);
          }
        } else if (activeWeddingId != null && activeWeddingId!.isNotEmpty) {
          final parentDoc = await firestore.getDocument(path: 'weddings/$activeWeddingId', idToken: idToken);
          if (parentDoc != null && (parentDoc['groomName'] != null || parentDoc['brideName'] != null)) {
            final fallbackProfile = WeddingProfile.fromFirestoreMap(parentDoc, activeWeddingId!);
            await db.insertProfile(fallbackProfile);
          }
        }

        for (final raw in remoteExpenses) {
          final id = raw['id'] ?? raw['expenseId'] ?? '';
          final expense = WeddingExpense.fromFirestoreMap(raw, id);
          await db.insertExpense(expense);
        }

        for (final raw in remoteTerms) {
          final id = raw['id'] ?? raw['termId'] ?? '';
          final term = WeddingPaymentTerm.fromFirestoreMap(raw, id);
          await db.insertPaymentTerm(term);
        }

        for (final raw in remoteGuests) {
          final id = raw['id'] ?? raw['guestId'] ?? '';
          final guest = WeddingGuest.fromFirestoreMap(raw, id);
          await db.insertGuest(guest);
        }

        for (final raw in remoteVendors) {
          final id = raw['id'] ?? raw['vendorId'] ?? '';
          final vendor = WeddingVendor.fromFirestoreMap(raw, id);
          await db.insertVendor(vendor);
        }

        for (final raw in remoteTasks) {
          final id = raw['id'] ?? raw['taskId'] ?? '';
          final task = WeddingTask.fromFirestoreMap(raw, id);
          await db.insertTask(task);
        }

        for (final raw in remoteCommittee) {
          final id = raw['id'] ?? raw['memberId'] ?? '';
          final member = WeddingCommitteeMember.fromFirestoreMap(raw, id);
          await db.insertCommittee(member);
        }

        for (final raw in remoteEvents) {
          final id = raw['id'] ?? raw['eventId'] ?? '';
          final event = WeddingEvent.fromFirestoreMap(raw, id);
          await db.insertEvent(event);
        }

        for (final raw in remoteRundown) {
          final id = raw['id'] ?? raw['itemId'] ?? '';
          final item = WeddingRundownItem.fromFirestoreMap(raw, id);
          await db.insertRundownItem(item);
        }

        for (final raw in remoteSeserahan) {
          final id = raw['id'] ?? raw['itemId'] ?? '';
          final item = WeddingSeserahan.fromFirestoreMap(raw, id);
          await db.insertSeserahan(item);
        }

        for (final raw in remoteDocs) {
          final id = raw['id'] ?? raw['docId'] ?? '';
          final doc = WeddingDocument.fromFirestoreMap(raw, id);
          await db.insertDocument(doc);
        }
      });

      onSyncComplete?.call();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Push all local database items for a profile up to Firestore Cloud
  Future<bool> pushAll(String profileId) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return false;

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

  /// Mengunggah seluruh data dari workspace lokal/legacy pengguna ke shared workspace (weddings/$weddingId)
  Future<bool> upliftLocalAndLegacyDataToSharedWorkspace(String targetWeddingId) async {
    activeWeddingId = targetWeddingId;
    final profiles = await db.getAllProfiles();
    for (final p in profiles) {
      await pushAll(p.id);
    }
    return true;
  }

  // ==================== PUSH & DELETE REMOTE METHODS ====================

  Future<void> pushProfile(WeddingProfile p) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_profiles/${p.id}',
      data: p.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteProfile(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_profiles/$id',
      idToken: idToken,
    );
  }

  Future<void> pushExpense(WeddingExpense e) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_expenses/${e.expenseId}',
      data: e.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteExpense(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_expenses/$id',
      idToken: idToken,
    );
  }

  Future<void> pushPaymentTerm(WeddingPaymentTerm t) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_payment_terms/${t.termId}',
      data: t.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemotePaymentTerm(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_payment_terms/$id',
      idToken: idToken,
    );
  }

  Future<void> pushGuest(WeddingGuest g) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_guests/${g.guestId}',
      data: g.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteGuest(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_guests/$id',
      idToken: idToken,
    );
  }

  Future<void> pushVendor(WeddingVendor v) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_vendors/${v.vendorId}',
      data: v.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteVendor(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_vendors/$id',
      idToken: idToken,
    );
  }

  Future<void> pushTask(WeddingTask t) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_tasks/${t.taskId}',
      data: t.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteTask(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_tasks/$id',
      idToken: idToken,
    );
  }

  Future<void> pushCommittee(WeddingCommitteeMember m) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_committee/${m.memberId}',
      data: m.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteCommittee(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_committee/$id',
      idToken: idToken,
    );
  }

  Future<void> pushEvent(WeddingEvent e) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_events/${e.eventId}',
      data: e.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteEvent(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_events/$id',
      idToken: idToken,
    );
  }

  Future<void> pushRundownItem(WeddingRundownItem item) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_rundown_items/${item.itemId}',
      data: item.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteRundownItem(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_rundown_items/$id',
      idToken: idToken,
    );
  }

  Future<void> pushSeserahan(WeddingSeserahan s) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_seserahan/${s.itemId}',
      data: s.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteSeserahan(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_seserahan/$id',
      idToken: idToken,
    );
  }

  Future<void> pushDocument(WeddingDocument d) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.putDocument(
      path: '$syncBasePath/wedding_documents/${d.docId}',
      data: d.toFirestoreMap(),
      idToken: idToken,
    );
  }

  Future<void> deleteRemoteDocument(String id) async {
    if (!isSyncEnabled || (userId == null && activeWeddingId == null)) return;
    await firestore.deleteDocument(
      path: '$syncBasePath/wedding_documents/$id',
      idToken: idToken,
    );
  }
}
