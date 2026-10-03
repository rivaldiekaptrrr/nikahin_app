// Domain enums for Nikahin Wedding Planner

enum ReligionType {
  islam('ISLAM', 'Islam (KUA)'),
  nonIslam('NON_ISLAM', 'Non-Islam (Catatan Sipil)');

  final String value;
  final String label;
  const ReligionType(this.value, this.label);

  static ReligionType fromString(String? val) {
    if (val == 'NON_ISLAM') return ReligionType.nonIslam;
    return ReligionType.islam;
  }
}

enum ReligionDetail {
  islam('ISLAM', 'Islam'),
  kristen('KRISTEN', 'Kristen Protestan'),
  katolik('KATOLIK', 'Katolik'),
  hindu('HINDU', 'Hindu'),
  buddha('BUDDHA', 'Buddha'),
  konghucu('KONGHUCU', 'Konghucu'),
  lainnya('LAINNYA', 'Lainnya');

  final String value;
  final String label;
  const ReligionDetail(this.value, this.label);

  static ReligionDetail fromString(String? val) {
    return ReligionDetail.values.firstWhere(
      (e) => e.value == val,
      orElse: () => ReligionDetail.islam,
    );
  }
}

enum CulturalPreset {
  jawa('JAWA', 'Jawa'),
  sunda('SUNDA', 'Sunda'),
  batak('BATAK', 'Batak'),
  minang('MINANG', 'Minang'),
  bugisMakassar('BUGIS_MAKASSAR', 'Bugis / Makassar'),
  bali('BALI', 'Bali'),
  betawi('BETAWI', 'Betawi'),
  tionghoa('TIONGHOA', 'Tionghoa'),
  modern('MODERN', 'Modern / Nasional'),
  lainnya('LAINNYA', 'Lainnya / Umum');

  final String value;
  final String label;
  const CulturalPreset(this.value, this.label);

  static CulturalPreset fromString(String? val) {
    return CulturalPreset.values.firstWhere(
      (e) => e.value == val,
      orElse: () => CulturalPreset.modern,
    );
  }
}

enum ExpenseCategory {
  venue('VENUE', 'Venue & Gedung'),
  catering('CATERING', 'Katering'),
  decor('DECOR', 'Dekorasi'),
  mua('MUA', 'MUA & Busana'),
  dokumentasi('DOKUMENTASI', 'Dokumentasi & Video'),
  seserahan('SESERAHAN', 'Seserahan & Mahar'),
  undangan('UNDANGAN', 'Undangan & Souvenir'),
  lainnya('LAINNYA', 'Lainnya');

  final String value;
  final String label;
  const ExpenseCategory(this.value, this.label);

  static ExpenseCategory fromString(String? val) {
    if (val == null) return ExpenseCategory.lainnya;
    final upper = val.toUpperCase().trim();
    switch (upper) {
      case 'VENUE':
      case 'GEDUNG':
        return ExpenseCategory.venue;
      case 'CATERING':
      case 'KATERING':
        return ExpenseCategory.catering;
      case 'DECOR':
      case 'DECORATION':
      case 'DEKORASI':
        return ExpenseCategory.decor;
      case 'MUA':
      case 'ATTIRE':
      case 'BUSANA':
      case 'MUA_BUSANA':
      case 'MAKEUP':
        return ExpenseCategory.mua;
      case 'DOKUMENTASI':
      case 'PHOTOGRAPHY':
      case 'FOTO':
      case 'VIDEO':
      case 'PHOTO':
        return ExpenseCategory.dokumentasi;
      case 'SESERAHAN':
      case 'MAHAR':
      case 'HANTARAN':
        return ExpenseCategory.seserahan;
      case 'UNDANGAN':
      case 'INVITATION':
      case 'SOUVENIR':
      case 'UNDANGAN_SOUVENIR':
        return ExpenseCategory.undangan;
      case 'LAINNYA':
      case 'OTHER':
      case 'ENTERTAINMENT':
      case 'HEALTH':
      case 'DOCUMENT':
      default:
        return ExpenseCategory.values.firstWhere(
          (e) => e.value == upper,
          orElse: () => ExpenseCategory.lainnya,
        );
    }
  }
}

enum PaidBySource {
  tabunganCpp('TABUNGAN_CPP', 'Tabungan CPP'),
  tabunganCpw('TABUNGAN_CPW', 'Tabungan CPW'),
  ortuCpp('ORTU_CPP', 'Orang Tua CPP'),
  ortuCpw('ORTU_CPW', 'Orang Tua CPW'),
  bersama('BERSAMA', 'Dana Bersama');

  final String value;
  final String label;
  const PaidBySource(this.value, this.label);

  static PaidBySource fromString(String? val) {
    return PaidBySource.values.firstWhere(
      (e) => e.value == val,
      orElse: () => PaidBySource.bersama,
    );
  }
}

enum PaymentStatus {
  unpaid('UNPAID', 'Belum Bayar'),
  partialDp('PARTIAL_DP', 'DP / Sebagian'),
  fullyPaid('FULLY_PAID', 'Lunas');

  final String value;
  final String label;
  const PaymentStatus(this.value, this.label);

  static PaymentStatus fromString(String? val) {
    return PaymentStatus.values.firstWhere(
      (e) => e.value == val,
      orElse: () => PaymentStatus.unpaid,
    );
  }
}

enum GuestGroup {
  keluargaCpp('KELUARGA_CPP', 'Keluarga CPP'),
  keluargaCpw('KELUARGA_CPW', 'Keluarga CPW'),
  temanCpp('TEMAN_CPP', 'Teman CPP'),
  temanCpw('TEMAN_CPW', 'Teman CPW'),
  vip('VIP', 'Tamu VIP'),
  lainnya('LAINNYA', 'Umum / Lainnya');

  final String value;
  final String label;
  const GuestGroup(this.value, this.label);

  static GuestGroup fromString(String? val) {
    return GuestGroup.values.firstWhere(
      (e) => e.value == val,
      orElse: () => GuestGroup.temanCpp,
    );
  }
}

enum SessionTarget {
  akad('AKAD', 'Akad / Pemberkatan Saja'),
  resepsi('RESEPSI', 'Resepsi Saja'),
  keduanya('KEDUANYA', 'Akad & Resepsi');

  final String value;
  final String label;
  const SessionTarget(this.value, this.label);

  static SessionTarget fromString(String? val) {
    return SessionTarget.values.firstWhere(
      (e) => e.value == val,
      orElse: () => SessionTarget.keduanya,
    );
  }
}

enum RsvpStatus {
  pending('PENDING', 'Menunggu'),
  attending('ATTENDING', 'Hadir'),
  declined('DECLINED', 'Tidak Hadir');

  final String value;
  final String label;
  const RsvpStatus(this.value, this.label);

  static RsvpStatus fromString(String? val) {
    return RsvpStatus.values.firstWhere(
      (e) => e.value == val,
      orElse: () => RsvpStatus.pending,
    );
  }
}

enum VendorStatus {
  prospek('PROSPEK', 'Prospek / Riset'),
  tandaJadi('TANDA_JADI', 'Tanda Jadi / Booking'),
  kontrak('KONTRAK', 'Kontrak Aktif'),
  selesai('SELESAI', 'Selesai');

  final String value;
  final String label;
  const VendorStatus(this.value, this.label);

  static VendorStatus fromString(String? val) {
    return VendorStatus.values.firstWhere(
      (e) => e.value == val,
      orElse: () => VendorStatus.prospek,
    );
  }
}

enum TaskPic {
  groom('GROOM', 'CPP (Pria)'),
  bride('BRIDE', 'CPW (Wanita)'),
  both('BOTH', 'Bersama'),
  family('FAMILY', 'Keluarga'),
  wo('WO', 'Wedding Organizer');

  final String value;
  final String label;
  const TaskPic(this.value, this.label);

  static TaskPic fromString(String? val) {
    return TaskPic.values.firstWhere(
      (e) => e.value == val,
      orElse: () => TaskPic.both,
    );
  }
}

enum CommitteeSide {
  keluargaCpp('KELUARGA_CPP', 'Keluarga CPP'),
  keluargaCpw('KELUARGA_CPW', 'Keluarga CPW'),
  temanCpp('TEMAN_CPP', 'Teman CPP'),
  temanCpw('TEMAN_CPW', 'Teman CPW');

  final String value;
  final String label;
  const CommitteeSide(this.value, this.label);

  static CommitteeSide fromString(String? val) {
    return CommitteeSide.values.firstWhere(
      (e) => e.value == val,
      orElse: () => CommitteeSide.keluargaCpp,
    );
  }
}

enum UniformStatus {
  belumDibagi('BELUM_DIBAGI', 'Belum Dibagi'),
  sedangJahit('SEDANG_JAHIT', 'Sedang Jahit'),
  siapPakai('SIAP_PAKAI', 'Siap Pakai');

  final String value;
  final String label;
  const UniformStatus(this.value, this.label);

  static UniformStatus fromString(String? val) {
    return UniformStatus.values.firstWhere(
      (e) => e.value == val,
      orElse: () => UniformStatus.belumDibagi,
    );
  }
}

enum SeserahanDirection {
  seserahanCpp('SESERAHAN_CPP', 'Seserahan (CPP → CPW)'),
  balasanCpw('BALASAN_CPW', 'Balasan (CPW → CPP)'),
  mahar('MAHAR', 'Mahar Pernikahan');

  final String value;
  final String label;
  const SeserahanDirection(this.value, this.label);

  static SeserahanDirection fromString(String? val) {
    return SeserahanDirection.values.firstWhere(
      (e) => e.value == val,
      orElse: () => SeserahanDirection.seserahanCpp,
    );
  }
}

enum SeserahanStatus {
  belumBeli('BELUM_BELI', 'Belum Beli'),
  dibeli('DIBELI', 'Sudah Dibeli'),
  wrapping('WRAPPING', 'Sedang Dihias'),
  siap('SIAP', 'Siap');

  final String value;
  final String label;
  const SeserahanStatus(this.value, this.label);

  static SeserahanStatus fromString(String? val) {
    return SeserahanStatus.values.firstWhere(
      (e) => e.value == val,
      orElse: () => SeserahanStatus.belumBeli,
    );
  }
}

enum DocumentOwnerType {
  groom('GROOM', 'CPP (Pria)'),
  bride('BRIDE', 'CPW (Wanita)'),
  both('BOTH', 'Bersama / Berdua');

  final String value;
  final String label;
  const DocumentOwnerType(this.value, this.label);

  static DocumentOwnerType fromString(String? val) {
    return DocumentOwnerType.values.firstWhere(
      (e) => e.value == val,
      orElse: () => DocumentOwnerType.both,
    );
  }
}
