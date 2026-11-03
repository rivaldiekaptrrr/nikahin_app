import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/config/business_config.dart';
import '../../../data/local/preferences_manager.dart';
import '../../../data/remote/midtrans_payment_service.dart';
import '../../../data/repositories/wedding_repository.dart';
import '../../../data/services/couple_pairing_service.dart';
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
          content: Text('Akunmu sudah aktif! Selamat merencanakan pernikahan 🎉'),
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
            content: Text('Selamat! Akunmu sudah aktif selamanya 🎉'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/setup');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Pembayaran sedang diverifikasi. Pastikan bukti transfer sudah terkirim ke WhatsApp Tim Nikahin.',
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

      if (kIsWeb) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile.fromData(bytes, mimeType: 'image/jpeg', name: 'qris_nikahin.jpg')],
            subject: 'QRIS Pembayaran Nikahin',
          ),
        );
        if (mounted) {
          _showSmoothToast(
            message: 'Gambar QRIS siap disimpan.',
            onOpen: () {},
          );
        }
        return;
      }

      String targetDir = '';
      String targetLocationName = 'folder Download';

      if (!kIsWeb && Platform.isAndroid) {
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
                        icon: const Icon(PhosphorIconsRegular.downloadSimple, color: Colors.black87),
                        tooltip: 'Download QRIS',
                        onPressed: _downloadQrisImage,
                      ),
                      IconButton(
                        icon: const Icon(PhosphorIconsRegular.x, color: Colors.black54),
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
                'Perbesar gambar atau simpan ke galeri untuk memindai lewat aplikasi pembayaranmu.',
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

    if (!selectedChannel.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Metode ${selectedChannel.name} belum tersedia saat ini.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isPaymentLoading = true);
    try {
      // Eksekusi pembayaran langsung Midtrans Core API (100% In-App Native)
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pembayaran belum dapat diproses: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.signOut),
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
                PhosphorIconsRegular.qrCode,
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
                Icon(PhosphorIconsRegular.hourglass, size: 14, color: Colors.amber),
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
          'Akun ($userEmail) siap digunakan. Selesaikan pembayaran sebesar ${CurrencyUtils.formatRupiah(BusinessConfig.lifetimePrice)} untuk membuka semua fitur selamanya.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),

        // 1.5. Akses Co-Planner Pasangan (Bypass Pembayaran)
        _buildCouplePairingBanner(context, theme),
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
                        Icon(PhosphorIconsFill.crown, size: 14, color: Colors.white),
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
                    icon: const Icon(PhosphorIconsRegular.copy, size: 18),
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
                      Icon(PhosphorIconsRegular.qrCode, size: 20),
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
                            : const Icon(PhosphorIconsRegular.downloadSimple, size: 20),
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
                icon: const Icon(PhosphorIconsRegular.magnifyingGlassPlus, size: 18),
                label: const Text(
                  'Ketuk untuk memperbesar QRIS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(height: 16),

              Text(
                'Bisa dibayar lewat semua mobile banking dan dompet digital (BCA, Mandiri, BRI, BNI, GoPay, OVO, Dana, ShopeePay).',
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
                  Icon(PhosphorIconsRegular.checks, size: 18),
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
                text: 'Buka aplikasi mobile banking atau dompet digital pilihanmu.',
              ),
              const SizedBox(height: 8),
              _buildStepItem(
                number: '2',
                text: 'Pilih menu Pindai QR / QRIS, lalu arahkan kamera ke kode QR di atas.',
              ),
              const SizedBox(height: 8),
              _buildStepItem(
                number: '3',
                text: 'Selesaikan pembayaran sejumlah Rp 49.000 & simpan bukti transfer.',
              ),
              const SizedBox(height: 8),
              _buildStepItem(
                number: '4',
                text: 'Ketuk tombol WhatsApp di bawah untuk mengirimkan bukti transfer.',
              ),
              const SizedBox(height: 8),
              _buildStepItem(
                number: '5',
                text: 'Tim Nikahin akan segera memverifikasi bukti pembayaranmu.',
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
              : const Icon(PhosphorIconsRegular.arrowsClockwise, size: 18),
          label: Text(_isCheckingStatus ? 'Memeriksa status...' : 'Cek Status Aktivasi'),
        ),
        const SizedBox(height: 14),

        // Auto-check note
        Text(
          'Halaman ini akan langsung beralih ke persiapan pernikahan begitu pembayaranmu terkonfirmasi.',
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

  /// Tampilan Direct Payment Midtrans Core API (Clean Editorial Luxury Edition)
  Widget _buildDirectPaymentContent(ThemeData theme, String userEmail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),

        // 1. Logo Resmi Simbol Nikahin
        Center(
          child: Image.asset(
            'assets/logo/png/nikahin-symbol-master-512.png',
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 18),

        // 2. Headline & Subtitle
        Text(
          'Aktivasi Akses Penuh',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Rencanakan momen bahagiamu bersama pasangan dalam satu aplikasi tanpa biaya langganan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 3. Single Clean Offer Bento Card
        BentoCard(
          padding: const EdgeInsets.all(22),
          borderRadius: 22,
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Akses Penuh Pasangan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1 lisensi aktif untuk 2 akun (kamu & pasangan)',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  SvgPicture.asset(
                    'assets/images/lifetime-pass.svg',
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Harga
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    CurrencyUtils.formatRupiah(BusinessConfig.lifetimePrice),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '/ selamanya',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),

              // Daftar 3 Benefit Utama
              _buildBenefitRow(
                theme: theme,
                icon: PhosphorIconsFill.checkCircle,
                text: 'Sinkronisasi real-time dua arah dengan akun pasangan',
              ),
              const SizedBox(height: 10),
              _buildBenefitRow(
                theme: theme,
                icon: PhosphorIconsFill.checkCircle,
                text: 'Kelola anggaran, termin vendor, rundown, & buku tamu',
              ),
              const SizedBox(height: 10),
              _buildBenefitRow(
                theme: theme,
                icon: PhosphorIconsFill.checkCircle,
                text: 'Ekspor dokumen panduan PDF & checklist KUA resmi',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 4. Tombol Utama (Pilih Metode Pembayaran)
        FilledButton.icon(
          onPressed: _isPaymentLoading ? null : _handleMidtransCorePurchase,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          icon: _isPaymentLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(PhosphorIconsRegular.wallet, size: 18),
          label: Text(
            _isPaymentLoading ? 'Menyiapkan Pembayaran...' : 'Pilih Metode Pembayaran',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
          ),
        ),
        const SizedBox(height: 14),

        // 5. Tautan Pasangan (Secondary Action yang Bersih)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Punya kode dari pasangan?',
              style: TextStyle(
                fontSize: 12.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: () => _showPairingCodeModal(context),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 6),
              ),
              child: Text(
                'Hubungkan Akun',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // 6. Utility Footer (Trust Badge & Akses Tanya Jawab)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsRegular.shieldCheck,
              size: 13,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
            ),
            const SizedBox(width: 4),
            Text(
              'Transaksi Aman',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '•',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _showFaqModal(context),
              child: Text(
                'Tanya Jawab',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary.withValues(alpha: 0.9),
                  decoration: TextDecoration.underline,
                  decorationColor: theme.colorScheme.primary.withValues(alpha: 0.35),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Menampilkan Tanya Jawab seputar lisensi via Bottom Sheet (Menjaga halaman utama tetap 100% no-scroll)
  void _showFaqModal(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        PhosphorIconsRegular.question,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tanya Jawab Lisensi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Hal yang sering ditanyakan calon pengantin seputar aktivasi aplikasi Nikahin.',
                  style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: Column(
                      children: [
                        _buildFaqItem(
                          theme: theme,
                          question: 'Apakah pasangan saya perlu membayar lagi?',
                          answer:
                              'Tidak perlu. Cukup 1 kali pembelian untuk satu pernikahan. Setelah aktif, pasanganmu bisa langsung masuk lewat kode undangan tanpa biaya tambahan.',
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildFaqItem(
                          theme: theme,
                          question: 'Bagaimana jika acara kami masih tahun depan?',
                          answer:
                              'Akses akun aktif selamanya tanpa batas waktu dan tanpa tagihan bulanan. Kamu bisa merencanakan setiap detail pernikahan kapan saja dengan tenang.',
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildFaqItem(
                          theme: theme,
                          question: 'Apakah data tetap aman jika berganti HP?',
                          answer:
                              'Semua data anggaran, vendor, dan daftar tamu tersimpan otomatis di akunmu. Kamu cukup masuk kembali dengan email yang sama di ponsel baru.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFaqItem({
    required ThemeData theme,
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(),
      collapsedShape: const RoundedRectangleBorder(),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
      iconColor: theme.colorScheme.primary,
      collapsedIconColor: theme.colorScheme.onSurfaceVariant,
      title: Text(
        question,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitRow({
    required ThemeData theme,
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 1.5),
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            PhosphorIconsBold.check,
            size: 10,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCouplePairingBanner(BuildContext context, ThemeData theme) {
    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE11D48).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  PhosphorIconsFill.heart,
                  color: Color(0xFFE11D48),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Punya Undangan dari Pasangan?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '1 lisensi aktif berlaku untuk 2 akun pengantin',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFFE11D48),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Jika pasangan Anda sudah memiliki lisensi Nikahin, hubungkan akun dengan kode pairing untuk bergabung tanpa biaya tambahan.',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => _showPairingCodeModal(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
              ),
            ),
            icon: const Icon(PhosphorIconsRegular.link, size: 18),
            label: const Text(
              'Masukkan Kode Pairing Pasangan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPairingCodeModal(BuildContext context) async {
    final theme = Theme.of(context);
    final codeController = TextEditingController();
    String selectedRole = 'BRIDE';
    String? localError;
    bool isClaiming = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(PhosphorIconsRegular.linkSimple, color: theme.colorScheme.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Hubungkan dengan Pasangan',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Masukkan 6 karakter kode undangan yang dibagikan oleh pasangan Anda.',
                    style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: codeController,
                    textCapitalization: TextCapitalization.characters,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3.5,
                    ),
                    maxLength: 12,
                    decoration: InputDecoration(
                      hintText: 'NK-XXXXXX',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.5,
                        color: theme.colorScheme.outlineVariant,
                      ),
                      counterText: '',
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: IconButton(
                        tooltip: 'Tempel kode',
                        icon: const Icon(PhosphorIconsRegular.clipboardText, size: 20),
                        onPressed: () async {
                          final data = await Clipboard.getData(Clipboard.kTextPlain);
                          final text = data?.text?.trim() ?? '';
                          if (text.isNotEmpty) {
                            codeController.text = text;
                            if (localError != null) {
                              setModalState(() => localError = null);
                            }
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                      ),
                    ),
                    onChanged: (val) {
                      if (localError != null) {
                        setModalState(() => localError = null);
                      }
                    },
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      localError!,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.error, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    'Anda sebagai',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(9),
                            onTap: () => setModalState(() => selectedRole = 'BRIDE'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedRole == 'BRIDE'
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: selectedRole == 'BRIDE'
                                    ? [
                                        BoxShadow(
                                          color: theme.brightness == Brightness.dark
                                              ? Colors.black.withValues(alpha: 0.3)
                                              : Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Mempelai Wanita',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: selectedRole == 'BRIDE' ? FontWeight.w600 : FontWeight.normal,
                                    color: selectedRole == 'BRIDE'
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(9),
                            onTap: () => setModalState(() => selectedRole = 'GROOM'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedRole == 'GROOM'
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: selectedRole == 'GROOM'
                                    ? [
                                        BoxShadow(
                                          color: theme.brightness == Brightness.dark
                                              ? Colors.black.withValues(alpha: 0.3)
                                              : Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Mempelai Pria',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: selectedRole == 'GROOM' ? FontWeight.w600 : FontWeight.normal,
                                    color: selectedRole == 'GROOM'
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: isClaiming
                        ? null
                        : () async {
                            final raw = codeController.text.trim();
                            if (raw.isEmpty) {
                              setModalState(() => localError = 'Silakan masukkan kode pairing.');
                              return;
                            }

                            setModalState(() {
                              localError = null;
                              isClaiming = true;
                            });

                            final auth = ref.read(authNotifierProvider);
                            final partnerUid = auth.userId ?? '';
                            final pairingService = ref.read(couplePairingServiceProvider);

                            final result = await pairingService.verifyAndClaimPairingCode(
                              rawCode: raw,
                              partnerRole: selectedRole,
                              partnerUid: partnerUid,
                            );

                            if (result.isSuccess) {
                              await ref.read(authNotifierProvider.notifier).refreshPartnerState();

                              final targetWeddingId = result.weddingId ?? ref.read(authNotifierProvider).activeWeddingId;
                              final db = ref.read(databaseProvider);
                              String? profileIdToOpen;

                              if (targetWeddingId != null && targetWeddingId.isNotEmpty) {
                                await AppPreferences.setActiveWeddingId(targetWeddingId);
                                await AppPreferences.setActiveProfileId(targetWeddingId);
                                await AppPreferences.setUserProfileId(partnerUid, targetWeddingId);
                                final p = await db.getProfileById(targetWeddingId);
                                if (p != null) profileIdToOpen = p.id;
                              }

                              if (profileIdToOpen == null) {
                                final allProfiles = await db.getAllProfiles();
                                if (allProfiles.isNotEmpty) {
                                  profileIdToOpen = allProfiles.first.id;
                                  await AppPreferences.setActiveProfileId(profileIdToOpen);
                                  await AppPreferences.setUserProfileId(partnerUid, profileIdToOpen);
                                }
                              }

                              if (modalContext.mounted) Navigator.of(modalContext).pop();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result.message),
                                    backgroundColor: const Color(0xFF059669),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                if (profileIdToOpen != null) {
                                  context.go('/wedding/$profileIdToOpen');
                                } else if (targetWeddingId != null && targetWeddingId.isNotEmpty) {
                                  context.go('/wedding/$targetWeddingId');
                                } else {
                                  context.go('/setup');
                                }
                              }
                            } else {
                              setModalState(() {
                                isClaiming = false;
                                localError = result.message;
                              });
                            }
                          },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: isClaiming
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(PhosphorIconsRegular.linkSimple, size: 20),
                    label: Text(
                      isClaiming ? 'Menghubungkan...' : 'Hubungkan',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
                      PhosphorIconsFill.checkCircle,
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

