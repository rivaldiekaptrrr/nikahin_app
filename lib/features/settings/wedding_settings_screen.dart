import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/local/preferences_manager.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/demo_guard.dart';
import '../../shared/utils/export_utils.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';
import '../auth/presentation/auth_notifier.dart';
import 'presentation/widgets/settings_app_info_card.dart';
import 'presentation/widgets/settings_backup_card.dart';
import 'presentation/widgets/settings_cloud_sync_card.dart';
import 'presentation/widgets/settings_danger_zone_card.dart';
import 'presentation/widgets/settings_hero_profile_card.dart';
import 'presentation/widgets/settings_preferences_card.dart';
import 'presentation/widgets/settings_profile_form_card.dart';
import 'presentation/widgets/settings_quote_card.dart';

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
          if (ref.watch(authNotifierProvider).isAdmin)
            IconButton(
              icon: const Icon(Icons.shield_rounded, color: Colors.amber),
              tooltip: 'Panel Super Admin',
              onPressed: () => context.push('/admin'),
            ),
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
                // 1. Hero Profile Banner (Bento Header)
                SettingsHeroProfileCard(profile: profile),
                const SizedBox(height: 16),

                // 2. Cloud Sync Status Card
                const SettingsCloudSyncCard(),
                const SizedBox(height: 24),

                // 3. Profile & Budget Section
                _buildSectionHeader(
                  context,
                  title: 'Data Mempelai & Anggaran',
                ),
                const SizedBox(height: 10),
                SettingsProfileFormCard(
                  formKey: _formKey,
                  groomController: _groomController,
                  brideController: _brideController,
                  weddingDate: _weddingDate,
                  budgetCap: _budgetCap,
                  culturalGroom: _culturalGroom,
                  culturalBride: _culturalBride,
                  isSaving: _isSaving,
                  onDateSelected: (millis) => setState(() => _weddingDate = millis),
                  onBudgetChanged: (val) => _budgetCap = val,
                  onCulturalGroomChanged: (val) => setState(() => _culturalGroom = val),
                  onCulturalBrideChanged: (val) => setState(() => _culturalBride = val),
                  onSave: () => _saveProfileSettings(profile),
                ),
                const SizedBox(height: 24),

                // 4. Quote Customization Section
                _buildSectionHeader(
                  context,
                  title: 'Kutipan Cinta di Dashboard',
                ),
                const SizedBox(height: 10),
                SettingsQuoteCard(
                  quoteEnabled: _quoteEnabled,
                  quoteController: _quoteController,
                  quoteFontSize: _quoteFontSize,
                  quoteFontStyle: _quoteFontStyle,
                  onQuoteEnabledChanged: (val) => setState(() => _quoteEnabled = val),
                  onQuoteFontSizeChanged: (val) => setState(() => _quoteFontSize = val),
                  onQuoteFontStyleChanged: (val) => setState(() => _quoteFontStyle = val),
                  onQuoteTextChanged: () => setState(() {}),
                ),
                const SizedBox(height: 24),

                // 5. System Preferences (Theme, Notifications, Biometrics)
                _buildSectionHeader(
                  context,
                  title: 'Tampilan & Keamanan',
                ),
                const SizedBox(height: 10),
                SettingsPreferencesCard(
                  dailyReminderEnabled: _dailyReminderEnabled,
                  biometricEnabled: _biometricEnabled,
                  onDailyReminderChanged: (val) async {
                    setState(() => _dailyReminderEnabled = val);
                    await AppPreferences.setDailyReminderEnabled(val);
                  },
                  onBiometricChanged: (val) async {
                    setState(() => _biometricEnabled = val);
                    await AppPreferences.setBiometricEnabled(val);
                  },
                ),
                const SizedBox(height: 24),

                // 6. Export Center & Data Backup
                _buildSectionHeader(
                  context,
                  title: 'Ekspor Data & Cadangan (Backup)',
                ),
                const SizedBox(height: 10),
                SettingsBackupCard(
                  profile: profile,
                  onExportPdf: () => _exportSummaryPdf(context, profile),
                  onExportCsv: () => _exportGuestsCsv(context, profile),
                  onExportJson: () => _exportFullBackupJson(context, profile),
                  onRestoreJson: () => _showRestoreBackupDialog(context),
                ),
                const SizedBox(height: 24),

                // 7. App Info & Feature Showcase
                _buildSectionHeader(
                  context,
                  title: 'Informasi Aplikasi & Fitur',
                ),
                const SizedBox(height: 10),
                const SettingsAppInfoCard(),
                const SizedBox(height: 24),

                // 8. Danger Zone
                _buildSectionHeader(
                  context,
                  title: 'Zona Berbahaya',
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 10),
                SettingsDangerZoneCard(
                  profile: profile,
                  onDeleteProfile: () => _deleteEntireProfile(context, profile),
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

  Future<void> _saveProfileSettings(WeddingProfile profile) async {
    if (!DemoGuard.checkAction(context, ref: ref, actionName: 'Menyimpan Pengaturan Profil')) {
      return;
    }
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
          const SnackBar(
            content: Text('Pengaturan profil & anggaran berhasil disimpan!'),
            behavior: SnackBarBehavior.floating,
          ),
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
          SnackBar(
            content: Text('Gagal mencadangkan data: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showRestoreBackupDialog(BuildContext context) {
    if (!DemoGuard.checkAction(context, ref: ref, actionName: 'Memulihkan Data Cadangan')) {
      return;
    }
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
                    const SnackBar(
                      content: Text('Data berhasil dipulihkan dari cadangan!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (err) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal memulihkan cadangan: $err'),
                      behavior: SnackBarBehavior.floating,
                    ),
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
    if (!DemoGuard.checkAction(context, ref: ref, actionName: 'Mereset Data Pernikahan')) {
      return;
    }
    HapticFeedback.heavyImpact();
    showDeleteConfirmDialog(
      context: context,
      itemName: profile.coupleTitle,
      message:
          'PERINGATAN: Mereset data pernikahan ini akan mengosongkan seluruh pos anggaran, vendor, tamu, rundown, dan tugas secara permanen.',
      onConfirm: () async {
        await ref.read(weddingRepositoryProvider).deleteProfile(profile.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data rencana pernikahan telah dibersihkan.'),
              behavior: SnackBarBehavior.floating,
            ),
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
}
