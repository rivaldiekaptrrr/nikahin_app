import '../../domain/models/wedding_models.dart';
import 'database.dart';

class MockSeeder {
  static const String primaryMockProfileId = 'profile_rivaldi_alya';
  static final int targetWeddingDate = DateTime(2027, 11, 10, 8, 0).millisecondsSinceEpoch;
  static const double targetBudgetCap = 50000000.0;

  /// Cek apakah profil demo di SQLite belum ada atau masih memakai data lama
  static bool isOutdated(WeddingProfile? profile) {
    if (profile == null) return true;
    return profile.totalBudgetCap != targetBudgetCap || profile.weddingDate != targetWeddingDate;
  }

  /// Seed complete mock data across all 10 wedding modules into SQLite database
  static Future<void> seedAllMockData(AppDatabase db) async {
    // 1. Single Wedding Profile (Rama & Sinta)
    final now = DateTime.now();
    final weddingDate = targetWeddingDate;

    final primaryProfile = WeddingProfile(
      id: primaryMockProfileId,
      groomName: 'Rama',
      brideName: 'Sinta',
      weddingDate: weddingDate,
      totalBudgetCap: targetBudgetCap,
      religionType: 'ISLAM',
      culturalPresetGroom: 'SUNDA',
      culturalPresetBride: 'JAWA',
      quote: 'Mencintai bukan tentang saling memandang, melainkan memandang bersama ke arah yang sama.',
      quoteEnabled: true,
      quoteFontSize: 'SEDANG',
      quoteFontStyle: 'ITALIC',
      createdAt: now.subtract(const Duration(days: 60)).millisecondsSinceEpoch,
    );

    // Clean up all existing mock entities to ensure a completely fresh, consistent seed
    await (db.delete(db.weddingExpenses)..where((t) => t.weddingProfileId.equals(primaryMockProfileId))).go();
    await (db.delete(db.weddingPaymentTerms)).go();
    await (db.delete(db.weddingVendors)..where((t) => t.weddingProfileId.equals(primaryMockProfileId))).go();
    await (db.delete(db.weddingDocuments)..where((t) => t.weddingProfileId.equals(primaryMockProfileId))).go();
    await (db.delete(db.weddingEvents)..where((t) => t.weddingProfileId.equals(primaryMockProfileId))).go();
    await (db.delete(db.weddingRundownItems)).go();
    await (db.delete(db.weddingTasks)..where((t) => t.weddingProfileId.equals(primaryMockProfileId))).go();
    await (db.delete(db.weddingGuests)..where((t) => t.weddingProfileId.equals(primaryMockProfileId))).go();
    await (db.delete(db.weddingCommitteeMembers)..where((t) => t.weddingProfileId.equals(primaryMockProfileId))).go();
    await (db.delete(db.weddingSeserahans)..where((t) => t.weddingProfileId.equals(primaryMockProfileId))).go();

    await db.insertProfile(primaryProfile);

    // 2. Expenses (Anggaran Realistis 8 Kategori Inti Tanpa Kategori 'LAINNYA' - Pagu 50 Juta)
    final expenses = <WeddingExpense>[
      WeddingExpense(
        expenseId: 'exp_1',
        weddingProfileId: primaryMockProfileId,
        title: 'Sewa Aula Pertemuan Serbaguna',
        category: 'VENUE',
        totalEstimated: 10000000.0,
        totalPaid: 10000000.0,
        paidBySource: 'BERSAMA',
        paymentStatus: 'FULLY_PAID',
        notes: 'Sewa gedung pertemuan, panggung pelaminan, kursi tamu & sound system',
        createdAt: now.subtract(const Duration(days: 45)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_2',
        weddingProfileId: primaryMockProfileId,
        title: 'Katering Prasmanan 250 Pax + 2 Gubukan',
        category: 'CATERING',
        totalEstimated: 16000000.0,
        totalPaid: 10000000.0,
        paidBySource: 'TABUNGAN_CPP',
        paymentStatus: 'PARTIAL_DP',
        notes: 'Menu prasmanan nusantara, stall sate ayam, siomay bandung & dessert buah segar',
        createdAt: now.subtract(const Duration(days: 40)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_3',
        weddingProfileId: primaryMockProfileId,
        title: 'Dekorasi Pelaminan Modern Minimalis',
        category: 'DECOR',
        totalEstimated: 6000000.0,
        totalPaid: 3000000.0,
        paidBySource: 'ORTU_CPP',
        paymentStatus: 'PARTIAL_DP',
        notes: 'Konsep Modern Rustic Minimalis dengan backdrop bunga, pergola jalan & photobooth',
        createdAt: now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_4',
        weddingProfileId: primaryMockProfileId,
        title: 'Sewa Busana Akad, Resepsi & Beskap Keluarga',
        category: 'BUSANA',
        totalEstimated: 4500000.0,
        totalPaid: 2500000.0,
        paidBySource: 'TABUNGAN_CPW',
        paymentStatus: 'PARTIAL_DP',
        notes: 'Sewa kebaya akad putih, gaun modern resepsi, beskap CPP & beskap orang tua',
        createdAt: now.subtract(const Duration(days: 28)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_5',
        weddingProfileId: primaryMockProfileId,
        title: 'Paket MUA Pengantin & Ibu Mempelai',
        category: 'MUA',
        totalEstimated: 3500000.0,
        totalPaid: 3500000.0,
        paidBySource: 'TABUNGAN_CPW',
        paymentStatus: 'FULLY_PAID',
        notes: 'Rias & hijab styling pengantin akad + resepsi, serta rias 2 ibu mempelai',
        createdAt: now.subtract(const Duration(days: 25)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_6',
        weddingProfileId: primaryMockProfileId,
        title: 'Foto & Cinematic Video Liputan Hari-H',
        category: 'DOKUMENTASI',
        totalEstimated: 4500000.0,
        totalPaid: 4500000.0,
        paidBySource: 'BERSAMA',
        paymentStatus: 'FULLY_PAID',
        notes: '1 Fotografer, 1 Videografer all-day, album cetak kolase & file cinematic video',
        createdAt: now.subtract(const Duration(days: 24)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_7',
        weddingProfileId: primaryMockProfileId,
        title: 'Logam Mulia Antam & Frame Mahar 3D',
        category: 'SESERAHAN',
        totalEstimated: 3500000.0,
        totalPaid: 3500000.0,
        paidBySource: 'TABUNGAN_CPP',
        paymentStatus: 'FULLY_PAID',
        notes: 'Emas batangan Antam bersertifikat & jasa custom hias pigura mahar akrilik 3D',
        createdAt: now.subtract(const Duration(days: 18)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_8',
        weddingProfileId: primaryMockProfileId,
        title: 'Undangan Digital Web & Cetak Mini 150 Pcs',
        category: 'UNDANGAN',
        totalEstimated: 1000000.0,
        totalPaid: 1000000.0,
        paidBySource: 'TABUNGAN_CPP',
        paymentStatus: 'FULLY_PAID',
        notes: 'Undangan web interaktif tamu tanpa batas & cetak fisik 150 lembar untuk kerabat',
        createdAt: now.subtract(const Duration(days: 15)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_9',
        weddingProfileId: primaryMockProfileId,
        title: 'Souvenir Pouch Dompet & Kartu Ucapan',
        category: 'UNDANGAN',
        totalEstimated: 1000000.0,
        totalPaid: 500000.0,
        paidBySource: 'TABUNGAN_CPW',
        paymentStatus: 'PARTIAL_DP',
        notes: 'Souvenir pouch kulit sintetis kemasan rapi dilengkapi kartu ucapan terima kasih',
        createdAt: now.subtract(const Duration(days: 12)).millisecondsSinceEpoch,
      ),
    ];

    for (final exp in expenses) {
      await db.insertExpense(exp);
    }

    // 2.1 Payment Terms & History (Termin Pembayaran)
    final paymentTerms = <WeddingPaymentTerm>[
      // exp_1: Venue (10jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_1_1',
        expenseId: 'exp_1',
        termName: 'DP 1 Booking Aula & Kunci Tanggal (30%)',
        amount: 3000000.0,
        dueDate: now.subtract(const Duration(days: 40)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 40)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_1_2',
        expenseId: 'exp_1',
        termName: 'Termin 2 Technical Meeting & Layout (40%)',
        amount: 4000000.0,
        dueDate: now.subtract(const Duration(days: 20)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 20)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_1_3',
        expenseId: 'exp_1',
        termName: 'Pelunasan Final Sewa Aula (30%)',
        amount: 3000000.0,
        dueDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
      ),

      // exp_2: Catering (16jt - DP 10jt, Sisa 6jt)
      WeddingPaymentTerm(
        termId: 'term_2_1',
        expenseId: 'exp_2',
        termName: 'DP 1 Booking Tanggal & Paket 250 Pax',
        amount: 5000000.0,
        dueDate: now.subtract(const Duration(days: 35)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 35)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_2_2',
        expenseId: 'exp_2',
        termName: 'Termin 2 Test Food & Tambah Stall',
        amount: 5000000.0,
        dueDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_2_3',
        expenseId: 'exp_2',
        termName: 'Pelunasan H-7 Final Porsi Katering',
        amount: 6000000.0,
        dueDate: weddingDate - const Duration(days: 7).inMilliseconds,
        isPaid: false,
      ),

      // exp_3: Decor (6jt - DP 3jt, Sisa 3jt)
      WeddingPaymentTerm(
        termId: 'term_3_1',
        expenseId: 'exp_3',
        termName: 'DP Desain Pelaminan & Photobooth',
        amount: 3000000.0,
        dueDate: now.subtract(const Duration(days: 25)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 25)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_3_2',
        expenseId: 'exp_3',
        termName: 'Pelunasan H-1 Loading Properti Dekorasi',
        amount: 3000000.0,
        dueDate: weddingDate - const Duration(days: 1).inMilliseconds,
        isPaid: false,
      ),

      // exp_4: Busana (4.5jt - DP 2.5jt, Sisa 2jt)
      WeddingPaymentTerm(
        termId: 'term_4_1',
        expenseId: 'exp_4',
        termName: 'DP Fitting Busana Akad & Resepsi',
        amount: 2500000.0,
        dueDate: now.subtract(const Duration(days: 25)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 25)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_4_2',
        expenseId: 'exp_4',
        termName: 'Pelunasan H-3 Pengambilan Busana',
        amount: 2000000.0,
        dueDate: weddingDate - const Duration(days: 3).inMilliseconds,
        isPaid: false,
      ),

      // exp_5: MUA (3.5jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_5_1',
        expenseId: 'exp_5',
        termName: 'DP Booking Jadwal MUA Akad & Resepsi',
        amount: 1500000.0,
        dueDate: now.subtract(const Duration(days: 20)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 20)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_5_2',
        expenseId: 'exp_5',
        termName: 'Pelunasan H-7 Trial Makeup Selesai',
        amount: 2000000.0,
        dueDate: now.subtract(const Duration(days: 6)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 6)).millisecondsSinceEpoch,
      ),

      // exp_6: Dokumentasi (4.5jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_6_1',
        expenseId: 'exp_6',
        termName: 'DP Booking Tim Liputan Dokumentasi',
        amount: 2000000.0,
        dueDate: now.subtract(const Duration(days: 24)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 24)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_6_2',
        expenseId: 'exp_6',
        termName: 'Pelunasan H-2 Sebelum Liputan Acara',
        amount: 2500000.0,
        dueDate: now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
      ),

      // exp_7: Seserahan & Mahar (3.5jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_7_1',
        expenseId: 'exp_7',
        termName: 'Pembelian Logam Mulia Antam',
        amount: 2500000.0,
        dueDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_7_2',
        expenseId: 'exp_7',
        termName: 'Jasa Desain Frame Akrilik & Hias Mahar 3D',
        amount: 1000000.0,
        dueDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
      ),

      // exp_8: Undangan (1jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_8_1',
        expenseId: 'exp_8',
        termName: 'Pelunasan Cetak 150 Undangan & Aktivasi Web',
        amount: 1000000.0,
        dueDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),

      // exp_9: Souvenir (1jt - DP 500rb, Sisa 500rb)
      WeddingPaymentTerm(
        termId: 'term_9_1',
        expenseId: 'exp_9',
        termName: 'DP Produksi Pouch Kulit 150 Pcs & Custom Tag',
        amount: 500000.0,
        dueDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_9_2',
        expenseId: 'exp_9',
        termName: 'Pelunasan Pengiriman Souvenir & Tag Ucapan',
        amount: 500000.0,
        dueDate: now.add(const Duration(days: 10)).millisecondsSinceEpoch,
        isPaid: false,
      ),
    ];

    for (final term in paymentTerms) {
      await db.insertPaymentTerm(term);
    }

    // 3. Guests (Buku Tamu)
    final guests = <WeddingGuest>[
      const WeddingGuest(
        guestId: 'guest_1',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Bpk. Ir. H. Hendra Gunawan & Kel.',
        phoneNumber: '081234567890',
        groupAllocation: 'KELUARGA_CPP',
        sessionTarget: 'ALL',
        estimatedPax: 3,
        rsvpStatus: 'ATTENDING',
      ),
      const WeddingGuest(
        guestId: 'guest_2',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Ibu Hj. Ratna Sari & Keluarga',
        phoneNumber: '081298765432',
        groupAllocation: 'KELUARGA_CPW',
        sessionTarget: 'ALL',
        estimatedPax: 2,
        rsvpStatus: 'ATTENDING',
      ),
      const WeddingGuest(
        guestId: 'guest_3',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Direktur Utama PT Maju Sejahtera',
        phoneNumber: '081122334455',
        groupAllocation: 'VIP',
        sessionTarget: 'RESEPSI',
        estimatedPax: 2,
        rsvpStatus: 'ATTENDING',
      ),
      const WeddingGuest(
        guestId: 'guest_4',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Ahmad Fauzi & Partner',
        phoneNumber: '085712345678',
        groupAllocation: 'TEMAN_CPP',
        sessionTarget: 'RESEPSI',
        estimatedPax: 2,
        rsvpStatus: 'ATTENDING',
      ),
      const WeddingGuest(
        guestId: 'guest_5',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Clarissa Amanda, S.Kom',
        phoneNumber: '087812345678',
        groupAllocation: 'TEMAN_CPW',
        sessionTarget: 'RESEPSI',
        estimatedPax: 1,
        rsvpStatus: 'ATTENDING',
      ),
      const WeddingGuest(
        guestId: 'guest_6',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Kevin Sanjaya',
        phoneNumber: '081345678901',
        groupAllocation: 'TEMAN_CPP',
        sessionTarget: 'RESEPSI',
        estimatedPax: 2,
        rsvpStatus: 'TENTATIVE',
      ),
      const WeddingGuest(
        guestId: 'guest_7',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Dian Sastrowardoyo',
        phoneNumber: '081876543210',
        groupAllocation: 'TEMAN_CPW',
        sessionTarget: 'RESEPSI',
        estimatedPax: 1,
        rsvpStatus: 'DECLINED',
      ),
      const WeddingGuest(
        guestId: 'guest_8',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Bpk. RW 05 H. Muhidin',
        phoneNumber: '081399887766',
        groupAllocation: 'KELUARGA_CPP',
        sessionTarget: 'AKAD',
        estimatedPax: 2,
        rsvpStatus: 'ATTENDING',
      ),
      const WeddingGuest(
        guestId: 'guest_9',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Rian Ardianto',
        phoneNumber: '081233445566',
        groupAllocation: 'TEMAN_CPP',
        sessionTarget: 'RESEPSI',
        estimatedPax: 2,
        rsvpStatus: 'PENDING',
      ),
      const WeddingGuest(
        guestId: 'guest_10',
        weddingProfileId: primaryMockProfileId,
        guestName: 'Keluarga Besar Bani Hasan',
        phoneNumber: '081266778899',
        groupAllocation: 'KELUARGA_CPW',
        sessionTarget: 'ALL',
        estimatedPax: 5,
        rsvpStatus: 'ATTENDING',
      ),
    ];

    for (final g in guests) {
      await db.insertGuest(g);
    }

    // 4. Vendors (Manajemen Vendor)
    final vendors = <WeddingVendor>[
      WeddingVendor(
        vendorId: 'ven_1',
        weddingProfileId: primaryMockProfileId,
        category: 'VENUE',
        name: 'Aula Pertemuan Serbaguna',
        picName: 'Bpk. Bambang Pamungkas',
        phoneNumber: '081234567890',
        status: 'KONTRAK',
        contractValue: 10000000.0,
        notes: 'Kapasitas 300 standing/seating, full AC, sound system & technical meeting H-10',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_2',
        weddingProfileId: primaryMockProfileId,
        category: 'CATERING',
        name: 'Sedaap Rasa Catering & Bakery',
        picName: 'Ibu Hj. Maya Indah',
        phoneNumber: '081345678901',
        status: 'KONTRAK',
        contractValue: 16000000.0,
        notes: 'Paket prasmanan 250 pax, bonus es krim & puding cup',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_3',
        weddingProfileId: primaryMockProfileId,
        category: 'DECOR',
        name: 'Mahkota Wedding Decoration',
        picName: 'Mas Reza Aditya',
        phoneNumber: '081567890123',
        status: 'KONTRAK',
        contractValue: 6000000.0,
        notes: 'Pelaminan 6 meter minimalis, pergola masuk & karpet jalan',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_4',
        weddingProfileId: primaryMockProfileId,
        category: 'DOKUMENTASI',
        name: 'Diamond Cinematic Studio',
        picName: 'Mas Dimas Pratama',
        phoneNumber: '081789012345',
        status: 'SELESAI',
        contractValue: 4500000.0,
        notes: 'Prewed outdoor selesai, liputan all-day Hari-H siap on-time 06:00',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_5',
        weddingProfileId: primaryMockProfileId,
        category: 'BUSANA',
        name: 'Sanggar Busana Tradisional & Modern',
        picName: 'Teh Winda Kartika',
        phoneNumber: '081901234567',
        status: 'KONTRAK',
        contractValue: 4500000.0,
        notes: 'Fitting busana akad & resepsi serta beskap orang tua selesai',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_6',
        weddingProfileId: primaryMockProfileId,
        category: 'MUA',
        name: 'Glow Artistry MUA & Hijab Do',
        picName: 'Mbak Cindy Claudia',
        phoneNumber: '082123456789',
        status: 'SELESAI',
        contractValue: 3500000.0,
        notes: 'Trial rias pengantin selesai & pelunasan jadwal Hari-H',
        createdAt: now.millisecondsSinceEpoch,
      ),
    ];

    for (final v in vendors) {
      await db.insertVendor(v);
    }

    // 5. Tasks (Timeline & Checklist)
    final d12 = weddingDate - (365 * 24 * 60 * 60 * 1000);
    final d6 = weddingDate - (180 * 24 * 60 * 60 * 1000);
    final d3 = weddingDate - (90 * 24 * 60 * 60 * 1000);
    final d1 = weddingDate - (30 * 24 * 60 * 60 * 1000);
    final dW1 = weddingDate - (7 * 24 * 60 * 60 * 1000);

    final tasks = <WeddingTask>[
      WeddingTask(
        taskId: 'task_1',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 12,
        title: 'Tentukan tanggal dan booking gedung pertemuan',
        description: 'Telah dibayar DP booking di Aula Pertemuan Serbaguna',
        pic: 'BOTH',
        dueDate: d12,
        isCompleted: true,
        sortOrder: 1,
      ),
      WeddingTask(
        taskId: 'task_2',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 12,
        title: 'Pilih & booking Wedding Organizer (WO)',
        description: 'Kontrak paket all-in 8 kru',
        pic: 'BOTH',
        dueDate: d12,
        isCompleted: true,
        sortOrder: 2,
      ),
      WeddingTask(
        taskId: 'task_3',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 6,
        title: 'Food tasting & finalisasi menu katering',
        description: 'Pilihan menu nusantara dan western stall',
        pic: 'BOTH',
        dueDate: d6,
        isCompleted: true,
        sortOrder: 3,
      ),
      WeddingTask(
        taskId: 'task_4',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 6,
        title: 'Sesi foto & video Pre-Wedding',
        description: 'Foto di studio dan alam terbuka Lembang',
        pic: 'BOTH',
        dueDate: d6,
        isCompleted: true,
        sortOrder: 4,
      ),
      WeddingTask(
        taskId: 'task_5',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 3,
        title: 'Fitting busana pengantin & seragam keluarga',
        description: 'Pastikan ukuran kebaya dan beskap nyaman dipakai',
        pic: 'BOTH',
        dueDate: d3,
        isCompleted: false,
        sortOrder: 5,
      ),
      WeddingTask(
        taskId: 'task_6',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 1,
        title: 'Cetak dan sebar undangan fisik & broadcast digital',
        description: 'Prioritaskan tamu luar kota dan sesepuh keluarga',
        pic: 'GROOM',
        dueDate: d1,
        isCompleted: false,
        sortOrder: 6,
      ),
      WeddingTask(
        taskId: 'task_7',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 1,
        title: 'Beli kotak & hias isi seserahan/hantaran',
        description: 'Bungkus rapi dengan akrilik transparan',
        pic: 'BRIDE',
        dueDate: d1,
        isCompleted: false,
        sortOrder: 7,
      ),
      WeddingTask(
        taskId: 'task_8',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 1,
        title: 'Technical Meeting (TM) seluruh vendor di venue',
        description: 'Koordinasi rundown, layout dekorasi, & sound check',
        pic: 'WO',
        dueDate: dW1,
        isCompleted: false,
        sortOrder: 8,
      ),
      WeddingTask(
        taskId: 'task_9',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 0,
        title: 'Gladi resik prosesi akad & kirab pengantin',
        description: 'Briefing saksi nikah, pagar ayu, dan penerima tamu',
        pic: 'WO',
        dueDate: weddingDate,
        isCompleted: false,
        sortOrder: 9,
      ),
      WeddingTask(
        taskId: 'task_10',
        weddingProfileId: primaryMockProfileId,
        phaseMonth: 0,
        title: 'Pelunasan sisa tagihan vendor setelah acara',
        description: 'Pastikan seluruh serah terima barang tuntas',
        pic: 'GROOM',
        dueDate: weddingDate,
        isCompleted: false,
        sortOrder: 10,
      ),
    ];

    await db.insertTasksBatch(tasks);

    // 6. Committee (Susunan Panitia)
    final committee = <WeddingCommitteeMember>[
      const WeddingCommitteeMember(
        memberId: 'com_1',
        weddingProfileId: primaryMockProfileId,
        memberName: 'Bpk. H. Rahmat Hidayat',
        role: 'Ketua Panitia Acara',
        side: 'KELUARGA_CPP',
        phoneNumber: '081234567801',
        uniformStatus: 'SIAP_PAKAI',
        uniformDescription: 'Beskap Sunda warna Mocca Gold',
      ),
      const WeddingCommitteeMember(
        memberId: 'com_2',
        weddingProfileId: primaryMockProfileId,
        memberName: 'Dimas Wicaksono, S.I.Kom',
        role: 'Master of Ceremony (MC)',
        side: 'TEMAN_CPP',
        phoneNumber: '081234567802',
        uniformStatus: 'SIAP_PAKAI',
        uniformDescription: 'Jas Formal Hitam & Dasi Rose Gold',
      ),
      const WeddingCommitteeMember(
        memberId: 'com_3',
        weddingProfileId: primaryMockProfileId,
        memberName: 'Sarah Amalia & Rina Fitri',
        role: 'Penerima Tamu & Souvenir',
        side: 'TEMAN_CPW',
        phoneNumber: '081234567803',
        uniformStatus: 'FITTING',
        uniformDescription: 'Kebaya Modern Rose Gold',
      ),
      const WeddingCommitteeMember(
        memberId: 'com_4',
        weddingProfileId: primaryMockProfileId,
        memberName: 'Bpk. Sukardi & Tim',
        role: 'Seksi Logistik & Perlengkapan',
        side: 'KELUARGA_CPP',
        phoneNumber: '081234567804',
        uniformStatus: 'SIAP_PAKAI',
        uniformDescription: 'Batik Tulis Lengan Panjang',
      ),
      const WeddingCommitteeMember(
        memberId: 'com_5',
        weddingProfileId: primaryMockProfileId,
        memberName: 'Ibu Dewi Kartika',
        role: 'Seksi Konsumsi VIP & Keluarga',
        side: 'KELUARGA_CPW',
        phoneNumber: '081234567805',
        uniformStatus: 'BELUM_DIBAGI',
        uniformDescription: 'Gamis Brokat Dusty Pink',
      ),
      const WeddingCommitteeMember(
        memberId: 'com_6',
        weddingProfileId: primaryMockProfileId,
        memberName: 'Bpk. Dr. H. Faisal Basri',
        role: 'Saksi Akad Nikah',
        side: 'KELUARGA_CPP',
        phoneNumber: '081234567806',
        uniformStatus: 'SIAP_PAKAI',
        uniformDescription: 'Peci Hitam & Jas Formal',
      ),
    ];

    for (final c in committee) {
      await db.insertCommittee(c);
    }

    // 7. Events & Rundown
    final eventAkad = WeddingEvent(
      eventId: 'evt_akad',
      weddingProfileId: primaryMockProfileId,
      eventName: 'Akad Nikah & Upacara Adat',
      eventDate: weddingDate,
      eventLocation: 'Masjid Agung Al-Ikhlas & Selasar Adat',
    );

    final eventResepsi = WeddingEvent(
      eventId: 'evt_resepsi',
      weddingProfileId: primaryMockProfileId,
      eventName: 'Resepsi Pernikahan (Syukuran & Ramah Tamah)',
      eventDate: weddingDate,
      eventLocation: 'Aula Pertemuan Serbaguna',
    );

    await db.insertEvent(eventAkad);
    await db.insertEvent(eventResepsi);

    final rundownItems = <WeddingRundownItem>[
      // Rundown Akad
      const WeddingRundownItem(
        itemId: 'rd_1',
        eventId: 'evt_akad',
        timeStart: '06:00',
        durationMinutes: 90,
        sessionTitle: 'Makeup & Busana Akad Pengantin',
        pic: 'MUA Teh Winda',
        mcScript: 'Pengantin pria & wanita persiapan busana adat Sunda',
      ),
      const WeddingRundownItem(
        itemId: 'rd_2',
        eventId: 'evt_akad',
        timeStart: '07:30',
        durationMinutes: 30,
        sessionTitle: 'Penyambutan Rombongan Keluarga CPP',
        pic: 'MC Dimas & WO',
        mcScript: 'Pengalungan melati oleh Ibu CPW ke CPP',
      ),
      const WeddingRundownItem(
        itemId: 'rd_3',
        eventId: 'evt_akad',
        timeStart: '08:00',
        durationMinutes: 45,
        sessionTitle: 'Prosesi Ijab Qabul & Khutbah Nikah',
        pic: 'Penghulu KUA',
        mcScript: 'Penandatanganan buku nikah & penyerahan mahar',
      ),
      const WeddingRundownItem(
        itemId: 'rd_4',
        eventId: 'evt_akad',
        timeStart: '08:45',
        durationMinutes: 45,
        sessionTitle: 'Upacara Adat Saweran & Sungkeman',
        pic: 'Pemandu Adat',
        mcScript: 'Sungkeman ke orang tua kedua mempelai dengan haru & khidmat',
      ),
      const WeddingRundownItem(
        itemId: 'rd_5',
        eventId: 'evt_akad',
        timeStart: '09:30',
        durationMinutes: 45,
        sessionTitle: 'Foto Bersama Keluarga Inti & Saksi',
        pic: 'Fotografer Diamond',
        mcScript: 'Sesi foto resmi keluarga besar CPP dan CPW',
      ),

      // Rundown Resepsi
      const WeddingRundownItem(
        itemId: 'rd_6',
        eventId: 'evt_resepsi',
        timeStart: '10:30',
        durationMinutes: 30,
        sessionTitle: 'Touch-up Busana Resepsi & Briefing',
        pic: 'Tim WO',
        mcScript: 'Pagar ayu dan penerima tamu sudah standby di posisi',
      ),
      const WeddingRundownItem(
        itemId: 'rd_7',
        eventId: 'evt_resepsi',
        timeStart: '11:00',
        durationMinutes: 30,
        sessionTitle: 'Kirab Pengantin (Grand Entrance)',
        pic: 'MC & Tim Adat',
        mcScript: 'Iringan musik gamelan/biola romantis menuju pelaminan',
      ),
      const WeddingRundownItem(
        itemId: 'rd_8',
        eventId: 'evt_resepsi',
        timeStart: '11:30',
        durationMinutes: 120,
        sessionTitle: 'Pemberian Selamat & Santap Siang',
        pic: 'Seksi Konsumsi & WO',
        mcScript: 'Live acoustic band membawakan lagu-lagu pilihan mempelai',
      ),
      const WeddingRundownItem(
        itemId: 'rd_9',
        eventId: 'evt_resepsi',
        timeStart: '13:30',
        durationMinutes: 30,
        sessionTitle: 'Lempar Handbouquet & Foto Sahabat',
        pic: 'MC Dimas',
        mcScript: 'Penutupan acara resepsi dan ucapan terima kasih',
      ),
    ];

    for (final rd in rundownItems) {
      await db.insertRundownItem(rd);
    }

    // 8. Seserahan & Hantaran
    final seserahan = <WeddingSeserahan>[
      const WeddingSeserahan(
        itemId: 'ses_1',
        weddingProfileId: primaryMockProfileId,
        direction: 'SESERAHAN_CPP',
        itemName: 'Set Perhiasan Emas Kalung & Gelang',
        quantity: 1,
        estimatedPrice: 15000000.0,
        status: 'SIAP',
        notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
      ),
      const WeddingSeserahan(
        itemId: 'ses_2',
        weddingProfileId: primaryMockProfileId,
        direction: 'SESERAHAN_CPP',
        itemName: 'Mukena Sutra Bordir & Al-Qur\'an',
        quantity: 1,
        estimatedPrice: 1500000.0,
        status: 'SIAP',
        notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
      ),
      const WeddingSeserahan(
        itemId: 'ses_3',
        weddingProfileId: primaryMockProfileId,
        direction: 'SESERAHAN_CPP',
        itemName: 'Paket Skincare & Makeup Premium',
        quantity: 1,
        estimatedPrice: 3500000.0,
        status: 'DIBELI',
        notes: null,
      ),
      const WeddingSeserahan(
        itemId: 'ses_4',
        weddingProfileId: primaryMockProfileId,
        direction: 'SESERAHAN_CPP',
        itemName: 'Tas Kulit Branded & High Heels',
        quantity: 2,
        estimatedPrice: 4200000.0,
        status: 'SIAP',
        notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
      ),
      const WeddingSeserahan(
        itemId: 'ses_5',
        weddingProfileId: primaryMockProfileId,
        direction: 'SESERAHAN_CPP',
        itemName: 'Kain Batik Tulis & Bahan Kebaya Brokat',
        quantity: 2,
        estimatedPrice: 2800000.0,
        status: 'SIAP',
        notes: null,
      ),
      const WeddingSeserahan(
        itemId: 'ses_6',
        weddingProfileId: primaryMockProfileId,
        direction: 'BALASAN_CPW',
        itemName: 'Satu Set Jas Formal & Kemeja Putih',
        quantity: 1,
        estimatedPrice: 3500000.0,
        status: 'SIAP',
        notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
      ),
      const WeddingSeserahan(
        itemId: 'ses_7',
        weddingProfileId: primaryMockProfileId,
        direction: 'BALASAN_CPW',
        itemName: 'Sepatu Pantofel Kulit Asli & Gesper',
        quantity: 2,
        estimatedPrice: 2500000.0,
        status: 'SIAP',
        notes: null,
      ),
      const WeddingSeserahan(
        itemId: 'ses_8',
        weddingProfileId: primaryMockProfileId,
        direction: 'BALASAN_CPW',
        itemName: 'Sajadah Turki & Sarung Sutra',
        quantity: 1,
        estimatedPrice: 1200000.0,
        status: 'SIAP',
        notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
      ),
      const WeddingSeserahan(
        itemId: 'ses_9',
        weddingProfileId: primaryMockProfileId,
        direction: 'MAHAR',
        itemName: 'Logam Mulia Antam 10 Gram (CertiCard)',
        quantity: 1,
        estimatedPrice: 14500000.0,
        status: 'SIAP',
        notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
      ),
      const WeddingSeserahan(
        itemId: 'ses_10',
        weddingProfileId: primaryMockProfileId,
        direction: 'MAHAR',
        itemName: 'Satu Set Mukena Sutra & Al-Qur\'an Terjemahan',
        quantity: 1,
        estimatedPrice: 1850000.0,
        status: 'SIAP',
        notes: null,
      ),
      const WeddingSeserahan(
        itemId: 'ses_11',
        weddingProfileId: primaryMockProfileId,
        direction: 'MAHAR',
        itemName: 'Uang Mahar Hias Frame 3D (Rp 2.026.100)',
        quantity: 1,
        estimatedPrice: 2250000.0,
        status: 'SIAP',
        notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
      ),
    ];

    for (final s in seserahan) {
      await db.insertSeserahan(s);
    }

    // 9. Documents (Berkas Nikah KUA)
    final docs = <WeddingDocument>[
      WeddingDocument(
        docId: 'doc_1',
        weddingProfileId: primaryMockProfileId,
        docName: 'Surat Pengantar Nikah Kelurahan / Desa (Model N1 - N4)',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 50000.0,
        dueDate: now.subtract(const Duration(days: 14)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_2',
        weddingProfileId: primaryMockProfileId,
        docName: 'Fotokopi KTP Calon Suami dan Istri',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 10000.0,
        dueDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_3',
        weddingProfileId: primaryMockProfileId,
        docName: 'Fotokopi Kartu Keluarga (KK) Calon Suami dan Istri',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 10000.0,
        dueDate: now.subtract(const Duration(days: 8)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_4',
        weddingProfileId: primaryMockProfileId,
        docName: 'Fotokopi Akta Kelahiran Calon Pengantin',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 0.0,
        dueDate: now.subtract(const Duration(days: 7)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_5',
        weddingProfileId: primaryMockProfileId,
        docName: 'Fotokopi Ijazah Terakhir (Pencocokan Nama & Data)',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 0.0,
        dueDate: now.subtract(const Duration(days: 6)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_6',
        weddingProfileId: primaryMockProfileId,
        docName: 'Pasfoto Latar Biru (2x3, 3x4, & 4x6 Ketentuan KUA)',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 50000.0,
        dueDate: now.subtract(const Duration(days: 4)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_7',
        weddingProfileId: primaryMockProfileId,
        docName: 'Surat Pernyataan Status Belum Menikah (Bermeterai)',
        ownerType: 'BOTH',
        isCompleted: false,
        adminCost: 20000.0,
        dueDate: now.add(const Duration(days: 5)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_8',
        weddingProfileId: primaryMockProfileId,
        docName: 'Surat Keterangan Kesehatan & Imunisasi TT Puskesmas',
        ownerType: 'BRIDE',
        isCompleted: true,
        adminCost: 75000.0,
        dueDate: now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_9',
        weddingProfileId: primaryMockProfileId,
        docName: 'Fotokopi KTP Orang Tua Calon Pengantin',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 10000.0,
        dueDate: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_10',
        weddingProfileId: primaryMockProfileId,
        docName: 'Fotokopi Buku Nikah Orang Tua (Khusus CPW / Anak Pertama)',
        ownerType: 'BRIDE',
        isCompleted: true,
        adminCost: 0.0,
        dueDate: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_11',
        weddingProfileId: primaryMockProfileId,
        docName: 'Fotokopi KTP Wali Nikah & 2 Saksi Nikah (Laki-laki Muslim)',
        ownerType: 'BOTH',
        isCompleted: false,
        adminCost: 10000.0,
        dueDate: now.add(const Duration(days: 12)).millisecondsSinceEpoch,
      ),
    ];

    await db.insertDocumentsBatch(docs);
  }
}
