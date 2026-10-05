import 'package:drift/drift.dart';

import '../../domain/models/wedding_models.dart';
import 'connection/connection.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  WeddingProfiles,
  WeddingExpenses,
  WeddingPaymentTerms,
  WeddingGuests,
  WeddingVendors,
  WeddingTasks,
  WeddingCommitteeMembers,
  WeddingEvents,
  WeddingRundownItems,
  WeddingSeserahans,
  WeddingDocuments,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // 1. Enable foreign keys cascade support (Data Consistency & Referential Integrity)
          await customStatement('PRAGMA foreign_keys = ON;');

          // 2. High-performance Indexing on Foreign Keys & frequent query filter columns
          await customStatement('CREATE INDEX IF NOT EXISTS idx_expenses_profile ON wedding_expenses(wedding_profile_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_payment_terms_expense ON wedding_payment_terms(expense_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_guests_profile ON wedding_guests(wedding_profile_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_guests_rsvp ON wedding_guests(rsvp_status);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_vendors_profile ON wedding_vendors(wedding_profile_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_tasks_profile ON wedding_tasks(wedding_profile_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_committee_profile ON wedding_committee_members(wedding_profile_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_events_profile ON wedding_events(wedding_profile_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_rundown_event ON wedding_rundown_items(event_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_seserahan_profile ON wedding_seserahans(wedding_profile_id);');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_docs_profile ON wedding_documents(wedding_profile_id);');
        },
        onCreate: (m) async {
          await m.createAll();
        },
      );

  // ==========================================
  // WEDDING PROFILES
  // ==========================================
  Stream<List<WeddingProfile>> watchAllProfiles() {
    return select(weddingProfiles).watch().map(
          (rows) => rows.map((r) => _profileFromRow(r)).toList(),
        );
  }

  Stream<WeddingProfile?> watchSingleProfile() {
    return (select(weddingProfiles)..limit(1)).watchSingleOrNull().map(
          (row) => row != null ? _profileFromRow(row) : null,
        );
  }

  Future<WeddingProfile?> getSingleProfile() async {
    final row = await (select(weddingProfiles)..limit(1)).getSingleOrNull();
    return row != null ? _profileFromRow(row) : null;
  }

  Future<WeddingProfile?> getProfileById(String id) async {
    final row = await (select(weddingProfiles)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _profileFromRow(row) : null;
  }

  Future<void> insertProfile(WeddingProfile p) async {
    await into(weddingProfiles).insertOnConflictUpdate(
      WeddingProfilesCompanion.insert(
        id: p.id,
        groomName: p.groomName,
        brideName: p.brideName,
        weddingDate: p.weddingDate,
        totalBudgetCap: Value(p.totalBudgetCap),
        religionType: Value(p.religionType),
        religionDetail: Value(p.religionDetail),
        culturalPresetGroom: Value(p.culturalPresetGroom),
        culturalPresetBride: Value(p.culturalPresetBride),
        quote: Value(p.quote),
        quoteEnabled: Value(p.quoteEnabled),
        quoteFontSize: Value(p.quoteFontSize),
        quoteFontStyle: Value(p.quoteFontStyle),
        createdAt: p.createdAt,
      ),
    );
  }

  Future<void> updateProfile(WeddingProfile p) async {
    await update(weddingProfiles).replace(
      WeddingProfileTableData(
        id: p.id,
        groomName: p.groomName,
        brideName: p.brideName,
        weddingDate: p.weddingDate,
        totalBudgetCap: p.totalBudgetCap,
        religionType: p.religionType,
        religionDetail: p.religionDetail,
        culturalPresetGroom: p.culturalPresetGroom,
        culturalPresetBride: p.culturalPresetBride,
        quote: p.quote,
        quoteEnabled: p.quoteEnabled,
        quoteFontSize: p.quoteFontSize,
        quoteFontStyle: p.quoteFontStyle,
        createdAt: p.createdAt,
      ),
    );
  }

  Future<void> deleteProfile(String id) async {
    await (delete(weddingProfiles)..where((t) => t.id.equals(id))).go();
  }

  WeddingProfile _profileFromRow(WeddingProfileTableData r) {
    return WeddingProfile(
      id: r.id,
      groomName: r.groomName,
      brideName: r.brideName,
      weddingDate: r.weddingDate,
      totalBudgetCap: r.totalBudgetCap,
      religionType: r.religionType,
      religionDetail: r.religionDetail,
      culturalPresetGroom: r.culturalPresetGroom,
      culturalPresetBride: r.culturalPresetBride,
      quote: r.quote,
      quoteEnabled: r.quoteEnabled,
      quoteFontSize: r.quoteFontSize,
      quoteFontStyle: r.quoteFontStyle,
      createdAt: r.createdAt,
    );
  }

  // ==========================================
  // WEDDING EXPENSES & PAYMENT TERMS
  // ==========================================
  Stream<List<WeddingExpense>> watchExpenses(String profileId) {
    return (select(weddingExpenses)
          ..where((t) => t.weddingProfileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((r) => _expenseFromRow(r)).toList());
  }

  Future<WeddingExpense?> getExpenseById(String expenseId) async {
    final row = await (select(weddingExpenses)..where((t) => t.expenseId.equals(expenseId))).getSingleOrNull();
    return row != null ? _expenseFromRow(row) : null;
  }

  Future<void> insertExpense(WeddingExpense e) async {
    await into(weddingExpenses).insertOnConflictUpdate(
      WeddingExpensesCompanion.insert(
        expenseId: e.expenseId,
        weddingProfileId: e.weddingProfileId,
        category: e.category,
        title: e.title,
        totalEstimated: Value(e.totalEstimated),
        totalPaid: Value(e.totalPaid),
        paidBySource: Value(e.paidBySource),
        paymentStatus: Value(e.paymentStatus),
        notes: Value(e.notes),
        createdAt: e.createdAt,
      ),
    );
  }

  Future<void> updateExpense(WeddingExpense e) async {
    await update(weddingExpenses).replace(
      WeddingExpenseTableData(
        expenseId: e.expenseId,
        weddingProfileId: e.weddingProfileId,
        category: e.category,
        title: e.title,
        totalEstimated: e.totalEstimated,
        totalPaid: e.totalPaid,
        paidBySource: e.paidBySource,
        paymentStatus: e.paymentStatus,
        notes: e.notes,
        createdAt: e.createdAt,
      ),
    );
  }

  Future<void> deleteExpense(String expenseId) async {
    await (delete(weddingExpenses)..where((t) => t.expenseId.equals(expenseId))).go();
  }

  Stream<List<WeddingPaymentTerm>> watchPaymentTerms(String expenseId) {
    return (select(weddingPaymentTerms)
          ..where((t) => t.expenseId.equals(expenseId))
          ..orderBy([(t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.asc)]))
        .watch()
        .map((rows) => rows.map((r) => _paymentTermFromRow(r)).toList());
  }

  Future<List<WeddingPaymentTerm>> getPaymentTermsForExpense(String expenseId) async {
    final rows = await (select(weddingPaymentTerms)
          ..where((t) => t.expenseId.equals(expenseId))
          ..orderBy([(t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.asc)]))
        .get();
    return rows.map((r) => _paymentTermFromRow(r)).toList();
  }

  Future<void> insertPaymentTerm(WeddingPaymentTerm term) async {
    await into(weddingPaymentTerms).insertOnConflictUpdate(
      WeddingPaymentTermsCompanion.insert(
        termId: term.termId,
        expenseId: term.expenseId,
        termName: term.termName,
        amount: term.amount,
        dueDate: term.dueDate,
        isPaid: Value(term.isPaid),
        paidDate: Value(term.paidDate),
      ),
    );
    await _recalculateExpensePaid(term.expenseId);
  }

  Future<void> updatePaymentTerm(WeddingPaymentTerm term) async {
    await update(weddingPaymentTerms).replace(
      WeddingPaymentTermTableData(
        termId: term.termId,
        expenseId: term.expenseId,
        termName: term.termName,
        amount: term.amount,
        dueDate: term.dueDate,
        isPaid: term.isPaid,
        paidDate: term.paidDate,
      ),
    );
    await _recalculateExpensePaid(term.expenseId);
  }

  Future<void> deletePaymentTerm(String termId, String expenseId) async {
    await (delete(weddingPaymentTerms)..where((t) => t.termId.equals(termId))).go();
    await _recalculateExpensePaid(expenseId);
  }

  Future<void> _recalculateExpensePaid(String expenseId) async {
    final terms = await getPaymentTermsForExpense(expenseId);
    final totalPaid = terms.where((t) => t.isPaid).fold(0.0, (acc, t) => acc + t.amount);
    final expense = await getExpenseById(expenseId);
    if (expense != null) {
      String status = 'UNPAID';
      if (totalPaid >= expense.totalEstimated && expense.totalEstimated > 0) {
        status = 'FULLY_PAID';
      } else if (totalPaid > 0) {
        status = 'PARTIAL_DP';
      }
      await updateExpense(expense.copyWith(
        totalPaid: totalPaid,
        paymentStatus: status,
      ));
    }
  }

  WeddingExpense _expenseFromRow(WeddingExpenseTableData r) {
    return WeddingExpense(
      expenseId: r.expenseId,
      weddingProfileId: r.weddingProfileId,
      category: r.category,
      title: r.title,
      totalEstimated: r.totalEstimated,
      totalPaid: r.totalPaid,
      paidBySource: r.paidBySource,
      paymentStatus: r.paymentStatus,
      notes: r.notes,
      createdAt: r.createdAt,
    );
  }

  WeddingPaymentTerm _paymentTermFromRow(WeddingPaymentTermTableData r) {
    return WeddingPaymentTerm(
      termId: r.termId,
      expenseId: r.expenseId,
      termName: r.termName,
      amount: r.amount,
      dueDate: r.dueDate,
      isPaid: r.isPaid,
      paidDate: r.paidDate,
    );
  }

  // ==========================================
  // WEDDING GUESTS
  // ==========================================
  Stream<List<WeddingGuest>> watchGuests(String profileId) {
    return (select(weddingGuests)
          ..where((t) => t.weddingProfileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm(expression: t.guestName, mode: OrderingMode.asc)]))
        .watch()
        .map((rows) => rows.map((r) => _guestFromRow(r)).toList());
  }

  Future<void> insertGuest(WeddingGuest g) async {
    await into(weddingGuests).insertOnConflictUpdate(
      WeddingGuestsCompanion.insert(
        guestId: g.guestId,
        weddingProfileId: g.weddingProfileId,
        guestName: g.guestName,
        phoneNumber: Value(g.phoneNumber),
        groupAllocation: Value(g.groupAllocation),
        sessionTarget: Value(g.sessionTarget),
        estimatedPax: Value(g.estimatedPax),
        rsvpStatus: Value(g.rsvpStatus),
      ),
    );
  }

  Future<void> insertGuestsBatch(List<WeddingGuest> list) async {
    await batch((b) {
      for (final g in list) {
        b.insert(
          weddingGuests,
          WeddingGuestsCompanion.insert(
            guestId: g.guestId,
            weddingProfileId: g.weddingProfileId,
            guestName: g.guestName,
            phoneNumber: Value(g.phoneNumber),
            groupAllocation: Value(g.groupAllocation),
            sessionTarget: Value(g.sessionTarget),
            estimatedPax: Value(g.estimatedPax),
            rsvpStatus: Value(g.rsvpStatus),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> updateGuest(WeddingGuest g) async {
    await update(weddingGuests).replace(
      WeddingGuestTableData(
        guestId: g.guestId,
        weddingProfileId: g.weddingProfileId,
        guestName: g.guestName,
        phoneNumber: g.phoneNumber,
        groupAllocation: g.groupAllocation,
        sessionTarget: g.sessionTarget,
        estimatedPax: g.estimatedPax,
        rsvpStatus: g.rsvpStatus,
      ),
    );
  }

  Future<void> deleteGuest(String guestId) async {
    await (delete(weddingGuests)..where((t) => t.guestId.equals(guestId))).go();
  }

  WeddingGuest _guestFromRow(WeddingGuestTableData r) {
    return WeddingGuest(
      guestId: r.guestId,
      weddingProfileId: r.weddingProfileId,
      guestName: r.guestName,
      phoneNumber: r.phoneNumber,
      groupAllocation: r.groupAllocation,
      sessionTarget: r.sessionTarget,
      estimatedPax: r.estimatedPax,
      rsvpStatus: r.rsvpStatus,
    );
  }

  // ==========================================
  // WEDDING VENDORS
  // ==========================================
  Stream<List<WeddingVendor>> watchVendors(String profileId) {
    return (select(weddingVendors)
          ..where((t) => t.weddingProfileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((r) => _vendorFromRow(r)).toList());
  }

  Future<void> insertVendor(WeddingVendor v) async {
    await into(weddingVendors).insertOnConflictUpdate(
      WeddingVendorsCompanion.insert(
        vendorId: v.vendorId,
        weddingProfileId: v.weddingProfileId,
        category: v.category,
        name: v.name,
        picName: Value(v.picName),
        phoneNumber: Value(v.phoneNumber),
        instagramHandle: Value(v.instagramHandle),
        contractValue: Value(v.contractValue),
        notes: Value(v.notes),
        status: Value(v.status),
        createdAt: v.createdAt,
      ),
    );
  }

  Future<void> updateVendor(WeddingVendor v) async {
    await update(weddingVendors).replace(
      WeddingVendorTableData(
        vendorId: v.vendorId,
        weddingProfileId: v.weddingProfileId,
        category: v.category,
        name: v.name,
        picName: v.picName,
        phoneNumber: v.phoneNumber,
        instagramHandle: v.instagramHandle,
        contractValue: v.contractValue,
        notes: v.notes,
        status: v.status,
        createdAt: v.createdAt,
      ),
    );
  }

  Future<void> deleteVendor(String vendorId) async {
    await (delete(weddingVendors)..where((t) => t.vendorId.equals(vendorId))).go();
  }

  WeddingVendor _vendorFromRow(WeddingVendorTableData r) {
    return WeddingVendor(
      vendorId: r.vendorId,
      weddingProfileId: r.weddingProfileId,
      category: r.category,
      name: r.name,
      picName: r.picName,
      phoneNumber: r.phoneNumber,
      instagramHandle: r.instagramHandle,
      contractValue: r.contractValue,
      notes: r.notes,
      status: r.status,
      createdAt: r.createdAt,
    );
  }

  // ==========================================
  // WEDDING TASKS
  // ==========================================
  Stream<List<WeddingTask>> watchTasks(String profileId) {
    return (select(weddingTasks)
          ..where((t) => t.weddingProfileId.equals(profileId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.phaseMonth, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
          ]))
        .watch()
        .map((rows) => rows.map((r) => _taskFromRow(r)).toList());
  }

  Future<void> insertTask(WeddingTask t) async {
    await into(weddingTasks).insertOnConflictUpdate(
      WeddingTasksCompanion.insert(
        taskId: t.taskId,
        weddingProfileId: t.weddingProfileId,
        phaseMonth: t.phaseMonth,
        title: t.title,
        description: Value(t.description),
        pic: Value(t.pic),
        isCompleted: Value(t.isCompleted),
        dueDate: Value(t.dueDate),
        completedDate: Value(t.completedDate),
        sortOrder: Value(t.sortOrder),
      ),
    );
  }

  Future<void> insertTasksBatch(List<WeddingTask> list) async {
    await batch((b) {
      for (final t in list) {
        b.insert(
          weddingTasks,
          WeddingTasksCompanion.insert(
            taskId: t.taskId,
            weddingProfileId: t.weddingProfileId,
            phaseMonth: t.phaseMonth,
            title: t.title,
            description: Value(t.description),
            pic: Value(t.pic),
            isCompleted: Value(t.isCompleted),
            dueDate: Value(t.dueDate),
            completedDate: Value(t.completedDate),
            sortOrder: Value(t.sortOrder),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> updateTask(WeddingTask t) async {
    await update(weddingTasks).replace(
      WeddingTaskTableData(
        taskId: t.taskId,
        weddingProfileId: t.weddingProfileId,
        phaseMonth: t.phaseMonth,
        title: t.title,
        description: t.description,
        pic: t.pic,
        isCompleted: t.isCompleted,
        dueDate: t.dueDate,
        completedDate: t.completedDate,
        sortOrder: t.sortOrder,
      ),
    );
  }

  Future<void> deleteTask(String taskId) async {
    await (delete(weddingTasks)..where((t) => t.taskId.equals(taskId))).go();
  }

  WeddingTask _taskFromRow(WeddingTaskTableData r) {
    return WeddingTask(
      taskId: r.taskId,
      weddingProfileId: r.weddingProfileId,
      phaseMonth: r.phaseMonth,
      title: r.title,
      description: r.description,
      pic: r.pic,
      isCompleted: r.isCompleted,
      dueDate: r.dueDate,
      completedDate: r.completedDate,
      sortOrder: r.sortOrder,
    );
  }

  // ==========================================
  // WEDDING COMMITTEE
  // ==========================================
  Stream<List<WeddingCommitteeMember>> watchCommittee(String profileId) {
    return (select(weddingCommitteeMembers)
          ..where((t) => t.weddingProfileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc)]))
        .watch()
        .map((rows) => rows.map((r) => _committeeFromRow(r)).toList());
  }

  Future<void> insertCommittee(WeddingCommitteeMember c) async {
    await into(weddingCommitteeMembers).insertOnConflictUpdate(
      WeddingCommitteeMembersCompanion.insert(
        memberId: c.memberId,
        weddingProfileId: c.weddingProfileId,
        memberName: c.memberName,
        role: c.role,
        side: Value(c.side),
        phoneNumber: Value(c.phoneNumber),
        uniformDescription: Value(c.uniformDescription),
        fabricMeters: Value(c.fabricMeters),
        uniformStatus: Value(c.uniformStatus),
        sortOrder: Value(c.sortOrder),
      ),
    );
  }

  Future<void> updateCommittee(WeddingCommitteeMember c) async {
    await update(weddingCommitteeMembers).replace(
      WeddingCommitteeTableData(
        memberId: c.memberId,
        weddingProfileId: c.weddingProfileId,
        memberName: c.memberName,
        role: c.role,
        side: c.side,
        phoneNumber: c.phoneNumber,
        uniformDescription: c.uniformDescription,
        fabricMeters: c.fabricMeters,
        uniformStatus: c.uniformStatus,
        sortOrder: c.sortOrder,
      ),
    );
  }

  Future<void> deleteCommittee(String memberId) async {
    await (delete(weddingCommitteeMembers)..where((t) => t.memberId.equals(memberId))).go();
  }

  WeddingCommitteeMember _committeeFromRow(WeddingCommitteeTableData r) {
    return WeddingCommitteeMember(
      memberId: r.memberId,
      weddingProfileId: r.weddingProfileId,
      memberName: r.memberName,
      role: r.role,
      side: r.side,
      phoneNumber: r.phoneNumber,
      uniformDescription: r.uniformDescription,
      fabricMeters: r.fabricMeters,
      uniformStatus: r.uniformStatus,
      sortOrder: r.sortOrder,
    );
  }

  // ==========================================
  // WEDDING EVENTS & RUNDOWN ITEMS
  // ==========================================
  Stream<List<WeddingEvent>> watchEvents(String profileId) {
    return (select(weddingEvents)
          ..where((t) => t.weddingProfileId.equals(profileId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.eventDate, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
          ]))
        .watch()
        .map((rows) => rows.map((r) => _eventFromRow(r)).toList());
  }

  Future<void> insertEvent(WeddingEvent e) async {
    await into(weddingEvents).insertOnConflictUpdate(
      WeddingEventsCompanion.insert(
        eventId: e.eventId,
        weddingProfileId: e.weddingProfileId,
        eventName: e.eventName,
        eventDate: e.eventDate,
        eventLocation: Value(e.eventLocation),
        sortOrder: Value(e.sortOrder),
      ),
    );
  }

  Future<void> insertEventsBatch(List<WeddingEvent> list) async {
    await batch((b) {
      for (final e in list) {
        b.insert(
          weddingEvents,
          WeddingEventsCompanion.insert(
            eventId: e.eventId,
            weddingProfileId: e.weddingProfileId,
            eventName: e.eventName,
            eventDate: e.eventDate,
            eventLocation: Value(e.eventLocation),
            sortOrder: Value(e.sortOrder),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> updateEvent(WeddingEvent e) async {
    await update(weddingEvents).replace(
      WeddingEventTableData(
        eventId: e.eventId,
        weddingProfileId: e.weddingProfileId,
        eventName: e.eventName,
        eventDate: e.eventDate,
        eventLocation: e.eventLocation,
        sortOrder: e.sortOrder,
      ),
    );
  }

  Future<void> deleteEvent(String eventId) async {
    await (delete(weddingEvents)..where((t) => t.eventId.equals(eventId))).go();
  }

  Stream<List<WeddingRundownItem>> watchRundownItems(String eventId) {
    return (select(weddingRundownItems)
          ..where((t) => t.eventId.equals(eventId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.timeStart, mode: OrderingMode.asc),
          ]))
        .watch()
        .map((rows) => rows.map((r) => _rundownItemFromRow(r)).toList());
  }

  Future<List<WeddingRundownItem>> getRundownItemsForEvent(String eventId) async {
    final rows = await (select(weddingRundownItems)
          ..where((t) => t.eventId.equals(eventId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc)]))
        .get();
    return rows.map((r) => _rundownItemFromRow(r)).toList();
  }

  Future<void> insertRundownItem(WeddingRundownItem i) async {
    await into(weddingRundownItems).insertOnConflictUpdate(
      WeddingRundownItemsCompanion.insert(
        itemId: i.itemId,
        eventId: i.eventId,
        timeStart: Value(i.timeStart),
        durationMinutes: Value(i.durationMinutes),
        sessionTitle: i.sessionTitle,
        pic: Value(i.pic),
        mcScript: Value(i.mcScript),
        sortOrder: Value(i.sortOrder),
      ),
    );
  }

  Future<void> updateRundownItem(WeddingRundownItem i) async {
    await update(weddingRundownItems).replace(
      WeddingRundownItemTableData(
        itemId: i.itemId,
        eventId: i.eventId,
        timeStart: i.timeStart,
        durationMinutes: i.durationMinutes,
        sessionTitle: i.sessionTitle,
        pic: i.pic,
        mcScript: i.mcScript,
        sortOrder: i.sortOrder,
      ),
    );
  }

  Future<void> deleteRundownItem(String itemId) async {
    await (delete(weddingRundownItems)..where((t) => t.itemId.equals(itemId))).go();
  }

  WeddingEvent _eventFromRow(WeddingEventTableData r) {
    return WeddingEvent(
      eventId: r.eventId,
      weddingProfileId: r.weddingProfileId,
      eventName: r.eventName,
      eventDate: r.eventDate,
      eventLocation: r.eventLocation,
      sortOrder: r.sortOrder,
    );
  }

  WeddingRundownItem _rundownItemFromRow(WeddingRundownItemTableData r) {
    return WeddingRundownItem(
      itemId: r.itemId,
      eventId: r.eventId,
      timeStart: r.timeStart,
      durationMinutes: r.durationMinutes,
      sessionTitle: r.sessionTitle,
      pic: r.pic,
      mcScript: r.mcScript,
      sortOrder: r.sortOrder,
    );
  }

  // ==========================================
  // WEDDING SESERAHAN
  // ==========================================
  Stream<List<WeddingSeserahan>> watchSeserahan(String profileId) {
    return (select(weddingSeserahans)
          ..where((t) => t.weddingProfileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc)]))
        .watch()
        .map((rows) => rows.map((r) => _seserahanFromRow(r)).toList());
  }

  Future<void> insertSeserahan(WeddingSeserahan s) async {
    await into(weddingSeserahans).insertOnConflictUpdate(
      WeddingSeserahansCompanion.insert(
        itemId: s.itemId,
        weddingProfileId: s.weddingProfileId,
        direction: Value(s.direction),
        itemName: s.itemName,
        quantity: Value(s.quantity),
        estimatedPrice: Value(s.estimatedPrice),
        status: Value(s.status),
        notes: Value(s.notes),
        sortOrder: Value(s.sortOrder),
      ),
    );
  }

  Future<void> updateSeserahan(WeddingSeserahan s) async {
    await update(weddingSeserahans).replace(
      WeddingSeserahanTableData(
        itemId: s.itemId,
        weddingProfileId: s.weddingProfileId,
        direction: s.direction,
        itemName: s.itemName,
        quantity: s.quantity,
        estimatedPrice: s.estimatedPrice,
        status: s.status,
        notes: s.notes,
        sortOrder: s.sortOrder,
      ),
    );
  }

  Future<void> deleteSeserahan(String itemId) async {
    await (delete(weddingSeserahans)..where((t) => t.itemId.equals(itemId))).go();
  }

  WeddingSeserahan _seserahanFromRow(WeddingSeserahanTableData r) {
    return WeddingSeserahan(
      itemId: r.itemId,
      weddingProfileId: r.weddingProfileId,
      direction: r.direction,
      itemName: r.itemName,
      quantity: r.quantity,
      estimatedPrice: r.estimatedPrice,
      status: r.status,
      notes: r.notes,
      sortOrder: r.sortOrder,
    );
  }

  // ==========================================
  // WEDDING DOCUMENTS
  // ==========================================
  Stream<List<WeddingDocument>> watchDocuments(String profileId) {
    return (select(weddingDocuments)
          ..where((t) => t.weddingProfileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc)]))
        .watch()
        .map((rows) => rows.map((r) => _documentFromRow(r)).toList());
  }

  String? _encodeDocMeta(WeddingDocument d) {
    if (d.dueDate != null) {
      return 'DUE:${d.dueDate}|${d.localFilePath ?? ''}';
    }
    return d.localFilePath;
  }

  Future<void> insertDocument(WeddingDocument d) async {
    await into(weddingDocuments).insertOnConflictUpdate(
      WeddingDocumentsCompanion.insert(
        docId: d.docId,
        weddingProfileId: d.weddingProfileId,
        docName: d.docName,
        ownerType: Value(d.ownerType),
        isCompleted: Value(d.isCompleted),
        localFilePath: Value(_encodeDocMeta(d)),
        adminCost: Value(d.adminCost),
        sortOrder: Value(d.sortOrder),
      ),
    );
  }

  Future<void> insertDocumentsBatch(List<WeddingDocument> list) async {
    await batch((b) {
      for (final d in list) {
        b.insert(
          weddingDocuments,
          WeddingDocumentsCompanion.insert(
            docId: d.docId,
            weddingProfileId: d.weddingProfileId,
            docName: d.docName,
            ownerType: Value(d.ownerType),
            isCompleted: Value(d.isCompleted),
            localFilePath: Value(_encodeDocMeta(d)),
            adminCost: Value(d.adminCost),
            sortOrder: Value(d.sortOrder),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> updateDocument(WeddingDocument d) async {
    await update(weddingDocuments).replace(
      WeddingDocumentTableData(
        docId: d.docId,
        weddingProfileId: d.weddingProfileId,
        docName: d.docName,
        ownerType: d.ownerType,
        isCompleted: d.isCompleted,
        localFilePath: _encodeDocMeta(d),
        adminCost: d.adminCost,
        sortOrder: d.sortOrder,
      ),
    );
  }

  Future<void> deleteDocument(String docId) async {
    await (delete(weddingDocuments)..where((t) => t.docId.equals(docId))).go();
  }

  WeddingDocument _documentFromRow(WeddingDocumentTableData r) {
    int? parsedDueDate;
    String? rawPath = r.localFilePath;
    if (rawPath != null && rawPath.startsWith('DUE:')) {
      final parts = rawPath.split('|');
      parsedDueDate = int.tryParse(parts[0].replaceFirst('DUE:', ''));
      rawPath = parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null;
    }

    return WeddingDocument(
      docId: r.docId,
      weddingProfileId: r.weddingProfileId,
      docName: r.docName,
      ownerType: r.ownerType,
      isCompleted: r.isCompleted,
      localFilePath: rawPath,
      adminCost: r.adminCost,
      sortOrder: r.sortOrder,
      dueDate: parsedDueDate,
    );
  }

  // ==========================================
  // PAGINATION QUERIES
  // ==========================================
  Future<List<WeddingGuest>> getGuestsPaginated(
    String profileId, {
    int limit = 20,
    int offset = 0,
    String? searchQuery,
    String? rsvpFilter,
  }) async {
    final query = select(weddingGuests)
      ..where((t) => t.weddingProfileId.equals(profileId));

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query.where((t) => t.guestName.like('%${searchQuery.trim()}%'));
    }
    if (rsvpFilter != null && rsvpFilter.isNotEmpty && rsvpFilter != 'ALL') {
      query.where((t) => t.rsvpStatus.equals(rsvpFilter));
    }

    query
      ..orderBy([(t) => OrderingTerm(expression: t.guestName, mode: OrderingMode.asc)])
      ..limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map((r) => _guestFromRow(r)).toList();
  }

  Future<int> countGuests(
    String profileId, {
    String? searchQuery,
    String? rsvpFilter,
  }) async {
    final countExp = weddingGuests.guestId.count();
    final query = selectOnly(weddingGuests)
      ..where(weddingGuests.weddingProfileId.equals(profileId))
      ..addColumns([countExp]);

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query.where(weddingGuests.guestName.like('%${searchQuery.trim()}%'));
    }
    if (rsvpFilter != null && rsvpFilter.isNotEmpty && rsvpFilter != 'ALL') {
      query.where(weddingGuests.rsvpStatus.equals(rsvpFilter));
    }

    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<List<WeddingExpense>> getExpensesPaginated(
    String profileId, {
    int limit = 20,
    int offset = 0,
    String? categoryFilter,
  }) async {
    final query = select(weddingExpenses)
      ..where((t) => t.weddingProfileId.equals(profileId));

    if (categoryFilter != null && categoryFilter.isNotEmpty && categoryFilter != 'ALL') {
      query.where((t) => t.category.equals(categoryFilter));
    }

    query
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
      ..limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map((r) => _expenseFromRow(r)).toList();
  }

  Future<int> countExpenses(
    String profileId, {
    String? categoryFilter,
  }) async {
    final countExp = weddingExpenses.expenseId.count();
    final query = selectOnly(weddingExpenses)
      ..where(weddingExpenses.weddingProfileId.equals(profileId))
      ..addColumns([countExp]);

    if (categoryFilter != null && categoryFilter.isNotEmpty && categoryFilter != 'ALL') {
      query.where(weddingExpenses.category.equals(categoryFilter));
    }

    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  // ==========================================
  // TRANSACTION-SAFE OPERATIONS (ACID)
  // ==========================================
  Future<void> recordPaymentTx({
    required WeddingPaymentTerm term,
    required WeddingExpense expense,
    required double newTotalPaid,
    required String newPaymentStatus,
  }) async {
    await transaction(() async {
      await insertPaymentTerm(term);
      await updateExpense(expense.copyWith(
        totalPaid: newTotalPaid,
        paymentStatus: newPaymentStatus,
      ));
    });
  }

  Future<void> removePaymentTermTx({
    required String termId,
    required String expenseId,
    required WeddingExpense expense,
    required double newTotalPaid,
    required String newPaymentStatus,
  }) async {
    await transaction(() async {
      await (delete(weddingPaymentTerms)..where((t) => t.termId.equals(termId))).go();
      await updateExpense(expense.copyWith(
        totalPaid: newTotalPaid,
        paymentStatus: newPaymentStatus,
      ));
    });
  }

  // ==========================================
  // BACKUP & RESTORE (FULL DATABASE SERIALIZATION)
  // ==========================================
  Future<Map<String, dynamic>> exportFullBackup(String profileId) async {
    final profile = await getProfileById(profileId);
    if (profile == null) throw Exception('Profil $profileId tidak ditemukan');

    final expenses = (await (select(weddingExpenses)..where((t) => t.weddingProfileId.equals(profileId))).get())
        .map((r) => _expenseFromRow(r).toFirestoreMap())
        .toList();

    final allPaymentTerms = <Map<String, dynamic>>[];
    for (final exp in expenses) {
      final expId = exp['expenseId'] as String;
      final terms = await getPaymentTermsForExpense(expId);
      allPaymentTerms.addAll(terms.map((t) => t.toFirestoreMap()));
    }

    final guests = (await (select(weddingGuests)..where((t) => t.weddingProfileId.equals(profileId))).get())
        .map((r) => _guestFromRow(r).toFirestoreMap())
        .toList();

    final vendors = (await (select(weddingVendors)..where((t) => t.weddingProfileId.equals(profileId))).get())
        .map((r) => _vendorFromRow(r).toFirestoreMap())
        .toList();

    final tasks = (await (select(weddingTasks)..where((t) => t.weddingProfileId.equals(profileId))).get())
        .map((r) => _taskFromRow(r).toFirestoreMap())
        .toList();

    final committee = (await (select(weddingCommitteeMembers)..where((t) => t.weddingProfileId.equals(profileId))).get())
        .map((r) => _committeeFromRow(r).toFirestoreMap())
        .toList();

    final events = (await (select(weddingEvents)..where((t) => t.weddingProfileId.equals(profileId))).get())
        .map((r) => _eventFromRow(r).toFirestoreMap())
        .toList();

    final allRundowns = <Map<String, dynamic>>[];
    for (final ev in events) {
      final evId = ev['eventId'] as String;
      final items = (await (select(weddingRundownItems)..where((t) => t.eventId.equals(evId))).get())
          .map((r) => _rundownItemFromRow(r).toFirestoreMap());
      allRundowns.addAll(items);
    }

    final seserahan = (await (select(weddingSeserahans)..where((t) => t.weddingProfileId.equals(profileId))).get())
        .map((r) => _seserahanFromRow(r).toFirestoreMap())
        .toList();

    final documents = (await (select(weddingDocuments)..where((t) => t.weddingProfileId.equals(profileId))).get())
        .map((r) => _documentFromRow(r).toFirestoreMap())
        .toList();

    return {
      'format': 'NIKAHIN_BACKUP',
      'version': 1,
      'exportedAt': DateTime.now().millisecondsSinceEpoch,
      'profile': profile.toFirestoreMap(),
      'expenses': expenses,
      'paymentTerms': allPaymentTerms,
      'guests': guests,
      'vendors': vendors,
      'tasks': tasks,
      'committee': committee,
      'events': events,
      'rundownItems': allRundowns,
      'seserahan': seserahan,
      'documents': documents,
    };
  }

  Future<void> restoreFullBackup(Map<String, dynamic> backup) async {
    if (backup['format'] != 'NIKAHIN_BACKUP') {
      throw const FormatException('Format file cadangan tidak valid.');
    }

    final profileMap = backup['profile'] as Map<String, dynamic>?;
    if (profileMap == null) throw const FormatException('Data profil tidak ditemukan dalam cadangan.');
    final profileId = profileMap['id'] as String? ?? '';
    if (profileId.isEmpty) throw const FormatException('ID Profil tidak valid.');

    final profile = WeddingProfile.fromFirestoreMap(profileMap, profileId);

    final expenses = (backup['expenses'] as List<dynamic>? ?? [])
        .map((e) => WeddingExpense.fromFirestoreMap(Map<String, dynamic>.from(e as Map), e['expenseId'] as String))
        .toList();

    final paymentTerms = (backup['paymentTerms'] as List<dynamic>? ?? [])
        .map((t) => WeddingPaymentTerm.fromFirestoreMap(Map<String, dynamic>.from(t as Map), t['termId'] as String))
        .toList();

    final guests = (backup['guests'] as List<dynamic>? ?? [])
        .map((g) => WeddingGuest.fromFirestoreMap(Map<String, dynamic>.from(g as Map), g['guestId'] as String))
        .toList();

    final vendors = (backup['vendors'] as List<dynamic>? ?? [])
        .map((v) => WeddingVendor.fromFirestoreMap(Map<String, dynamic>.from(v as Map), v['vendorId'] as String))
        .toList();

    final tasks = (backup['tasks'] as List<dynamic>? ?? [])
        .map((t) => WeddingTask.fromFirestoreMap(Map<String, dynamic>.from(t as Map), t['taskId'] as String))
        .toList();

    final committee = (backup['committee'] as List<dynamic>? ?? [])
        .map((c) => WeddingCommitteeMember.fromFirestoreMap(Map<String, dynamic>.from(c as Map), c['memberId'] as String))
        .toList();

    final events = (backup['events'] as List<dynamic>? ?? [])
        .map((ev) => WeddingEvent.fromFirestoreMap(Map<String, dynamic>.from(ev as Map), ev['eventId'] as String))
        .toList();

    final rundownItems = (backup['rundownItems'] as List<dynamic>? ?? [])
        .map((r) => WeddingRundownItem.fromFirestoreMap(Map<String, dynamic>.from(r as Map), r['itemId'] as String))
        .toList();

    final seserahan = (backup['seserahan'] as List<dynamic>? ?? [])
        .map((s) => WeddingSeserahan.fromFirestoreMap(Map<String, dynamic>.from(s as Map), s['itemId'] as String))
        .toList();

    final documents = (backup['documents'] as List<dynamic>? ?? [])
        .map((d) => WeddingDocument.fromFirestoreMap(Map<String, dynamic>.from(d as Map), d['docId'] as String))
        .toList();

    // Execute atomic restoration inside an isolated SQLite transaction
    await transaction(() async {
      await insertProfile(profile);

      // Clean existing related entities before repopulating
      await (delete(weddingExpenses)..where((t) => t.weddingProfileId.equals(profileId))).go();
      await (delete(weddingGuests)..where((t) => t.weddingProfileId.equals(profileId))).go();
      await (delete(weddingVendors)..where((t) => t.weddingProfileId.equals(profileId))).go();
      await (delete(weddingTasks)..where((t) => t.weddingProfileId.equals(profileId))).go();
      await (delete(weddingCommitteeMembers)..where((t) => t.weddingProfileId.equals(profileId))).go();
      await (delete(weddingEvents)..where((t) => t.weddingProfileId.equals(profileId))).go();
      await (delete(weddingSeserahans)..where((t) => t.weddingProfileId.equals(profileId))).go();
      await (delete(weddingDocuments)..where((t) => t.weddingProfileId.equals(profileId))).go();

      // Batch re-insert
      for (final exp in expenses) {
        await insertExpense(exp);
      }
      for (final term in paymentTerms) {
        await insertPaymentTerm(term);
      }
      await insertGuestsBatch(guests);
      for (final v in vendors) {
        await insertVendor(v);
      }
      await insertTasksBatch(tasks);
      for (final c in committee) {
        await insertCommittee(c);
      }
      await insertEventsBatch(events);
      for (final r in rundownItems) {
        await insertRundownItem(r);
      }
      for (final s in seserahan) {
        await insertSeserahan(s);
      }
      await insertDocumentsBatch(documents);
    });
  }
}
