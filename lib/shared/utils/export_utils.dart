import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import 'currency_utils.dart';
import 'date_utils.dart';

class ExportUtils {
  /// Generates a comprehensive, adaptable PDF document and opens print / share preview
  static Future<void> exportWeddingSummaryPdf({
    required WeddingProfile profile,
    required List<WeddingExpense> expenses,
    required List<WeddingGuest> guests,
    required List<WeddingVendor> vendors,
    required List<WeddingTask> tasks,
    required List<WeddingCommitteeMember> committee,
    required List<WeddingEvent> events,
    required Map<String, List<WeddingRundownItem>> eventRundowns,
    required List<WeddingSeserahan> seserahan,
    required List<WeddingDocument> documents,
  }) async {
    final pdf = pw.Document();

    final totalPaidExpense = expenses.fold(0.0, (acc, e) => acc + e.totalPaid);
    final totalEstimatedExpense = expenses.fold(0.0, (acc, e) => acc + e.totalEstimated);
    final totalPax = guests.fold(0, (acc, g) => acc + g.estimatedPax);
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final completedDocs = documents.where((d) => d.isCompleted).length;

    // Theme Colors
    const primaryColor = PdfColor.fromInt(0xFF881337); // Rose 900
    const primaryLight = PdfColor.fromInt(0xFFFFF1F2); // Rose 50
    const primaryBorder = PdfColor.fromInt(0xFFFECDD3); // Rose 200
    const textDark = PdfColor.fromInt(0xFF1E293B); // Slate 800
    const textMuted = PdfColor.fromInt(0xFF64748B); // Slate 500
    const tableHeaderBg = PdfColor.fromInt(0xFF9F1239); // Rose 800
    const tableRowEven = PdfColor.fromInt(0xFFFAFAFA);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 28),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 14),
            padding: const pw.EdgeInsets.only(top: 6),
            decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Nikahin - Dokumen Rencana Pernikahan',
                  style: const pw.TextStyle(fontSize: 7.5, color: textMuted),
                ),
                pw.Text(
                  'Halaman ${context.pageNumber} dari ${context.pagesCount}',
                  style: const pw.TextStyle(fontSize: 7.5, color: textMuted),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          return [
            // Header Banner
            pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 12),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: primaryColor, width: 1.5)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Ringkasan Pernikahan',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        '${profile.groomName} & ${profile.brideName}',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Hari & Tanggal: ${WeddingDateUtils.formatFull(profile.weddingDate)}',
                        style: const pw.TextStyle(fontSize: 9.5, color: textDark),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: primaryLight,
                          borderRadius: pw.BorderRadius.circular(4),
                          border: pw.Border.all(color: primaryBorder),
                        ),
                        child: pw.Text(
                          'NIKAHIN',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // Summary Stats Card
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: pw.BoxDecoration(
                color: primaryLight,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: primaryBorder, width: 0.8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildPdfStat('Batas Anggaran', CurrencyUtils.formatRupiah(profile.totalBudgetCap), primaryColor),
                  _buildPdfStat('Estimasi Biaya', CurrencyUtils.formatRupiah(totalEstimatedExpense), primaryColor),
                  _buildPdfStat('Total Terbayar', CurrencyUtils.formatRupiah(totalPaidExpense), primaryColor),
                  _buildPdfStat('Estimasi Tamu', '$totalPax Orang', primaryColor),
                  _buildPdfStat('Progress Tugas', '$completedTasks dari ${tasks.length}', primaryColor),
                  _buildPdfStat('Dokumen KUA', '$completedDocs dari ${documents.length}', primaryColor),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Section: Rincian Anggaran
            _buildSectionHeader('1. Rincian Pos Anggaran Pernikahan', primaryColor),
            pw.SizedBox(height: 6),
            if (expenses.isEmpty)
              _buildEmptyNotice('Belum ada data pengeluaran tercatat.')
            else
              pw.TableHelper.fromTextArray(
                headers: ['No', 'Kategori', 'Item Pengeluaran', 'Estimasi Biaya', 'Realisasi Bayar', 'Status Bayar'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
                headerDecoration: const pw.BoxDecoration(color: tableHeaderBg),
                headerPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
                cellStyle: const pw.TextStyle(fontSize: 8, color: textDark),
                rowDecoration: const pw.BoxDecoration(color: tableRowEven),
                columnWidths: const {
                  0: pw.FixedColumnWidth(24),  // No
                  1: pw.FixedColumnWidth(85),  // Kategori
                  2: pw.FlexColumnWidth(3),    // Item
                  3: pw.FixedColumnWidth(80),  // Estimasi
                  4: pw.FixedColumnWidth(80),  // Terbayar
                  5: pw.FixedColumnWidth(68),  // Status
                },
                cellAlignments: const {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.center,
                },
                data: expenses.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final e = entry.value;
                  return [
                    '$idx',
                    ExpenseCategory.fromString(e.category).label,
                    e.title,
                    CurrencyUtils.formatRupiah(e.totalEstimated),
                    CurrencyUtils.formatRupiah(e.totalPaid),
                    _formatPaymentStatus(e.paymentStatus),
                  ];
                }).toList(),
              ),
            pw.SizedBox(height: 16),

            // Section: Daftar Vendor
            _buildSectionHeader('2. Daftar Vendor & Rekanan', primaryColor),
            pw.SizedBox(height: 6),
            if (vendors.isEmpty)
              _buildEmptyNotice('Belum ada data vendor terdaftar.')
            else
              pw.TableHelper.fromTextArray(
                headers: ['No', 'Kategori', 'Nama Vendor', 'Kontak PIC', 'Nilai Kontrak', 'Status'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
                headerDecoration: const pw.BoxDecoration(color: tableHeaderBg),
                headerPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
                cellStyle: const pw.TextStyle(fontSize: 8, color: textDark),
                rowDecoration: const pw.BoxDecoration(color: tableRowEven),
                columnWidths: const {
                  0: pw.FixedColumnWidth(24),  // No
                  1: pw.FixedColumnWidth(85),  // Kategori
                  2: pw.FlexColumnWidth(2.5),  // Nama Vendor
                  3: pw.FlexColumnWidth(2.2),  // Kontak PIC
                  4: pw.FixedColumnWidth(80),  // Nilai
                  5: pw.FixedColumnWidth(68),  // Status
                },
                cellAlignments: const {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerLeft,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.center,
                },
                data: vendors.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final v = entry.value;
                  final picText = v.picName != null && v.picName!.isNotEmpty
                      ? '${v.picName} (${v.phoneNumber ?? '-'})'
                      : (v.phoneNumber ?? '-');
                  return [
                    '$idx',
                    ExpenseCategory.fromString(v.category).label,
                    v.name,
                    picText,
                    CurrencyUtils.formatRupiah(v.contractValue),
                    VendorStatus.fromString(v.status).label,
                  ];
                }).toList(),
              ),
            pw.SizedBox(height: 16),

            // Section: Rundown Acara
            _buildSectionHeader('3. Susunan Acara (Rundown)', primaryColor),
            pw.SizedBox(height: 6),
            if (events.isEmpty)
              _buildEmptyNotice('Belum ada jadwal acara tercatat.')
            else
              ...events.map((event) {
                final items = eventRundowns[event.eventId] ?? [];
                final eventDateStr = event.eventDate > 0
                    ? WeddingDateUtils.formatFull(event.eventDate)
                    : '';
                final locationStr = event.eventLocation != null && event.eventLocation!.isNotEmpty
                    ? ' - Tempat: ${event.eventLocation}'
                    : '';

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: double.infinity,
                      margin: const pw.EdgeInsets.only(top: 4, bottom: 4),
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(3),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Acara: ${event.eventName}$locationStr',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.5, color: textDark),
                          ),
                          if (eventDateStr.isNotEmpty)
                            pw.Text(
                              eventDateStr,
                              style: const pw.TextStyle(fontSize: 7.5, color: textMuted),
                            ),
                        ],
                      ),
                    ),
                    if (items.isEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 6, bottom: 6),
                        child: pw.Text('Belum ada sesi kegiatan pada acara ini.', style: const pw.TextStyle(fontSize: 7.5, color: textMuted)),
                      )
                    else
                      pw.TableHelper.fromTextArray(
                        headers: ['Waktu', 'Durasi', 'Sesi Acara & Kegiatan', 'Penanggung Jawab (PIC)'],
                        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: textDark, fontSize: 8),
                        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                        headerPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        cellStyle: const pw.TextStyle(fontSize: 8, color: textDark),
                        rowDecoration: const pw.BoxDecoration(color: tableRowEven),
                        columnWidths: const {
                          0: pw.FixedColumnWidth(50),  // Waktu
                          1: pw.FixedColumnWidth(44),  // Durasi
                          2: pw.FlexColumnWidth(3.5),  // Sesi Acara
                          3: pw.FlexColumnWidth(2),    // PIC
                        },
                        cellAlignments: const {
                          0: pw.Alignment.center,
                          1: pw.Alignment.center,
                          2: pw.Alignment.centerLeft,
                          3: pw.Alignment.centerLeft,
                        },
                        data: items.map((i) => [
                          i.timeStart,
                          '${i.durationMinutes} mnt',
                          i.sessionTitle,
                          (i.pic != null && i.pic!.trim().isNotEmpty) ? i.pic! : '-',
                        ]).toList(),
                      ),
                    pw.SizedBox(height: 8),
                  ],
                );
              }),
            pw.SizedBox(height: 12),

            // Section: Struktur Panitia & Seragam
            _buildSectionHeader('4. Struktur Panitia & Seragam', primaryColor),
            pw.SizedBox(height: 6),
            if (committee.isEmpty)
              _buildEmptyNotice('Belum ada susunan panitia tercatat.')
            else
              pw.TableHelper.fromTextArray(
                headers: ['No', 'Nama Anggota', 'Peran & Tugas', 'Pihak', 'Rincian Seragam', 'Status Seragam'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
                headerDecoration: const pw.BoxDecoration(color: tableHeaderBg),
                headerPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
                cellStyle: const pw.TextStyle(fontSize: 8, color: textDark),
                rowDecoration: const pw.BoxDecoration(color: tableRowEven),
                columnWidths: const {
                  0: pw.FixedColumnWidth(24),  // No
                  1: pw.FlexColumnWidth(2),    // Nama
                  2: pw.FlexColumnWidth(2.2),  // Peran
                  3: pw.FixedColumnWidth(80),  // Pihak
                  4: pw.FlexColumnWidth(2.3),  // Seragam
                  5: pw.FixedColumnWidth(70),  // Status Seragam
                },
                cellAlignments: const {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerLeft,
                  4: pw.Alignment.centerLeft,
                  5: pw.Alignment.center,
                },
                data: committee.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final c = entry.value;
                  final uniformText = c.uniformDescription != null && c.uniformDescription!.isNotEmpty
                      ? '${c.uniformDescription} (${c.fabricMeters > 0 ? '${c.fabricMeters}m' : '-'})'
                      : (c.fabricMeters > 0 ? '${c.fabricMeters} meter' : '-');
                  return [
                    '$idx',
                    c.memberName,
                    c.role,
                    CommitteeSide.fromString(c.side).label,
                    uniformText,
                    UniformStatus.fromString(c.uniformStatus).label,
                  ];
                }).toList(),
              ),
            pw.SizedBox(height: 16),

            // Section: Checklist Dokumen Nikah
            _buildSectionHeader('5. Dokumen Persyaratan Nikah (KUA / Catatan Sipil)', primaryColor),
            pw.SizedBox(height: 6),
            if (documents.isEmpty)
              _buildEmptyNotice('Belum ada daftar dokumen tercatat.')
            else
              pw.TableHelper.fromTextArray(
                headers: ['No', 'Nama Dokumen Persyaratan', 'Pihak Berkas', 'Target Selesai', 'Status'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
                headerDecoration: const pw.BoxDecoration(color: tableHeaderBg),
                headerPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
                cellStyle: const pw.TextStyle(fontSize: 8, color: textDark),
                rowDecoration: const pw.BoxDecoration(color: tableRowEven),
                columnWidths: const {
                  0: pw.FixedColumnWidth(24),  // No
                  1: pw.FlexColumnWidth(3.5),  // Nama Dokumen
                  2: pw.FixedColumnWidth(85),  // Pihak
                  3: pw.FixedColumnWidth(75),  // Target Selesai
                  4: pw.FixedColumnWidth(68),  // Status
                },
                cellAlignments: const {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                },
                data: documents.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final d = entry.value;
                  return [
                    '$idx',
                    d.docName,
                    DocumentOwnerType.fromString(d.ownerType).label,
                    d.dueDate != null ? WeddingDateUtils.formatShort(d.dueDate!) : '-',
                    d.isCompleted ? 'Lengkap' : 'Belum Selesai',
                  ];
                }).toList(),
              ),
            pw.SizedBox(height: 16),

            // Section: Daftar Seserahan & Mahar
            _buildSectionHeader('6. Daftar Seserahan & Mahar', primaryColor),
            pw.SizedBox(height: 6),
            if (seserahan.isEmpty)
              _buildEmptyNotice('Belum ada data seserahan atau mahar tercatat.')
            else
              pw.TableHelper.fromTextArray(
                headers: ['No', 'Nama Barang & Hantaran', 'Arah Hantaran', 'Estimasi Nilai', 'Status'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
                headerDecoration: const pw.BoxDecoration(color: tableHeaderBg),
                headerPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
                cellStyle: const pw.TextStyle(fontSize: 8, color: textDark),
                rowDecoration: const pw.BoxDecoration(color: tableRowEven),
                columnWidths: const {
                  0: pw.FixedColumnWidth(24),  // No
                  1: pw.FlexColumnWidth(3),    // Nama Barang
                  2: pw.FixedColumnWidth(110), // Arah Hantaran
                  3: pw.FixedColumnWidth(80),  // Estimasi Nilai
                  4: pw.FixedColumnWidth(70),  // Status
                },
                cellAlignments: const {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.center,
                },
                data: seserahan.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final s = entry.value;
                  return [
                    '$idx',
                    s.itemName,
                    SeserahanDirection.fromString(s.direction).label,
                    CurrencyUtils.formatRupiah(s.estimatedPrice),
                    SeserahanStatus.fromString(s.status).label,
                  ];
                }).toList(),
              ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Ringkasan_Pernikahan_${profile.groomName}_${profile.brideName}.pdf',
    );
  }

  static pw.Widget _buildSectionHeader(String title, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Container(
            width: 3.5,
            height: 12,
            margin: const pw.EdgeInsets.only(right: 6),
            decoration: pw.BoxDecoration(
              color: color,
              borderRadius: pw.BorderRadius.circular(1.5),
            ),
          ),
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 10.5,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildEmptyNotice(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600, fontStyle: pw.FontStyle.italic),
      ),
    );
  }

  static pw.Widget _buildPdfStat(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700)),
        pw.SizedBox(height: 2),
        pw.Text(value, style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }

  static String _formatPaymentStatus(String status) {
    final s = status.toUpperCase().trim();
    if (s == 'FULLY_PAID' || s == 'LUNAS') return 'Lunas';
    if (s == 'PARTIAL_DP' || s == 'PARTIALLY_PAID' || s == 'DP') return 'DP Terbayar';
    return 'Belum Bayar';
  }

  /// Exports guests to a real CSV file on disk and triggers file share
  static Future<void> exportGuestsCsv(WeddingProfile profile, List<WeddingGuest> guests) async {
    final buffer = StringBuffer();
    buffer.writeln('No,Nama Tamu,Nomor WhatsApp,Kelompok Tamu,Sesi Undangan,Estimasi Pax,Status Kehadiran');

    for (var i = 0; i < guests.length; i++) {
      final g = guests[i];
      final no = i + 1;
      final name = '"${g.guestName.replaceAll('"', '""')}"';
      final phone = '"${(g.phoneNumber ?? '-').replaceAll('"', '""')}"';
      final group = '"${GuestGroup.fromString(g.groupAllocation).label}"';
      final session = '"${SessionTarget.fromString(g.sessionTarget).label}"';
      final pax = g.estimatedPax;
      final rsvp = '"${RsvpStatus.fromString(g.rsvpStatus).label}"';
      buffer.writeln('$no,$name,$phone,$group,$session,$pax,$rsvp');
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final cleanGroom = profile.groomName.replaceAll(RegExp(r'[^\w\.-]'), '_');
      final cleanBride = profile.brideName.replaceAll(RegExp(r'[^\w\.-]'), '_');
      final fileName = 'Daftar_Tamu_${cleanGroom}_$cleanBride.csv';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(buffer.toString(), encoding: utf8);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'text/csv', name: fileName)],
          subject: 'Daftar Tamu Pernikahan ${profile.groomName} & ${profile.brideName}',
          text: 'File CSV Daftar Tamu Pernikahan ${profile.groomName} & ${profile.brideName}',
        ),
      );
    } catch (_) {
      // Fallback if writing temp file fails on unsupported platform
      await SharePlus.instance.share(
        ShareParams(
          text: buffer.toString(),
          subject: 'Daftar_Tamu_${profile.groomName}_${profile.brideName}.csv',
        ),
      );
    }
  }
}
