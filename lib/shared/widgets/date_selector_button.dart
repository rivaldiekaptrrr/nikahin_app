import 'package:flutter/material.dart';
import '../utils/date_utils.dart';

class DateSelectorButton extends StatelessWidget {
  final int selectedEpochMillis;
  final ValueChanged<int> onDateSelected;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DateSelectorButton({
    super.key,
    required this.selectedEpochMillis,
    required this.onDateSelected,
    this.label = 'Pilih Tanggal',
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDate = selectedEpochMillis > 0;
    final dateStr = hasDate ? WeddingDateUtils.formatFull(selectedEpochMillis) : 'Belum ditentukan';

    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final initial = hasDate
            ? DateTime.fromMillisecondsSinceEpoch(selectedEpochMillis)
            : now.add(const Duration(days: 90));

        final picked = await showDatePicker(
          context: context,
          initialDate: initial.isBefore(firstDate ?? DateTime(2020))
              ? (firstDate ?? DateTime(2020))
              : initial,
          firstDate: firstDate ?? DateTime(2020),
          lastDate: lastDate ?? DateTime(2040),
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  primary: theme.colorScheme.primary,
                  onPrimary: theme.colorScheme.onPrimary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          onDateSelected(picked.millisecondsSinceEpoch);
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: hasDate ? theme.colorScheme.onSurface : theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
