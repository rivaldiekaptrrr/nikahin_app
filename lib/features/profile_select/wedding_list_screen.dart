import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/config/mock_config.dart';
import '../../data/local/mock_seeder.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/currency_utils.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/app_feedback.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/date_selector_button.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/error_state_view.dart';
import '../../shared/widgets/skeleton_loading.dart';

class WeddingListScreen extends ConsumerWidget {
  const WeddingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.watch(weddingRepositoryProvider);
    final profilesStream = repo.watchAllProfiles();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.favorite_rounded, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Nikahin'),
          ],
        ),
      ),
      body: StreamBuilder<List<WeddingProfile>>(
        stream: profilesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorStateView(
              errorMessage: snapshot.error.toString(),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonListView(showHeader: false);
          }

          final profiles = snapshot.data ?? [];

          if (profiles.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Pilih Rencana Pernikahan',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kelola rencana dan persiapan momen bahagiamu',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              ...profiles.map((profile) => _buildProfileCard(context, ref, profile)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProfileDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Buat Rencana Baru'),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref, WeddingProfile profile) {
    final theme = Theme.of(context);
    final days = WeddingDateUtils.daysUntil(profile.weddingDate);
    String countdownText;
    if (days == 0) {
      countdownText = 'Hari Ini!';
    } else if (days > 0) {
      countdownText = '$days Hari Lagi';
    } else {
      countdownText = '${days.abs()} Hari Berlalu';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BentoCard(
        onTap: () {
          ref.read(activeProfileIdProvider.notifier).state = profile.id;
          context.go('/wedding/${profile.id}');
        },
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    profile.coupleTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    countdownText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 16, color: theme.colorScheme.outline),
                const SizedBox(width: 6),
                Text(
                  WeddingDateUtils.formatFull(profile.weddingDate),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 16, color: theme.colorScheme.outline),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Anggaran: ${CurrencyUtils.formatRupiah(profile.totalBudgetCap)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error, size: 20),
                  onPressed: () {
                    showDeleteConfirmDialog(
                      context: context,
                      itemName: profile.coupleTitle,
                      onConfirm: () async {
                        final repo = ref.read(weddingRepositoryProvider);
                        await repo.deleteProfile(profile.id);
                        if (context.mounted) {
                          AppFeedback.showUndo(
                            context,
                            message: '"${profile.coupleTitle}" berhasil dihapus',
                            onUndo: () => repo.createProfile(profile, seedDefaults: false),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_outline_rounded, size: 64, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Rencana Pernikahan',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai buat rencana pernikahan impianmu sekarang. Template tugas, dokumen, dan susunan acara akan dibuatkan secara otomatis.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _showCreateProfileDialog(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Buat Rencana Pernikahan'),
            ),
            if (kUseMockData) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final db = ref.read(databaseProvider);
                  await MockSeeder.seedAllMockData(db);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data simulasi (mock) pernikahan berhasil dimuat!')),
                    );
                  }
                },
                icon: const Icon(Icons.dataset_rounded),
                label: const Text('Muat Data Simulasi (Mock Data)'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCreateProfileDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _CreateProfileBottomSheet(),
    );
  }
}

class _CreateProfileBottomSheet extends ConsumerStatefulWidget {
  const _CreateProfileBottomSheet();

  @override
  ConsumerState<_CreateProfileBottomSheet> createState() => _CreateProfileBottomSheetState();
}

class _CreateProfileBottomSheetState extends ConsumerState<_CreateProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _groomController = TextEditingController();
  final _brideController = TextEditingController();
  int _weddingDate = DateTime.now().add(const Duration(days: 180)).millisecondsSinceEpoch;
  double _budgetCap = 50000000;
  String _religionType = 'ISLAM';
  String _religionDetail = 'ISLAM';
  String _culturalGroom = 'MODERN';
  String _culturalBride = 'MODERN';
  bool _isLoading = false;

  @override
  void dispose() {
    _groomController.dispose();
    _brideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                'Buat Rencana Pernikahan',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Groom & Bride Names
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
                  hintText: 'Contoh: Rivaldi',
                  prefixIcon: Icon(Icons.person_outline_rounded),
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
                  hintText: 'Contoh: Sarah',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (v) => ValidationUtils.validateName(v, 'Nama CPW'),
              ),
              const SizedBox(height: 14),

              // Wedding Date
              DateSelectorButton(
                label: 'Tanggal Pernikahan',
                selectedEpochMillis: _weddingDate,
                onDateSelected: (millis) => setState(() => _weddingDate = millis),
              ),
              const SizedBox(height: 14),

              // Budget Cap
              CurrencyTextField(
                labelText: 'Target Total Anggaran (Budget Cap)',
                initialValue: _budgetCap,
                onChanged: (val) => _budgetCap = val,
              ),
              const SizedBox(height: 14),

              // Religion Type (Islam vs Non-Islam)
              Text(
                'Alur Pendaftaran Dokumen',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Islam (KUA)'),
                      selected: _religionType == 'ISLAM',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _religionType = 'ISLAM';
                            _religionDetail = 'ISLAM';
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Non-Islam (Catatan Sipil)'),
                      selected: _religionType == 'NON_ISLAM',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _religionType = 'NON_ISLAM';
                            _religionDetail = 'KRISTEN';
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Cultural Preset
              DropdownButtonFormField<String>(
                initialValue: _culturalGroom,
                decoration: const InputDecoration(labelText: 'Adat Mempelai Pria (CPP)'),
                items: CulturalPreset.values
                    .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                    .toList(),
                onChanged: (val) => setState(() => _culturalGroom = val ?? 'MODERN'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _culturalBride,
                decoration: const InputDecoration(labelText: 'Adat Mempelai Wanita (CPW)'),
                items: CulturalPreset.values
                    .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                    .toList(),
                onChanged: (val) => setState(() => _culturalBride = val ?? 'MODERN'),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Mulai Rencanakan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final id = UuidUtils.generateId();
      final profile = WeddingProfile(
        id: id,
        groomName: _groomController.text.trim(),
        brideName: _brideController.text.trim(),
        weddingDate: _weddingDate,
        totalBudgetCap: _budgetCap,
        religionType: _religionType,
        religionDetail: _religionDetail,
        culturalPresetGroom: _culturalGroom,
        culturalPresetBride: _culturalBride,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      final repo = ref.read(weddingRepositoryProvider);
      await repo.createProfile(profile, seedDefaults: true);

      ref.read(activeProfileIdProvider.notifier).state = id;

      if (mounted) {
        Navigator.of(context).pop();
        AppFeedback.showSuccess(context, message: 'Rencana pernikahan berhasil dibuat!');
        context.go('/wedding/$id');
      }
    } catch (e) {
      if (mounted) {
        AppFeedback.showError(context, message: 'Gagal membuat rencana: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
