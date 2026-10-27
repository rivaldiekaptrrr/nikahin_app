import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/services/couple_pairing_service.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/whatsapp_logo.dart';
import '../../../auth/presentation/auth_notifier.dart';

class CoupleConnectCard extends ConsumerStatefulWidget {
  final WeddingProfile profile;

  const CoupleConnectCard({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<CoupleConnectCard> createState() => _CoupleConnectCardState();
}

class _CoupleConnectCardState extends ConsumerState<CoupleConnectCard> {
  PairingCodeData? _activePairingCode;
  bool _isGeneratingCode = false;
  bool _isClaimingCode = false;
  bool _isUnlinking = false;

  Future<void> _generateCode() async {
    final auth = ref.read(authNotifierProvider);
    final uid = auth.userId;
    if (uid == null) return;

    setState(() => _isGeneratingCode = true);
    try {
      final pairingService = ref.read(couplePairingServiceProvider);
      final weddingId = auth.activeWeddingId ?? widget.profile.id;
      final role = widget.profile.groomName.isNotEmpty ? 'GROOM' : 'BRIDE';

      final codeData = await pairingService.generatePairingCode(
        creatorUid: uid,
        creatorName: auth.displayName ?? 'Pasangan Anda',
        weddingId: weddingId,
        creatorRole: role,
      );

      if (mounted) {
        setState(() {
          _activePairingCode = codeData;
        });
        if (codeData != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Kode pairing ${CouplePairingService.formatCodeForDisplay(codeData.code)} berhasil dibuat!',
              ),
              backgroundColor: const Color(0xFF059669),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Gagal membuat kode pairing. Periksa koneksi internet.'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isGeneratingCode = false);
    }
  }

  void _shareViaWhatsApp(String code) async {
    final formattedCode = CouplePairingService.formatCodeForDisplay(code);
    final message = 'Halo sayang! Ayo rencanakan pernikahan kita bersama di aplikasi Nikahin. '
        'Gunakan kode pairing undangan kita: $formattedCode saat membuka aplikasi untuk sinkronisasi workspace kita ❤️💍';

    final whatsappUrl = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        await SharePlus.instance.share(
          ShareParams(
            text: message,
            subject: 'Undangan Co-Planner Nikahin App',
          ),
        );
      }
    } catch (_) {
      await SharePlus.instance.share(
        ShareParams(
          text: message,
          subject: 'Undangan Co-Planner Nikahin App',
        ),
      );
    }
  }

  Future<void> _showEnterCodeDialog() async {
    final theme = Theme.of(context);
    final codeController = TextEditingController();
    String selectedRole = 'BRIDE';
    String? localError;

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
                          color: const Color(0xFFE11D48).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.favorite_rounded, color: Color(0xFFE11D48), size: 20),
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
                    'Masukkan 6 karakter kode undangan yang dibuat oleh pasangan Anda.',
                    style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),

                  // Input Kode Pairing
                  TextField(
                    controller: codeController,
                    textCapitalization: TextCapitalization.characters,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4.0,
                    ),
                    maxLength: 9,
                    decoration: InputDecoration(
                      hintText: 'NK-XXXXXX',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        color: theme.colorScheme.outlineVariant,
                      ),
                      counterText: '',
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const SizedBox(height: 14),

                  // Pilihan Peran
                  const Text(
                    'Peran Anda:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Pengantin Wanita 👰')),
                          selected: selectedRole == 'BRIDE',
                          onSelected: (val) {
                            if (val) setModalState(() => selectedRole = 'BRIDE');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Pengantin Pria 🤵')),
                          selected: selectedRole == 'GROOM',
                          onSelected: (val) {
                            if (val) setModalState(() => selectedRole = 'GROOM');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tombol Verifikasi
                  FilledButton.icon(
                    onPressed: _isClaimingCode
                        ? null
                        : () async {
                            final raw = codeController.text.trim();
                            if (raw.isEmpty) {
                              setModalState(() => localError = 'Silakan masukkan kode pairing.');
                              return;
                            }

                            setModalState(() => localError = null);
                            setState(() => _isClaimingCode = true);

                            final auth = ref.read(authNotifierProvider);
                            final partnerUid = auth.userId ?? '';
                            final pairingService = ref.read(couplePairingServiceProvider);

                            final result = await pairingService.verifyAndClaimPairingCode(
                              rawCode: raw,
                              partnerUid: partnerUid,
                              partnerRole: selectedRole,
                            );

                            setState(() => _isClaimingCode = false);

                            if (result.isSuccess) {
                              await ref.read(authNotifierProvider.notifier).refreshPartnerState();
                              if (modalContext.mounted) Navigator.of(modalContext).pop();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result.message),
                                    backgroundColor: const Color(0xFF059669),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } else {
                              setModalState(() => localError = result.message);
                            }
                          },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: _isClaimingCode
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.link_rounded, size: 20),
                    label: Text(
                      _isClaimingCode ? 'Menghubungkan...' : 'Verifikasi & Hubungkan',
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

  Future<void> _confirmUnlink() async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.link_off_rounded, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            const Text('Putuskan Tautan?'),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin memutuskan sinkronisasi dengan pasangan? Anda dapat menghubungkan kembali akun kapan saja.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            child: const Text('Putuskan'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isUnlinking = true);
    try {
      final auth = ref.read(authNotifierProvider);
      final pairingService = ref.read(couplePairingServiceProvider);
      await pairingService.unlinkPartner(
        currentUid: auth.userId ?? '',
        partnerUid: auth.partnerOfUid ?? '',
        weddingId: auth.activeWeddingId ?? widget.profile.id,
      );

      await ref.read(authNotifierProvider.notifier).refreshPartnerState();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tautan dengan pasangan berhasil diputuskan.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUnlinking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final isLinked = authState.isPartnerLinked;

    if (isLinked) {
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
                    color: const Color(0xFF059669).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.favorite_rounded, color: Color(0xFF059669), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Pasangan Terhubung',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF059669),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        authState.coupleRole == 'GROOM'
                            ? 'Peran: Pengantin Pria 🤵'
                            : 'Peran: Pengantin Wanita 👰',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sync_rounded, size: 16, color: Color(0xFF059669)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Perencanaan pernikahan (anggaran, rundown, buku tamu) disinkronkan secara real-time antar perangkat.',
                      style: TextStyle(fontSize: 11.5, color: theme.colorScheme.onSurfaceVariant, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isUnlinking ? null : _confirmUnlink,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.5)),
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: _isUnlinking
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.link_off_rounded, size: 16),
              label: Text(_isUnlinking ? 'Memutuskan...' : 'Putuskan Tautan Pasangan'),
            ),
          ],
        ),
      );
    }

    // State: Belum Terhubung
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
                child: const Icon(Icons.favorite_rounded, color: Color(0xFFE11D48), size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajak Pasangan Jadi Co-Planner',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '1 lisensi berlaku untuk 2 akun pengantin',
                      style: TextStyle(fontSize: 12, color: Color(0xFFE11D48), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Bagikan kode unik agar pasangan Anda dapat mengelola anggaran, vendor, rundown, dan tamu bersama tanpa biaya tambahan.',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 14),

          // Tampilkan Kode Pairing Aktif jika sudah di-generate
          if (_activePairingCode != null && _activePairingCode!.isActive) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        CouplePairingService.formatCodeForDisplay(_activePairingCode!.code),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4.0,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        tooltip: 'Salin Kode',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _activePairingCode!.code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kode pairing disalin ke papan klip.'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Berlaku hingga 48 jam ke depan',
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => _shareViaWhatsApp(_activePairingCode!.code),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const WhatsAppLogo(size: 18),
              label: const Text(
                'Kirim Kode ke WhatsApp Pasangan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 6),
          ] else ...[
            FilledButton.icon(
              onPressed: _isGeneratingCode ? null : _generateCode,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isGeneratingCode
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.qr_code_rounded, size: 18),
              label: Text(
                _isGeneratingCode ? 'Membuat Kode...' : 'Buat Kode Undangan Pasangan',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],

          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _showEnterCodeDialog,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(42),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.input_rounded, size: 16),
            label: const Text(
              'Punya Kode dari Pasangan? Masukkan di Sini',
              style: TextStyle(fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}
