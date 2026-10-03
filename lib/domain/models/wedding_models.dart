// Domain Models for Nikahin Wedding Planner

class WeddingProfile {
  final String id;
  final String groomName;
  final String brideName;
  final int weddingDate;
  final double totalBudgetCap;
  final String religionType; // ISLAM | NON_ISLAM
  final String? religionDetail;
  final String? culturalPresetGroom;
  final String? culturalPresetBride;
  final String? quote;
  final bool quoteEnabled;
  final String quoteFontSize; // KECIL | SEDANG | BESAR
  final String quoteFontStyle; // NORMAL | BOLD | ITALIC | BOLD_ITALIC
  final int createdAt;

  const WeddingProfile({
    required this.id,
    required this.groomName,
    required this.brideName,
    required this.weddingDate,
    this.totalBudgetCap = 0.0,
    this.religionType = 'ISLAM',
    this.religionDetail = 'ISLAM',
    this.culturalPresetGroom = 'MODERN',
    this.culturalPresetBride = 'MODERN',
    this.quote = 'Perjalanan cinta yang luar biasa dimulai dari sini.',
    this.quoteEnabled = true,
    this.quoteFontSize = 'SEDANG',
    this.quoteFontStyle = 'ITALIC',
    required this.createdAt,
  });

  String get coupleTitle => '$groomName & $brideName';

  WeddingProfile copyWith({
    String? id,
    String? groomName,
    String? brideName,
    int? weddingDate,
    double? totalBudgetCap,
    String? religionType,
    String? religionDetail,
    String? culturalPresetGroom,
    String? culturalPresetBride,
    String? quote,
    bool? quoteEnabled,
    String? quoteFontSize,
    String? quoteFontStyle,
    int? createdAt,
  }) {
    return WeddingProfile(
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
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'id': id,
        'groomName': groomName,
        'brideName': brideName,
        'weddingDate': weddingDate,
        'totalBudgetCap': totalBudgetCap,
        'religionType': religionType,
        'religionDetail': religionDetail,
        'culturalPresetGroom': culturalPresetGroom,
        'culturalPresetBride': culturalPresetBride,
        'quote': quote,
        'quoteEnabled': quoteEnabled,
        'quoteFontSize': quoteFontSize,
        'quoteFontStyle': quoteFontStyle,
        'createdAt': createdAt,
      };

  factory WeddingProfile.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingProfile(
      id: id,
      groomName: map['groomName'] ?? '',
      brideName: map['brideName'] ?? '',
      weddingDate: (map['weddingDate'] as num?)?.toInt() ?? 0,
      totalBudgetCap: (map['totalBudgetCap'] as num?)?.toDouble() ?? 0.0,
      religionType: map['religionType'] ?? 'ISLAM',
      religionDetail: map['religionDetail'],
      culturalPresetGroom: map['culturalPresetGroom'],
      culturalPresetBride: map['culturalPresetBride'],
      quote: map['quote'] ?? 'Perjalanan cinta yang luar biasa dimulai dari sini.',
      quoteEnabled: map['quoteEnabled'] ?? true,
      quoteFontSize: map['quoteFontSize'] ?? 'SEDANG',
      quoteFontStyle: map['quoteFontStyle'] ?? 'ITALIC',
      createdAt: (map['createdAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class WeddingExpense {
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

  const WeddingExpense({
    required this.expenseId,
    required this.weddingProfileId,
    required this.category,
    required this.title,
    this.totalEstimated = 0.0,
    this.totalPaid = 0.0,
    this.paidBySource = 'BERSAMA',
    this.paymentStatus = 'UNPAID',
    this.notes,
    required this.createdAt,
  });

  WeddingExpense copyWith({
    String? expenseId,
    String? weddingProfileId,
    String? category,
    String? title,
    double? totalEstimated,
    double? totalPaid,
    String? paidBySource,
    String? paymentStatus,
    String? notes,
    int? createdAt,
  }) {
    return WeddingExpense(
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
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'expenseId': expenseId,
        'weddingProfileId': weddingProfileId,
        'category': category,
        'title': title,
        'totalEstimated': totalEstimated,
        'totalPaid': totalPaid,
        'paidBySource': paidBySource,
        'paymentStatus': paymentStatus,
        'notes': notes,
        'createdAt': createdAt,
      };

  factory WeddingExpense.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingExpense(
      expenseId: id,
      weddingProfileId: map['weddingProfileId'] ?? '',
      category: map['category'] ?? 'LAINNYA',
      title: map['title'] ?? '',
      totalEstimated: (map['totalEstimated'] as num?)?.toDouble() ?? 0.0,
      totalPaid: (map['totalPaid'] as num?)?.toDouble() ?? 0.0,
      paidBySource: map['paidBySource'] ?? 'BERSAMA',
      paymentStatus: map['paymentStatus'] ?? 'UNPAID',
      notes: map['notes'],
      createdAt: (map['createdAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class WeddingPaymentTerm {
  final String termId;
  final String expenseId;
  final String termName;
  final double amount;
  final int dueDate;
  final bool isPaid;
  final int? paidDate;

  const WeddingPaymentTerm({
    required this.termId,
    required this.expenseId,
    required this.termName,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    this.paidDate,
  });

  WeddingPaymentTerm copyWith({
    String? termId,
    String? expenseId,
    String? termName,
    double? amount,
    int? dueDate,
    bool? isPaid,
    int? paidDate,
  }) {
    return WeddingPaymentTerm(
      termId: termId ?? this.termId,
      expenseId: expenseId ?? this.expenseId,
      termName: termName ?? this.termName,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'termId': termId,
        'expenseId': expenseId,
        'termName': termName,
        'amount': amount,
        'dueDate': dueDate,
        'isPaid': isPaid,
        'paidDate': paidDate,
      };

  factory WeddingPaymentTerm.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingPaymentTerm(
      termId: id,
      expenseId: map['expenseId'] ?? '',
      termName: map['termName'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      dueDate: (map['dueDate'] as num?)?.toInt() ?? 0,
      isPaid: map['isPaid'] ?? false,
      paidDate: (map['paidDate'] as num?)?.toInt(),
    );
  }
}

class WeddingGuest {
  final String guestId;
  final String weddingProfileId;
  final String guestName;
  final String? phoneNumber;
  final String groupAllocation;
  final String sessionTarget;
  final int estimatedPax;
  final String rsvpStatus;

  const WeddingGuest({
    required this.guestId,
    required this.weddingProfileId,
    required this.guestName,
    this.phoneNumber,
    this.groupAllocation = 'TEMAN_CPP',
    this.sessionTarget = 'KEDUANYA',
    this.estimatedPax = 2,
    this.rsvpStatus = 'PENDING',
  });

  WeddingGuest copyWith({
    String? guestId,
    String? weddingProfileId,
    String? guestName,
    String? phoneNumber,
    String? groupAllocation,
    String? sessionTarget,
    int? estimatedPax,
    String? rsvpStatus,
  }) {
    return WeddingGuest(
      guestId: guestId ?? this.guestId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      guestName: guestName ?? this.guestName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      groupAllocation: groupAllocation ?? this.groupAllocation,
      sessionTarget: sessionTarget ?? this.sessionTarget,
      estimatedPax: estimatedPax ?? this.estimatedPax,
      rsvpStatus: rsvpStatus ?? this.rsvpStatus,
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'guestId': guestId,
        'weddingProfileId': weddingProfileId,
        'guestName': guestName,
        'phoneNumber': phoneNumber,
        'groupAllocation': groupAllocation,
        'sessionTarget': sessionTarget,
        'estimatedPax': estimatedPax,
        'rsvpStatus': rsvpStatus,
      };

  factory WeddingGuest.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingGuest(
      guestId: id,
      weddingProfileId: map['weddingProfileId'] ?? '',
      guestName: map['guestName'] ?? '',
      phoneNumber: map['phoneNumber'],
      groupAllocation: map['groupAllocation'] ?? 'TEMAN_CPP',
      sessionTarget: map['sessionTarget'] ?? 'KEDUANYA',
      estimatedPax: (map['estimatedPax'] as num?)?.toInt() ?? 2,
      rsvpStatus: map['rsvpStatus'] ?? 'PENDING',
    );
  }
}

class WeddingVendor {
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

  const WeddingVendor({
    required this.vendorId,
    required this.weddingProfileId,
    required this.category,
    required this.name,
    this.picName,
    this.phoneNumber,
    this.instagramHandle,
    this.contractValue = 0.0,
    this.notes,
    this.status = 'PROSPEK',
    required this.createdAt,
  });

  WeddingVendor copyWith({
    String? vendorId,
    String? weddingProfileId,
    String? category,
    String? name,
    String? picName,
    String? phoneNumber,
    String? instagramHandle,
    double? contractValue,
    String? notes,
    String? status,
    int? createdAt,
  }) {
    return WeddingVendor(
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
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'vendorId': vendorId,
        'weddingProfileId': weddingProfileId,
        'category': category,
        'name': name,
        'picName': picName,
        'phoneNumber': phoneNumber,
        'instagramHandle': instagramHandle,
        'contractValue': contractValue,
        'notes': notes,
        'status': status,
        'createdAt': createdAt,
      };

  factory WeddingVendor.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingVendor(
      vendorId: id,
      weddingProfileId: map['weddingProfileId'] ?? '',
      category: map['category'] ?? 'LAINNYA',
      name: map['name'] ?? '',
      picName: map['picName'],
      phoneNumber: map['phoneNumber'],
      instagramHandle: map['instagramHandle'],
      contractValue: (map['contractValue'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes'],
      status: map['status'] ?? 'PROSPEK',
      createdAt: (map['createdAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class WeddingTask {
  final String taskId;
  final String weddingProfileId;
  final int phaseMonth; // 12, 6, 3, 1, 0 (Hari H)
  final String title;
  final String? description;
  final String pic;
  final bool isCompleted;
  final int? dueDate;
  final int? completedDate;
  final int sortOrder;

  const WeddingTask({
    required this.taskId,
    required this.weddingProfileId,
    required this.phaseMonth,
    required this.title,
    this.description,
    this.pic = 'BOTH',
    this.isCompleted = false,
    this.dueDate,
    this.completedDate,
    this.sortOrder = 0,
  });

  WeddingTask copyWith({
    String? taskId,
    String? weddingProfileId,
    int? phaseMonth,
    String? title,
    String? description,
    String? pic,
    bool? isCompleted,
    int? dueDate,
    int? completedDate,
    int? sortOrder,
  }) {
    return WeddingTask(
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
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'taskId': taskId,
        'weddingProfileId': weddingProfileId,
        'phaseMonth': phaseMonth,
        'title': title,
        'description': description,
        'pic': pic,
        'isCompleted': isCompleted,
        'dueDate': dueDate,
        'completedDate': completedDate,
        'sortOrder': sortOrder,
      };

  factory WeddingTask.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingTask(
      taskId: id,
      weddingProfileId: map['weddingProfileId'] ?? '',
      phaseMonth: (map['phaseMonth'] as num?)?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'],
      pic: map['pic'] ?? 'BOTH',
      isCompleted: map['isCompleted'] ?? false,
      dueDate: (map['dueDate'] as num?)?.toInt(),
      completedDate: (map['completedDate'] as num?)?.toInt(),
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeddingCommitteeMember {
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

  const WeddingCommitteeMember({
    required this.memberId,
    required this.weddingProfileId,
    required this.memberName,
    required this.role,
    this.side = 'KELUARGA_CPP',
    this.phoneNumber,
    this.uniformDescription,
    this.fabricMeters = 0.0,
    this.uniformStatus = 'BELUM_DIBAGI',
    this.sortOrder = 0,
  });

  WeddingCommitteeMember copyWith({
    String? memberId,
    String? weddingProfileId,
    String? memberName,
    String? role,
    String? side,
    String? phoneNumber,
    String? uniformDescription,
    double? fabricMeters,
    String? uniformStatus,
    int? sortOrder,
  }) {
    return WeddingCommitteeMember(
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
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'memberId': memberId,
        'weddingProfileId': weddingProfileId,
        'memberName': memberName,
        'role': role,
        'side': side,
        'phoneNumber': phoneNumber,
        'uniformDescription': uniformDescription,
        'fabricMeters': fabricMeters,
        'uniformStatus': uniformStatus,
        'sortOrder': sortOrder,
      };

  factory WeddingCommitteeMember.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingCommitteeMember(
      memberId: id,
      weddingProfileId: map['weddingProfileId'] ?? '',
      memberName: map['memberName'] ?? '',
      role: map['role'] ?? '',
      side: map['side'] ?? 'KELUARGA_CPP',
      phoneNumber: map['phoneNumber'],
      uniformDescription: map['uniformDescription'],
      fabricMeters: (map['fabricMeters'] as num?)?.toDouble() ?? 0.0,
      uniformStatus: map['uniformStatus'] ?? 'BELUM_DIBAGI',
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeddingEvent {
  final String eventId;
  final String weddingProfileId;
  final String eventName;
  final int eventDate;
  final String? eventLocation;
  final int sortOrder;

  const WeddingEvent({
    required this.eventId,
    required this.weddingProfileId,
    required this.eventName,
    required this.eventDate,
    this.eventLocation,
    this.sortOrder = 0,
  });

  WeddingEvent copyWith({
    String? eventId,
    String? weddingProfileId,
    String? eventName,
    int? eventDate,
    String? eventLocation,
    int? sortOrder,
  }) {
    return WeddingEvent(
      eventId: eventId ?? this.eventId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'eventId': eventId,
        'weddingProfileId': weddingProfileId,
        'eventName': eventName,
        'eventDate': eventDate,
        'eventLocation': eventLocation,
        'sortOrder': sortOrder,
      };

  factory WeddingEvent.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingEvent(
      eventId: id,
      weddingProfileId: map['weddingProfileId'] ?? '',
      eventName: map['eventName'] ?? '',
      eventDate: (map['eventDate'] as num?)?.toInt() ?? 0,
      eventLocation: map['eventLocation'],
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeddingRundownItem {
  final String itemId;
  final String eventId;
  final String timeStart;
  final int durationMinutes;
  final String sessionTitle;
  final String? pic;
  final String? mcScript;
  final int sortOrder;

  const WeddingRundownItem({
    required this.itemId,
    required this.eventId,
    required this.timeStart,
    this.durationMinutes = 15,
    required this.sessionTitle,
    this.pic,
    this.mcScript,
    this.sortOrder = 0,
  });

  WeddingRundownItem copyWith({
    String? itemId,
    String? eventId,
    String? timeStart,
    int? durationMinutes,
    String? sessionTitle,
    String? pic,
    String? mcScript,
    int? sortOrder,
  }) {
    return WeddingRundownItem(
      itemId: itemId ?? this.itemId,
      eventId: eventId ?? this.eventId,
      timeStart: timeStart ?? this.timeStart,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      pic: pic ?? this.pic,
      mcScript: mcScript ?? this.mcScript,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'itemId': itemId,
        'eventId': eventId,
        'timeStart': timeStart,
        'durationMinutes': durationMinutes,
        'sessionTitle': sessionTitle,
        'pic': pic,
        'mcScript': mcScript,
        'sortOrder': sortOrder,
      };

  factory WeddingRundownItem.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingRundownItem(
      itemId: id,
      eventId: map['eventId'] ?? '',
      timeStart: map['timeStart'] ?? '08:00',
      durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 15,
      sessionTitle: map['sessionTitle'] ?? '',
      pic: map['pic'],
      mcScript: map['mcScript'],
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeddingSeserahan {
  final String itemId;
  final String weddingProfileId;
  final String direction; // SESERAHAN_CPP | BALASAN_CPW | MAHAR
  final String itemName;
  final int quantity;
  final double estimatedPrice;
  final String status; // BELUM_BELI | DIBELI | WRAPPING | SIAP
  final String? notes;
  final int sortOrder;

  const WeddingSeserahan({
    required this.itemId,
    required this.weddingProfileId,
    required this.direction,
    required this.itemName,
    this.quantity = 1,
    this.estimatedPrice = 0.0,
    this.status = 'BELUM_BELI',
    this.notes,
    this.sortOrder = 0,
  });

  WeddingSeserahan copyWith({
    String? itemId,
    String? weddingProfileId,
    String? direction,
    String? itemName,
    int? quantity,
    double? estimatedPrice,
    String? status,
    String? notes,
    int? sortOrder,
  }) {
    return WeddingSeserahan(
      itemId: itemId ?? this.itemId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      direction: direction ?? this.direction,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'itemId': itemId,
        'weddingProfileId': weddingProfileId,
        'direction': direction,
        'itemName': itemName,
        'quantity': quantity,
        'estimatedPrice': estimatedPrice,
        'status': status,
        'notes': notes,
        'sortOrder': sortOrder,
      };

  factory WeddingSeserahan.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingSeserahan(
      itemId: id,
      weddingProfileId: map['weddingProfileId'] ?? '',
      direction: map['direction'] ?? 'SESERAHAN_CPP',
      itemName: map['itemName'] ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      estimatedPrice: (map['estimatedPrice'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'BELUM_BELI',
      notes: map['notes'],
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeddingDocument {
  final String docId;
  final String weddingProfileId;
  final String docName;
  final String ownerType; // GROOM | BRIDE | BOTH
  final bool isCompleted;
  final String? localFilePath;
  final double adminCost;
  final int sortOrder;
  final int? dueDate;

  const WeddingDocument({
    required this.docId,
    required this.weddingProfileId,
    required this.docName,
    this.ownerType = 'BOTH',
    this.isCompleted = false,
    this.localFilePath,
    this.adminCost = 0.0,
    this.sortOrder = 0,
    this.dueDate,
  });

  WeddingDocument copyWith({
    String? docId,
    String? weddingProfileId,
    String? docName,
    String? ownerType,
    bool? isCompleted,
    String? localFilePath,
    double? adminCost,
    int? sortOrder,
    int? dueDate,
  }) {
    return WeddingDocument(
      docId: docId ?? this.docId,
      weddingProfileId: weddingProfileId ?? this.weddingProfileId,
      docName: docName ?? this.docName,
      ownerType: ownerType ?? this.ownerType,
      isCompleted: isCompleted ?? this.isCompleted,
      localFilePath: localFilePath ?? this.localFilePath,
      adminCost: adminCost ?? this.adminCost,
      sortOrder: sortOrder ?? this.sortOrder,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
        'docId': docId,
        'weddingProfileId': weddingProfileId,
        'docName': docName,
        'ownerType': ownerType,
        'isCompleted': isCompleted,
        'localFilePath': localFilePath,
        'adminCost': adminCost,
        'sortOrder': sortOrder,
        'dueDate': dueDate,
      };

  factory WeddingDocument.fromFirestoreMap(Map<String, dynamic> map, String id) {
    return WeddingDocument(
      docId: id,
      weddingProfileId: map['weddingProfileId'] ?? '',
      docName: map['docName'] ?? '',
      ownerType: map['ownerType'] ?? 'BOTH',
      isCompleted: map['isCompleted'] ?? false,
      localFilePath: map['localFilePath'],
      adminCost: (map['adminCost'] as num?)?.toDouble() ?? 0.0,
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
      dueDate: (map['dueDate'] as num?)?.toInt(),
    );
  }
}
