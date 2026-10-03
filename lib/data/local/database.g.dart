// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WeddingProfilesTable extends WeddingProfiles
    with TableInfo<$WeddingProfilesTable, WeddingProfileTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groomNameMeta = const VerificationMeta(
    'groomName',
  );
  @override
  late final GeneratedColumn<String> groomName = GeneratedColumn<String>(
    'groom_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brideNameMeta = const VerificationMeta(
    'brideName',
  );
  @override
  late final GeneratedColumn<String> brideName = GeneratedColumn<String>(
    'bride_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingDateMeta = const VerificationMeta(
    'weddingDate',
  );
  @override
  late final GeneratedColumn<int> weddingDate = GeneratedColumn<int>(
    'wedding_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalBudgetCapMeta = const VerificationMeta(
    'totalBudgetCap',
  );
  @override
  late final GeneratedColumn<double> totalBudgetCap = GeneratedColumn<double>(
    'total_budget_cap',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _religionTypeMeta = const VerificationMeta(
    'religionType',
  );
  @override
  late final GeneratedColumn<String> religionType = GeneratedColumn<String>(
    'religion_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ISLAM'),
  );
  static const VerificationMeta _religionDetailMeta = const VerificationMeta(
    'religionDetail',
  );
  @override
  late final GeneratedColumn<String> religionDetail = GeneratedColumn<String>(
    'religion_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _culturalPresetGroomMeta =
      const VerificationMeta('culturalPresetGroom');
  @override
  late final GeneratedColumn<String> culturalPresetGroom =
      GeneratedColumn<String>(
        'cultural_preset_groom',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _culturalPresetBrideMeta =
      const VerificationMeta('culturalPresetBride');
  @override
  late final GeneratedColumn<String> culturalPresetBride =
      GeneratedColumn<String>(
        'cultural_preset_bride',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _quoteMeta = const VerificationMeta('quote');
  @override
  late final GeneratedColumn<String> quote = GeneratedColumn<String>(
    'quote',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteEnabledMeta = const VerificationMeta(
    'quoteEnabled',
  );
  @override
  late final GeneratedColumn<bool> quoteEnabled = GeneratedColumn<bool>(
    'quote_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("quote_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _quoteFontSizeMeta = const VerificationMeta(
    'quoteFontSize',
  );
  @override
  late final GeneratedColumn<String> quoteFontSize = GeneratedColumn<String>(
    'quote_font_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SEDANG'),
  );
  static const VerificationMeta _quoteFontStyleMeta = const VerificationMeta(
    'quoteFontStyle',
  );
  @override
  late final GeneratedColumn<String> quoteFontStyle = GeneratedColumn<String>(
    'quote_font_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ITALIC'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groomName,
    brideName,
    weddingDate,
    totalBudgetCap,
    religionType,
    religionDetail,
    culturalPresetGroom,
    culturalPresetBride,
    quote,
    quoteEnabled,
    quoteFontSize,
    quoteFontStyle,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingProfileTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('groom_name')) {
      context.handle(
        _groomNameMeta,
        groomName.isAcceptableOrUnknown(data['groom_name']!, _groomNameMeta),
      );
    } else if (isInserting) {
      context.missing(_groomNameMeta);
    }
    if (data.containsKey('bride_name')) {
      context.handle(
        _brideNameMeta,
        brideName.isAcceptableOrUnknown(data['bride_name']!, _brideNameMeta),
      );
    } else if (isInserting) {
      context.missing(_brideNameMeta);
    }
    if (data.containsKey('wedding_date')) {
      context.handle(
        _weddingDateMeta,
        weddingDate.isAcceptableOrUnknown(
          data['wedding_date']!,
          _weddingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingDateMeta);
    }
    if (data.containsKey('total_budget_cap')) {
      context.handle(
        _totalBudgetCapMeta,
        totalBudgetCap.isAcceptableOrUnknown(
          data['total_budget_cap']!,
          _totalBudgetCapMeta,
        ),
      );
    }
    if (data.containsKey('religion_type')) {
      context.handle(
        _religionTypeMeta,
        religionType.isAcceptableOrUnknown(
          data['religion_type']!,
          _religionTypeMeta,
        ),
      );
    }
    if (data.containsKey('religion_detail')) {
      context.handle(
        _religionDetailMeta,
        religionDetail.isAcceptableOrUnknown(
          data['religion_detail']!,
          _religionDetailMeta,
        ),
      );
    }
    if (data.containsKey('cultural_preset_groom')) {
      context.handle(
        _culturalPresetGroomMeta,
        culturalPresetGroom.isAcceptableOrUnknown(
          data['cultural_preset_groom']!,
          _culturalPresetGroomMeta,
        ),
      );
    }
    if (data.containsKey('cultural_preset_bride')) {
      context.handle(
        _culturalPresetBrideMeta,
        culturalPresetBride.isAcceptableOrUnknown(
          data['cultural_preset_bride']!,
          _culturalPresetBrideMeta,
        ),
      );
    }
    if (data.containsKey('quote')) {
      context.handle(
        _quoteMeta,
        quote.isAcceptableOrUnknown(data['quote']!, _quoteMeta),
      );
    }
    if (data.containsKey('quote_enabled')) {
      context.handle(
        _quoteEnabledMeta,
        quoteEnabled.isAcceptableOrUnknown(
          data['quote_enabled']!,
          _quoteEnabledMeta,
        ),
      );
    }
    if (data.containsKey('quote_font_size')) {
      context.handle(
        _quoteFontSizeMeta,
        quoteFontSize.isAcceptableOrUnknown(
          data['quote_font_size']!,
          _quoteFontSizeMeta,
        ),
      );
    }
    if (data.containsKey('quote_font_style')) {
      context.handle(
        _quoteFontStyleMeta,
        quoteFontStyle.isAcceptableOrUnknown(
          data['quote_font_style']!,
          _quoteFontStyleMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeddingProfileTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingProfileTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groomName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}groom_name'],
      )!,
      brideName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bride_name'],
      )!,
      weddingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wedding_date'],
      )!,
      totalBudgetCap: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_budget_cap'],
      )!,
      religionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}religion_type'],
      )!,
      religionDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}religion_detail'],
      ),
      culturalPresetGroom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cultural_preset_groom'],
      ),
      culturalPresetBride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cultural_preset_bride'],
      ),
      quote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote'],
      ),
      quoteEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}quote_enabled'],
      )!,
      quoteFontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_font_size'],
      )!,
      quoteFontStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_font_style'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeddingProfilesTable createAlias(String alias) {
    return $WeddingProfilesTable(attachedDatabase, alias);
  }
}

class WeddingProfileTableData extends DataClass
    implements Insertable<WeddingProfileTableData> {
  final String id;
  final String groomName;
  final String brideName;
  final int weddingDate;
  final double totalBudgetCap;
  final String religionType;
  final String? religionDetail;
  final String? culturalPresetGroom;
  final String? culturalPresetBride;
  final String? quote;
  final bool quoteEnabled;
  final String quoteFontSize;
  final String quoteFontStyle;
  final int createdAt;
  const WeddingProfileTableData({
    required this.id,
    required this.groomName,
    required this.brideName,
    required this.weddingDate,
    required this.totalBudgetCap,
    required this.religionType,
    this.religionDetail,
    this.culturalPresetGroom,
    this.culturalPresetBride,
    this.quote,
    required this.quoteEnabled,
    required this.quoteFontSize,
    required this.quoteFontStyle,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['groom_name'] = Variable<String>(groomName);
    map['bride_name'] = Variable<String>(brideName);
    map['wedding_date'] = Variable<int>(weddingDate);
    map['total_budget_cap'] = Variable<double>(totalBudgetCap);
    map['religion_type'] = Variable<String>(religionType);
    if (!nullToAbsent || religionDetail != null) {
      map['religion_detail'] = Variable<String>(religionDetail);
    }
    if (!nullToAbsent || culturalPresetGroom != null) {
      map['cultural_preset_groom'] = Variable<String>(culturalPresetGroom);
    }
    if (!nullToAbsent || culturalPresetBride != null) {
      map['cultural_preset_bride'] = Variable<String>(culturalPresetBride);
    }
    if (!nullToAbsent || quote != null) {
      map['quote'] = Variable<String>(quote);
    }
    map['quote_enabled'] = Variable<bool>(quoteEnabled);
    map['quote_font_size'] = Variable<String>(quoteFontSize);
    map['quote_font_style'] = Variable<String>(quoteFontStyle);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  WeddingProfilesCompanion toCompanion(bool nullToAbsent) {
    return WeddingProfilesCompanion(
      id: Value(id),
      groomName: Value(groomName),
      brideName: Value(brideName),
      weddingDate: Value(weddingDate),
      totalBudgetCap: Value(totalBudgetCap),
      religionType: Value(religionType),
      religionDetail: religionDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(religionDetail),
      culturalPresetGroom: culturalPresetGroom == null && nullToAbsent
          ? const Value.absent()
          : Value(culturalPresetGroom),
      culturalPresetBride: culturalPresetBride == null && nullToAbsent
          ? const Value.absent()
          : Value(culturalPresetBride),
      quote: quote == null && nullToAbsent
          ? const Value.absent()
          : Value(quote),
      quoteEnabled: Value(quoteEnabled),
      quoteFontSize: Value(quoteFontSize),
      quoteFontStyle: Value(quoteFontStyle),
      createdAt: Value(createdAt),
    );
  }

  factory WeddingProfileTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingProfileTableData(
      id: serializer.fromJson<String>(json['id']),
      groomName: serializer.fromJson<String>(json['groomName']),
      brideName: serializer.fromJson<String>(json['brideName']),
      weddingDate: serializer.fromJson<int>(json['weddingDate']),
      totalBudgetCap: serializer.fromJson<double>(json['totalBudgetCap']),
      religionType: serializer.fromJson<String>(json['religionType']),
      religionDetail: serializer.fromJson<String?>(json['religionDetail']),
      culturalPresetGroom: serializer.fromJson<String?>(
        json['culturalPresetGroom'],
      ),
      culturalPresetBride: serializer.fromJson<String?>(
        json['culturalPresetBride'],
      ),
      quote: serializer.fromJson<String?>(json['quote']),
      quoteEnabled: serializer.fromJson<bool>(json['quoteEnabled']),
      quoteFontSize: serializer.fromJson<String>(json['quoteFontSize']),
      quoteFontStyle: serializer.fromJson<String>(json['quoteFontStyle']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groomName': serializer.toJson<String>(groomName),
      'brideName': serializer.toJson<String>(brideName),
      'weddingDate': serializer.toJson<int>(weddingDate),
      'totalBudgetCap': serializer.toJson<double>(totalBudgetCap),
      'religionType': serializer.toJson<String>(religionType),
      'religionDetail': serializer.toJson<String?>(religionDetail),
      'culturalPresetGroom': serializer.toJson<String?>(culturalPresetGroom),
      'culturalPresetBride': serializer.toJson<String?>(culturalPresetBride),
      'quote': serializer.toJson<String?>(quote),
      'quoteEnabled': serializer.toJson<bool>(quoteEnabled),
      'quoteFontSize': serializer.toJson<String>(quoteFontSize),
      'quoteFontStyle': serializer.toJson<String>(quoteFontStyle),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  WeddingProfileTableData copyWith({
    String? id,
    String? groomName,
    String? brideName,
    int? weddingDate,
    double? totalBudgetCap,
    String? religionType,
    Value<String?> religionDetail = const Value.absent(),
    Value<String?> culturalPresetGroom = const Value.absent(),
    Value<String?> culturalPresetBride = const Value.absent(),
    Value<String?> quote = const Value.absent(),
    bool? quoteEnabled,
    String? quoteFontSize,
    String? quoteFontStyle,
    int? createdAt,
  }) => WeddingProfileTableData(
    id: id ?? this.id,
    groomName: groomName ?? this.groomName,
    brideName: brideName ?? this.brideName,
    weddingDate: weddingDate ?? this.weddingDate,
    totalBudgetCap: totalBudgetCap ?? this.totalBudgetCap,
    religionType: religionType ?? this.religionType,
    religionDetail: religionDetail.present
        ? religionDetail.value
        : this.religionDetail,
    culturalPresetGroom: culturalPresetGroom.present
        ? culturalPresetGroom.value
        : this.culturalPresetGroom,
    culturalPresetBride: culturalPresetBride.present
        ? culturalPresetBride.value
        : this.culturalPresetBride,
    quote: quote.present ? quote.value : this.quote,
    quoteEnabled: quoteEnabled ?? this.quoteEnabled,
    quoteFontSize: quoteFontSize ?? this.quoteFontSize,
    quoteFontStyle: quoteFontStyle ?? this.quoteFontStyle,
    createdAt: createdAt ?? this.createdAt,
  );
  WeddingProfileTableData copyWithCompanion(WeddingProfilesCompanion data) {
    return WeddingProfileTableData(
      id: data.id.present ? data.id.value : this.id,
      groomName: data.groomName.present ? data.groomName.value : this.groomName,
      brideName: data.brideName.present ? data.brideName.value : this.brideName,
      weddingDate: data.weddingDate.present
          ? data.weddingDate.value
          : this.weddingDate,
      totalBudgetCap: data.totalBudgetCap.present
          ? data.totalBudgetCap.value
          : this.totalBudgetCap,
      religionType: data.religionType.present
          ? data.religionType.value
          : this.religionType,
      religionDetail: data.religionDetail.present
          ? data.religionDetail.value
          : this.religionDetail,
      culturalPresetGroom: data.culturalPresetGroom.present
          ? data.culturalPresetGroom.value
          : this.culturalPresetGroom,
      culturalPresetBride: data.culturalPresetBride.present
          ? data.culturalPresetBride.value
          : this.culturalPresetBride,
      quote: data.quote.present ? data.quote.value : this.quote,
      quoteEnabled: data.quoteEnabled.present
          ? data.quoteEnabled.value
          : this.quoteEnabled,
      quoteFontSize: data.quoteFontSize.present
          ? data.quoteFontSize.value
          : this.quoteFontSize,
      quoteFontStyle: data.quoteFontStyle.present
          ? data.quoteFontStyle.value
          : this.quoteFontStyle,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingProfileTableData(')
          ..write('id: $id, ')
          ..write('groomName: $groomName, ')
          ..write('brideName: $brideName, ')
          ..write('weddingDate: $weddingDate, ')
          ..write('totalBudgetCap: $totalBudgetCap, ')
          ..write('religionType: $religionType, ')
          ..write('religionDetail: $religionDetail, ')
          ..write('culturalPresetGroom: $culturalPresetGroom, ')
          ..write('culturalPresetBride: $culturalPresetBride, ')
          ..write('quote: $quote, ')
          ..write('quoteEnabled: $quoteEnabled, ')
          ..write('quoteFontSize: $quoteFontSize, ')
          ..write('quoteFontStyle: $quoteFontStyle, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groomName,
    brideName,
    weddingDate,
    totalBudgetCap,
    religionType,
    religionDetail,
    culturalPresetGroom,
    culturalPresetBride,
    quote,
    quoteEnabled,
    quoteFontSize,
    quoteFontStyle,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingProfileTableData &&
          other.id == this.id &&
          other.groomName == this.groomName &&
          other.brideName == this.brideName &&
          other.weddingDate == this.weddingDate &&
          other.totalBudgetCap == this.totalBudgetCap &&
          other.religionType == this.religionType &&
          other.religionDetail == this.religionDetail &&
          other.culturalPresetGroom == this.culturalPresetGroom &&
          other.culturalPresetBride == this.culturalPresetBride &&
          other.quote == this.quote &&
          other.quoteEnabled == this.quoteEnabled &&
          other.quoteFontSize == this.quoteFontSize &&
          other.quoteFontStyle == this.quoteFontStyle &&
          other.createdAt == this.createdAt);
}

class WeddingProfilesCompanion
    extends UpdateCompanion<WeddingProfileTableData> {
  final Value<String> id;
  final Value<String> groomName;
  final Value<String> brideName;
  final Value<int> weddingDate;
  final Value<double> totalBudgetCap;
  final Value<String> religionType;
  final Value<String?> religionDetail;
  final Value<String?> culturalPresetGroom;
  final Value<String?> culturalPresetBride;
  final Value<String?> quote;
  final Value<bool> quoteEnabled;
  final Value<String> quoteFontSize;
  final Value<String> quoteFontStyle;
  final Value<int> createdAt;
  final Value<int> rowid;
  const WeddingProfilesCompanion({
    this.id = const Value.absent(),
    this.groomName = const Value.absent(),
    this.brideName = const Value.absent(),
    this.weddingDate = const Value.absent(),
    this.totalBudgetCap = const Value.absent(),
    this.religionType = const Value.absent(),
    this.religionDetail = const Value.absent(),
    this.culturalPresetGroom = const Value.absent(),
    this.culturalPresetBride = const Value.absent(),
    this.quote = const Value.absent(),
    this.quoteEnabled = const Value.absent(),
    this.quoteFontSize = const Value.absent(),
    this.quoteFontStyle = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingProfilesCompanion.insert({
    required String id,
    required String groomName,
    required String brideName,
    required int weddingDate,
    this.totalBudgetCap = const Value.absent(),
    this.religionType = const Value.absent(),
    this.religionDetail = const Value.absent(),
    this.culturalPresetGroom = const Value.absent(),
    this.culturalPresetBride = const Value.absent(),
    this.quote = const Value.absent(),
    this.quoteEnabled = const Value.absent(),
    this.quoteFontSize = const Value.absent(),
    this.quoteFontStyle = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groomName = Value(groomName),
       brideName = Value(brideName),
       weddingDate = Value(weddingDate),
       createdAt = Value(createdAt);
  static Insertable<WeddingProfileTableData> custom({
    Expression<String>? id,
    Expression<String>? groomName,
    Expression<String>? brideName,
    Expression<int>? weddingDate,
    Expression<double>? totalBudgetCap,
    Expression<String>? religionType,
    Expression<String>? religionDetail,
    Expression<String>? culturalPresetGroom,
    Expression<String>? culturalPresetBride,
    Expression<String>? quote,
    Expression<bool>? quoteEnabled,
    Expression<String>? quoteFontSize,
    Expression<String>? quoteFontStyle,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groomName != null) 'groom_name': groomName,
      if (brideName != null) 'bride_name': brideName,
      if (weddingDate != null) 'wedding_date': weddingDate,
      if (totalBudgetCap != null) 'total_budget_cap': totalBudgetCap,
      if (religionType != null) 'religion_type': religionType,
      if (religionDetail != null) 'religion_detail': religionDetail,
      if (culturalPresetGroom != null)
        'cultural_preset_groom': culturalPresetGroom,
      if (culturalPresetBride != null)
        'cultural_preset_bride': culturalPresetBride,
      if (quote != null) 'quote': quote,
      if (quoteEnabled != null) 'quote_enabled': quoteEnabled,
      if (quoteFontSize != null) 'quote_font_size': quoteFontSize,
      if (quoteFontStyle != null) 'quote_font_style': quoteFontStyle,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? groomName,
    Value<String>? brideName,
    Value<int>? weddingDate,
    Value<double>? totalBudgetCap,
    Value<String>? religionType,
    Value<String?>? religionDetail,
    Value<String?>? culturalPresetGroom,
    Value<String?>? culturalPresetBride,
    Value<String?>? quote,
    Value<bool>? quoteEnabled,
    Value<String>? quoteFontSize,
    Value<String>? quoteFontStyle,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return WeddingProfilesCompanion(
      id: id ?? this.id,
      groomName: groomName ?? this.groomName,
      brideName: brideName ?? this.brideName,
      weddingDate: weddingDate ?? this.weddingDate,
      totalBudgetCap: totalBudgetCap ?? this.totalBudgetCap,
      religionType: religionType ?? this.religionType,
      religionDetail: religionDetail ?? this.religionDetail,
      culturalPresetGroom: culturalPresetGroom ?? this.culturalPresetGroom,
      culturalPresetBride: culturalPresetBride ?? this.culturalPresetBride,
      quote: quote ?? this.quote,
      quoteEnabled: quoteEnabled ?? this.quoteEnabled,
      quoteFontSize: quoteFontSize ?? this.quoteFontSize,
      quoteFontStyle: quoteFontStyle ?? this.quoteFontStyle,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groomName.present) {
      map['groom_name'] = Variable<String>(groomName.value);
    }
    if (brideName.present) {
      map['bride_name'] = Variable<String>(brideName.value);
    }
    if (weddingDate.present) {
      map['wedding_date'] = Variable<int>(weddingDate.value);
    }
    if (totalBudgetCap.present) {
      map['total_budget_cap'] = Variable<double>(totalBudgetCap.value);
    }
    if (religionType.present) {
      map['religion_type'] = Variable<String>(religionType.value);
    }
    if (religionDetail.present) {
      map['religion_detail'] = Variable<String>(religionDetail.value);
    }
    if (culturalPresetGroom.present) {
      map['cultural_preset_groom'] = Variable<String>(
        culturalPresetGroom.value,
      );
    }
    if (culturalPresetBride.present) {
      map['cultural_preset_bride'] = Variable<String>(
        culturalPresetBride.value,
      );
    }
    if (quote.present) {
      map['quote'] = Variable<String>(quote.value);
    }
    if (quoteEnabled.present) {
      map['quote_enabled'] = Variable<bool>(quoteEnabled.value);
    }
    if (quoteFontSize.present) {
      map['quote_font_size'] = Variable<String>(quoteFontSize.value);
    }
    if (quoteFontStyle.present) {
      map['quote_font_style'] = Variable<String>(quoteFontStyle.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingProfilesCompanion(')
          ..write('id: $id, ')
          ..write('groomName: $groomName, ')
          ..write('brideName: $brideName, ')
          ..write('weddingDate: $weddingDate, ')
          ..write('totalBudgetCap: $totalBudgetCap, ')
          ..write('religionType: $religionType, ')
          ..write('religionDetail: $religionDetail, ')
          ..write('culturalPresetGroom: $culturalPresetGroom, ')
          ..write('culturalPresetBride: $culturalPresetBride, ')
          ..write('quote: $quote, ')
          ..write('quoteEnabled: $quoteEnabled, ')
          ..write('quoteFontSize: $quoteFontSize, ')
          ..write('quoteFontStyle: $quoteFontStyle, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingExpensesTable extends WeddingExpenses
    with TableInfo<$WeddingExpensesTable, WeddingExpenseTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<String> expenseId = GeneratedColumn<String>(
    'expense_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingProfileIdMeta = const VerificationMeta(
    'weddingProfileId',
  );
  @override
  late final GeneratedColumn<String> weddingProfileId = GeneratedColumn<String>(
    'wedding_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalEstimatedMeta = const VerificationMeta(
    'totalEstimated',
  );
  @override
  late final GeneratedColumn<double> totalEstimated = GeneratedColumn<double>(
    'total_estimated',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalPaidMeta = const VerificationMeta(
    'totalPaid',
  );
  @override
  late final GeneratedColumn<double> totalPaid = GeneratedColumn<double>(
    'total_paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _paidBySourceMeta = const VerificationMeta(
    'paidBySource',
  );
  @override
  late final GeneratedColumn<String> paidBySource = GeneratedColumn<String>(
    'paid_by_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BERSAMA'),
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNPAID'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    expenseId,
    weddingProfileId,
    category,
    title,
    totalEstimated,
    totalPaid,
    paidBySource,
    paymentStatus,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingExpenseTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('wedding_profile_id')) {
      context.handle(
        _weddingProfileIdMeta,
        weddingProfileId.isAcceptableOrUnknown(
          data['wedding_profile_id']!,
          _weddingProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingProfileIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('total_estimated')) {
      context.handle(
        _totalEstimatedMeta,
        totalEstimated.isAcceptableOrUnknown(
          data['total_estimated']!,
          _totalEstimatedMeta,
        ),
      );
    }
    if (data.containsKey('total_paid')) {
      context.handle(
        _totalPaidMeta,
        totalPaid.isAcceptableOrUnknown(data['total_paid']!, _totalPaidMeta),
      );
    }
    if (data.containsKey('paid_by_source')) {
      context.handle(
        _paidBySourceMeta,
        paidBySource.isAcceptableOrUnknown(
          data['paid_by_source']!,
          _paidBySourceMeta,
        ),
      );
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {expenseId};
  @override
  WeddingExpenseTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingExpenseTableData(
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_id'],
      )!,
      weddingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wedding_profile_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      totalEstimated: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_estimated'],
      )!,
      totalPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_paid'],
      )!,
      paidBySource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_by_source'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeddingExpensesTable createAlias(String alias) {
    return $WeddingExpensesTable(attachedDatabase, alias);
  }
}

class WeddingExpenseTableData extends DataClass
    implements Insertable<WeddingExpenseTableData> {
  final String expenseId;
  final String weddingProfileId;
  final String category;
  final String title;
  final double totalEstimated;
  final double totalPaid;
  final String paidBySource;
  final String paymentStatus;
  final String? notes;
  final int createdAt;
  const WeddingExpenseTableData({
    required this.expenseId,
    required this.weddingProfileId,
    required this.category,
    required this.title,
    required this.totalEstimated,
    required this.totalPaid,
    required this.paidBySource,
    required this.paymentStatus,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['expense_id'] = Variable<String>(expenseId);
    map['wedding_profile_id'] = Variable<String>(weddingProfileId);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    map['total_estimated'] = Variable<double>(totalEstimated);
    map['total_paid'] = Variable<double>(totalPaid);
    map['paid_by_source'] = Variable<String>(paidBySource);
    map['payment_status'] = Variable<String>(paymentStatus);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  WeddingExpensesCompanion toCompanion(bool nullToAbsent) {
    return WeddingExpensesCompanion(
      expenseId: Value(expenseId),
      weddingProfileId: Value(weddingProfileId),
      category: Value(category),
      title: Value(title),
      totalEstimated: Value(totalEstimated),
      totalPaid: Value(totalPaid),
      paidBySource: Value(paidBySource),
      paymentStatus: Value(paymentStatus),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory WeddingExpenseTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingExpenseTableData(
      expenseId: serializer.fromJson<String>(json['expenseId']),
      weddingProfileId: serializer.fromJson<String>(json['weddingProfileId']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      totalEstimated: serializer.fromJson<double>(json['totalEstimated']),
      totalPaid: serializer.fromJson<double>(json['totalPaid']),
      paidBySource: serializer.fromJson<String>(json['paidBySource']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'expenseId': serializer.toJson<String>(expenseId),
      'weddingProfileId': serializer.toJson<String>(weddingProfileId),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'totalEstimated': serializer.toJson<double>(totalEstimated),
      'totalPaid': serializer.toJson<double>(totalPaid),
      'paidBySource': serializer.toJson<String>(paidBySource),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  WeddingExpenseTableData copyWith({
    String? expenseId,
    String? weddingProfileId,
    String? category,
    String? title,
    double? totalEstimated,
    double? totalPaid,
    String? paidBySource,
    String? paymentStatus,
    Value<String?> notes = const Value.absent(),
    int? createdAt,
  }) => WeddingExpenseTableData(
    expenseId: expenseId ?? this.expenseId,
    weddingProfileId: weddingProfileId ?? this.weddingProfileId,
    category: category ?? this.category,
    title: title ?? this.title,
    totalEstimated: totalEstimated ?? this.totalEstimated,
    totalPaid: totalPaid ?? this.totalPaid,
    paidBySource: paidBySource ?? this.paidBySource,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  WeddingExpenseTableData copyWithCompanion(WeddingExpensesCompanion data) {
    return WeddingExpenseTableData(
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      weddingProfileId: data.weddingProfileId.present
          ? data.weddingProfileId.value
          : this.weddingProfileId,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      totalEstimated: data.totalEstimated.present
          ? data.totalEstimated.value
          : this.totalEstimated,
      totalPaid: data.totalPaid.present ? data.totalPaid.value : this.totalPaid,
      paidBySource: data.paidBySource.present
          ? data.paidBySource.value
          : this.paidBySource,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingExpenseTableData(')
          ..write('expenseId: $expenseId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('totalEstimated: $totalEstimated, ')
          ..write('totalPaid: $totalPaid, ')
          ..write('paidBySource: $paidBySource, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    expenseId,
    weddingProfileId,
    category,
    title,
    totalEstimated,
    totalPaid,
    paidBySource,
    paymentStatus,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingExpenseTableData &&
          other.expenseId == this.expenseId &&
          other.weddingProfileId == this.weddingProfileId &&
          other.category == this.category &&
          other.title == this.title &&
          other.totalEstimated == this.totalEstimated &&
          other.totalPaid == this.totalPaid &&
          other.paidBySource == this.paidBySource &&
          other.paymentStatus == this.paymentStatus &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class WeddingExpensesCompanion
    extends UpdateCompanion<WeddingExpenseTableData> {
  final Value<String> expenseId;
  final Value<String> weddingProfileId;
  final Value<String> category;
  final Value<String> title;
  final Value<double> totalEstimated;
  final Value<double> totalPaid;
  final Value<String> paidBySource;
  final Value<String> paymentStatus;
  final Value<String?> notes;
  final Value<int> createdAt;
  final Value<int> rowid;
  const WeddingExpensesCompanion({
    this.expenseId = const Value.absent(),
    this.weddingProfileId = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.totalEstimated = const Value.absent(),
    this.totalPaid = const Value.absent(),
    this.paidBySource = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingExpensesCompanion.insert({
    required String expenseId,
    required String weddingProfileId,
    required String category,
    required String title,
    this.totalEstimated = const Value.absent(),
    this.totalPaid = const Value.absent(),
    this.paidBySource = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.notes = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : expenseId = Value(expenseId),
       weddingProfileId = Value(weddingProfileId),
       category = Value(category),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<WeddingExpenseTableData> custom({
    Expression<String>? expenseId,
    Expression<String>? weddingProfileId,
    Expression<String>? category,
    Expression<String>? title,
    Expression<double>? totalEstimated,
    Expression<double>? totalPaid,
    Expression<String>? paidBySource,
    Expression<String>? paymentStatus,
    Expression<String>? notes,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (expenseId != null) 'expense_id': expenseId,
      if (weddingProfileId != null) 'wedding_profile_id': weddingProfileId,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (totalEstimated != null) 'total_estimated': totalEstimated,
      if (totalPaid != null) 'total_paid': totalPaid,
      if (paidBySource != null) 'paid_by_source': paidBySource,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingExpensesCompanion copyWith({
    Value<String>? expenseId,
    Value<String>? weddingProfileId,
    Value<String>? category,
    Value<String>? title,
    Value<double>? totalEstimated,
    Value<double>? totalPaid,
    Value<String>? paidBySource,
    Value<String>? paymentStatus,
    Value<String?>? notes,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return WeddingExpensesCompanion(
      expenseId: expenseId ?? this.expenseId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      category: category ?? this.category,
      title: title ?? this.title,
      totalEstimated: totalEstimated ?? this.totalEstimated,
      totalPaid: totalPaid ?? this.totalPaid,
      paidBySource: paidBySource ?? this.paidBySource,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (expenseId.present) {
      map['expense_id'] = Variable<String>(expenseId.value);
    }
    if (weddingProfileId.present) {
      map['wedding_profile_id'] = Variable<String>(weddingProfileId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (totalEstimated.present) {
      map['total_estimated'] = Variable<double>(totalEstimated.value);
    }
    if (totalPaid.present) {
      map['total_paid'] = Variable<double>(totalPaid.value);
    }
    if (paidBySource.present) {
      map['paid_by_source'] = Variable<String>(paidBySource.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingExpensesCompanion(')
          ..write('expenseId: $expenseId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('totalEstimated: $totalEstimated, ')
          ..write('totalPaid: $totalPaid, ')
          ..write('paidBySource: $paidBySource, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingPaymentTermsTable extends WeddingPaymentTerms
    with TableInfo<$WeddingPaymentTermsTable, WeddingPaymentTermTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingPaymentTermsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _termIdMeta = const VerificationMeta('termId');
  @override
  late final GeneratedColumn<String> termId = GeneratedColumn<String>(
    'term_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<String> expenseId = GeneratedColumn<String>(
    'expense_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_expenses (expense_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _termNameMeta = const VerificationMeta(
    'termName',
  );
  @override
  late final GeneratedColumn<String> termName = GeneratedColumn<String>(
    'term_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<int> paidDate = GeneratedColumn<int>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    termId,
    expenseId,
    termName,
    amount,
    dueDate,
    isPaid,
    paidDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_payment_terms';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingPaymentTermTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('term_id')) {
      context.handle(
        _termIdMeta,
        termId.isAcceptableOrUnknown(data['term_id']!, _termIdMeta),
      );
    } else if (isInserting) {
      context.missing(_termIdMeta);
    }
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('term_name')) {
      context.handle(
        _termNameMeta,
        termName.isAcceptableOrUnknown(data['term_name']!, _termNameMeta),
      );
    } else if (isInserting) {
      context.missing(_termNameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {termId};
  @override
  WeddingPaymentTermTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingPaymentTermTableData(
      termId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}term_id'],
      )!,
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expense_id'],
      )!,
      termName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}term_name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
      )!,
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_date'],
      ),
    );
  }

  @override
  $WeddingPaymentTermsTable createAlias(String alias) {
    return $WeddingPaymentTermsTable(attachedDatabase, alias);
  }
}

class WeddingPaymentTermTableData extends DataClass
    implements Insertable<WeddingPaymentTermTableData> {
  final String termId;
  final String expenseId;
  final String termName;
  final double amount;
  final int dueDate;
  final bool isPaid;
  final int? paidDate;
  const WeddingPaymentTermTableData({
    required this.termId,
    required this.expenseId,
    required this.termName,
    required this.amount,
    required this.dueDate,
    required this.isPaid,
    this.paidDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['term_id'] = Variable<String>(termId);
    map['expense_id'] = Variable<String>(expenseId);
    map['term_name'] = Variable<String>(termName);
    map['amount'] = Variable<double>(amount);
    map['due_date'] = Variable<int>(dueDate);
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<int>(paidDate);
    }
    return map;
  }

  WeddingPaymentTermsCompanion toCompanion(bool nullToAbsent) {
    return WeddingPaymentTermsCompanion(
      termId: Value(termId),
      expenseId: Value(expenseId),
      termName: Value(termName),
      amount: Value(amount),
      dueDate: Value(dueDate),
      isPaid: Value(isPaid),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
    );
  }

  factory WeddingPaymentTermTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingPaymentTermTableData(
      termId: serializer.fromJson<String>(json['termId']),
      expenseId: serializer.fromJson<String>(json['expenseId']),
      termName: serializer.fromJson<String>(json['termName']),
      amount: serializer.fromJson<double>(json['amount']),
      dueDate: serializer.fromJson<int>(json['dueDate']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      paidDate: serializer.fromJson<int?>(json['paidDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'termId': serializer.toJson<String>(termId),
      'expenseId': serializer.toJson<String>(expenseId),
      'termName': serializer.toJson<String>(termName),
      'amount': serializer.toJson<double>(amount),
      'dueDate': serializer.toJson<int>(dueDate),
      'isPaid': serializer.toJson<bool>(isPaid),
      'paidDate': serializer.toJson<int?>(paidDate),
    };
  }

  WeddingPaymentTermTableData copyWith({
    String? termId,
    String? expenseId,
    String? termName,
    double? amount,
    int? dueDate,
    bool? isPaid,
    Value<int?> paidDate = const Value.absent(),
  }) => WeddingPaymentTermTableData(
    termId: termId ?? this.termId,
    expenseId: expenseId ?? this.expenseId,
    termName: termName ?? this.termName,
    amount: amount ?? this.amount,
    dueDate: dueDate ?? this.dueDate,
    isPaid: isPaid ?? this.isPaid,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
  );
  WeddingPaymentTermTableData copyWithCompanion(
    WeddingPaymentTermsCompanion data,
  ) {
    return WeddingPaymentTermTableData(
      termId: data.termId.present ? data.termId.value : this.termId,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      termName: data.termName.present ? data.termName.value : this.termName,
      amount: data.amount.present ? data.amount.value : this.amount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingPaymentTermTableData(')
          ..write('termId: $termId, ')
          ..write('expenseId: $expenseId, ')
          ..write('termName: $termName, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('isPaid: $isPaid, ')
          ..write('paidDate: $paidDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    termId,
    expenseId,
    termName,
    amount,
    dueDate,
    isPaid,
    paidDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingPaymentTermTableData &&
          other.termId == this.termId &&
          other.expenseId == this.expenseId &&
          other.termName == this.termName &&
          other.amount == this.amount &&
          other.dueDate == this.dueDate &&
          other.isPaid == this.isPaid &&
          other.paidDate == this.paidDate);
}

class WeddingPaymentTermsCompanion
    extends UpdateCompanion<WeddingPaymentTermTableData> {
  final Value<String> termId;
  final Value<String> expenseId;
  final Value<String> termName;
  final Value<double> amount;
  final Value<int> dueDate;
  final Value<bool> isPaid;
  final Value<int?> paidDate;
  final Value<int> rowid;
  const WeddingPaymentTermsCompanion({
    this.termId = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.termName = const Value.absent(),
    this.amount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingPaymentTermsCompanion.insert({
    required String termId,
    required String expenseId,
    required String termName,
    required double amount,
    required int dueDate,
    this.isPaid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : termId = Value(termId),
       expenseId = Value(expenseId),
       termName = Value(termName),
       amount = Value(amount),
       dueDate = Value(dueDate);
  static Insertable<WeddingPaymentTermTableData> custom({
    Expression<String>? termId,
    Expression<String>? expenseId,
    Expression<String>? termName,
    Expression<double>? amount,
    Expression<int>? dueDate,
    Expression<bool>? isPaid,
    Expression<int>? paidDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (termId != null) 'term_id': termId,
      if (expenseId != null) 'expense_id': expenseId,
      if (termName != null) 'term_name': termName,
      if (amount != null) 'amount': amount,
      if (dueDate != null) 'due_date': dueDate,
      if (isPaid != null) 'is_paid': isPaid,
      if (paidDate != null) 'paid_date': paidDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingPaymentTermsCompanion copyWith({
    Value<String>? termId,
    Value<String>? expenseId,
    Value<String>? termName,
    Value<double>? amount,
    Value<int>? dueDate,
    Value<bool>? isPaid,
    Value<int?>? paidDate,
    Value<int>? rowid,
  }) {
    return WeddingPaymentTermsCompanion(
      termId: termId ?? this.termId,
      expenseId: expenseId ?? this.expenseId,
      termName: termName ?? this.termName,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (termId.present) {
      map['term_id'] = Variable<String>(termId.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<String>(expenseId.value);
    }
    if (termName.present) {
      map['term_name'] = Variable<String>(termName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<int>(paidDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingPaymentTermsCompanion(')
          ..write('termId: $termId, ')
          ..write('expenseId: $expenseId, ')
          ..write('termName: $termName, ')
          ..write('amount: $amount, ')
          ..write('dueDate: $dueDate, ')
          ..write('isPaid: $isPaid, ')
          ..write('paidDate: $paidDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingGuestsTable extends WeddingGuests
    with TableInfo<$WeddingGuestsTable, WeddingGuestTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingGuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guestIdMeta = const VerificationMeta(
    'guestId',
  );
  @override
  late final GeneratedColumn<String> guestId = GeneratedColumn<String>(
    'guest_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingProfileIdMeta = const VerificationMeta(
    'weddingProfileId',
  );
  @override
  late final GeneratedColumn<String> weddingProfileId = GeneratedColumn<String>(
    'wedding_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _guestNameMeta = const VerificationMeta(
    'guestName',
  );
  @override
  late final GeneratedColumn<String> guestName = GeneratedColumn<String>(
    'guest_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupAllocationMeta = const VerificationMeta(
    'groupAllocation',
  );
  @override
  late final GeneratedColumn<String> groupAllocation = GeneratedColumn<String>(
    'group_allocation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('TEMAN_CPP'),
  );
  static const VerificationMeta _sessionTargetMeta = const VerificationMeta(
    'sessionTarget',
  );
  @override
  late final GeneratedColumn<String> sessionTarget = GeneratedColumn<String>(
    'session_target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('KEDUANYA'),
  );
  static const VerificationMeta _estimatedPaxMeta = const VerificationMeta(
    'estimatedPax',
  );
  @override
  late final GeneratedColumn<int> estimatedPax = GeneratedColumn<int>(
    'estimated_pax',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _rsvpStatusMeta = const VerificationMeta(
    'rsvpStatus',
  );
  @override
  late final GeneratedColumn<String> rsvpStatus = GeneratedColumn<String>(
    'rsvp_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    guestId,
    weddingProfileId,
    guestName,
    phoneNumber,
    groupAllocation,
    sessionTarget,
    estimatedPax,
    rsvpStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_guests';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingGuestTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guest_id')) {
      context.handle(
        _guestIdMeta,
        guestId.isAcceptableOrUnknown(data['guest_id']!, _guestIdMeta),
      );
    } else if (isInserting) {
      context.missing(_guestIdMeta);
    }
    if (data.containsKey('wedding_profile_id')) {
      context.handle(
        _weddingProfileIdMeta,
        weddingProfileId.isAcceptableOrUnknown(
          data['wedding_profile_id']!,
          _weddingProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingProfileIdMeta);
    }
    if (data.containsKey('guest_name')) {
      context.handle(
        _guestNameMeta,
        guestName.isAcceptableOrUnknown(data['guest_name']!, _guestNameMeta),
      );
    } else if (isInserting) {
      context.missing(_guestNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('group_allocation')) {
      context.handle(
        _groupAllocationMeta,
        groupAllocation.isAcceptableOrUnknown(
          data['group_allocation']!,
          _groupAllocationMeta,
        ),
      );
    }
    if (data.containsKey('session_target')) {
      context.handle(
        _sessionTargetMeta,
        sessionTarget.isAcceptableOrUnknown(
          data['session_target']!,
          _sessionTargetMeta,
        ),
      );
    }
    if (data.containsKey('estimated_pax')) {
      context.handle(
        _estimatedPaxMeta,
        estimatedPax.isAcceptableOrUnknown(
          data['estimated_pax']!,
          _estimatedPaxMeta,
        ),
      );
    }
    if (data.containsKey('rsvp_status')) {
      context.handle(
        _rsvpStatusMeta,
        rsvpStatus.isAcceptableOrUnknown(data['rsvp_status']!, _rsvpStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guestId};
  @override
  WeddingGuestTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingGuestTableData(
      guestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guest_id'],
      )!,
      weddingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wedding_profile_id'],
      )!,
      guestName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guest_name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      groupAllocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_allocation'],
      )!,
      sessionTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_target'],
      )!,
      estimatedPax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_pax'],
      )!,
      rsvpStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rsvp_status'],
      )!,
    );
  }

  @override
  $WeddingGuestsTable createAlias(String alias) {
    return $WeddingGuestsTable(attachedDatabase, alias);
  }
}

class WeddingGuestTableData extends DataClass
    implements Insertable<WeddingGuestTableData> {
  final String guestId;
  final String weddingProfileId;
  final String guestName;
  final String? phoneNumber;
  final String groupAllocation;
  final String sessionTarget;
  final int estimatedPax;
  final String rsvpStatus;
  const WeddingGuestTableData({
    required this.guestId,
    required this.weddingProfileId,
    required this.guestName,
    this.phoneNumber,
    required this.groupAllocation,
    required this.sessionTarget,
    required this.estimatedPax,
    required this.rsvpStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guest_id'] = Variable<String>(guestId);
    map['wedding_profile_id'] = Variable<String>(weddingProfileId);
    map['guest_name'] = Variable<String>(guestName);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    map['group_allocation'] = Variable<String>(groupAllocation);
    map['session_target'] = Variable<String>(sessionTarget);
    map['estimated_pax'] = Variable<int>(estimatedPax);
    map['rsvp_status'] = Variable<String>(rsvpStatus);
    return map;
  }

  WeddingGuestsCompanion toCompanion(bool nullToAbsent) {
    return WeddingGuestsCompanion(
      guestId: Value(guestId),
      weddingProfileId: Value(weddingProfileId),
      guestName: Value(guestName),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      groupAllocation: Value(groupAllocation),
      sessionTarget: Value(sessionTarget),
      estimatedPax: Value(estimatedPax),
      rsvpStatus: Value(rsvpStatus),
    );
  }

  factory WeddingGuestTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingGuestTableData(
      guestId: serializer.fromJson<String>(json['guestId']),
      weddingProfileId: serializer.fromJson<String>(json['weddingProfileId']),
      guestName: serializer.fromJson<String>(json['guestName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      groupAllocation: serializer.fromJson<String>(json['groupAllocation']),
      sessionTarget: serializer.fromJson<String>(json['sessionTarget']),
      estimatedPax: serializer.fromJson<int>(json['estimatedPax']),
      rsvpStatus: serializer.fromJson<String>(json['rsvpStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guestId': serializer.toJson<String>(guestId),
      'weddingProfileId': serializer.toJson<String>(weddingProfileId),
      'guestName': serializer.toJson<String>(guestName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'groupAllocation': serializer.toJson<String>(groupAllocation),
      'sessionTarget': serializer.toJson<String>(sessionTarget),
      'estimatedPax': serializer.toJson<int>(estimatedPax),
      'rsvpStatus': serializer.toJson<String>(rsvpStatus),
    };
  }

  WeddingGuestTableData copyWith({
    String? guestId,
    String? weddingProfileId,
    String? guestName,
    Value<String?> phoneNumber = const Value.absent(),
    String? groupAllocation,
    String? sessionTarget,
    int? estimatedPax,
    String? rsvpStatus,
  }) => WeddingGuestTableData(
    guestId: guestId ?? this.guestId,
    weddingProfileId: weddingProfileId ?? this.weddingProfileId,
    guestName: guestName ?? this.guestName,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    groupAllocation: groupAllocation ?? this.groupAllocation,
    sessionTarget: sessionTarget ?? this.sessionTarget,
    estimatedPax: estimatedPax ?? this.estimatedPax,
    rsvpStatus: rsvpStatus ?? this.rsvpStatus,
  );
  WeddingGuestTableData copyWithCompanion(WeddingGuestsCompanion data) {
    return WeddingGuestTableData(
      guestId: data.guestId.present ? data.guestId.value : this.guestId,
      weddingProfileId: data.weddingProfileId.present
          ? data.weddingProfileId.value
          : this.weddingProfileId,
      guestName: data.guestName.present ? data.guestName.value : this.guestName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      groupAllocation: data.groupAllocation.present
          ? data.groupAllocation.value
          : this.groupAllocation,
      sessionTarget: data.sessionTarget.present
          ? data.sessionTarget.value
          : this.sessionTarget,
      estimatedPax: data.estimatedPax.present
          ? data.estimatedPax.value
          : this.estimatedPax,
      rsvpStatus: data.rsvpStatus.present
          ? data.rsvpStatus.value
          : this.rsvpStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingGuestTableData(')
          ..write('guestId: $guestId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('guestName: $guestName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('groupAllocation: $groupAllocation, ')
          ..write('sessionTarget: $sessionTarget, ')
          ..write('estimatedPax: $estimatedPax, ')
          ..write('rsvpStatus: $rsvpStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    guestId,
    weddingProfileId,
    guestName,
    phoneNumber,
    groupAllocation,
    sessionTarget,
    estimatedPax,
    rsvpStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingGuestTableData &&
          other.guestId == this.guestId &&
          other.weddingProfileId == this.weddingProfileId &&
          other.guestName == this.guestName &&
          other.phoneNumber == this.phoneNumber &&
          other.groupAllocation == this.groupAllocation &&
          other.sessionTarget == this.sessionTarget &&
          other.estimatedPax == this.estimatedPax &&
          other.rsvpStatus == this.rsvpStatus);
}

class WeddingGuestsCompanion extends UpdateCompanion<WeddingGuestTableData> {
  final Value<String> guestId;
  final Value<String> weddingProfileId;
  final Value<String> guestName;
  final Value<String?> phoneNumber;
  final Value<String> groupAllocation;
  final Value<String> sessionTarget;
  final Value<int> estimatedPax;
  final Value<String> rsvpStatus;
  final Value<int> rowid;
  const WeddingGuestsCompanion({
    this.guestId = const Value.absent(),
    this.weddingProfileId = const Value.absent(),
    this.guestName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.groupAllocation = const Value.absent(),
    this.sessionTarget = const Value.absent(),
    this.estimatedPax = const Value.absent(),
    this.rsvpStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingGuestsCompanion.insert({
    required String guestId,
    required String weddingProfileId,
    required String guestName,
    this.phoneNumber = const Value.absent(),
    this.groupAllocation = const Value.absent(),
    this.sessionTarget = const Value.absent(),
    this.estimatedPax = const Value.absent(),
    this.rsvpStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : guestId = Value(guestId),
       weddingProfileId = Value(weddingProfileId),
       guestName = Value(guestName);
  static Insertable<WeddingGuestTableData> custom({
    Expression<String>? guestId,
    Expression<String>? weddingProfileId,
    Expression<String>? guestName,
    Expression<String>? phoneNumber,
    Expression<String>? groupAllocation,
    Expression<String>? sessionTarget,
    Expression<int>? estimatedPax,
    Expression<String>? rsvpStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guestId != null) 'guest_id': guestId,
      if (weddingProfileId != null) 'wedding_profile_id': weddingProfileId,
      if (guestName != null) 'guest_name': guestName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (groupAllocation != null) 'group_allocation': groupAllocation,
      if (sessionTarget != null) 'session_target': sessionTarget,
      if (estimatedPax != null) 'estimated_pax': estimatedPax,
      if (rsvpStatus != null) 'rsvp_status': rsvpStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingGuestsCompanion copyWith({
    Value<String>? guestId,
    Value<String>? weddingProfileId,
    Value<String>? guestName,
    Value<String?>? phoneNumber,
    Value<String>? groupAllocation,
    Value<String>? sessionTarget,
    Value<int>? estimatedPax,
    Value<String>? rsvpStatus,
    Value<int>? rowid,
  }) {
    return WeddingGuestsCompanion(
      guestId: guestId ?? this.guestId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      guestName: guestName ?? this.guestName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      groupAllocation: groupAllocation ?? this.groupAllocation,
      sessionTarget: sessionTarget ?? this.sessionTarget,
      estimatedPax: estimatedPax ?? this.estimatedPax,
      rsvpStatus: rsvpStatus ?? this.rsvpStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guestId.present) {
      map['guest_id'] = Variable<String>(guestId.value);
    }
    if (weddingProfileId.present) {
      map['wedding_profile_id'] = Variable<String>(weddingProfileId.value);
    }
    if (guestName.present) {
      map['guest_name'] = Variable<String>(guestName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (groupAllocation.present) {
      map['group_allocation'] = Variable<String>(groupAllocation.value);
    }
    if (sessionTarget.present) {
      map['session_target'] = Variable<String>(sessionTarget.value);
    }
    if (estimatedPax.present) {
      map['estimated_pax'] = Variable<int>(estimatedPax.value);
    }
    if (rsvpStatus.present) {
      map['rsvp_status'] = Variable<String>(rsvpStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingGuestsCompanion(')
          ..write('guestId: $guestId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('guestName: $guestName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('groupAllocation: $groupAllocation, ')
          ..write('sessionTarget: $sessionTarget, ')
          ..write('estimatedPax: $estimatedPax, ')
          ..write('rsvpStatus: $rsvpStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingVendorsTable extends WeddingVendors
    with TableInfo<$WeddingVendorsTable, WeddingVendorTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingVendorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<String> vendorId = GeneratedColumn<String>(
    'vendor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingProfileIdMeta = const VerificationMeta(
    'weddingProfileId',
  );
  @override
  late final GeneratedColumn<String> weddingProfileId = GeneratedColumn<String>(
    'wedding_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _picNameMeta = const VerificationMeta(
    'picName',
  );
  @override
  late final GeneratedColumn<String> picName = GeneratedColumn<String>(
    'pic_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instagramHandleMeta = const VerificationMeta(
    'instagramHandle',
  );
  @override
  late final GeneratedColumn<String> instagramHandle = GeneratedColumn<String>(
    'instagram_handle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractValueMeta = const VerificationMeta(
    'contractValue',
  );
  @override
  late final GeneratedColumn<double> contractValue = GeneratedColumn<double>(
    'contract_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PROSPEK'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    vendorId,
    weddingProfileId,
    category,
    name,
    picName,
    phoneNumber,
    instagramHandle,
    contractValue,
    notes,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_vendors';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingVendorTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorIdMeta);
    }
    if (data.containsKey('wedding_profile_id')) {
      context.handle(
        _weddingProfileIdMeta,
        weddingProfileId.isAcceptableOrUnknown(
          data['wedding_profile_id']!,
          _weddingProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingProfileIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pic_name')) {
      context.handle(
        _picNameMeta,
        picName.isAcceptableOrUnknown(data['pic_name']!, _picNameMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('instagram_handle')) {
      context.handle(
        _instagramHandleMeta,
        instagramHandle.isAcceptableOrUnknown(
          data['instagram_handle']!,
          _instagramHandleMeta,
        ),
      );
    }
    if (data.containsKey('contract_value')) {
      context.handle(
        _contractValueMeta,
        contractValue.isAcceptableOrUnknown(
          data['contract_value']!,
          _contractValueMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vendorId};
  @override
  WeddingVendorTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingVendorTableData(
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_id'],
      )!,
      weddingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wedding_profile_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      picName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pic_name'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      instagramHandle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instagram_handle'],
      ),
      contractValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}contract_value'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeddingVendorsTable createAlias(String alias) {
    return $WeddingVendorsTable(attachedDatabase, alias);
  }
}

class WeddingVendorTableData extends DataClass
    implements Insertable<WeddingVendorTableData> {
  final String vendorId;
  final String weddingProfileId;
  final String category;
  final String name;
  final String? picName;
  final String? phoneNumber;
  final String? instagramHandle;
  final double contractValue;
  final String? notes;
  final String status;
  final int createdAt;
  const WeddingVendorTableData({
    required this.vendorId,
    required this.weddingProfileId,
    required this.category,
    required this.name,
    this.picName,
    this.phoneNumber,
    this.instagramHandle,
    required this.contractValue,
    this.notes,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vendor_id'] = Variable<String>(vendorId);
    map['wedding_profile_id'] = Variable<String>(weddingProfileId);
    map['category'] = Variable<String>(category);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || picName != null) {
      map['pic_name'] = Variable<String>(picName);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || instagramHandle != null) {
      map['instagram_handle'] = Variable<String>(instagramHandle);
    }
    map['contract_value'] = Variable<double>(contractValue);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  WeddingVendorsCompanion toCompanion(bool nullToAbsent) {
    return WeddingVendorsCompanion(
      vendorId: Value(vendorId),
      weddingProfileId: Value(weddingProfileId),
      category: Value(category),
      name: Value(name),
      picName: picName == null && nullToAbsent
          ? const Value.absent()
          : Value(picName),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      instagramHandle: instagramHandle == null && nullToAbsent
          ? const Value.absent()
          : Value(instagramHandle),
      contractValue: Value(contractValue),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory WeddingVendorTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingVendorTableData(
      vendorId: serializer.fromJson<String>(json['vendorId']),
      weddingProfileId: serializer.fromJson<String>(json['weddingProfileId']),
      category: serializer.fromJson<String>(json['category']),
      name: serializer.fromJson<String>(json['name']),
      picName: serializer.fromJson<String?>(json['picName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      instagramHandle: serializer.fromJson<String?>(json['instagramHandle']),
      contractValue: serializer.fromJson<double>(json['contractValue']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vendorId': serializer.toJson<String>(vendorId),
      'weddingProfileId': serializer.toJson<String>(weddingProfileId),
      'category': serializer.toJson<String>(category),
      'name': serializer.toJson<String>(name),
      'picName': serializer.toJson<String?>(picName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'instagramHandle': serializer.toJson<String?>(instagramHandle),
      'contractValue': serializer.toJson<double>(contractValue),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  WeddingVendorTableData copyWith({
    String? vendorId,
    String? weddingProfileId,
    String? category,
    String? name,
    Value<String?> picName = const Value.absent(),
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> instagramHandle = const Value.absent(),
    double? contractValue,
    Value<String?> notes = const Value.absent(),
    String? status,
    int? createdAt,
  }) => WeddingVendorTableData(
    vendorId: vendorId ?? this.vendorId,
    weddingProfileId: weddingProfileId ?? this.weddingProfileId,
    category: category ?? this.category,
    name: name ?? this.name,
    picName: picName.present ? picName.value : this.picName,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    instagramHandle: instagramHandle.present
        ? instagramHandle.value
        : this.instagramHandle,
    contractValue: contractValue ?? this.contractValue,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  WeddingVendorTableData copyWithCompanion(WeddingVendorsCompanion data) {
    return WeddingVendorTableData(
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      weddingProfileId: data.weddingProfileId.present
          ? data.weddingProfileId.value
          : this.weddingProfileId,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
      picName: data.picName.present ? data.picName.value : this.picName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      instagramHandle: data.instagramHandle.present
          ? data.instagramHandle.value
          : this.instagramHandle,
      contractValue: data.contractValue.present
          ? data.contractValue.value
          : this.contractValue,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingVendorTableData(')
          ..write('vendorId: $vendorId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('picName: $picName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('instagramHandle: $instagramHandle, ')
          ..write('contractValue: $contractValue, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    vendorId,
    weddingProfileId,
    category,
    name,
    picName,
    phoneNumber,
    instagramHandle,
    contractValue,
    notes,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingVendorTableData &&
          other.vendorId == this.vendorId &&
          other.weddingProfileId == this.weddingProfileId &&
          other.category == this.category &&
          other.name == this.name &&
          other.picName == this.picName &&
          other.phoneNumber == this.phoneNumber &&
          other.instagramHandle == this.instagramHandle &&
          other.contractValue == this.contractValue &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class WeddingVendorsCompanion extends UpdateCompanion<WeddingVendorTableData> {
  final Value<String> vendorId;
  final Value<String> weddingProfileId;
  final Value<String> category;
  final Value<String> name;
  final Value<String?> picName;
  final Value<String?> phoneNumber;
  final Value<String?> instagramHandle;
  final Value<double> contractValue;
  final Value<String?> notes;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> rowid;
  const WeddingVendorsCompanion({
    this.vendorId = const Value.absent(),
    this.weddingProfileId = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.picName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.instagramHandle = const Value.absent(),
    this.contractValue = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingVendorsCompanion.insert({
    required String vendorId,
    required String weddingProfileId,
    required String category,
    required String name,
    this.picName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.instagramHandle = const Value.absent(),
    this.contractValue = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : vendorId = Value(vendorId),
       weddingProfileId = Value(weddingProfileId),
       category = Value(category),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<WeddingVendorTableData> custom({
    Expression<String>? vendorId,
    Expression<String>? weddingProfileId,
    Expression<String>? category,
    Expression<String>? name,
    Expression<String>? picName,
    Expression<String>? phoneNumber,
    Expression<String>? instagramHandle,
    Expression<double>? contractValue,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vendorId != null) 'vendor_id': vendorId,
      if (weddingProfileId != null) 'wedding_profile_id': weddingProfileId,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
      if (picName != null) 'pic_name': picName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (instagramHandle != null) 'instagram_handle': instagramHandle,
      if (contractValue != null) 'contract_value': contractValue,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingVendorsCompanion copyWith({
    Value<String>? vendorId,
    Value<String>? weddingProfileId,
    Value<String>? category,
    Value<String>? name,
    Value<String?>? picName,
    Value<String?>? phoneNumber,
    Value<String?>? instagramHandle,
    Value<double>? contractValue,
    Value<String?>? notes,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return WeddingVendorsCompanion(
      vendorId: vendorId ?? this.vendorId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      category: category ?? this.category,
      name: name ?? this.name,
      picName: picName ?? this.picName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      contractValue: contractValue ?? this.contractValue,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vendorId.present) {
      map['vendor_id'] = Variable<String>(vendorId.value);
    }
    if (weddingProfileId.present) {
      map['wedding_profile_id'] = Variable<String>(weddingProfileId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (picName.present) {
      map['pic_name'] = Variable<String>(picName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (instagramHandle.present) {
      map['instagram_handle'] = Variable<String>(instagramHandle.value);
    }
    if (contractValue.present) {
      map['contract_value'] = Variable<double>(contractValue.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingVendorsCompanion(')
          ..write('vendorId: $vendorId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('picName: $picName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('instagramHandle: $instagramHandle, ')
          ..write('contractValue: $contractValue, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingTasksTable extends WeddingTasks
    with TableInfo<$WeddingTasksTable, WeddingTaskTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingProfileIdMeta = const VerificationMeta(
    'weddingProfileId',
  );
  @override
  late final GeneratedColumn<String> weddingProfileId = GeneratedColumn<String>(
    'wedding_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _phaseMonthMeta = const VerificationMeta(
    'phaseMonth',
  );
  @override
  late final GeneratedColumn<int> phaseMonth = GeneratedColumn<int>(
    'phase_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _picMeta = const VerificationMeta('pic');
  @override
  late final GeneratedColumn<String> pic = GeneratedColumn<String>(
    'pic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BOTH'),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedDateMeta = const VerificationMeta(
    'completedDate',
  );
  @override
  late final GeneratedColumn<int> completedDate = GeneratedColumn<int>(
    'completed_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    taskId,
    weddingProfileId,
    phaseMonth,
    title,
    description,
    pic,
    isCompleted,
    dueDate,
    completedDate,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingTaskTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('wedding_profile_id')) {
      context.handle(
        _weddingProfileIdMeta,
        weddingProfileId.isAcceptableOrUnknown(
          data['wedding_profile_id']!,
          _weddingProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingProfileIdMeta);
    }
    if (data.containsKey('phase_month')) {
      context.handle(
        _phaseMonthMeta,
        phaseMonth.isAcceptableOrUnknown(data['phase_month']!, _phaseMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMonthMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('pic')) {
      context.handle(
        _picMeta,
        pic.isAcceptableOrUnknown(data['pic']!, _picMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('completed_date')) {
      context.handle(
        _completedDateMeta,
        completedDate.isAcceptableOrUnknown(
          data['completed_date']!,
          _completedDateMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  WeddingTaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingTaskTableData(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      weddingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wedding_profile_id'],
      )!,
      phaseMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase_month'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      pic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pic'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
      ),
      completedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_date'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WeddingTasksTable createAlias(String alias) {
    return $WeddingTasksTable(attachedDatabase, alias);
  }
}

class WeddingTaskTableData extends DataClass
    implements Insertable<WeddingTaskTableData> {
  final String taskId;
  final String weddingProfileId;
  final int phaseMonth;
  final String title;
  final String? description;
  final String pic;
  final bool isCompleted;
  final int? dueDate;
  final int? completedDate;
  final int sortOrder;
  const WeddingTaskTableData({
    required this.taskId,
    required this.weddingProfileId,
    required this.phaseMonth,
    required this.title,
    this.description,
    required this.pic,
    required this.isCompleted,
    this.dueDate,
    this.completedDate,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['wedding_profile_id'] = Variable<String>(weddingProfileId);
    map['phase_month'] = Variable<int>(phaseMonth);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['pic'] = Variable<String>(pic);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<int>(dueDate);
    }
    if (!nullToAbsent || completedDate != null) {
      map['completed_date'] = Variable<int>(completedDate);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WeddingTasksCompanion toCompanion(bool nullToAbsent) {
    return WeddingTasksCompanion(
      taskId: Value(taskId),
      weddingProfileId: Value(weddingProfileId),
      phaseMonth: Value(phaseMonth),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      pic: Value(pic),
      isCompleted: Value(isCompleted),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      completedDate: completedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDate),
      sortOrder: Value(sortOrder),
    );
  }

  factory WeddingTaskTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingTaskTableData(
      taskId: serializer.fromJson<String>(json['taskId']),
      weddingProfileId: serializer.fromJson<String>(json['weddingProfileId']),
      phaseMonth: serializer.fromJson<int>(json['phaseMonth']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      pic: serializer.fromJson<String>(json['pic']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      dueDate: serializer.fromJson<int?>(json['dueDate']),
      completedDate: serializer.fromJson<int?>(json['completedDate']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'weddingProfileId': serializer.toJson<String>(weddingProfileId),
      'phaseMonth': serializer.toJson<int>(phaseMonth),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'pic': serializer.toJson<String>(pic),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'dueDate': serializer.toJson<int?>(dueDate),
      'completedDate': serializer.toJson<int?>(completedDate),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WeddingTaskTableData copyWith({
    String? taskId,
    String? weddingProfileId,
    int? phaseMonth,
    String? title,
    Value<String?> description = const Value.absent(),
    String? pic,
    bool? isCompleted,
    Value<int?> dueDate = const Value.absent(),
    Value<int?> completedDate = const Value.absent(),
    int? sortOrder,
  }) => WeddingTaskTableData(
    taskId: taskId ?? this.taskId,
    weddingProfileId: weddingProfileId ?? this.weddingProfileId,
    phaseMonth: phaseMonth ?? this.phaseMonth,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    pic: pic ?? this.pic,
    isCompleted: isCompleted ?? this.isCompleted,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    completedDate: completedDate.present
        ? completedDate.value
        : this.completedDate,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WeddingTaskTableData copyWithCompanion(WeddingTasksCompanion data) {
    return WeddingTaskTableData(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      weddingProfileId: data.weddingProfileId.present
          ? data.weddingProfileId.value
          : this.weddingProfileId,
      phaseMonth: data.phaseMonth.present
          ? data.phaseMonth.value
          : this.phaseMonth,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      pic: data.pic.present ? data.pic.value : this.pic,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      completedDate: data.completedDate.present
          ? data.completedDate.value
          : this.completedDate,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingTaskTableData(')
          ..write('taskId: $taskId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('phaseMonth: $phaseMonth, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('pic: $pic, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('dueDate: $dueDate, ')
          ..write('completedDate: $completedDate, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    taskId,
    weddingProfileId,
    phaseMonth,
    title,
    description,
    pic,
    isCompleted,
    dueDate,
    completedDate,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingTaskTableData &&
          other.taskId == this.taskId &&
          other.weddingProfileId == this.weddingProfileId &&
          other.phaseMonth == this.phaseMonth &&
          other.title == this.title &&
          other.description == this.description &&
          other.pic == this.pic &&
          other.isCompleted == this.isCompleted &&
          other.dueDate == this.dueDate &&
          other.completedDate == this.completedDate &&
          other.sortOrder == this.sortOrder);
}

class WeddingTasksCompanion extends UpdateCompanion<WeddingTaskTableData> {
  final Value<String> taskId;
  final Value<String> weddingProfileId;
  final Value<int> phaseMonth;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> pic;
  final Value<bool> isCompleted;
  final Value<int?> dueDate;
  final Value<int?> completedDate;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WeddingTasksCompanion({
    this.taskId = const Value.absent(),
    this.weddingProfileId = const Value.absent(),
    this.phaseMonth = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.pic = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completedDate = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingTasksCompanion.insert({
    required String taskId,
    required String weddingProfileId,
    required int phaseMonth,
    required String title,
    this.description = const Value.absent(),
    this.pic = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.completedDate = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       weddingProfileId = Value(weddingProfileId),
       phaseMonth = Value(phaseMonth),
       title = Value(title);
  static Insertable<WeddingTaskTableData> custom({
    Expression<String>? taskId,
    Expression<String>? weddingProfileId,
    Expression<int>? phaseMonth,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? pic,
    Expression<bool>? isCompleted,
    Expression<int>? dueDate,
    Expression<int>? completedDate,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (weddingProfileId != null) 'wedding_profile_id': weddingProfileId,
      if (phaseMonth != null) 'phase_month': phaseMonth,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (pic != null) 'pic': pic,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (dueDate != null) 'due_date': dueDate,
      if (completedDate != null) 'completed_date': completedDate,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingTasksCompanion copyWith({
    Value<String>? taskId,
    Value<String>? weddingProfileId,
    Value<int>? phaseMonth,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? pic,
    Value<bool>? isCompleted,
    Value<int?>? dueDate,
    Value<int?>? completedDate,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WeddingTasksCompanion(
      taskId: taskId ?? this.taskId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      phaseMonth: phaseMonth ?? this.phaseMonth,
      title: title ?? this.title,
      description: description ?? this.description,
      pic: pic ?? this.pic,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      completedDate: completedDate ?? this.completedDate,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (weddingProfileId.present) {
      map['wedding_profile_id'] = Variable<String>(weddingProfileId.value);
    }
    if (phaseMonth.present) {
      map['phase_month'] = Variable<int>(phaseMonth.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (pic.present) {
      map['pic'] = Variable<String>(pic.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (completedDate.present) {
      map['completed_date'] = Variable<int>(completedDate.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingTasksCompanion(')
          ..write('taskId: $taskId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('phaseMonth: $phaseMonth, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('pic: $pic, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('dueDate: $dueDate, ')
          ..write('completedDate: $completedDate, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingCommitteeMembersTable extends WeddingCommitteeMembers
    with TableInfo<$WeddingCommitteeMembersTable, WeddingCommitteeTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingCommitteeMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingProfileIdMeta = const VerificationMeta(
    'weddingProfileId',
  );
  @override
  late final GeneratedColumn<String> weddingProfileId = GeneratedColumn<String>(
    'wedding_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _memberNameMeta = const VerificationMeta(
    'memberName',
  );
  @override
  late final GeneratedColumn<String> memberName = GeneratedColumn<String>(
    'member_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sideMeta = const VerificationMeta('side');
  @override
  late final GeneratedColumn<String> side = GeneratedColumn<String>(
    'side',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('KELUARGA_CPP'),
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uniformDescriptionMeta =
      const VerificationMeta('uniformDescription');
  @override
  late final GeneratedColumn<String> uniformDescription =
      GeneratedColumn<String>(
        'uniform_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fabricMetersMeta = const VerificationMeta(
    'fabricMeters',
  );
  @override
  late final GeneratedColumn<double> fabricMeters = GeneratedColumn<double>(
    'fabric_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _uniformStatusMeta = const VerificationMeta(
    'uniformStatus',
  );
  @override
  late final GeneratedColumn<String> uniformStatus = GeneratedColumn<String>(
    'uniform_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BELUM_DIBAGI'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    memberId,
    weddingProfileId,
    memberName,
    role,
    side,
    phoneNumber,
    uniformDescription,
    fabricMeters,
    uniformStatus,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_committee_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingCommitteeTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('wedding_profile_id')) {
      context.handle(
        _weddingProfileIdMeta,
        weddingProfileId.isAcceptableOrUnknown(
          data['wedding_profile_id']!,
          _weddingProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingProfileIdMeta);
    }
    if (data.containsKey('member_name')) {
      context.handle(
        _memberNameMeta,
        memberName.isAcceptableOrUnknown(data['member_name']!, _memberNameMeta),
      );
    } else if (isInserting) {
      context.missing(_memberNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('side')) {
      context.handle(
        _sideMeta,
        side.isAcceptableOrUnknown(data['side']!, _sideMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('uniform_description')) {
      context.handle(
        _uniformDescriptionMeta,
        uniformDescription.isAcceptableOrUnknown(
          data['uniform_description']!,
          _uniformDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('fabric_meters')) {
      context.handle(
        _fabricMetersMeta,
        fabricMeters.isAcceptableOrUnknown(
          data['fabric_meters']!,
          _fabricMetersMeta,
        ),
      );
    }
    if (data.containsKey('uniform_status')) {
      context.handle(
        _uniformStatusMeta,
        uniformStatus.isAcceptableOrUnknown(
          data['uniform_status']!,
          _uniformStatusMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {memberId};
  @override
  WeddingCommitteeTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingCommitteeTableData(
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      weddingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wedding_profile_id'],
      )!,
      memberName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      side: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}side'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      uniformDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uniform_description'],
      ),
      fabricMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fabric_meters'],
      )!,
      uniformStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uniform_status'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WeddingCommitteeMembersTable createAlias(String alias) {
    return $WeddingCommitteeMembersTable(attachedDatabase, alias);
  }
}

class WeddingCommitteeTableData extends DataClass
    implements Insertable<WeddingCommitteeTableData> {
  final String memberId;
  final String weddingProfileId;
  final String memberName;
  final String role;
  final String side;
  final String? phoneNumber;
  final String? uniformDescription;
  final double fabricMeters;
  final String uniformStatus;
  final int sortOrder;
  const WeddingCommitteeTableData({
    required this.memberId,
    required this.weddingProfileId,
    required this.memberName,
    required this.role,
    required this.side,
    this.phoneNumber,
    this.uniformDescription,
    required this.fabricMeters,
    required this.uniformStatus,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['member_id'] = Variable<String>(memberId);
    map['wedding_profile_id'] = Variable<String>(weddingProfileId);
    map['member_name'] = Variable<String>(memberName);
    map['role'] = Variable<String>(role);
    map['side'] = Variable<String>(side);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || uniformDescription != null) {
      map['uniform_description'] = Variable<String>(uniformDescription);
    }
    map['fabric_meters'] = Variable<double>(fabricMeters);
    map['uniform_status'] = Variable<String>(uniformStatus);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WeddingCommitteeMembersCompanion toCompanion(bool nullToAbsent) {
    return WeddingCommitteeMembersCompanion(
      memberId: Value(memberId),
      weddingProfileId: Value(weddingProfileId),
      memberName: Value(memberName),
      role: Value(role),
      side: Value(side),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      uniformDescription: uniformDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(uniformDescription),
      fabricMeters: Value(fabricMeters),
      uniformStatus: Value(uniformStatus),
      sortOrder: Value(sortOrder),
    );
  }

  factory WeddingCommitteeTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingCommitteeTableData(
      memberId: serializer.fromJson<String>(json['memberId']),
      weddingProfileId: serializer.fromJson<String>(json['weddingProfileId']),
      memberName: serializer.fromJson<String>(json['memberName']),
      role: serializer.fromJson<String>(json['role']),
      side: serializer.fromJson<String>(json['side']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      uniformDescription: serializer.fromJson<String?>(
        json['uniformDescription'],
      ),
      fabricMeters: serializer.fromJson<double>(json['fabricMeters']),
      uniformStatus: serializer.fromJson<String>(json['uniformStatus']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'memberId': serializer.toJson<String>(memberId),
      'weddingProfileId': serializer.toJson<String>(weddingProfileId),
      'memberName': serializer.toJson<String>(memberName),
      'role': serializer.toJson<String>(role),
      'side': serializer.toJson<String>(side),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'uniformDescription': serializer.toJson<String?>(uniformDescription),
      'fabricMeters': serializer.toJson<double>(fabricMeters),
      'uniformStatus': serializer.toJson<String>(uniformStatus),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WeddingCommitteeTableData copyWith({
    String? memberId,
    String? weddingProfileId,
    String? memberName,
    String? role,
    String? side,
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> uniformDescription = const Value.absent(),
    double? fabricMeters,
    String? uniformStatus,
    int? sortOrder,
  }) => WeddingCommitteeTableData(
    memberId: memberId ?? this.memberId,
    weddingProfileId: weddingProfileId ?? this.weddingProfileId,
    memberName: memberName ?? this.memberName,
    role: role ?? this.role,
    side: side ?? this.side,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    uniformDescription: uniformDescription.present
        ? uniformDescription.value
        : this.uniformDescription,
    fabricMeters: fabricMeters ?? this.fabricMeters,
    uniformStatus: uniformStatus ?? this.uniformStatus,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WeddingCommitteeTableData copyWithCompanion(
    WeddingCommitteeMembersCompanion data,
  ) {
    return WeddingCommitteeTableData(
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      weddingProfileId: data.weddingProfileId.present
          ? data.weddingProfileId.value
          : this.weddingProfileId,
      memberName: data.memberName.present
          ? data.memberName.value
          : this.memberName,
      role: data.role.present ? data.role.value : this.role,
      side: data.side.present ? data.side.value : this.side,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      uniformDescription: data.uniformDescription.present
          ? data.uniformDescription.value
          : this.uniformDescription,
      fabricMeters: data.fabricMeters.present
          ? data.fabricMeters.value
          : this.fabricMeters,
      uniformStatus: data.uniformStatus.present
          ? data.uniformStatus.value
          : this.uniformStatus,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingCommitteeTableData(')
          ..write('memberId: $memberId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('memberName: $memberName, ')
          ..write('role: $role, ')
          ..write('side: $side, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('uniformDescription: $uniformDescription, ')
          ..write('fabricMeters: $fabricMeters, ')
          ..write('uniformStatus: $uniformStatus, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    memberId,
    weddingProfileId,
    memberName,
    role,
    side,
    phoneNumber,
    uniformDescription,
    fabricMeters,
    uniformStatus,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingCommitteeTableData &&
          other.memberId == this.memberId &&
          other.weddingProfileId == this.weddingProfileId &&
          other.memberName == this.memberName &&
          other.role == this.role &&
          other.side == this.side &&
          other.phoneNumber == this.phoneNumber &&
          other.uniformDescription == this.uniformDescription &&
          other.fabricMeters == this.fabricMeters &&
          other.uniformStatus == this.uniformStatus &&
          other.sortOrder == this.sortOrder);
}

class WeddingCommitteeMembersCompanion
    extends UpdateCompanion<WeddingCommitteeTableData> {
  final Value<String> memberId;
  final Value<String> weddingProfileId;
  final Value<String> memberName;
  final Value<String> role;
  final Value<String> side;
  final Value<String?> phoneNumber;
  final Value<String?> uniformDescription;
  final Value<double> fabricMeters;
  final Value<String> uniformStatus;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WeddingCommitteeMembersCompanion({
    this.memberId = const Value.absent(),
    this.weddingProfileId = const Value.absent(),
    this.memberName = const Value.absent(),
    this.role = const Value.absent(),
    this.side = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.uniformDescription = const Value.absent(),
    this.fabricMeters = const Value.absent(),
    this.uniformStatus = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingCommitteeMembersCompanion.insert({
    required String memberId,
    required String weddingProfileId,
    required String memberName,
    required String role,
    this.side = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.uniformDescription = const Value.absent(),
    this.fabricMeters = const Value.absent(),
    this.uniformStatus = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : memberId = Value(memberId),
       weddingProfileId = Value(weddingProfileId),
       memberName = Value(memberName),
       role = Value(role);
  static Insertable<WeddingCommitteeTableData> custom({
    Expression<String>? memberId,
    Expression<String>? weddingProfileId,
    Expression<String>? memberName,
    Expression<String>? role,
    Expression<String>? side,
    Expression<String>? phoneNumber,
    Expression<String>? uniformDescription,
    Expression<double>? fabricMeters,
    Expression<String>? uniformStatus,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (memberId != null) 'member_id': memberId,
      if (weddingProfileId != null) 'wedding_profile_id': weddingProfileId,
      if (memberName != null) 'member_name': memberName,
      if (role != null) 'role': role,
      if (side != null) 'side': side,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (uniformDescription != null) 'uniform_description': uniformDescription,
      if (fabricMeters != null) 'fabric_meters': fabricMeters,
      if (uniformStatus != null) 'uniform_status': uniformStatus,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingCommitteeMembersCompanion copyWith({
    Value<String>? memberId,
    Value<String>? weddingProfileId,
    Value<String>? memberName,
    Value<String>? role,
    Value<String>? side,
    Value<String?>? phoneNumber,
    Value<String?>? uniformDescription,
    Value<double>? fabricMeters,
    Value<String>? uniformStatus,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WeddingCommitteeMembersCompanion(
      memberId: memberId ?? this.memberId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      memberName: memberName ?? this.memberName,
      role: role ?? this.role,
      side: side ?? this.side,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uniformDescription: uniformDescription ?? this.uniformDescription,
      fabricMeters: fabricMeters ?? this.fabricMeters,
      uniformStatus: uniformStatus ?? this.uniformStatus,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (weddingProfileId.present) {
      map['wedding_profile_id'] = Variable<String>(weddingProfileId.value);
    }
    if (memberName.present) {
      map['member_name'] = Variable<String>(memberName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (side.present) {
      map['side'] = Variable<String>(side.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (uniformDescription.present) {
      map['uniform_description'] = Variable<String>(uniformDescription.value);
    }
    if (fabricMeters.present) {
      map['fabric_meters'] = Variable<double>(fabricMeters.value);
    }
    if (uniformStatus.present) {
      map['uniform_status'] = Variable<String>(uniformStatus.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingCommitteeMembersCompanion(')
          ..write('memberId: $memberId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('memberName: $memberName, ')
          ..write('role: $role, ')
          ..write('side: $side, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('uniformDescription: $uniformDescription, ')
          ..write('fabricMeters: $fabricMeters, ')
          ..write('uniformStatus: $uniformStatus, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingEventsTable extends WeddingEvents
    with TableInfo<$WeddingEventsTable, WeddingEventTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingProfileIdMeta = const VerificationMeta(
    'weddingProfileId',
  );
  @override
  late final GeneratedColumn<String> weddingProfileId = GeneratedColumn<String>(
    'wedding_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _eventNameMeta = const VerificationMeta(
    'eventName',
  );
  @override
  late final GeneratedColumn<String> eventName = GeneratedColumn<String>(
    'event_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<int> eventDate = GeneratedColumn<int>(
    'event_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventLocationMeta = const VerificationMeta(
    'eventLocation',
  );
  @override
  late final GeneratedColumn<String> eventLocation = GeneratedColumn<String>(
    'event_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    weddingProfileId,
    eventName,
    eventDate,
    eventLocation,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingEventTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('wedding_profile_id')) {
      context.handle(
        _weddingProfileIdMeta,
        weddingProfileId.isAcceptableOrUnknown(
          data['wedding_profile_id']!,
          _weddingProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingProfileIdMeta);
    }
    if (data.containsKey('event_name')) {
      context.handle(
        _eventNameMeta,
        eventName.isAcceptableOrUnknown(data['event_name']!, _eventNameMeta),
      );
    } else if (isInserting) {
      context.missing(_eventNameMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('event_location')) {
      context.handle(
        _eventLocationMeta,
        eventLocation.isAcceptableOrUnknown(
          data['event_location']!,
          _eventLocationMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  WeddingEventTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingEventTableData(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      weddingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wedding_profile_id'],
      )!,
      eventName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_name'],
      )!,
      eventDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_date'],
      )!,
      eventLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_location'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WeddingEventsTable createAlias(String alias) {
    return $WeddingEventsTable(attachedDatabase, alias);
  }
}

class WeddingEventTableData extends DataClass
    implements Insertable<WeddingEventTableData> {
  final String eventId;
  final String weddingProfileId;
  final String eventName;
  final int eventDate;
  final String? eventLocation;
  final int sortOrder;
  const WeddingEventTableData({
    required this.eventId,
    required this.weddingProfileId,
    required this.eventName,
    required this.eventDate,
    this.eventLocation,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['wedding_profile_id'] = Variable<String>(weddingProfileId);
    map['event_name'] = Variable<String>(eventName);
    map['event_date'] = Variable<int>(eventDate);
    if (!nullToAbsent || eventLocation != null) {
      map['event_location'] = Variable<String>(eventLocation);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WeddingEventsCompanion toCompanion(bool nullToAbsent) {
    return WeddingEventsCompanion(
      eventId: Value(eventId),
      weddingProfileId: Value(weddingProfileId),
      eventName: Value(eventName),
      eventDate: Value(eventDate),
      eventLocation: eventLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(eventLocation),
      sortOrder: Value(sortOrder),
    );
  }

  factory WeddingEventTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingEventTableData(
      eventId: serializer.fromJson<String>(json['eventId']),
      weddingProfileId: serializer.fromJson<String>(json['weddingProfileId']),
      eventName: serializer.fromJson<String>(json['eventName']),
      eventDate: serializer.fromJson<int>(json['eventDate']),
      eventLocation: serializer.fromJson<String?>(json['eventLocation']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'weddingProfileId': serializer.toJson<String>(weddingProfileId),
      'eventName': serializer.toJson<String>(eventName),
      'eventDate': serializer.toJson<int>(eventDate),
      'eventLocation': serializer.toJson<String?>(eventLocation),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WeddingEventTableData copyWith({
    String? eventId,
    String? weddingProfileId,
    String? eventName,
    int? eventDate,
    Value<String?> eventLocation = const Value.absent(),
    int? sortOrder,
  }) => WeddingEventTableData(
    eventId: eventId ?? this.eventId,
    weddingProfileId: weddingProfileId ?? this.weddingProfileId,
    eventName: eventName ?? this.eventName,
    eventDate: eventDate ?? this.eventDate,
    eventLocation: eventLocation.present
        ? eventLocation.value
        : this.eventLocation,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WeddingEventTableData copyWithCompanion(WeddingEventsCompanion data) {
    return WeddingEventTableData(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      weddingProfileId: data.weddingProfileId.present
          ? data.weddingProfileId.value
          : this.weddingProfileId,
      eventName: data.eventName.present ? data.eventName.value : this.eventName,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      eventLocation: data.eventLocation.present
          ? data.eventLocation.value
          : this.eventLocation,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingEventTableData(')
          ..write('eventId: $eventId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('eventName: $eventName, ')
          ..write('eventDate: $eventDate, ')
          ..write('eventLocation: $eventLocation, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    weddingProfileId,
    eventName,
    eventDate,
    eventLocation,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingEventTableData &&
          other.eventId == this.eventId &&
          other.weddingProfileId == this.weddingProfileId &&
          other.eventName == this.eventName &&
          other.eventDate == this.eventDate &&
          other.eventLocation == this.eventLocation &&
          other.sortOrder == this.sortOrder);
}

class WeddingEventsCompanion extends UpdateCompanion<WeddingEventTableData> {
  final Value<String> eventId;
  final Value<String> weddingProfileId;
  final Value<String> eventName;
  final Value<int> eventDate;
  final Value<String?> eventLocation;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WeddingEventsCompanion({
    this.eventId = const Value.absent(),
    this.weddingProfileId = const Value.absent(),
    this.eventName = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.eventLocation = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingEventsCompanion.insert({
    required String eventId,
    required String weddingProfileId,
    required String eventName,
    required int eventDate,
    this.eventLocation = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       weddingProfileId = Value(weddingProfileId),
       eventName = Value(eventName),
       eventDate = Value(eventDate);
  static Insertable<WeddingEventTableData> custom({
    Expression<String>? eventId,
    Expression<String>? weddingProfileId,
    Expression<String>? eventName,
    Expression<int>? eventDate,
    Expression<String>? eventLocation,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (weddingProfileId != null) 'wedding_profile_id': weddingProfileId,
      if (eventName != null) 'event_name': eventName,
      if (eventDate != null) 'event_date': eventDate,
      if (eventLocation != null) 'event_location': eventLocation,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingEventsCompanion copyWith({
    Value<String>? eventId,
    Value<String>? weddingProfileId,
    Value<String>? eventName,
    Value<int>? eventDate,
    Value<String?>? eventLocation,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WeddingEventsCompanion(
      eventId: eventId ?? this.eventId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (weddingProfileId.present) {
      map['wedding_profile_id'] = Variable<String>(weddingProfileId.value);
    }
    if (eventName.present) {
      map['event_name'] = Variable<String>(eventName.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<int>(eventDate.value);
    }
    if (eventLocation.present) {
      map['event_location'] = Variable<String>(eventLocation.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('eventName: $eventName, ')
          ..write('eventDate: $eventDate, ')
          ..write('eventLocation: $eventLocation, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingRundownItemsTable extends WeddingRundownItems
    with TableInfo<$WeddingRundownItemsTable, WeddingRundownItemTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingRundownItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_events (event_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _timeStartMeta = const VerificationMeta(
    'timeStart',
  );
  @override
  late final GeneratedColumn<String> timeStart = GeneratedColumn<String>(
    'time_start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('08:00'),
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _sessionTitleMeta = const VerificationMeta(
    'sessionTitle',
  );
  @override
  late final GeneratedColumn<String> sessionTitle = GeneratedColumn<String>(
    'session_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _picMeta = const VerificationMeta('pic');
  @override
  late final GeneratedColumn<String> pic = GeneratedColumn<String>(
    'pic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mcScriptMeta = const VerificationMeta(
    'mcScript',
  );
  @override
  late final GeneratedColumn<String> mcScript = GeneratedColumn<String>(
    'mc_script',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    eventId,
    timeStart,
    durationMinutes,
    sessionTitle,
    pic,
    mcScript,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_rundown_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingRundownItemTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('time_start')) {
      context.handle(
        _timeStartMeta,
        timeStart.isAcceptableOrUnknown(data['time_start']!, _timeStartMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('session_title')) {
      context.handle(
        _sessionTitleMeta,
        sessionTitle.isAcceptableOrUnknown(
          data['session_title']!,
          _sessionTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionTitleMeta);
    }
    if (data.containsKey('pic')) {
      context.handle(
        _picMeta,
        pic.isAcceptableOrUnknown(data['pic']!, _picMeta),
      );
    }
    if (data.containsKey('mc_script')) {
      context.handle(
        _mcScriptMeta,
        mcScript.isAcceptableOrUnknown(data['mc_script']!, _mcScriptMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  WeddingRundownItemTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingRundownItemTableData(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      timeStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_start'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      sessionTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_title'],
      )!,
      pic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pic'],
      ),
      mcScript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mc_script'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WeddingRundownItemsTable createAlias(String alias) {
    return $WeddingRundownItemsTable(attachedDatabase, alias);
  }
}

class WeddingRundownItemTableData extends DataClass
    implements Insertable<WeddingRundownItemTableData> {
  final String itemId;
  final String eventId;
  final String timeStart;
  final int durationMinutes;
  final String sessionTitle;
  final String? pic;
  final String? mcScript;
  final int sortOrder;
  const WeddingRundownItemTableData({
    required this.itemId,
    required this.eventId,
    required this.timeStart,
    required this.durationMinutes,
    required this.sessionTitle,
    this.pic,
    this.mcScript,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['event_id'] = Variable<String>(eventId);
    map['time_start'] = Variable<String>(timeStart);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['session_title'] = Variable<String>(sessionTitle);
    if (!nullToAbsent || pic != null) {
      map['pic'] = Variable<String>(pic);
    }
    if (!nullToAbsent || mcScript != null) {
      map['mc_script'] = Variable<String>(mcScript);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WeddingRundownItemsCompanion toCompanion(bool nullToAbsent) {
    return WeddingRundownItemsCompanion(
      itemId: Value(itemId),
      eventId: Value(eventId),
      timeStart: Value(timeStart),
      durationMinutes: Value(durationMinutes),
      sessionTitle: Value(sessionTitle),
      pic: pic == null && nullToAbsent ? const Value.absent() : Value(pic),
      mcScript: mcScript == null && nullToAbsent
          ? const Value.absent()
          : Value(mcScript),
      sortOrder: Value(sortOrder),
    );
  }

  factory WeddingRundownItemTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingRundownItemTableData(
      itemId: serializer.fromJson<String>(json['itemId']),
      eventId: serializer.fromJson<String>(json['eventId']),
      timeStart: serializer.fromJson<String>(json['timeStart']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      sessionTitle: serializer.fromJson<String>(json['sessionTitle']),
      pic: serializer.fromJson<String?>(json['pic']),
      mcScript: serializer.fromJson<String?>(json['mcScript']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'eventId': serializer.toJson<String>(eventId),
      'timeStart': serializer.toJson<String>(timeStart),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'sessionTitle': serializer.toJson<String>(sessionTitle),
      'pic': serializer.toJson<String?>(pic),
      'mcScript': serializer.toJson<String?>(mcScript),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WeddingRundownItemTableData copyWith({
    String? itemId,
    String? eventId,
    String? timeStart,
    int? durationMinutes,
    String? sessionTitle,
    Value<String?> pic = const Value.absent(),
    Value<String?> mcScript = const Value.absent(),
    int? sortOrder,
  }) => WeddingRundownItemTableData(
    itemId: itemId ?? this.itemId,
    eventId: eventId ?? this.eventId,
    timeStart: timeStart ?? this.timeStart,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    sessionTitle: sessionTitle ?? this.sessionTitle,
    pic: pic.present ? pic.value : this.pic,
    mcScript: mcScript.present ? mcScript.value : this.mcScript,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WeddingRundownItemTableData copyWithCompanion(
    WeddingRundownItemsCompanion data,
  ) {
    return WeddingRundownItemTableData(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      timeStart: data.timeStart.present ? data.timeStart.value : this.timeStart,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      sessionTitle: data.sessionTitle.present
          ? data.sessionTitle.value
          : this.sessionTitle,
      pic: data.pic.present ? data.pic.value : this.pic,
      mcScript: data.mcScript.present ? data.mcScript.value : this.mcScript,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingRundownItemTableData(')
          ..write('itemId: $itemId, ')
          ..write('eventId: $eventId, ')
          ..write('timeStart: $timeStart, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sessionTitle: $sessionTitle, ')
          ..write('pic: $pic, ')
          ..write('mcScript: $mcScript, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    eventId,
    timeStart,
    durationMinutes,
    sessionTitle,
    pic,
    mcScript,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingRundownItemTableData &&
          other.itemId == this.itemId &&
          other.eventId == this.eventId &&
          other.timeStart == this.timeStart &&
          other.durationMinutes == this.durationMinutes &&
          other.sessionTitle == this.sessionTitle &&
          other.pic == this.pic &&
          other.mcScript == this.mcScript &&
          other.sortOrder == this.sortOrder);
}

class WeddingRundownItemsCompanion
    extends UpdateCompanion<WeddingRundownItemTableData> {
  final Value<String> itemId;
  final Value<String> eventId;
  final Value<String> timeStart;
  final Value<int> durationMinutes;
  final Value<String> sessionTitle;
  final Value<String?> pic;
  final Value<String?> mcScript;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WeddingRundownItemsCompanion({
    this.itemId = const Value.absent(),
    this.eventId = const Value.absent(),
    this.timeStart = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.sessionTitle = const Value.absent(),
    this.pic = const Value.absent(),
    this.mcScript = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingRundownItemsCompanion.insert({
    required String itemId,
    required String eventId,
    this.timeStart = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    required String sessionTitle,
    this.pic = const Value.absent(),
    this.mcScript = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       eventId = Value(eventId),
       sessionTitle = Value(sessionTitle);
  static Insertable<WeddingRundownItemTableData> custom({
    Expression<String>? itemId,
    Expression<String>? eventId,
    Expression<String>? timeStart,
    Expression<int>? durationMinutes,
    Expression<String>? sessionTitle,
    Expression<String>? pic,
    Expression<String>? mcScript,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (eventId != null) 'event_id': eventId,
      if (timeStart != null) 'time_start': timeStart,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (sessionTitle != null) 'session_title': sessionTitle,
      if (pic != null) 'pic': pic,
      if (mcScript != null) 'mc_script': mcScript,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingRundownItemsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? eventId,
    Value<String>? timeStart,
    Value<int>? durationMinutes,
    Value<String>? sessionTitle,
    Value<String?>? pic,
    Value<String?>? mcScript,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WeddingRundownItemsCompanion(
      itemId: itemId ?? this.itemId,
      eventId: eventId ?? this.eventId,
      timeStart: timeStart ?? this.timeStart,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      pic: pic ?? this.pic,
      mcScript: mcScript ?? this.mcScript,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (timeStart.present) {
      map['time_start'] = Variable<String>(timeStart.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (sessionTitle.present) {
      map['session_title'] = Variable<String>(sessionTitle.value);
    }
    if (pic.present) {
      map['pic'] = Variable<String>(pic.value);
    }
    if (mcScript.present) {
      map['mc_script'] = Variable<String>(mcScript.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingRundownItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('eventId: $eventId, ')
          ..write('timeStart: $timeStart, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('sessionTitle: $sessionTitle, ')
          ..write('pic: $pic, ')
          ..write('mcScript: $mcScript, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingSeserahansTable extends WeddingSeserahans
    with TableInfo<$WeddingSeserahansTable, WeddingSeserahanTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingSeserahansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingProfileIdMeta = const VerificationMeta(
    'weddingProfileId',
  );
  @override
  late final GeneratedColumn<String> weddingProfileId = GeneratedColumn<String>(
    'wedding_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SESERAHAN_CPP'),
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _estimatedPriceMeta = const VerificationMeta(
    'estimatedPrice',
  );
  @override
  late final GeneratedColumn<double> estimatedPrice = GeneratedColumn<double>(
    'estimated_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BELUM_BELI'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    weddingProfileId,
    direction,
    itemName,
    quantity,
    estimatedPrice,
    status,
    notes,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_seserahans';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingSeserahanTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('wedding_profile_id')) {
      context.handle(
        _weddingProfileIdMeta,
        weddingProfileId.isAcceptableOrUnknown(
          data['wedding_profile_id']!,
          _weddingProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingProfileIdMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('estimated_price')) {
      context.handle(
        _estimatedPriceMeta,
        estimatedPrice.isAcceptableOrUnknown(
          data['estimated_price']!,
          _estimatedPriceMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  WeddingSeserahanTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingSeserahanTableData(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      weddingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wedding_profile_id'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      estimatedPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_price'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WeddingSeserahansTable createAlias(String alias) {
    return $WeddingSeserahansTable(attachedDatabase, alias);
  }
}

class WeddingSeserahanTableData extends DataClass
    implements Insertable<WeddingSeserahanTableData> {
  final String itemId;
  final String weddingProfileId;
  final String direction;
  final String itemName;
  final int quantity;
  final double estimatedPrice;
  final String status;
  final String? notes;
  final int sortOrder;
  const WeddingSeserahanTableData({
    required this.itemId,
    required this.weddingProfileId,
    required this.direction,
    required this.itemName,
    required this.quantity,
    required this.estimatedPrice,
    required this.status,
    this.notes,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['wedding_profile_id'] = Variable<String>(weddingProfileId);
    map['direction'] = Variable<String>(direction);
    map['item_name'] = Variable<String>(itemName);
    map['quantity'] = Variable<int>(quantity);
    map['estimated_price'] = Variable<double>(estimatedPrice);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WeddingSeserahansCompanion toCompanion(bool nullToAbsent) {
    return WeddingSeserahansCompanion(
      itemId: Value(itemId),
      weddingProfileId: Value(weddingProfileId),
      direction: Value(direction),
      itemName: Value(itemName),
      quantity: Value(quantity),
      estimatedPrice: Value(estimatedPrice),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
    );
  }

  factory WeddingSeserahanTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingSeserahanTableData(
      itemId: serializer.fromJson<String>(json['itemId']),
      weddingProfileId: serializer.fromJson<String>(json['weddingProfileId']),
      direction: serializer.fromJson<String>(json['direction']),
      itemName: serializer.fromJson<String>(json['itemName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      estimatedPrice: serializer.fromJson<double>(json['estimatedPrice']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'weddingProfileId': serializer.toJson<String>(weddingProfileId),
      'direction': serializer.toJson<String>(direction),
      'itemName': serializer.toJson<String>(itemName),
      'quantity': serializer.toJson<int>(quantity),
      'estimatedPrice': serializer.toJson<double>(estimatedPrice),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WeddingSeserahanTableData copyWith({
    String? itemId,
    String? weddingProfileId,
    String? direction,
    String? itemName,
    int? quantity,
    double? estimatedPrice,
    String? status,
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
  }) => WeddingSeserahanTableData(
    itemId: itemId ?? this.itemId,
    weddingProfileId: weddingProfileId ?? this.weddingProfileId,
    direction: direction ?? this.direction,
    itemName: itemName ?? this.itemName,
    quantity: quantity ?? this.quantity,
    estimatedPrice: estimatedPrice ?? this.estimatedPrice,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WeddingSeserahanTableData copyWithCompanion(WeddingSeserahansCompanion data) {
    return WeddingSeserahanTableData(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      weddingProfileId: data.weddingProfileId.present
          ? data.weddingProfileId.value
          : this.weddingProfileId,
      direction: data.direction.present ? data.direction.value : this.direction,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      estimatedPrice: data.estimatedPrice.present
          ? data.estimatedPrice.value
          : this.estimatedPrice,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingSeserahanTableData(')
          ..write('itemId: $itemId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('direction: $direction, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('estimatedPrice: $estimatedPrice, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    weddingProfileId,
    direction,
    itemName,
    quantity,
    estimatedPrice,
    status,
    notes,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingSeserahanTableData &&
          other.itemId == this.itemId &&
          other.weddingProfileId == this.weddingProfileId &&
          other.direction == this.direction &&
          other.itemName == this.itemName &&
          other.quantity == this.quantity &&
          other.estimatedPrice == this.estimatedPrice &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder);
}

class WeddingSeserahansCompanion
    extends UpdateCompanion<WeddingSeserahanTableData> {
  final Value<String> itemId;
  final Value<String> weddingProfileId;
  final Value<String> direction;
  final Value<String> itemName;
  final Value<int> quantity;
  final Value<double> estimatedPrice;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WeddingSeserahansCompanion({
    this.itemId = const Value.absent(),
    this.weddingProfileId = const Value.absent(),
    this.direction = const Value.absent(),
    this.itemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.estimatedPrice = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingSeserahansCompanion.insert({
    required String itemId,
    required String weddingProfileId,
    this.direction = const Value.absent(),
    required String itemName,
    this.quantity = const Value.absent(),
    this.estimatedPrice = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       weddingProfileId = Value(weddingProfileId),
       itemName = Value(itemName);
  static Insertable<WeddingSeserahanTableData> custom({
    Expression<String>? itemId,
    Expression<String>? weddingProfileId,
    Expression<String>? direction,
    Expression<String>? itemName,
    Expression<int>? quantity,
    Expression<double>? estimatedPrice,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (weddingProfileId != null) 'wedding_profile_id': weddingProfileId,
      if (direction != null) 'direction': direction,
      if (itemName != null) 'item_name': itemName,
      if (quantity != null) 'quantity': quantity,
      if (estimatedPrice != null) 'estimated_price': estimatedPrice,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingSeserahansCompanion copyWith({
    Value<String>? itemId,
    Value<String>? weddingProfileId,
    Value<String>? direction,
    Value<String>? itemName,
    Value<int>? quantity,
    Value<double>? estimatedPrice,
    Value<String>? status,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WeddingSeserahansCompanion(
      itemId: itemId ?? this.itemId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      direction: direction ?? this.direction,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (weddingProfileId.present) {
      map['wedding_profile_id'] = Variable<String>(weddingProfileId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (estimatedPrice.present) {
      map['estimated_price'] = Variable<double>(estimatedPrice.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingSeserahansCompanion(')
          ..write('itemId: $itemId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('direction: $direction, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('estimatedPrice: $estimatedPrice, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeddingDocumentsTable extends WeddingDocuments
    with TableInfo<$WeddingDocumentsTable, WeddingDocumentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeddingDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _docIdMeta = const VerificationMeta('docId');
  @override
  late final GeneratedColumn<String> docId = GeneratedColumn<String>(
    'doc_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weddingProfileIdMeta = const VerificationMeta(
    'weddingProfileId',
  );
  @override
  late final GeneratedColumn<String> weddingProfileId = GeneratedColumn<String>(
    'wedding_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wedding_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _docNameMeta = const VerificationMeta(
    'docName',
  );
  @override
  late final GeneratedColumn<String> docName = GeneratedColumn<String>(
    'doc_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerTypeMeta = const VerificationMeta(
    'ownerType',
  );
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
    'owner_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BOTH'),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adminCostMeta = const VerificationMeta(
    'adminCost',
  );
  @override
  late final GeneratedColumn<double> adminCost = GeneratedColumn<double>(
    'admin_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    docId,
    weddingProfileId,
    docName,
    ownerType,
    isCompleted,
    localFilePath,
    adminCost,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wedding_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeddingDocumentTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('doc_id')) {
      context.handle(
        _docIdMeta,
        docId.isAcceptableOrUnknown(data['doc_id']!, _docIdMeta),
      );
    } else if (isInserting) {
      context.missing(_docIdMeta);
    }
    if (data.containsKey('wedding_profile_id')) {
      context.handle(
        _weddingProfileIdMeta,
        weddingProfileId.isAcceptableOrUnknown(
          data['wedding_profile_id']!,
          _weddingProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weddingProfileIdMeta);
    }
    if (data.containsKey('doc_name')) {
      context.handle(
        _docNameMeta,
        docName.isAcceptableOrUnknown(data['doc_name']!, _docNameMeta),
      );
    } else if (isInserting) {
      context.missing(_docNameMeta);
    }
    if (data.containsKey('owner_type')) {
      context.handle(
        _ownerTypeMeta,
        ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    }
    if (data.containsKey('admin_cost')) {
      context.handle(
        _adminCostMeta,
        adminCost.isAcceptableOrUnknown(data['admin_cost']!, _adminCostMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {docId};
  @override
  WeddingDocumentTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeddingDocumentTableData(
      docId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doc_id'],
      )!,
      weddingProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wedding_profile_id'],
      )!,
      docName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doc_name'],
      )!,
      ownerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_type'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      ),
      adminCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}admin_cost'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WeddingDocumentsTable createAlias(String alias) {
    return $WeddingDocumentsTable(attachedDatabase, alias);
  }
}

class WeddingDocumentTableData extends DataClass
    implements Insertable<WeddingDocumentTableData> {
  final String docId;
  final String weddingProfileId;
  final String docName;
  final String ownerType;
  final bool isCompleted;
  final String? localFilePath;
  final double adminCost;
  final int sortOrder;
  const WeddingDocumentTableData({
    required this.docId,
    required this.weddingProfileId,
    required this.docName,
    required this.ownerType,
    required this.isCompleted,
    this.localFilePath,
    required this.adminCost,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['doc_id'] = Variable<String>(docId);
    map['wedding_profile_id'] = Variable<String>(weddingProfileId);
    map['doc_name'] = Variable<String>(docName);
    map['owner_type'] = Variable<String>(ownerType);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || localFilePath != null) {
      map['local_file_path'] = Variable<String>(localFilePath);
    }
    map['admin_cost'] = Variable<double>(adminCost);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WeddingDocumentsCompanion toCompanion(bool nullToAbsent) {
    return WeddingDocumentsCompanion(
      docId: Value(docId),
      weddingProfileId: Value(weddingProfileId),
      docName: Value(docName),
      ownerType: Value(ownerType),
      isCompleted: Value(isCompleted),
      localFilePath: localFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(localFilePath),
      adminCost: Value(adminCost),
      sortOrder: Value(sortOrder),
    );
  }

  factory WeddingDocumentTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeddingDocumentTableData(
      docId: serializer.fromJson<String>(json['docId']),
      weddingProfileId: serializer.fromJson<String>(json['weddingProfileId']),
      docName: serializer.fromJson<String>(json['docName']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      localFilePath: serializer.fromJson<String?>(json['localFilePath']),
      adminCost: serializer.fromJson<double>(json['adminCost']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'docId': serializer.toJson<String>(docId),
      'weddingProfileId': serializer.toJson<String>(weddingProfileId),
      'docName': serializer.toJson<String>(docName),
      'ownerType': serializer.toJson<String>(ownerType),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'localFilePath': serializer.toJson<String?>(localFilePath),
      'adminCost': serializer.toJson<double>(adminCost),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WeddingDocumentTableData copyWith({
    String? docId,
    String? weddingProfileId,
    String? docName,
    String? ownerType,
    bool? isCompleted,
    Value<String?> localFilePath = const Value.absent(),
    double? adminCost,
    int? sortOrder,
  }) => WeddingDocumentTableData(
    docId: docId ?? this.docId,
    weddingProfileId: weddingProfileId ?? this.weddingProfileId,
    docName: docName ?? this.docName,
    ownerType: ownerType ?? this.ownerType,
    isCompleted: isCompleted ?? this.isCompleted,
    localFilePath: localFilePath.present
        ? localFilePath.value
        : this.localFilePath,
    adminCost: adminCost ?? this.adminCost,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WeddingDocumentTableData copyWithCompanion(WeddingDocumentsCompanion data) {
    return WeddingDocumentTableData(
      docId: data.docId.present ? data.docId.value : this.docId,
      weddingProfileId: data.weddingProfileId.present
          ? data.weddingProfileId.value
          : this.weddingProfileId,
      docName: data.docName.present ? data.docName.value : this.docName,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      adminCost: data.adminCost.present ? data.adminCost.value : this.adminCost,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeddingDocumentTableData(')
          ..write('docId: $docId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('docName: $docName, ')
          ..write('ownerType: $ownerType, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('adminCost: $adminCost, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    docId,
    weddingProfileId,
    docName,
    ownerType,
    isCompleted,
    localFilePath,
    adminCost,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeddingDocumentTableData &&
          other.docId == this.docId &&
          other.weddingProfileId == this.weddingProfileId &&
          other.docName == this.docName &&
          other.ownerType == this.ownerType &&
          other.isCompleted == this.isCompleted &&
          other.localFilePath == this.localFilePath &&
          other.adminCost == this.adminCost &&
          other.sortOrder == this.sortOrder);
}

class WeddingDocumentsCompanion
    extends UpdateCompanion<WeddingDocumentTableData> {
  final Value<String> docId;
  final Value<String> weddingProfileId;
  final Value<String> docName;
  final Value<String> ownerType;
  final Value<bool> isCompleted;
  final Value<String?> localFilePath;
  final Value<double> adminCost;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WeddingDocumentsCompanion({
    this.docId = const Value.absent(),
    this.weddingProfileId = const Value.absent(),
    this.docName = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.adminCost = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeddingDocumentsCompanion.insert({
    required String docId,
    required String weddingProfileId,
    required String docName,
    this.ownerType = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.adminCost = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : docId = Value(docId),
       weddingProfileId = Value(weddingProfileId),
       docName = Value(docName);
  static Insertable<WeddingDocumentTableData> custom({
    Expression<String>? docId,
    Expression<String>? weddingProfileId,
    Expression<String>? docName,
    Expression<String>? ownerType,
    Expression<bool>? isCompleted,
    Expression<String>? localFilePath,
    Expression<double>? adminCost,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (docId != null) 'doc_id': docId,
      if (weddingProfileId != null) 'wedding_profile_id': weddingProfileId,
      if (docName != null) 'doc_name': docName,
      if (ownerType != null) 'owner_type': ownerType,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (adminCost != null) 'admin_cost': adminCost,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeddingDocumentsCompanion copyWith({
    Value<String>? docId,
    Value<String>? weddingProfileId,
    Value<String>? docName,
    Value<String>? ownerType,
    Value<bool>? isCompleted,
    Value<String?>? localFilePath,
    Value<double>? adminCost,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WeddingDocumentsCompanion(
      docId: docId ?? this.docId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      docName: docName ?? this.docName,
      ownerType: ownerType ?? this.ownerType,
      isCompleted: isCompleted ?? this.isCompleted,
      localFilePath: localFilePath ?? this.localFilePath,
      adminCost: adminCost ?? this.adminCost,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (docId.present) {
      map['doc_id'] = Variable<String>(docId.value);
    }
    if (weddingProfileId.present) {
      map['wedding_profile_id'] = Variable<String>(weddingProfileId.value);
    }
    if (docName.present) {
      map['doc_name'] = Variable<String>(docName.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (adminCost.present) {
      map['admin_cost'] = Variable<double>(adminCost.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeddingDocumentsCompanion(')
          ..write('docId: $docId, ')
          ..write('weddingProfileId: $weddingProfileId, ')
          ..write('docName: $docName, ')
          ..write('ownerType: $ownerType, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('adminCost: $adminCost, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WeddingProfilesTable weddingProfiles = $WeddingProfilesTable(
    this,
  );
  late final $WeddingExpensesTable weddingExpenses = $WeddingExpensesTable(
    this,
  );
  late final $WeddingPaymentTermsTable weddingPaymentTerms =
      $WeddingPaymentTermsTable(this);
  late final $WeddingGuestsTable weddingGuests = $WeddingGuestsTable(this);
  late final $WeddingVendorsTable weddingVendors = $WeddingVendorsTable(this);
  late final $WeddingTasksTable weddingTasks = $WeddingTasksTable(this);
  late final $WeddingCommitteeMembersTable weddingCommitteeMembers =
      $WeddingCommitteeMembersTable(this);
  late final $WeddingEventsTable weddingEvents = $WeddingEventsTable(this);
  late final $WeddingRundownItemsTable weddingRundownItems =
      $WeddingRundownItemsTable(this);
  late final $WeddingSeserahansTable weddingSeserahans =
      $WeddingSeserahansTable(this);
  late final $WeddingDocumentsTable weddingDocuments = $WeddingDocumentsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    weddingProfiles,
    weddingExpenses,
    weddingPaymentTerms,
    weddingGuests,
    weddingVendors,
    weddingTasks,
    weddingCommitteeMembers,
    weddingEvents,
    weddingRundownItems,
    weddingSeserahans,
    weddingDocuments,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_expenses',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_payment_terms', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_guests', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_vendors', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_tasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('wedding_committee_members', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_rundown_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_seserahans', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wedding_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wedding_documents', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WeddingProfilesTableCreateCompanionBuilder =
    WeddingProfilesCompanion Function({
      required String id,
      required String groomName,
      required String brideName,
      required int weddingDate,
      Value<double> totalBudgetCap,
      Value<String> religionType,
      Value<String?> religionDetail,
      Value<String?> culturalPresetGroom,
      Value<String?> culturalPresetBride,
      Value<String?> quote,
      Value<bool> quoteEnabled,
      Value<String> quoteFontSize,
      Value<String> quoteFontStyle,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$WeddingProfilesTableUpdateCompanionBuilder =
    WeddingProfilesCompanion Function({
      Value<String> id,
      Value<String> groomName,
      Value<String> brideName,
      Value<int> weddingDate,
      Value<double> totalBudgetCap,
      Value<String> religionType,
      Value<String?> religionDetail,
      Value<String?> culturalPresetGroom,
      Value<String?> culturalPresetBride,
      Value<String?> quote,
      Value<bool> quoteEnabled,
      Value<String> quoteFontSize,
      Value<String> quoteFontStyle,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$WeddingProfilesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingProfilesTable,
          WeddingProfileTableData
        > {
  $$WeddingProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $WeddingExpensesTable,
    List<WeddingExpenseTableData>
  >
  _weddingExpensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weddingExpenses,
    aliasName: 'wedding_profiles__id__wedding_expenses__wedding_profile_id',
  );

  $$WeddingExpensesTableProcessedTableManager get weddingExpensesRefs {
    final manager =
        $$WeddingExpensesTableTableManager($_db, $_db.weddingExpenses).filter(
          (f) => f.weddingProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _weddingExpensesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeddingGuestsTable, List<WeddingGuestTableData>>
  _weddingGuestsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weddingGuests,
    aliasName: 'wedding_profiles__id__wedding_guests__wedding_profile_id',
  );

  $$WeddingGuestsTableProcessedTableManager get weddingGuestsRefs {
    final manager = $$WeddingGuestsTableTableManager($_db, $_db.weddingGuests)
        .filter(
          (f) => f.weddingProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_weddingGuestsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeddingVendorsTable, List<WeddingVendorTableData>>
  _weddingVendorsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weddingVendors,
    aliasName: 'wedding_profiles__id__wedding_vendors__wedding_profile_id',
  );

  $$WeddingVendorsTableProcessedTableManager get weddingVendorsRefs {
    final manager = $$WeddingVendorsTableTableManager($_db, $_db.weddingVendors)
        .filter(
          (f) => f.weddingProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_weddingVendorsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeddingTasksTable, List<WeddingTaskTableData>>
  _weddingTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weddingTasks,
    aliasName: 'wedding_profiles__id__wedding_tasks__wedding_profile_id',
  );

  $$WeddingTasksTableProcessedTableManager get weddingTasksRefs {
    final manager = $$WeddingTasksTableTableManager($_db, $_db.weddingTasks)
        .filter(
          (f) => f.weddingProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_weddingTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $WeddingCommitteeMembersTable,
    List<WeddingCommitteeTableData>
  >
  _weddingCommitteeMembersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.weddingCommitteeMembers,
    aliasName:
        'wedding_profiles__id__wedding_committee_members__wedding_profile_id',
  );

  $$WeddingCommitteeMembersTableProcessedTableManager
  get weddingCommitteeMembersRefs {
    final manager =
        $$WeddingCommitteeMembersTableTableManager(
          $_db,
          $_db.weddingCommitteeMembers,
        ).filter(
          (f) => f.weddingProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _weddingCommitteeMembersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeddingEventsTable, List<WeddingEventTableData>>
  _weddingEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weddingEvents,
    aliasName: 'wedding_profiles__id__wedding_events__wedding_profile_id',
  );

  $$WeddingEventsTableProcessedTableManager get weddingEventsRefs {
    final manager = $$WeddingEventsTableTableManager($_db, $_db.weddingEvents)
        .filter(
          (f) => f.weddingProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_weddingEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $WeddingSeserahansTable,
    List<WeddingSeserahanTableData>
  >
  _weddingSeserahansRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weddingSeserahans,
        aliasName:
            'wedding_profiles__id__wedding_seserahans__wedding_profile_id',
      );

  $$WeddingSeserahansTableProcessedTableManager get weddingSeserahansRefs {
    final manager =
        $$WeddingSeserahansTableTableManager(
          $_db,
          $_db.weddingSeserahans,
        ).filter(
          (f) => f.weddingProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _weddingSeserahansRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $WeddingDocumentsTable,
    List<WeddingDocumentTableData>
  >
  _weddingDocumentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weddingDocuments,
    aliasName: 'wedding_profiles__id__wedding_documents__wedding_profile_id',
  );

  $$WeddingDocumentsTableProcessedTableManager get weddingDocumentsRefs {
    final manager =
        $$WeddingDocumentsTableTableManager($_db, $_db.weddingDocuments).filter(
          (f) => f.weddingProfileId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _weddingDocumentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WeddingProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingProfilesTable> {
  $$WeddingProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groomName => $composableBuilder(
    column: $table.groomName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brideName => $composableBuilder(
    column: $table.brideName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weddingDate => $composableBuilder(
    column: $table.weddingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalBudgetCap => $composableBuilder(
    column: $table.totalBudgetCap,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get religionType => $composableBuilder(
    column: $table.religionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get religionDetail => $composableBuilder(
    column: $table.religionDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get culturalPresetGroom => $composableBuilder(
    column: $table.culturalPresetGroom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get culturalPresetBride => $composableBuilder(
    column: $table.culturalPresetBride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quote => $composableBuilder(
    column: $table.quote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get quoteEnabled => $composableBuilder(
    column: $table.quoteEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteFontSize => $composableBuilder(
    column: $table.quoteFontSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteFontStyle => $composableBuilder(
    column: $table.quoteFontStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weddingExpensesRefs(
    Expression<bool> Function($$WeddingExpensesTableFilterComposer f) f,
  ) {
    final $$WeddingExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingExpenses,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingExpensesTableFilterComposer(
            $db: $db,
            $table: $db.weddingExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weddingGuestsRefs(
    Expression<bool> Function($$WeddingGuestsTableFilterComposer f) f,
  ) {
    final $$WeddingGuestsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingGuests,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingGuestsTableFilterComposer(
            $db: $db,
            $table: $db.weddingGuests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weddingVendorsRefs(
    Expression<bool> Function($$WeddingVendorsTableFilterComposer f) f,
  ) {
    final $$WeddingVendorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingVendors,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingVendorsTableFilterComposer(
            $db: $db,
            $table: $db.weddingVendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weddingTasksRefs(
    Expression<bool> Function($$WeddingTasksTableFilterComposer f) f,
  ) {
    final $$WeddingTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingTasks,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingTasksTableFilterComposer(
            $db: $db,
            $table: $db.weddingTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weddingCommitteeMembersRefs(
    Expression<bool> Function($$WeddingCommitteeMembersTableFilterComposer f) f,
  ) {
    final $$WeddingCommitteeMembersTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weddingCommitteeMembers,
          getReferencedColumn: (t) => t.weddingProfileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeddingCommitteeMembersTableFilterComposer(
                $db: $db,
                $table: $db.weddingCommitteeMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> weddingEventsRefs(
    Expression<bool> Function($$WeddingEventsTableFilterComposer f) f,
  ) {
    final $$WeddingEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingEvents,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingEventsTableFilterComposer(
            $db: $db,
            $table: $db.weddingEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weddingSeserahansRefs(
    Expression<bool> Function($$WeddingSeserahansTableFilterComposer f) f,
  ) {
    final $$WeddingSeserahansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingSeserahans,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingSeserahansTableFilterComposer(
            $db: $db,
            $table: $db.weddingSeserahans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weddingDocumentsRefs(
    Expression<bool> Function($$WeddingDocumentsTableFilterComposer f) f,
  ) {
    final $$WeddingDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingDocuments,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.weddingDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeddingProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingProfilesTable> {
  $$WeddingProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groomName => $composableBuilder(
    column: $table.groomName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brideName => $composableBuilder(
    column: $table.brideName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weddingDate => $composableBuilder(
    column: $table.weddingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalBudgetCap => $composableBuilder(
    column: $table.totalBudgetCap,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get religionType => $composableBuilder(
    column: $table.religionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get religionDetail => $composableBuilder(
    column: $table.religionDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get culturalPresetGroom => $composableBuilder(
    column: $table.culturalPresetGroom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get culturalPresetBride => $composableBuilder(
    column: $table.culturalPresetBride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quote => $composableBuilder(
    column: $table.quote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get quoteEnabled => $composableBuilder(
    column: $table.quoteEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteFontSize => $composableBuilder(
    column: $table.quoteFontSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteFontStyle => $composableBuilder(
    column: $table.quoteFontStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeddingProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingProfilesTable> {
  $$WeddingProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groomName =>
      $composableBuilder(column: $table.groomName, builder: (column) => column);

  GeneratedColumn<String> get brideName =>
      $composableBuilder(column: $table.brideName, builder: (column) => column);

  GeneratedColumn<int> get weddingDate => $composableBuilder(
    column: $table.weddingDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalBudgetCap => $composableBuilder(
    column: $table.totalBudgetCap,
    builder: (column) => column,
  );

  GeneratedColumn<String> get religionType => $composableBuilder(
    column: $table.religionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get religionDetail => $composableBuilder(
    column: $table.religionDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get culturalPresetGroom => $composableBuilder(
    column: $table.culturalPresetGroom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get culturalPresetBride => $composableBuilder(
    column: $table.culturalPresetBride,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quote =>
      $composableBuilder(column: $table.quote, builder: (column) => column);

  GeneratedColumn<bool> get quoteEnabled => $composableBuilder(
    column: $table.quoteEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quoteFontSize => $composableBuilder(
    column: $table.quoteFontSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quoteFontStyle => $composableBuilder(
    column: $table.quoteFontStyle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> weddingExpensesRefs<T extends Object>(
    Expression<T> Function($$WeddingExpensesTableAnnotationComposer a) f,
  ) {
    final $$WeddingExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingExpenses,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weddingGuestsRefs<T extends Object>(
    Expression<T> Function($$WeddingGuestsTableAnnotationComposer a) f,
  ) {
    final $$WeddingGuestsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingGuests,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingGuestsTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingGuests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weddingVendorsRefs<T extends Object>(
    Expression<T> Function($$WeddingVendorsTableAnnotationComposer a) f,
  ) {
    final $$WeddingVendorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingVendors,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingVendorsTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingVendors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weddingTasksRefs<T extends Object>(
    Expression<T> Function($$WeddingTasksTableAnnotationComposer a) f,
  ) {
    final $$WeddingTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingTasks,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weddingCommitteeMembersRefs<T extends Object>(
    Expression<T> Function($$WeddingCommitteeMembersTableAnnotationComposer a)
    f,
  ) {
    final $$WeddingCommitteeMembersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weddingCommitteeMembers,
          getReferencedColumn: (t) => t.weddingProfileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeddingCommitteeMembersTableAnnotationComposer(
                $db: $db,
                $table: $db.weddingCommitteeMembers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> weddingEventsRefs<T extends Object>(
    Expression<T> Function($$WeddingEventsTableAnnotationComposer a) f,
  ) {
    final $$WeddingEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingEvents,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weddingSeserahansRefs<T extends Object>(
    Expression<T> Function($$WeddingSeserahansTableAnnotationComposer a) f,
  ) {
    final $$WeddingSeserahansTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weddingSeserahans,
          getReferencedColumn: (t) => t.weddingProfileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeddingSeserahansTableAnnotationComposer(
                $db: $db,
                $table: $db.weddingSeserahans,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> weddingDocumentsRefs<T extends Object>(
    Expression<T> Function($$WeddingDocumentsTableAnnotationComposer a) f,
  ) {
    final $$WeddingDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weddingDocuments,
      getReferencedColumn: (t) => t.weddingProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingDocuments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeddingProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingProfilesTable,
          WeddingProfileTableData,
          $$WeddingProfilesTableFilterComposer,
          $$WeddingProfilesTableOrderingComposer,
          $$WeddingProfilesTableAnnotationComposer,
          $$WeddingProfilesTableCreateCompanionBuilder,
          $$WeddingProfilesTableUpdateCompanionBuilder,
          (WeddingProfileTableData, $$WeddingProfilesTableReferences),
          WeddingProfileTableData,
          PrefetchHooks Function({
            bool weddingExpensesRefs,
            bool weddingGuestsRefs,
            bool weddingVendorsRefs,
            bool weddingTasksRefs,
            bool weddingCommitteeMembersRefs,
            bool weddingEventsRefs,
            bool weddingSeserahansRefs,
            bool weddingDocumentsRefs,
          })
        > {
  $$WeddingProfilesTableTableManager(
    _$AppDatabase db,
    $WeddingProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeddingProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groomName = const Value.absent(),
                Value<String> brideName = const Value.absent(),
                Value<int> weddingDate = const Value.absent(),
                Value<double> totalBudgetCap = const Value.absent(),
                Value<String> religionType = const Value.absent(),
                Value<String?> religionDetail = const Value.absent(),
                Value<String?> culturalPresetGroom = const Value.absent(),
                Value<String?> culturalPresetBride = const Value.absent(),
                Value<String?> quote = const Value.absent(),
                Value<bool> quoteEnabled = const Value.absent(),
                Value<String> quoteFontSize = const Value.absent(),
                Value<String> quoteFontStyle = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingProfilesCompanion(
                id: id,
                groomName: groomName,
                brideName: brideName,
                weddingDate: weddingDate,
                totalBudgetCap: totalBudgetCap,
                religionType: religionType,
                religionDetail: religionDetail,
                culturalPresetGroom: culturalPresetGroom,
                culturalPresetBride: culturalPresetBride,
                quote: quote,
                quoteEnabled: quoteEnabled,
                quoteFontSize: quoteFontSize,
                quoteFontStyle: quoteFontStyle,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groomName,
                required String brideName,
                required int weddingDate,
                Value<double> totalBudgetCap = const Value.absent(),
                Value<String> religionType = const Value.absent(),
                Value<String?> religionDetail = const Value.absent(),
                Value<String?> culturalPresetGroom = const Value.absent(),
                Value<String?> culturalPresetBride = const Value.absent(),
                Value<String?> quote = const Value.absent(),
                Value<bool> quoteEnabled = const Value.absent(),
                Value<String> quoteFontSize = const Value.absent(),
                Value<String> quoteFontStyle = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WeddingProfilesCompanion.insert(
                id: id,
                groomName: groomName,
                brideName: brideName,
                weddingDate: weddingDate,
                totalBudgetCap: totalBudgetCap,
                religionType: religionType,
                religionDetail: religionDetail,
                culturalPresetGroom: culturalPresetGroom,
                culturalPresetBride: culturalPresetBride,
                quote: quote,
                quoteEnabled: quoteEnabled,
                quoteFontSize: quoteFontSize,
                quoteFontStyle: quoteFontStyle,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeddingProfilesTable, WeddingProfileTableData>(
                    table,
                  ),
                  $$WeddingProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                weddingExpensesRefs = false,
                weddingGuestsRefs = false,
                weddingVendorsRefs = false,
                weddingTasksRefs = false,
                weddingCommitteeMembersRefs = false,
                weddingEventsRefs = false,
                weddingSeserahansRefs = false,
                weddingDocumentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weddingExpensesRefs) db.weddingExpenses,
                    if (weddingGuestsRefs) db.weddingGuests,
                    if (weddingVendorsRefs) db.weddingVendors,
                    if (weddingTasksRefs) db.weddingTasks,
                    if (weddingCommitteeMembersRefs) db.weddingCommitteeMembers,
                    if (weddingEventsRefs) db.weddingEvents,
                    if (weddingSeserahansRefs) db.weddingSeserahans,
                    if (weddingDocumentsRefs) db.weddingDocuments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weddingExpensesRefs)
                        await $_getPrefetchedData<
                          WeddingProfileTableData,
                          $WeddingProfilesTable,
                          WeddingExpenseTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingProfilesTableReferences
                              ._weddingExpensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingExpensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weddingProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weddingGuestsRefs)
                        await $_getPrefetchedData<
                          WeddingProfileTableData,
                          $WeddingProfilesTable,
                          WeddingGuestTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingProfilesTableReferences
                              ._weddingGuestsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingGuestsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weddingProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weddingVendorsRefs)
                        await $_getPrefetchedData<
                          WeddingProfileTableData,
                          $WeddingProfilesTable,
                          WeddingVendorTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingProfilesTableReferences
                              ._weddingVendorsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingVendorsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weddingProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weddingTasksRefs)
                        await $_getPrefetchedData<
                          WeddingProfileTableData,
                          $WeddingProfilesTable,
                          WeddingTaskTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingProfilesTableReferences
                              ._weddingTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weddingProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weddingCommitteeMembersRefs)
                        await $_getPrefetchedData<
                          WeddingProfileTableData,
                          $WeddingProfilesTable,
                          WeddingCommitteeTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingProfilesTableReferences
                              ._weddingCommitteeMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingCommitteeMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weddingProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weddingEventsRefs)
                        await $_getPrefetchedData<
                          WeddingProfileTableData,
                          $WeddingProfilesTable,
                          WeddingEventTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingProfilesTableReferences
                              ._weddingEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weddingProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weddingSeserahansRefs)
                        await $_getPrefetchedData<
                          WeddingProfileTableData,
                          $WeddingProfilesTable,
                          WeddingSeserahanTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingProfilesTableReferences
                              ._weddingSeserahansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingSeserahansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weddingProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weddingDocumentsRefs)
                        await $_getPrefetchedData<
                          WeddingProfileTableData,
                          $WeddingProfilesTable,
                          WeddingDocumentTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingProfilesTableReferences
                              ._weddingDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingDocumentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weddingProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WeddingProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingProfilesTable,
      WeddingProfileTableData,
      $$WeddingProfilesTableFilterComposer,
      $$WeddingProfilesTableOrderingComposer,
      $$WeddingProfilesTableAnnotationComposer,
      $$WeddingProfilesTableCreateCompanionBuilder,
      $$WeddingProfilesTableUpdateCompanionBuilder,
      (WeddingProfileTableData, $$WeddingProfilesTableReferences),
      WeddingProfileTableData,
      PrefetchHooks Function({
        bool weddingExpensesRefs,
        bool weddingGuestsRefs,
        bool weddingVendorsRefs,
        bool weddingTasksRefs,
        bool weddingCommitteeMembersRefs,
        bool weddingEventsRefs,
        bool weddingSeserahansRefs,
        bool weddingDocumentsRefs,
      })
    >;
typedef $$WeddingExpensesTableCreateCompanionBuilder =
    WeddingExpensesCompanion Function({
      required String expenseId,
      required String weddingProfileId,
      required String category,
      required String title,
      Value<double> totalEstimated,
      Value<double> totalPaid,
      Value<String> paidBySource,
      Value<String> paymentStatus,
      Value<String?> notes,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$WeddingExpensesTableUpdateCompanionBuilder =
    WeddingExpensesCompanion Function({
      Value<String> expenseId,
      Value<String> weddingProfileId,
      Value<String> category,
      Value<String> title,
      Value<double> totalEstimated,
      Value<double> totalPaid,
      Value<String> paidBySource,
      Value<String> paymentStatus,
      Value<String?> notes,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$WeddingExpensesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingExpensesTable,
          WeddingExpenseTableData
        > {
  $$WeddingExpensesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingProfilesTable _weddingProfileIdTable(_$AppDatabase db) =>
      db.weddingProfiles.createAlias(
        'wedding_expenses__wedding_profile_id__wedding_profiles__id',
      );

  $$WeddingProfilesTableProcessedTableManager get weddingProfileId {
    final $_column = $_itemColumn<String>('wedding_profile_id')!;

    final manager = $$WeddingProfilesTableTableManager(
      $_db,
      $_db.weddingProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weddingProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $WeddingPaymentTermsTable,
    List<WeddingPaymentTermTableData>
  >
  _weddingPaymentTermsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weddingPaymentTerms,
        aliasName:
            'wedding_expenses__expense_id__wedding_payment_terms__expense_id',
      );

  $$WeddingPaymentTermsTableProcessedTableManager get weddingPaymentTermsRefs {
    final manager =
        $$WeddingPaymentTermsTableTableManager(
          $_db,
          $_db.weddingPaymentTerms,
        ).filter(
          (f) => f.expenseId.expenseId.sqlEquals(
            $_itemColumn<String>('expense_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _weddingPaymentTermsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WeddingExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingExpensesTable> {
  $$WeddingExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get expenseId => $composableBuilder(
    column: $table.expenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalEstimated => $composableBuilder(
    column: $table.totalEstimated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPaid => $composableBuilder(
    column: $table.totalPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidBySource => $composableBuilder(
    column: $table.paidBySource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingProfilesTableFilterComposer get weddingProfileId {
    final $$WeddingProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableFilterComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> weddingPaymentTermsRefs(
    Expression<bool> Function($$WeddingPaymentTermsTableFilterComposer f) f,
  ) {
    final $$WeddingPaymentTermsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.weddingPaymentTerms,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingPaymentTermsTableFilterComposer(
            $db: $db,
            $table: $db.weddingPaymentTerms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeddingExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingExpensesTable> {
  $$WeddingExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get expenseId => $composableBuilder(
    column: $table.expenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalEstimated => $composableBuilder(
    column: $table.totalEstimated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPaid => $composableBuilder(
    column: $table.totalPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidBySource => $composableBuilder(
    column: $table.paidBySource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingProfilesTableOrderingComposer get weddingProfileId {
    final $$WeddingProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingExpensesTable> {
  $$WeddingExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get expenseId =>
      $composableBuilder(column: $table.expenseId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get totalEstimated => $composableBuilder(
    column: $table.totalEstimated,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPaid =>
      $composableBuilder(column: $table.totalPaid, builder: (column) => column);

  GeneratedColumn<String> get paidBySource => $composableBuilder(
    column: $table.paidBySource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WeddingProfilesTableAnnotationComposer get weddingProfileId {
    final $$WeddingProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> weddingPaymentTermsRefs<T extends Object>(
    Expression<T> Function($$WeddingPaymentTermsTableAnnotationComposer a) f,
  ) {
    final $$WeddingPaymentTermsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.expenseId,
          referencedTable: $db.weddingPaymentTerms,
          getReferencedColumn: (t) => t.expenseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeddingPaymentTermsTableAnnotationComposer(
                $db: $db,
                $table: $db.weddingPaymentTerms,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WeddingExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingExpensesTable,
          WeddingExpenseTableData,
          $$WeddingExpensesTableFilterComposer,
          $$WeddingExpensesTableOrderingComposer,
          $$WeddingExpensesTableAnnotationComposer,
          $$WeddingExpensesTableCreateCompanionBuilder,
          $$WeddingExpensesTableUpdateCompanionBuilder,
          (WeddingExpenseTableData, $$WeddingExpensesTableReferences),
          WeddingExpenseTableData,
          PrefetchHooks Function({
            bool weddingProfileId,
            bool weddingPaymentTermsRefs,
          })
        > {
  $$WeddingExpensesTableTableManager(
    _$AppDatabase db,
    $WeddingExpensesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeddingExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> expenseId = const Value.absent(),
                Value<String> weddingProfileId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> totalEstimated = const Value.absent(),
                Value<double> totalPaid = const Value.absent(),
                Value<String> paidBySource = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingExpensesCompanion(
                expenseId: expenseId,
                weddingProfileId: weddingProfileId,
                category: category,
                title: title,
                totalEstimated: totalEstimated,
                totalPaid: totalPaid,
                paidBySource: paidBySource,
                paymentStatus: paymentStatus,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String expenseId,
                required String weddingProfileId,
                required String category,
                required String title,
                Value<double> totalEstimated = const Value.absent(),
                Value<double> totalPaid = const Value.absent(),
                Value<String> paidBySource = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WeddingExpensesCompanion.insert(
                expenseId: expenseId,
                weddingProfileId: weddingProfileId,
                category: category,
                title: title,
                totalEstimated: totalEstimated,
                totalPaid: totalPaid,
                paidBySource: paidBySource,
                paymentStatus: paymentStatus,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeddingExpensesTable, WeddingExpenseTableData>(
                    table,
                  ),
                  $$WeddingExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({weddingProfileId = false, weddingPaymentTermsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weddingPaymentTermsRefs) db.weddingPaymentTerms,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (weddingProfileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.weddingProfileId,
                            referencedTable: $$WeddingExpensesTableReferences
                                ._weddingProfileIdTable(db),
                            referencedColumn: $$WeddingExpensesTableReferences
                                ._weddingProfileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weddingPaymentTermsRefs)
                        await $_getPrefetchedData<
                          WeddingExpenseTableData,
                          $WeddingExpensesTable,
                          WeddingPaymentTermTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingExpensesTableReferences
                              ._weddingPaymentTermsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingExpensesTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingPaymentTermsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expenseId == item.expenseId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WeddingExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingExpensesTable,
      WeddingExpenseTableData,
      $$WeddingExpensesTableFilterComposer,
      $$WeddingExpensesTableOrderingComposer,
      $$WeddingExpensesTableAnnotationComposer,
      $$WeddingExpensesTableCreateCompanionBuilder,
      $$WeddingExpensesTableUpdateCompanionBuilder,
      (WeddingExpenseTableData, $$WeddingExpensesTableReferences),
      WeddingExpenseTableData,
      PrefetchHooks Function({
        bool weddingProfileId,
        bool weddingPaymentTermsRefs,
      })
    >;
typedef $$WeddingPaymentTermsTableCreateCompanionBuilder =
    WeddingPaymentTermsCompanion Function({
      required String termId,
      required String expenseId,
      required String termName,
      required double amount,
      required int dueDate,
      Value<bool> isPaid,
      Value<int?> paidDate,
      Value<int> rowid,
    });
typedef $$WeddingPaymentTermsTableUpdateCompanionBuilder =
    WeddingPaymentTermsCompanion Function({
      Value<String> termId,
      Value<String> expenseId,
      Value<String> termName,
      Value<double> amount,
      Value<int> dueDate,
      Value<bool> isPaid,
      Value<int?> paidDate,
      Value<int> rowid,
    });

final class $$WeddingPaymentTermsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingPaymentTermsTable,
          WeddingPaymentTermTableData
        > {
  $$WeddingPaymentTermsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingExpensesTable _expenseIdTable(_$AppDatabase db) =>
      db.weddingExpenses.createAlias(
        'wedding_payment_terms__expense_id__wedding_expenses__expense_id',
      );

  $$WeddingExpensesTableProcessedTableManager get expenseId {
    final $_column = $_itemColumn<String>('expense_id')!;

    final manager = $$WeddingExpensesTableTableManager(
      $_db,
      $_db.weddingExpenses,
    ).filter((f) => f.expenseId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeddingPaymentTermsTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingPaymentTermsTable> {
  $$WeddingPaymentTermsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get termId => $composableBuilder(
    column: $table.termId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get termName => $composableBuilder(
    column: $table.termName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingExpensesTableFilterComposer get expenseId {
    final $$WeddingExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.weddingExpenses,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingExpensesTableFilterComposer(
            $db: $db,
            $table: $db.weddingExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingPaymentTermsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingPaymentTermsTable> {
  $$WeddingPaymentTermsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get termId => $composableBuilder(
    column: $table.termId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get termName => $composableBuilder(
    column: $table.termName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingExpensesTableOrderingComposer get expenseId {
    final $$WeddingExpensesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.weddingExpenses,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingExpensesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingPaymentTermsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingPaymentTermsTable> {
  $$WeddingPaymentTermsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get termId =>
      $composableBuilder(column: $table.termId, builder: (column) => column);

  GeneratedColumn<String> get termName =>
      $composableBuilder(column: $table.termName, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<int> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  $$WeddingExpensesTableAnnotationComposer get expenseId {
    final $$WeddingExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.weddingExpenses,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingPaymentTermsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingPaymentTermsTable,
          WeddingPaymentTermTableData,
          $$WeddingPaymentTermsTableFilterComposer,
          $$WeddingPaymentTermsTableOrderingComposer,
          $$WeddingPaymentTermsTableAnnotationComposer,
          $$WeddingPaymentTermsTableCreateCompanionBuilder,
          $$WeddingPaymentTermsTableUpdateCompanionBuilder,
          (WeddingPaymentTermTableData, $$WeddingPaymentTermsTableReferences),
          WeddingPaymentTermTableData,
          PrefetchHooks Function({bool expenseId})
        > {
  $$WeddingPaymentTermsTableTableManager(
    _$AppDatabase db,
    $WeddingPaymentTermsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingPaymentTermsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingPaymentTermsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeddingPaymentTermsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> termId = const Value.absent(),
                Value<String> expenseId = const Value.absent(),
                Value<String> termName = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int> dueDate = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<int?> paidDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingPaymentTermsCompanion(
                termId: termId,
                expenseId: expenseId,
                termName: termName,
                amount: amount,
                dueDate: dueDate,
                isPaid: isPaid,
                paidDate: paidDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String termId,
                required String expenseId,
                required String termName,
                required double amount,
                required int dueDate,
                Value<bool> isPaid = const Value.absent(),
                Value<int?> paidDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingPaymentTermsCompanion.insert(
                termId: termId,
                expenseId: expenseId,
                termName: termName,
                amount: amount,
                dueDate: dueDate,
                isPaid: isPaid,
                paidDate: paidDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $WeddingPaymentTermsTable,
                    WeddingPaymentTermTableData
                  >(table),
                  $$WeddingPaymentTermsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expenseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (expenseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.expenseId,
                        referencedTable: $$WeddingPaymentTermsTableReferences
                            ._expenseIdTable(db),
                        referencedColumn: $$WeddingPaymentTermsTableReferences
                            ._expenseIdTable(db)
                            .expenseId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeddingPaymentTermsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingPaymentTermsTable,
      WeddingPaymentTermTableData,
      $$WeddingPaymentTermsTableFilterComposer,
      $$WeddingPaymentTermsTableOrderingComposer,
      $$WeddingPaymentTermsTableAnnotationComposer,
      $$WeddingPaymentTermsTableCreateCompanionBuilder,
      $$WeddingPaymentTermsTableUpdateCompanionBuilder,
      (WeddingPaymentTermTableData, $$WeddingPaymentTermsTableReferences),
      WeddingPaymentTermTableData,
      PrefetchHooks Function({bool expenseId})
    >;
typedef $$WeddingGuestsTableCreateCompanionBuilder =
    WeddingGuestsCompanion Function({
      required String guestId,
      required String weddingProfileId,
      required String guestName,
      Value<String?> phoneNumber,
      Value<String> groupAllocation,
      Value<String> sessionTarget,
      Value<int> estimatedPax,
      Value<String> rsvpStatus,
      Value<int> rowid,
    });
typedef $$WeddingGuestsTableUpdateCompanionBuilder =
    WeddingGuestsCompanion Function({
      Value<String> guestId,
      Value<String> weddingProfileId,
      Value<String> guestName,
      Value<String?> phoneNumber,
      Value<String> groupAllocation,
      Value<String> sessionTarget,
      Value<int> estimatedPax,
      Value<String> rsvpStatus,
      Value<int> rowid,
    });

final class $$WeddingGuestsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingGuestsTable,
          WeddingGuestTableData
        > {
  $$WeddingGuestsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingProfilesTable _weddingProfileIdTable(_$AppDatabase db) => db
      .weddingProfiles
      .createAlias('wedding_guests__wedding_profile_id__wedding_profiles__id');

  $$WeddingProfilesTableProcessedTableManager get weddingProfileId {
    final $_column = $_itemColumn<String>('wedding_profile_id')!;

    final manager = $$WeddingProfilesTableTableManager(
      $_db,
      $_db.weddingProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weddingProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeddingGuestsTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingGuestsTable> {
  $$WeddingGuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get guestId => $composableBuilder(
    column: $table.guestId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guestName => $composableBuilder(
    column: $table.guestName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupAllocation => $composableBuilder(
    column: $table.groupAllocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionTarget => $composableBuilder(
    column: $table.sessionTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedPax => $composableBuilder(
    column: $table.estimatedPax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rsvpStatus => $composableBuilder(
    column: $table.rsvpStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingProfilesTableFilterComposer get weddingProfileId {
    final $$WeddingProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableFilterComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingGuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingGuestsTable> {
  $$WeddingGuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get guestId => $composableBuilder(
    column: $table.guestId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guestName => $composableBuilder(
    column: $table.guestName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupAllocation => $composableBuilder(
    column: $table.groupAllocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionTarget => $composableBuilder(
    column: $table.sessionTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedPax => $composableBuilder(
    column: $table.estimatedPax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rsvpStatus => $composableBuilder(
    column: $table.rsvpStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingProfilesTableOrderingComposer get weddingProfileId {
    final $$WeddingProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingGuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingGuestsTable> {
  $$WeddingGuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get guestId =>
      $composableBuilder(column: $table.guestId, builder: (column) => column);

  GeneratedColumn<String> get guestName =>
      $composableBuilder(column: $table.guestName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupAllocation => $composableBuilder(
    column: $table.groupAllocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionTarget => $composableBuilder(
    column: $table.sessionTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedPax => $composableBuilder(
    column: $table.estimatedPax,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rsvpStatus => $composableBuilder(
    column: $table.rsvpStatus,
    builder: (column) => column,
  );

  $$WeddingProfilesTableAnnotationComposer get weddingProfileId {
    final $$WeddingProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingGuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingGuestsTable,
          WeddingGuestTableData,
          $$WeddingGuestsTableFilterComposer,
          $$WeddingGuestsTableOrderingComposer,
          $$WeddingGuestsTableAnnotationComposer,
          $$WeddingGuestsTableCreateCompanionBuilder,
          $$WeddingGuestsTableUpdateCompanionBuilder,
          (WeddingGuestTableData, $$WeddingGuestsTableReferences),
          WeddingGuestTableData,
          PrefetchHooks Function({bool weddingProfileId})
        > {
  $$WeddingGuestsTableTableManager(_$AppDatabase db, $WeddingGuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingGuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingGuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeddingGuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> guestId = const Value.absent(),
                Value<String> weddingProfileId = const Value.absent(),
                Value<String> guestName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String> groupAllocation = const Value.absent(),
                Value<String> sessionTarget = const Value.absent(),
                Value<int> estimatedPax = const Value.absent(),
                Value<String> rsvpStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingGuestsCompanion(
                guestId: guestId,
                weddingProfileId: weddingProfileId,
                guestName: guestName,
                phoneNumber: phoneNumber,
                groupAllocation: groupAllocation,
                sessionTarget: sessionTarget,
                estimatedPax: estimatedPax,
                rsvpStatus: rsvpStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String guestId,
                required String weddingProfileId,
                required String guestName,
                Value<String?> phoneNumber = const Value.absent(),
                Value<String> groupAllocation = const Value.absent(),
                Value<String> sessionTarget = const Value.absent(),
                Value<int> estimatedPax = const Value.absent(),
                Value<String> rsvpStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingGuestsCompanion.insert(
                guestId: guestId,
                weddingProfileId: weddingProfileId,
                guestName: guestName,
                phoneNumber: phoneNumber,
                groupAllocation: groupAllocation,
                sessionTarget: sessionTarget,
                estimatedPax: estimatedPax,
                rsvpStatus: rsvpStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeddingGuestsTable, WeddingGuestTableData>(
                    table,
                  ),
                  $$WeddingGuestsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weddingProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weddingProfileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.weddingProfileId,
                        referencedTable: $$WeddingGuestsTableReferences
                            ._weddingProfileIdTable(db),
                        referencedColumn: $$WeddingGuestsTableReferences
                            ._weddingProfileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeddingGuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingGuestsTable,
      WeddingGuestTableData,
      $$WeddingGuestsTableFilterComposer,
      $$WeddingGuestsTableOrderingComposer,
      $$WeddingGuestsTableAnnotationComposer,
      $$WeddingGuestsTableCreateCompanionBuilder,
      $$WeddingGuestsTableUpdateCompanionBuilder,
      (WeddingGuestTableData, $$WeddingGuestsTableReferences),
      WeddingGuestTableData,
      PrefetchHooks Function({bool weddingProfileId})
    >;
typedef $$WeddingVendorsTableCreateCompanionBuilder =
    WeddingVendorsCompanion Function({
      required String vendorId,
      required String weddingProfileId,
      required String category,
      required String name,
      Value<String?> picName,
      Value<String?> phoneNumber,
      Value<String?> instagramHandle,
      Value<double> contractValue,
      Value<String?> notes,
      Value<String> status,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$WeddingVendorsTableUpdateCompanionBuilder =
    WeddingVendorsCompanion Function({
      Value<String> vendorId,
      Value<String> weddingProfileId,
      Value<String> category,
      Value<String> name,
      Value<String?> picName,
      Value<String?> phoneNumber,
      Value<String?> instagramHandle,
      Value<double> contractValue,
      Value<String?> notes,
      Value<String> status,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$WeddingVendorsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingVendorsTable,
          WeddingVendorTableData
        > {
  $$WeddingVendorsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingProfilesTable _weddingProfileIdTable(_$AppDatabase db) => db
      .weddingProfiles
      .createAlias('wedding_vendors__wedding_profile_id__wedding_profiles__id');

  $$WeddingProfilesTableProcessedTableManager get weddingProfileId {
    final $_column = $_itemColumn<String>('wedding_profile_id')!;

    final manager = $$WeddingProfilesTableTableManager(
      $_db,
      $_db.weddingProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weddingProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeddingVendorsTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingVendorsTable> {
  $$WeddingVendorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get picName => $composableBuilder(
    column: $table.picName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instagramHandle => $composableBuilder(
    column: $table.instagramHandle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get contractValue => $composableBuilder(
    column: $table.contractValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingProfilesTableFilterComposer get weddingProfileId {
    final $$WeddingProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableFilterComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingVendorsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingVendorsTable> {
  $$WeddingVendorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get picName => $composableBuilder(
    column: $table.picName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instagramHandle => $composableBuilder(
    column: $table.instagramHandle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get contractValue => $composableBuilder(
    column: $table.contractValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingProfilesTableOrderingComposer get weddingProfileId {
    final $$WeddingProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingVendorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingVendorsTable> {
  $$WeddingVendorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get vendorId =>
      $composableBuilder(column: $table.vendorId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get picName =>
      $composableBuilder(column: $table.picName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instagramHandle => $composableBuilder(
    column: $table.instagramHandle,
    builder: (column) => column,
  );

  GeneratedColumn<double> get contractValue => $composableBuilder(
    column: $table.contractValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WeddingProfilesTableAnnotationComposer get weddingProfileId {
    final $$WeddingProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingVendorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingVendorsTable,
          WeddingVendorTableData,
          $$WeddingVendorsTableFilterComposer,
          $$WeddingVendorsTableOrderingComposer,
          $$WeddingVendorsTableAnnotationComposer,
          $$WeddingVendorsTableCreateCompanionBuilder,
          $$WeddingVendorsTableUpdateCompanionBuilder,
          (WeddingVendorTableData, $$WeddingVendorsTableReferences),
          WeddingVendorTableData,
          PrefetchHooks Function({bool weddingProfileId})
        > {
  $$WeddingVendorsTableTableManager(
    _$AppDatabase db,
    $WeddingVendorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingVendorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingVendorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeddingVendorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> vendorId = const Value.absent(),
                Value<String> weddingProfileId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> picName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> instagramHandle = const Value.absent(),
                Value<double> contractValue = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingVendorsCompanion(
                vendorId: vendorId,
                weddingProfileId: weddingProfileId,
                category: category,
                name: name,
                picName: picName,
                phoneNumber: phoneNumber,
                instagramHandle: instagramHandle,
                contractValue: contractValue,
                notes: notes,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String vendorId,
                required String weddingProfileId,
                required String category,
                required String name,
                Value<String?> picName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> instagramHandle = const Value.absent(),
                Value<double> contractValue = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WeddingVendorsCompanion.insert(
                vendorId: vendorId,
                weddingProfileId: weddingProfileId,
                category: category,
                name: name,
                picName: picName,
                phoneNumber: phoneNumber,
                instagramHandle: instagramHandle,
                contractValue: contractValue,
                notes: notes,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeddingVendorsTable, WeddingVendorTableData>(
                    table,
                  ),
                  $$WeddingVendorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weddingProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weddingProfileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.weddingProfileId,
                        referencedTable: $$WeddingVendorsTableReferences
                            ._weddingProfileIdTable(db),
                        referencedColumn: $$WeddingVendorsTableReferences
                            ._weddingProfileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeddingVendorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingVendorsTable,
      WeddingVendorTableData,
      $$WeddingVendorsTableFilterComposer,
      $$WeddingVendorsTableOrderingComposer,
      $$WeddingVendorsTableAnnotationComposer,
      $$WeddingVendorsTableCreateCompanionBuilder,
      $$WeddingVendorsTableUpdateCompanionBuilder,
      (WeddingVendorTableData, $$WeddingVendorsTableReferences),
      WeddingVendorTableData,
      PrefetchHooks Function({bool weddingProfileId})
    >;
typedef $$WeddingTasksTableCreateCompanionBuilder =
    WeddingTasksCompanion Function({
      required String taskId,
      required String weddingProfileId,
      required int phaseMonth,
      required String title,
      Value<String?> description,
      Value<String> pic,
      Value<bool> isCompleted,
      Value<int?> dueDate,
      Value<int?> completedDate,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$WeddingTasksTableUpdateCompanionBuilder =
    WeddingTasksCompanion Function({
      Value<String> taskId,
      Value<String> weddingProfileId,
      Value<int> phaseMonth,
      Value<String> title,
      Value<String?> description,
      Value<String> pic,
      Value<bool> isCompleted,
      Value<int?> dueDate,
      Value<int?> completedDate,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$WeddingTasksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingTasksTable,
          WeddingTaskTableData
        > {
  $$WeddingTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WeddingProfilesTable _weddingProfileIdTable(_$AppDatabase db) => db
      .weddingProfiles
      .createAlias('wedding_tasks__wedding_profile_id__wedding_profiles__id');

  $$WeddingProfilesTableProcessedTableManager get weddingProfileId {
    final $_column = $_itemColumn<String>('wedding_profile_id')!;

    final manager = $$WeddingProfilesTableTableManager(
      $_db,
      $_db.weddingProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weddingProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeddingTasksTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingTasksTable> {
  $$WeddingTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phaseMonth => $composableBuilder(
    column: $table.phaseMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pic => $composableBuilder(
    column: $table.pic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingProfilesTableFilterComposer get weddingProfileId {
    final $$WeddingProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableFilterComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingTasksTable> {
  $$WeddingTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phaseMonth => $composableBuilder(
    column: $table.phaseMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pic => $composableBuilder(
    column: $table.pic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingProfilesTableOrderingComposer get weddingProfileId {
    final $$WeddingProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingTasksTable> {
  $$WeddingTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get phaseMonth => $composableBuilder(
    column: $table.phaseMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pic =>
      $composableBuilder(column: $table.pic, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$WeddingProfilesTableAnnotationComposer get weddingProfileId {
    final $$WeddingProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingTasksTable,
          WeddingTaskTableData,
          $$WeddingTasksTableFilterComposer,
          $$WeddingTasksTableOrderingComposer,
          $$WeddingTasksTableAnnotationComposer,
          $$WeddingTasksTableCreateCompanionBuilder,
          $$WeddingTasksTableUpdateCompanionBuilder,
          (WeddingTaskTableData, $$WeddingTasksTableReferences),
          WeddingTaskTableData,
          PrefetchHooks Function({bool weddingProfileId})
        > {
  $$WeddingTasksTableTableManager(_$AppDatabase db, $WeddingTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeddingTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<String> weddingProfileId = const Value.absent(),
                Value<int> phaseMonth = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> pic = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<int?> completedDate = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingTasksCompanion(
                taskId: taskId,
                weddingProfileId: weddingProfileId,
                phaseMonth: phaseMonth,
                title: title,
                description: description,
                pic: pic,
                isCompleted: isCompleted,
                dueDate: dueDate,
                completedDate: completedDate,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required String weddingProfileId,
                required int phaseMonth,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> pic = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<int?> completedDate = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingTasksCompanion.insert(
                taskId: taskId,
                weddingProfileId: weddingProfileId,
                phaseMonth: phaseMonth,
                title: title,
                description: description,
                pic: pic,
                isCompleted: isCompleted,
                dueDate: dueDate,
                completedDate: completedDate,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeddingTasksTable, WeddingTaskTableData>(table),
                  $$WeddingTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weddingProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weddingProfileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.weddingProfileId,
                        referencedTable: $$WeddingTasksTableReferences
                            ._weddingProfileIdTable(db),
                        referencedColumn: $$WeddingTasksTableReferences
                            ._weddingProfileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeddingTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingTasksTable,
      WeddingTaskTableData,
      $$WeddingTasksTableFilterComposer,
      $$WeddingTasksTableOrderingComposer,
      $$WeddingTasksTableAnnotationComposer,
      $$WeddingTasksTableCreateCompanionBuilder,
      $$WeddingTasksTableUpdateCompanionBuilder,
      (WeddingTaskTableData, $$WeddingTasksTableReferences),
      WeddingTaskTableData,
      PrefetchHooks Function({bool weddingProfileId})
    >;
typedef $$WeddingCommitteeMembersTableCreateCompanionBuilder =
    WeddingCommitteeMembersCompanion Function({
      required String memberId,
      required String weddingProfileId,
      required String memberName,
      required String role,
      Value<String> side,
      Value<String?> phoneNumber,
      Value<String?> uniformDescription,
      Value<double> fabricMeters,
      Value<String> uniformStatus,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$WeddingCommitteeMembersTableUpdateCompanionBuilder =
    WeddingCommitteeMembersCompanion Function({
      Value<String> memberId,
      Value<String> weddingProfileId,
      Value<String> memberName,
      Value<String> role,
      Value<String> side,
      Value<String?> phoneNumber,
      Value<String?> uniformDescription,
      Value<double> fabricMeters,
      Value<String> uniformStatus,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$WeddingCommitteeMembersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingCommitteeMembersTable,
          WeddingCommitteeTableData
        > {
  $$WeddingCommitteeMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingProfilesTable _weddingProfileIdTable(_$AppDatabase db) =>
      db.weddingProfiles.createAlias(
        'wedding_committee_members__wedding_profile_id__wedding_profiles__id',
      );

  $$WeddingProfilesTableProcessedTableManager get weddingProfileId {
    final $_column = $_itemColumn<String>('wedding_profile_id')!;

    final manager = $$WeddingProfilesTableTableManager(
      $_db,
      $_db.weddingProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weddingProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeddingCommitteeMembersTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingCommitteeMembersTable> {
  $$WeddingCommitteeMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberName => $composableBuilder(
    column: $table.memberName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uniformDescription => $composableBuilder(
    column: $table.uniformDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fabricMeters => $composableBuilder(
    column: $table.fabricMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uniformStatus => $composableBuilder(
    column: $table.uniformStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingProfilesTableFilterComposer get weddingProfileId {
    final $$WeddingProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableFilterComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingCommitteeMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingCommitteeMembersTable> {
  $$WeddingCommitteeMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberName => $composableBuilder(
    column: $table.memberName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uniformDescription => $composableBuilder(
    column: $table.uniformDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fabricMeters => $composableBuilder(
    column: $table.fabricMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uniformStatus => $composableBuilder(
    column: $table.uniformStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingProfilesTableOrderingComposer get weddingProfileId {
    final $$WeddingProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingCommitteeMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingCommitteeMembersTable> {
  $$WeddingCommitteeMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<String> get memberName => $composableBuilder(
    column: $table.memberName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get side =>
      $composableBuilder(column: $table.side, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uniformDescription => $composableBuilder(
    column: $table.uniformDescription,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fabricMeters => $composableBuilder(
    column: $table.fabricMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uniformStatus => $composableBuilder(
    column: $table.uniformStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$WeddingProfilesTableAnnotationComposer get weddingProfileId {
    final $$WeddingProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingCommitteeMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingCommitteeMembersTable,
          WeddingCommitteeTableData,
          $$WeddingCommitteeMembersTableFilterComposer,
          $$WeddingCommitteeMembersTableOrderingComposer,
          $$WeddingCommitteeMembersTableAnnotationComposer,
          $$WeddingCommitteeMembersTableCreateCompanionBuilder,
          $$WeddingCommitteeMembersTableUpdateCompanionBuilder,
          (WeddingCommitteeTableData, $$WeddingCommitteeMembersTableReferences),
          WeddingCommitteeTableData,
          PrefetchHooks Function({bool weddingProfileId})
        > {
  $$WeddingCommitteeMembersTableTableManager(
    _$AppDatabase db,
    $WeddingCommitteeMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingCommitteeMembersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WeddingCommitteeMembersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeddingCommitteeMembersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> memberId = const Value.absent(),
                Value<String> weddingProfileId = const Value.absent(),
                Value<String> memberName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> side = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> uniformDescription = const Value.absent(),
                Value<double> fabricMeters = const Value.absent(),
                Value<String> uniformStatus = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingCommitteeMembersCompanion(
                memberId: memberId,
                weddingProfileId: weddingProfileId,
                memberName: memberName,
                role: role,
                side: side,
                phoneNumber: phoneNumber,
                uniformDescription: uniformDescription,
                fabricMeters: fabricMeters,
                uniformStatus: uniformStatus,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String memberId,
                required String weddingProfileId,
                required String memberName,
                required String role,
                Value<String> side = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> uniformDescription = const Value.absent(),
                Value<double> fabricMeters = const Value.absent(),
                Value<String> uniformStatus = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingCommitteeMembersCompanion.insert(
                memberId: memberId,
                weddingProfileId: weddingProfileId,
                memberName: memberName,
                role: role,
                side: side,
                phoneNumber: phoneNumber,
                uniformDescription: uniformDescription,
                fabricMeters: fabricMeters,
                uniformStatus: uniformStatus,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $WeddingCommitteeMembersTable,
                    WeddingCommitteeTableData
                  >(table),
                  $$WeddingCommitteeMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weddingProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weddingProfileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.weddingProfileId,
                        referencedTable:
                            $$WeddingCommitteeMembersTableReferences
                                ._weddingProfileIdTable(db),
                        referencedColumn:
                            $$WeddingCommitteeMembersTableReferences
                                ._weddingProfileIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeddingCommitteeMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingCommitteeMembersTable,
      WeddingCommitteeTableData,
      $$WeddingCommitteeMembersTableFilterComposer,
      $$WeddingCommitteeMembersTableOrderingComposer,
      $$WeddingCommitteeMembersTableAnnotationComposer,
      $$WeddingCommitteeMembersTableCreateCompanionBuilder,
      $$WeddingCommitteeMembersTableUpdateCompanionBuilder,
      (WeddingCommitteeTableData, $$WeddingCommitteeMembersTableReferences),
      WeddingCommitteeTableData,
      PrefetchHooks Function({bool weddingProfileId})
    >;
typedef $$WeddingEventsTableCreateCompanionBuilder =
    WeddingEventsCompanion Function({
      required String eventId,
      required String weddingProfileId,
      required String eventName,
      required int eventDate,
      Value<String?> eventLocation,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$WeddingEventsTableUpdateCompanionBuilder =
    WeddingEventsCompanion Function({
      Value<String> eventId,
      Value<String> weddingProfileId,
      Value<String> eventName,
      Value<int> eventDate,
      Value<String?> eventLocation,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$WeddingEventsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingEventsTable,
          WeddingEventTableData
        > {
  $$WeddingEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingProfilesTable _weddingProfileIdTable(_$AppDatabase db) => db
      .weddingProfiles
      .createAlias('wedding_events__wedding_profile_id__wedding_profiles__id');

  $$WeddingProfilesTableProcessedTableManager get weddingProfileId {
    final $_column = $_itemColumn<String>('wedding_profile_id')!;

    final manager = $$WeddingProfilesTableTableManager(
      $_db,
      $_db.weddingProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weddingProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $WeddingRundownItemsTable,
    List<WeddingRundownItemTableData>
  >
  _weddingRundownItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weddingRundownItems,
        aliasName: 'wedding_events__event_id__wedding_rundown_items__event_id',
      );

  $$WeddingRundownItemsTableProcessedTableManager get weddingRundownItemsRefs {
    final manager =
        $$WeddingRundownItemsTableTableManager(
          $_db,
          $_db.weddingRundownItems,
        ).filter(
          (f) => f.eventId.eventId.sqlEquals($_itemColumn<String>('event_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _weddingRundownItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WeddingEventsTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingEventsTable> {
  $$WeddingEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventName => $composableBuilder(
    column: $table.eventName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventLocation => $composableBuilder(
    column: $table.eventLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingProfilesTableFilterComposer get weddingProfileId {
    final $$WeddingProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableFilterComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> weddingRundownItemsRefs(
    Expression<bool> Function($$WeddingRundownItemsTableFilterComposer f) f,
  ) {
    final $$WeddingRundownItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.weddingRundownItems,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingRundownItemsTableFilterComposer(
            $db: $db,
            $table: $db.weddingRundownItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeddingEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingEventsTable> {
  $$WeddingEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventName => $composableBuilder(
    column: $table.eventName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventLocation => $composableBuilder(
    column: $table.eventLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingProfilesTableOrderingComposer get weddingProfileId {
    final $$WeddingProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingEventsTable> {
  $$WeddingEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get eventName =>
      $composableBuilder(column: $table.eventName, builder: (column) => column);

  GeneratedColumn<int> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get eventLocation => $composableBuilder(
    column: $table.eventLocation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$WeddingProfilesTableAnnotationComposer get weddingProfileId {
    final $$WeddingProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> weddingRundownItemsRefs<T extends Object>(
    Expression<T> Function($$WeddingRundownItemsTableAnnotationComposer a) f,
  ) {
    final $$WeddingRundownItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.eventId,
          referencedTable: $db.weddingRundownItems,
          getReferencedColumn: (t) => t.eventId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeddingRundownItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.weddingRundownItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WeddingEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingEventsTable,
          WeddingEventTableData,
          $$WeddingEventsTableFilterComposer,
          $$WeddingEventsTableOrderingComposer,
          $$WeddingEventsTableAnnotationComposer,
          $$WeddingEventsTableCreateCompanionBuilder,
          $$WeddingEventsTableUpdateCompanionBuilder,
          (WeddingEventTableData, $$WeddingEventsTableReferences),
          WeddingEventTableData,
          PrefetchHooks Function({
            bool weddingProfileId,
            bool weddingRundownItemsRefs,
          })
        > {
  $$WeddingEventsTableTableManager(_$AppDatabase db, $WeddingEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeddingEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<String> weddingProfileId = const Value.absent(),
                Value<String> eventName = const Value.absent(),
                Value<int> eventDate = const Value.absent(),
                Value<String?> eventLocation = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingEventsCompanion(
                eventId: eventId,
                weddingProfileId: weddingProfileId,
                eventName: eventName,
                eventDate: eventDate,
                eventLocation: eventLocation,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required String weddingProfileId,
                required String eventName,
                required int eventDate,
                Value<String?> eventLocation = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingEventsCompanion.insert(
                eventId: eventId,
                weddingProfileId: weddingProfileId,
                eventName: eventName,
                eventDate: eventDate,
                eventLocation: eventLocation,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeddingEventsTable, WeddingEventTableData>(
                    table,
                  ),
                  $$WeddingEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({weddingProfileId = false, weddingRundownItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weddingRundownItemsRefs) db.weddingRundownItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (weddingProfileId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.weddingProfileId,
                            referencedTable: $$WeddingEventsTableReferences
                                ._weddingProfileIdTable(db),
                            referencedColumn: $$WeddingEventsTableReferences
                                ._weddingProfileIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weddingRundownItemsRefs)
                        await $_getPrefetchedData<
                          WeddingEventTableData,
                          $WeddingEventsTable,
                          WeddingRundownItemTableData
                        >(
                          currentTable: table,
                          referencedTable: $$WeddingEventsTableReferences
                              ._weddingRundownItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeddingEventsTableReferences(
                                db,
                                table,
                                p0,
                              ).weddingRundownItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.eventId == item.eventId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WeddingEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingEventsTable,
      WeddingEventTableData,
      $$WeddingEventsTableFilterComposer,
      $$WeddingEventsTableOrderingComposer,
      $$WeddingEventsTableAnnotationComposer,
      $$WeddingEventsTableCreateCompanionBuilder,
      $$WeddingEventsTableUpdateCompanionBuilder,
      (WeddingEventTableData, $$WeddingEventsTableReferences),
      WeddingEventTableData,
      PrefetchHooks Function({
        bool weddingProfileId,
        bool weddingRundownItemsRefs,
      })
    >;
typedef $$WeddingRundownItemsTableCreateCompanionBuilder =
    WeddingRundownItemsCompanion Function({
      required String itemId,
      required String eventId,
      Value<String> timeStart,
      Value<int> durationMinutes,
      required String sessionTitle,
      Value<String?> pic,
      Value<String?> mcScript,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$WeddingRundownItemsTableUpdateCompanionBuilder =
    WeddingRundownItemsCompanion Function({
      Value<String> itemId,
      Value<String> eventId,
      Value<String> timeStart,
      Value<int> durationMinutes,
      Value<String> sessionTitle,
      Value<String?> pic,
      Value<String?> mcScript,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$WeddingRundownItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingRundownItemsTable,
          WeddingRundownItemTableData
        > {
  $$WeddingRundownItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingEventsTable _eventIdTable(_$AppDatabase db) => db.weddingEvents
      .createAlias('wedding_rundown_items__event_id__wedding_events__event_id');

  $$WeddingEventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<String>('event_id')!;

    final manager = $$WeddingEventsTableTableManager(
      $_db,
      $_db.weddingEvents,
    ).filter((f) => f.eventId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeddingRundownItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingRundownItemsTable> {
  $$WeddingRundownItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeStart => $composableBuilder(
    column: $table.timeStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionTitle => $composableBuilder(
    column: $table.sessionTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pic => $composableBuilder(
    column: $table.pic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mcScript => $composableBuilder(
    column: $table.mcScript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingEventsTableFilterComposer get eventId {
    final $$WeddingEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.weddingEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingEventsTableFilterComposer(
            $db: $db,
            $table: $db.weddingEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingRundownItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingRundownItemsTable> {
  $$WeddingRundownItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeStart => $composableBuilder(
    column: $table.timeStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionTitle => $composableBuilder(
    column: $table.sessionTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pic => $composableBuilder(
    column: $table.pic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mcScript => $composableBuilder(
    column: $table.mcScript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingEventsTableOrderingComposer get eventId {
    final $$WeddingEventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.weddingEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingEventsTableOrderingComposer(
            $db: $db,
            $table: $db.weddingEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingRundownItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingRundownItemsTable> {
  $$WeddingRundownItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get timeStart =>
      $composableBuilder(column: $table.timeStart, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionTitle => $composableBuilder(
    column: $table.sessionTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pic =>
      $composableBuilder(column: $table.pic, builder: (column) => column);

  GeneratedColumn<String> get mcScript =>
      $composableBuilder(column: $table.mcScript, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$WeddingEventsTableAnnotationComposer get eventId {
    final $$WeddingEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.weddingEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingRundownItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingRundownItemsTable,
          WeddingRundownItemTableData,
          $$WeddingRundownItemsTableFilterComposer,
          $$WeddingRundownItemsTableOrderingComposer,
          $$WeddingRundownItemsTableAnnotationComposer,
          $$WeddingRundownItemsTableCreateCompanionBuilder,
          $$WeddingRundownItemsTableUpdateCompanionBuilder,
          (WeddingRundownItemTableData, $$WeddingRundownItemsTableReferences),
          WeddingRundownItemTableData,
          PrefetchHooks Function({bool eventId})
        > {
  $$WeddingRundownItemsTableTableManager(
    _$AppDatabase db,
    $WeddingRundownItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingRundownItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingRundownItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeddingRundownItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> timeStart = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> sessionTitle = const Value.absent(),
                Value<String?> pic = const Value.absent(),
                Value<String?> mcScript = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingRundownItemsCompanion(
                itemId: itemId,
                eventId: eventId,
                timeStart: timeStart,
                durationMinutes: durationMinutes,
                sessionTitle: sessionTitle,
                pic: pic,
                mcScript: mcScript,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String eventId,
                Value<String> timeStart = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                required String sessionTitle,
                Value<String?> pic = const Value.absent(),
                Value<String?> mcScript = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingRundownItemsCompanion.insert(
                itemId: itemId,
                eventId: eventId,
                timeStart: timeStart,
                durationMinutes: durationMinutes,
                sessionTitle: sessionTitle,
                pic: pic,
                mcScript: mcScript,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $WeddingRundownItemsTable,
                    WeddingRundownItemTableData
                  >(table),
                  $$WeddingRundownItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$WeddingRundownItemsTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$WeddingRundownItemsTableReferences
                            ._eventIdTable(db)
                            .eventId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeddingRundownItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingRundownItemsTable,
      WeddingRundownItemTableData,
      $$WeddingRundownItemsTableFilterComposer,
      $$WeddingRundownItemsTableOrderingComposer,
      $$WeddingRundownItemsTableAnnotationComposer,
      $$WeddingRundownItemsTableCreateCompanionBuilder,
      $$WeddingRundownItemsTableUpdateCompanionBuilder,
      (WeddingRundownItemTableData, $$WeddingRundownItemsTableReferences),
      WeddingRundownItemTableData,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$WeddingSeserahansTableCreateCompanionBuilder =
    WeddingSeserahansCompanion Function({
      required String itemId,
      required String weddingProfileId,
      Value<String> direction,
      required String itemName,
      Value<int> quantity,
      Value<double> estimatedPrice,
      Value<String> status,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$WeddingSeserahansTableUpdateCompanionBuilder =
    WeddingSeserahansCompanion Function({
      Value<String> itemId,
      Value<String> weddingProfileId,
      Value<String> direction,
      Value<String> itemName,
      Value<int> quantity,
      Value<double> estimatedPrice,
      Value<String> status,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$WeddingSeserahansTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingSeserahansTable,
          WeddingSeserahanTableData
        > {
  $$WeddingSeserahansTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingProfilesTable _weddingProfileIdTable(_$AppDatabase db) =>
      db.weddingProfiles.createAlias(
        'wedding_seserahans__wedding_profile_id__wedding_profiles__id',
      );

  $$WeddingProfilesTableProcessedTableManager get weddingProfileId {
    final $_column = $_itemColumn<String>('wedding_profile_id')!;

    final manager = $$WeddingProfilesTableTableManager(
      $_db,
      $_db.weddingProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weddingProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeddingSeserahansTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingSeserahansTable> {
  $$WeddingSeserahansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedPrice => $composableBuilder(
    column: $table.estimatedPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingProfilesTableFilterComposer get weddingProfileId {
    final $$WeddingProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableFilterComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingSeserahansTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingSeserahansTable> {
  $$WeddingSeserahansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedPrice => $composableBuilder(
    column: $table.estimatedPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingProfilesTableOrderingComposer get weddingProfileId {
    final $$WeddingProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingSeserahansTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingSeserahansTable> {
  $$WeddingSeserahansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get estimatedPrice => $composableBuilder(
    column: $table.estimatedPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$WeddingProfilesTableAnnotationComposer get weddingProfileId {
    final $$WeddingProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingSeserahansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingSeserahansTable,
          WeddingSeserahanTableData,
          $$WeddingSeserahansTableFilterComposer,
          $$WeddingSeserahansTableOrderingComposer,
          $$WeddingSeserahansTableAnnotationComposer,
          $$WeddingSeserahansTableCreateCompanionBuilder,
          $$WeddingSeserahansTableUpdateCompanionBuilder,
          (WeddingSeserahanTableData, $$WeddingSeserahansTableReferences),
          WeddingSeserahanTableData,
          PrefetchHooks Function({bool weddingProfileId})
        > {
  $$WeddingSeserahansTableTableManager(
    _$AppDatabase db,
    $WeddingSeserahansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingSeserahansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingSeserahansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeddingSeserahansTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> weddingProfileId = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> estimatedPrice = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingSeserahansCompanion(
                itemId: itemId,
                weddingProfileId: weddingProfileId,
                direction: direction,
                itemName: itemName,
                quantity: quantity,
                estimatedPrice: estimatedPrice,
                status: status,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String weddingProfileId,
                Value<String> direction = const Value.absent(),
                required String itemName,
                Value<int> quantity = const Value.absent(),
                Value<double> estimatedPrice = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingSeserahansCompanion.insert(
                itemId: itemId,
                weddingProfileId: weddingProfileId,
                direction: direction,
                itemName: itemName,
                quantity: quantity,
                estimatedPrice: estimatedPrice,
                status: status,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $WeddingSeserahansTable,
                    WeddingSeserahanTableData
                  >(table),
                  $$WeddingSeserahansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weddingProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weddingProfileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.weddingProfileId,
                        referencedTable: $$WeddingSeserahansTableReferences
                            ._weddingProfileIdTable(db),
                        referencedColumn: $$WeddingSeserahansTableReferences
                            ._weddingProfileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeddingSeserahansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingSeserahansTable,
      WeddingSeserahanTableData,
      $$WeddingSeserahansTableFilterComposer,
      $$WeddingSeserahansTableOrderingComposer,
      $$WeddingSeserahansTableAnnotationComposer,
      $$WeddingSeserahansTableCreateCompanionBuilder,
      $$WeddingSeserahansTableUpdateCompanionBuilder,
      (WeddingSeserahanTableData, $$WeddingSeserahansTableReferences),
      WeddingSeserahanTableData,
      PrefetchHooks Function({bool weddingProfileId})
    >;
typedef $$WeddingDocumentsTableCreateCompanionBuilder =
    WeddingDocumentsCompanion Function({
      required String docId,
      required String weddingProfileId,
      required String docName,
      Value<String> ownerType,
      Value<bool> isCompleted,
      Value<String?> localFilePath,
      Value<double> adminCost,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$WeddingDocumentsTableUpdateCompanionBuilder =
    WeddingDocumentsCompanion Function({
      Value<String> docId,
      Value<String> weddingProfileId,
      Value<String> docName,
      Value<String> ownerType,
      Value<bool> isCompleted,
      Value<String?> localFilePath,
      Value<double> adminCost,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$WeddingDocumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeddingDocumentsTable,
          WeddingDocumentTableData
        > {
  $$WeddingDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeddingProfilesTable _weddingProfileIdTable(_$AppDatabase db) =>
      db.weddingProfiles.createAlias(
        'wedding_documents__wedding_profile_id__wedding_profiles__id',
      );

  $$WeddingProfilesTableProcessedTableManager get weddingProfileId {
    final $_column = $_itemColumn<String>('wedding_profile_id')!;

    final manager = $$WeddingProfilesTableTableManager(
      $_db,
      $_db.weddingProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weddingProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeddingDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $WeddingDocumentsTable> {
  $$WeddingDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get docId => $composableBuilder(
    column: $table.docId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get docName => $composableBuilder(
    column: $table.docName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get adminCost => $composableBuilder(
    column: $table.adminCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$WeddingProfilesTableFilterComposer get weddingProfileId {
    final $$WeddingProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableFilterComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeddingDocumentsTable> {
  $$WeddingDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get docId => $composableBuilder(
    column: $table.docId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get docName => $composableBuilder(
    column: $table.docName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get adminCost => $composableBuilder(
    column: $table.adminCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeddingProfilesTableOrderingComposer get weddingProfileId {
    final $$WeddingProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeddingDocumentsTable> {
  $$WeddingDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get docId =>
      $composableBuilder(column: $table.docId, builder: (column) => column);

  GeneratedColumn<String> get docName =>
      $composableBuilder(column: $table.docName, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get adminCost =>
      $composableBuilder(column: $table.adminCost, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$WeddingProfilesTableAnnotationComposer get weddingProfileId {
    final $$WeddingProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weddingProfileId,
      referencedTable: $db.weddingProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeddingProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.weddingProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeddingDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeddingDocumentsTable,
          WeddingDocumentTableData,
          $$WeddingDocumentsTableFilterComposer,
          $$WeddingDocumentsTableOrderingComposer,
          $$WeddingDocumentsTableAnnotationComposer,
          $$WeddingDocumentsTableCreateCompanionBuilder,
          $$WeddingDocumentsTableUpdateCompanionBuilder,
          (WeddingDocumentTableData, $$WeddingDocumentsTableReferences),
          WeddingDocumentTableData,
          PrefetchHooks Function({bool weddingProfileId})
        > {
  $$WeddingDocumentsTableTableManager(
    _$AppDatabase db,
    $WeddingDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeddingDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeddingDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeddingDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> docId = const Value.absent(),
                Value<String> weddingProfileId = const Value.absent(),
                Value<String> docName = const Value.absent(),
                Value<String> ownerType = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> localFilePath = const Value.absent(),
                Value<double> adminCost = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingDocumentsCompanion(
                docId: docId,
                weddingProfileId: weddingProfileId,
                docName: docName,
                ownerType: ownerType,
                isCompleted: isCompleted,
                localFilePath: localFilePath,
                adminCost: adminCost,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String docId,
                required String weddingProfileId,
                required String docName,
                Value<String> ownerType = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> localFilePath = const Value.absent(),
                Value<double> adminCost = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeddingDocumentsCompanion.insert(
                docId: docId,
                weddingProfileId: weddingProfileId,
                docName: docName,
                ownerType: ownerType,
                isCompleted: isCompleted,
                localFilePath: localFilePath,
                adminCost: adminCost,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeddingDocumentsTable, WeddingDocumentTableData>(
                    table,
                  ),
                  $$WeddingDocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weddingProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weddingProfileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.weddingProfileId,
                        referencedTable: $$WeddingDocumentsTableReferences
                            ._weddingProfileIdTable(db),
                        referencedColumn: $$WeddingDocumentsTableReferences
                            ._weddingProfileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeddingDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeddingDocumentsTable,
      WeddingDocumentTableData,
      $$WeddingDocumentsTableFilterComposer,
      $$WeddingDocumentsTableOrderingComposer,
      $$WeddingDocumentsTableAnnotationComposer,
      $$WeddingDocumentsTableCreateCompanionBuilder,
      $$WeddingDocumentsTableUpdateCompanionBuilder,
      (WeddingDocumentTableData, $$WeddingDocumentsTableReferences),
      WeddingDocumentTableData,
      PrefetchHooks Function({bool weddingProfileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WeddingProfilesTableTableManager get weddingProfiles =>
      $$WeddingProfilesTableTableManager(_db, _db.weddingProfiles);
  $$WeddingExpensesTableTableManager get weddingExpenses =>
      $$WeddingExpensesTableTableManager(_db, _db.weddingExpenses);
  $$WeddingPaymentTermsTableTableManager get weddingPaymentTerms =>
      $$WeddingPaymentTermsTableTableManager(_db, _db.weddingPaymentTerms);
  $$WeddingGuestsTableTableManager get weddingGuests =>
      $$WeddingGuestsTableTableManager(_db, _db.weddingGuests);
  $$WeddingVendorsTableTableManager get weddingVendors =>
      $$WeddingVendorsTableTableManager(_db, _db.weddingVendors);
  $$WeddingTasksTableTableManager get weddingTasks =>
      $$WeddingTasksTableTableManager(_db, _db.weddingTasks);
  $$WeddingCommitteeMembersTableTableManager get weddingCommitteeMembers =>
      $$WeddingCommitteeMembersTableTableManager(
        _db,
        _db.weddingCommitteeMembers,
      );
  $$WeddingEventsTableTableManager get weddingEvents =>
      $$WeddingEventsTableTableManager(_db, _db.weddingEvents);
  $$WeddingRundownItemsTableTableManager get weddingRundownItems =>
      $$WeddingRundownItemsTableTableManager(_db, _db.weddingRundownItems);
  $$WeddingSeserahansTableTableManager get weddingSeserahans =>
      $$WeddingSeserahansTableTableManager(_db, _db.weddingSeserahans);
  $$WeddingDocumentsTableTableManager get weddingDocuments =>
      $$WeddingDocumentsTableTableManager(_db, _db.weddingDocuments);
}
