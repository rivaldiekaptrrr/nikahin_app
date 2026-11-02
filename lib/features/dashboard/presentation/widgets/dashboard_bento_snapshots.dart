import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../../../../data/repositories/wedding_repository.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/widgets/bento_card.dart';

/// Bento Grid 2x2 yang menyajikan ringkasan holistik kesiapan pernikahan:
/// 1. Tamu & RSVP
/// 2. Checklist Persiapan
/// 3. Dokumen KUA & Legalitas
/// 4. Vendor Pernikahan
class DashboardBentoSnapshots extends ConsumerWidget {
  final String profileId;

  const DashboardBentoSnapshots({
    super.key,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kesiapan Pernikahan',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'Kilas persiapan berdua',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Baris 1: Tamu & RSVP + Checklist Persiapan
        Row(
          children: [
            Expanded(
              child: _GuestSnapshotCard(profileId: profileId),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TaskSnapshotCard(profileId: profileId),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Baris 2: Dokumen KUA + Vendor Pernikahan
        Row(
          children: [
            Expanded(
              child: _DocumentSnapshotCard(profileId: profileId),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _VendorSnapshotCard(profileId: profileId),
            ),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// 1. KARTU TAMU & RSVP
// ==========================================
class _GuestSnapshotCard extends ConsumerWidget {
  final String profileId;
  const _GuestSnapshotCard({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(weddingRepositoryProvider);
    final theme = Theme.of(context);

    return StreamBuilder<List<WeddingGuest>>(
      stream: repo.watchGuests(profileId),
      builder: (context, snapshot) {
        final guests = snapshot.data ?? [];
        final totalGuests = guests.length;
        final attending = guests.where((g) => g.rsvpStatus == 'ATTENDING').length;
        final pending = guests.where((g) => g.rsvpStatus == 'PENDING').length;

        final subText = totalGuests == 0
            ? 'Belum ada daftar tamu'
            : '$attending Hadir • $pending Menunggu';

        return _BentoSnapshotShell(
          icon: PhosphorIconsRegular.users,
          iconColor: const Color(0xFFD97706),
          iconBgColor: const Color(0xFFFEF3C7),
          title: 'Tamu & RSVP',
          metric: totalGuests == 0 ? '0 Tamu' : '$totalGuests Tamu',
          subWidget: Text(
            subText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => context.go('/wedding/$profileId/guests'),
        );
      },
    );
  }
}

// ==========================================
// 2. KARTU CHECKLIST PERSIAPAN
// ==========================================
class _TaskSnapshotCard extends ConsumerWidget {
  final String profileId;
  const _TaskSnapshotCard({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(weddingRepositoryProvider);
    final theme = Theme.of(context);

    return StreamBuilder<List<WeddingTask>>(
      stream: repo.watchTasks(profileId),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        final totalTasks = tasks.length;
        final completedTasks = tasks.where((t) => t.isCompleted).length;
        final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
        final percentage = (progress * 100).round();

        return _BentoSnapshotShell(
          icon: PhosphorIconsRegular.checkCircle,
          iconColor: const Color(0xFF059669),
          iconBgColor: const Color(0xFFD1FAE5),
          title: 'Checklist Persiapan',
          metric: totalTasks == 0 ? '0 Tugas' : '$completedTasks / $totalTasks Tugas',
          subWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                totalTasks == 0 ? 'Bisa mulai dicicil' : '$percentage% rampung',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          onTap: () => context.go('/wedding/$profileId/tasks'),
        );
      },
    );
  }
}

// ==========================================
// 3. KARTU DOKUMEN KUA & LEGALITAS
// ==========================================
class _DocumentSnapshotCard extends ConsumerWidget {
  final String profileId;
  const _DocumentSnapshotCard({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(weddingRepositoryProvider);
    final theme = Theme.of(context);

    return StreamBuilder<List<WeddingDocument>>(
      stream: repo.watchDocuments(profileId),
      builder: (context, snapshot) {
        final docs = snapshot.data ?? [];
        final totalDocs = docs.length;
        final completedDocs = docs.where((d) => d.isCompleted).length;
        final remaining = totalDocs - completedDocs;

        final subText = totalDocs == 0
            ? 'Syarat nikah belum dicatat'
            : (remaining == 0 ? 'Semua berkas beres' : 'Tinggal $remaining berkas lagi');

        return _BentoSnapshotShell(
          icon: PhosphorIconsRegular.fileText,
          iconColor: const Color(0xFF2563EB),
          iconBgColor: const Color(0xFFDBEAFE),
          title: 'Dokumen KUA',
          metric: totalDocs == 0 ? '0 Berkas' : '$completedDocs / $totalDocs Berkas',
          subWidget: Text(
            subText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: remaining == 0
                  ? const Color(0xFF059669)
                  : theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: remaining == 0 ? FontWeight.w600 : FontWeight.normal,
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => context.go('/wedding/$profileId/documents'),
        );
      },
    );
  }
}

// ==========================================
// 4. KARTU VENDOR PERNIKAHAN
// ==========================================
class _VendorSnapshotCard extends ConsumerWidget {
  final String profileId;
  const _VendorSnapshotCard({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(weddingRepositoryProvider);
    final theme = Theme.of(context);

    return StreamBuilder<List<WeddingVendor>>(
      stream: repo.watchVendors(profileId),
      builder: (context, snapshot) {
        final vendors = snapshot.data ?? [];
        final totalVendors = vendors.length;

        final completedCount = vendors
            .where((v) => v.status.toUpperCase() == 'SELESAI')
            .length;
        final contractCount = vendors
            .where((v) => v.status.toUpperCase() == 'KONTRAK')
            .length;
        final tandaJadiCount = vendors
            .where((v) => v.status.toUpperCase() == 'TANDA_JADI')
            .length;
        final prospectCount = vendors
            .where((v) => v.status.toUpperCase() == 'PROSPEK')
            .length;

        final dealCount = completedCount + contractCount + tandaJadiCount;

        final String metricText = totalVendors == 0
            ? '0 Vendor'
            : '$dealCount / $totalVendors Deal';

        String subText;
        if (totalVendors == 0) {
          subText = 'Mulai cari vendor impian';
        } else if (dealCount == 0) {
          subText = 'Masih tahap riset vendor';
        } else if (completedCount == totalVendors) {
          subText = 'Semua vendor selesai';
        } else {
          final parts = <String>[];
          if (completedCount > 0) parts.add('$completedCount Selesai');
          if (contractCount > 0) parts.add('$contractCount Kontrak');
          if (tandaJadiCount > 0) parts.add('$tandaJadiCount Tanda Jadi');
          if (parts.length == 1 && prospectCount > 0) {
            parts.add('$prospectCount Riset');
          }
          subText = parts.take(2).join(' • ');
        }

        return _BentoSnapshotShell(
          icon: PhosphorIconsRegular.storefront,
          iconColor: const Color(0xFF9333EA),
          iconBgColor: const Color(0xFFF3E8FF),
          title: 'Vendor Pernikahan',
          metric: metricText,
          subWidget: Text(
            subText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: dealCount > 0
                  ? const Color(0xFF059669)
                  : theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: dealCount > 0 ? FontWeight.w600 : FontWeight.normal,
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => context.go('/wedding/$profileId/vendors'),
        );
      },
    );
  }
}

// ==========================================
// SHELL WIDGET KARTU BENTO (KONSISTEN & INTERAKTIF)
// ==========================================
class _BentoSnapshotShell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String metric;
  final Widget subWidget;
  final VoidCallback onTap;

  const _BentoSnapshotShell({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.metric,
    required this.subWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BentoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      borderRadius: 20,
      gradient: LinearGradient(
        colors: isDark
            ? [
                theme.colorScheme.surfaceContainer,
                theme.colorScheme.surfaceContainerHigh,
              ]
            : [
                theme.colorScheme.primaryContainer.withValues(alpha: 0.65),
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.14),
        width: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Baris Atas: Ikon + Panah Navigasi Halus
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? iconColor.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: isDark
                        ? iconColor.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.9),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isDark ? iconColor.withValues(alpha: 0.95) : iconColor,
                ),
              ),
              Icon(
                PhosphorIconsRegular.caretRight,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Label Judul Modul
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          // Metrik Utama (Angka Tebal)
          Text(
            metric,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15.5,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Sub-Widget (Status / Progress Bar)
          subWidget,
        ],
      ),
    );
  }
}
