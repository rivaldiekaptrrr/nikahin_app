import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/config/business_config.dart';
import '../../../data/remote/midtrans_payment_service.dart';
import '../../../shared/utils/currency_utils.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/whatsapp_logo.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';
import 'midtrans_custom_payment_screen.dart';
import 'widgets/payment_channel_selection_modal.dart';

/// Halaman Paywall & Lisensi Nikahin (Bridal Luxury Bento Edition - 100% Responsive)
/// Mendukung mode pembayaran manual (QRIS Statis + WhatsApp) & Direct Midtrans Core API.
class PendingVerificationScreen extends ConsumerStatefulWidget {
  const PendingVerificationScreen({super.key});

  @override
  ConsumerState<PendingVerificationScreen> createState() => _PendingVerificationScreenState();
}

class _PendingVerificationScreenState extends ConsumerState<PendingVerificationScreen> {
  bool _isPaymentLoading = false;
  bool _isCheckingStatus = false;
  bool _isDownloadingQris = false;
  Timer? _statusPollTimer;
  OverlayEntry? _qrisToastOverlay;

  @override
  void initState() {
    super.initState();
    // Auto-polling status verifikasi berkala (setiap 10 detik) jika akun belum premium
    _statusPollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _silentCheckStatus();
    });
  }

  @override
  void dispose() {
    _statusPollTimer?.cancel();
    _qrisToastOverlay?.remove();
    _qrisToastOverlay = null;
    super.dispose();
  }

  Future<void> _silentCheckStatus() async {
    if (!mounted) return;
    final level = await ref.read(authNotifierProvider.notifier).refreshAccessLevel();
    if (level.isPremium && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akses lisensi Anda telah aktif! Selamat datang 🎉'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/setup');
    }
  }

  Future<void> _checkStatusManually() async {
    setState(() => _isCheckingStatus = true);
    try {
      final level = await ref.read(authNotifierProvider.notifier).refreshAccessLevel();
      if (!mounted) return;
      if (level.isPremium) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selamat! Akun Anda telah berhasil diaktifkan 🎉'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/setup');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Status: Menunggu Verifikasi. Mohon pastikan bukti transfer sudah terkirim ke WhatsApp Tim Nikahin.',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCheckingStatus = false);
    }
  }

  Future<void> _launchWhatsApp(String userEmail) async {
    final uri = BusinessConfig.getWhatsAppConfirmationUri(
      userEmail: userEmail,
    );
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tidak dapat membuka aplikasi WhatsApp. Silakan hubungi admin di +${BusinessConfig.manualPaymentWhatsAppNumber}.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal membuka WhatsApp. Silakan hubungi nomor +${BusinessConfig.manualPaymentWhatsAppNumber} secara manual.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _downloadQrisImage() async {
    if (_isDownloadingQris) return;
    setState(() => _isDownloadingQris = true);

    try {
      final byteData = await rootBundle.load(BusinessConfig.manualQrisAssetPath);
      final bytes = byteData.buffer.asUint8List();

      String targetDir = '';
      String targetLocationName = 'folder Download';

      if (Platform.isAndroid) {
        final publicDownloadDir = Directory('/storage/emulated/0/Download');
        final publicPicturesDir = Directory('/storage/emulated/0/Pictures');
        if (await publicDownloadDir.exists()) {
          targetDir = publicDownloadDir.path;
          targetLocationName = 'folder Download';
        } else if (await publicPicturesDir.exists()) {
          targetDir = publicPicturesDir.path;
          targetLocationName = 'folder Galeri/Pictures';
        } else {
          final extDirs = await getExternalStorageDirectories(type: StorageDirectory.downloads);
          if (extDirs != null && extDirs.isNotEmpty) {
            targetDir = extDirs.first.path;
            targetLocationName = 'penyimpanan perangkat';
          }
        }
      }

      if (targetDir.isEmpty) {
        final downloadDir = await getDownloadsDirectory();
        if (downloadDir != null) {
          targetDir = downloadDir.path;
          targetLocationName = 'folder Download';
        } else {
          final docDir = await getApplicationDocumentsDirectory();
          targetDir = docDir.path;
          targetLocationName = 'dokumen aplikasi';
        }
      }

      final fileName = 'qris_nikahin_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('$targetDir/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      if (mounted) {
        _showSmoothToast(
          message: 'Gambar QRIS berhasil disimpan di $targetLocationName.',
          onOpen: () => OpenFilex.open(file.path),
        );
      }
    } catch (e) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh gambar QRIS: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloadingQris = false);
      }
    }
  }

  void _showSmoothToast({
    required String message,
    required VoidCallback onOpen,
  }) {
    _qrisToastOverlay?.remove();
    _qrisToastOverlay = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _SmoothToastWidget(
        message: message,
        onOpen: () {
          entry.remove();
          if (_qrisToastOverlay == entry) _qrisToastOverlay = null;
          onOpen();
        },
        onDismiss: () {
          entry.remove();
          if (_qrisToastOverlay == entry) _qrisToastOverlay = null;
        },
      ),
    );

    _qrisToastOverlay = entry;
    overlay.insert(entry);
  }

  void _showFullQrisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'QRIS Pembayaran Nikahin',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download_rounded, color: Colors.black87),
                        tooltip: 'Download QRIS',
                        onPressed: _downloadQrisImage,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.black54),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(
                  maxScale: 4.0,
                  child: Image.asset(
                    BusinessConfig.manualQrisAssetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Cubit layar untuk zoom atau ambil screenshot untuk scan dari galeri.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          child: BusinessConfig.useManualPaymentMode
              ? _buildManualPaymentContent(theme, auth, userEmail)
              : _buildDirectPaymentContent(theme, userEmail),
        ),
      ),
    );
  }

  /// Tampilan Khusus Mode Pembayaran Manual (QRIS Statis + Kirim Bukti WhatsApp + Aktivasi Admin Panel)
  Widget _buildManualPaymentContent(ThemeData theme, AuthState auth, String userEmail) {
    return Column(
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
                Icons.qr_code_scanner_rounded,
                size: 38,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Status Tag
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_top_rounded, size: 14, color: Colors.amber),
                SizedBox(width: 5),
                Text(
                  'MENUNGGU PEMBAYARAN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB78103),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        Text(
          'Instruksi Pembayaran QRIS 💍',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Akun ($userEmail) siap diaktifkan. Silakan selesaikan pembayaran sebesar ${CurrencyUtils.formatRupiah(BusinessConfig.lifetimePrice)} untuk membuka akses seumur hidup.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),

        // 2. VIP Lifetime Badge & Nominal Tagihan
        BentoCard(
          padding: const EdgeInsets.all(18),
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
              const SizedBox(height: 12),
              Text(
                BusinessConfig.packageName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        CurrencyUtils.formatRupiah(BusinessConfig.lifetimePrice),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      CurrencyUtils.formatRupiah(BusinessConfig.originalPrice),
                      style: TextStyle(
                        fontSize: 13,
                        decoration: TextDecoration.lineThrough,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: BusinessConfig.lifetimePrice.toInt().toString()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nominal Rp 49.000 berhasil disalin ke papan klip'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    tooltip: 'Salin Nominal',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 3. QRIS Image Card (Bento Styling)
        BentoCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.qr_code_2_rounded, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'QRIS Nasional',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Bebas Biaya Admin',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: _isDownloadingQris ? null : _downloadQrisImage,
                        icon: _isDownloadingQris
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.download_rounded, size: 20),
                        tooltip: 'Download Gambar QRIS',
                        visualDensity: VisualDensity.compact,
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(6),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // QRIS Image Container with Tap to Enlarge
              GestureDetector(
                onTap: () => _showFullQrisDialog(context),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 290, maxHeight: 310),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      BusinessConfig.manualQrisAssetPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextButton.icon(
                onPressed: () => _showFullQrisDialog(context),
                icon: const Icon(Icons.zoom_in_rounded, size: 18),
                label: const Text(
                  'Ketuk untuk memperbesar QRIS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(height: 16),

              Text(
                'Mendukung seluruh M-Banking (BCA, Mandiri, BRI, BNI) & E-Wallet (GoPay, OVO, Dana, ShopeePay).',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 4. Petunjuk Langkah Pembayaran
        BentoCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.checklist_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Langkah Pembayaran & Verifikasi:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildStepItem(
                number: '1',
                text: 'Buka aplikasi M-Banking atau E-Wallet favorit Anda.',
              ),
              const SizedBox(height: 8),
              _buildStepItem(
                number: '2',
                text: 'Pilih menu Scan QR / QRIS, lalu scan kode QRIS di atas.',
              ),
              const SizedBox(height: 8),
              _buildStepItem(
                number: '3',
                text: 'Selesaikan pembayaran sejumlah Rp 49.000 & simpan bukti transfer.',
              ),
              const SizedBox(height: 8),
              _buildStepItem(
                number: '4',
                text: 'Klik tombol WhatsApp di bawah untuk menyetor bukti pembayaran.',
              ),
              const SizedBox(height: 8),
              _buildStepItem(
                number: '5',
                text: 'Tim Nikahin akan segera memverifikasi bukti pembayaran Anda.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 5. Tombol WhatsApp (Aksi Utama)
        FilledButton.icon(
          onPressed: () => _launchWhatsApp(userEmail),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF25D366), // Warna resmi WhatsApp
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
          ),
          icon: const WhatsAppLogo(size: 22),
          label: const Text(
            'Kirim Bukti Pembayaran ke WhatsApp',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
          ),
        ),
        const SizedBox(height: 10),

        // 6. Tombol Cek Status Aktivasi
        OutlinedButton.icon(
          onPressed: _isCheckingStatus ? null : _checkStatusManually,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: _isCheckingStatus
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.sync_rounded, size: 18),
          label: Text(_isCheckingStatus ? 'Memeriksa status...' : 'Cek Status Aktivasi'),
        ),
        const SizedBox(height: 14),

        // Auto-check note
        Text(
          'Layar ini akan otomatis mengalihkan Anda ke persiapan pernikahan begitu pembayaran terverifikasi.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            height: 1.35,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStepItem({required String number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12.5, height: 1.35),
          ),
        ),
      ],
    );
  }

  /// Tampilan Direct Payment Midtrans Core API (Jika mode manual = false)
  Widget _buildDirectPaymentContent(ThemeData theme, String userEmail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hero Romantic Header
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

        // VIP Lifetime Pass Card
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

        // Bento Grid Highlights (2x2 Grid)
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

        // Trust & Security Badges Row
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

        // Clean Action Button
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

/// Floating Banner dengan animasi masuk & keluar (Smooth Fade & Slide Easing)
class _SmoothToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  const _SmoothToastWidget({
    required this.message,
    required this.onOpen,
    required this.onDismiss,
  });

  @override
  State<_SmoothToastWidget> createState() => _SmoothToastWidgetState();
}

class _SmoothToastWidgetState extends State<_SmoothToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 450),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    ));

    _controller.forward();

    // Auto-dismiss setelah 4 detik dengan animasi reverse yang smooth
    _dismissTimer = Timer(const Duration(seconds: 4), () {
      _closeSmoothly();
    });
  }

  void _closeSmoothly() {
    _dismissTimer?.cancel();
    if (mounted) {
      _controller.reverse().then((_) {
        if (mounted) widget.onDismiss();
      });
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 20;

    return Positioned(
      bottom: bottomPadding,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Slate 800 modern dark banner
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF4ADE80),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      _closeSmoothly();
                      widget.onOpen();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6EE7B7),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    child: const Text('Buka'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

