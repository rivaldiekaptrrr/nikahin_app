import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WeddingShellScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex();
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
        indicatorColor: selectedIndex >= 0 ? theme.colorScheme.primaryContainer : Colors.transparent,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: selectedIndex == 0 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(Icons.home_rounded, color: theme.colorScheme.primary),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.check_circle_outline_rounded,
              color: selectedIndex == 1 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary),
            label: 'Tugas',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
              color: selectedIndex == 2 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded, color: theme.colorScheme.primary),
            label: 'Anggaran',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.grid_view_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
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
      _MenuItem('guests', 'Tamu', Icons.people_rounded),
      _MenuItem('vendors', 'Vendor', Icons.storefront_rounded),
      _MenuItem('seserahan', 'Seserahan', Icons.card_giftcard_rounded),
      _MenuItem('committee', 'Panitia', Icons.groups_rounded),
      _MenuItem('rundown', 'Rundown', Icons.event_note_rounded),
      _MenuItem('documents', 'Dokumen', Icons.folder_rounded),
      _MenuItem('settings', 'Pengaturan', Icons.settings_rounded),
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
