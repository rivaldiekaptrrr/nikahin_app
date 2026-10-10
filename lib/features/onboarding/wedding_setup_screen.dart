import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/local/preferences_manager.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/date_selector_button.dart';
import '../auth/presentation/auth_notifier.dart';

/// Layar Setup Profil Pernikahan untuk User Baru yang Baru Diaktifkan.
/// Hanya muncul sekali saat pertama kali login dan belum memiliki profil.
class WeddingSetupScreen extends ConsumerStatefulWidget {
  const WeddingSetupScreen({super.key});

  @override
  ConsumerState<WeddingSetupScreen> createState() => _WeddingSetupScreenState();
}

class _WeddingSetupScreenState extends ConsumerState<WeddingSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groomController = TextEditingController();
  final _brideController = TextEditingController();

  int _weddingDate = DateTime.now().add(const Duration(days: 180)).millisecondsSinceEpoch;
  double _budgetCap = 100000000.0;
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

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_weddingDate <= DateTime.now().millisecondsSinceEpoch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal pernikahan harus di masa mendatang.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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

      final currentUserId = ref.read(authNotifierProvider).userId;
      await AppPreferences.setUserProfileId(currentUserId, id);
      await AppPreferences.setActiveProfileId(id);
      ref.read(activeProfileIdProvider.notifier).state = id;

      if (mounted) {
        context.go('/wedding/$id');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data: $e'),
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
        title: const Text('Setup Rencana Pernikahan'),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 36,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Selamat Datang, ${auth.displayName ?? 'Pengguna'}! 💍',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Isi data dasar pernikahan Anda untuk memulai perencanaan. Data ini dapat diubah kapan saja di menu Pengaturan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                // Nama Mempelai Pria
                TextFormField(
                  controller: _groomController,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                    ValidationUtils.nameInputFormatter,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Nama Mempelai Pria (CPP)',
                    hintText: 'Contoh: Budi',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) => ValidationUtils.validateName(v, 'Nama CPP'),
                ),
                const SizedBox(height: 14),

                // Nama Mempelai Wanita
                TextFormField(
                  controller: _brideController,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                    ValidationUtils.nameInputFormatter,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Nama Mempelai Wanita (CPW)',
                    hintText: 'Contoh: Sari',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) => ValidationUtils.validateName(v, 'Nama CPW'),
                ),
                const SizedBox(height: 14),

                // Tanggal Pernikahan
                DateSelectorButton(
                  label: 'Tanggal Pernikahan',
                  selectedEpochMillis: _weddingDate,
                  onDateSelected: (millis) => setState(() => _weddingDate = millis),
                ),
                const SizedBox(height: 14),

                // Total Anggaran
                CurrencyTextField(
                  labelText: 'Target Total Anggaran (Budget Cap)',
                  initialValue: _budgetCap,
                  onChanged: (val) => _budgetCap = val,
                ),
                const SizedBox(height: 14),

                // Alur Dokumen Nikah
                Text(
                  'Alur Pendaftaran Dokumen Nikah',
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
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

                // Adat CPP
                DropdownButtonFormField<String>(
                  initialValue: _culturalGroom,
                  decoration: const InputDecoration(labelText: 'Adat Mempelai Pria (CPP)'),
                  items: CulturalPreset.values
                      .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                      .toList(),
                  onChanged: (val) => setState(() => _culturalGroom = val ?? 'MODERN'),
                ),
                const SizedBox(height: 14),

                // Adat CPW
                DropdownButtonFormField<String>(
                  initialValue: _culturalBride,
                  decoration: const InputDecoration(labelText: 'Adat Mempelai Wanita (CPW)'),
                  items: CulturalPreset.values
                      .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                      .toList(),
                  onChanged: (val) => setState(() => _culturalBride = val ?? 'MODERN'),
                ),
                const SizedBox(height: 28),

                // Submit Button
                FilledButton.icon(
                  onPressed: _isLoading ? null : _saveAndContinue,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Icon(Icons.arrow_forward_rounded, size: 20),
                  label: Text(
                    _isLoading ? 'Menyimpan...' : 'Mulai Rencanakan Pernikahan',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
