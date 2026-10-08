import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/currency_utils.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/utils/demo_guard.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/app_feedback.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/date_selector_button.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/error_state_view.dart';
import '../../shared/widgets/skeleton_loading.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';

class WeddingBudgetScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingBudgetScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingBudgetScreen> createState() => _WeddingBudgetScreenState();
}

class _WeddingBudgetScreenState extends ConsumerState<WeddingBudgetScreen> {
  String _selectedSourceFilter = 'SEMUA';

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(weddingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anggaran Pernikahan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showBudgetGuide(context),
          ),
        ],
      ),
      body: StreamBuilder<List<WeddingProfile>>(
        stream: repo.watchAllProfiles(),
        builder: (context, profileSnap) {
          final profiles = profileSnap.data ?? [];
          final profile = profiles.firstWhere(
            (p) => p.id == widget.profileId,
            orElse: () => WeddingProfile(
              id: widget.profileId,
              groomName: '',
              brideName: '',
              weddingDate: 0,
              createdAt: 0,
            ),
          );

          return StreamBuilder<List<WeddingExpense>>(
            stream: repo.watchExpenses(widget.profileId),
            builder: (context, expenseSnap) {
              if (profileSnap.hasError || expenseSnap.hasError) {
                return ErrorStateView(
                  errorMessage: (profileSnap.error ?? expenseSnap.error).toString(),
                  onRetry: () => setState(() {}),
                );
              }

              if (profileSnap.connectionState == ConnectionState.waiting ||
                  expenseSnap.connectionState == ConnectionState.waiting) {
                return const SkeletonListView(showHeader: true);
              }

              final allExpenses = expenseSnap.data ?? [];
              final filteredExpenses = _selectedSourceFilter == 'SEMUA'
                  ? allExpenses
                  : allExpenses.where((e) => e.paidBySource == _selectedSourceFilter).toList();

              final totalEstimated = allExpenses.fold(0.0, (acc, e) => acc + e.totalEstimated);
              final totalPaid = allExpenses.fold(0.0, (acc, e) => acc + e.totalPaid);
              final budgetCap = profile.totalBudgetCap > 0 ? profile.totalBudgetCap : totalEstimated;
              final remaining = budgetCap - totalPaid;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  // 1. Budget Summary Card
                  _buildSummaryCard(context, budgetCap, totalEstimated, totalPaid, remaining),
                  const SizedBox(height: 16),

                  // 2. Fund Source Filter Chips
                  _buildSourceFilterChips(),
                  const SizedBox(height: 16),

                  // 3. Expenses Grouped by Category
                  if (filteredExpenses.isEmpty)
                    _buildEmptyExpensesState(context)
                  else
                    ..._buildCategoryAccordions(context, filteredExpenses),

                  const SizedBox(height: 80),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    double budgetCap,
    double totalEstimated,
    double totalPaid,
    double remaining,
  ) {
    final theme = Theme.of(context);
    final progress = budgetCap > 0 ? (totalPaid / budgetCap).clamp(0.0, 1.0) : 0.0;

    return BentoCard(
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        colors: [
          theme.colorScheme.primaryContainer,
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Target Anggaran',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                CurrencyUtils.formatRupiah(budgetCap),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  label: 'Estimasi Biaya',
                  amount: totalEstimated,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  label: 'Sudah Dibayar',
                  amount: totalPaid,
                  color: theme.colorScheme.primary,
                  isBold: true,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  label: 'Sisa Dana',
                  amount: remaining > 0 ? remaining : 0,
                  color: remaining >= 0 ? const Color(0xFF2E7D32) : theme.colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).toInt()}% dari target terbayar',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required double amount,
    required Color color,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[700]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          CurrencyUtils.formatRupiahCompact(amount),
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSourceFilterChips() {
    final sources = [
      {'val': 'SEMUA', 'label': 'Semua Sumber'},
      {'val': 'BERSAMA', 'label': 'Dana Bersama'},
      {'val': 'TABUNGAN_CPP', 'label': 'Tabungan CPP'},
      {'val': 'TABUNGAN_CPW', 'label': 'Tabungan CPW'},
      {'val': 'ORTU_CPP', 'label': 'Ortu CPP'},
      {'val': 'ORTU_CPW', 'label': 'Ortu CPW'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sources.map((s) {
          final isSelected = _selectedSourceFilter == s['val'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(s['label']!),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedSourceFilter = s['val']!);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildCategoryAccordions(BuildContext context, List<WeddingExpense> expenses) {
    // Group expenses by category (support custom categories as well)
    final grouped = <String, List<WeddingExpense>>{};
    for (final exp in expenses) {
      final enumCat = ExpenseCategory.fromString(exp.category);
      final key = (enumCat != ExpenseCategory.lainnya) ? enumCat.value : exp.category;
      grouped.putIfAbsent(key, () => []).add(exp);
    }

    return grouped.entries.map((entry) {
      final categoryKey = entry.key;
      final categoryExpenses = entry.value;
      final catEstimated = categoryExpenses.fold(0.0, (acc, e) => acc + e.totalEstimated);
      final catPaid = categoryExpenses.fold(0.0, (acc, e) => acc + e.totalPaid);
      final catLabel = _getCategoryDisplayName(categoryKey);
      final progress = catEstimated > 0 ? (catPaid / catEstimated).clamp(0.0, 1.0) : 0.0;
      final percent = (progress * 100).round();
      final theme = Theme.of(context);

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: BentoCard(
          padding: EdgeInsets.zero,
          child: Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: false,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(categoryKey),
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      catLabel,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$percent%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    '${CurrencyUtils.formatRupiah(catPaid)} / ${CurrencyUtils.formatRupiah(catEstimated)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.5),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      color: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
              children: [
                const Divider(height: 1),
                ...categoryExpenses.map((expense) => _buildExpenseItem(context, expense)),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildExpenseItem(BuildContext context, WeddingExpense expense) {
    final theme = Theme.of(context);
    final remaining = (expense.totalEstimated - expense.totalPaid).clamp(0.0, double.infinity);

    // Status chip colors matching reference Kotlin ExpenseItem
    Color statusBg;
    Color statusFg;
    String statusLabel;
    if (expense.paymentStatus == 'FULLY_PAID' || (expense.totalEstimated > 0 && expense.totalPaid >= expense.totalEstimated)) {
      statusBg = const Color(0xFFE8F5E9);
      statusFg = const Color(0xFF2E7D32);
      statusLabel = 'Lunas';
    } else if (expense.paymentStatus == 'PARTIAL_DP' || expense.totalPaid > 0) {
      statusBg = const Color(0xFFFFF3E0);
      statusFg = const Color(0xFFE65100);
      statusLabel = 'Sebagian DP';
    } else {
      statusBg = theme.colorScheme.surfaceContainerHighest;
      statusFg = theme.colorScheme.onSurfaceVariant;
      statusLabel = 'Belum Bayar';
    }

    final subtext = (expense.paymentStatus == 'FULLY_PAID' || (expense.totalEstimated > 0 && expense.totalPaid >= expense.totalEstimated))
        ? 'Lunas'
        : (expense.totalPaid > 0
            ? 'Sisa ${CurrencyUtils.formatRupiah(remaining)}'
            : 'Belum bayar');

    final subtextColor = (expense.paymentStatus == 'FULLY_PAID' || (expense.totalEstimated > 0 && expense.totalPaid >= expense.totalEstimated))
        ? const Color(0xFF2E7D32)
        : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => _showPaymentTermsModal(context, expense),
      onLongPress: () => _showExpenseOptions(context, expense),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Column: Clean Title & Status Badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expense.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusFg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Right Column: Total Estimated & Sisa/Lunas info + Chevron
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CurrencyUtils.formatRupiah(expense.totalEstimated),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtext,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: subtextColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyExpensesState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long_outlined, size: 48, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Pos Anggaran',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Catat estimasi biaya venue, katering, MUA, dekorasi, dll.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 18),
            FilledButton.tonalIcon(
              onPressed: () => _showAddExpenseDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Pengeluaran Pertama'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== DIALOGS & MODALS ====================
  void _showAddExpenseDialog(BuildContext context, {WeddingExpense? expenseToEdit}) {
    if (!DemoGuard.checkAction(
      context,
      ref: ref,
      actionName: expenseToEdit != null ? 'Edit Pengeluaran' : 'Tambah Pos Anggaran',
    )) {
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddExpenseBottomSheet(
        profileId: widget.profileId,
        expenseToEdit: expenseToEdit,
      ),
    );
  }

  void _showExpenseOptions(BuildContext context, WeddingExpense expense) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Pengeluaran'),
              onTap: () {
                Navigator.pop(ctx);
                _showAddExpenseDialog(context, expenseToEdit: expense);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('Hapus Pengeluaran', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                if (!DemoGuard.checkAction(context, ref: ref, actionName: 'Hapus Pengeluaran')) {
                  return;
                }
                showDeleteConfirmDialog(
                  context: context,
                  itemName: expense.title,
                  onConfirm: () async {
                    final repo = ref.read(weddingRepositoryProvider);
                    await repo.deleteExpense(expense.expenseId);
                    if (context.mounted) {
                      AppFeedback.showUndo(
                        context,
                        message: '"${expense.title}" berhasil dihapus',
                        onUndo: () => repo.createExpense(expense),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentTermsModal(BuildContext context, WeddingExpense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ExpenseDetailBottomSheet(
        profileId: widget.profileId,
        initialExpense: expense,
      ),
    );
  }

  void _showBudgetGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Anggaran Pernikahan',
      screenPurpose:
          'Membantumu merencanakan alokasi dana, mencatat estimasi biaya vendor, dan memantau pembayaran agar keuangan pernikahan tetap aman dan teratur.',
      features: const [
        WeddingGuideFeature(
          icon: Icons.pie_chart_rounded,
          title: 'Target & Ringkasan Anggaran',
          description: 'Pantau target total biaya, jumlah yang sudah dibayar, serta sisa dana yang masih tersedia secara langsung.',
        ),
        WeddingGuideFeature(
          icon: Icons.category_rounded,
          title: 'Kategori Pengeluaran',
          description: 'Kelompokkan biaya seperti Gedung, Katering, MUA, atau buat kategori baru sendiri dengan ikon pilihanmu.',
        ),
        WeddingGuideFeature(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Sumber Dana Transparan',
          description: 'Atur siapa yang menanggung biaya (Dana Bersama, Tabungan CPP/CPW, atau Orang Tua) dan filter sesuai kebutuhan.',
        ),
        WeddingGuideFeature(
          icon: Icons.receipt_long_rounded,
          title: 'Histori & Catat Pembayaran',
          description: 'Ketuk salah satu pos pengeluaran untuk melihat rincian cicilan (DP atau Pelunasan) serta mencatat pembayaran baru.',
        ),
      ],
      proTip: 'Tekan tombol "+" untuk menambah pos pengeluaran baru, dan sisa dana akan terhitung otomatis saat ada pembayaran dicatat!',
    );
  }
}

// BottomSheet for adding / editing Expense
class _AddExpenseBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingExpense? expenseToEdit;

  const _AddExpenseBottomSheet({required this.profileId, this.expenseToEdit});

  @override
  ConsumerState<_AddExpenseBottomSheet> createState() => _AddExpenseBottomSheetState();
}

class _AddExpenseBottomSheetState extends ConsumerState<_AddExpenseBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _customCategoryController = TextEditingController();
  String _category = 'VENUE';
  String _paidBy = 'BERSAMA';
  double _estimatedAmount = 0.0;
  bool _isLoading = false;
  IconData _selectedIcon = Icons.auto_awesome_rounded;

  static const List<IconData> _availableCategoryIcons = [
    // Acara & Tempat
    Icons.celebration_rounded,
    Icons.apartment_rounded,
    Icons.nightlife_rounded,
    Icons.deck_rounded,
    Icons.church_rounded,
    Icons.mosque_rounded,
    Icons.temple_buddhist_rounded,
    Icons.temple_hindu_rounded,
    Icons.park_rounded,
    Icons.beach_access_rounded,
    Icons.home_rounded,
    Icons.theater_comedy_rounded,

    // Makanan & Minuman
    Icons.restaurant_rounded,
    Icons.local_dining_rounded,
    Icons.cake_rounded,
    Icons.wine_bar_rounded,
    Icons.local_bar_rounded,
    Icons.coffee_rounded,
    Icons.icecream_rounded,
    Icons.bakery_dining_rounded,

    // Foto, Video & Hiburan
    Icons.photo_camera_rounded,
    Icons.camera_alt_rounded,
    Icons.videocam_rounded,
    Icons.music_note_rounded,
    Icons.mic_rounded,
    Icons.speaker_rounded,
    Icons.auto_awesome_rounded,
    Icons.stars_rounded,

    // Busana, Kecantikan & Romansa
    Icons.brush_rounded,
    Icons.palette_rounded,
    Icons.spa_rounded,
    Icons.face_retouching_natural_rounded,
    Icons.diamond_rounded,
    Icons.favorite_rounded,
    Icons.favorite_border_rounded,
    Icons.volunteer_activism_rounded,

    // Undangan, Hadiah & Souvenir
    Icons.card_giftcard_rounded,
    Icons.mark_email_read_rounded,
    Icons.mail_rounded,
    Icons.inventory_2_rounded,
    Icons.print_rounded,
    Icons.badge_rounded,
    Icons.confirmation_number_rounded,
    Icons.storefront_rounded,

    // Bunga & Dekorasi
    Icons.local_florist_rounded,
    Icons.wb_sunny_rounded,
    Icons.emoji_events_rounded,
    Icons.light_rounded,
    Icons.filter_vintage_rounded,

    // Transportasi & Honeymoon
    Icons.flight_takeoff_rounded,
    Icons.local_airport_rounded,
    Icons.directions_car_rounded,
    Icons.drive_eta_rounded,
    Icons.train_rounded,
    Icons.hotel_rounded,
    Icons.luggage_rounded,

    // Keuangan, Keamanan & Lainnya
    Icons.receipt_long_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.savings_rounded,
    Icons.payments_rounded,
    Icons.security_rounded,
    Icons.groups_rounded,
    Icons.diversity_1_rounded,
    Icons.handshake_rounded,
    Icons.cleaning_services_rounded,
    Icons.category_rounded,
  ];

  void _openIconPickerModal(BuildContext context) {
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: theme.colorScheme.surface,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 460, maxWidth: 400),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih Ikon Kategori',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(dialogCtx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _availableCategoryIcons.length,
                    itemBuilder: (ctx, index) {
                      final iconData = _availableCategoryIcons[index];
                      final isSelected = _selectedIcon == iconData;

                      return Material(
                        color: isSelected
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setState(() {
                              _selectedIcon = iconData;
                            });
                            Navigator.pop(dialogCtx);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                iconData,
                                size: 24,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.expenseToEdit != null) {
      final e = widget.expenseToEdit!;
      _titleController.text = e.title;
      _notesController.text = e.notes ?? '';
      _paidBy = e.paidBySource;
      _estimatedAmount = e.totalEstimated;

      final isPredefined = ExpenseCategory.values.any((c) => c.value == e.category && c != ExpenseCategory.lainnya);
      if (isPredefined) {
        _category = e.category;
      } else {
        _category = 'LAINNYA';
        _customCategoryController.text = e.category == 'LAINNYA' ? '' : e.category;
        _selectedIcon = _getCategoryIcon(e.category);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.expenseToEdit != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 24,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? 'Edit Pengeluaran' : 'Tambah Pos Pengeluaran',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Category Selector
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: ExpenseCategory.values
                    .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val ?? 'VENUE'),
              ),
              const SizedBox(height: 14),

              // Dynamic Custom Category & Icon Selection when "Lainnya" is selected
              if (_category == 'LAINNYA') ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon selector button
                    Column(
                      children: [
                        InkWell(
                          onTap: () => _openIconPickerModal(context),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  _selectedIcon,
                                  size: 26,
                                  color: theme.colorScheme.primary,
                                ),
                                Positioned(
                                  right: 3,
                                  bottom: 3,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit_rounded,
                                      size: 10,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pilih Ikon',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Custom category name field
                    Expanded(
                      child: TextFormField(
                        controller: _customCategoryController,
                        inputFormatters: [LengthLimitingTextInputFormatter(40)],
                        maxLength: 40,
                        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                        decoration: const InputDecoration(
                          labelText: 'Nama Kategori Baru',
                          hintText: 'Cth: Photobooth, Honeymoon, Mobil Pengantin, dll',
                        ),
                        validator: (v) => _category == 'LAINNYA'
                            ? ValidationUtils.validateRequired(v, 'Nama kategori baru')
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],

              // Title
              TextFormField(
                controller: _titleController,
                inputFormatters: [LengthLimitingTextInputFormatter(60)],
                maxLength: 60,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(
                  labelText: 'Nama Pos / Kebutuhan',
                  hintText: 'Contoh: Sewa Gedung Resepsi',
                ),
                validator: (v) => ValidationUtils.validateRequired(v, 'Nama pos'),
              ),
              const SizedBox(height: 14),

              // Estimated Amount
              CurrencyTextField(
                labelText: 'Total Estimasi Biaya',
                initialValue: _estimatedAmount,
                isRequired: true,
                onChanged: (val) => _estimatedAmount = val,
              ),
              const SizedBox(height: 14),

              // Paid by Source
              DropdownButtonFormField<String>(
                initialValue: _paidBy,
                decoration: const InputDecoration(labelText: 'Sumber Dana'),
                items: PaidBySource.values
                    .map((s) => DropdownMenuItem(value: s.value, child: Text(s.label)))
                    .toList(),
                onChanged: (val) => setState(() => _paidBy = val ?? 'BERSAMA'),
              ),
              const SizedBox(height: 14),

              // Notes
              TextFormField(
                controller: _notesController,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'Catatan Tambahan (Opsional)',
                  hintText: 'Paket termasuk listrik & AC',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveExpense,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Pengeluaran'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(weddingRepositoryProvider);
      final categoryToSave = _category == 'LAINNYA'
          ? (_customCategoryController.text.trim().isNotEmpty
              ? _customCategoryController.text.trim()
              : 'Lainnya')
          : _category;

      if (widget.expenseToEdit != null) {
        final updated = widget.expenseToEdit!.copyWith(
          category: categoryToSave,
          title: _titleController.text.trim(),
          totalEstimated: _estimatedAmount,
          paidBySource: _paidBy,
          notes: _notesController.text.trim(),
        );
        await repo.updateExpense(updated);
        if (mounted) {
          AppFeedback.showSuccess(context, message: 'Pos anggaran berhasil diperbarui');
        }
      } else {
        final newExpense = WeddingExpense(
          expenseId: UuidUtils.generateId(),
          weddingProfileId: widget.profileId,
          category: categoryToSave,
          title: _titleController.text.trim(),
          totalEstimated: _estimatedAmount,
          totalPaid: 0.0,
          paidBySource: _paidBy,
          paymentStatus: 'UNPAID',
          notes: _notesController.text.trim(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        await repo.createExpense(newExpense);
        if (mounted) {
          AppFeedback.showSuccess(context, message: 'Pos anggaran berhasil ditambahkan');
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        AppFeedback.showError(context, message: 'Gagal menyimpan anggaran: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// Rich 2-Tier Detail & Payment Modal Bottom Sheet matching reference Kotlin ExpenseDetailContent
class _ExpenseDetailBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingExpense initialExpense;

  const _ExpenseDetailBottomSheet({
    required this.profileId,
    required this.initialExpense,
  });

  @override
  ConsumerState<_ExpenseDetailBottomSheet> createState() => _ExpenseDetailBottomSheetState();
}

class _ExpenseDetailBottomSheetState extends ConsumerState<_ExpenseDetailBottomSheet> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(weddingRepositoryProvider);

    return StreamBuilder<List<WeddingExpense>>(
      stream: repo.watchExpenses(widget.profileId),
      builder: (context, expSnapshot) {
        final expenses = expSnapshot.data ?? [];
        final expense = expenses.firstWhere(
          (e) => e.expenseId == widget.initialExpense.expenseId,
          orElse: () => widget.initialExpense,
        );

        final catLabel = _getCategoryDisplayName(expense.category);
        final sourceLabel = PaidBySource.fromString(expense.paidBySource).label;
        final remaining = (expense.totalEstimated - expense.totalPaid).clamp(0.0, double.infinity);
        final progress = expense.totalEstimated > 0
            ? (expense.totalPaid / expense.totalEstimated).clamp(0.0, 1.0)
            : 0.0;
        final percentage = (progress * 100).round();

        // Status chip colors matching Kotlin
        Color statusBg;
        Color statusFg;
        String statusLabel;
        if (expense.paymentStatus == 'FULLY_PAID' || (expense.totalEstimated > 0 && expense.totalPaid >= expense.totalEstimated)) {
          statusBg = const Color(0xFFE8F5E9);
          statusFg = const Color(0xFF2E7D32);
          statusLabel = 'Lunas';
        } else if (expense.paymentStatus == 'PARTIAL_DP' || expense.totalPaid > 0) {
          statusBg = const Color(0xFFFFF3E0);
          statusFg = const Color(0xFFE65100);
          statusLabel = 'DP / Sebagian';
        } else {
          statusBg = theme.colorScheme.surfaceContainerHighest;
          statusFg = theme.colorScheme.onSurfaceVariant;
          statusLabel = 'Belum Bayar';
        }

        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expense.title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Kategori: $catLabel • Ditanggung: $sourceLabel',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusFg,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Financial Overview Card (Spacious 2-Tier Layout)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tier 1: Total Estimasi Biaya
                            Text(
                              'Total Estimasi Biaya',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyUtils.formatRupiah(expense.totalEstimated),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Divider(
                                height: 1,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                              ),
                            ),

                            // Tier 2: Terbayar vs Sisa Tagihan (2 Spacious Columns)
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sudah Terbayar',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        CurrencyUtils.formatRupiah(expense.totalPaid),
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2E7D32),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Sisa Tagihan',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        CurrencyUtils.formatRupiah(remaining),
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: remaining > 0 ? const Color(0xFFE65100) : theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Progress Bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progres Pembayaran',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '$percentage%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Sumber Dana Tag
                            Row(
                              children: [
                                Text(
                                  'Sumber Dana: ',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    sourceLabel,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Catatan (opsional)
                      if (expense.notes != null && expense.notes!.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Catatan:',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(expense.notes!, style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Histori Pembayaran Section
                      StreamBuilder<List<WeddingPaymentTerm>>(
                        stream: repo.watchPaymentTerms(expense.expenseId),
                        builder: (context, termsSnap) {
                          final terms = termsSnap.data ?? [];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Histori Pembayaran',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (terms.isNotEmpty)
                                    Text(
                                      '${terms.length} Pembayaran',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Kotak Container Histori Pembayaran dengan Scroll Internal
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                                  ),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: terms.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Center(
                                          child: Text(
                                            'Belum ada catatan pembayaran / cicilan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      )
                                    : ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxHeight: 200,
                                        ),
                                        child: Scrollbar(
                                          thumbVisibility: terms.length > 2,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics: const ClampingScrollPhysics(),
                                            itemCount: terms.length,
                                            separatorBuilder: (_, _) => const SizedBox(height: 8),
                                            itemBuilder: (context, index) {
                                              final term = terms[index];
                                              final isPaid = term.isPaid;
                                              final dateStr = WeddingDateUtils.formatShort(term.paidDate ?? term.dueDate);

                                              return Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme.surface,
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            term.termName,
                                                            style: theme.textTheme.bodyMedium?.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 2),
                                                          Text(
                                                            isPaid ? 'Dibayar: $dateStr' : 'Tenggat: $dateStr',
                                                            style: theme.textTheme.labelSmall?.copyWith(
                                                              color: theme.colorScheme.onSurfaceVariant,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          CurrencyUtils.formatRupiah(term.amount),
                                                          style: theme.textTheme.bodyMedium?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color: isPaid ? const Color(0xFF2E7D32) : theme.colorScheme.onSurface,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: isPaid ? const Color(0xFFE8F5E9) : theme.colorScheme.surfaceContainerHighest,
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: Text(
                                                            isPaid ? 'Lunas' : 'Tenggat',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w600,
                                                              color: isPaid ? const Color(0xFF2E7D32) : theme.colorScheme.onSurfaceVariant,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    IconButton(
                                                      icon: Icon(Icons.delete_outline_rounded, size: 20, color: theme.colorScheme.error),
                                                      visualDensity: VisualDensity.compact,
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                                      onPressed: () {
                                                        showDeleteConfirmDialog(
                                                          context: context,
                                                          itemName: term.termName,
                                                          message: 'Apakah Anda yakin ingin menghapus pembayaran "${term.termName}" sebesar ${CurrencyUtils.formatRupiah(term.amount)}?',
                                                          onConfirm: () async {
                                                            await repo.removePaymentTerm(term: term, expense: expense);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Bottom Action Buttons
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Primary: Catat Pembayaran
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.payment_rounded, size: 20),
                        label: const Text('Catat Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => _showAddPaymentModal(context, ref, expense),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Secondary: Edit & Hapus
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit Data'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => _AddExpenseBottomSheet(
                                  profileId: widget.profileId,
                                  expenseToEdit: expense,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.delete_outline_rounded, size: 18),
                            label: const Text('Hapus'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                              side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              showDeleteConfirmDialog(
                                context: context,
                                itemName: expense.title,
                                onConfirm: () async {
                                  await repo.deleteExpense(expense.expenseId);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddPaymentModal(BuildContext context, WidgetRef ref, WeddingExpense expense) {
    showDialog(
      context: context,
      builder: (ctx) => _AddPaymentRecordDialog(expense: expense),
    );
  }
}

// Dialog for recording payments directly
class _AddPaymentRecordDialog extends ConsumerStatefulWidget {
  final WeddingExpense expense;

  const _AddPaymentRecordDialog({required this.expense});

  @override
  ConsumerState<_AddPaymentRecordDialog> createState() => _AddPaymentRecordDialogState();
}

class _AddPaymentRecordDialogState extends ConsumerState<_AddPaymentRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _termNameController;
  double _amount = 0.0;
  int _selectedDate = DateTime.now().millisecondsSinceEpoch;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final remaining = (widget.expense.totalEstimated - widget.expense.totalPaid).clamp(0.0, double.infinity);
    _amount = remaining > 0 ? remaining : 0.0;
    _termNameController = TextEditingController(
      text: widget.expense.totalPaid == 0 ? 'DP 1' : 'Pelunasan',
    );
  }

  @override
  void dispose() {
    _termNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Catat Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _termNameController,
                inputFormatters: [LengthLimitingTextInputFormatter(40)],
                maxLength: 40,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(
                  labelText: 'Jenis Bayar (DP 1, Pelunasan, dll)',
                  hintText: 'Cth: DP 1, DP 2, Pelunasan',
                ),
                validator: (v) => ValidationUtils.validateRequired(v, 'Jenis bayar'),
              ),
              const SizedBox(height: 14),
              CurrencyTextField(
                labelText: 'Nominal Pembayaran (Rp)',
                initialValue: _amount,
                onChanged: (val) => _amount = val,
              ),
              const SizedBox(height: 14),
              DateSelectorButton(
                label: 'Tanggal Bayar',
                selectedEpochMillis: _selectedDate,
                onDateSelected: (millis) => setState(() => _selectedDate = millis),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submitPayment,
          child: _isLoading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Simpan'),
        ),
      ],
    );
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal pembayaran harus lebih dari 0')),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      await ref.read(weddingRepositoryProvider).recordPayment(
        expense: widget.expense,
        termName: _termNameController.text.trim(),
        amount: _amount,
        dueDate: _selectedDate,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pembayaran berhasil dicatat!')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

String _getCategoryDisplayName(String key) {
  final enumCat = ExpenseCategory.fromString(key);
  if (enumCat != ExpenseCategory.lainnya) {
    return enumCat.label;
  }
  if (key.toUpperCase() == 'LAINNYA') {
    return 'Lainnya';
  }
  return key;
}

IconData _getCategoryIcon(String key) {
  final upper = key.toUpperCase().trim();
  switch (upper) {
    case 'VENUE':
    case 'GEDUNG':
      return Icons.apartment_rounded;
    case 'CATERING':
    case 'KATERING':
      return Icons.restaurant_rounded;
    case 'DECOR':
    case 'DEKORASI':
      return Icons.celebration_rounded;
    case 'MUA':
    case 'BUSANA':
    case 'MAKEUP':
      return Icons.brush_rounded;
    case 'DOKUMENTASI':
    case 'FOTO':
    case 'VIDEO':
    case 'PHOTOGRAPHY':
      return Icons.photo_camera_rounded;
    case 'SESERAHAN':
    case 'MAHAR':
      return Icons.card_giftcard_rounded;
    case 'UNDANGAN':
    case 'SOUVENIR':
      return Icons.mark_email_read_rounded;
    case 'HONEYMOON':
    case 'BULAN MADU':
    case 'FLIGHT':
      return Icons.flight_takeoff_rounded;
    case 'PHOTOBOOTH':
      return Icons.camera_alt_rounded;
    case 'MUSIK':
    case 'BAND':
    case 'MUSIC':
    case 'ENTERTAINMENT':
      return Icons.music_note_rounded;
    case 'CINCIN':
    case 'PERHIASAN':
    case 'RING':
      return Icons.diamond_rounded;
    case 'KUE':
    case 'CAKE':
      return Icons.cake_rounded;
    case 'MOBIL':
    case 'TRANSPORT':
    case 'MOBIL PENGANTIN':
      return Icons.directions_car_rounded;
    case 'BUNGA':
    case 'HANDBOUQUET':
      return Icons.local_florist_rounded;
    case 'HOTEL':
    case 'AKOMODASI':
      return Icons.hotel_rounded;
    case 'SPA':
    case 'PERAWATAN':
      return Icons.spa_rounded;
    case 'SERAGAM':
      return Icons.palette_rounded;
    case 'MC':
    case 'SOUND':
      return Icons.mic_rounded;
    case 'KEAMANAN':
    case 'PARKIR':
      return Icons.security_rounded;
    case 'KONSUMSI':
    case 'SNACK':
      return Icons.local_dining_rounded;
    case 'CETAK':
    case 'BUKU TAMU':
      return Icons.print_rounded;
    case 'ADAT':
    case 'IBADAH':
      return Icons.church_rounded;
    case 'PESTA':
    case 'AFTER PARTY':
      return Icons.celebration_rounded;
    default:
      return Icons.receipt_long_rounded;
  }
}

