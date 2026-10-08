import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/repositories/wedding_repository.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../auth/presentation/auth_notifier.dart';

class SettingsCloudSyncCard extends ConsumerWidget {
  const SettingsCloudSyncCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sync = ref.watch(syncManagerProvider);
    final authState = ref.watch(authNotifierProvider);

    final isDemo = authState.isDemoMode;
    final isAuthenticated = authState.isAuthenticated;
    final isAdmin = authState.isAdmin;
    final isPremium = authState.isPremium;
    final isPending = authState.isPendingVerification;

    Color badgeColor;
    String statusTitle;
    String statusDesc;
    IconData statusIcon;

    if (isDemo) {
      badgeColor = Colors.amber.shade800;
      statusTitle = 'Mode Demo (Hanya Lihat)';
      statusDesc = 'Fitur penambahan & edit dinonaktifkan di mode ini.';
      statusIcon = Icons.visibility_outlined;
    } else if (isAdmin) {
      badgeColor = Colors.amber.shade800;
      statusTitle = '👑 Akun Super Admin';
      statusDesc = authState.email ?? 'Akses penuh & manajemen pengguna';
      statusIcon = Icons.admin_panel_settings_rounded;
    } else if (isPremium) {
      badgeColor = Colors.green.shade700;
      statusTitle = '✨ Lisensi Premium Aktif';
      statusDesc = authState.email ?? 'Sinkronisasi Cloud & fitur penuh aktif';
      statusIcon = Icons.verified_rounded;
    } else if (isPending) {
      badgeColor = Colors.orange.shade800;
      statusTitle = 'Menunggu Aktivasi Lisensi';
      statusDesc = 'Aktifkan lisensi untuk sinkronisasi cloud penuh';
      statusIcon = Icons.hourglass_top_rounded;
    } else {
      badgeColor = theme.colorScheme.outline;
      statusTitle = 'Penyimpanan Offline';
      statusDesc = 'Semua data tersimpan aman di perangkat lokal.';
      statusIcon = Icons.cloud_off_rounded;
    }

    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  color: badgeColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      statusDesc,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Buttons
          if (isAdmin) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.go('/admin'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber.shade800,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.shield_rounded, size: 18),
                label: const Text('Buka Panel Super Admin', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
          ],

          Row(
            children: [
              if (isDemo) ...[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(Icons.login_rounded, size: 16),
                    label: const Text('Masuk / Buat Akun'),
                  ),
                ),
              ] else if (isPending) ...[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/pending-verification'),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                    label: const Text('Beli / Aktivasi Lisensi'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) context.go('/login');
                  },
                  child: const Text('Keluar'),
                ),
              ] else if (isAuthenticated) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final success = await sync.pullAll();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success ? 'Sinkronisasi berhasil!' : 'Mode lokal aktif.'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.sync_rounded, size: 16),
                    label: const Text('Sinkronkan'),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout_rounded, size: 16),
                  label: const Text('Keluar'),
                ),
              ] else ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final success = await sync.pullAll();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success ? 'Sinkronisasi berhasil!' : 'Mode lokal aktif.'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.sync_rounded, size: 16),
                    label: const Text('Sinkronkan'),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonalIcon(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.person_outline_rounded, size: 16),
                  label: const Text('Masuk Akun'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
