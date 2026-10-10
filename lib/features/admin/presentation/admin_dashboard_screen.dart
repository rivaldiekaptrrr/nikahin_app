import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/business_config.dart';
import '../../../domain/models/access_level.dart';
import '../../../shared/utils/currency_utils.dart';
import '../../../shared/utils/date_utils.dart';
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

  // Multi-Selection State
  final Set<String> _selectedUserIds = {};
  bool _isBatchProcessing = false;

  bool get _isSelectionMode => _selectedUserIds.isNotEmpty;

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
          // Clear selections for deleted/changed items
          _selectedUserIds.retainWhere((id) => fetched.any((u) => u.uid == id));
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Gagal memuat daftar pengguna: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleSelection(String uid) {
    setState(() {
      if (_selectedUserIds.contains(uid)) {
        _selectedUserIds.remove(uid);
      } else {
        _selectedUserIds.add(uid);
      }
    });
  }

  void _selectAll(List<AppUserInfo> list) {
    setState(() {
      final eligible = list
          .where((u) => u.email.toLowerCase() != BusinessConfig.adminEmail.toLowerCase())
          .map((u) => u.uid);
      _selectedUserIds.addAll(eligible);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedUserIds.clear();
    });
  }

  Future<void> _updateUserAccess(AppUserInfo user, AccessLevel newLevel) async {
    final theme = Theme.of(context);
    final success = await ref.read(authNotifierProvider.notifier).updateTargetUserAccess(user.uid, newLevel);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Akses "${user.email}" diubah ke ${newLevel.label}.',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: newLevel == AccessLevel.premium ? Colors.green.shade700 : theme.colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        setState(() {
          final index = _users.indexWhere((u) => u.uid == user.uid);
          if (index != -1) {
            _users[index] = _users[index].copyWith(accessLevel: newLevel);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Gagal memperbarui hak akses pengguna.')),
              ],
            ),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _deleteUser(AppUserInfo user) async {
    final theme = Theme.of(context);
    final success = await ref.read(authNotifierProvider.notifier).deleteTargetUser(user.uid);

    if (mounted) {
      if (success) {
        setState(() {
          _users.removeWhere((u) => u.uid == user.uid);
          _selectedUserIds.remove(user.uid);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Akun "${user.email}" berhasil dihapus dari cloud.',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Gagal menghapus pengguna dari server.')),
              ],
            ),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _batchUpdateAccess(AccessLevel newLevel) async {
    if (_selectedUserIds.isEmpty) return;
    setState(() => _isBatchProcessing = true);
    final count = _selectedUserIds.length;
    int successCount = 0;

    for (final uid in _selectedUserIds.toList()) {
      final success = await ref.read(authNotifierProvider.notifier).updateTargetUserAccess(uid, newLevel);
      if (success) {
        successCount++;
        final index = _users.indexWhere((u) => u.uid == uid);
        if (index != -1) {
          _users[index] = _users[index].copyWith(accessLevel: newLevel);
        }
      }
    }

    if (mounted) {
      setState(() {
        _isBatchProcessing = false;
        _selectedUserIds.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$successCount dari $count pengguna berhasil diubah ke ${newLevel.label}.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: newLevel == AccessLevel.premium ? Colors.green.shade700 : Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _batchDelete() async {
    if (_selectedUserIds.isEmpty) return;

    final count = _selectedUserIds.length;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Hapus Masal?'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus $count pengguna terpilih secara permanen dari server Firestore?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Ya, Hapus Semua'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isBatchProcessing = true);
    int successCount = 0;

    for (final uid in _selectedUserIds.toList()) {
      final success = await ref.read(authNotifierProvider.notifier).deleteTargetUser(uid);
      if (success) {
        successCount++;
        _users.removeWhere((u) => u.uid == uid);
      }
    }

    if (mounted) {
      setState(() {
        _isBatchProcessing = false;
        _selectedUserIds.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$successCount dari $count akun berhasil dihapus dari cloud.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin ke clipboard.'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final currentAdminEmail = authState.email ?? 'Super Admin';
    final query = _searchController.text.trim().toLowerCase();

    final filteredUsers = _users.where((u) {
      final matchesQuery = query.isEmpty ||
          u.email.toLowerCase().contains(query) ||
          (u.displayName?.toLowerCase().contains(query) ?? false) ||
          u.uid.toLowerCase().contains(query);

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
    final totalOmset = premiumCount * 49000.0;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        titleSpacing: _isSelectionMode ? 0 : 16,
        elevation: 0,
        backgroundColor: _isSelectionMode
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
            : theme.colorScheme.surface,
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Batal Pilih',
                onPressed: _clearSelection,
              )
            : null,
        title: _isSelectionMode
            ? Text(
                '${_selectedUserIds.length} Pengguna Dipilih',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Super Admin',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
        actions: _isSelectionMode
            ? [
                TextButton.icon(
                  onPressed: () {
                    if (_selectedUserIds.length == filteredUsers.length) {
                      _clearSelection();
                    } else {
                      _selectAll(filteredUsers);
                    }
                  },
                  icon: Icon(
                    _selectedUserIds.length == filteredUsers.length
                        ? Icons.deselect_rounded
                        : Icons.select_all_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _selectedUserIds.length == filteredUsers.length ? 'Batal Semua' : 'Pilih Semua',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
              ]
            : [
                IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded),
                  tooltip: 'Segarkan Data',
                  onPressed: _isLoading ? null : _loadUsers,
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Color(0xFFE11D48)),
                  tooltip: 'Buka Nikahin',
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
      bottomNavigationBar: _isSelectionMode
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isBatchProcessing)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                            SizedBox(width: 8),
                            Text('Memproses tindakan masal...', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _isBatchProcessing ? null : () => _batchUpdateAccess(AccessLevel.premium),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.check_circle_rounded, size: 16),
                            label: const Text('Aktifkan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isBatchProcessing ? null : () => _batchUpdateAccess(AccessLevel.none),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFEA580C),
                              side: const BorderSide(color: Color(0xFFEA580C)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.lock_clock_rounded, size: 16),
                            label: const Text('Kunci', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: _isBatchProcessing ? null : _batchDelete,
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.delete_forever_rounded, size: 20),
                          tooltip: 'Hapus Pengguna Terpilih',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUsers,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              // 1. Admin Status Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                          child: const Icon(Icons.verified_user_rounded, color: Color(0xFFD97706), size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Admin Aktif',
                                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Flexible(
                                    child: Text(
                                      'Live Sync',
                                      style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                currentAdminEmail,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Bento Stats KPI Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildBentoKpiCard(
                              theme,
                              title: 'Total User',
                              value: '$totalCount',
                              subtitle: 'Akun Terdaftar',
                              icon: Icons.people_alt_rounded,
                              accentColor: theme.colorScheme.primary,
                              gradientColors: [
                                theme.colorScheme.primary.withValues(alpha: 0.08),
                                theme.colorScheme.primary.withValues(alpha: 0.02),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildBentoKpiCard(
                              theme,
                              title: 'Menunggu',
                              value: '$pendingCount',
                              subtitle: 'Perlu Aktivasi',
                              icon: Icons.hourglass_empty_rounded,
                              accentColor: const Color(0xFFEA580C),
                              isWarning: pendingCount > 0,
                              gradientColors: [
                                const Color(0xFFEA580C).withValues(alpha: 0.12),
                                const Color(0xFFEA580C).withValues(alpha: 0.02),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBentoKpiCard(
                              theme,
                              title: 'Lisensi Aktif',
                              value: '$premiumCount',
                              subtitle: 'Lifetime Member',
                              icon: Icons.workspace_premium_rounded,
                              accentColor: const Color(0xFF059669),
                              gradientColors: [
                                const Color(0xFF059669).withValues(alpha: 0.1),
                                const Color(0xFF059669).withValues(alpha: 0.02),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildBentoKpiCard(
                              theme,
                              title: 'Est. Omset',
                              value: CurrencyUtils.formatRupiahCompact(totalOmset),
                              subtitle: 'Total Penjualan',
                              icon: Icons.monetization_on_rounded,
                              accentColor: const Color(0xFFD97706),
                              gradientColors: [
                                const Color(0xFFD97706).withValues(alpha: 0.12),
                                const Color(0xFFD97706).withValues(alpha: 0.02),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Search & Filter Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama, email, atau UID...',
                          hintStyle: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                          prefixIcon: const Icon(Icons.search_rounded, size: 18),
                          suffixIcon: query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 16),
                                  onPressed: () => setState(() => _searchController.clear()),
                                )
                              : null,
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: [
                                  _buildFilterPill('ALL', 'Semua', totalCount, Icons.dashboard_rounded),
                                  const SizedBox(width: 6),
                                  _buildFilterPill('NONE', 'Menunggu', pendingCount, Icons.hourglass_top_rounded, color: const Color(0xFFEA580C)),
                                  const SizedBox(width: 6),
                                  _buildFilterPill('PREMIUM', 'Premium', premiumCount, Icons.verified_rounded, color: const Color(0xFF059669)),
                                  const SizedBox(width: 6),
                                  _buildFilterPill('ADMIN', 'Admin', adminCount, Icons.shield_rounded, color: const Color(0xFFD97706)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              if (_isSelectionMode) {
                                _clearSelection();
                              } else {
                                _selectAll(filteredUsers);
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: _isSelectionMode
                                    ? theme.colorScheme.primaryContainer
                                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _isSelectionMode
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isSelectionMode ? Icons.check_box_rounded : Icons.checklist_rounded,
                                    size: 16,
                                    color: _isSelectionMode
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isSelectionMode ? 'Batal' : 'Pilih',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: _isSelectionMode
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 12),
                ),
              ),

              // 4. Users List or States
              if (_isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          'Memuat data pengguna dari cloud...',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_errorMessage != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_off_rounded, color: theme.colorScheme.error, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _loadUsers,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (filteredUsers.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            query.isEmpty ? Icons.people_outline_rounded : Icons.search_off_rounded,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            query.isEmpty ? 'Belum Ada Pengguna' : 'Pengguna Tidak Ditemukan',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            query.isEmpty
                                ? 'Pengguna baru yang login dengan Google akan otomatis muncul di sini.'
                                : 'Coba kata kunci pencarian yang lain atau reset filter kategori.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 96),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final user = filteredUsers[index];
                        final isSelected = _selectedUserIds.contains(user.uid);
                        return _buildPremiumUserCard(context, user, isSelected: isSelected);
                      },
                      childCount: filteredUsers.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoKpiCard(
    ThemeData theme, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required List<Color> gradientColors,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isWarning ? accentColor.withValues(alpha: 0.5) : accentColor.withValues(alpha: 0.15),
          width: isWarning ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: accentColor),
              ),
              if (isWarning)
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'PERLU TINDAKAN',
                      style: TextStyle(color: Colors.white, fontSize: 7.5, fontWeight: FontWeight.w900),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9.5,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String filterVal, String label, int count, IconData icon, {Color? color}) {
    final theme = Theme.of(context);
    final isSelected = _selectedFilter == filterVal;
    final activeColor = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: () => setState(() => _selectedFilter = filterVal),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.25) : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumUserCard(BuildContext context, AppUserInfo user, {bool isSelected = false}) {
    final theme = Theme.of(context);
    final initial = user.email.isNotEmpty ? user.email[0].toUpperCase() : 'U';
    final isSuperAdminAccount = user.email.toLowerCase() == BusinessConfig.adminEmail.toLowerCase();

    Color statusColor;
    String statusTitle;
    IconData statusIcon;

    switch (user.accessLevel) {
      case AccessLevel.admin:
        statusColor = const Color(0xFFD97706);
        statusTitle = 'ADMIN';
        statusIcon = Icons.shield_rounded;
        break;
      case AccessLevel.premium:
        statusColor = const Color(0xFF059669);
        statusTitle = 'PREMIUM';
        statusIcon = Icons.verified_rounded;
        break;
      case AccessLevel.none:
        statusColor = const Color(0xFFEA580C);
        statusTitle = 'MENUNGGU';
        statusIcon = Icons.hourglass_top_rounded;
        break;
    }

    final isPending = user.accessLevel == AccessLevel.none;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: _isSelectionMode
            ? (isSuperAdminAccount ? null : () => _toggleSelection(user.uid))
            : null,
        onLongPress: isSuperAdminAccount ? null : () => _toggleSelection(user.uid),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : isPending
                      ? statusColor.withValues(alpha: 0.4)
                      : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: isSelected || isPending ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Color Stripe
                  Container(
                    width: 4,
                    color: isSelected ? theme.colorScheme.primary : statusColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Header Row
                          Row(
                            children: [
                              // Avatar / Checkbox Icon
                              GestureDetector(
                                onTap: isSuperAdminAccount ? null : () => _toggleSelection(user.uid),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: isSelected
                                      ? theme.colorScheme.primary
                                      : statusColor.withValues(alpha: 0.12),
                                  child: isSelected
                                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                                      : Text(
                                          initial,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.displayName ?? user.email.split('@').first,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    InkWell(
                                      onTap: () => _copyToClipboard(user.email, 'Email pengguna'),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              user.email,
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                color: theme.colorScheme.onSurfaceVariant,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.copy_rounded, size: 11, color: theme.colorScheme.outline),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(statusIcon, size: 11, color: statusColor),
                                    const SizedBox(width: 3),
                                    Text(
                                      statusTitle,
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        color: statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          const Divider(height: 1),
                          const SizedBox(height: 8),

                          // Metadata & Actions
                          Row(
                            children: [
                              // Left: Registration Date
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded, size: 11, color: theme.colorScheme.outline),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        WeddingDateUtils.formatShort(user.createdAt),
                                        style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Right: Action buttons
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (user.accessLevel == AccessLevel.none)
                                    FilledButton.icon(
                                      onPressed: () => _updateUserAccess(user, AccessLevel.premium),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(0xFF059669),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      icon: const Icon(Icons.check_circle_rounded, size: 13),
                                      label: const Text(
                                        'Aktifkan',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  else if (user.accessLevel == AccessLevel.premium)
                                    OutlinedButton(
                                      onPressed: () => _showRevokeDialog(user),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text('Cabut', style: TextStyle(fontSize: 11)),
                                    ),
                                  const SizedBox(width: 4),
                                  PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    icon: const Icon(Icons.more_vert_rounded, size: 18),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    onSelected: (val) {
                                      if (val == 'DELETE') {
                                        _showDeleteDialog(user);
                                      } else if (val == 'PREMIUM') {
                                        _updateUserAccess(user, AccessLevel.premium);
                                      } else if (val == 'NONE') {
                                        _updateUserAccess(user, AccessLevel.none);
                                      } else if (val == 'ADMIN') {
                                        _updateUserAccess(user, AccessLevel.admin);
                                      }
                                    },
                                    itemBuilder: (ctx) {
                                      return [
                                        const PopupMenuItem(
                                          value: 'PREMIUM',
                                          child: Row(
                                            children: [
                                              Icon(Icons.verified_rounded, size: 16, color: Color(0xFF059669)),
                                              SizedBox(width: 8),
                                              Text('Jadikan Premium Lifetime'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'NONE',
                                          child: Row(
                                            children: [
                                              Icon(Icons.lock_clock_rounded, size: 16, color: Color(0xFFEA580C)),
                                              SizedBox(width: 8),
                                              Text('Kunci (Menunggu Pembayaran)'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'ADMIN',
                                          child: Row(
                                            children: [
                                              Icon(Icons.shield_rounded, size: 16, color: Color(0xFFD97706)),
                                              SizedBox(width: 8),
                                              Text('Jadikan Super Admin'),
                                            ],
                                          ),
                                        ),
                                        if (!isSuperAdminAccount) ...[
                                          const PopupMenuDivider(),
                                          const PopupMenuItem(
                                            value: 'DELETE',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete_forever_rounded, size: 16, color: Colors.red),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Hapus Pengguna',
                                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ];
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRevokeDialog(AppUserInfo user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cabut Akses Premium?'),
        content: Text('Akun "${user.email}" akan dikembalikan ke status "Menunggu Verifikasi" dan tidak dapat mengakses fitur penuh sampai diaktifkan kembali.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _updateUserAccess(user, AccessLevel.none);
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Ya, Cabut Akses'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(AppUserInfo user) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            const Text('Hapus Pengguna?'),
          ],
        ),
        content: Text(
          'Akun "${user.email}" akan dihapus permanen dari Firestore cloud database. Pengguna tidak akan dapat mengakses aplikasi lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteUser(user);
            },
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            child: const Text('Ya, Hapus Permanen'),
          ),
        ],
      ),
    );
  }
}
