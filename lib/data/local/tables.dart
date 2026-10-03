import 'package:drift/drift.dart';

@DataClassName('WeddingProfileTableData')
class WeddingProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get groomName => text()();
  TextColumn get brideName => text()();
  IntColumn get weddingDate => integer()();
  RealColumn get totalBudgetCap => real().withDefault(const Constant(0.0))();
  TextColumn get religionType => text().withDefault(const Constant('ISLAM'))();
  TextColumn get religionDetail => text().nullable()();
  TextColumn get culturalPresetGroom => text().nullable()();
  TextColumn get culturalPresetBride => text().nullable()();
  TextColumn get quote => text().nullable()();
  BoolColumn get quoteEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get quoteFontSize => text().withDefault(const Constant('SEDANG'))();
  TextColumn get quoteFontStyle => text().withDefault(const Constant('ITALIC'))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WeddingExpenseTableData')
class WeddingExpenses extends Table {
  TextColumn get expenseId => text()();
  TextColumn get weddingProfileId => text().references(WeddingProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get category => text()();
  TextColumn get title => text()();
  RealColumn get totalEstimated => real().withDefault(const Constant(0.0))();
  RealColumn get totalPaid => real().withDefault(const Constant(0.0))();
  TextColumn get paidBySource => text().withDefault(const Constant('BERSAMA'))();
  TextColumn get paymentStatus => text().withDefault(const Constant('UNPAID'))();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {expenseId};
}

@DataClassName('WeddingPaymentTermTableData')
class WeddingPaymentTerms extends Table {
  TextColumn get termId => text()();
  TextColumn get expenseId => text().references(WeddingExpenses, #expenseId, onDelete: KeyAction.cascade)();
  TextColumn get termName => text()();
  RealColumn get amount => real()();
  IntColumn get dueDate => integer()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  IntColumn get paidDate => integer().nullable()();

  @override
  Set<Column> get primaryKey => {termId};
}

@DataClassName('WeddingGuestTableData')
class WeddingGuests extends Table {
  TextColumn get guestId => text()();
  TextColumn get weddingProfileId => text().references(WeddingProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get guestName => text()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get groupAllocation => text().withDefault(const Constant('TEMAN_CPP'))();
  TextColumn get sessionTarget => text().withDefault(const Constant('KEDUANYA'))();
  IntColumn get estimatedPax => integer().withDefault(const Constant(2))();
  TextColumn get rsvpStatus => text().withDefault(const Constant('PENDING'))();

  @override
  Set<Column> get primaryKey => {guestId};
}

@DataClassName('WeddingVendorTableData')
class WeddingVendors extends Table {
  TextColumn get vendorId => text()();
  TextColumn get weddingProfileId => text().references(WeddingProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get category => text()();
  TextColumn get name => text()();
  TextColumn get picName => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get instagramHandle => text().nullable()();
  RealColumn get contractValue => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('PROSPEK'))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {vendorId};
}

@DataClassName('WeddingTaskTableData')
class WeddingTasks extends Table {
  TextColumn get taskId => text()();
  TextColumn get weddingProfileId => text().references(WeddingProfiles, #id, onDelete: KeyAction.cascade)();
  IntColumn get phaseMonth => integer()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get pic => text().withDefault(const Constant('BOTH'))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get dueDate => integer().nullable()();
  IntColumn get completedDate => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {taskId};
}

@DataClassName('WeddingCommitteeTableData')
class WeddingCommitteeMembers extends Table {
  TextColumn get memberId => text()();
  TextColumn get weddingProfileId => text().references(WeddingProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get memberName => text()();
  TextColumn get role => text()();
  TextColumn get side => text().withDefault(const Constant('KELUARGA_CPP'))();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get uniformDescription => text().nullable()();
  RealColumn get fabricMeters => real().withDefault(const Constant(0.0))();
  TextColumn get uniformStatus => text().withDefault(const Constant('BELUM_DIBAGI'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {memberId};
}

@DataClassName('WeddingEventTableData')
class WeddingEvents extends Table {
  TextColumn get eventId => text()();
  TextColumn get weddingProfileId => text().references(WeddingProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get eventName => text()();
  IntColumn get eventDate => integer()();
  TextColumn get eventLocation => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {eventId};
}

@DataClassName('WeddingRundownItemTableData')
class WeddingRundownItems extends Table {
  TextColumn get itemId => text()();
  TextColumn get eventId => text().references(WeddingEvents, #eventId, onDelete: KeyAction.cascade)();
  TextColumn get timeStart => text().withDefault(const Constant('08:00'))();
  IntColumn get durationMinutes => integer().withDefault(const Constant(15))();
  TextColumn get sessionTitle => text()();
  TextColumn get pic => text().nullable()();
  TextColumn get mcScript => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {itemId};
}

@DataClassName('WeddingSeserahanTableData')
class WeddingSeserahans extends Table {
  TextColumn get itemId => text()();
  TextColumn get weddingProfileId => text().references(WeddingProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get direction => text().withDefault(const Constant('SESERAHAN_CPP'))();
  TextColumn get itemName => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get estimatedPrice => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('BELUM_BELI'))();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {itemId};
}

@DataClassName('WeddingDocumentTableData')
class WeddingDocuments extends Table {
  TextColumn get docId => text()();
  TextColumn get weddingProfileId => text().references(WeddingProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get docName => text()();
  TextColumn get ownerType => text().withDefault(const Constant('BOTH'))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get localFilePath => text().nullable()();
  RealColumn get adminCost => real().withDefault(const Constant(0.0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {docId};
}
