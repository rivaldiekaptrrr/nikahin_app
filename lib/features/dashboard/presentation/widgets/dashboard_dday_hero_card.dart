import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/utils/date_utils.dart';

/// Kartu Hero Hitung Mundur D-Day berstandar Appllama High-Fidelity.
/// Menampilkan countdown besar yang dinamis, nama pasangan, fase persiapan, dan kutipan romantis.
class DashboardDDayHeroCard extends StatelessWidget {
  final String profileId;
  final WeddingProfile profile;

  const DashboardDDayHeroCard({
    super.key,
    required this.profileId,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = WeddingDateUtils.daysUntil(profile.weddingDate);
    final daysString = days >= 0 ? '$days' : '${days.abs()}';
    final subText = days == 0 ? 'Hari Ini!' : (days > 0 ? 'Hari Lagi' : 'Hari Lalu');
    final formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now());

    final names = '${profile.groomName} & ${profile.brideName}'
        .trim();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.16),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.75),
              theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Bar: Today's Date & Couple Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    formattedDate,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.go('/wedding/$profileId/settings');
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 170),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            names.isNotEmpty ? names : 'Calon Pengantin',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.favorite_rounded,
                          size: 13,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Centered Countdown Digits
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  daysString,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onPrimaryContainer,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  subText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              WeddingDateUtils.formatFull(profile.weddingDate),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Romantic Quote Card
            if (profile.quoteEnabled && profile.quote != null && profile.quote!.isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Text(
                  '"${profile.quote}"',
                  textAlign: TextAlign.center,
                  style: _resolveQuoteStyle(profile).copyWith(
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
