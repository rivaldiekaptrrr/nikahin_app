import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/currency_utils.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/widgets/error_state_view.dart';
import '../../shared/widgets/skeleton_loading.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';
import '../auth/presentation/widgets/demo_sticky_banner.dart';
import '../updater/presentation/update_notifier.dart';
import '../updater/presentation/widgets/update_dialog.dart';

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

            return StreamBuilder<List<WeddingTask>>(
              stream: repo.watchTasks(widget.profileId),
              builder: (context, tasksSnap) {
                final tasks = tasksSnap.data ?? [];

                return StreamBuilder<List<WeddingDocument>>(
                  stream: repo.watchDocuments(widget.profileId),
                  builder: (context, docsSnap) {
                    final docs = docsSnap.data ?? [];

                    return StreamBuilder<List<WeddingGuest>>(
                      stream: repo.watchGuests(widget.profileId),
                      builder: (context, guestsSnap) {
                        final guests = guestsSnap.data ?? [];

                        return StreamBuilder<List<WeddingVendor>>(
                          stream: repo.watchVendors(widget.profileId),
                          builder: (context, vendorsSnap) {
                            final vendors = vendorsSnap.data ?? [];

                            return StreamBuilder<List<WeddingSeserahan>>(
                              stream: repo.watchSeserahan(widget.profileId),
                              builder: (context, seserahanSnap) {
                                final seserahan = seserahanSnap.data ?? [];

                                return StreamBuilder<List<WeddingCommitteeMember>>(
                                  stream: repo.watchCommittee(widget.profileId),
                                  builder: (context, committeeSnap) {
                                    final committee = committeeSnap.data ?? [];

                                    if (profilesSnap.hasError ||
                                        expensesSnap.hasError ||
                                        tasksSnap.hasError ||
                                        docsSnap.hasError ||
                                        guestsSnap.hasError ||
                                        vendorsSnap.hasError ||
                                        seserahanSnap.hasError ||
                                        committeeSnap.hasError) {
                                      return Scaffold(
                                        appBar: AppBar(title: const Text('Dashboard Pernikahan')),
                                        body: ErrorStateView(
                                          errorMessage: 'Terjadi kendala saat memuat data dashboard',
                                          onRetry: () => setState(() {}),
                                        ),
                                      );
                                    }

                                    if (profilesSnap.connectionState == ConnectionState.waiting ||
                                        expensesSnap.connectionState == ConnectionState.waiting ||
                                        tasksSnap.connectionState == ConnectionState.waiting) {
                                      return Scaffold(
                                        appBar: AppBar(title: const Text('Dashboard Pernikahan')),
                                        body: const SkeletonListView(showHeader: true),
                                      );
                                    }

                                    return _buildDashboardContent(
                                      context: context,
                                      theme: theme,
                                      profile: profile,
                                      profiles: profiles,
                                      expenses: expenses,
                                      tasks: tasks,
                                      docs: docs,
                                      guests: guests,
                                      vendors: vendors,
                                      seserahan: seserahan,
                                      committee: committee,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
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
    required List<WeddingProfile> profiles,
    required List<WeddingExpense> expenses,
    required List<WeddingTask> tasks,
    required List<WeddingDocument> docs,
    required List<WeddingGuest> guests,
    required List<WeddingVendor> vendors,
    required List<WeddingSeserahan> seserahan,
    required List<WeddingCommitteeMember> committee,
  }) {
    // Computations matching reference ViewModel
    final totalBudgetCap = profile.totalBudgetCap > 0
        ? profile.totalBudgetCap
        : expenses.fold(0.0, (sum, e) => sum + e.totalEstimated);
    final totalPaid = expenses.fold(0.0, (sum, e) => sum + e.totalPaid);
    final budgetProgress = totalBudgetCap > 0 ? (totalPaid / totalBudgetCap).clamp(0.0, 1.0) : 0.0;
    final budgetPercentage = (budgetProgress * 100).round();

    final taskDoneCount = tasks.where((t) => t.isCompleted).length;
    final taskProgress = tasks.isNotEmpty ? (taskDoneCount / tasks.length).clamp(0.0, 1.0) : 0.0;

    final docDoneCount = docs.where((d) => d.isCompleted).length;
    final docProgress = docs.isNotEmpty ? (docDoneCount / docs.length).clamp(0.0, 1.0) : 0.0;

    final vendorLunasCount = expenses.where((e) => e.paymentStatus == 'FULLY_PAID' || (e.totalEstimated > 0 && e.totalPaid >= e.totalEstimated)).length;
    final totalExpenseCount = expenses.length;
    final vendorLunasProgress = totalExpenseCount > 0 ? (vendorLunasCount / totalExpenseCount).clamp(0.0, 1.0) : 0.0;

    // Last paid expense
    final paidExpenses = expenses.where((e) => e.totalPaid > 0).toList();
    final lastPaidExpense = paidExpenses.isNotEmpty ? paidExpenses.last : null;

    // Stats
    final totalGuests = guests.length;
    final contractedVendors = vendors.where((v) => v.status == 'KONTRAK' || v.status == 'SELESAI' || v.status == 'TANDA_JADI').length;
    final totalVendors = vendors.length;

    final readySeserahanItems = seserahan.where((s) => s.status == 'SIAP' || s.status == 'DIBELI').length;
    final totalSeserahanItems = seserahan.length;

    final uniformReadyCount = committee.where((c) => c.uniformStatus == 'SIAP_PAKAI').length;
    final totalCommitteeMembers = committee.length;

    // Upcoming tasks (top 5 incomplete)
    final upcomingTasks = tasks
        .where((t) => !t.isCompleted)
        .toList()
      ..sort((a, b) => (a.dueDate ?? 0).compareTo(b.dueDate ?? 0));
    final displayUpcomingTasks = upcomingTasks.take(5).toList();

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

            // 1. HERO COUNTDOWN (2x2 Span)
            _buildHeroCountdown(context, theme, profile, profiles),
            const SizedBox(height: 16),

            // 2. BENTO FINANCIAL SUMMARY CARD
            _buildFinancialSummaryCard(
              context,
              theme,
              totalPaid: totalPaid,
              totalBudgetCap: totalBudgetCap,
              budgetProgress: budgetProgress,
              budgetPercentage: budgetPercentage,
            ),
            const SizedBox(height: 16),

            // 3. BENTO QUICK ACTIONS (3 in 1 Row)
            _buildQuickActions(context, theme),
            const SizedBox(height: 16),

            // 4. BENTO PROGRESS GRID (2x1 Left, 1x1 Right)
            _buildProgressGrid(
              context,
              theme,
              taskProgress: taskProgress,
              docProgress: docProgress,
              vendorLunasCount: vendorLunasCount,
              totalExpenseCount: totalExpenseCount,
              vendorLunasProgress: vendorLunasProgress,
              lastPaidExpense: lastPaidExpense,
            ),
            const SizedBox(height: 16),

            // 5. BENTO STATS GRID (2x2)
            _buildStatsGrid(
              context,
              theme,
              totalGuests: totalGuests,
              contractedVendors: contractedVendors,
              totalVendors: totalVendors,
              readySeserahanItems: readySeserahanItems,
              totalSeserahanItems: totalSeserahanItems,
              uniformReadyCount: uniformReadyCount,
              totalCommitteeMembers: totalCommitteeMembers,
            ),
            const SizedBox(height: 24),

            // 6. BUDGET CATEGORIES SECTION
            if (categoryBudgets.isNotEmpty) ...[
              _buildCategoryBudgetsSection(context, theme, categoryBudgets),
              const SizedBox(height: 24),
            ],

            // 7. UPCOMING TASKS (Top 5)
            if (displayUpcomingTasks.isNotEmpty) ...[
              _buildUpcomingTasksSection(context, theme, displayUpcomingTasks),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== 1. HERO COUNTDOWN CARD ====================
  Widget _buildHeroCountdown(
    BuildContext context,
    ThemeData theme,
    WeddingProfile profile,
    List<WeddingProfile> profiles,
  ) {
    final days = WeddingDateUtils.daysUntil(profile.weddingDate);
    final daysString = days >= 0 ? '$days' : '${days.abs()}';
    final subText = days == 0 ? 'Hari Ini!' : (days > 0 ? 'Hari Lagi' : 'Hari Lalu');
    final formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now());

    final names = '${profile.groomName} & ${profile.brideName}'.trim().replaceAll(RegExp(r'^&|&$'), '').trim();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Top Bar: Date & Profile Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    formattedDate,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  constraints: const BoxConstraints(maxWidth: 160),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          names.isNotEmpty ? names : 'Rivaldi & Alya',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.favorite_rounded,
                        size: 14,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Centered Countdown
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  daysString,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onPrimaryContainer,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  subText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              WeddingDateUtils.formatFull(profile.weddingDate),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.75),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Romantic Quote
            if (profile.quoteEnabled && profile.quote != null && profile.quote!.isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '"${profile.quote}"',
                  textAlign: TextAlign.center,
                  style: _resolveQuoteStyle(profile).copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  TextStyle _resolveQuoteStyle(WeddingProfile profile) {
    double fontSize = 13.0;
    if (profile.quoteFontSize == 'KECIL') fontSize = 11.0;
    if (profile.quoteFontSize == 'BESAR') fontSize = 15.0;

    FontWeight fontWeight = FontWeight.normal;
    FontStyle fontStyle = FontStyle.normal;

    switch (profile.quoteFontStyle) {
      case 'BOLD':
        fontWeight = FontWeight.bold;
        break;
      case 'ITALIC':
        fontStyle = FontStyle.italic;
        break;
      case 'BOLD_ITALIC':
        fontWeight = FontWeight.bold;
        fontStyle = FontStyle.italic;
        break;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: 1.35,
    );
  }

  // ==================== 2. FINANCIAL SUMMARY CARD ====================
  Widget _buildFinancialSummaryCard(
    BuildContext context,
    ThemeData theme, {
    required double totalPaid,
    required double totalBudgetCap,
    required double budgetProgress,
    required int budgetPercentage,
  }) {
    final remainingBudget = (totalBudgetCap - totalPaid).clamp(0.0, double.infinity);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/wedding/${widget.profileId}/budget'),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // Left Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Anggaran',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyUtils.formatRupiah(totalPaid),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'dari ${CurrencyUtils.formatRupiah(totalBudgetCap)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: budgetProgress,
                        minHeight: 5,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            CurrencyUtils.formatRupiah(remainingBudget),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Sisa Anggaran',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Right Circular Radial Gauge (64x64)
              SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: budgetProgress,
                        strokeWidth: 6,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      ),
                    ),
                    Text(
                      '$budgetPercentage%',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
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
            label: 'Cek\nRundown',
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: bgColor,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fgColor, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: fgColor,
                  fontSize: 10.5,
                  height: 1.15,
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

  // ==================== 4. PROGRESS GRID ====================
  Widget _buildProgressGrid(
    BuildContext context,
    ThemeData theme, {
    required double taskProgress,
    required double docProgress,
    required int vendorLunasCount,
    required int totalExpenseCount,
    required double vendorLunasProgress,
    required WeddingExpense? lastPaidExpense,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Column (Tasks + Docs)
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _buildProgressCard(
                    context,
                    theme,
                    title: 'Tugas Selesai',
                    progress: taskProgress,
                    color: theme.colorScheme.primary,
                    onTap: () => context.go('/wedding/${widget.profileId}/tasks'),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildProgressCard(
                    context,
                    theme,
                    title: 'Berkas KUA',
                    progress: docProgress,
                    color: theme.colorScheme.tertiary,
                    onTap: () => context.go('/wedding/${widget.profileId}/documents'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Right Column (Tall Vendor Lunas Card)
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              color: theme.colorScheme.surface,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              child: InkWell(
                onTap: () => context.go('/wedding/${widget.profileId}/budget'),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 180),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF43A047),
                            size: 28,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Vendor Lunas',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$vendorLunasCount / $totalExpenseCount',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF43A047),
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: vendorLunasProgress,
                              minHeight: 5,
                              backgroundColor: const Color(0xFF43A047).withValues(alpha: 0.15),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF43A047)),
                            ),
                          ),
                        ],
                      ),
                      if (lastPaidExpense != null) ...[
                        const Divider(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terakhir Dibayar',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lastPaidExpense.title,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              CurrencyUtils.formatRupiah(lastPaidExpense.totalPaid),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    ThemeData theme, {
    required String title,
    required double progress,
    required Color color,
    required VoidCallback onTap,
  }) {
    final percentage = (progress * 100).round();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== 5. STATS GRID (2x2) ====================
  Widget _buildStatsGrid(
    BuildContext context,
    ThemeData theme, {
    required int totalGuests,
    required int contractedVendors,
    required int totalVendors,
    required int readySeserahanItems,
    required int totalSeserahanItems,
    required int uniformReadyCount,
    required int totalCommitteeMembers,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                theme,
                icon: Icons.groups_rounded,
                value: '$totalGuests',
                label: 'Tamu Diundang',
                onTap: () => context.go('/wedding/${widget.profileId}/guests'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                theme,
                icon: Icons.storefront_rounded,
                value: '$contractedVendors / $totalVendors',
                label: 'Vendor Deal',
                onTap: () => context.go('/wedding/${widget.profileId}/vendors'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                theme,
                icon: Icons.card_giftcard_rounded,
                value: '$readySeserahanItems / $totalSeserahanItems',
                label: 'Seserahan Siap',
                onTap: () => context.go('/wedding/${widget.profileId}/seserahan'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                theme,
                icon: Icons.checkroom_rounded,
                value: '$uniformReadyCount / $totalCommitteeMembers',
                label: 'Panitia Siap',
                onTap: () => context.go('/wedding/${widget.profileId}/committee'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 24),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== 6. BUDGET CATEGORIES ====================
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
              'Budget per Kategori',
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
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

  // ==================== 7. UPCOMING TASKS ====================
  Widget _buildUpcomingTasksSection(
    BuildContext context,
    ThemeData theme,
    List<WeddingTask> upcomingTasks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tugas Mendatang',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/wedding/${widget.profileId}/tasks'),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...upcomingTasks.map((task) {
          final picEnum = TaskPic.fromString(task.pic);
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: theme.colorScheme.surface,
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                onChanged: (val) {
                  ref.read(weddingRepositoryProvider).toggleTaskCompletion(task, val ?? false);
                },
              ),
              title: Text(
                task.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: task.dueDate != null
                  ? Text(
                      'Tenggat: ${WeddingDateUtils.formatShort(task.dueDate!)} • PIC: ${picEnum.label}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : Text(
                      'PIC: ${picEnum.label}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
              onTap: () => context.go('/wedding/${widget.profileId}/tasks'),
            ),
          );
        }),
      ],
    );
  }

  void _showGuideDialog(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Beranda Pernikahan',
      screenPurpose: 'Halaman utama untuk melihat rangkuman dan progres persiapan pernikahan Anda secara praktis.',
      features: const [
        WeddingGuideFeature(
          icon: Icons.timer_rounded,
          title: 'Countdown',
          description: 'Menghitung sisa hari menuju hari pernikahan bahagia Anda bersama pasangan.',
        ),
        WeddingGuideFeature(
          icon: Icons.format_quote_rounded,
          title: 'Quotes',
          description: 'Berikan kata-kata motivasimu atau pesan cinta romantis yang dapat disesuaikan di menu pengaturan.',
        ),
        WeddingGuideFeature(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Ringkasan Anggaran',
          description: 'Dapat memantau pengeluaran dan sisa anggaran langsung di beranda untuk memudahkanmu tanpa perlu ke menu anggaran.',
        ),
        WeddingGuideFeature(
          icon: Icons.bolt_rounded,
          title: 'Aksi Cepat & Progres',
          description: 'Pintasan langsung untuk mencatat biaya, kelola tamu, dan cek susunan acara, serta melihat progres tugas dan berkas KUA.',
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
