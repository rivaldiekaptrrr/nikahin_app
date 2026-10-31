import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/utils/date_utils.dart';

/// Kartu Hero Hitung Mundur D-Day (Opsi A - Backup Penuh).
/// Menampilkan nama pasangan di tengah, tanggal beraksen hangat, strip kalender lingkaran interaktif, dan hitung mundur.
class DashboardDDayHeroCardOptionA extends StatefulWidget {
  final String profileId;
  final WeddingProfile profile;

  const DashboardDDayHeroCardOptionA({
    super.key,
    required this.profileId,
    required this.profile,
  });

  @override
  State<DashboardDDayHeroCardOptionA> createState() => _DashboardDDayHeroCardOptionAState();
}

class _DashboardDDayHeroCardOptionAState extends State<DashboardDDayHeroCardOptionA> {
  late DateTime _anchorDate;

  @override
  void initState() {
    super.initState();
    _initAnchorDate();
  }

  @override
  void didUpdateWidget(covariant DashboardDDayHeroCardOptionA oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.weddingDate != widget.profile.weddingDate) {
      _initAnchorDate();
    }
  }

  void _initAnchorDate() {
    if (widget.profile.weddingDate > 0) {
      _anchorDate = DateTime.fromMillisecondsSinceEpoch(widget.profile.weddingDate);
    } else {
      _anchorDate = DateTime.now();
    }
  }

  String _getShortDayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Sen';
      case DateTime.tuesday:
        return 'Sel';
      case DateTime.wednesday:
        return 'Rab';
      case DateTime.thursday:
        return 'Kam';
      case DateTime.friday:
        return 'Jum';
      case DateTime.saturday:
        return 'Sab';
      case DateTime.sunday:
        return 'Min';
      default:
        return '';
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final weddingDateTime = widget.profile.weddingDate > 0
        ? DateTime.fromMillisecondsSinceEpoch(widget.profile.weddingDate)
        : DateTime.now();

    final groom = widget.profile.groomName.trim();
    final bride = widget.profile.brideName.trim();
    final names = (groom.isNotEmpty && bride.isNotEmpty)
        ? '$groom & $bride'
        : (groom.isNotEmpty
            ? groom
            : (bride.isNotEmpty ? bride : 'Calon Pengantin'));

    final formattedWeddingDate =
        DateFormat('d MMMM yyyy', 'id_ID').format(weddingDateTime);

    final days = WeddingDateUtils.daysUntil(widget.profile.weddingDate);
    final daysText = days == 0
        ? 'Hari Pernikahan Hari Ini! 💍'
        : (days > 0
            ? '$days Hari Menuju Hari Bahagia'
            : '${days.abs()} Hari Telah Berlalu');

    // 5 hari berurutan berpusat pada _anchorDate
    final dateItems = List.generate(
      5,
      (index) => _anchorDate.add(Duration(days: index - 2)),
    );

    final isAtWeddingDate = _isSameDay(_anchorDate, weddingDateTime);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    theme.colorScheme.surfaceContainer,
                    theme.colorScheme.surfaceContainerHigh,
                  ]
                : [
                    const Color(0xFFFBF8F4),
                    const Color(0xFFF4EDE4),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ==================== 1. HEADER: NAMA PASANGAN & IKON KALENDER ====================
            Stack(
              alignment: Alignment.center,
              children: [
                // Nama Pasangan di Tengah
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.go('/wedding/${widget.profileId}/settings');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 4),
                    child: Column(
                      children: [
                        Text(
                          names,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedWeddingDate,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE07A5F),
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Ikon Kalender di Kanan Atas
                Positioned(
                  right: 0,
                  top: 0,
                  child: Tooltip(
                    message: isAtWeddingDate
                        ? 'Buka Kalender'
                        : 'Kembali ke Hari H',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          HapticFeedback.selectionClick();
                          if (!isAtWeddingDate) {
                            setState(() {
                              _anchorDate = weddingDateTime;
                            });
                          } else {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _anchorDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                              locale: const Locale('id', 'ID'),
                            );
                            if (picked != null && mounted) {
                              setState(() {
                                _anchorDate = picked;
                              });
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? theme.colorScheme.surface
                                : Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE07A5F)
                                  .withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isAtWeddingDate
                                ? Icons.calendar_month_rounded
                                : Icons.restore_rounded,
                            size: 20,
                            color: const Color(0xFFE07A5F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ==================== 2. STRIP LINGKARAN TANGGAL ====================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol Panah Kiri (<)
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  iconSize: 24,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  color: theme.colorScheme.onSurfaceVariant,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _anchorDate =
                          _anchorDate.subtract(const Duration(days: 1));
                    });
                  },
                ),

                // Deretan 5 Lingkaran Tanggal
                ...dateItems.map((date) {
                  final isCenter = _isSameDay(date, _anchorDate);
                  final isWeddingDay = _isSameDay(date, weddingDateTime);

                  return _buildDateCircle(
                    context: context,
                    theme: theme,
                    isDark: isDark,
                    date: date,
                    isCenter: isCenter,
                    isWeddingDay: isWeddingDay,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _anchorDate = date;
                      });
                    },
                  );
                }),

                // Tombol Panah Kanan (>)
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  iconSize: 24,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  color: theme.colorScheme.onSurfaceVariant,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _anchorDate = _anchorDate.add(const Duration(days: 1));
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ==================== 3. STATUS HITUNG MUNDUR & INFO HARI H ====================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surface
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    daysText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // ==================== 4. KUTIPAN ROMANTIS / DOA ====================
            if (widget.profile.quoteEnabled &&
                widget.profile.quote != null &&
                widget.profile.quote!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surface
                      : Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Text(
                  '"${widget.profile.quote}"',
                  textAlign: TextAlign.center,
                  style: _resolveQuoteStyle(widget.profile).copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateCircle({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required DateTime date,
    required bool isCenter,
    required bool isWeddingDay,
    required VoidCallback onTap,
  }) {
    final dayNum = DateFormat('d', 'id_ID').format(date);
    final dayName = _getShortDayName(date);

    final size = isCenter ? 58.0 : 44.0;
    final primaryColor = theme.colorScheme.primary;

    Color bgColor;
    if (isCenter) {
      bgColor = isDark ? theme.colorScheme.surface : Colors.white;
    } else {
      bgColor = isDark
          ? theme.colorScheme.surface.withValues(alpha: 0.6)
          : Colors.white.withValues(alpha: 0.75);
    }

    Border? border;
    if (isCenter) {
      border = Border.all(
        color: isWeddingDay ? const Color(0xFFE07A5F) : primaryColor,
        width: 1.8,
      );
    } else if (isWeddingDay) {
      border = Border.all(
        color: const Color(0xFFE07A5F).withValues(alpha: 0.5),
        width: 1.2,
      );
    } else {
      border = Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        width: 1,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
          boxShadow: isCenter
              ? [
                  BoxShadow(
                    color: isWeddingDay
                        ? const Color(0xFFE07A5F).withValues(alpha: 0.2)
                        : primaryColor.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayNum,
              style: TextStyle(
                fontSize: isCenter ? 17 : 12.5,
                fontWeight: isCenter ? FontWeight.w900 : FontWeight.w600,
                color: isCenter
                    ? (isWeddingDay
                        ? const Color(0xFFE07A5F)
                        : theme.colorScheme.onSurface)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.85),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dayName,
              style: TextStyle(
                fontSize: isCenter ? 11 : 9.5,
                fontWeight: isCenter ? FontWeight.w700 : FontWeight.w500,
                color: isCenter
                    ? (isWeddingDay
                        ? const Color(0xFFE07A5F)
                        : primaryColor)
                    : theme.colorScheme.onSurfaceVariant,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _resolveQuoteStyle(WeddingProfile profile) {
    double fontSize = 13.0;
    if (profile.quoteFontSize == 'KECIL') fontSize = 11.0;
    if (profile.quoteFontSize == 'BESAR') fontSize = 15.0;

    FontWeight fontWeight = FontWeight.normal;
    FontStyle fontStyle = FontStyle.normal;

    switch (profile.quoteFontStyle) {
      case 'BOLD':
        fontWeight = FontWeight.bold;
        break;
      case 'ITALIC':
        fontStyle = FontStyle.italic;
        break;
      case 'BOLD_ITALIC':
        fontWeight = FontWeight.bold;
        fontStyle = FontStyle.italic;
        break;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: 1.35,
    );
  }
}
