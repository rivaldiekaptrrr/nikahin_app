import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/config/platform_config.dart';
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

  void _showFeatureSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Icon(PhosphorIconsFill.sparkle, color: theme.colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Fitur Unggulan Nikahin',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Nikahin hadir untuk membantu Anda dan pasangan menyiapkan pernikahan dengan rapi, tenang, dan otomatis tersimpan aman.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              _buildFeatureItem(
                theme,
                icon: PhosphorIconsRegular.wallet,
                title: 'Anggaran & Vendor',
                desc: 'Catat pos pengeluaran, pantau DP hingga pelunasan, dan simpan kontak vendor.',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                theme,
                icon: PhosphorIconsRegular.calendarCheck,
                title: 'Susunan Acara (Rundown)',
                desc: 'Atur susunan acara akad serta resepsi lengkap dengan penanggung jawab di lapangan.',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                theme,
                icon: PhosphorIconsRegular.users,
                title: 'Buku Tamu & RSVP',
                desc: 'Atur alokasi tamu per sesi (Akad atau Resepsi), kelompok pihak keluarga, dan konfirmasi kehadiran.',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                theme,
                icon: PhosphorIconsRegular.clipboardText,
                title: 'Berkas Dokumen Nikah',
                desc: 'Daftar kelengkapan berkas KUA atau Catatan Sipil dengan pengingat tenggat waktu.',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                theme,
                icon: PhosphorIconsRegular.gift,
                title: 'Seserahan & Panitia',
                desc: 'Rincian hantaran mahar serta pembagian tugas dan seragam panitia keluarga.',
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                theme,
                icon: PhosphorIconsRegular.printer,
                title: 'Ekspor PDF & CSV',
                desc: 'Cetak buku panduan pernikahan yang rapi dan siap dibagikan ke keluarga maupun WO.',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
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
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF2E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Image.asset(
                  'assets/logo/png/nikahin-symbol-master.png',
                  fit: BoxFit.contain,
                ),
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
              if (AppPlatformConfig.isApkUpdaterAvailable)
                FilledButton.tonalIcon(
                  onPressed: _isCheckingUpdate ? null : _handleCheckUpdate,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: _isCheckingUpdate
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 1.8),
                        )
                      : const Icon(PhosphorIconsRegular.arrowClockwise, size: 13),
                  label: Text(_isCheckingUpdate ? 'Memeriksa...' : 'Cek Update'),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(PhosphorIconsFill.cloudCheck, size: 14, color: Color(0xFFAA771C)),
                      const SizedBox(width: 5),
                      Text(
                        'Web PWA Aktif',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Divider(height: 20),
          InkWell(
            onTap: () => _showFeatureSheet(context),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsFill.sparkle,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Panduan & Ringkasan Fitur Aplikasi',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Icon(
                    PhosphorIconsRegular.caretRight,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
