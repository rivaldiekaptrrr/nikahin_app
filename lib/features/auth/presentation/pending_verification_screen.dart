import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/business_config.dart';
import '../../../data/remote/midtrans_payment_service.dart';
import '../../../shared/utils/currency_utils.dart';
import '../../../shared/widgets/bento_card.dart';
import 'auth_notifier.dart';
import 'midtrans_custom_payment_screen.dart';
import 'widgets/payment_channel_selection_modal.dart';

/// Halaman Paywall & Lisensi Nikahin (Bridal Luxury Bento Edition - 100% Responsive)
class PendingVerificationScreen extends ConsumerStatefulWidget {
  const PendingVerificationScreen({super.key});

  @override
  ConsumerState<PendingVerificationScreen> createState() => _PendingVerificationScreenState();
}

class _PendingVerificationScreenState extends ConsumerState<PendingVerificationScreen> {
  bool _isPaymentLoading = false;

  Future<void> _handleMidtransCorePurchase() async {
    final selectedChannel = await PaymentChannelSelectionModal.show(context);
    if (selectedChannel == null || !mounted) return;

    setState(() => _isPaymentLoading = true);
    try {
      final result = await ref.read(authNotifierProvider.notifier).chargeMidtransCoreApi(
        channel: selectedChannel,
      );
      if (!mounted) return;

      switch (result) {
        case MidtransCoreChargeSuccess(:final data):
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => MidtransCustomPaymentScreen(chargeData: data),
            ),
          );
          break;

        case MidtransCoreChargeError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          break;
      }
    } finally {
      if (mounted) setState(() => _isPaymentLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authNotifierProvider);
    final userEmail = auth.email ?? '-';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Aktivasi Lisensi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Keluar Akun',
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Hero Romantic Header
              Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.surfaceContainerHighest,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Social Proof Chip
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 15, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        'Dipercaya 10.000+ Calon Pengantin',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB78103),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Satu Langkah Menuju Pernikahan Impian 💍',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Akun ($userEmail) siap digunakan. Dapatkan akses penuh seumur hidup tanpa biaya langganan berulang.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              // 2. VIP Lifetime Pass Card (Golden / Champagne Styling)
              BentoCard(
                padding: const EdgeInsets.all(20),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.65),
                    theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium_rounded, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'VIP LIFETIME PASS',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'HEMAT 50%',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text(
                      BusinessConfig.packageName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              CurrencyUtils.formatRupiah(BusinessConfig.lifetimePrice),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            CurrencyUtils.formatRupiah(BusinessConfig.originalPrice),
                            style: TextStyle(
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bayar sekali saja, nikmati seluruh fitur dan update selamanya.',
                      style: TextStyle(fontSize: 11.5, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Bento Grid Highlights (2x2 Grid)
              Row(
                children: [
                  Expanded(
                    child: _buildBentoFeatureCard(
                      theme: theme,
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Anggaran & Vendor',
                      desc: 'Termin DP & lunas otomatis',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildBentoFeatureCard(
                      theme: theme,
                      icon: Icons.people_outline_rounded,
                      title: 'Buku Tamu Digital',
                      desc: 'RSVP real-time & kategori',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildBentoFeatureCard(
                      theme: theme,
                      icon: Icons.event_note_outlined,
                      title: 'Rundown & PIC',
                      desc: 'Skrip acara menit-ke-menit',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildBentoFeatureCard(
                      theme: theme,
                      icon: Icons.picture_as_pdf_outlined,
                      title: 'Panduan PDF & KUA',
                      desc: 'Ekspor dokumen siap cetak',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Trust & Security Badges Row (Overflow-proof)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    _buildTrustItem(Icons.lock_outline_rounded, 'Enkripsi 256-bit'),
                    Container(width: 1, height: 16, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    _buildTrustItem(Icons.qr_code_rounded, 'QRIS Resmi'),
                    Container(width: 1, height: 16, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    _buildTrustItem(Icons.bolt_rounded, 'Aktivasi Instan'),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 5. Clean Action Button
              FilledButton.icon(
                onPressed: _isPaymentLoading ? null : _handleMidtransCorePurchase,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                icon: _isPaymentLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.flash_on_rounded, size: 20),
                label: Text(
                  _isPaymentLoading ? 'Menyiapkan Pembayaran...' : 'Bayar Sekarang',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const SizedBox(height: 12),

              // Footer Note
              Text(
                'Pembayaran diverifikasi secara otomatis dalam hitungan detik setelah transaksi selesai.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoFeatureCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String label) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.green.shade700),
          const SizedBox(width: 4),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
