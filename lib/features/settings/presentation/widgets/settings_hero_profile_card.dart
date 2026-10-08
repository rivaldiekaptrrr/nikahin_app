import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/widgets/bento_card.dart';

class SettingsHeroProfileCard extends StatelessWidget {
  final WeddingProfile profile;

  const SettingsHeroProfileCard({
    super.key,
    required this.profile,
  });

  String _getMonogram() {
    final groom = profile.groomName.trim().isNotEmpty ? profile.groomName.trim()[0].toUpperCase() : 'P';
    final bride = profile.brideName.trim().isNotEmpty ? profile.brideName.trim()[0].toUpperCase() : 'W';
    return '$groom & $bride';
  }

  String _getCountdownText() {
    if (profile.weddingDate <= 0) return 'Belum diatur';
    final weddingDt = DateTime.fromMillisecondsSinceEpoch(profile.weddingDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(weddingDt.year, weddingDt.month, weddingDt.day);
    final diff = target.difference(today).inDays;

    if (diff > 0) return '$diff Hari Lagi';
    if (diff == 0) return 'Hari Ini! 💍';
    return 'Telah Berlalu';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasNames = profile.groomName.isNotEmpty || profile.brideName.isNotEmpty;
    final dateStr = profile.weddingDate > 0
        ? DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(
            DateTime.fromMillisecondsSinceEpoch(profile.weddingDate),
          )
        : 'Tanggal Pernikahan Belum Ditentukan';

    return BentoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Dual Monogram Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  _getMonogram(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasNames ? profile.coupleTitle : 'Rencana Pernikahan Baru',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dateStr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 12,
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
            ],
          ),
          const SizedBox(height: 16),
          // Badges / Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _getCountdownText(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (profile.culturalPresetGroom != null && profile.culturalPresetGroom != 'MODERN')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        size: 14,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Adat ${profile.culturalPresetGroom}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
