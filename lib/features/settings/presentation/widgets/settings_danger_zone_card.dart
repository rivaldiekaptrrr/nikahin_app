import 'package:flutter/material.dart';
import '../../../../domain/models/wedding_models.dart';
import '../../../../shared/widgets/bento_card.dart';

class SettingsDangerZoneCard extends StatelessWidget {
  final WeddingProfile profile;
  final VoidCallback onDeleteProfile;

  const SettingsDangerZoneCard({
    super.key,
    required this.profile,
    required this.onDeleteProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BentoCard(
      padding: const EdgeInsets.all(16),
      border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.delete_forever_rounded, color: theme.colorScheme.error, size: 22),
        ),
        title: Text(
          'Hapus Seluruh Data Rencana',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.error, fontSize: 14),
        ),
        subtitle: const Text(
          'Mengosongkan anggaran, vendor, tamu, dan rundown untuk mulai dari awal.',
          style: TextStyle(fontSize: 12),
        ),
        onTap: onDeleteProfile,
      ),
    );
  }
}
