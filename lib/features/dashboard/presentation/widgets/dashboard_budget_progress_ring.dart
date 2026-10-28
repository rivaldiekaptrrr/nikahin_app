import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/currency_utils.dart';

/// Kartu Progres Anggaran & Cincin Visual Interaktif berstandar Appllama High-Fidelity.
/// Menyajikan visualisasi status pembayaran dan kesehatan bujet pernikahan secara jelas.
class DashboardBudgetProgressRing extends StatelessWidget {
  final String profileId;
  final double totalBudgetCap;
  final double totalEstimated;
  final double totalPaid;

  const DashboardBudgetProgressRing({
    super.key,
    required this.profileId,
    required this.totalBudgetCap,
    required this.totalEstimated,
    required this.totalPaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveCap = totalBudgetCap > 0 ? totalBudgetCap : totalEstimated;
    final paidProgress = effectiveCap > 0 ? (totalPaid / effectiveCap).clamp(0.0, 1.0) : 0.0;
    final paidPercentage = (paidProgress * 100).round();

    final remainingCost = (totalEstimated - totalPaid).clamp(0.0, double.infinity);
    final freeBudget = (totalBudgetCap - totalEstimated);
    final isOverBudget = totalBudgetCap > 0 && totalEstimated > totalBudgetCap;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              context.go('/wedding/$profileId/budget');
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Title & Health Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.pie_chart_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Kesehatan Anggaran',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      _buildHealthBadge(isOverBudget, totalEstimated, totalBudgetCap),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Middle Row: Radial Ring & Key Totals
                  Row(
                    children: [
                      // Circular Progress Ring
                      SizedBox(
                        width: 86,
                        height: 86,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background track
                            SizedBox(
                              width: 86,
                              height: 86,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 8,
                                color: theme.colorScheme.surfaceContainerHighest,
                              ),
                            ),
                            // Paid progress ring
                            SizedBox(
                              width: 86,
                              height: 86,
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.easeOutCubic,
                                tween: Tween<double>(begin: 0.0, end: paidProgress),
                                builder: (context, value, _) {
                                  return CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 8,
                                    strokeCap: StrokeCap.round,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.colorScheme.primary,
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Center percentage label
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$paidPercentage%',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Terbayar',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Financial Metrics Stack
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Terbayar',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyUtils.formatRupiah(totalPaid),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.primary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Batas Anggaran',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      CurrencyUtils.formatRupiahCompact(effectiveCap),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sisa Tagihan',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      CurrencyUtils.formatRupiahCompact(remainingCost),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFD97706),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Bottom Sisa Dana Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isOverBudget
                          ? const Color(0xFFFEE2E2)
                          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isOverBudget ? 'Melebihi Batas Anggaran' : 'Sisa Anggaran Tersedia',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isOverBudget
                                ? const Color(0xFF991B1B)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          CurrencyUtils.formatRupiah(isOverBudget ? (totalEstimated - totalBudgetCap) : freeBudget),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isOverBudget
                                ? const Color(0xFF991B1B)
                                : const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthBadge(bool isOverBudget, double estimated, double cap) {
    if (cap <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Estimasi',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
        ),
      );
    }

    if (isOverBudget) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Melebihi Batas',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
        ),
      );
    }

    final ratio = estimated / cap;
    if (ratio >= 0.85) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Mendekati Batas',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Terkendali',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
      ),
    );
  }
}
