import 'package:flutter/material.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/widgets/bento_card.dart';

class SettingsBackupCard extends StatelessWidget {
  final WeddingProfile profile;
  final VoidCallback onExportPdf;
  final VoidCallback onExportCsv;
  final VoidCallback onExportJson;
  final VoidCallback onRestoreJson;

  const SettingsBackupCard({
    super.key,
    required this.profile,
    required this.onExportPdf,
    required this.onExportCsv,
    required this.onExportJson,
    required this.onRestoreJson,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 22),
            ),
            title: const Text(
              'Ekspor Buku Panduan Nikah (PDF)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: const Text(
              'Format lengkap berisi anggaran, vendor, rundown, dan panitia',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: onExportPdf,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.table_chart_rounded, color: Colors.teal, size: 22),
            ),
            title: const Text(
              'Ekspor Daftar Tamu Undangan (CSV)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: const Text(
              'Format tabel spreadsheet untuk tim penerima tamu',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: onExportCsv,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.backup_rounded, color: Colors.blue, size: 22),
            ),
            title: const Text(
              'Cadangkan Data Lengkap (JSON Backup)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: const Text(
              'Simpan seluruh data profil, anggaran, tamu, vendor ke file .json',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: onExportJson,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade800.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.restore_page_rounded, color: Colors.amber.shade800, size: 22),
            ),
            title: const Text(
              'Pulihkan Data (Restore Backup)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: const Text(
              'Pulihkan rencana pernikahan dari teks atau file JSON cadangan',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: onRestoreJson,
          ),
        ],
      ),
    );
  }
}
