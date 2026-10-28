import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/currency_utils.dart';
import '../../shared/widgets/error_state_view.dart';
import '../../shared/widgets/skeleton_loading.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';
import '../auth/presentation/widgets/demo_sticky_banner.dart';
import '../updater/presentation/update_notifier.dart';
import '../updater/presentation/widgets/update_dialog.dart';
import 'presentation/widgets/dashboard_budget_progress_ring.dart';
import 'presentation/widgets/dashboard_dday_hero_card.dart';

class WeddingDashboardScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingDashboardScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingDashboardScreen> createState() => _WeddingDashboardScreenState();
}

class _WeddingDashboardScreenState extends ConsumerState<WeddingDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUpdateSilently();
    });
  }

  Future<void> _checkUpdateSilently() async {
    try {
      final release = await ref
          .read(updateNotifierProvider.notifier)
          .checkForUpdate(silent: true);
      if (release != null && mounted) {
        UpdateDialog.show(context, release: release);
      }
    } catch (_) {}
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(weddingRepositoryProvider);

    return StreamBuilder<List<WeddingProfile>>(
      stream: repo.watchAllProfiles(),
      builder: (context, profilesSnap) {
        final profiles = profilesSnap.data ?? [];
        final profile = profiles.firstWhere(
          (p) => p.id == widget.profileId,
          orElse: () => profiles.isNotEmpty
              ? profiles.first
              : WeddingProfile(
                  id: widget.profileId,
                  groomName: 'Calon Pengantin',
                  brideName: 'Mempelai',
                  weddingDate: DateTime.now().add(const Duration(days: 90)).millisecondsSinceEpoch,
                  totalBudgetCap: 50000000,
                  religionType: 'ISLAM',
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
        );

        return StreamBuilder<List<WeddingExpense>>(
          stream: repo.watchExpenses(widget.profileId),
          builder: (context, expensesSnap) {
            final expenses = expensesSnap.data ?? [];

            if (profilesSnap.hasError || expensesSnap.hasError) {
              return Scaffold(
                appBar: AppBar(title: const Text('Dashboard Pernikahan')),
                body: ErrorStateView(
                  errorMessage: 'Terjadi kendala saat memuat data dashboard',
                  onRetry: () => setState(() {}),
                ),
              );
            }

            if (profilesSnap.connectionState == ConnectionState.waiting ||
                expensesSnap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(title: const Text('Dashboard Pernikahan')),
                body: const SkeletonListView(showHeader: true),
              );
            }

            return _buildDashboardContent(
              context: context,
              theme: theme,
              profile: profile,
              expenses: expenses,
            );
          },
        );
      },
    );
  }

  Widget _buildDashboardContent({
    required BuildContext context,
    required ThemeData theme,
    required WeddingProfile profile,
    required List<WeddingExpense> expenses,
  }) {
    // Computations matching reference ViewModel
    final totalBudgetCap = profile.totalBudgetCap > 0
        ? profile.totalBudgetCap
        : expenses.fold(0.0, (sum, e) => sum + e.totalEstimated);
    final totalPaid = expenses.fold(0.0, (sum, e) => sum + e.totalPaid);

    // Grouped category budgets
    final categoryMap = <String, _CategoryProgress>{};
    for (final exp in expenses) {
      final catEnum = ExpenseCategory.fromString(exp.category);
      final key = catEnum.value;
      if (!categoryMap.containsKey(key)) {
        categoryMap[key] = _CategoryProgress(
          categoryKey: key,
          categoryName: catEnum.label,
          iconName: key.toLowerCase(),
          totalEstimated: 0.0,
          totalPaid: 0.0,
        );
      }
      categoryMap[key]!.totalEstimated += exp.totalEstimated;
      categoryMap[key]!.totalPaid += exp.totalPaid;
    }
    final categoryBudgets = categoryMap.values.toList()
      ..sort((a, b) => b.totalEstimated.compareTo(a.totalEstimated));

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text(
          'Beranda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showGuideDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/wedding/${widget.profileId}/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(syncManagerProvider).pullAll();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 0. DEMO MODE STICKY BANNER
            const DemoStickyBanner(),

            // 1. HERO COUNTDOWN (Modular Component)
            DashboardDDayHeroCard(
              profileId: widget.profileId,
              profile: profile,
            ),
            const SizedBox(height: 16),

            // 2. FINANCIAL SUMMARY & RADIAL PROGRESS RING (Appllama Benchmark)
            DashboardBudgetProgressRing(
              profileId: widget.profileId,
              totalBudgetCap: totalBudgetCap,
              totalEstimated: expenses.fold(0.0, (sum, e) => sum + e.totalEstimated),
              totalPaid: totalPaid,
            ),
            const SizedBox(height: 16),

            // 3. BENTO QUICK ACTIONS (3 in 1 Row)
            _buildQuickActions(context, theme),
            const SizedBox(height: 20),

            // 4. BUDGET CATEGORIES SECTION
            if (categoryBudgets.isNotEmpty) ...[
              _buildCategoryBudgetsSection(context, theme, categoryBudgets),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== 3. QUICK ACTIONS (3 in 1 Row) ====================
  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            theme,
            label: 'Catat\nPengeluaran',
            icon: Icons.add_rounded,
            isPrimary: true,
            onTap: () => context.go('/wedding/${widget.profileId}/budget'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            context,
            theme,
            label: 'Kelola\nTamu',
            icon: Icons.people_rounded,
            isPrimary: false,
            onTap: () => context.go('/wedding/${widget.profileId}/guests'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            context,
            theme,
            label: 'Lihat\nSusunan Acara',
            icon: Icons.event_note_rounded,
            isPrimary: false,
            onTap: () => context.go('/wedding/${widget.profileId}/rundown'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    ThemeData theme, {
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    final bgColor = isPrimary ? theme.colorScheme.primary : theme.colorScheme.surface;
    final fgColor = isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary;
    final textColor = isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isPrimary
              ? Colors.transparent
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
          width: 1,
        ),
      ),
      color: bgColor,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fgColor, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  fontSize: 11,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== 4. BUDGET CATEGORIES ====================
  Widget _buildCategoryBudgetsSection(
    BuildContext context,
    ThemeData theme,
    List<_CategoryProgress> categoryBudgets,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Anggaran per Kategori',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/wedding/${widget.profileId}/budget'),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...categoryBudgets.map((cat) {
          final progress = cat.totalEstimated > 0
              ? (cat.totalPaid / cat.totalEstimated).clamp(0.0, 1.0)
              : 0.0;
          final percentage = (progress * 100).round();

          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
                width: 1,
              ),
            ),
            color: theme.colorScheme.surface,
            child: InkWell(
              onTap: () => context.go('/wedding/${widget.profileId}/budget'),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _getCategoryIcon(cat.iconName),
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cat.categoryName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$percentage%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${CurrencyUtils.formatRupiah(cat.totalPaid)} / ${CurrencyUtils.formatRupiah(cat.totalEstimated)}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'apartment':
      case 'venue':
        return Icons.apartment_rounded;
      case 'restaurant':
      case 'catering':
        return Icons.restaurant_rounded;
      case 'brush':
      case 'decor':
        return Icons.brush_rounded;
      case 'face':
      case 'mua':
        return Icons.face_retouching_natural_rounded;
      case 'checkroom':
      case 'busana':
        return Icons.checkroom_rounded;
      case 'camera':
      case 'dokumentasi':
        return Icons.camera_alt_rounded;
      case 'email':
      case 'undangan':
        return Icons.email_rounded;
      case 'giftcard':
      case 'seserahan':
        return Icons.card_giftcard_rounded;
      case 'redeem':
      case 'souvenir':
        return Icons.redeem_rounded;
      case 'car':
      case 'transportasi':
        return Icons.directions_car_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  void _showGuideDialog(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Beranda Pernikahan',
      screenPurpose: 'Pusat informasi utama untuk memantau ringkasan dan perkembangan persiapan pernikahanmu secara praktis.',
      features: const [
        WeddingGuideFeature(
          icon: Icons.timer_rounded,
          title: 'Hitung Mundur',
          description: 'Melihat sisa hari menuju hari pernikahan bahagiamu bersama pasangan.',
        ),
        WeddingGuideFeature(
          icon: Icons.format_quote_rounded,
          title: 'Pesan Cinta & Doa',
          description: 'Tampilkan kata mutiara romantis atau doa bersama yang bisa kamu ubah di menu pengaturan.',
        ),
        WeddingGuideFeature(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Ringkasan Anggaran',
          description: 'Pantau total pengeluaran dan sisa anggaran langsung dari beranda tanpa harus berpindah menu.',
        ),
        WeddingGuideFeature(
          icon: Icons.bolt_rounded,
          title: 'Aksi Cepat & Kategori',
          description: 'Pintasan langsung untuk mencatat biaya, kelola tamu, dan mengecek susunan acara.',
        ),
      ],
    );
  }
}

class _CategoryProgress {
  final String categoryKey;
  final String categoryName;
  final String iconName;
  double totalEstimated;
  double totalPaid;

  _CategoryProgress({
    required this.categoryKey,
    required this.categoryName,
    required this.iconName,
    required this.totalEstimated,
    required this.totalPaid,
  });
}
