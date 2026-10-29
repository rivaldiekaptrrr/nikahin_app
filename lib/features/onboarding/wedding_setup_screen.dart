import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/local/preferences_manager.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/currency_utils.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/date_selector_button.dart';
import '../auth/presentation/auth_notifier.dart';
import '../../data/services/notification_service.dart';

/// Interactive 3-Step Setup Wizard berstandar Appllama High-Fidelity.
/// Memandu calon pengantin baru menyiapkan fondasi pernikahan dengan cepat (< 60 detik).
class WeddingSetupScreen extends ConsumerStatefulWidget {
  const WeddingSetupScreen({super.key});

  @override
  ConsumerState<WeddingSetupScreen> createState() => _WeddingSetupScreenState();
}

class _WeddingSetupScreenState extends ConsumerState<WeddingSetupScreen> {
  final PageController _pageController = PageController();
  final _step1FormKey = GlobalKey<FormState>();
  final _groomController = TextEditingController();
  final _brideController = TextEditingController();

  int _currentStep = 0;
  int _weddingDate = DateTime.now().add(const Duration(days: 180)).millisecondsSinceEpoch;
  double _budgetCap = 75000000.0;
  String _religionType = 'ISLAM';
  String _religionDetail = 'ISLAM';
  String _culturalGroom = 'MODERN';
  String _culturalBride = 'MODERN';
  bool _generateStarterPack = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _groomController.addListener(() => setState(() {}));
    _brideController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _groomController.dispose();
    _brideController.dispose();
    super.dispose();
  }

  int get _remainingDays {
    final target = DateTime.fromMillisecondsSinceEpoch(_weddingDate);
    final now = DateTime.now();
    return target.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  void _goToStep(int step) {
    HapticFeedback.lightImpact();
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onNextStep() {
    if (_currentStep == 0) {
      if (!_step1FormKey.currentState!.validate()) return;
      _goToStep(1);
    } else if (_currentStep == 1) {
      if (_remainingDays <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tanggal pernikahan harus di masa mendatang.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      _goToStep(2);
    } else {
      _saveAndFinish();
    }
  }

  void _onPrevStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  Future<void> _saveAndFinish() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      final id = UuidUtils.generateId();
      final profile = WeddingProfile(
        id: id,
        groomName: _groomController.text.trim().isEmpty ? 'Calon Pengantin' : _groomController.text.trim(),
        brideName: _brideController.text.trim().isEmpty ? 'Mempelai' : _brideController.text.trim(),
        weddingDate: _weddingDate,
        totalBudgetCap: _budgetCap,
        religionType: _religionType,
        religionDetail: _religionDetail,
        culturalPresetGroom: _culturalGroom,
        culturalPresetBride: _culturalBride,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      final repo = ref.read(weddingRepositoryProvider);
      await repo.createProfile(
        profile,
        seedDefaults: true,
        generateStarterExpenses: _generateStarterPack,
      );

      final currentUserId = ref.read(authNotifierProvider).userId;
      await AppPreferences.setUserProfileId(currentUserId, id);
      await AppPreferences.setActiveProfileId(id);
      ref.read(activeProfileIdProvider.notifier).state = id;

      if (_weddingDate > 0) {
        await ref.read(notificationServiceProvider).scheduleWeddingCountdownReminders(
              weddingDate: DateTime.fromMillisecondsSinceEpoch(_weddingDate),
              groomName: _groomController.text.trim(),
              brideName: _brideController.text.trim(),
            );
      }

      if (mounted) {
        context.go('/wedding/$id');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan profil pernikahan: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Setup Rencana Pernikahan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _onPrevStep,
                tooltip: 'Kembali',
              )
            : null,
        actions: [
          if (auth.isAdmin)
            IconButton(
              icon: const Icon(Icons.shield_rounded, color: Color(0xFFD97706)),
              tooltip: 'Buka Panel Super Admin',
              onPressed: () => context.push('/admin'),
            ),
          TextButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
            child: const Text('Keluar'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Column(
            children: [
              // Step text indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _stepTitle(_currentStep),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Langkah ${_currentStep + 1} dari 3',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Linear Progress Indicator with animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0.0,
                      end: (_currentStep + 1) / 3.0,
                    ),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        minHeight: 4,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1Identity(theme),
                  _buildStep2WeddingDate(theme),
                  _buildStep3BudgetAndConcept(theme),
                ],
              ),
            ),
            _buildBottomActionBar(theme),
          ],
        ),
      ),
    );
  }

  String _stepTitle(int step) {
    switch (step) {
      case 0:
        return '1. Identitas Pasangan';
      case 1:
        return '2. Tanggal Hari-H';
      case 2:
        return '3. Anggaran & Alur Dokumen';
      default:
        return '';
    }
  }

  // ==================== STEP 1: IDENTITAS PASANGAN ====================
  Widget _buildStep1Identity(ThemeData theme) {
    final groomName = _groomController.text.trim();
    final brideName = _brideController.text.trim();
    final displayCouple = (groomName.isEmpty && brideName.isEmpty)
        ? 'Nama Pengantin Pria & Wanita'
        : '${groomName.isEmpty ? "CPP" : groomName} & ${brideName.isEmpty ? "CPW" : brideName}';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Form(
        key: _step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Live Preview Bento Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayCouple,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Perjalanan indah kalian berdua dimulai dari sini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Siapa nama panggilan kalian berdua?',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Nama ini akan tampil di beranda dan buku panduan pernikahan.',
              style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 18),

            // Mempelai Pria
            TextFormField(
              controller: _groomController,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
                ValidationUtils.nameInputFormatter,
              ],
              decoration: InputDecoration(
                labelText: 'Nama Panggilan Mempelai Pria',
                hintText: 'Contoh: Rivaldi',
                prefixIcon: const Icon(Icons.male_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              validator: (v) => ValidationUtils.validateName(v, 'Nama CPP'),
            ),
            const SizedBox(height: 14),

            // Mempelai Wanita
            TextFormField(
              controller: _brideController,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
                ValidationUtils.nameInputFormatter,
              ],
              decoration: InputDecoration(
                labelText: 'Nama Panggilan Mempelai Wanita',
                hintText: 'Contoh: Alya',
                prefixIcon: const Icon(Icons.female_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              validator: (v) => ValidationUtils.validateName(v, 'Nama CPW'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== STEP 2: TANGGAL HARI-H ====================
  Widget _buildStep2WeddingDate(ThemeData theme) {
    final days = _remainingDays;
    final dateFormatted = DateFormat('EEEE, d MMMM yyyy', 'id_ID')
        .format(DateTime.fromMillisecondsSinceEpoch(_weddingDate));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Live Countdown Bento Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.secondary.withValues(alpha: 0.25),
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  days > 0 ? '$days Hari Lagi' : 'Hari Bahagia',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormatted,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Kapan hari pernikahan akan digelar?',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Hitung mundur dan daftar persiapan akan otomatis disesuaikan dengan tanggal ini.',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),

          // Date Selector Button
          DateSelectorButton(
            label: 'Pilih Tanggal Hari-H',
            selectedEpochMillis: _weddingDate,
            onDateSelected: (millis) => setState(() => _weddingDate = millis),
          ),
          const SizedBox(height: 16),

          // Quick Presets
          Text(
            'Pilihan Cepat Sisa Waktu:',
            style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDatePresetChip(label: '+3 Bulan', days: 90),
              _buildDatePresetChip(label: '+6 Bulan (Standar)', days: 180),
              _buildDatePresetChip(label: '+1 Tahun', days: 365),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePresetChip({required String label, required int days}) {
    final targetDate = DateTime.now().add(Duration(days: days));
    final isSelected = (_remainingDays - days).abs() <= 2;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        HapticFeedback.lightImpact();
        setState(() => _weddingDate = targetDate.millisecondsSinceEpoch);
      },
    );
  }

  // ==================== STEP 3: ANGGARAN & KONSEP ====================
  Widget _buildStep3BudgetAndConcept(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Target Anggaran Pernikahan',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Nikahin bisa menyiapkan contoh pembagian pos anggaran awal untuk membantumu.',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),

          // Quick Budget Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildBudgetChip(30000000, '30 Juta'),
              _buildBudgetChip(50000000, '50 Juta'),
              _buildBudgetChip(75000000, '75 Juta'),
              _buildBudgetChip(100000000, '100 Juta'),
              _buildBudgetChip(150000000, '150 Juta'),
            ],
          ),
          const SizedBox(height: 14),

          // Currency input field
          CurrencyTextField(
            labelText: 'Target Total Anggaran',
            initialValue: _budgetCap,
            onChanged: (val) => setState(() => _budgetCap = val),
          ),
          const SizedBox(height: 16),

          // Starter Allocation Preview Card & Switch
          if (_budgetCap > 0) ...[
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: SwitchListTile(
                value: _generateStarterPack,
                activeThumbColor: theme.colorScheme.primary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onChanged: (val) {
                  HapticFeedback.lightImpact();
                  setState(() => _generateStarterPack = val);
                },
                title: const Text(
                  'Buat Rincian Pos Anggaran Otomatis',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _generateStarterPack
                      ? 'Menyiapkan 7 pos biaya umum (seperti katering dan gedung) sebagai rancangan awal.'
                      : 'Mulai dari daftar kosong. Kamu bisa menambahkan pos pengeluaran sendiri nanti di menu Anggaran.',
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_generateStarterPack) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pie_chart_outline_rounded, size: 18, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Contoh Pembagian Pos Biaya:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildAllocationRow('Katering 35%', _budgetCap * 0.35),
                    _buildAllocationRow('Venue 20%', _budgetCap * 0.20),
                    _buildAllocationRow('Dekorasi 15%', _budgetCap * 0.15),
                    _buildAllocationRow('MUA 12%', _budgetCap * 0.12),
                    _buildAllocationRow('Dokumentasi 10%', _budgetCap * 0.10),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Semua nominal bebas kamu ubah atau sesuaikan kapan saja.',
                            style: TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              const SizedBox(height: 8),
            ],
          ],

          // Alur Pendaftaran Dokumen
          Text(
            'Instansi Pendaftaran Pernikahan',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Menentukan persiapan berkas legalitas nikah di menu Dokumen.',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildRegistrationChannelCard(
                  theme: theme,
                  title: 'KUA',
                  subtitle: 'Buku Nikah Muslim',
                  icon: Icons.menu_book_rounded,
                  isSelected: _religionType == 'ISLAM',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _religionType = 'ISLAM';
                      _religionDetail = 'ISLAM';
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildRegistrationChannelCard(
                  theme: theme,
                  title: 'Catatan Sipil',
                  subtitle: 'Akta Nikah Dukcapil',
                  icon: Icons.account_balance_rounded,
                  isSelected: _religionType == 'NON_ISLAM',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _religionType = 'NON_ISLAM';
                      _religionDetail = 'KRISTEN';
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Adat CPP
          DropdownButtonFormField<String>(
            initialValue: _culturalGroom,
            decoration: InputDecoration(
              labelText: 'Konsep Adat Mempelai Pria',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            items: CulturalPreset.values
                .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                .toList(),
            onChanged: (val) => setState(() => _culturalGroom = val ?? 'MODERN'),
          ),
          const SizedBox(height: 14),

          // Adat CPW
          DropdownButtonFormField<String>(
            initialValue: _culturalBride,
            decoration: InputDecoration(
              labelText: 'Konsep Adat Mempelai Wanita',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            items: CulturalPreset.values
                .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                .toList(),
            onChanged: (val) => setState(() => _culturalBride = val ?? 'MODERN'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBudgetChip(double amount, String label) {
    final isSelected = (_budgetCap - amount).abs() < 1000;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        HapticFeedback.lightImpact();
        setState(() => _budgetCap = amount);
      },
    );
  }

  Widget _buildAllocationRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5)),
          Text(
            CurrencyUtils.formatRupiahCompact(amount),
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationChannelCard({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant.withValues(alpha: 0.6);
    final bgColor = isSelected
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
        : theme.colorScheme.surface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== BOTTOM ACTION BAR ====================
  Widget _buildBottomActionBar(ThemeData theme) {
    final isLastStep = _currentStep == 2;
    const buttonHeight = 50.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Screen 1 (Step 0): Tombol Lanjut Dibentangkan Penuh Selebar Layar
            if (_currentStep == 0) ...[
              Expanded(
                child: SizedBox(
                  height: buttonHeight,
                  child: FilledButton(
                    onPressed: _onNextStep,
                    style: FilledButton.styleFrom(
                      fixedSize: const Size.fromHeight(buttonHeight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 1,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lanjut',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Screen 2 & 3: Tombol Kembali di Kiri
              SizedBox(
                height: buttonHeight,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _onPrevStep,
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size.fromHeight(buttonHeight),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
                    ),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Kembali',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Tombol Kanan: 'Lanjut' di Step 2, atau 'Rencanakan Pernikahan' di Langkah Terakhir
              Expanded(
                child: SizedBox(
                  height: buttonHeight,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _onNextStep,
                    style: FilledButton.styleFrom(
                      fixedSize: const Size.fromHeight(buttonHeight),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            _isLoading
                                ? 'Menyiapkan...'
                                : isLastStep
                                    ? 'Rencanakan Pernikahan'
                                    : 'Lanjut',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        else
                          Icon(
                            isLastStep ? Icons.auto_awesome_rounded : Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
