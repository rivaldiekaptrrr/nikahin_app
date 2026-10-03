import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/currency_utils.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/app_feedback.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/error_state_view.dart';
import '../../shared/widgets/skeleton_loading.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';

class WeddingSeserahanScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingSeserahanScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingSeserahanScreen> createState() => _WeddingSeserahanScreenState();
}

class _WeddingSeserahanScreenState extends ConsumerState<WeddingSeserahanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasSyncedMockData = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  bool _isValidUrl(String? text) {
    if (text == null || text.trim().isEmpty) return false;
    final trimmed = text.trim();
    return trimmed.startsWith('http://') ||
        trimmed.startsWith('https://') ||
        trimmed.startsWith('www.') ||
        trimmed.contains('tokopedia.com') ||
        trimmed.contains('shopee.co.id') ||
        trimmed.contains('lazada.co.id') ||
        trimmed.contains('blibli.com') ||
        trimmed.contains('tiktok.com');
  }

  void _checkAndSyncMockData(List<WeddingSeserahan> allItems, WeddingRepository repo) {
    if (_hasSyncedMockData) return;
    final maharItems = allItems.where((s) => s.direction == 'MAHAR').toList();
    final hasOldLinkOrLegacy = allItems.any((s) => s.notes != null && (s.notes!.contains('ZSbmXeeoA') || !_isValidUrl(s.notes)));

    if ((maharItems.isEmpty && allItems.isNotEmpty) || hasOldLinkOrLegacy) {
      _hasSyncedMockData = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // 1. Seed Mahar if missing
        if (maharItems.isEmpty) {
          final mockMahar = [
            WeddingSeserahan(
              itemId: 'ses_9_${widget.profileId}',
              weddingProfileId: widget.profileId,
              direction: 'MAHAR',
              itemName: 'Logam Mulia Antam 10 Gram (CertiCard)',
              quantity: 1,
              estimatedPrice: 14500000.0,
              status: 'SIAP',
              notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
            ),
            WeddingSeserahan(
              itemId: 'ses_10_${widget.profileId}',
              weddingProfileId: widget.profileId,
              direction: 'MAHAR',
              itemName: 'Satu Set Mukena Sutra & Al-Qur\'an Terjemahan',
              quantity: 1,
              estimatedPrice: 1850000.0,
              status: 'SIAP',
              notes: null, // Contoh tidak diisi link produk
            ),
            WeddingSeserahan(
              itemId: 'ses_11_${widget.profileId}',
              weddingProfileId: widget.profileId,
              direction: 'MAHAR',
              itemName: 'Uang Mahar Hias Frame 3D (Rp 2.026.100)',
              quantity: 1,
              estimatedPrice: 2250000.0,
              status: 'SIAP',
              notes: 'https://tk.tokopedia.com/ZSbmVBAyB/',
            ),
          ];
          for (final m in mockMahar) {
            await repo.createSeserahan(m);
          }
        }

        // 2. Update existing items with new target link or null
        for (final item in allItems) {
          final isOldOrLegacy = item.notes != null && (item.notes!.contains('ZSbmXeeoA') || !_isValidUrl(item.notes));
          if (isOldOrLegacy) {
            final name = item.itemName.toLowerCase();
            final shouldHaveLink = name.contains('perhiasan') ||
                name.contains('mukena sutra bordir') ||
                name.contains('tas kulit') ||
                name.contains('jas formal') ||
                name.contains('sajadah turki') ||
                name.contains('logam mulia') ||
                name.contains('uang mahar');

            final updated = item.copyWith(
              notes: shouldHaveLink ? 'https://tk.tokopedia.com/ZSbmVBAyB/' : null,
            );
            await repo.updateSeserahan(updated);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openProductLink(String rawUrl, BuildContext context) async {
    var urlStr = rawUrl.trim();
    if (!urlStr.startsWith('http://') && !urlStr.startsWith('https://')) {
      urlStr = 'https://$urlStr';
    }
    final uri = Uri.tryParse(urlStr);
    if (uri != null) {
      try {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka tautan produk')),
          );
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Format tautan produk tidak valid')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(weddingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seserahan & Mahar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showSeserahanGuide(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: const [
            Tab(text: 'Seserahan CPP'),
            Tab(text: 'Balasan CPW'),
            Tab(text: 'Mahar'),
          ],
        ),
      ),
      body: StreamBuilder<List<WeddingSeserahan>>(
        stream: repo.watchSeserahan(widget.profileId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorStateView(
              errorMessage: snapshot.error.toString(),
              onRetry: () => setState(() {}),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonListView(showHeader: true);
          }

          final allItems = snapshot.data ?? [];
          _checkAndSyncMockData(allItems, repo);

          final cppItems = allItems.where((s) => s.direction == 'SESERAHAN_CPP').toList();
          final cpwItems = allItems.where((s) => s.direction == 'BALASAN_CPW').toList();
          final maharItems = allItems.where((s) => s.direction == 'MAHAR').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildSectionView(
                context,
                'SESERAHAN_CPP',
                'Seserahan Pria ke Wanita',
                '(CPP → CPW)',
                cppItems,
              ),
              _buildSectionView(
                context,
                'BALASAN_CPW',
                'Balasan Wanita ke Pria',
                '(CPW → CPP)',
                cpwItems,
              ),
              _buildSectionView(
                context,
                'MAHAR',
                'Mahar & Mas Kawin',
                '(Akad Pernikahan)',
                maharItems,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String direction = 'SESERAHAN_CPP';
          if (_tabController.index == 1) direction = 'BALASAN_CPW';
          if (_tabController.index == 2) direction = 'MAHAR';
          _showAddItemDialog(context, initialDirection: direction);
        },
        child: const Icon(Icons.add_shopping_cart_rounded),
      ),
    );
  }

  Widget _buildSectionView(
    BuildContext context,
    String direction,
    String titleLine1,
    String titleLine2,
    List<WeddingSeserahan> items,
  ) {
    final theme = Theme.of(context);
    final totalCost = items.fold(0.0, (acc, i) => acc + i.estimatedPrice);
    final totalItems = items.length;
    final readyItems = items.where((i) => i.status == 'SIAP').length;
    final progress = totalItems > 0 ? (readyItems / totalItems) : 0.0;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        // Hero Overview Card
        BentoCard(
          padding: const EdgeInsets.all(18),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleLine1,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          titleLine2,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Estimasi',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyUtils.formatRupiah(totalCost),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kesiapan Barang:',
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
                  Text(
                    '$readyItems / $totalItems Siap (${(progress * 100).toInt()}%)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (items.isEmpty)
          _buildEmptySectionState(context, direction)
        else
          ...items.map((item) => _buildItemCard(context, item)),

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, WeddingSeserahan item) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final repo = ref.read(weddingRepositoryProvider);
    final hasLink = _isValidUrl(item.notes);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: BentoCard(
        onTap: () => _showStatusPicker(context, item),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Leading Icon + Name/Qty + Action Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Icon Avatar
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.direction == 'MAHAR' ? Icons.diamond_outlined : Icons.card_giftcard_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Quantity
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${item.quantity} Barang',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // 3-dots Menu
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: Icon(Icons.more_vert_rounded, size: 20, color: theme.colorScheme.outline),
                  onSelected: (action) {
                    if (action == 'edit') {
                      _showAddItemDialog(context, itemToEdit: item);
                    } else if (action == 'delete') {
                      showDeleteConfirmDialog(
                        context: context,
                        itemName: item.itemName,
                        onConfirm: () async {
                          await repo.deleteSeserahan(item.itemId);
                          if (context.mounted) {
                            AppFeedback.showUndo(
                              context,
                              message: '"${item.itemName}" berhasil dihapus',
                              onUndo: () => repo.createSeserahan(item),
                            );
                          }
                        },
                      );
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit Barang')),
                    const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Subtle Divider Line
            Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),

            const SizedBox(height: 10),

            // Bottom Row: Price on Left + Action Badges (Link & Status) on Right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price Tag
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimasi Biaya',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      CurrencyUtils.formatRupiah(item.estimatedPrice),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                // Right Meta & Action Badges
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Link Action Button (if exists)
                    if (hasLink) ...[
                      Material(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _openProductLink(item.notes!, context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.link_rounded,
                                  size: 15,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Produk',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Status Chip
                    StatusChip(status: item.status),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySectionState(BuildContext context, String direction) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.card_giftcard_outlined, size: 48, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Daftar Barang',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Catat daftar isi kotak seserahan, mahar pernikahan, atau hantaran balasan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 18),
            FilledButton.tonalIcon(
              onPressed: () => _showAddItemDialog(context, initialDirection: direction),
              icon: const Icon(Icons.add_shopping_cart_rounded),
              label: const Text('Tambah Barang Pertama'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, {String? initialDirection, WeddingSeserahan? itemToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddSeserahanBottomSheet(
        profileId: widget.profileId,
        initialDirection: initialDirection ?? 'SESERAHAN_CPP',
        itemToEdit: itemToEdit,
      ),
    );
  }

  void _showStatusPicker(BuildContext context, WeddingSeserahan item) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Ubah Status Barang',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.radio_button_unchecked, color: Colors.grey),
              title: const Text('Belum Beli'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateSeserahan(item.copyWith(status: 'BELUM_BELI'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: Colors.purple),
              title: const Text('Sudah Dibeli'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateSeserahan(item.copyWith(status: 'DIBELI'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard, color: Colors.orange),
              title: const Text('Sedang Dihias'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateSeserahan(item.copyWith(status: 'WRAPPING'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: const Text('Siap'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateSeserahan(item.copyWith(status: 'SIAP'));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSeserahanGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Panduan Seserahan & Mahar',
      screenPurpose:
          'Pantau dan kelola seluruh daftar barang hantaran seserahan, balasan, serta mahar mas kawin agar rapi, terdokumentasi, dan siap tepat waktu.',
      features: const [
        WeddingGuideFeature(
          title: '3 Kategori Terarah',
          description: 'Pemisahan jelas antara barang seserahan pria (CPP), balasan wanita (CPW), dan mahar mas kawin.',
          icon: Icons.tab_rounded,
        ),
        WeddingGuideFeature(
          title: 'Tautan Produk Online',
          description: 'Simpan link produk e-commerce (Tokopedia, Shopee, dll) untuk mempermudah pembelian dan pengecekan spesifikasi barang.',
          icon: Icons.link_rounded,
        ),
        WeddingGuideFeature(
          title: 'Status Kesiapan',
          description: 'Pantau status barang: Belum Beli, Sudah Dibeli, Sedang Dihias, hingga Siap untuk hari pernikahan.',
          icon: Icons.check_circle_outline_rounded,
        ),
        WeddingGuideFeature(
          title: 'Kalkulasi Estimasi',
          description: 'Total anggaran dan persentase kesiapan barang otomatis terakumulasi secara real-time di setiap kategori.',
          icon: Icons.auto_graph_rounded,
        ),
      ],
      proTip: 'Ketuk pada kartu barang untuk memperbarui status kesiapan secara instan!',
    );
  }
}

class _AddSeserahanBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final String initialDirection;
  final WeddingSeserahan? itemToEdit;

  const _AddSeserahanBottomSheet({
    required this.profileId,
    required this.initialDirection,
    this.itemToEdit,
  });

  @override
  ConsumerState<_AddSeserahanBottomSheet> createState() => _AddSeserahanBottomSheetState();
}

class _AddSeserahanBottomSheetState extends ConsumerState<_AddSeserahanBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  late String _direction;
  String _status = 'BELUM_BELI';
  int _qty = 1;
  double _price = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _direction = widget.initialDirection;
    if (widget.itemToEdit != null) {
      final s = widget.itemToEdit!;
      _nameController.text = s.itemName;
      _notesController.text = (s.notes != null && (s.notes!.startsWith('http://') || s.notes!.startsWith('https://') || s.notes!.contains('tokopedia') || s.notes!.contains('shopee')))
          ? s.notes!
          : '';
      _direction = s.direction;
      _status = s.status;
      _qty = s.quantity;
      _price = s.estimatedPrice;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.itemToEdit != null;

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
                isEdit ? 'Edit Barang' : 'Tambah Barang Baru',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _direction,
                decoration: const InputDecoration(labelText: 'Jenis Hantaran'),
                items: SeserahanDirection.values
                    .map((d) => DropdownMenuItem(value: d.value, child: Text(d.label)))
                    .toList(),
                onChanged: (val) => setState(() => _direction = val ?? 'SESERAHAN_CPP'),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _nameController,
                inputFormatters: [LengthLimitingTextInputFormatter(60)],
                maxLength: 60,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang / Item',
                  hintText: 'Cth: Set Perhiasan, Mukena, Skincare',
                ),
                validator: (v) => ValidationUtils.validateRequired(v, 'Nama barang'),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _qty.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      maxLength: 3,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: const InputDecoration(labelText: 'Jumlah (Qty)'),
                      validator: (val) => ValidationUtils.validateMinNumber(
                        int.tryParse(val ?? ''),
                        1,
                        'Jumlah (Qty)',
                      ),
                      onChanged: (val) => _qty = int.tryParse(val) ?? 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: CurrencyTextField(
                      labelText: 'Estimasi Harga',
                      initialValue: _price,
                      onChanged: (val) => _price = val,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status Kesiapan'),
                items: SeserahanStatus.values
                    .map((s) => DropdownMenuItem(value: s.value, child: Text(s.label)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val ?? 'BELUM_BELI'),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _notesController,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                maxLength: 200,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(
                  labelText: 'Link Produk (Opsional)',
                  hintText: 'Cth: https://tk.tokopedia.com/...',
                  prefixIcon: Icon(Icons.link_rounded),
                ),
                keyboardType: TextInputType.url,
                validator: (v) => ValidationUtils.validateUrl(v, isRequired: false),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveItem,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Barang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(weddingRepositoryProvider);
      if (widget.itemToEdit != null) {
        final updated = widget.itemToEdit!.copyWith(
          direction: _direction,
          itemName: _nameController.text.trim(),
          quantity: _qty,
          estimatedPrice: _price,
          status: _status,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
        await repo.updateSeserahan(updated);
        if (mounted) {
          AppFeedback.showSuccess(context, message: 'Barang berhasil diperbarui');
        }
      } else {
        final newItem = WeddingSeserahan(
          itemId: UuidUtils.generateId(),
          weddingProfileId: widget.profileId,
          direction: _direction,
          itemName: _nameController.text.trim(),
          quantity: _qty,
          estimatedPrice: _price,
          status: _status,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
        await repo.createSeserahan(newItem);
        if (mounted) {
          AppFeedback.showSuccess(context, message: 'Barang berhasil ditambahkan');
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        AppFeedback.showError(context, message: 'Gagal menyimpan barang: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
