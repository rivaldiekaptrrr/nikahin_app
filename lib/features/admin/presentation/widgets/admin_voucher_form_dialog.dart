import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../../../../domain/models/voucher_models.dart';
import '../../../../shared/utils/currency_utils.dart';
import '../../../../shared/utils/date_utils.dart';

/// Dialog interaktif untuk membuat atau mengubah konfigurasi kode voucher
class AdminVoucherFormDialog extends StatefulWidget {
  final PricingConfig pricingConfig;
  final VoucherModel? existingVoucher;

  const AdminVoucherFormDialog({
    super.key,
    required this.pricingConfig,
    this.existingVoucher,
  });

  @override
  State<AdminVoucherFormDialog> createState() => _AdminVoucherFormDialogState();
}

class _AdminVoucherFormDialogState extends State<AdminVoucherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _discountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quotaController;
  late final TextEditingController _customChannelController;

  late String _selectedChannel;
  late VoucherDiscountType _discountType;
  late bool _isUnlimitedQuota;
  late bool _isForever;
  DateTime? _validUntilDate;
  late bool _isActive;

  static const List<String> _presetChannels = [
    'threads',
    'instagram',
    'tiktok',
    'youtube',
    'whatsapp',
    'affiliate',
    'organic',
    'custom',
  ];

  bool get _isEditing => widget.existingVoucher != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingVoucher;
    _codeController = TextEditingController(text: existing?.code ?? '');
    _discountController = TextEditingController(
      text: existing != null ? existing.discountValue.toInt().toString() : '',
    );
    _descriptionController = TextEditingController(text: existing?.description ?? '');
    _quotaController = TextEditingController(
      text: existing?.maxQuota?.toString() ?? '100',
    );

    final initChannel = existing?.channel.toLowerCase() ?? 'threads';
    if (_presetChannels.contains(initChannel) && initChannel != 'custom') {
      _selectedChannel = initChannel;
      _customChannelController = TextEditingController();
    } else {
      _selectedChannel = 'custom';
      _customChannelController = TextEditingController(text: initChannel);
    }

    _discountType = existing?.discountType ?? VoucherDiscountType.fixed;
    _isUnlimitedQuota = existing?.maxQuota == null;
    _isForever = existing?.validUntil == null;
    _validUntilDate = existing?.validUntil != null
        ? DateTime.fromMillisecondsSinceEpoch(existing!.validUntil!)
        : DateTime.now().add(const Duration(days: 30));
    _isActive = existing?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
    _quotaController.dispose();
    _customChannelController.dispose();
    super.dispose();
  }

  VoucherModel _buildPreviewModel() {
    final rawDiscount = double.tryParse(_discountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
    final resolvedChannel = _selectedChannel == 'custom'
        ? _customChannelController.text.trim().toLowerCase()
        : _selectedChannel;

    final now = DateTime.now().millisecondsSinceEpoch;
    return VoucherModel(
      code: _codeController.text.trim().toUpperCase(),
      channel: resolvedChannel.isEmpty ? 'organic' : resolvedChannel,
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      discountType: _discountType,
      discountValue: rawDiscount,
      isActive: _isActive,
      maxQuota: _isUnlimitedQuota ? null : int.tryParse(_quotaController.text.trim()),
      usedCount: widget.existingVoucher?.usedCount ?? 0,
      validFrom: widget.existingVoucher?.validFrom ?? now,
      validUntil: _isForever
          ? null
          : (_validUntilDate != null
              ? DateTime(_validUntilDate!.year, _validUntilDate!.month, _validUntilDate!.day, 23, 59, 59)
                  .millisecondsSinceEpoch
              : null),
      createdAt: widget.existingVoucher?.createdAt ?? now,
      updatedAt: now,
    );
  }

  Future<void> _pickValidUntilDate() async {
    final initial = _validUntilDate ?? DateTime.now().add(const Duration(days: 30));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(DateTime.now()) ? DateTime.now() : initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (picked != null) {
      setState(() => _validUntilDate = picked);
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final model = _buildPreviewModel();
    Navigator.pop(context, model);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = _buildPreviewModel();
    final basisPrice = widget.pricingConfig.defaultPrice;
    final cutAmount = preview.calculateDiscountCut(widget.pricingConfig);
    final finalPrice = preview.calculateFinalPrice(widget.pricingConfig);
    final isClampedByMin = (basisPrice - cutAmount) < widget.pricingConfig.minAllowedPrice;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      title: Row(
        children: [
          Icon(
            _isEditing ? PhosphorIconsRegular.pencilSimple : PhosphorIconsFill.ticket,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isEditing ? 'Ubah Kode Voucher' : 'Buat Voucher Baru',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Kode Voucher
                TextFormField(
                  controller: _codeController,
                  readOnly: _isEditing,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_-]')),
                  ],
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Kode Voucher',
                    hintText: 'Contoh: THREADS39 atau IGHEMAT',
                    helperText: _isEditing
                        ? 'Kode voucher tidak dapat diubah setelah dibuat.'
                        : 'Hanya huruf, angka, garis bawah (_), atau tanda hubung (-).',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(PhosphorIconsRegular.hash),
                  ),
                  validator: (val) {
                    final clean = (val ?? '').trim();
                    if (clean.length < 2 || clean.length > 32) {
                      return 'Kode harus terdiri dari 2 sampai 32 karakter.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // 2. Kanal Sumber (Channel Attribution)
                DropdownButtonFormField<String>(
                  initialValue: _selectedChannel,
                  decoration: InputDecoration(
                    labelText: 'Sumber Kanal Promosi',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(PhosphorIconsRegular.broadcast),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'threads', child: Text('Threads')),
                    DropdownMenuItem(value: 'instagram', child: Text('Instagram')),
                    DropdownMenuItem(value: 'tiktok', child: Text('TikTok')),
                    DropdownMenuItem(value: 'youtube', child: Text('YouTube')),
                    DropdownMenuItem(value: 'whatsapp', child: Text('WhatsApp / Komunitas')),
                    DropdownMenuItem(value: 'affiliate', child: Text('Partner / Wedding Organizer')),
                    DropdownMenuItem(value: 'organic', child: Text('Umum / Organik')),
                    DropdownMenuItem(value: 'custom', child: Text('Ketik Kanal Khusus...')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedChannel = val);
                  },
                ),
                if (_selectedChannel == 'custom') ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _customChannelController,
                    decoration: InputDecoration(
                      labelText: 'Nama Kanal Khusus',
                      hintText: 'Contoh: wo_mahkota atau twitter_ads',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (val) {
                      if (_selectedChannel == 'custom' && (val == null || val.trim().isEmpty)) {
                        return 'Isi nama kanal khusus.';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),

                // 3. Tipe Potongan
                const Text(
                  'Aturan Potongan Harga',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                SegmentedButton<VoucherDiscountType>(
                  segments: const [
                    ButtonSegment(
                      value: VoucherDiscountType.fixed,
                      label: Text('Potongan Rupiah', style: TextStyle(fontSize: 12)),
                    ),
                    ButtonSegment(
                      value: VoucherDiscountType.percent,
                      label: Text('Potongan Persen (%)', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                  selected: {_discountType},
                  onSelectionChanged: (s) => setState(() => _discountType = s.first),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: _discountType == VoucherDiscountType.fixed
                        ? 'Nominal Potongan (Rp)'
                        : 'Persentase Potongan (%)',
                    hintText: _discountType == VoucherDiscountType.fixed ? 'Contoh: 10000 atau 60000' : 'Contoh: 20 atau 60',
                    prefixText: _discountType == VoucherDiscountType.fixed ? 'Rp ' : null,
                    suffixText: _discountType == VoucherDiscountType.percent ? '%' : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) {
                    final parsed = double.tryParse(val ?? '') ?? -1;
                    if (parsed < 0) {
                      return 'Masukkan angka potongan yang valid.';
                    }
                    if (_discountType == VoucherDiscountType.percent && parsed > 100) {
                      return 'Persentase maksimal adalah 100%.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // 4. Live Price Calculator Preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isClampedByMin
                          ? Colors.orange.withValues(alpha: 0.6)
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Simulasi Harga Bayar Pengguna',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Harga default:', style: TextStyle(fontSize: 12)),
                          Text(CurrencyUtils.formatRupiah(basisPrice), style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Potongan voucher:', style: TextStyle(fontSize: 12)),
                          Text(
                            '-${CurrencyUtils.formatRupiah(cutAmount)}',
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.error, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Divider(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total yang dibayar:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text(
                            CurrencyUtils.formatRupiah(finalPrice),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      if (isClampedByMin) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Catatan: Nominal otomatis ditahan pada batas minimum ${CurrencyUtils.formatRupiah(widget.pricingConfig.minAllowedPrice)}.',
                          style: TextStyle(fontSize: 11, color: Colors.orange.shade800),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 5. Kuota & Masa Berlaku
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tanpa Batas Kuota', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Boleh diklaim oleh berapa saja calon pengantin', style: TextStyle(fontSize: 11.5)),
                  value: _isUnlimitedQuota,
                  onChanged: (val) => setState(() => _isUnlimitedQuota = val),
                ),
                if (!_isUnlimitedQuota)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _quotaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Batas Kuota Klaim',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (val) {
                        if (!_isUnlimitedQuota) {
                          final q = int.tryParse(val ?? '') ?? 0;
                          if (q <= 0) return 'Kuota harus lebih dari 0.';
                        }
                        return null;
                      },
                    ),
                  ),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Berlaku Selamanya', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Matikan jika voucher punya tanggal berakhir', style: TextStyle(fontSize: 11.5)),
                  value: _isForever,
                  onChanged: (val) => setState(() => _isForever = val),
                ),
                if (!_isForever)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton.icon(
                      onPressed: _pickValidUntilDate,
                      icon: const Icon(PhosphorIconsRegular.calendar, size: 18),
                      label: Text(
                        _validUntilDate != null
                            ? 'Berlaku s.d. ${WeddingDateUtils.formatFull(_validUntilDate!.millisecondsSinceEpoch)}'
                            : 'Pilih Tanggal Berakhir',
                      ),
                    ),
                  ),

                // 6. Catatan & Status Aktif
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: 'Catatan Admin (Opsional)',
                    hintText: 'Contoh: Kampanye Reels Minggu ke-4 Nov',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Status Voucher Aktif', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(PhosphorIconsRegular.check, size: 18),
          label: Text(_isEditing ? 'Simpan Perubahan' : 'Simpan Voucher'),
        ),
      ],
    );
  }
}
