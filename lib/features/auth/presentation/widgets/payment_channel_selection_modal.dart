import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../domain/models/midtrans_core_models.dart';
import '../../../../shared/widgets/bento_card.dart';

/// Modal bottom sheet untuk memilih metode pembayaran Midtrans Core API (Luxury Bento Edition)
class PaymentChannelSelectionModal extends StatefulWidget {
  final ValueChanged<PaymentChannel> onChannelSelected;

  const PaymentChannelSelectionModal({
    super.key,
    required this.onChannelSelected,
  });

  static Future<PaymentChannel?> show(BuildContext context) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet<PaymentChannel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaymentChannelSelectionModal(
        onChannelSelected: (channel) => Navigator.of(ctx).pop(channel),
      ),
    );
  }

  @override
  State<PaymentChannelSelectionModal> createState() => _PaymentChannelSelectionModalState();
}

class _PaymentChannelSelectionModalState extends State<PaymentChannelSelectionModal> {
  int _selectedFilterIndex = 0; // 0: Semua, 1: QRIS, 2: Virtual Account, 3: E-Wallet

  final List<String> _categories = ['Semua', '⚡ QRIS', '🏦 Virtual Account', '📱 E-Wallet'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredChannels = _getFilteredChannels();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).viewPadding.bottom + 16,
        left: 20,
        right: 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Metode Pembayaran',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, size: 13, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          'Midtrans Official • Otomatis & Terverifikasi',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Category Chips / Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedFilterIndex = index);
                      }
                    },
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                    ),
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    showCheckmark: false,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),

          // Scrollable list of payment channels
          Expanded(
            child: ListView.separated(
              itemCount: filteredChannels.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final channel = filteredChannels[index];
                return _buildChannelCard(
                  context: context,
                  channel: channel,
                  isHighlight: channel == PaymentChannel.qris,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<PaymentChannel> _getFilteredChannels() {
    switch (_selectedFilterIndex) {
      case 1:
        return [PaymentChannel.qris];
      case 2:
        return [
          PaymentChannel.bcaVa,
          PaymentChannel.mandiriBill,
          PaymentChannel.briVa,
          PaymentChannel.bniVa,
          PaymentChannel.permataVa,
        ];
      case 3:
        return [
          PaymentChannel.gopay,
          PaymentChannel.shopeepay,
        ];
      default:
        return [
          PaymentChannel.qris,
          PaymentChannel.bcaVa,
          PaymentChannel.mandiriBill,
          PaymentChannel.briVa,
          PaymentChannel.bniVa,
          PaymentChannel.permataVa,
          PaymentChannel.gopay,
          PaymentChannel.shopeepay,
        ];
    }
  }

  Widget _buildChannelCard({
    required BuildContext context,
    required PaymentChannel channel,
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    final brandColor = _getBrandColor(channel);

    return BentoCard(
      padding: EdgeInsets.zero,
      gradient: isHighlight
          ? LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                theme.colorScheme.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onChannelSelected(channel);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              // Icon container with specific brand styling
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: brandColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Icon(
                  channel.icon,
                  color: brandColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Title, Subtitle, & Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            channel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: channel.badgeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            channel.badge,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: channel.badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            channel.subtitle,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Bebas Biaya',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBrandColor(PaymentChannel channel) {
    switch (channel) {
      case PaymentChannel.qris:
        return const Color(0xFFC8102E); // QRIS Red
      case PaymentChannel.bcaVa:
        return const Color(0xFF005EAA); // BCA Blue
      case PaymentChannel.mandiriBill:
        return const Color(0xFF003D79); // Mandiri Deep Blue
      case PaymentChannel.briVa:
        return const Color(0xFF00529C); // BRI Blue
      case PaymentChannel.bniVa:
        return const Color(0xFFF15A24); // BNI Orange
      case PaymentChannel.permataVa:
        return const Color(0xFF008080); // Permata Teal
      case PaymentChannel.gopay:
        return const Color(0xFF00AA13); // GoPay Green
      case PaymentChannel.shopeepay:
        return const Color(0xFFEE4D2D); // ShopeePay Orange
    }
  }
}
