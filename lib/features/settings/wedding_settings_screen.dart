import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/local/preferences_manager.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../data/services/notification_service.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/demo_guard.dart';
import '../../shared/utils/export_utils.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';
import '../auth/presentation/auth_notifier.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/date_selector_button.dart';
import 'presentation/widgets/settings_app_info_card.dart';
import 'presentation/widgets/settings_backup_card.dart';
import 'presentation/widgets/settings_danger_zone_card.dart';
import 'presentation/widgets/settings_preferences_card.dart';
import 'presentation/widgets/settings_quote_card.dart';
import 'presentation/widgets/settings_support_card.dart';
import 'presentation/widgets/settings_unified_profile_card.dart';

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
  int _dailyReminderHour = 20;
  int _dailyReminderMinute = 0;
  bool _biometricEnabled = false;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final daily = await AppPreferences.isDailyReminderEnabled();
    final hour = await AppPreferences.getDailyReminderHour();
    final minute = await AppPreferences.getDailyReminderMinute();
    final bio = await AppPreferences.isBiometricEnabled();
    if (mounted) {
      setState(() {
        _dailyReminderEnabled = daily;
        _dailyReminderHour = hour;
        _dailyReminderMinute = minute;
        _biometricEnabled = bio;
      });
      if (daily) {
        ref.read(notificationServiceProvider).scheduleDailyReminder(
              hour: hour,
              minute: minute,
            );
      }
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
                // 1. Unified Profile Box (All-in-One: Avatar Google, Identitas, Status Akun)
                SettingsUnifiedProfileCard(
                  profile: profile,
                  onEditProfile: () => _showEditProfileModal(context, profile),
                ),
                const SizedBox(height: 20),

                // 2. Quote Customization Section
                _buildSectionHeader(
                  context,
                  title: 'Kutipan Cinta di Dashboard',
                  icon: Icons.format_quote_rounded,
                ),
                const SizedBox(height: 10),
                SettingsQuoteCard(
                  quoteEnabled: _quoteEnabled,
                  quoteController: _quoteController,
                  quoteFontSize: _quoteFontSize,
                  quoteFontStyle: _quoteFontStyle,
                  onQuoteEnabledChanged: (val) {
                    setState(() => _quoteEnabled = val);
                    _saveQuoteSettings(profile);
                  },
                  onQuoteFontSizeChanged: (val) {
                    setState(() => _quoteFontSize = val);
                    _saveQuoteSettings(profile);
                  },
                  onQuoteFontStyleChanged: (val) {
                    setState(() => _quoteFontStyle = val);
                    _saveQuoteSettings(profile);
                  },
                  onQuoteTextChanged: () => _saveQuoteSettings(profile),
                ),
                const SizedBox(height: 20),

                // 3. System Preferences (Theme, Notifications, Biometrics)
                _buildSectionHeader(
                  context,
                  title: 'Tampilan & Keamanan',
                  icon: Icons.tune_rounded,
                ),
                const SizedBox(height: 10),
                SettingsPreferencesCard(
                  dailyReminderEnabled: _dailyReminderEnabled,
                  dailyReminderHour: _dailyReminderHour,
                  dailyReminderMinute: _dailyReminderMinute,
                  biometricEnabled: _biometricEnabled,
                  onDailyReminderChanged: (val) async {
                    setState(() => _dailyReminderEnabled = val);
                    await AppPreferences.setDailyReminderEnabled(val);
                    final notif = ref.read(notificationServiceProvider);
                    if (val) {
                      await notif.requestPermissions();
                      await notif.scheduleDailyReminder(
                        hour: _dailyReminderHour,
                        minute: _dailyReminderMinute,
                      );
                    } else {
                      await notif.cancelDailyReminder();
                    }
                  },
                  onDailyReminderTimeChanged: (hour, minute) async {
                    setState(() {
                      _dailyReminderHour = hour;
                      _dailyReminderMinute = minute;
                    });
                    await AppPreferences.setDailyReminderTime(hour, minute);
                    if (_dailyReminderEnabled) {
                      await ref.read(notificationServiceProvider).scheduleDailyReminder(
                            hour: hour,
                            minute: minute,
                          );
                    }
                  },
                  onBiometricChanged: (val) async {
                    setState(() => _biometricEnabled = val);
                    await AppPreferences.setBiometricEnabled(val);
                  },
                ),
                const SizedBox(height: 20),

                // 4. Export Center & Data Backup
                _buildSectionHeader(
                  context,
                  title: 'Ekspor Data & Cadangan',
                  icon: Icons.archive_outlined,
                ),
                const SizedBox(height: 10),
                SettingsBackupCard(
                  profile: profile,
                  onExportPdf: () => _exportSummaryPdf(context, profile),
                  onExportCsv: () => _exportGuestsCsv(context, profile),
                  onExportJson: () => _exportFullBackupJson(context, profile),
                  onRestoreJson: () => _showRestoreBackupDialog(context),
                ),
                const SizedBox(height: 20),

                // 5. App Info & Feature Showcase
                _buildSectionHeader(
                  context,
                  title: 'Tentang Aplikasi',
                  icon: Icons.info_outline_rounded,
                ),
                const SizedBox(height: 10),
                const SettingsAppInfoCard(),
                const SizedBox(height: 20),

                // 6. Support & Feedback
                _buildSectionHeader(
                  context,
                  title: 'Bantuan & Dukungan',
                  icon: Icons.support_agent_rounded,
                ),
                const SizedBox(height: 10),
                const SettingsSupportCard(),
                const SizedBox(height: 20),

                // 7. Danger Zone
                _buildSectionHeader(
                  context,
                  title: 'Zona Berbahaya',
                  icon: Icons.warning_amber_rounded,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 10),
                SettingsDangerZoneCard(
                  profile: profile,
                  onDeleteProfile: () => _deleteEntireProfile(context, profile),
                ),
                const SizedBox(height: 28),

                // 8. Log Out Button (Production Grade)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutConfirmDialog(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(
                        color: theme.colorScheme.error.withValues(alpha: 0.4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: Text(
                      ref.watch(authNotifierProvider).isDemoMode
                          ? 'Keluar dari Mode Demo'
                          : 'Keluar dari Akun',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
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
    IconData? icon,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 2),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color ?? theme.colorScheme.primary),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? theme.colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutConfirmDialog(BuildContext context) async {
    final authState = ref.read(authNotifierProvider);
    final isDemo = authState.isDemoMode;
    final email = authState.email ?? 'Akun Anda';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Theme.of(ctx).colorScheme.error, size: 22),
            const SizedBox(width: 10),
            Text(isDemo ? 'Keluar Mode Demo' : 'Keluar Akun'),
          ],
        ),
        content: Text(
          isDemo
              ? 'Apakah Anda yakin ingin keluar dari Mode Demo? Anda akan dialihkan ke halaman masuk.'
              : 'Apakah Anda yakin ingin keluar dari akun $email? Data yang telah tersinkronisasi tetap aman di penyimpanan cloud.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await ref.read(authNotifierProvider.notifier).signOut();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  Future<void> _saveQuoteSettings(WeddingProfile profile) async {
    final updated = profile.copyWith(
      quote: _quoteController.text.trim(),
      quoteEnabled: _quoteEnabled,
      quoteFontSize: _quoteFontSize,
      quoteFontStyle: _quoteFontStyle,
    );
    await ref.read(weddingRepositoryProvider).updateProfile(updated);
  }

  void _showEditProfileModal(BuildContext context, WeddingProfile profile) {
    final theme = Theme.of(context);
    final modalFormKey = GlobalKey<FormState>();

    final groomCtrl = TextEditingController(text: _groomController.text);
    final brideCtrl = TextEditingController(text: _brideController.text);
    int modalWeddingDate = _weddingDate;
    double modalBudgetCap = _budgetCap;
    String modalCulturalGroom = _culturalGroom;
    String modalCulturalBride = _culturalBride;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.85,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                expand: false,
                builder: (context, scrollController) {
                  return Form(
                    key: modalFormKey,
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite_rounded, color: theme.colorScheme.primary, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'Edit Data Mempelai',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                        Text(
                          'Ubah identitas pasangan pengantin, tanggal hari-H, dan target alokasi anggaran.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: groomCtrl,
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
                          controller: brideCtrl,
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
                          selectedEpochMillis: modalWeddingDate,
                          onDateSelected: (millis) {
                            setModalState(() => modalWeddingDate = millis);
                          },
                        ),
                        const SizedBox(height: 14),
                        CurrencyTextField(
                          labelText: 'Batas Total Anggaran (Budget Target)',
                          initialValue: modalBudgetCap,
                          onChanged: (val) {
                            modalBudgetCap = val;
                          },
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: modalCulturalGroom,
                          decoration: const InputDecoration(labelText: 'Adat Tradisi Mempelai Pria'),
                          items: CulturalPreset.values
                              .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              HapticFeedback.selectionClick();
                              setModalState(() => modalCulturalGroom = val);
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: modalCulturalBride,
                          decoration: const InputDecoration(labelText: 'Adat Tradisi Mempelai Wanita'),
                          items: CulturalPreset.values
                              .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              HapticFeedback.selectionClick();
                              setModalState(() => modalCulturalBride = val);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () async {
                            if (!modalFormKey.currentState!.validate()) return;
                            if (!DemoGuard.checkAction(context, ref: ref, actionName: 'Menyimpan Pengaturan Profil')) {
                              return;
                            }
                            HapticFeedback.mediumImpact();

                            setState(() {
                              _groomController.text = groomCtrl.text.trim();
                              _brideController.text = brideCtrl.text.trim();
                              _weddingDate = modalWeddingDate;
                              _budgetCap = modalBudgetCap;
                              _culturalGroom = modalCulturalGroom;
                              _culturalBride = modalCulturalBride;
                            });

                            final updated = profile.copyWith(
                              groomName: groomCtrl.text.trim(),
                              brideName: brideCtrl.text.trim(),
                              weddingDate: modalWeddingDate,
                              totalBudgetCap: modalBudgetCap,
                              culturalPresetGroom: modalCulturalGroom,
                              culturalPresetBride: modalCulturalBride,
                              quote: _quoteController.text.trim(),
                              quoteEnabled: _quoteEnabled,
                              quoteFontSize: _quoteFontSize,
                              quoteFontStyle: _quoteFontStyle,
                            );

                            await ref.read(weddingRepositoryProvider).updateProfile(updated);

                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                            }
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profil & anggaran berhasil disimpan!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.check_circle_outline_rounded),
                          label: const Text('Simpan Perubahan'),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
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
