import '../../domain/models/wedding_models.dart';
import '../../shared/utils/uuid_utils.dart';

class SeedData {
  /// Generate default tasks when a new wedding profile is created
  static List<WeddingTask> generateDefaultTasks(String profileId, int weddingDate) {
    // Phase milestones in milliseconds from weddingDate
    // 12 months ~ 365 days, 6 months ~ 180 days, 3 months ~ 90 days, 1 month ~ 30 days
    final d12 = weddingDate - (365 * 24 * 60 * 60 * 1000);
    final d6 = weddingDate - (180 * 24 * 60 * 60 * 1000);
    final d3 = weddingDate - (90 * 24 * 60 * 60 * 1000);
    final d1 = weddingDate - (30 * 24 * 60 * 60 * 1000);
    final d0 = weddingDate;

    final tasks = <WeddingTask>[
      // 12 Bulan Sebelum
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 12,
        title: 'Tentukan tanggal dan booking venue/gedung',
        description: 'Pastikan ketersediaan tempat dan tanggal dari kedua belah pihak keluarga.',
        pic: 'BOTH',
        dueDate: d12,
        sortOrder: 1,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 12,
        title: 'Tentukan konsep/tema pernikahan & warna busana',
        description: 'Pilih adat, modern, atau perpaduan tema nasional.',
        pic: 'BOTH',
        dueDate: d12,
        sortOrder: 2,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 12,
        title: 'Buat estimasi anggaran awal dan alokasi dana',
        description: 'Bagi porsi tabungan bersama atau bantuan keluarga.',
        pic: 'BOTH',
        dueDate: d12,
        sortOrder: 3,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 12,
        title: 'Cari & booking Wedding Organizer (WO)',
        description: 'Pilih WO yang berpengalaman sesuai konsep pernikahan.',
        pic: 'BOTH',
        dueDate: d12,
        sortOrder: 4,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 12,
        title: 'Daftarkan rencana nikah ke KUA / Catatan Sipil',
        description: 'Cek syarat administrasi awal dan ketersediaan penghulu.',
        pic: 'BOTH',
        dueDate: d12,
        sortOrder: 5,
      ),

      // 6 Bulan Sebelum
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 6,
        title: 'Food tasting & booking catering',
        description: 'Tentukan menu utama dan stall pondokan favorit.',
        pic: 'BOTH',
        dueDate: d6,
        sortOrder: 6,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 6,
        title: 'Booking fotografer & videografer (Prewed & Hari-H)',
        description: 'Pilih paket foto akad, resepsi, dan cinematic video.',
        pic: 'BOTH',
        dueDate: d6,
        sortOrder: 7,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 6,
        title: 'Booking dekorasi & pelaminan',
        description: 'Sesuaikan dengan luas venue dan tema warna.',
        pic: 'BOTH',
        dueDate: d6,
        sortOrder: 8,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 6,
        title: 'Booking MUA & fitting busana perdana',
        description: 'Pilih gaun/kebaya dan rias untuk pengantin & ibu.',
        pic: 'BRIDE',
        dueDate: d6,
        sortOrder: 9,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 6,
        title: 'Desain undangan fisik & website undangan digital',
        description: 'Mulai kumpulkan data nama keluarga dan lokasi maps.',
        pic: 'BOTH',
        dueDate: d6,
        sortOrder: 10,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 6,
        title: 'Susun daftar awal tamu undangan',
        description: 'Kelompokkan keluarga CPP, CPW, teman, dan VIP.',
        pic: 'BOTH',
        dueDate: d6,
        sortOrder: 11,
      ),

      // 3 Bulan Sebelum
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 3,
        title: 'Cetak undangan fisik & siapkan link undangan online',
        description: 'Pastikan ejaan nama gelar dan waktu sudah benar.',
        pic: 'BOTH',
        dueDate: d3,
        sortOrder: 12,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 3,
        title: 'Beli & siapkan kotak seserahan serta mahar',
        description: 'Hias kotak seserahan dan tata uang/emas mahar.',
        pic: 'GROOM',
        dueDate: d3,
        sortOrder: 13,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 3,
        title: 'Final fitting busana pengantin & orang tua',
        description: 'Uji kenyamanan bergerak, berjalan, dan bernafas.',
        pic: 'BOTH',
        dueDate: d3,
        sortOrder: 14,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 3,
        title: 'Sebarkan undangan fisik & online',
        description: 'Kirim undangan luar kota lebih awal via ekspedisi.',
        pic: 'BOTH',
        dueDate: d3,
        sortOrder: 15,
      ),

      // 1 Bulan Sebelum
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 1,
        title: 'Final checklist dekorasi, catering & pelunasan vendor',
        description: 'Pastikan seluruh vendor siap dan jadwal muat barang fix.',
        pic: 'BOTH',
        dueDate: d1,
        sortOrder: 16,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 1,
        title: 'Technical meeting & gladi bersih rundown dengan WO/Panitia',
        description: 'Distribusikan rundown menit-ke-menit dan teks MC.',
        pic: 'BOTH',
        dueDate: d1,
        sortOrder: 17,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 1,
        title: 'Bagikan seragam & kain panitia keluarga',
        description: 'Pastikan semua seragam sudah selesai dijahit.',
        pic: 'FAMILY',
        dueDate: d1,
        sortOrder: 18,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 1,
        title: 'Siapkan uang amplop kas kecil untuk Hari-H',
        description: 'Untuk tip keamanan, kebersihan, parkir, dan darurat.',
        pic: 'BOTH',
        dueDate: d1,
        sortOrder: 19,
      ),

      // Hari-H (0)
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 0,
        title: 'Briefing panitia & sarapan pagi pengantin',
        description: 'Pastikan kedua mempelai makan dan cukup terhidrasi.',
        pic: 'FAMILY',
        dueDate: d0,
        sortOrder: 20,
      ),
      WeddingTask(
        taskId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        phaseMonth: 0,
        title: 'Mulai rias MUA tepat waktu & eksekusi Rundown',
        description: 'Ikuti arahan rundown WO dari awal hingga selesai.',
        pic: 'WO',
        dueDate: d0,
        sortOrder: 21,
      ),
    ];

    return tasks;
  }

  /// Generate default administrative documents based on religion type
  static List<WeddingDocument> generateDefaultDocuments(String profileId, String religionType) {
    if (religionType == 'ISLAM') {
      return [
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Pengantar Nikah dari Kelurahan / Desa (N1)',
          ownerType: 'BOTH',
          sortOrder: 1,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Keterangan Asal Usul (N2)',
          ownerType: 'BOTH',
          sortOrder: 2,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Persetujuan Mempelai (N3)',
          ownerType: 'BOTH',
          sortOrder: 3,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Izin Orang Tua (N4 - jika usia < 21 thn)',
          ownerType: 'BOTH',
          sortOrder: 4,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Rekomendasi Nikah dari KUA Domisili (N5 / N6)',
          ownerType: 'GROOM',
          sortOrder: 5,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Fotokopi KTP & Kartu Keluarga (KK)',
          ownerType: 'BOTH',
          sortOrder: 6,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Fotokopi Akte Kelahiran & Ijazah Terakhir',
          ownerType: 'BOTH',
          sortOrder: 7,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Pas Foto Latar Biru 2x3 (4 lbr) & 4x6 (2 lbr)',
          ownerType: 'BOTH',
          sortOrder: 8,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Keterangan Sehat & Imunisasi TT dari Puskesmas',
          ownerType: 'BRIDE',
          sortOrder: 9,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Sertifikat Bimbingan Perkawinan (Bimwin) KUA',
          ownerType: 'BOTH',
          sortOrder: 10,
        ),
      ];
    } else {
      return [
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Keterangan Belum Menikah dari Kelurahan',
          ownerType: 'BOTH',
          sortOrder: 1,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Pemberkatan / Perkawinan Agama dari Tempat Ibadah',
          ownerType: 'BOTH',
          sortOrder: 2,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Fotokopi KTP & Kartu Keluarga (KK)',
          ownerType: 'BOTH',
          sortOrder: 3,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Fotokopi Akte Kelahiran CPP & CPW',
          ownerType: 'BOTH',
          sortOrder: 4,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Fotokopi Surat Baptis / Akta Agama',
          ownerType: 'BOTH',
          sortOrder: 5,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Pas Foto Berdampingan 4x6 (4 lembar)',
          ownerType: 'BOTH',
          sortOrder: 6,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Fotokopi KTP Saksi Pernikahan (2 orang)',
          ownerType: 'BOTH',
          sortOrder: 7,
        ),
        WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: profileId,
          docName: 'Surat Pernyataan Keabsahan Perkawinan (Dukcapil)',
          ownerType: 'BOTH',
          sortOrder: 8,
        ),
      ];
    }
  }

  /// Default events (Akad Nikah & Resepsi)
  static List<WeddingEvent> generateDefaultEvents(String profileId, int weddingDate) {
    return [
      WeddingEvent(
        eventId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        eventName: 'Akad Nikah / Pemberkatan',
        eventDate: weddingDate,
        eventLocation: 'Masjid / Gereja / Venue Utama',
        sortOrder: 1,
      ),
      WeddingEvent(
        eventId: UuidUtils.generateId(),
        weddingProfileId: profileId,
        eventName: 'Resepsi Pernikahan',
        eventDate: weddingDate,
        eventLocation: 'Grand Ballroom / Gedung Resepsi',
        sortOrder: 2,
      ),
    ];
  }
}
