import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../../../../data/repositories/wedding_repository.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/utils/date_utils.dart';
import '../../../../shared/widgets/app_svg_logo.dart';
import '../hero_cover_controller.dart';

/// Kartu Hero Hitung Mundur D-Day berstandar Appllama High-Fidelity (Opsi B).
/// Menampilkan nama pasangan di tengah, tanggal beraksen hangat, strip kalender lingkaran interaktif,
/// panel fokus agenda/hitung mundur yang dinamis, serta personalisasi foto latar belakang.
class DashboardDDayHeroCard extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingProfile profile;

  const DashboardDDayHeroCard({
    super.key,
    required this.profileId,
    required this.profile,
  });

  @override
  ConsumerState<DashboardDDayHeroCard> createState() => _DashboardDDayHeroCardState();
}

class _DashboardDDayHeroCardState extends ConsumerState<DashboardDDayHeroCard> {
  late DateTime _anchorDate;

  @override
  void initState() {
    super.initState();
    _initAnchorDate();
  }

  void _initAnchorDate() {
    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);
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

  void _showPhotoOptions(BuildContext context, bool hasCustomPhoto) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        final sheetTheme = Theme.of(bottomSheetContext);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: sheetTheme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Foto Latar Kartu Utama',
                  style: sheetTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Personalisasi kartu hitung mundur dengan foto momen berdua favoritmu.',
                  style: sheetTheme.textTheme.bodySmall?.copyWith(
                    color: sheetTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: sheetTheme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(PhosphorIconsRegular.image, color: sheetTheme.colorScheme.primary),
                  ),
                  title: const Text('Pilih Foto dari Galeri', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Gunakan foto prewedding atau foto berdua'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    final success = await ref
                        .read(heroCoverNotifierProvider(widget.profileId).notifier)
                        .pickAndSavePhoto(ImageSource.gallery);
                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Foto latar berhasil diperbarui')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: sheetTheme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(PhosphorIconsRegular.camera, color: sheetTheme.colorScheme.primary),
                  ),
                  title: const Text('Ambil Foto dengan Kamera', style: TextStyle(fontWeight: FontWeight.w600)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);
                    final success = await ref
                        .read(heroCoverNotifierProvider(widget.profileId).notifier)
                        .pickAndSavePhoto(ImageSource.camera);
                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Foto latar berhasil diperbarui')),
                      );
                    }
                  },
                ),
                if (hasCustomPhoto) ...[
                  const SizedBox(height: 4),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: sheetTheme.colorScheme.errorContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(PhosphorIconsRegular.trash, color: sheetTheme.colorScheme.error),
                    ),
                    title: Text(
                      'Hapus Foto (Gunakan Tema Bawaan)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: sheetTheme.colorScheme.error,
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () async {
                      Navigator.pop(bottomSheetContext);
                      await ref
                          .read(heroCoverNotifierProvider(widget.profileId).notifier)
                          .removePhoto();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kembali ke tampilan tema bawaan')),
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final repo = ref.watch(weddingRepositoryProvider);

    final coverAsync = ref.watch(heroCoverNotifierProvider(widget.profileId));
    final coverPhotoPath = coverAsync.value;
    final hasCustomPhoto = coverPhotoPath != null && coverPhotoPath.isNotEmpty;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final weddingDateTime = widget.profile.weddingDate > 0
        ? DateTime.fromMillisecondsSinceEpoch(widget.profile.weddingDate)
        : today.add(const Duration(days: 90));

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
    final String countdownTag;
    if (days == 0) {
      countdownTag = 'Hari H! 💍';
    } else if (days > 0) {
      countdownTag = 'H-$days';
    } else {
      countdownTag = 'H+${days.abs()}';
    }

    // 5 hari berurutan berpusat pada _anchorDate (default: Hari Ini)
    final dateItems = List.generate(
      5,
      (index) => _anchorDate.add(Duration(days: index - 2)),
    );

    final isAtToday = _isSameDay(_anchorDate, today);

    return StreamBuilder<List<WeddingEvent>>(
      stream: repo.watchEvents(widget.profileId),
      builder: (context, snapshot) {
        final events = snapshot.data ?? [];

        // Cari acara yang jatuh pada _anchorDate
        final eventsOnSelectedDate = events.where((e) {
          final eDt = DateTime.fromMillisecondsSinceEpoch(e.eventDate);
          return _isSameDay(eDt, _anchorDate);
        }).toList();

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hasCustomPhoto
                  ? Colors.white.withValues(alpha: 0.22)
                  : theme.colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.14),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // ==================== LAYER 0: BACKGROUND (FOTO ATAU GRADASI HANGAT + WATERMARK) ====================
                if (hasCustomPhoto) ...[
                  Positioned.fill(
                    child: kIsWeb
                        ? Image.network(
                            coverPhotoPath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildDefaultGradient(theme, isDark),
                          )
                        : Image.file(
                            File(coverPhotoPath),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildDefaultGradient(theme, isDark),
                          ),
                  ),
                  // Dark Vignette & Scrim Gradient Overlay untuk menjaga keterbacaan teks
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.52),
                            Colors.black.withValues(alpha: 0.35),
                            Colors.black.withValues(alpha: 0.68),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Positioned.fill(
                    child: _buildDefaultGradient(theme, isDark),
                  ),
                  // Watermark Vektor Simbol Master Nikahin (Subtle Brand Identity)
                  Positioned(
                    top: -24,
                    right: -24,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: isDark ? 0.08 : 0.065,
                        child: Transform.rotate(
                          angle: -0.18,
                          child: const NikahinSvgLogo.master(
                            width: 155,
                            height: 155,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // ==================== LAYER 1: KONTEN KARTU ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      // ==================== 1. HEADER: NAMA PASANGAN & TANGGAL PERNIKAHAN ====================
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.go('/wedding/${widget.profileId}/settings');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 4),
                          child: Column(
                            children: [
                              Text(
                                names,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  color: hasCustomPhoto
                                      ? Colors.white
                                      : theme.colorScheme.onSurface,
                                  shadows: hasCustomPhoto
                                      ? [
                                          Shadow(
                                            color: Colors.black.withValues(alpha: 0.6),
                                            blurRadius: 6,
                                            offset: const Offset(0, 1.5),
                                          ),
                                        ]
                                      : null,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                formattedWeddingDate,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: hasCustomPhoto
                                      ? const Color(0xFFFDF0DE)
                                      : const Color(0xFFD97757),
                                  letterSpacing: 0.3,
                                  shadows: hasCustomPhoto
                                      ? [
                                          Shadow(
                                            color: Colors.black.withValues(alpha: 0.5),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : null,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ==================== 2. STRIP LINGKARAN TANGGAL DENGAN INDIKATOR ACARA ====================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Tombol Panah Kiri (<)
                          IconButton(
                            icon: const Icon(PhosphorIconsRegular.caretLeft),
                            iconSize: 20,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            color: hasCustomPhoto
                                ? Colors.white.withValues(alpha: 0.9)
                                : theme.colorScheme.onSurfaceVariant,
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
                            final isToday = _isSameDay(date, today);
                            final isWeddingDay = _isSameDay(date, weddingDateTime);

                            // Cek apakah tanggal ini memiliki event pernikahan
                            final hasEvent = events.any((e) {
                              final eDt =
                                  DateTime.fromMillisecondsSinceEpoch(e.eventDate);
                              return _isSameDay(eDt, date);
                            });

                            return _buildDateCircle(
                              context: context,
                              theme: theme,
                              isDark: isDark,
                              date: date,
                              isCenter: isCenter,
                              isToday: isToday,
                              isWeddingDay: isWeddingDay,
                              hasEvent: hasEvent,
                              hasCustomPhoto: hasCustomPhoto,
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
                            icon: const Icon(PhosphorIconsRegular.caretRight),
                            iconSize: 20,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            color: hasCustomPhoto
                                ? Colors.white.withValues(alpha: 0.9)
                                : theme.colorScheme.onSurfaceVariant,
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _anchorDate = _anchorDate.add(const Duration(days: 1));
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ==================== 3. COUNTDOWN SIMPLE (KONSEP C: DUAL PERSPECTIVE) ====================
                      _buildSimpleCountdown(
                        context: context,
                        theme: theme,
                        isDark: isDark,
                        isAtToday: isAtToday,
                        countdownTag: countdownTag,
                        today: today,
                        weddingDateTime: weddingDateTime,
                        eventsOnSelectedDate: eventsOnSelectedDate,
                        hasCustomPhoto: hasCustomPhoto,
                      ),
                      const SizedBox(height: 14),

                      // ==================== 4. SPACE DEDIKASI UNTUK QUOTES ====================
                      _buildQuoteSection(
                        context: context,
                        theme: theme,
                        isDark: isDark,
                        hasCustomPhoto: hasCustomPhoto,
                      ),
                    ],
                  ),
                ),

                // ==================== LAYER 2: TOMBOL ATUR FOTO LATAR (POJOK KANAN ATAS) ====================
                Positioned(
                  top: 14,
                  right: 14,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showPhotoOptions(context, hasCustomPhoto),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: hasCustomPhoto
                              ? Colors.black.withValues(alpha: 0.45)
                              : (isDark
                                  ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.8)),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: hasCustomPhoto
                                ? Colors.white.withValues(alpha: 0.25)
                                : theme.colorScheme.primary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          hasCustomPhoto
                              ? PhosphorIconsRegular.camera
                              : PhosphorIconsRegular.image,
                          size: 16,
                          color: hasCustomPhoto
                              ? Colors.white
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Gradasi Latar Bawaan Harmonis (Warm Champagne Silk & Peach khas Nikahin)
  Widget _buildDefaultGradient(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  theme.colorScheme.surfaceContainer,
                  theme.colorScheme.surfaceContainerHigh,
                ]
              : [
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.55),
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  /// Format durasi waktu manusiawi (e.g. "1 Tahun 2 Bulan Menuju Hari Bahagia")
  String _formatHumanDuration(DateTime from, DateTime to) {
    if (to.isBefore(from)) return 'Hari bahagia telah terlewati';
    if (to.year == from.year && to.month == from.month && to.day == from.day) {
      return 'Hari bahagia telah tiba!';
    }

    int years = to.year - from.year;
    int months = to.month - from.month;
    int days = to.day - from.day;

    if (days < 0) {
      final prevMonth = DateTime(to.year, to.month, 0);
      days += prevMonth.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    final parts = <String>[];
    if (years > 0) parts.add('$years Tahun');
    if (months > 0) parts.add('$months Bulan');
    if (years == 0 && days > 0) parts.add('$days Hari');

    if (parts.isEmpty) {
      return 'Hari bahagia segera tiba';
    }
    return '${parts.join(' ')} Menuju Hari Bahagia';
  }

  /// Indikator Hitung Mundur Simple dalam Kompartemen Kotak Rapi (Bento Box)
  Widget _buildSimpleCountdown({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required bool isAtToday,
    required String countdownTag,
    required DateTime today,
    required DateTime weddingDateTime,
    required List<WeddingEvent> eventsOnSelectedDate,
    required bool hasCustomPhoto,
  }) {
    final boxBgColor = hasCustomPhoto
        ? Colors.black.withValues(alpha: 0.42)
        : (isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
            : Colors.white.withValues(alpha: 0.85));

    final boxBorder = Border.all(
      color: hasCustomPhoto
          ? Colors.white.withValues(alpha: 0.2)
          : theme.colorScheme.primary.withValues(alpha: 0.14),
      width: 1,
    );

    if (isAtToday) {
      final humanDuration = _formatHumanDuration(today, weddingDateTime);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: boxBgColor,
          borderRadius: BorderRadius.circular(16),
          border: boxBorder,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              countdownTag,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: hasCustomPhoto
                    ? const Color(0xFFFBA4A8)
                    : theme.colorScheme.primary,
                letterSpacing: 0.6,
                shadows: hasCustomPhoto
                    ? [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              humanDuration,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: hasCustomPhoto
                    ? Colors.white.withValues(alpha: 0.95)
                    : theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.2,
                shadows: hasCustomPhoto
                    ? [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (eventsOnSelectedDate.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: boxBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE07A5F).withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              PhosphorIconsFill.calendarDots,
              color: Color(0xFFE07A5F),
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Ada ${eventsOnSelectedDate.length} agenda acara pada tanggal ini',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: hasCustomPhoto
                      ? Colors.white
                      : const Color(0xFFE07A5F),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _anchorDate = today);
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  '• Kembali ke Hari Ini',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: hasCustomPhoto
                        ? const Color(0xFFFDF0DE)
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: boxBgColor,
        borderRadius: BorderRadius.circular(16),
        border: boxBorder,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('d MMMM yyyy', 'id_ID').format(_anchorDate),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: hasCustomPhoto
                  ? Colors.white.withValues(alpha: 0.95)
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _anchorDate = today);
            },
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                '• Kembali ke Hari Ini',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: hasCustomPhoto
                      ? const Color(0xFFFDF0DE)
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kompartemen Kartu Quotes Pernikahan Sesuai Konfigurasi Settings & Referensi Pengguna
  Widget _buildQuoteSection({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required bool hasCustomPhoto,
  }) {
    if (!widget.profile.quoteEnabled) {
      return const SizedBox.shrink();
    }

    final rawQuote = widget.profile.quote?.trim() ?? '';
    final quoteText = rawQuote.isNotEmpty
        ? rawQuote
        : 'Dan di antara tanda-tanda kebesaran-Nya ialah Dia menciptakan pasangan-pasangan untukmu dari jenismu sendiri, agar kamu cenderung dan merasa tenteram kepadanya. — QS. Ar-Rum: 21';

    String displayQuoteText = quoteText;
    String? displaySource;

    if (quoteText.contains('—')) {
      final parts = quoteText.split('—');
      displayQuoteText = parts[0].trim();
      displaySource = parts.length > 1 ? parts[1].trim() : null;
    } else if (quoteText.contains(' - ')) {
      final parts = quoteText.split(' - ');
      displayQuoteText = parts[0].trim();
      displaySource = parts.length > 1 ? parts[1].trim() : null;
    }

    final accentColor = hasCustomPhoto
        ? const Color(0xFFFBA4A8)
        : theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasCustomPhoto
            ? Colors.black.withValues(alpha: 0.42)
            : (isDark
                ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.88)),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasCustomPhoto
              ? Colors.white.withValues(alpha: 0.2)
              : theme.colorScheme.primary.withValues(alpha: 0.14),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "” QUOTES PERNIKAHAN" Sesuai Referensi Pengguna
          Row(
            children: [
              Icon(
                PhosphorIconsRegular.quotes,
                size: 20,
                color: accentColor,
              ),
              const SizedBox(width: 6),
              Text(
                'QUOTES PERNIKAHAN',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  letterSpacing: 0.8,
                  shadows: hasCustomPhoto
                      ? [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Isi Teks Kutipan Mengikuti Konfigurasi Font & Teks dari Settings
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              context.go('/wedding/${widget.profileId}/settings');
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"$displayQuoteText"',
                    style: _resolveQuoteStyle(widget.profile, theme).copyWith(
                      color: hasCustomPhoto
                          ? Colors.white.withValues(alpha: 0.95)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      shadows: hasCustomPhoto
                          ? [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                  ),
                  if (displaySource != null && displaySource.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '— $displaySource',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                          shadows: hasCustomPhoto
                              ? [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCircle({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required DateTime date,
    required bool isCenter,
    required bool isToday,
    required bool isWeddingDay,
    required bool hasEvent,
    required bool hasCustomPhoto,
    required VoidCallback onTap,
  }) {
    final dayNum = DateFormat('d', 'id_ID').format(date);
    final dayName = isToday && isCenter ? 'Hari Ini' : _getShortDayName(date);

    final size = isCenter ? 58.0 : 44.0;
    final primaryColor = theme.colorScheme.primary;

    Color bgColor;
    if (isCenter) {
      if (hasCustomPhoto) {
        bgColor = isWeddingDay ? const Color(0xFFE07A5F) : primaryColor;
      } else {
        bgColor = isDark ? theme.colorScheme.surface : Colors.white;
      }
    } else {
      if (hasCustomPhoto) {
        bgColor = Colors.black.withValues(alpha: 0.38);
      } else {
        bgColor = isDark
            ? theme.colorScheme.surface.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.75);
      }
    }

    Border? border;
    if (isCenter) {
      border = Border.all(
        color: hasCustomPhoto
            ? Colors.white.withValues(alpha: 0.8)
            : (isWeddingDay
                ? const Color(0xFFE07A5F)
                : (isToday ? primaryColor : theme.colorScheme.outline)),
        width: 1.8,
      );
    } else if (hasCustomPhoto) {
      border = Border.all(
        color: isWeddingDay
            ? const Color(0xFFE07A5F).withValues(alpha: 0.8)
            : (isToday ? const Color(0xFFFBA4A8).withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.22)),
        width: isWeddingDay || isToday ? 1.4 : 1.0,
      );
    } else if (isWeddingDay) {
      border = Border.all(
        color: const Color(0xFFE07A5F).withValues(alpha: 0.6),
        width: 1.4,
      );
    } else if (isToday) {
      border = Border.all(
        color: primaryColor.withValues(alpha: 0.5),
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
                        ? const Color(0xFFE07A5F).withValues(alpha: 0.3)
                        : (hasCustomPhoto ? Colors.black.withValues(alpha: 0.4) : primaryColor.withValues(alpha: 0.12)),
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNum,
                  style: TextStyle(
                    fontSize: isCenter ? 17 : 12.5,
                    fontWeight: isCenter ? FontWeight.w900 : FontWeight.w600,
                    color: hasCustomPhoto
                        ? Colors.white
                        : (isCenter
                            ? (isWeddingDay
                                ? const Color(0xFFE07A5F)
                                : (isToday ? primaryColor : theme.colorScheme.onSurface))
                            : (isToday
                                ? primaryColor
                                : theme.colorScheme.onSurface.withValues(alpha: 0.85))),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: isCenter ? (isToday ? 9.0 : 11.0) : 9.5,
                    fontWeight: isCenter ? FontWeight.w700 : FontWeight.w500,
                    color: hasCustomPhoto
                        ? (isCenter ? Colors.white : Colors.white.withValues(alpha: 0.85))
                        : (isCenter
                            ? (isWeddingDay
                                ? const Color(0xFFE07A5F)
                                : primaryColor)
                            : (isToday ? primaryColor : theme.colorScheme.onSurfaceVariant)),
                    height: 1.1,
                  ),
                ),
              ],
            ),

            // Titik Indikator Acara Pernikahan di Bawah Tanggal
            if (hasEvent)
              Positioned(
                bottom: isCenter ? 5 : 3,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE07A5F),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  TextStyle _resolveQuoteStyle(WeddingProfile profile, ThemeData theme) {
    double fontSize = 13.0;
    if (profile.quoteFontSize == 'KECIL') fontSize = 11.5;
    if (profile.quoteFontSize == 'BESAR') fontSize = 14.5;

    FontWeight fontWeight = FontWeight.normal;
    FontStyle fontStyle = FontStyle.italic;

    switch (profile.quoteFontStyle) {
      case 'BOLD':
        fontWeight = FontWeight.bold;
        fontStyle = FontStyle.normal;
        break;
      case 'ITALIC':
        fontWeight = FontWeight.normal;
        fontStyle = FontStyle.italic;
        break;
      case 'BOLD_ITALIC':
        fontWeight = FontWeight.bold;
        fontStyle = FontStyle.italic;
        break;
      default:
        fontWeight = FontWeight.normal;
        fontStyle = FontStyle.italic;
        break;
    }

    return (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: 1.45,
      letterSpacing: 0.2,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
    );
  }
}
