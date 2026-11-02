import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../shared/widgets/offline_banner.dart';
import '../../shared/widgets/wedding_doodle_background.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/auth_state.dart';

class WeddingShellScaffold extends ConsumerWidget {
  final String profileId;
  final String location;
  final Widget child;

  const WeddingShellScaffold({
    super.key,
    required this.profileId,
    required this.location,
    required this.child,
  });

  int _calculateSelectedIndex() {
    if (location == '/wedding/$profileId' || location == '/wedding/$profileId/') {
      return 0;
    }
    if (location.startsWith('/wedding/$profileId/tasks')) {
      return 1;
    }
    if (location.startsWith('/wedding/$profileId/budget')) {
      return 2;
    }
    return -1; // Other screens or menu
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0) {
      context.go('/wedding/$profileId');
    } else if (index == 1) {
      context.go('/wedding/$profileId/tasks');
    } else if (index == 2) {
      context.go('/wedding/$profileId/budget');
    } else if (index == 3) {
      _showMenuSheet(context);
    }
  }

  void _showMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Menu Lainnya',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                WeddingMenuGrid(
                  onNavigate: (route) {
                    Navigator.of(bottomSheetContext).pop();
                    context.go('/wedding/$profileId/$route');
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        context.go('/login');
      }
    });

    final selectedIndex = _calculateSelectedIndex();
    final theme = Theme.of(context);

    return Scaffold(
      body: WeddingDoodleBackground(
        child: Column(
          children: [
            const OfflineBanner(),
            Expanded(
              child: Theme(
                data: theme.copyWith(
                  scaffoldBackgroundColor: Colors.transparent,
                  appBarTheme: theme.appBarTheme.copyWith(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
        indicatorColor: selectedIndex >= 0 ? theme.colorScheme.primaryContainer : Colors.transparent,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: [
          NavigationDestination(
            icon: Icon(
              PhosphorIconsRegular.house,
              color: selectedIndex == 0 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(PhosphorIconsFill.house, color: theme.colorScheme.primary),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(
              PhosphorIconsRegular.checkCircle,
              color: selectedIndex == 1 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(PhosphorIconsFill.checkCircle, color: theme.colorScheme.primary),
            label: 'Tugas',
          ),
          NavigationDestination(
            icon: Icon(
              PhosphorIconsRegular.wallet,
              color: selectedIndex == 2 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(PhosphorIconsFill.wallet, color: theme.colorScheme.primary),
            label: 'Anggaran',
          ),
          NavigationDestination(
            icon: Icon(
              PhosphorIconsRegular.squaresFour,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(PhosphorIconsFill.squaresFour, color: theme.colorScheme.primary),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

class WeddingMenuGrid extends StatelessWidget {
  final ValueChanged<String> onNavigate;

  const WeddingMenuGrid({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      _MenuItem('guests', 'Tamu', PhosphorIconsRegular.users),
      _MenuItem('vendors', 'Vendor', PhosphorIconsRegular.storefront),
      _MenuItem('seserahan', 'Seserahan', PhosphorIconsRegular.gift),
      _MenuItem('committee', 'Panitia', PhosphorIconsRegular.identificationBadge),
      _MenuItem('rundown', 'Rundown', PhosphorIconsRegular.calendarCheck),
      _MenuItem('documents', 'Dokumen', PhosphorIconsRegular.folder),
      _MenuItem('settings', 'Pengaturan', PhosphorIconsRegular.gear),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => onNavigate(item.route),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(
                  item.icon,
                  color: theme.colorScheme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final String route;
  final String label;
  final IconData icon;

  _MenuItem(this.route, this.label, this.icon);
}
