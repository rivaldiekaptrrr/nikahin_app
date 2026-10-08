import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

void showDemoRestrictionSheet(
  BuildContext context, {
  required String featureName,
}) {
  HapticFeedback.mediumImpact();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _DemoRestrictionSheetContent(featureName: featureName),
  );
}

class _DemoRestrictionSheetContent extends StatelessWidget {
  final String featureName;

  const _DemoRestrictionSheetContent({required this.featureName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Icon with glowing badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Mode Demo (Hanya Lihat)',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              'Fitur "$featureName" dinonaktifkan dalam mode demo. Masuk atau daftar akun secara gratis untuk mulai membuat dan menyimpan rencana pernikahan Anda sendiri!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Features Checklist
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildBenefitRow(theme, Icons.cloud_sync_outlined, 'Simpan data tersinkronisasi aman di Cloud'),
                  const SizedBox(height: 8),
                  _buildBenefitRow(theme, Icons.devices_rounded, 'Akses bersama pasangan di berbagai perangkat'),
                  const SizedBox(height: 8),
                  _buildBenefitRow(theme, Icons.picture_as_pdf_outlined, 'Ekspor buku panduan PDF & CSV tanpa batas'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // CTA Buttons
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/login');
                },
                icon: const Icon(Icons.login_rounded, size: 18),
                label: const Text(
                  'Masuk / Daftar Akun',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Lanjutkan Melihat Demo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
