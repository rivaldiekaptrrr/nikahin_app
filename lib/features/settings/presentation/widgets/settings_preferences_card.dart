import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/config/platform_config.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../ui/theme/theme_controller.dart';

class SettingsPreferencesCard extends ConsumerWidget {
  final bool dailyReminderEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool biometricEnabled;
  final ValueChanged<bool> onDailyReminderChanged;
  final void Function(int hour, int minute) onDailyReminderTimeChanged;
  final ValueChanged<bool> onBiometricChanged;
  final VoidCallback? onTestNotification;

  const SettingsPreferencesCard({
    super.key,
    required this.dailyReminderEnabled,
    this.dailyReminderHour = 20,
    this.dailyReminderMinute = 0,
    required this.biometricEnabled,
    required this.onDailyReminderChanged,
    required this.onDailyReminderTimeChanged,
    required this.onBiometricChanged,
    this.onTestNotification,
  });

  Future<void> _pickReminderTime(BuildContext context) async {
    HapticFeedback.selectionClick();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dailyReminderHour, minute: dailyReminderMinute),
      helpText: 'Pilih Jam Pengingat',
      cancelText: 'Batal',
      confirmText: 'Simpan',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDailyReminderTimeChanged(picked.hour, picked.minute);
    }
  }

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
          const SizedBox(height: 18),

          // Palette Section Title (Minimalist)
          Text(
            'Warna Aksen',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 12),

          // Pure Telegram-Style Color Bubbles (GPU-Accelerated Tactile Pop)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: WeddingPalette.values.map((p) {
                final isSelected = p == ref.watch(weddingPaletteProvider);
                return RepaintBoundary(
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ref.read(weddingPaletteProvider.notifier).setPalette(p);
                    },
                    customBorder: const CircleBorder(),
                    child: AnimatedScale(
                      scale: isSelected ? 1.12 : 0.94,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? p.primaryPreview : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: p.primaryPreview,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: p.primaryPreview.withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 1.5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: AnimatedScale(
                              scale: isSelected ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutBack,
                              child: const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
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
              'Kabar berkala untuk memantau persiapan dan berkas nikah',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            value: dailyReminderEnabled,
            onChanged: (val) {
              HapticFeedback.selectionClick();
              onDailyReminderChanged(val);
            },
          ),
          if (dailyReminderEnabled) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Material(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => _pickReminderTime(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 15,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Waktu Pengingat:',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${dailyReminderHour.toString().padLeft(2, '0')}:${dailyReminderMinute.toString().padLeft(2, '0')} WIB',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onTestNotification,
                  icon: const Icon(Icons.notifications_active_outlined, size: 15),
                  label: const Text('Kirim Notifikasi Uji Coba', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ),
            ),
          ],
          if (AppPlatformConfig.isBiometricsAvailable) ...[
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
        ],
      ),
    );
  }
}
