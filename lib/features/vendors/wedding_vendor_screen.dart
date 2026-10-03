import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/currency_utils.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';

class WeddingVendorScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingVendorScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingVendorScreen> createState() => _WeddingVendorScreenState();
}

class _WeddingVendorScreenState extends ConsumerState<WeddingVendorScreen> {
  String _selectedCategory = 'SEMUA';

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(weddingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Vendor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showVendorGuide(context),
          ),
        ],
      ),
      body: StreamBuilder<List<WeddingVendor>>(
        stream: repo.watchVendors(widget.profileId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allVendors = snapshot.data ?? [];
          final filtered = _selectedCategory == 'SEMUA'
              ? allVendors
              : allVendors.where((v) => v.category == _selectedCategory).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // 1. Hero Overview KPI Card (from WeddingVendorScreen.kt)
              _buildHeroCard(context, allVendors),
              const SizedBox(height: 14),

              // 2. Category Filter Chips
              _buildCategoryChips(allVendors),
              const SizedBox(height: 16),

              // 3. Vendor Items / Empty State
              if (filtered.isEmpty)
                _buildEmptyVendorsState(context)
              else
                ...filtered.map((vendor) => _buildVendorCard(context, vendor)),

              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVendorDialog(context),
        tooltip: 'Tambah Vendor',
        child: const Icon(Icons.add_business_rounded),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, List<WeddingVendor> allVendors) {
    final theme = Theme.of(context);
    final totalCount = allVendors.length;
    final dealCount = allVendors
        .where((v) => v.status == 'KONTRAK' || v.status == 'SELESAI' || v.status == 'TANDA_JADI')
        .length;
    final completedCount = allVendors.where((v) => v.status == 'SELESAI').length;
    final contractCount = allVendors.where((v) => v.status == 'KONTRAK').length;
    final tandaJadiCount = allVendors.where((v) => v.status == 'TANDA_JADI').length;
    final totalContractValue = allVendors.fold(0.0, (acc, v) => acc + v.contractValue);
    final progress = totalCount > 0 ? (dealCount / totalCount).clamp(0.0, 1.0) : 0.0;

    return BentoCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Total Kontrak & Deal Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Kontrak Seluruh Vendor',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyUtils.formatRupiah(totalContractValue),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$dealCount/$totalCount Deal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),

          // Row 2: Quick Metrics with Colored Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(const Color(0xFF2E7D32), 'Selesai: $completedCount'),
              _buildMetricItem(const Color(0xFF1565C0), 'Kontrak: $contractCount'),
              _buildMetricItem(const Color(0xFFE65100), 'Tanda Jadi: $tandaJadiCount'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildCategoryChips(List<WeddingVendor> vendors) {
    final categories = [
      {'val': 'SEMUA', 'label': 'Semua Kategori'},
      ...ExpenseCategory.values.map((c) => {'val': c.value, 'label': c.label}),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((c) {
          final isSelected = _selectedCategory == c['val'];
          final count = c['val'] == 'SEMUA'
              ? vendors.length
              : vendors.where((v) => v.category == c['val']).length;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('${c['label']} ($count)'),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = c['val']!),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVendorCard(BuildContext context, WeddingVendor vendor) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: BentoCard(
        onTap: () => _showVendorDetailModal(context, vendor),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kategori: ${vendor.category}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                StatusChip(status: vendor.status),
              ],
            ),
            const SizedBox(height: 12),

            // Pipeline Progress Bar
            _buildPipelineIndicator(vendor.status),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nilai Kontrak',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                      Text(
                        CurrencyUtils.formatRupiah(vendor.contractValue),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (vendor.phoneNumber != null && vendor.phoneNumber!.isNotEmpty) ...[
                      IconButton.filledTonal(
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.phone_rounded, size: 18),
                        tooltip: 'Telepon',
                        onPressed: () => _launchCaller(vendor.phoneNumber!),
                      ),
                      const SizedBox(width: 6),
                      IconButton.filledTonal(
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                        tooltip: 'Chat WhatsApp',
                        onPressed: () => _launchWhatsApp(vendor.phoneNumber!),
                      ),
                      const SizedBox(width: 4),
                    ],
                    IconButton(
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert_rounded, size: 20),
                      onPressed: () => _showVendorOptions(context, vendor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPipelineIndicator(String status) {
    int currentStep = 1;
    switch (status) {
      case 'PROSPEK':
        currentStep = 1;
        break;
      case 'TANDA_JADI':
        currentStep = 2;
        break;
      case 'KONTRAK':
        currentStep = 3;
        break;
      case 'SELESAI':
        currentStep = 4;
        break;
    }

    final steps = ['Prospek', 'Tanda Jadi', 'Kontrak', 'Selesai'];

    return Row(
      children: List.generate(4, (index) {
        final stepNum = index + 1;
        final isPassed = stepNum <= currentStep;
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isPassed ? const Color(0xFFD81B60) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isPassed ? FontWeight.bold : FontWeight.normal,
                  color: isPassed ? const Color(0xFFD81B60) : Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyVendorsState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.storefront_outlined, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'Belum Ada Vendor Tercatat',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Kelola tahapan vendor dari tahap riset (prospek) hingga deal kontrak.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== ACTIONS & MODALS ====================
  void _showVendorOptions(BuildContext context, WeddingVendor vendor) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Vendor'),
              onTap: () {
                Navigator.pop(ctx);
                _showAddVendorDialog(context, vendorToEdit: vendor);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('Hapus Vendor', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                showDeleteConfirmDialog(
                  context: context,
                  itemName: vendor.name,
                  onConfirm: () async {
                    await ref.read(weddingRepositoryProvider).deleteVendor(vendor.vendorId);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddVendorDialog(BuildContext context, {WeddingVendor? vendorToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddVendorBottomSheet(
        profileId: widget.profileId,
        vendorToEdit: vendorToEdit,
      ),
    );
  }

  void _showVendorDetailModal(BuildContext context, WeddingVendor vendor) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    vendor.name,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                StatusChip(status: vendor.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Kategori: ${vendor.category}',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            const Divider(height: 24),
            _buildDetailRow('PIC Contact', vendor.picName ?? '-'),
            _buildDetailRow('No. Telepon / WA', vendor.phoneNumber ?? '-'),
            _buildDetailRow(
              'Instagram',
              vendor.instagramHandle != null && vendor.instagramHandle!.isNotEmpty
                  ? '@${vendor.instagramHandle!.replaceAll('@', '')}'
                  : '-',
            ),
            _buildDetailRow('Nilai Kontrak', CurrencyUtils.formatRupiah(vendor.contractValue)),
            if (vendor.notes != null && vendor.notes!.isNotEmpty)
              _buildDetailRow('Catatan', vendor.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchCaller(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp(String phone) async {
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) return;

    // Normalisasi format nomor Indonesia
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '62${cleanPhone.substring(1)}';
    } else if (cleanPhone.startsWith('8')) {
      cleanPhone = '62$cleanPhone';
    } else if (!cleanPhone.startsWith('62')) {
      if (cleanPhone.length >= 9 && cleanPhone.length <= 13) {
        cleanPhone = '62$cleanPhone';
      }
    }

    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchInstagram(String handle) async {
    final cleanHandle = handle.replaceAll('@', '').trim();
    if (cleanHandle.isEmpty) return;
    final uri = Uri.parse('https://instagram.com/$cleanHandle');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showVendorGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Manajemen Kontrak',
      screenPurpose:
          'Pusat kendali seluruh vendor pernikahan Anda. Catat kontak PIC, nilai kontrak, uang muka (DP), dan pantau tahapan kerja sama hingga hari H.',
      features: const [
        WeddingGuideFeature(
          title: 'Pantau Status & Kontrak',
          description: 'Lacak tahapan kerja sama: Mulai dari Prospek/Riset, Tanda Jadi, Kontrak Aktif, hingga Selesai.',
          icon: Icons.assignment_turned_in_outlined,
        ),
        WeddingGuideFeature(
          title: 'Kontak PIC Cepat (WA & Telp)',
          description: 'Hubungi PIC vendor langsung melalui WhatsApp atau panggilan telepon dalam 1 ketukan.',
          icon: Icons.chat_bubble_outline_rounded,
        ),
        WeddingGuideFeature(
          title: 'Kategori Vendor Rapi',
          description: 'Filter vendor berdasarkan kategori: Venue, Katering, Fotografi, Dekorasi, MUA, Busana, dll.',
          icon: Icons.category_outlined,
        ),
        WeddingGuideFeature(
          title: 'Rekap Nilai Kontrak Total',
          description: 'Hitung total komitmen anggaran seluruh vendor yang telah deal secara real-time.',
          icon: Icons.account_balance_wallet_outlined,
        ),
      ],
      proTip: 'Simpan nomor kontak PIC cadangan dan rincian paket di catatan vendor agar mudah diakses saat hari H.',
    );
  }
}

class _AddVendorBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingVendor? vendorToEdit;

  const _AddVendorBottomSheet({required this.profileId, this.vendorToEdit});

  @override
  ConsumerState<_AddVendorBottomSheet> createState() => _AddVendorBottomSheetState();
}

class _AddVendorBottomSheetState extends ConsumerState<_AddVendorBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _picController = TextEditingController();
  final _phoneController = TextEditingController();
  final _igController = TextEditingController();
  final _notesController = TextEditingController();
  String _category = 'VENUE';
  String _status = 'PROSPEK';
  double _contractValue = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.vendorToEdit != null) {
      final v = widget.vendorToEdit!;
      _nameController.text = v.name;
      _picController.text = v.picName ?? '';
      _phoneController.text = v.phoneNumber ?? '';
      _igController.text = v.instagramHandle ?? '';
      _notesController.text = v.notes ?? '';
      _category = v.category;
      _status = v.status;
      _contractValue = v.contractValue;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _picController.dispose();
    _phoneController.dispose();
    _igController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.vendorToEdit != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 24,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? 'Edit Data Vendor' : 'Tambah Vendor Baru',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori Vendor'),
                items: ExpenseCategory.values
                    .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val ?? 'VENUE'),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _nameController,
                inputFormatters: [LengthLimitingTextInputFormatter(60)],
                maxLength: 60,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(labelText: 'Nama Vendor / Perusahaan'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama vendor wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _picController,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      maxLength: 50,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: const InputDecoration(labelText: 'Nama PIC (Opsional)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\s]')),
                        LengthLimitingTextInputFormatter(16),
                      ],
                      maxLength: 16,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: const InputDecoration(labelText: 'Nomor Telepon / WA'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _igController,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                maxLength: 30,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(
                  labelText: 'Instagram Handle (tanpa @)',
                  prefixText: '@',
                ),
              ),
              const SizedBox(height: 14),

              CurrencyTextField(
                labelText: 'Nilai Kontrak (Kesepakatan)',
                initialValue: _contractValue,
                onChanged: (val) => _contractValue = val,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status Progres Vendor'),
                items: VendorStatus.values
                    .map((s) => DropdownMenuItem(value: s.value, child: Text(s.label)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val ?? 'PROSPEK'),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _notesController,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                maxLength: 200,
                decoration: const InputDecoration(labelText: 'Catatan Khusus / Detail Paket'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveVendor,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Vendor'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveVendor() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(weddingRepositoryProvider);
      if (widget.vendorToEdit != null) {
        final updated = widget.vendorToEdit!.copyWith(
          category: _category,
          name: _nameController.text.trim(),
          picName: _picController.text.trim().isEmpty ? null : _picController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          instagramHandle: _igController.text.trim().isEmpty ? null : _igController.text.trim(),
          contractValue: _contractValue,
          status: _status,
          notes: _notesController.text.trim(),
        );
        await repo.updateVendor(updated);
      } else {
        final newVendor = WeddingVendor(
          vendorId: UuidUtils.generateId(),
          weddingProfileId: widget.profileId,
          category: _category,
          name: _nameController.text.trim(),
          picName: _picController.text.trim().isEmpty ? null : _picController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          instagramHandle: _igController.text.trim().isEmpty ? null : _igController.text.trim(),
          contractValue: _contractValue,
          status: _status,
          notes: _notesController.text.trim(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        await repo.createVendor(newVendor);
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
