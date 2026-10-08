import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../ui/theme/theme_controller.dart';

class SettingsPreferencesCard extends ConsumerWidget {
  final bool dailyReminderEnabled;
  final bool biometricEnabled;
  final ValueChanged<bool> onDailyReminderChanged;
  final ValueChanged<bool> onBiometricChanged;

  const SettingsPreferencesCard({
    super.key,
    required this.dailyReminderEnabled,
    required this.biometricEnabled,
    required this.onDailyReminderChanged,
    required this.onBiometricChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return BentoCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title: Theme
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tema Tampilan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    'Sesuaikan skema warna aplikasi',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
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
              selected: {themeMode},
              onSelectionChanged: (newSelection) {
                if (newSelection.isNotEmpty) {
                  HapticFeedback.selectionClick();
                  ref.read(themeModeProvider.notifier).setThemeMode(newSelection.first);
                }
              },
            ),
          ),
          const Divider(height: 28),

          // Daily Reminder Toggle
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            title: const Text(
              'Pengingat Harian',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              'Pemberitahuan berkala progres tugas & berkas',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            value: dailyReminderEnabled,
            onChanged: (val) {
              HapticFeedback.selectionClick();
              onDailyReminderChanged(val);
            },
          ),
          const Divider(height: 24),

          // Biometric Lock Toggle
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.fingerprint_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            title: const Text(
              'Kunci Keamanan Biometrik',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              'Gunakan sidik jari atau PIN saat membuka aplikasi',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            value: biometricEnabled,
            onChanged: (val) {
              HapticFeedback.selectionClick();
              onBiometricChanged(val);
            },
          ),
        ],
      ),
    );
  }
}
