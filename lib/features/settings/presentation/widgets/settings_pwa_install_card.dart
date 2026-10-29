import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/bento_card.dart';

/// Kartu panduan edukasi instalasi PWA ("Tambahkan ke Layar Utama")
/// Muncul otomatis jika aplikasi diakses melalui platform Web / peramban seluler.
class SettingsPwaInstallCard extends StatelessWidget {
  const SettingsPwaInstallCard({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return BentoCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_iphone_rounded,
                  color: Color(0xFFAA771C),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pasang di Layar Utama iPhone',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Buka Nikahin layaknya aplikasi App Store asli',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                _buildStepRow(
                  step: '1',
                  text: 'Ketuk tombol Bagikan (Share / ikon kotak berpanah atas) di bilah bawah Safari.',
                  theme: theme,
                ),
                const SizedBox(height: 10),
                _buildStepRow(
                  step: '2',
                  text: 'Gulir ke bawah dan pilih menu "Tambahkan ke Layar Utama" (Add to Home Screen).',
                  theme: theme,
                ),
                const SizedBox(height: 10),
                _buildStepRow(
                  step: '3',
                  text: 'Ikon Nikahin akan langsung muncul di layar utama iPhone Anda dalam mode layar penuh.',
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: 'https://nikahin-app.pages.dev'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tautan web Nikahin berhasil disalin ke papan klip.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.link_rounded, size: 18),
            label: const Text('Salin Tautan Web Aplikasi'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String step,
    required String text,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            step,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.35,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
