import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../auth/presentation/auth_notifier.dart';

class SettingsUnifiedProfileCard extends ConsumerWidget {
  final WeddingProfile profile;
  final VoidCallback onEditProfile;

  const SettingsUnifiedProfileCard({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  String _getMonogram() {
    final groom = profile.groomName.trim().isNotEmpty ? profile.groomName.trim()[0].toUpperCase() : 'P';
    final bride = profile.brideName.trim().isNotEmpty ? profile.brideName.trim()[0].toUpperCase() : 'W';
    return '$groom & $bride';
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    final hasNames = profile.groomName.isNotEmpty || profile.brideName.isNotEmpty;
    final dateStr = profile.weddingDate > 0
        ? DateFormat('d MMMM yyyy', 'id_ID').format(
            DateTime.fromMillisecondsSinceEpoch(profile.weddingDate),
          )
        : 'Tanggal Belum Ditentukan';

    final isDemo = authState.isDemoMode;
    final isAdmin = authState.isAdmin;
    final isPremium = authState.isPremium;
    final isPending = authState.isPendingVerification;

    // Status styling
    Color statusColor;
    String statusTitle;
    String statusSubtitle;
    VoidCallback? onStatusTap;

    if (isDemo) {
      statusColor = const Color(0xFFD97706);
      statusTitle = 'Mode Demo';
      statusSubtitle = 'Ketuk untuk masuk atau mendaftar akun';
      onStatusTap = () => context.go('/login');
    } else if (isAdmin) {
      statusColor = const Color(0xFFD97706);
      statusTitle = authState.email ?? 'Super Admin';
      statusSubtitle = 'Akun Administrator';
    } else if (isPremium) {
      statusColor = const Color(0xFF059669);
      statusTitle = authState.email ?? 'Akun Terhubung';
      statusSubtitle = 'Lisensi Premium';
    } else if (isPending) {
      statusColor = const Color(0xFFEA580C);
      statusTitle = authState.email ?? 'Menunggu Aktivasi';
      statusSubtitle = 'Menunggu Pembayaran • Ketuk untuk Aktivasi';
      onStatusTap = () => context.go('/pending-verification');
    } else {
      statusColor = theme.colorScheme.outline;
      statusTitle = 'Penyimpanan Lokal';
      statusSubtitle = 'Data tersimpan di perangkat • Ketuk untuk masuk';
      onStatusTap = () => context.go('/login');
    }

    final photoUrl = authState.photoUrl;

    return BentoCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TOP ROW: Avatar + Identity + Edit Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar (Google Photo with Dual Monogram Fallback)
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: photoUrl != null && photoUrl.isNotEmpty
                      ? null
                      : LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.tertiary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child: photoUrl != null && photoUrl.isNotEmpty
                    ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        width: 52,
                        height: 52,
                        errorBuilder: (context, error, stackTrace) => _buildMonogramText(theme),
                      )
                    : _buildMonogramText(theme),
              ),
              const SizedBox(width: 14),

              // Names & Date/Countdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasNames ? profile.coupleTitle : 'Rencana Pernikahan Baru',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            dateStr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Edit Profile Button
              FilledButton.tonalIcon(
                onPressed: onEditProfile,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit_rounded, size: 14),
                label: const Text(
                  'Edit',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          // 2. HAIRLINE DIVIDER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),

          // 3. BOTTOM ROW: Status Akun & Cloud Live Sync (Bebas Tombol Redundan)
          InkWell(
            onTap: onStatusTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          statusSubtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: isPremium
                                ? const Color(0xFF059669)
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isPremium ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (onStatusTap != null)
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonogramText(ThemeData theme) {
    return Text(
      _getMonogram(),
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        fontSize: 15,
      ),
    );
  }
}
