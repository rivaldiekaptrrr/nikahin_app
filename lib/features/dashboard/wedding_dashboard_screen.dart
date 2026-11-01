import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/config/platform_config.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/widgets/error_state_view.dart';
import '../../shared/widgets/skeleton_loading.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';
import '../updater/presentation/update_notifier.dart';
import '../updater/presentation/widgets/update_dialog.dart';
import 'presentation/widgets/dashboard_bento_snapshots.dart';
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
    if (!AppPlatformConfig.isApkUpdaterAvailable) return;
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
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: const Text('Dashboard Pernikahan'),
                ),
                body: ErrorStateView(
                  errorMessage: 'Terjadi kendala saat memuat data dashboard',
                  onRetry: () => setState(() {}),
                ),
              );
            }

            if (profilesSnap.connectionState == ConnectionState.waiting ||
                expensesSnap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: const Text('Dashboard Pernikahan'),
                ),
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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

            // 4. BENTO SNAPSHOTS KESIAPAN PERSIAPAN (2x2 Grid)
            DashboardBentoSnapshots(profileId: widget.profileId),
            const SizedBox(height: 24),
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

  void _showGuideDialog(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Beranda Pernikahan',
      screenPurpose: 'Pusat informasi utama untuk memantau ringkasan dan perkembangan persiapan pernikahanmu secara praktis.',
      features: const [
        WeddingGuideFeature(
          icon: Icons.timer_rounded,
          title: 'Hitung Mundur & Kalender',
          description: 'Melihat sisa hari menuju hari pernikahan bahagiamu dan mengecek agenda harian.',
        ),
        WeddingGuideFeature(
          icon: Icons.format_quote_rounded,
          title: 'Pesan Cinta & Doa',
          description: 'Tampilkan kata mutiara romantis atau doa bersama yang bisa kamu ubah di menu pengaturan.',
        ),
        WeddingGuideFeature(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Kesehatan Anggaran',
          description: 'Pantau total pengeluaran, status lunas atau DP, dan sisa anggaran langsung dari beranda.',
        ),
        WeddingGuideFeature(
          icon: Icons.dashboard_customize_rounded,
          title: 'Kilas Kesiapan Acara',
          description: 'Pantau tamu undangan, daftar tugas, berkas KUA, hingga vendor pernikahan dalam satu tampilan bento yang praktis.',
        ),
      ],
    );
  }
}
