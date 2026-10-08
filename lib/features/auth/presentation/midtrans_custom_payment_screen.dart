import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/remote/midtrans_payment_service.dart';
import '../../../domain/models/midtrans_core_models.dart';
import '../../../shared/utils/currency_utils.dart';
import '../../../shared/widgets/bento_card.dart';
import 'auth_notifier.dart';
import 'payment_celebration_screen.dart';

/// Layar Pembayaran 100% Native Custom Midtrans Core API (Luxury Ticket-Stub Edition)
class MidtransCustomPaymentScreen extends ConsumerStatefulWidget {
  final MidtransChargeData chargeData;

  const MidtransCustomPaymentScreen({
    super.key,
    required this.chargeData,
  });

  @override
  ConsumerState<MidtransCustomPaymentScreen> createState() => _MidtransCustomPaymentScreenState();
}

class _MidtransCustomPaymentScreenState extends ConsumerState<MidtransCustomPaymentScreen> with SingleTickerProviderStateMixin {
  late MidtransChargeData _data;
  Timer? _countdownTimer;
  Timer? _pollingTimer;
  Duration _remainingTime = const Duration(hours: 24);
  bool _isSuccess = false;
  String? _copiedLabel;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _data = widget.chargeData;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _initExpiryTimer();
    _startStatusPolling();
  }

  void _initExpiryTimer() {
    if (_data.expiryTime != null) {
      final diff = _data.expiryTime!.difference(DateTime.now());
      _remainingTime = diff.isNegative ? Duration.zero : diff;
    }

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
        } else {
          _countdownTimer?.cancel();
        }
      });
    });
  }

  void _startStatusPolling() {
    _pollingTimer?.cancel();
    // Polling status secara live setiap 4 detik
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (!mounted || _isSuccess) {
        timer.cancel();
        return;
      }

      // 1. Cek via Firestore / AuthNotifier
      final accessLevel = await ref.read(authNotifierProvider.notifier).checkAccessStatus();
      if (accessLevel.isPremium || accessLevel.isAdmin) {
        timer.cancel();
        _onPaymentSuccess();
        return;
      }

      // 2. Cek status via Midtrans Core API status endpoint
      try {
        final paymentService = ref.read(midtransPaymentServiceProvider);
        final status = await paymentService.checkCoreApiStatus(_data.orderId);
        if (status.isSuccess) {
          timer.cancel();
          await ref.read(authNotifierProvider.notifier).checkAccessStatus();
          _onPaymentSuccess();
        }
      } catch (_) {}
    });
  }

  void _onPaymentSuccess() {
    if (_isSuccess || !mounted) return;
    setState(() => _isSuccess = true);
    HapticFeedback.heavyImpact();

    _countdownTimer?.cancel();
    _pollingTimer?.cancel();

    // Tampilkan transisi selebrasi layar penuh (Milestone Full-Screen Experience)
    PaymentCelebrationScreen.show(context, orderId: _data.orderId);
  }

  void _copyToClipboard(String text, String label) {
    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copiedLabel = label);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('$label berhasil disalin ke clipboard!')),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedLabel = null);
    });
  }

  Future<void> _openDeeplink(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka aplikasi pembayaran.')),
          );
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Pembayaran Tagihan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // 1. Live Status Stepper Progress
            _buildLiveStatusStepper(theme),
            const SizedBox(height: 16),

            // 2. Ticket-Stub Billing Card
            _buildTicketBillingCard(theme, hours, minutes, seconds),
            const SizedBox(height: 16),

            // 3. Specific Channel Details (QRIS / VA / E-Wallet)
            _buildChannelSpecificCard(theme),
            const SizedBox(height: 16),

            // 4. Step-by-Step Payment Instructions
            _buildPaymentGuideSection(theme),
            const SizedBox(height: 20),

            // 5. Action Buttons (Check Status with Auto-Polling Banner)
            _buildActionSection(theme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatusStepper(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem(
            theme: theme,
            stepNumber: '1',
            label: 'Dibuat',
            isCompleted: true,
            isActive: false,
          ),
          _buildStepLine(theme, isPassed: true),
          _buildStepItem(
            theme: theme,
            stepNumber: '2',
            label: 'Menunggu Bayar',
            isCompleted: false,
            isActive: true,
          ),
          _buildStepLine(theme, isPassed: false),
          _buildStepItem(
            theme: theme,
            stepNumber: '3',
            label: 'Verifikasi',
            isCompleted: false,
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required ThemeData theme,
    required String stepNumber,
    required String label,
    required bool isCompleted,
    required bool isActive,
  }) {
    Color circleColor;
    Widget child;

    if (isCompleted) {
      circleColor = Colors.green;
      child = const Icon(Icons.check_rounded, size: 14, color: Colors.white);
    } else if (isActive) {
      circleColor = theme.colorScheme.primary;
      child = AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 4 * _pulseController.value,
                spreadRadius: 2 * _pulseController.value,
              ),
            ],
          ),
        ),
      );
    } else {
      circleColor = theme.colorScheme.outlineVariant;
      child = Text(
        stepNumber,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: child),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(ThemeData theme, {required bool isPassed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          height: 2,
          color: isPassed ? Colors.green : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildTicketBillingCard(ThemeData theme, String hours, String minutes, String seconds) {
    return BentoCard(
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        colors: [
          theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL TAGIHAN RESMI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyUtils.formatRupiah(_data.grossAmount),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 12, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      'Bebas Admin',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Countdown & Order ID Details (Responsive & Ellipsis-safe)
          Row(
            children: [
              // Sisa Waktu
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: Colors.red.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Sisa: ',
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    Flexible(
                      child: Text(
                        '$hours:$minutes:$seconds',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Order ID
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ID: ',
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    Flexible(
                      child: Text(
                        _data.orderId,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelSpecificCard(ThemeData theme) {
    switch (_data.channel) {
      case PaymentChannel.qris:
        return _buildQrisCard(theme);

      case PaymentChannel.mandiriBill:
        return _buildMandiriBillCard(theme);

      case PaymentChannel.bcaVa:
      case PaymentChannel.bniVa:
      case PaymentChannel.briVa:
      case PaymentChannel.permataVa:
        return _buildVirtualAccountCard(theme);

      case PaymentChannel.gopay:
      case PaymentChannel.shopeepay:
        return _buildEWalletCard(theme);
    }
  }

  Widget _buildQrisCard(ThemeData theme) {
    return BentoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8102E).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFFC8102E), size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pindai Kode QRIS Resmi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      'Mendukung semua mobile banking & e-wallet Indonesia',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // QR Viewfinder Container with Scan Brackets
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top merchant badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'MERCHANT: NIKAHIN WEDDING PLANNER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // QR Image
                if (_data.qrCodeUrl != null && _data.qrCodeUrl!.isNotEmpty)
                  Image.network(
                    _data.qrCodeUrl!,
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => _buildFallbackQrVisual(),
                  )
                else
                  _buildFallbackQrVisual(),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_rounded, size: 14, color: Color(0xFFC8102E)),
                    const SizedBox(width: 4),
                    Text(
                      'NMID: ID102003847291 • QRIS STANDAR BI',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'Buka BCA Mobile, Livin, BRImo, BNI Mobile, GoPay, OVO, Dana, atau ShopeePay lalu scan QR di atas.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackQrVisual() {
    return Container(
      width: 200,
      height: 200,
      color: Colors.grey.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_2_rounded, size: 100, color: Colors.grey.shade800),
            const SizedBox(height: 6),
            Text(
              'QRIS MIDTRANS CORE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVirtualAccountCard(ThemeData theme) {
    final va = _data.vaNumber ?? '7001081234567890';
    final bank = _data.bankName ?? _data.channel.name;
    final isCopied = _copiedLabel == 'Nomor Virtual Account';

    return BentoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _data.channel.badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_data.channel.icon, color: _data.channel.badgeColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Text(
                      'Nomor Rekening Virtual Account',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NOMOR VIRTUAL ACCOUNT',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 3),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: SelectableText(
                          va,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonalIcon(
                  onPressed: () => _copyToClipboard(va, 'Nomor Virtual Account'),
                  style: FilledButton.styleFrom(
                    backgroundColor: isCopied ? Colors.green.shade700 : null,
                    foregroundColor: isCopied ? Colors.white : null,
                  ),
                  icon: Icon(isCopied ? Icons.check_circle_rounded : Icons.copy_rounded, size: 16),
                  label: Text(
                    isCopied ? 'Tersalin!' : 'Salin',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMandiriBillCard(ThemeData theme) {
    final billerCode = _data.billerCode ?? '70012';
    final billKey = _data.billKey ?? '990812345678';
    final isCodeCopied = _copiedLabel == 'Kode Perusahaan';
    final isKeyCopied = _copiedLabel == 'Kode Bayar';

    return BentoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF003D79).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_rounded, color: Color(0xFF003D79), size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mandiri Bill Payment',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      'Perusahaan & Kode Pembayaran Mandiri',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Kode Perusahaan
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('KODE PERUSAHAAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text(billerCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                IconButton(
                  icon: Icon(isCodeCopied ? Icons.check_circle_rounded : Icons.copy_rounded, size: 18, color: isCodeCopied ? Colors.green : null),
                  tooltip: 'Salin Kode Perusahaan',
                  onPressed: () => _copyToClipboard(billerCode, 'Kode Perusahaan'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Kode Bayar / Bill Key
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('KODE BAYAR (BILL KEY)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text(billKey, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                IconButton(
                  icon: Icon(isKeyCopied ? Icons.check_circle_rounded : Icons.copy_rounded, size: 18, color: isKeyCopied ? Colors.green : null),
                  tooltip: 'Salin Kode Bayar',
                  onPressed: () => _copyToClipboard(billKey, 'Kode Bayar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEWalletCard(ThemeData theme) {
    final deep = _data.deeplinkUrl;

    return BentoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _data.channel.badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_data.channel.icon, color: _data.channel.badgeColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _data.channel.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Text(
                      'Buka dan konfirmasi pembayaran di aplikasi Anda',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          if (deep != null && deep.isNotEmpty)
            FilledButton.icon(
              onPressed: () => _openDeeplink(deep),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: _data.channel.badgeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                'Buka Aplikasi ${_data.channel.name}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentGuideSection(ThemeData theme) {
    final instructions = _getInstructionsForChannel(_data.channel);

    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              const Text(
                'Panduan Cara Pembayaran',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...instructions.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final text = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$idx',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) => Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.6),
                    blurRadius: 5 * _pulseController.value,
                    spreadRadius: 2.5 * _pulseController.value,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Menunggu transaksi... Sistem memverifikasi pembayaran secara otomatis tanpa perlu konfirmasi manual.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade900,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getInstructionsForChannel(PaymentChannel channel) {
    switch (channel) {
      case PaymentChannel.qris:
        return [
          'Buka aplikasi BCA Mobile, Livin by Mandiri, BRImo, GoPay, OVO, ShopeePay, atau DANA.',
          'Pilih fitur "Bayar" atau "Pindai / Scan QR".',
          'Arahkan kamera ke QR code di atas, pastikan nama merchant "NIKAHIN".',
          'Periksa nominal pembayaran dan konfirmasi dengan PIN Anda.',
        ];
      case PaymentChannel.bcaVa:
        return [
          'Buka BCA Mobile / KlikBCA / ATM BCA.',
          'Pilih menu "Transfer" → "BCA Virtual Account".',
          'Masukkan nomor Virtual Account yang tertera di atas.',
          'Periksa detail nama & nominal, lalu masukkan PIN m-BCA.',
        ];
      case PaymentChannel.mandiriBill:
        return [
          'Buka aplikasi Livin\' by Mandiri atau ATM Mandiri.',
          'Pilih menu "Bayar" → "Multi Payment".',
          'Pilih penyedia jasa dengan memasukkan Kode Perusahaan.',
          'Masukkan Kode Bayar (Bill Key) dan konfirmasi pembayaran.',
        ];
      case PaymentChannel.briVa:
        return [
          'Buka BRImo atau ATM BRI.',
          'Pilih menu "Pembayaran" → "BRIVA".',
          'Masukkan nomor BRIVA di atas.',
          'Periksa jumlah tagihan dan selesaikan dengan PIN BRImo.',
        ];
      case PaymentChannel.bniVa:
        return [
          'Buka BNI Mobile Banking atau ATM BNI.',
          'Pilih menu "Transfer" → "Virtual Account Billing".',
          'Masukkan nomor Virtual Account BNI.',
          'Konfirmasi transaksi dan masukkan Password Transaksi.',
        ];
      case PaymentChannel.permataVa:
        return [
          'Buka PermataMobile X atau ATM Permata.',
          'Pilih menu "Pembayaran" → "Virtual Account".',
          'Masukkan nomor Virtual Account Permata.',
          'Konfirmasi tagihan dan masukkan PIN otentikasi.',
        ];
      case PaymentChannel.gopay:
        return [
          'Klik tombol "Buka Aplikasi GoPay" di atas.',
          'Aplikasi Gojek/GoPay akan terbuka otomatis.',
          'Periksa nominal dan klik "Bayar".',
          'Masukkan PIN GoPay untuk menyelesaikan transaksi.',
        ];
      case PaymentChannel.shopeepay:
        return [
          'Klik tombol "Buka Aplikasi ShopeePay" di atas.',
          'Aplikasi Shopee akan terbuka otomatis.',
          'Periksa rincian pembayaran Nikahin.',
          'Selesaikan transaksi dengan PIN atau sidik jari ShopeePay.',
        ];
    }
  }
}
