import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/enums/wedding_enums.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/status_chip.dart';

/// Kartu Tamu Interaktif dengan Gesture-Driven Swipe Actions berstandar Appllama High-Fidelity.
/// - Swipe Kanan: Langsung tandai Hadir / Attending (disertai haptic feedback).
/// - Swipe Kiri: Buka template WhatsApp RSVP jika nomor telepon tersedia.
/// - Tap: Ubah status RSVP melalui Quick Picker Modal.
class GuestListItemCard extends StatelessWidget {
  final WeddingGuest guest;
  final VoidCallback onTap;
  final ValueChanged<String> onRsvpChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GuestListItemCard({
    super.key,
    required this.guest,
    required this.onTap,
    required this.onRsvpChanged,
    required this.onEdit,
    required this.onDelete,
  });

  Future<void> _sendWhatsAppMessage(BuildContext context) async {
    final phone = guest.phoneNumber?.trim() ?? '';
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tamu ini belum memiliki nomor telepon WhatsApp.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    }

    final message =
        'Halo ${guest.guestName}, dengan penuh rasa bahagia kami mengundang Anda untuk hadir di acara pernikahan kami. '
        'Mohon konfirmasi kehadiran Anda melalui tautan undangan ini. Terima kasih!';

    final uri = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}');

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka aplikasi WhatsApp.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membuka WhatsApp. Pastikan aplikasi terpasang.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionLabel = SessionTarget.fromString(guest.sessionTarget).label;
    final isVip = guest.groupAllocation == 'VIP';
    final isAttending = guest.rsvpStatus == 'ATTENDING';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey('guest_${guest.guestId}'),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Swipe Kanan -> Toggle Status Hadir
            HapticFeedback.mediumImpact();
            final newStatus = isAttending ? 'PENDING' : 'ATTENDING';
            onRsvpChanged(newStatus);
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  newStatus == 'ATTENDING'
                      ? '✓ "${guest.guestName}" ditandai Hadir'
                      : 'Status "${guest.guestName}" diubah ke Menunggu Konfirmasi',
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
            return false; // Jangan hapus dari list, hanya trigger aksi
          } else if (direction == DismissDirection.endToStart) {
            // Swipe Kiri -> WhatsApp Action
            HapticFeedback.lightImpact();
            await _sendWhatsAppMessage(context);
            return false;
          }
          return false;
        },
        background: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF059669), // Emerald
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                isAttending ? Icons.replay_rounded : Icons.check_circle_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isAttending ? 'Ubah ke Menunggu' : 'Tandai Hadir',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF25D366), // WhatsApp Green
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Kirim WhatsApp',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 22),
            ],
          ),
        ),
        child: BentoCard(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Avatar Circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isVip
                      ? const Color(0xFFFEF3C7)
                      : theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isVip ? Icons.star_rounded : Icons.person_rounded,
                  size: 20,
                  color: isVip ? const Color(0xFFD97706) : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),

              // Middle Column: Guest info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            guest.guestName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVip) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'VIP',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${guest.estimatedPax} Pax',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            guest.phoneNumber ?? 'Tanpa nomor',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('•', style: TextStyle(color: Colors.grey[400])),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            sessionLabel,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Status Chip
              StatusChip(status: guest.rsvpStatus),

              // Popup Menu
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, size: 18, color: theme.colorScheme.outline),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                onSelected: (action) {
                  if (action == 'edit') {
                    onEdit();
                  } else if (action == 'wa') {
                    _sendWhatsAppMessage(context);
                  } else if (action == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'wa',
                    child: Row(
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF25D366)),
                        SizedBox(width: 8),
                        Text('Kirim WhatsApp'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 16),
                        SizedBox(width: 8),
                        Text('Edit Data'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
