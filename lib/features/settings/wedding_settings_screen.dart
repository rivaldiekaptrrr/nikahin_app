import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/local/preferences_manager.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/export_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/date_selector_button.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';
import '../../ui/theme/theme_controller.dart';

class WeddingSettingsScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingSettingsScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingSettingsScreen> createState() => _WeddingSettingsScreenState();
}

class _WeddingSettingsScreenState extends ConsumerState<WeddingSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groomController = TextEditingController();
  final _brideController = TextEditingController();
  final _quoteController = TextEditingController();
  int _weddingDate = 0;
  double _budgetCap = 0.0;
  String _culturalGroom = 'MODERN';
  String _culturalBride = 'MODERN';
  bool _quoteEnabled = true;
  String _quoteFontSize = 'SEDANG';
  String _quoteFontStyle = 'ITALIC';
  bool _dailyReminderEnabled = true;
  bool _biometricEnabled = false;
  bool _isCheckingUpdate = false;
  bool _isInit = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final daily = await AppPreferences.isDailyReminderEnabled();
    final bio = await AppPreferences.isBiometricEnabled();
    if (mounted) {
      setState(() {
        _dailyReminderEnabled = daily;
        _biometricEnabled = bio;
      });
    }
  }

  void _initFields(WeddingProfile p) {
    if (_isInit) return;
    _groomController.text = p.groomName;
    _brideController.text = p.brideName;
    _quoteController.text = p.quote ?? '';
    _weddingDate = p.weddingDate;
    _budgetCap = p.totalBudgetCap;
    _culturalGroom = p.culturalPresetGroom ?? 'MODERN';
    _culturalBride = p.culturalPresetBride ?? 'MODERN';
    _quoteEnabled = p.quoteEnabled;
    _quoteFontSize = p.quoteFontSize;
    _quoteFontStyle = p.quoteFontStyle;
    _isInit = true;
  }

  @override
  void dispose() {
    _groomController.dispose();
    _brideController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(weddingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Panduan Fitur',
            onPressed: () => _showSettingsGuide(context),
          ),
        ],
      ),
      body: StreamBuilder<List<WeddingProfile>>(
        stream: repo.watchAllProfiles(),
        builder: (context, snapshot) {
          final profiles = snapshot.data ?? [];
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

          if (profile.groomName.isNotEmpty && !_isInit) {
            _initFields(profile);
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // 1. Cloud Sync Status Card
                _buildSyncCard(context),
                const SizedBox(height: 24),

                // 2. Profile & Budget Section
                _buildSectionHeader(
                  context,
                  title: 'Data Mempelai & Anggaran',
                ),
                const SizedBox(height: 10),
                BentoCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _groomController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                          ValidationUtils.nameInputFormatter,
                        ],
                        maxLength: 50,
                        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                        decoration: const InputDecoration(
                          labelText: 'Nama Mempelai Pria (CPP)',
                          hintText: 'Cth: Dimas Arya',
                        ),
                        validator: (v) => ValidationUtils.validateName(v, 'Nama CPP'),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _brideController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                          ValidationUtils.nameInputFormatter,
                        ],
                        maxLength: 50,
                        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                        decoration: const InputDecoration(
                          labelText: 'Nama Mempelai Wanita (CPW)',
                          hintText: 'Cth: Larasati',
                        ),
                        validator: (v) => ValidationUtils.validateName(v, 'Nama CPW'),
                      ),
                      const SizedBox(height: 14),
                      DateSelectorButton(
                        label: 'Tanggal Pernikahan (Hari-H)',
                        selectedEpochMillis: _weddingDate,
                        onDateSelected: (millis) => setState(() => _weddingDate = millis),
                      ),
                      const SizedBox(height: 14),
                      CurrencyTextField(
                        labelText: 'Batas Total Anggaran (Budget Target)',
                        initialValue: _budgetCap,
                        onChanged: (val) => _budgetCap = val,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _culturalGroom,
                        decoration: const InputDecoration(labelText: 'Adat Tradisi Mempelai Pria'),
                        items: CulturalPreset.values
                            .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                            .toList(),
                        onChanged: (val) => setState(() => _culturalGroom = val ?? 'MODERN'),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _culturalBride,
                        decoration: const InputDecoration(labelText: 'Adat Tradisi Mempelai Wanita'),
                        items: CulturalPreset.values
                            .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                            .toList(),
                        onChanged: (val) => setState(() => _culturalBride = val ?? 'MODERN'),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isSaving ? null : () => _saveProfileSettings(profile),
                          icon: _isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.check_circle_outline_rounded),
                          label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Profil & Anggaran'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Quote Customization Section
                _buildSectionHeader(
                  context,
                  title: 'Kutipan Cinta di Dashboard',
                ),
                const SizedBox(height: 10),
                BentoCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Tampilkan Kutipan di Dashboard', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: const Text('Menampilkan quote romantis pada kartu utama ringkasan', style: TextStyle(fontSize: 12)),
                        value: _quoteEnabled,
                        onChanged: (val) => setState(() => _quoteEnabled = val),
                      ),
                      if (_quoteEnabled) ...[
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _quoteController,
                          inputFormatters: [LengthLimitingTextInputFormatter(150)],
                          maxLength: 150,
                          decoration: const InputDecoration(
                            labelText: 'Teks Kutipan atau Doa',
                            hintText: 'Perjalanan cinta yang luar biasa dimulai dari hari bahagia ini.',
                          ),
                          maxLines: 2,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: _quoteFontSize,
                                decoration: const InputDecoration(
                                  labelText: 'Ukuran Font',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'KECIL', child: Text('Kecil', overflow: TextOverflow.ellipsis)),
                                  DropdownMenuItem(value: 'SEDANG', child: Text('Sedang', overflow: TextOverflow.ellipsis)),
                                  DropdownMenuItem(value: 'BESAR', child: Text('Besar', overflow: TextOverflow.ellipsis)),
                                ],
                                onChanged: (val) => setState(() => _quoteFontSize = val ?? 'SEDANG'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: _quoteFontStyle,
                                decoration: const InputDecoration(
                                  labelText: 'Gaya Font',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'NORMAL', child: Text('Normal', overflow: TextOverflow.ellipsis)),
                                  DropdownMenuItem(value: 'BOLD', child: Text('Tebal', overflow: TextOverflow.ellipsis)),
                                  DropdownMenuItem(value: 'ITALIC', child: Text('Miring', overflow: TextOverflow.ellipsis)),
                                  DropdownMenuItem(value: 'BOLD_ITALIC', child: Text('Tebal Miring', overflow: TextOverflow.ellipsis)),
                                ],
                                onChanged: (val) => setState(() => _quoteFontStyle = val ?? 'ITALIC'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Live Preview Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.visibility_outlined, size: 14, color: theme.colorScheme.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Pratinjau Langsung (Live Preview)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '"${_quoteController.text.trim().isNotEmpty ? _quoteController.text.trim() : 'Perjalanan cinta yang luar biasa dimulai dari sini.'}"',
                                style: _resolvePreviewStyle(theme),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. System Preferences
                _buildSectionHeader(
                  context,
                  title: 'Tampilan & Keamanan',
                ),
                const SizedBox(height: 10),
                BentoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tema Aplikasi
                      const Text(
                        'Tema Aplikasi',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pilih tema tampilan yang nyaman untuk mata',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<ThemeMode>(
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('Sistem', style: TextStyle(fontSize: 12)),
                              icon: Icon(Icons.brightness_auto_outlined, size: 16),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Terang', style: TextStyle(fontSize: 12)),
                              icon: Icon(Icons.light_mode_outlined, size: 16),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Gelap', style: TextStyle(fontSize: 12)),
                              icon: Icon(Icons.dark_mode_outlined, size: 16),
                            ),
                          ],
                          selected: {ref.watch(themeModeProvider)},
                          onSelectionChanged: (newSelection) {
                            if (newSelection.isNotEmpty) {
                              ref.read(themeModeProvider.notifier).setThemeMode(newSelection.first);
                            }
                          },
                        ),
                      ),
                      const Divider(height: 28),

                      // Pengingat Harian Toggle
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.notifications_active_outlined, color: theme.colorScheme.primary, size: 20),
                        ),
                        title: const Text('Pengingat Harian', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(
                          'Pemberitahuan berkala progres tugas dan berkas',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        value: _dailyReminderEnabled,
                        onChanged: (val) async {
                          setState(() => _dailyReminderEnabled = val);
                          await AppPreferences.setDailyReminderEnabled(val);
                        },
                      ),
                      const Divider(height: 28),

                      // Kunci Biometrik Toggle
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.fingerprint_rounded, color: theme.colorScheme.primary, size: 20),
                        ),
                        title: const Text('Kunci Keamanan Biometrik', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(
                          'Gunakan sidik jari atau PIN saat membuka aplikasi',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        value: _biometricEnabled,
                        onChanged: (val) async {
                          setState(() => _biometricEnabled = val);
                          await AppPreferences.setBiometricEnabled(val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Export Center & Data Backup
                _buildSectionHeader(
                  context,
                  title: 'Ekspor Data & Cadangan (Backup)',
                ),
                const SizedBox(height: 10),
                BentoCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 22),
                        ),
                        title: const Text('Ekspor Buku Panduan Nikah (PDF)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: const Text('Format lengkap berisi anggaran, vendor, rundown, dan panitia', style: TextStyle(fontSize: 12)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                        onTap: () => _exportSummaryPdf(context, profile),
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.table_chart_rounded, color: Colors.teal, size: 22),
                        ),
                        title: const Text('Ekspor Daftar Tamu Undangan (CSV)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: const Text('Format tabel spreadsheet untuk tim penerima tamu', style: TextStyle(fontSize: 12)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                        onTap: () => _exportGuestsCsv(context, profile),
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.backup_rounded, color: Colors.blue, size: 22),
                        ),
                        title: const Text('Cadangkan Data Lengkap (JSON Backup)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: const Text('Simpan seluruh data profil, anggaran, tamu, vendor ke file .json', style: TextStyle(fontSize: 12)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                        onTap: () => _exportFullBackupJson(context, profile),
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade800.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.restore_page_rounded, color: Colors.amber.shade800, size: 22),
                        ),
                        title: const Text('Pulihkan Data (Restore Backup)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: const Text('Pulihkan rencana pernikahan dari teks atau file JSON cadangan', style: TextStyle(fontSize: 12)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                        onTap: () => _showRestoreBackupDialog(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 6. App Info & Version
                _buildSectionHeader(
                  context,
                  title: 'Informasi Aplikasi & Fitur',
                ),
                const SizedBox(height: 10),
                BentoCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.system_update_rounded, color: theme.colorScheme.primary, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Nikahin',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  'Versi 1.0.0 (Build Stabil)',
                                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          FilledButton.tonal(
                            onPressed: _isCheckingUpdate
                                ? null
                                : () async {
                                    setState(() => _isCheckingUpdate = true);
                                    await Future.delayed(const Duration(milliseconds: 700));
                                    if (!context.mounted) return;
                                    setState(() => _isCheckingUpdate = false);
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Status Pembaruan'),
                                        content: const Text(
                                          'Aplikasi Nikahin sudah dalam versi terbaru (v1.0.0).\nSeluruh fitur berjalan optimal.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            child: const Text('Tutup'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                            child: _isCheckingUpdate
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Cek Update'),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        'Fitur Unggulan Nikahin',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildFeatureItem(
                        theme,
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Anggaran & Vendor',
                        desc: 'Pelacakan pos biaya, pembayaran bertahap (DP / Lunas), dan daftar kontak vendor.',
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem(
                        theme,
                        icon: Icons.event_note_outlined,
                        title: 'Timeline Rundown Acara',
                        desc: 'Penjadwalan urutan sesi kegiatan acara akad & resepsi beserta penanggung jawab (PIC).',
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem(
                        theme,
                        icon: Icons.people_outline_rounded,
                        title: 'Buku Tamu & RSVP',
                        desc: 'Manajemen alokasi tamu per sesi (Akad/Resepsi), kelompok pihak, dan status kehadiran.',
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem(
                        theme,
                        icon: Icons.assignment_outlined,
                        title: 'Berkas Dokumen Nikah',
                        desc: 'Checklist berkas KUA / Catatan Sipil dengan penentuan target deadline otomatis.',
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem(
                        theme,
                        icon: Icons.card_giftcard_outlined,
                        title: 'Seserahan & Panitia',
                        desc: 'Rincian hantaran mahar CPP/CPW serta pembagian tugas & seragam panitia keluarga.',
                      ),
                      const SizedBox(height: 8),
                      _buildFeatureItem(
                        theme,
                        icon: Icons.print_outlined,
                        title: 'Ekspor PDF & CSV',
                        desc: 'Cetak buku panduan resmi pernikahan berformat tabel rapi siap bagikan ke keluarga & WO.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 7. Danger Zone
                _buildSectionHeader(
                  context,
                  title: 'Zona Berbahaya',
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 10),
                BentoCard(
                  padding: const EdgeInsets.all(16),
                  border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.delete_forever_rounded, color: theme.colorScheme.error, size: 22),
                    ),
                    title: Text(
                      'Hapus Seluruh Data Rencana',
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.error, fontSize: 14),
                    ),
                    subtitle: const Text(
                      'Mengosongkan anggaran, vendor, tamu, dan rundown untuk mulai dari awal.',
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () => _deleteEntireProfile(context, profile),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: color ?? theme.colorScheme.onSurface,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildSyncCard(BuildContext context) {
    final theme = Theme.of(context);
    final sync = ref.watch(syncManagerProvider);

    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: sync.isSyncEnabled
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  sync.isSyncEnabled ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                  color: sync.isSyncEnabled ? theme.colorScheme.primary : theme.colorScheme.outline,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sync.isSyncEnabled ? 'Cloud Sync Aktif' : 'Penyimpanan Offline',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      sync.isSyncEnabled
                          ? 'Tersinkronisasi otomatis dengan Cloud'
                          : 'Semua data tersimpan aman di perangkat',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
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
                label: const Text('Akun'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _resolvePreviewStyle(ThemeData theme) {
    double size = 13.0;
    if (_quoteFontSize == 'KECIL') size = 11.0;
    if (_quoteFontSize == 'BESAR') size = 15.0;

    FontWeight weight = FontWeight.normal;
    FontStyle style = FontStyle.normal;

    if (_quoteFontStyle.contains('BOLD')) weight = FontWeight.bold;
    if (_quoteFontStyle.contains('ITALIC')) style = FontStyle.italic;

    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
      color: theme.colorScheme.onPrimaryContainer,
      height: 1.3,
    );
  }

  Future<void> _saveProfileSettings(WeddingProfile profile) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final updated = profile.copyWith(
        groomName: _groomController.text.trim(),
        brideName: _brideController.text.trim(),
        weddingDate: _weddingDate,
        totalBudgetCap: _budgetCap,
        culturalPresetGroom: _culturalGroom,
        culturalPresetBride: _culturalBride,
        quote: _quoteController.text.trim(),
        quoteEnabled: _quoteEnabled,
        quoteFontSize: _quoteFontSize,
        quoteFontStyle: _quoteFontStyle,
      );

      await ref.read(weddingRepositoryProvider).updateProfile(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengaturan profil & anggaran berhasil disimpan!')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _exportSummaryPdf(BuildContext context, WeddingProfile profile) async {
    final repo = ref.read(weddingRepositoryProvider);
    final expenses = await repo.watchExpenses(profile.id).first;
    final guests = await repo.watchGuests(profile.id).first;
    final vendors = await repo.watchVendors(profile.id).first;
    final tasks = await repo.watchTasks(profile.id).first;
    final committee = await repo.watchCommittee(profile.id).first;
    final events = await repo.watchEvents(profile.id).first;
    final seserahan = await repo.watchSeserahan(profile.id).first;
    final documents = await repo.watchDocuments(profile.id).first;

    final eventRundowns = <String, List<WeddingRundownItem>>{};
    for (final e in events) {
      final items = await repo.watchRundownItems(e.eventId).first;
      eventRundowns[e.eventId] = items;
    }

    await ExportUtils.exportWeddingSummaryPdf(
      profile: profile,
      expenses: expenses,
      guests: guests,
      vendors: vendors,
      tasks: tasks,
      committee: committee,
      events: events,
      eventRundowns: eventRundowns,
      seserahan: seserahan,
      documents: documents,
    );
  }

  Future<void> _exportGuestsCsv(BuildContext context, WeddingProfile profile) async {
    final repo = ref.read(weddingRepositoryProvider);
    final guests = await repo.watchGuests(profile.id).first;
    await ExportUtils.exportGuestsCsv(profile, guests);
  }

  Future<void> _exportFullBackupJson(BuildContext context, WeddingProfile profile) async {
    try {
      final repo = ref.read(weddingRepositoryProvider);
      final backupData = await repo.exportFullBackup(profile.id);
      await ExportUtils.exportBackupJson(profile, backupData);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mencadangkan data: $e')),
        );
      }
    }
  }

  void _showRestoreBackupDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.restore_page_rounded, color: Colors.blue),
            SizedBox(width: 8),
            Text('Pulihkan Cadangan'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tempelkan (paste) teks JSON cadangan data pernikahan di bawah ini:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: '{"format":"NIKAHIN_BACKUP", ...}',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              try {
                final backupData = ExportUtils.parseBackupJson(text);
                await ref.read(weddingRepositoryProvider).restoreFullBackup(backupData);
                if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil dipulihkan dari cadangan!')),
                  );
                }
              } catch (err) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal memulihkan cadangan: $err')),
                  );
                }
              }
            },
            child: const Text('Pulihkan'),
          ),
        ],
      ),
    );
  }


  void _deleteEntireProfile(BuildContext context, WeddingProfile profile) {
    showDeleteConfirmDialog(
      context: context,
      itemName: profile.coupleTitle,
      message: 'PERINGATAN: Mereset data pernikahan ini akan mengosongkan seluruh pos anggaran, vendor, tamu, rundown, dan tugas secara permanen.',
      onConfirm: () async {
        await ref.read(weddingRepositoryProvider).deleteProfile(profile.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data rencana pernikahan telah dibersihkan.')),
          );
          context.go('/wedding/${profile.id}');
        }
      },
    );
  }

  void _showSettingsGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Panduan Pengaturan',
      screenPurpose:
          'Pusat kendali konfigurasi profil pernikahan, kustomisasi kutipan dashboard, preferensi tema, hingga ekspor laporan PDF.',
      features: const [
        WeddingGuideFeature(
          title: 'Data Pengantin & Anggaran',
          description: 'Ubah nama kedua mempelai, tanggal pernikahan, target total anggaran, dan pilihan adat tradisi.',
          icon: Icons.favorite_border_rounded,
        ),
        WeddingGuideFeature(
          title: 'Kutipan Cinta & Doa',
          description: 'Sesuaikan teks kutipan romantis serta ukuran dan gaya font untuk kartu utama dashboard.',
          icon: Icons.format_quote_rounded,
        ),
        WeddingGuideFeature(
          title: 'Ekspor Dokumen PDF & CSV',
          description: 'Cetak seluruh susunan rencana dalam format PDF siap pakai atau ekspor daftar tamu ke tabel CSV.',
          icon: Icons.ios_share_rounded,
        ),
        WeddingGuideFeature(
          title: 'Tema & Keamanan',
          description: 'Pilih mode tampilan terang atau gelap, aktifkan pengingat harian, serta kunci aplikasi dengan sidik jari.',
          icon: Icons.tune_rounded,
        ),
      ],
      proTip: 'Gunakan tombol Ekspor PDF untuk membagikan susunan persiapan pernikahan ke pihak keluarga dan wedding organizer!',
    );
  }

  Widget _buildFeatureItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11.5,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
