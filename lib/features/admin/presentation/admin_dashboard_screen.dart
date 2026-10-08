import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/models/access_level.dart';
import '../../../shared/utils/date_utils.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../auth/presentation/auth_notifier.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'ALL'; // 'ALL', 'NONE', 'PREMIUM', 'ADMIN'
  bool _isLoading = false;
  List<AppUserInfo> _users = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetched = await ref.read(authNotifierProvider.notifier).fetchAllUsers();
      if (mounted) {
        setState(() {
          _users = fetched;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Gagal memuat pengguna: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserAccess(AppUserInfo user, AccessLevel newLevel) async {
    final theme = Theme.of(context);
    final success = await ref.read(authNotifierProvider.notifier).updateTargetUserAccess(user.uid, newLevel);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Akses untuk "${user.email}" berhasil diubah ke ${newLevel.label}.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.primary,
          ),
        );
        // Update local list item
        setState(() {
          final index = _users.indexWhere((u) => u.uid == user.uid);
          if (index != -1) {
            _users[index] = _users[index].copyWith(accessLevel: newLevel);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal memperbarui hak akses pengguna.'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = _searchController.text.trim().toLowerCase();

    final filteredUsers = _users.where((u) {
      final matchesQuery = query.isEmpty ||
          u.email.toLowerCase().contains(query) ||
          (u.displayName?.toLowerCase().contains(query) ?? false);

      if (!matchesQuery) return false;

      switch (_selectedFilter) {
        case 'NONE':
          return u.accessLevel == AccessLevel.none;
        case 'PREMIUM':
          return u.accessLevel == AccessLevel.premium;
        case 'ADMIN':
          return u.accessLevel == AccessLevel.admin;
        default:
          return true;
      }
    }).toList();

    final totalCount = _users.length;
    final pendingCount = _users.where((u) => u.accessLevel == AccessLevel.none).length;
    final premiumCount = _users.where((u) => u.accessLevel == AccessLevel.premium).length;
    final adminCount = _users.where((u) => u.accessLevel == AccessLevel.admin).length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Panel Super Admin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan Data',
            onPressed: _isLoading ? null : _loadUsers,
          ),
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            tooltip: 'Masuk Aplikasi Nikahin',
            onPressed: () => context.go('/wedding/profile_rivaldi_alya'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Keluar',
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Stats Metrics Card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      theme,
                      title: 'Total User',
                      value: '$totalCount',
                      color: theme.colorScheme.primary,
                      icon: Icons.people_outline_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricTile(
                      theme,
                      title: 'Menunggu',
                      value: '$pendingCount',
                      color: Colors.orange.shade700,
                      icon: Icons.hourglass_top_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricTile(
                      theme,
                      title: 'Premium',
                      value: '$premiumCount',
                      color: Colors.green.shade700,
                      icon: Icons.verified_rounded,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari email atau nama pembeli...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () => setState(() => _searchController.clear()),
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

            // 3. Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  _buildFilterChip('ALL', 'Semua ($totalCount)'),
                  _buildFilterChip('NONE', 'Menunggu ($pendingCount)'),
                  _buildFilterChip('PREMIUM', 'Aktif ($premiumCount)'),
                  _buildFilterChip('ADMIN', 'Admin ($adminCount)'),
                ],
              ),
            ),
            const Divider(height: 12),

            // 4. Users List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 40),
                                const SizedBox(height: 10),
                                Text(_errorMessage!, textAlign: TextAlign.center),
                                const SizedBox(height: 14),
                                FilledButton(
                                  onPressed: _loadUsers,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : filteredUsers.isEmpty
                          ? Center(
                              child: Text(
                                query.isEmpty ? 'Belum ada pengguna terdaftar.' : 'Pengguna tidak ditemukan.',
                                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                return _buildUserCard(context, user);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    ThemeData theme, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return BentoCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterVal, String label) {
    final isSelected = _selectedFilter == filterVal;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedFilter = filterVal),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, AppUserInfo user) {
    final theme = Theme.of(context);
    final initial = user.email.isNotEmpty ? user.email[0].toUpperCase() : 'U';

    Color badgeColor;
    String badgeText;
    switch (user.accessLevel) {
      case AccessLevel.admin:
        badgeColor = Colors.amber.shade800;
        badgeText = 'SUPER ADMIN';
        break;
      case AccessLevel.premium:
        badgeColor = Colors.green.shade700;
        badgeText = 'PREMIUM';
        break;
      case AccessLevel.none:
        badgeColor = Colors.orange.shade700;
        badgeText = 'MENUNGGU';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BentoCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? user.email.split('@').first,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: badgeColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terdaftar: ${WeddingDateUtils.formatShort(user.createdAt)}',
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (user.accessLevel == AccessLevel.none)
                      FilledButton.tonal(
                        onPressed: () => _updateUserAccess(user, AccessLevel.premium),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline_rounded, size: 14),
                            SizedBox(width: 4),
                            Text('Aktifkan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    else if (user.accessLevel == AccessLevel.premium)
                      OutlinedButton(
                        onPressed: () => _updateUserAccess(user, AccessLevel.none),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Cabut Akses', style: TextStyle(fontSize: 12)),
                      ),
                    const SizedBox(width: 6),
                    PopupMenuButton<AccessLevel>(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: const Icon(Icons.more_vert_rounded, size: 18),
                      onSelected: (level) => _updateUserAccess(user, level),
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: AccessLevel.premium,
                          child: Text('Jadikan Premium Lifetime'),
                        ),
                        const PopupMenuItem(
                          value: AccessLevel.none,
                          child: Text('Kunci (Menunggu Pembayaran)'),
                        ),
                        const PopupMenuItem(
                          value: AccessLevel.admin,
                          child: Text('Jadikan Super Admin'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
