import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../../../../data/local/preferences_manager.dart';
import '../../../../data/repositories/wedding_repository.dart';
import '../../../../domain/models/voucher_models.dart';
import '../../../../shared/utils/currency_utils.dart';
import '../../../../shared/utils/date_utils.dart';
import '../../../auth/presentation/auth_notifier.dart';
import 'admin_voucher_form_dialog.dart';

/// Tab manajemen Harga Dasar Global, Voucher Dinamis, dan Ringkasan Kanal di Admin Panel
class AdminVoucherTab extends ConsumerStatefulWidget {
  const AdminVoucherTab({super.key});

  @override
  ConsumerState<AdminVoucherTab> createState() => _AdminVoucherTabState();
}

class _AdminVoucherTabState extends ConsumerState<AdminVoucherTab> {
  bool _isLoading = true;
  PricingConfig _pricingConfig = const PricingConfig();
  List<VoucherModel> _vouchers = [];
  List<VoucherRedemptionLog> _redemptions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final idToken = await AppPreferences.getIdToken();
      final results = await Future.wait<dynamic>([
        firestoreService.fetchPricingConfig(idToken: idToken),
        firestoreService.fetchAllVouchers(idToken: idToken),
        firestoreService.fetchVoucherRedemptions(idToken: idToken),
      ]);

      if (mounted) {
        setState(() {
          _pricingConfig = results[0] as PricingConfig;
          _vouchers = results[1] as List<VoucherModel>;
          _redemptions = results[2] as List<VoucherRedemptionLog>;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data voucher: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showEditPricingDialog() async {
    final defCtrl = TextEditingController(text: _pricingConfig.defaultPrice.toInt().toString());
    final minCtrl = TextEditingController(text: _pricingConfig.minAllowedPrice.toInt().toString());
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<PricingConfig>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pengaturan Harga Global', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: defCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Harga Default Aplikasi (Rp)',
                  prefixText: 'Rp ',
                  helperText: 'Harga resmi yang tampil sebelum memakai kode voucher.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Nominal tidak valid' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: minCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Batas Minimal Harga Diskon (Rp)',
                  prefixText: 'Rp ',
                  helperText: 'Mencegah total bayar menjadi terlalu rendah/minus.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Nominal tidak valid' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.pop(
                ctx,
                PricingConfig(
                  defaultPrice: double.parse(defCtrl.text),
                  minAllowedPrice: double.parse(minCtrl.text),
                  updatedAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
            },
            child: const Text('Simpan Harga'),
          ),
        ],
      ),
    );

    defCtrl.dispose();
    minCtrl.dispose();

    if (saved == null || !mounted) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    final idToken = await AppPreferences.getIdToken();
    final ok = await firestoreService.updatePricingConfig(saved, idToken: idToken);

    if (mounted) {
      if (ok) {
        setState(() => _pricingConfig = saved);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harga dasar global berhasil diperbarui di Cloud Firestore.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal menyimpan perubahan harga. Periksa koneksi atau hak akses Admin.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _openVoucherForm({VoucherModel? existing}) async {
    final result = await showDialog<VoucherModel>(
      context: context,
      builder: (ctx) => AdminVoucherFormDialog(
        pricingConfig: _pricingConfig,
        existingVoucher: existing,
      ),
    );

    if (result == null || !mounted) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    final idToken = await AppPreferences.getIdToken();
    final ok = await firestoreService.upsertVoucher(
      result,
      isEdit: existing != null,
      idToken: idToken,
    );

    if (mounted) {
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Voucher ${result.code} berhasil disimpan.')),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal menyimpan voucher. Pastikan kode belum bentrok dan koneksi stabil.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleActive(VoucherModel voucher, bool newValue) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    final idToken = await AppPreferences.getIdToken();
    final ok = await firestoreService.toggleVoucherActive(voucher.code, newValue, idToken: idToken);
    if (ok && mounted) {
      setState(() {
        final idx = _vouchers.indexWhere((v) => v.code == voucher.code);
        if (idx != -1) {
          _vouchers[idx] = _vouchers[idx].copyWith(isActive: newValue);
        }
      });
    }
  }

  Future<void> _confirmDeleteVoucher(VoucherModel voucher) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kode Voucher?'),
        content: Text('Voucher "${voucher.code}" akan dihapus permanen. Pengguna tidak lagi bisa memakainya.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    final idToken = await AppPreferences.getIdToken();
    final ok = await firestoreService.deleteVoucher(voucher.code, idToken: idToken);

    if (ok && mounted) {
      setState(() => _vouchers.removeWhere((v) => v.code == voucher.code));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voucher ${voucher.code} telah dihapus.')),
      );
    }
  }

  void _copyPromoLink(String code) {
    final url = 'https://getnikahin.my.id?promo=$code';
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link promosi disalin: $url')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Hitung performa per kanal dari log penukaran yang lunas
    final Map<String, ({int count, double revenue})> channelStats = {};
    for (final log in _redemptions) {
      final ch = log.channel.toLowerCase();
      final prev = channelStats[ch] ?? (count: 0, revenue: 0.0);
      channelStats[ch] = (count: prev.count + 1, revenue: prev.revenue + log.paidAmount);
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          // 1. Kartu Pengaturan Harga Global
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(PhosphorIconsFill.tag, size: 18, color: Color(0xFFD97706)),
                        SizedBox(width: 8),
                        Text(
                          'Harga Dasar Global',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: _showEditPricingDialog,
                      icon: const Icon(PhosphorIconsRegular.pencilSimple, size: 15),
                      label: const Text('Ubah Harga', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PricingMetricTile(
                        label: 'Harga Default Resmi',
                        value: CurrencyUtils.formatRupiah(_pricingConfig.defaultPrice),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PricingMetricTile(
                        label: 'Batas Minimal Diskon',
                        value: CurrencyUtils.formatRupiah(_pricingConfig.minAllowedPrice),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Ringkasan Performa Kanal (Channel Attribution)
          if (channelStats.isNotEmpty) ...[
            const Text(
              'Performa Konversi per Kanal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 82,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: channelStats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (ctx, i) {
                  final entry = channelStats.entries.elementAt(i);
                  return Container(
                    width: 156,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.14)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${entry.value.count} transaksi',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          CurrencyUtils.formatRupiahCompact(entry.value.revenue),
                          style: TextStyle(fontSize: 11.5, color: Colors.green.shade700, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
          ],

          // 3. Header Daftar Voucher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Voucher (${_vouchers.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              FilledButton.icon(
                onPressed: () => _openVoucherForm(),
                icon: const Icon(PhosphorIconsRegular.plus, size: 16),
                label: const Text('Buat Voucher', style: TextStyle(fontSize: 12.5)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (_vouchers.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
              ),
              child: Column(
                children: [
                  Icon(PhosphorIconsRegular.ticket, size: 36, color: theme.colorScheme.outline),
                  const SizedBox(height: 10),
                  const Text(
                    'Belum ada kode voucher',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Buat voucher pertama untuk melacak transaksi dari Threads, Instagram, atau partner.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            )
          else
            ..._vouchers.map((voucher) {
              final finalPrice = voucher.calculateFinalPrice(_pricingConfig);
              final cutText = voucher.discountType == VoucherDiscountType.percent
                  ? '${voucher.discountValue.toInt()}%'
                  : CurrencyUtils.formatRupiah(voucher.discountValue);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: voucher.isCurrentlyUsable
                        ? theme.colorScheme.primary.withValues(alpha: 0.25)
                        : theme.colorScheme.outline.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    voucher.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '• ${voucher.channel.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              if (voucher.description != null && voucher.description!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    voucher.description!,
                                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Switch(
                          value: voucher.isActive,
                          onChanged: (val) => _toggleActive(voucher, val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 14,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Potongan: $cutText',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Bayar: ${CurrencyUtils.formatRupiah(finalPrice)}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(
                          'Terpakai: ${voucher.usedCount}${voucher.maxQuota != null ? " / ${voucher.maxQuota}" : " (Bebas)"}',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        if (voucher.validUntil != null)
                          Text(
                            voucher.isExpired
                                ? 'Kedaluwarsa (${WeddingDateUtils.formatShort(voucher.validUntil!)})'
                                : 's.d. ${WeddingDateUtils.formatShort(voucher.validUntil!)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: voucher.isExpired ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    const Divider(height: 18),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => _copyPromoLink(voucher.code),
                          icon: const Icon(PhosphorIconsRegular.linkSimple, size: 16),
                          label: const Text('Salin Link Promo', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(PhosphorIconsRegular.pencilSimple, size: 18),
                          tooltip: 'Ubah Voucher',
                          onPressed: () => _openVoucherForm(existing: voucher),
                        ),
                        IconButton(
                          icon: Icon(PhosphorIconsRegular.trash, size: 18, color: theme.colorScheme.error),
                          tooltip: 'Hapus Voucher',
                          onPressed: () => _confirmDeleteVoucher(voucher),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _PricingMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final bool muted;

  const _PricingMetricTile({
    required this.label,
    required this.value,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.5,
              decoration: muted ? TextDecoration.lineThrough : null,
              color: muted ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
