import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/remote/midtrans_payment_service.dart';
import '../../../domain/models/midtrans_core_models.dart';
import '../../../shared/utils/currency_utils.dart';
import '../../../shared/widgets/bento_card.dart';
import 'auth_notifier.dart';
import 'payment_celebration_screen.dart';
import 'widgets/payment_brand_badge.dart';

/// Layar Pembayaran Midtrans Core API (Standar Produksi Fintech, Bento Grid & Inset Box)
class MidtransCustomPaymentScreen extends ConsumerStatefulWidget {
  final MidtransChargeData chargeData;

  const MidtransCustomPaymentScreen({
    super.key,
    required this.chargeData,
  });

  @override
  ConsumerState<MidtransCustomPaymentScreen> createState() => _MidtransCustomPaymentScreenState();
}

class _MidtransCustomPaymentScreenState extends ConsumerState<MidtransCustomPaymentScreen> {
  late MidtransChargeData _data;
  Timer? _countdownTimer;
  Timer? _pollingTimer;
  Duration _remainingTime = const Duration(hours: 24);
  bool _isSuccess = false;
  String? _copiedLabel;
  int _selectedGuideTab = 0; // 0: m-Banking, 1: ATM, 2: i-Banking

  @override
  void initState() {
    super.initState();
    _data = widget.chargeData;

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

    // Tampilkan transisi selebrasi layar penuh
    PaymentCelebrationScreen.show(context, orderId: _data.orderId);
  }

  void _copyToClipboard(String text, String label) {
    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copiedLabel = label);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(PhosphorIconsFill.checkCircle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('$label berhasil disalin!')),
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
            const SnackBar(content: Text('Aplikasi pembayaran belum terpasang atau tidak dapat dibuka.')),
          );
        }
      }
    } catch (_) {}
  }

  String _formatNumberWithSpacing(String raw) {
    // Format spasi per 4 digit (misal: 1241 2489 2467 7646 51)
    final clean = raw.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    final formattedTime = '$hours:$minutes:$seconds';

    return Scaffold(
      backgroundColor: isDark ? theme.colorScheme.surface : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Detail Pembayaran'),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          children: [
            // 1. Top Countdown Capsule
            _buildCountdownCapsule(formattedTime),
            const SizedBox(height: 14),

            // 2. Hero Card: Channel & Nomor Rekening / VA (Inset White Box)
            _buildHeroPaymentCard(theme),
            const SizedBox(height: 14),

            // 3. Detail Transaksi Bento Card
            _buildTransactionDetailCard(theme),
            const SizedBox(height: 14),

            // 4. Segmented Tab Panduan Pembayaran
            _buildPaymentGuideSection(theme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownCapsule(String formattedTime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE85D42), // Coral Urgent Accent
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE85D42).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Selesaikan pembayaran dalam',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              const Icon(PhosphorIconsRegular.clock, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPaymentCard(ThemeData theme) {
    switch (_data.channel) {
      case PaymentChannel.qris:
        return _buildQrisCard(theme);
      case PaymentChannel.mandiriBill:
        return _buildMandiriBillCard(theme);
      case PaymentChannel.gopay:
      case PaymentChannel.shopeepay:
        return _buildEWalletCard(theme);
      default:
        return _buildVirtualAccountCard(theme);
    }
  }

  Widget _buildVirtualAccountCard(ThemeData theme) {
    final rawVa = _data.vaNumber ?? '7001081234567890';
    final spacedVa = _formatNumberWithSpacing(rawVa);
    final bankName = _data.bankName ?? _data.channel.name;
    final isCopied = _copiedLabel == 'Nomor Virtual Account';
    final isDark = theme.brightness == Brightness.dark;

    return BentoCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: isDark ? theme.colorScheme.surfaceContainerHigh : const Color(0xFFF1F5F9),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Logo Brand & Nama Bank
          Row(
            children: [
              PaymentBrandBadge(channel: _data.channel, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bankName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'Virtual Account',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Inset White Box (Kotak Putih Nomor VA & Tombol Salin)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      spacedVa,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: theme.colorScheme.onSurface,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _copyToClipboard(rawVa, 'Nomor Virtual Account'),
                  icon: Icon(
                    isCopied ? PhosphorIconsFill.checkCircle : PhosphorIconsRegular.copy,
                    size: 20,
                    color: isCopied ? Colors.green : theme.colorScheme.primary,
                  ),
                  tooltip: 'Salin Nomor Rekening',
                  visualDensity: VisualDensity.compact,
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
    final isDark = theme.brightness == Brightness.dark;

    return BentoCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: isDark ? theme.colorScheme.surfaceContainerHigh : const Color(0xFFF1F5F9),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PaymentBrandBadge(channel: PaymentChannel.mandiriBill, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mandiri Bill Payment',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'Perusahaan & Kode Pembayaran',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Inset Box 1: Kode Perusahaan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KODE PERUSAHAAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      billerCode,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(billerCode, 'Kode Perusahaan'),
                  icon: Icon(
                    isCodeCopied ? PhosphorIconsFill.checkCircle : PhosphorIconsRegular.copy,
                    size: 18,
                    color: isCodeCopied ? Colors.green : theme.colorScheme.primary,
                  ),
                  tooltip: 'Salin Kode',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Inset Box 2: Kode Bayar (Bill Key)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KODE BAYAR (BILL KEY)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      billKey,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(billKey, 'Kode Bayar'),
                  icon: Icon(
                    isKeyCopied ? PhosphorIconsFill.checkCircle : PhosphorIconsRegular.copy,
                    size: 18,
                    color: isKeyCopied ? Colors.green : theme.colorScheme.primary,
                  ),
                  tooltip: 'Salin Kode Bayar',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrisCard(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return BentoCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? theme.colorScheme.surfaceContainerHigh : const Color(0xFFF1F5F9),
      borderRadius: 18,
      child: Column(
        children: [
          Row(
            children: [
              PaymentBrandBadge(channel: PaymentChannel.qris, size: 36),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pindai Kode QRIS',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    Text(
                      'Semua m-Banking & e-Wallet',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Viewfinder QR Putih Bersih
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
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
                if (_data.qrCodeUrl != null && _data.qrCodeUrl!.isNotEmpty)
                  Image.network(
                    _data.qrCodeUrl!,
                    width: 210,
                    height: 210,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => _buildFallbackQrVisual(),
                  )
                else
                  _buildFallbackQrVisual(),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(PhosphorIconsFill.sealCheck, size: 14, color: Color(0xFFC8102E)),
                    SizedBox(width: 4),
                    Text(
                      'QRIS STANDAR ASPI & BANK INDONESIA',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackQrVisual() {
    return Container(
      width: 190,
      height: 190,
      color: Colors.grey.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIconsRegular.qrCode, size: 80, color: Colors.grey.shade800),
            const SizedBox(height: 6),
            const Text(
              'QRIS MIDTRANS CORE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEWalletCard(ThemeData theme) {
    final deep = _data.deeplinkUrl;
    final isDark = theme.brightness == Brightness.dark;

    return BentoCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark ? theme.colorScheme.surfaceContainerHigh : const Color(0xFFF1F5F9),
      borderRadius: 18,
      child: Column(
        children: [
          Row(
            children: [
              PaymentBrandBadge(channel: _data.channel, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _data.channel.name,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    Text(
                      'Buka di aplikasi',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (deep != null && deep.isNotEmpty)
            FilledButton.icon(
              onPressed: () => _openDeeplink(deep),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(PhosphorIconsRegular.arrowSquareOut, size: 18),
              label: Text(
                'Buka Aplikasi ${_data.channel.name}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetailCard(ThemeData theme) {
    final authState = ref.watch(authNotifierProvider);
    final userName = authState.displayName ?? 'Calon Pengantin';

    return BentoCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Transaksi',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),

          _buildDetailRow(
            label: 'ID Transaksi',
            value: _data.orderId,
            theme: theme,
            isMonospace: true,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            label: 'Paket Akses',
            value: 'Nikahin Lifetime Pass',
            theme: theme,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            label: 'Nama Akun',
            value: userName,
            theme: theme,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            label: 'Metode Pembayaran',
            value: _data.channel.name,
            theme: theme,
          ),
          const SizedBox(height: 10),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 10),

          // Total Tagihan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Tagihan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                CurrencyUtils.formatRupiah(_data.grossAmount),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required ThemeData theme,
    bool isMonospace = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentGuideSection(ThemeData theme) {
    final instructions = _getInstructionsForChannel(_data.channel, _selectedGuideTab);

    return BentoCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIconsRegular.bookBookmark, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              const Text(
                'Panduan Cara Pembayaran',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Segmented Tab Pilihan Kanal (m-Banking, ATM, Internet Banking)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _buildGuideTabButton('m-Banking', 0, theme),
                _buildGuideTabButton('ATM', 1, theme),
                _buildGuideTabButton('i-Banking', 2, theme),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Daftar Langkah Terstruktur
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
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$idx',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
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
                        fontSize: 12,
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

  Widget _buildGuideTabButton(String label, int index, ThemeData theme) {
    final isSelected = _selectedGuideTab == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedGuideTab = index);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getInstructionsForChannel(PaymentChannel channel, int tabIndex) {
    // 0: m-Banking, 1: ATM, 2: i-Banking
    switch (channel) {
      case PaymentChannel.qris:
        return [
          'Buka aplikasi m-Banking atau e-Wallet pilihanmu.',
          'Pilih fitur "Bayar" atau "Scan / Pindai QR".',
          'Arahkan kamera ke kode QR di atas.',
          'Pastikan nama merchant "NIKAHIN" dan selesaikan pembayaran.',
        ];
      case PaymentChannel.mandiriBill:
        if (tabIndex == 1) {
          return [
            'Masukkan kartu ATM Mandiri dan PIN.',
            'Pilih menu "Bayar / Beli" → "Multi Payment".',
            'Masukkan Kode Perusahaan: 70012, lalu tekan Benar.',
            'Masukkan Kode Bayar (Bill Key) dan konfirmasi pembayaran.',
          ];
        } else if (tabIndex == 2) {
          return [
            'Login ke Mandiri Internet Banking.',
            'Pilih menu "Pembayaran" → "Multi Payment".',
            'Pilih penyedia jasa dengan Kode Perusahaan 70012.',
            'Masukkan Kode Bayar dan selesaikan dengan Token PIN.',
          ];
        }
        return [
          'Buka aplikasi Livin\' by Mandiri.',
          'Pilih menu "Bayar" → "Multi Payment".',
          'Masukkan Kode Perusahaan: 70012.',
          'Masukkan Kode Bayar (Bill Key) dan selesaikan dengan PIN Livin\'.',
        ];

      case PaymentChannel.briVa:
        if (tabIndex == 1) {
          return [
            'Masukkan kartu ATM BRI dan PIN.',
            'Pilih menu "Transaksi Lain" → "Pembayaran" → "Lainnya" → "BRIVA".',
            'Masukkan nomor BRIVA di atas lalu tekan Benar.',
            'Periksa detail nama akun dan jumlah, lalu konfirmasi pembayaran.',
          ];
        } else if (tabIndex == 2) {
          return [
            'Login ke Internet Banking BRI (ib.bri.co.id).',
            'Pilih menu "Pembayaran" → "BRIVA".',
            'Masukkan nomor Virtual Account BRIVA.',
            'Konfirmasi detail tagihan dan masukkan password m-Token.',
          ];
        }
        return [
          'Buka aplikasi BRImo dan lakukan login.',
          'Pilih menu "Tagihan" atau "Pembayaran" → "BRIVA".',
          'Pilih "Tambah Transaksi Baru" dan masukkan nomor BRIVA di atas.',
          'Periksa detail penerima dan selesaikan dengan PIN BRImo.',
        ];

      case PaymentChannel.bniVa:
        if (tabIndex == 1) {
          return [
            'Masukkan kartu ATM BNI dan PIN.',
            'Pilih menu "Menu Lain" → "Pembayaran" → "Menu Berikutnya" → "Virtual Account Billing".',
            'Masukkan nomor Virtual Account BNI.',
            'Periksa data transaksi dan konfirmasi pembayaran.',
          ];
        } else if (tabIndex == 2) {
          return [
            'Login ke BNI Internet Banking.',
            'Pilih menu "Transaksi" → "Virtual Account Billing".',
            'Masukkan nomor Virtual Account BNI.',
            'Masukkan respon otentikasi BNI e-Secure.',
          ];
        }
        return [
          'Buka BNI Mobile Banking.',
          'Pilih menu "Transfer" → "Virtual Account Billing".',
          'Pilih "Input Baru" dan masukkan nomor Virtual Account BNI.',
          'Periksa nominal dan masukkan Password Transaksi.',
        ];

      case PaymentChannel.permataVa:
        return [
          'Buka PermataMobile X atau ATM Permata.',
          'Pilih menu "Pembayaran" → "Virtual Account".',
          'Masukkan nomor Virtual Account Permata di atas.',
          'Periksa detail tagihan dan konfirmasi pembayaran.',
        ];

      case PaymentChannel.cimbVa:
        return [
          'Buka OCTO Mobile atau ATM CIMB Niaga.',
          'Pilih menu "Transfer" → "Rekening Ponsel / Rekening Lain" → "Virtual Account".',
          'Masukkan nomor Virtual Account CIMB Niaga di atas.',
          'Periksa detail tagihan dan konfirmasi dengan PIN.',
        ];

      case PaymentChannel.bsiVa:
        return [
          'Buka BSI Mobile atau ATM BSI.',
          'Pilih menu "Bayar" → "Institusi / Virtual Account".',
          'Masukkan nomor Virtual Account BSI di atas.',
          'Periksa detail nama & nominal, lalu masukkan PIN BSI Mobile.',
        ];

      case PaymentChannel.bcaVa:
        return [
          'Buka BCA Mobile (m-BCA) atau KlikBCA.',
          'Pilih menu "m-Transfer" → "BCA Virtual Account".',
          'Masukkan nomor BCA Virtual Account di atas.',
          'Periksa detail transaksi dan masukkan PIN m-BCA.',
        ];

      case PaymentChannel.gopay:
        return [
          'Ketuk tombol "Buka Aplikasi GoPay" di atas.',
          'Aplikasi Gojek atau GoPay akan terbuka secara otomatis.',
          'Periksa nominal pembayaran Nikahin.',
          'Selesaikan transaksi dengan PIN GoPay Anda.',
        ];

      case PaymentChannel.shopeepay:
        return [
          'Ketuk tombol "Buka Aplikasi ShopeePay" di atas.',
          'Aplikasi Shopee akan terbuka secara otomatis.',
          'Periksa nominal dan selesaikan dengan PIN ShopeePay.',
        ];
    }
  }
}
