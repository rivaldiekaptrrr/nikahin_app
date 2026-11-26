import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../../../../data/local/preferences_manager.dart';
import '../../../../domain/models/voucher_models.dart';
import '../../../../shared/utils/currency_utils.dart';
import '../../../../shared/utils/date_utils.dart';
import '../../../auth/presentation/auth_notifier.dart';

/// Tab riwayat penukaran voucher yang berhasil lunas (`voucher_redemptions`)
class AdminRedemptionsTab extends ConsumerStatefulWidget {
  const AdminRedemptionsTab({super.key});

  @override
  ConsumerState<AdminRedemptionsTab> createState() => _AdminRedemptionsTabState();
}

class _AdminRedemptionsTabState extends ConsumerState<AdminRedemptionsTab> {
  final _searchCtrl = TextEditingController();
  bool _isLoading = true;
  List<VoucherRedemptionLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final idToken = await AppPreferences.getIdToken();
      final fetched = await firestoreService.fetchVoucherRedemptions(idToken: idToken);
      if (mounted) setState(() => _logs = fetched);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = _logs.where((log) {
      if (query.isEmpty) return true;
      return log.userEmail.toLowerCase().contains(query) ||
          log.voucherCode.toLowerCase().contains(query) ||
          log.channel.toLowerCase().contains(query) ||
          log.orderId.toLowerCase().contains(query);
    }).toList();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadLogs,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari email, kode voucher, atau kanal...',
                prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 18),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 60),
                      Icon(PhosphorIconsRegular.receipt, size: 38, color: theme.colorScheme.outline),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Belum ada riwayat penukaran voucher',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final log = filtered[i];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.14)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${log.voucherCode}  (${log.channel.toUpperCase()})',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  CurrencyUtils.formatRupiah(log.paidAmount),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(log.userEmail, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text(
                              'Order: ${log.orderId} • ${log.paymentType.toUpperCase()} • ${WeddingDateUtils.formatShort(log.redeemedAt)}',
                              style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
