import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../../../../app/config/business_config.dart';
import '../../../../domain/models/midtrans_core_models.dart';
import '../../../../shared/utils/currency_utils.dart';
import '../../../../shared/widgets/bento_card.dart';
import 'payment_brand_badge.dart';

/// Modal pemilihan metode pembayaran Midtrans Core API (Standar Produksi Fintech & Bento Grid)
class PaymentChannelSelectionModal extends StatefulWidget {
  final ValueChanged<PaymentChannel> onChannelSelected;
  final PaymentChannel? initialChannel;

  const PaymentChannelSelectionModal({
    super.key,
    required this.onChannelSelected,
    this.initialChannel,
  });

  static Future<PaymentChannel?> show(
    BuildContext context, {
    PaymentChannel? initialChannel,
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet<PaymentChannel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaymentChannelSelectionModal(
        initialChannel: initialChannel,
        onChannelSelected: (channel) => Navigator.of(ctx).pop(channel),
      ),
    );
  }

  @override
  State<PaymentChannelSelectionModal> createState() => _PaymentChannelSelectionModalState();
}

class _PaymentChannelSelectionModalState extends State<PaymentChannelSelectionModal> {
  late PaymentChannel _selectedChannel;

  // Status expand/collapse seksi
  bool _isRecommendedExpanded = true;
  bool _isVaExpanded = true;
  bool _isEwalletExpanded = true;
  bool _isUpcomingExpanded = false;

  @override
  void initState() {
    super.initState();
    // Default pilihan ke GoPay atau initialChannel
    _selectedChannel = widget.initialChannel ?? PaymentChannel.gopay;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metode Pembayaran',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pilih metode pembayaran yang paling nyaman untukmu',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  icon: const Icon(PhosphorIconsRegular.x, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Divider lembut
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),

          // Scrollable Daftar Metode Pembayaran (Collapsible Categories)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              children: [
                // 1. REKOMENDASI PEMBAYARAN (AKTIF LIVE)
                _buildSectionHeader(
                  title: 'Rekomendasi Pembayaran',
                  isExpanded: _isRecommendedExpanded,
                  onToggle: () => setState(() => _isRecommendedExpanded = !_isRecommendedExpanded),
                  theme: theme,
                ),
                if (_isRecommendedExpanded) ...[
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(
                    channel: PaymentChannel.gopay,
                    theme: theme,
                  ),
                  const SizedBox(height: 14),
                ],

                // 2. VIRTUAL ACCOUNT OTOMATIS 24 JAM
                _buildSectionHeader(
                  title: 'Virtual Account (Otomatis 24 Jam)',
                  isExpanded: _isVaExpanded,
                  onToggle: () => setState(() => _isVaExpanded = !_isVaExpanded),
                  theme: theme,
                ),
                if (_isVaExpanded) ...[
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.briVa, theme: theme),
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.mandiriBill, theme: theme),
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.bniVa, theme: theme),
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.permataVa, theme: theme),
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.cimbVa, theme: theme),
                  const SizedBox(height: 14),
                ],

                // 3. PEMBAYARAN INSTAN & QRIS
                _buildSectionHeader(
                  title: 'Dompet Digital & QRIS',
                  isExpanded: _isEwalletExpanded,
                  onToggle: () => setState(() => _isEwalletExpanded = !_isEwalletExpanded),
                  theme: theme,
                ),
                if (_isEwalletExpanded) ...[
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.qris, theme: theme),
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.shopeepay, theme: theme),
                  const SizedBox(height: 14),
                ],

                // 4. SALURAN DALAM PROSES AKTIVASI
                _buildSectionHeader(
                  title: 'Segera Hadir',
                  isExpanded: _isUpcomingExpanded,
                  onToggle: () => setState(() => _isUpcomingExpanded = !_isUpcomingExpanded),
                  theme: theme,
                ),
                if (_isUpcomingExpanded) ...[
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.bcaVa, theme: theme),
                  const SizedBox(height: 8),
                  _buildChannelIslandCard(channel: PaymentChannel.bsiVa, theme: theme),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),

          // Sticky Bottom Bar (Total Pembayaran & Tombol Lanjutkan)
          _buildStickyBottomBar(theme),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onToggle();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: -0.2,
              ),
            ),
            Icon(
              isExpanded ? PhosphorIconsRegular.caretUp : PhosphorIconsRegular.caretDown,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelIslandCard({
    required PaymentChannel channel,
    required ThemeData theme,
    String? recommendedBadge,
  }) {
    final isSelected = _selectedChannel == channel;
    final isAvailable = channel.isAvailable;
    final isDark = theme.brightness == Brightness.dark;

    final card = BentoCard(
      padding: EdgeInsets.zero,
      backgroundColor: isDark ? theme.colorScheme.surfaceContainerHigh : Colors.white,
      border: Border.all(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant.withValues(alpha: isDark ? 0.3 : 0.45),
        width: isSelected ? 1.6 : 1.0,
      ),
      borderRadius: 16,
      child: InkWell(
        onTap: isAvailable
            ? () {
                HapticFeedback.selectionClick();
                setState(() => _selectedChannel = channel);
              }
            : () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Metode ${channel.name} sedang dalam proses aktivasi Midtrans dan akan segera hadir.',
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Logo Resmi Tanpa Kotak Pembungkus
              PaymentBrandBadge(
                channel: channel,
                size: 40,
              ),
              const SizedBox(width: 14),

              // Info & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            channel.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: isAvailable
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (recommendedBadge != null && isAvailable) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              recommendedBadge,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ] else if (!isAvailable) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Segera',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      channel.subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: isAvailable ? 1.0 : 0.6,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Radio Button Elegan (Nikahin Theme Dynamic)
              if (isAvailable)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
                      width: isSelected ? 6.5 : 1.5,
                    ),
                    color: Colors.white,
                  ),
                )
              else
                Icon(
                  PhosphorIconsRegular.lockSimple,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ),
    );

    if (!isAvailable) {
      return Opacity(
        opacity: 0.62,
        child: card,
      );
    }
    return card;
  }

  Widget _buildStickyBottomBar(ThemeData theme) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: bottomInset > 0 ? bottomInset + 8 : 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total Pembayaran
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    PhosphorIconsRegular.info,
                    size: 13,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                CurrencyUtils.formatRupiah(BusinessConfig.lifetimePrice),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          // Tombol Pilih / Lanjutkan
          FilledButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              widget.onChannelSelected(_selectedChannel);
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lanjutkan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 6),
                Icon(PhosphorIconsRegular.arrowRight, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
