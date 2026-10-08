import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../updater/presentation/update_notifier.dart';
import '../../../updater/presentation/widgets/update_dialog.dart';

class SettingsAppInfoCard extends ConsumerStatefulWidget {
  const SettingsAppInfoCard({super.key});

  @override
  ConsumerState<SettingsAppInfoCard> createState() => _SettingsAppInfoCardState();
}

class _SettingsAppInfoCardState extends ConsumerState<SettingsAppInfoCard> {
  bool _isCheckingUpdate = false;

  Future<void> _handleCheckUpdate() async {
    setState(() => _isCheckingUpdate = true);
    final theme = Theme.of(context);

    try {
      final release = await ref.read(updateNotifierProvider.notifier).checkForUpdate(silent: false);
      if (!mounted) return;

      if (release != null) {
        UpdateDialog.show(context, release: release);
      } else {
        final updateState = ref.read(updateNotifierProvider);
        if (updateState.status == UpdateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memeriksa pembaruan: ${updateState.errorMessage ?? "Periksa koneksi internet"}'),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          final currentVer = updateState.currentVersion;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Aplikasi Nikahin sudah dalam versi terbaru (v${currentVer.isNotEmpty ? currentVer : "1.0.0"}).'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isCheckingUpdate = false);
    }
  }

  Widget _buildFeatureItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11.5,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentVersion = ref.watch(updateNotifierProvider.select((s) => s.currentVersion));

    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.system_update_rounded, color: theme.colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nikahin',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Versi ${currentVersion.isNotEmpty ? currentVersion : "1.0.0"} (Build Stabil)',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(
                onPressed: _isCheckingUpdate ? null : _handleCheckUpdate,
                child: _isCheckingUpdate
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Cek Update'),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            'Fitur Unggulan Nikahin',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          _buildFeatureItem(
            theme,
            icon: Icons.account_balance_wallet_outlined,
            title: 'Anggaran & Vendor',
            desc: 'Pelacakan pos biaya, pembayaran bertahap (DP / Lunas), dan daftar kontak vendor.',
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            theme,
            icon: Icons.event_note_outlined,
            title: 'Timeline Rundown Acara',
            desc: 'Penjadwalan urutan sesi kegiatan acara akad & resepsi beserta penanggung jawab (PIC).',
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            theme,
            icon: Icons.people_outline_rounded,
            title: 'Buku Tamu & RSVP',
            desc: 'Manajemen alokasi tamu per sesi (Akad/Resepsi), kelompok pihak, dan status kehadiran.',
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            theme,
            icon: Icons.assignment_outlined,
            title: 'Berkas Dokumen Nikah',
            desc: 'Checklist berkas KUA / Catatan Sipil dengan penentuan target deadline otomatis.',
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            theme,
            icon: Icons.card_giftcard_outlined,
            title: 'Seserahan & Panitia',
            desc: 'Rincian hantaran mahar CPP/CPW serta pembagian tugas & seragam panitia keluarga.',
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            theme,
            icon: Icons.print_outlined,
            title: 'Ekspor PDF & CSV',
            desc: 'Cetak buku panduan resmi pernikahan berformat tabel rapi siap bagikan ke keluarga & WO.',
          ),
        ],
      ),
    );
  }
}
