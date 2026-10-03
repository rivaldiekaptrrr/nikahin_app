import '../../domain/models/wedding_models.dart';
import 'database.dart';

class MockSeeder {
  static const String primaryMockProfileId = 'profile_rivaldi_alya';

  /// Seed complete mock data across all 10 wedding modules into SQLite database
  static Future<void> seedAllMockData(AppDatabase db) async {
    // 1. Single Wedding Profile (Rivaldi & Alya)
    final now = DateTime.now();
    final weddingDate = now.add(const Duration(days: 45)).millisecondsSinceEpoch;

    final primaryProfile = WeddingProfile(
      id: primaryMockProfileId,
      groomName: 'Rivaldi',
      brideName: 'Alya',
      weddingDate: weddingDate,
      totalBudgetCap: 175000000.0,
      religionType: 'ISLAM',
      culturalPresetGroom: 'SUNDA',
      culturalPresetBride: 'JAWA',
      quote: 'Mencintai bukan tentang saling memandang, melainkan memandang bersama ke arah yang sama.',
      quoteEnabled: true,
      quoteFontSize: 'SEDANG',
      quoteFontStyle: 'ITALIC',
      createdAt: now.subtract(const Duration(days: 60)).millisecondsSinceEpoch,
    );

    // Clean up any legacy profiles to ensure strict single-profile operation
    await db.deleteProfile('mock_profile_dimas_sarah');
    await db.deleteProfile('mock_profile_rivaldi_putri');

    await db.insertProfile(primaryProfile);

    // 2. Expenses (Anggaran)
    final expenses = <WeddingExpense>[
      WeddingExpense(
        expenseId: 'exp_1',
        weddingProfileId: primaryMockProfileId,
        title: 'Grand Ballroom Hotel Aston',
        category: 'VENUE',
        totalEstimated: 45000000.0,
        totalPaid: 45000000.0,
        paidBySource: 'BERSAMA',
        paymentStatus: 'FULLY_PAID',
        notes: 'Termasuk fasilitas AC, panggung, sound system, & 2 kamar pengantin',
        createdAt: now.subtract(const Duration(days: 45)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_2',
        weddingProfileId: primaryMockProfileId,
        title: 'Catering Buffet 800 Pax + 4 Gubukan',
        category: 'CATERING',
        totalEstimated: 55000000.0,
        totalPaid: 25000000.0,
        paidBySource: 'TABUNGAN_CPP',
        paymentStatus: 'PARTIAL_DP',
        notes: 'Stall: Sate Ayam, Zuppa Soup, Siomay Bandung, Kambing Guling',
        createdAt: now.subtract(const Duration(days: 40)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_3',
        weddingProfileId: primaryMockProfileId,
        title: 'Busana Akad & Resepsi Pengantin + Ortu',
        category: 'MUA',
        totalEstimated: 18000000.0,
        totalPaid: 10000000.0,
        paidBySource: 'TABUNGAN_CPW',
        paymentStatus: 'PARTIAL_DP',
        notes: 'Kebaya Sunda Siger untuk Akad, Gaun Modern & Beskap Jawa untuk Resepsi',
        createdAt: now.subtract(const Duration(days: 35)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_4',
        weddingProfileId: primaryMockProfileId,
        title: 'Dekorasi Pelaminan, Lorong & Photobooth',
        category: 'DECOR',
        totalEstimated: 22000000.0,
        totalPaid: 10000000.0,
        paidBySource: 'ORTU_CPP',
        paymentStatus: 'PARTIAL_DP',
        notes: 'Konsep Rustic Modern dengan kombinasi bunga fresh & lampu fairy lights',
        createdAt: now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_5',
        weddingProfileId: primaryMockProfileId,
        title: 'Foto & Cinematic Video Hari-H (All Day)',
        category: 'DOKUMENTASI',
        totalEstimated: 12500000.0,
        totalPaid: 12500000.0,
        paidBySource: 'BERSAMA',
        paymentStatus: 'FULLY_PAID',
        notes: 'Paket 2 Photographer, 2 Videographer, Drone, 1 Album Kolase, Flashdisk Box',
        createdAt: now.subtract(const Duration(days: 28)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_6',
        weddingProfileId: primaryMockProfileId,
        title: 'Undangan Fisik Foil Emas 400 Pcs + Web',
        category: 'UNDANGAN',
        totalEstimated: 4500000.0,
        totalPaid: 0.0,
        paidBySource: 'TABUNGAN_CPP',
        paymentStatus: 'UNPAID',
        notes: 'Hardcover amplop dengan custom barcode check-in & link undangan web',
        createdAt: now.subtract(const Duration(days: 20)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_7',
        weddingProfileId: primaryMockProfileId,
        title: 'Souvenir Tumbler Kayu + Pouch 500 Pcs',
        category: 'UNDANGAN',
        totalEstimated: 6000000.0,
        totalPaid: 3000000.0,
        paidBySource: 'TABUNGAN_CPW',
        paymentStatus: 'PARTIAL_DP',
        notes: 'Kemasan box craft coklat dengan pita rose gold & hangtag terima kasih',
        createdAt: now.subtract(const Duration(days: 15)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_8',
        weddingProfileId: primaryMockProfileId,
        title: 'Live Band Akustik, Sound System & Master of Ceremony',
        category: 'LAINNYA',
        totalEstimated: 7500000.0,
        totalPaid: 7500000.0,
        paidBySource: 'BERSAMA',
        paymentStatus: 'FULLY_PAID',
        notes: '4 Musisi (Vokal, Gitar, Keyboard, Saxophone) + MC Profesional Akad & Resepsi',
        createdAt: now.subtract(const Duration(days: 14)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_9',
        weddingProfileId: primaryMockProfileId,
        title: 'Logam Mulia Antam 10 Gram & Frame Mahar 3D',
        category: 'SESERAHAN',
        totalEstimated: 14500000.0,
        totalPaid: 14500000.0,
        paidBySource: 'TABUNGAN_CPP',
        paymentStatus: 'FULLY_PAID',
        notes: 'Koin kuno, sertifikat Antam, & bingkai kaca akrilik ukir laser kaligrafi',
        createdAt: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
      WeddingExpense(
        expenseId: 'exp_10',
        weddingProfileId: primaryMockProfileId,
        title: 'Biaya Administrasi KUA & Penghulu Hari Libur',
        category: 'LAINNYA',
        totalEstimated: 600000.0,
        totalPaid: 600000.0,
        paidBySource: 'TABUNGAN_CPP',
        paymentStatus: 'FULLY_PAID',
        notes: 'Transfer resmi PNBP via Bank Mandiri & transport penghulu',
        createdAt: now.subtract(const Duration(days: 8)).millisecondsSinceEpoch,
      ),
    ];

    for (final exp in expenses) {
      await db.insertExpense(exp);
    }

    // 2.1 Payment Terms & History (Termin Pembayaran)
    final paymentTerms = <WeddingPaymentTerm>[
      // exp_1: Venue (45jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_1_1',
        expenseId: 'exp_1',
        termName: 'DP 1 Booking Gedung & Kunci Tanggal (30%)',
        amount: 13500000.0,
        dueDate: now.subtract(const Duration(days: 40)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 40)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_1_2',
        expenseId: 'exp_1',
        termName: 'Termin 2 Technical Meeting & Layout (40%)',
        amount: 18000000.0,
        dueDate: now.subtract(const Duration(days: 20)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 20)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_1_3',
        expenseId: 'exp_1',
        termName: 'Pelunasan Final Venue Hotel Aston (30%)',
        amount: 13500000.0,
        dueDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
      ),

      // exp_2: Catering (55jt - DP 25jt, Sisa 30jt)
      WeddingPaymentTerm(
        termId: 'term_2_1',
        expenseId: 'exp_2',
        termName: 'DP 1 Booking Tanggal & Paket 800 Pax',
        amount: 11000000.0,
        dueDate: now.subtract(const Duration(days: 35)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 35)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_2_2',
        expenseId: 'exp_2',
        termName: 'Termin 2 Test Food & Tambah 4 Stall',
        amount: 14000000.0,
        dueDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_2_3',
        expenseId: 'exp_2',
        termName: 'Pelunasan H-7 Final Porsi Katering',
        amount: 30000000.0,
        dueDate: weddingDate - const Duration(days: 7).inMilliseconds,
        isPaid: false,
      ),

      // exp_3: Busana & MUA (18jt - DP 10jt, Sisa 8jt)
      WeddingPaymentTerm(
        termId: 'term_3_1',
        expenseId: 'exp_3',
        termName: 'DP Fitting Pertama & Booking MUA Akad',
        amount: 5000000.0,
        dueDate: now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_3_2',
        expenseId: 'exp_3',
        termName: 'Termin 2 Fitting Busana Ortu & Beskap Jawa',
        amount: 5000000.0,
        dueDate: now.subtract(const Duration(days: 12)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 12)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_3_3',
        expenseId: 'exp_3',
        termName: 'Pelunasan H-3 Pengambilan Baju Pengantin',
        amount: 8000000.0,
        dueDate: weddingDate - const Duration(days: 3).inMilliseconds,
        isPaid: false,
      ),

      // exp_4: Dekorasi (22jt - DP 10jt, Sisa 12jt)
      WeddingPaymentTerm(
        termId: 'term_4_1',
        expenseId: 'exp_4',
        termName: 'DP Desain 3D Pelaminan & Photobooth',
        amount: 5000000.0,
        dueDate: now.subtract(const Duration(days: 25)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 25)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_4_2',
        expenseId: 'exp_4',
        termName: 'Termin 2 Pengadaan Bunga Fresh & Gazebo',
        amount: 5000000.0,
        dueDate: now.subtract(const Duration(days: 8)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 8)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_4_3',
        expenseId: 'exp_4',
        termName: 'Pelunasan H-1 Loading Properti Gedung',
        amount: 12000000.0,
        dueDate: weddingDate - const Duration(days: 1).inMilliseconds,
        isPaid: false,
      ),

      // exp_5: Dokumentasi (12.5jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_5_1',
        expenseId: 'exp_5',
        termName: 'DP Booking Tim 2 Foto + 2 Video + Drone',
        amount: 4000000.0,
        dueDate: now.subtract(const Duration(days: 24)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 24)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_5_2',
        expenseId: 'exp_5',
        termName: 'Pelunasan H-2 Sebelum Liputan Acara',
        amount: 8500000.0,
        dueDate: now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
      ),

      // exp_6: Undangan (4.5jt - Belum Bayar)
      WeddingPaymentTerm(
        termId: 'term_6_1',
        expenseId: 'exp_6',
        termName: 'DP Proofing Sample Cetak & Desain Foil Emas',
        amount: 2000000.0,
        dueDate: now.add(const Duration(days: 5)).millisecondsSinceEpoch,
        isPaid: false,
      ),
      WeddingPaymentTerm(
        termId: 'term_6_2',
        expenseId: 'exp_6',
        termName: 'Pelunasan Selesai Cetak 400 Pcs & Packing',
        amount: 2500000.0,
        dueDate: now.add(const Duration(days: 15)).millisecondsSinceEpoch,
        isPaid: false,
      ),

      // exp_7: Souvenir (6jt - DP 3jt, Sisa 3jt)
      WeddingPaymentTerm(
        termId: 'term_7_1',
        expenseId: 'exp_7',
        termName: 'DP Produksi Tumbler Kayu 500 Pcs & Custom Pouch',
        amount: 3000000.0,
        dueDate: now.subtract(const Duration(days: 14)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 14)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_7_2',
        expenseId: 'exp_7',
        termName: 'Pelunasan Pengiriman Souvenir & Tag Ucapan',
        amount: 3000000.0,
        dueDate: now.add(const Duration(days: 10)).millisecondsSinceEpoch,
        isPaid: false,
      ),

      // exp_8: Entertainment (7.5jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_8_1',
        expenseId: 'exp_8',
        termName: 'DP Booking Live Akustik & MC Pernikahan',
        amount: 2500000.0,
        dueDate: now.subtract(const Duration(days: 14)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 14)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_8_2',
        expenseId: 'exp_8',
        termName: 'Pelunasan Gladi Resik & Penampilan Resepsi',
        amount: 5000000.0,
        dueDate: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      ),

      // exp_9: Mahar (14.5jt - Lunas)
      WeddingPaymentTerm(
        termId: 'term_9_1',
        expenseId: 'exp_9',
        termName: 'Pembelian Logam Mulia Antam 10 Gram',
        amount: 13000000.0,
        dueDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
      WeddingPaymentTerm(
        termId: 'term_9_2',
        expenseId: 'exp_9',
        termName: 'Jasa Desain Frame Akrilik & Hias Mahar 3D',
        amount: 1500000.0,
        dueDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
      ),

      // exp_10: KUA (600rb - Lunas)
      WeddingPaymentTerm(
        termId: 'term_10_1',
        expenseId: 'exp_10',
        termName: 'Setor PNBP Kas Negara KUA Bank Mandiri',
        amount: 600000.0,
        dueDate: now.subtract(const Duration(days: 8)).millisecondsSinceEpoch,
        isPaid: true,
        paidDate: now.subtract(const Duration(days: 8)).millisecondsSinceEpoch,
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
        name: 'Grand Ballroom Hotel Aston',
        picName: 'Bpk. Bambang Pamungkas',
        phoneNumber: '081234567890',
        status: 'KONTRAK',
        contractValue: 45000000.0,
        notes: 'Kapasitas 1.000 standing, full karpet, technical meeting H-10',
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
        contractValue: 55000000.0,
        notes: 'Bonus 100 cup es krim & 2 loyang tart pengantin',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_3',
        weddingProfileId: primaryMockProfileId,
        category: 'DECORATION',
        name: 'Mahkota Wedding Decoration',
        picName: 'Mas Reza Aditya',
        phoneNumber: '081567890123',
        status: 'KONTRAK',
        contractValue: 22000000.0,
        notes: 'Pelaminan 12 meter, pergola masuk, karpet jalan mawar merah',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_4',
        weddingProfileId: primaryMockProfileId,
        category: 'PHOTOGRAPHY',
        name: 'Diamond Cinematic Studio',
        picName: 'Mas Dimas Pratama',
        phoneNumber: '081789012345',
        status: 'SELESAI',
        contractValue: 12500000.0,
        notes: 'Prewed outdoor di Lembang selesai, Hari-H siap on-time 05:30',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_5',
        weddingProfileId: primaryMockProfileId,
        category: 'ATTIRE',
        name: 'Sanggar Busana Anggun Rias',
        picName: 'Teh Winda Kartika',
        phoneNumber: '081901234567',
        status: 'KONTRAK',
        contractValue: 18000000.0,
        notes: 'Fitting terakhir dijadwalkan H-14 di studio sanggar',
        createdAt: now.millisecondsSinceEpoch,
      ),
      WeddingVendor(
        vendorId: 'ven_6',
        weddingProfileId: primaryMockProfileId,
        category: 'ENTERTAINMENT',
        name: 'Harmony Sound & Acoustic Band',
        picName: 'Mas Eko Saputra',
        phoneNumber: '082123456789',
        status: 'TANDA_JADI',
        contractValue: 7500000.0,
        notes: 'Song list 15 lagu romantis pop Indonesia & jazz',
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
        title: 'Tentukan tanggal dan booking gedung/ballroom',
        description: 'Telah dibayar DP 50% di Hotel Aston',
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
      eventName: 'Resepsi Pernikahan (Grand Wedding)',
      eventDate: weddingDate,
      eventLocation: 'Grand Ballroom Hotel Aston',
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
        docName: 'Surat Pengantar Nikah Kelurahan (Model N1 - N4)',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 50000.0,
        dueDate: now.subtract(const Duration(days: 14)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_2',
        weddingProfileId: primaryMockProfileId,
        docName: 'Fotokopi KTP & Kartu Keluarga Mempelai + Ortu',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 10000.0,
        dueDate: now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_3',
        weddingProfileId: primaryMockProfileId,
        docName: 'Akta Kelahiran & Ijazah Terakhir',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 0.0,
        dueDate: now.subtract(const Duration(days: 7)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_4',
        weddingProfileId: primaryMockProfileId,
        docName: 'Surat Keterangan Sehat & Suntik TT Puskesmas',
        ownerType: 'BRIDE',
        isCompleted: true,
        adminCost: 75000.0,
        dueDate: now.subtract(const Duration(days: 5)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_5',
        weddingProfileId: primaryMockProfileId,
        docName: 'Pas Foto Latar Belakang Biru (2x3 & 4x6)',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 50000.0,
        dueDate: now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_6',
        weddingProfileId: primaryMockProfileId,
        docName: 'Pendaftaran Online Simkah & Bayar PNBP KUA',
        ownerType: 'BOTH',
        isCompleted: true,
        adminCost: 600000.0,
        dueDate: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_7',
        weddingProfileId: primaryMockProfileId,
        docName: 'Surat Rekomendasi Nikah (Numpang Nikah CPP)',
        ownerType: 'GROOM',
        isCompleted: false,
        adminCost: 0.0,
        dueDate: now.add(const Duration(days: 3)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_8',
        weddingProfileId: primaryMockProfileId,
        docName: 'Sertifikat Bimbingan Perkawinan (Bimwin)',
        ownerType: 'BOTH',
        isCompleted: false,
        adminCost: 0.0,
        dueDate: now.add(const Duration(days: 9)).millisecondsSinceEpoch,
      ),
      WeddingDocument(
        docId: 'doc_9',
        weddingProfileId: primaryMockProfileId,
        docName: 'Surat Persetujuan Mempelai (Model N7)',
        ownerType: 'BOTH',
        isCompleted: false,
        adminCost: 0.0,
        dueDate: now.add(const Duration(days: 16)).millisecondsSinceEpoch,
      ),
    ];

    await db.insertDocumentsBatch(docs);
  }
}
