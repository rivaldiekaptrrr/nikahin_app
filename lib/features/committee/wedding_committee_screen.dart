import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/app_feedback.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/error_state_view.dart';
import '../../shared/widgets/skeleton_loading.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';

class WeddingCommitteeScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingCommitteeScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingCommitteeScreen> createState() => _WeddingCommitteeScreenState();
}

class _WeddingCommitteeScreenState extends ConsumerState<WeddingCommitteeScreen> {
  String _selectedSide = 'SEMUA';
  bool _isModuleEnabled = true;
  bool _isLoadingPref = true;

  @override
  void initState() {
    super.initState();
    _loadModulePref();
  }

  Future<void> _loadModulePref() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('pref_committee_enabled_${widget.profileId}') ?? true;
    if (mounted) {
      setState(() {
        _isModuleEnabled = enabled;
        _isLoadingPref = false;
      });
    }
  }

  Future<void> _setModuleEnabled(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_committee_enabled_${widget.profileId}', val);
    if (mounted) {
      setState(() {
        _isModuleEnabled = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(weddingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panitia & Seragam'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Panduan Fitur',
            onPressed: () => _showCommitteeGuide(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Tooltip(
                message: _isModuleEnabled ? 'Nonaktifkan Modul' : 'Aktifkan Modul',
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch.adaptive(
                    value: _isModuleEnabled,
                    activeTrackColor: theme.colorScheme.primary,
                    onChanged: (val) => _setModuleEnabled(val),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoadingPref
          ? const Center(child: CircularProgressIndicator())
          : !_isModuleEnabled
              ? _buildDisabledState(context)
              : StreamBuilder<List<WeddingCommitteeMember>>(
                  stream: repo.watchCommittee(widget.profileId),
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

                    final allMembers = snapshot.data ?? [];
                    final filtered = _selectedSide == 'SEMUA'
                        ? allMembers
                        : allMembers.where((m) => m.side == _selectedSide).toList();

                    final totalFabric = allMembers.fold(0.0, (acc, m) => acc + m.fabricMeters);
                    final readyUniforms = allMembers.where((m) => m.uniformStatus == 'SIAP_PAKAI').length;

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      children: [
                        // Summary Banner
                        BentoCard(
                          padding: const EdgeInsets.all(16),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
                              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCol('Total Panitia', '${allMembers.length} Orang'),
                              _buildStatCol('Seragam Siap', '$readyUniforms dari ${allMembers.length}'),
                              _buildStatCol('Total Kain', '${totalFabric.toStringAsFixed(1)} Meter', isPrimary: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Side Filter Chips
                        _buildSideFilterChips(allMembers),
                        const SizedBox(height: 16),

                        // Committee List
                        if (filtered.isEmpty)
                          _buildEmptyCommitteeState(context)
                        else
                          ...filtered.map((member) => _buildMemberCard(context, member)),

                        const SizedBox(height: 80),
                      ],
                    );
                  },
                ),
      floatingActionButton: _isModuleEnabled
          ? FloatingActionButton(
              onPressed: () => _showAddMemberDialog(context),
              child: const Icon(Icons.person_add_alt_1_rounded),
            )
          : null,
    );
  }

  Widget _buildDisabledState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checkroom_outlined,
                size: 52,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Modul Panitia & Seragam Nonaktif',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Modul ini opsional. Jika pasangan menyewa seluruh seragam atau tidak memerlukan pembagian kain mandiri, modul ini dapat dibiarkan nonaktif.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _setModuleEnabled(true),
              icon: const Icon(Icons.toggle_on_outlined),
              label: const Text('Aktifkan Modul Panitia'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value, {bool isPrimary = false}) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isPrimary ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSideFilterChips(List<WeddingCommitteeMember> members) {
    final sides = [
      {'val': 'SEMUA', 'label': 'Semua Pihak'},
      {'val': 'KELUARGA_CPP', 'label': 'Keluarga CPP'},
      {'val': 'KELUARGA_CPW', 'label': 'Keluarga CPW'},
      {'val': 'TEMAN_CPP', 'label': 'Teman CPP'},
      {'val': 'TEMAN_CPW', 'label': 'Teman CPW'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sides.map((s) {
          final isSelected = _selectedSide == s['val'];
          final count = s['val'] == 'SEMUA'
              ? members.length
              : members.where((m) => m.side == s['val']).length;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('${s['label']} ($count)'),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedSide = s['val']!),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, WeddingCommitteeMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final repo = ref.read(weddingRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: BentoCard(
        onTap: () => _showUniformStatusPicker(context, member),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar + Name & Role + 3-dots Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.memberName,
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
                        'Peran: ${member.role}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                      _showAddMemberDialog(context, memberToEdit: member);
                    } else if (action == 'delete') {
                      showDeleteConfirmDialog(
                        context: context,
                        itemName: member.memberName,
                        onConfirm: () async {
                          await repo.deleteCommittee(member.memberId);
                          if (context.mounted) {
                            AppFeedback.showUndo(
                              context,
                              message: '"${member.memberName}" berhasil dihapus',
                              onUndo: () => repo.createCommittee(member),
                            );
                          }
                        },
                      );
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit Data')),
                    const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Divider Line
            Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),

            const SizedBox(height: 10),

            // Bottom Row: Pihak Badge & Uniform on Left + StatusChip on Right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Pihak Badge + Seragam info (Expanded to avoid any overflow)
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _formatSide(member.side),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (member.uniformDescription != null && member.uniformDescription!.trim().isNotEmpty)
                        Text(
                          member.fabricMeters > 0
                              ? '${member.uniformDescription} (${member.fabricMeters} m)'
                              : member.uniformDescription!,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      else if (member.fabricMeters > 0)
                        Text(
                          '${member.fabricMeters} Meter Kain',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Status Chip
                StatusChip(status: member.uniformStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatSide(String side) {
    switch (side) {
      case 'KELUARGA_CPP':
        return 'Keluarga CPP';
      case 'KELUARGA_CPW':
        return 'Keluarga CPW';
      case 'TEMAN_CPP':
        return 'Teman CPP';
      case 'TEMAN_CPW':
        return 'Teman CPW';
      default:
        return side;
    }
  }

  Widget _buildEmptyCommitteeState(BuildContext context) {
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
              child: Icon(Icons.groups_outlined, size: 48, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Anggota Panitia',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Catat susunan panitia keluarga, saksi nikah, among tamu, dan pembagian seragam.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 18),
            FilledButton.tonalIcon(
              onPressed: () => _showAddMemberDialog(context),
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Tambah Panitia Pertama'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, {WeddingCommitteeMember? memberToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddCommitteeBottomSheet(
        profileId: widget.profileId,
        memberToEdit: memberToEdit,
      ),
    );
  }

  void _showUniformStatusPicker(BuildContext context, WeddingCommitteeMember member) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Status Jahit Seragam',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
              title: const Text('Belum Dibagi'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateCommittee(member.copyWith(uniformStatus: 'BELUM_DIBAGI'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.cut_outlined, color: Colors.orange),
              title: const Text('Sedang Jahit'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateCommittee(member.copyWith(uniformStatus: 'SEDANG_JAHIT'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: const Text('Siap Pakai'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateCommittee(member.copyWith(uniformStatus: 'SIAP_PAKAI'));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCommitteeGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Panduan Panitia & Seragam',
      screenPurpose:
          'Modul ini bersifat opsional untuk mencatat susunan panitia keluarga serta pembagian jatah kain seragam. Jika seluruh seragam memakai sistem sewa, Anda dapat menonaktifkan modul ini melalui switch di pojok kanan atas.',
      features: const [
        WeddingGuideFeature(
          title: 'Fitur Opsional (Sewa Seragam)',
          description: 'Gunakan switch di atas untuk menonaktifkan modul jika Anda menyewa seragam atau tidak membentuk panitia mandiri.',
          icon: Icons.toggle_on_outlined,
        ),
        WeddingGuideFeature(
          title: 'Pembagian Pihak & Peran',
          description: 'Kelompokkan panitia berdasarkan pihak keluarga pria (CPP), keluarga wanita (CPW), atau teman dengan peran spesifik.',
          icon: Icons.assignment_ind_outlined,
        ),
        WeddingGuideFeature(
          title: 'Status Jahit Seragam',
          description: 'Pantau seragam dari status Belum Dibagi, Sedang Jahit, hingga Siap Pakai di hari pernikahan.',
          icon: Icons.checkroom_outlined,
        ),
        WeddingGuideFeature(
          title: 'Kalkulasi Total Kain',
          description: 'Total kebutuhan meteran kain dihitung otomatis untuk memudahkan estimasi saat berbelanja di toko kain.',
          icon: Icons.straighten_outlined,
        ),
      ],
      proTip: 'Ketuk pada kartu panitia untuk langsung mengubah status seragam secara cepat!',
    );
  }
}

class _AddCommitteeBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingCommitteeMember? memberToEdit;

  const _AddCommitteeBottomSheet({required this.profileId, this.memberToEdit});

  @override
  ConsumerState<_AddCommitteeBottomSheet> createState() => _AddCommitteeBottomSheetState();
}

class _AddCommitteeBottomSheetState extends ConsumerState<_AddCommitteeBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _uniformDescController = TextEditingController();
  String _side = 'KELUARGA_CPP';
  String _uniformStatus = 'BELUM_DIBAGI';
  double _fabricMeters = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.memberToEdit != null) {
      final m = widget.memberToEdit!;
      _nameController.text = m.memberName;
      _roleController.text = m.role;
      _phoneController.text = m.phoneNumber ?? '';
      _uniformDescController.text = m.uniformDescription ?? '';
      _side = m.side;
      _uniformStatus = m.uniformStatus;
      _fabricMeters = m.fabricMeters;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _uniformDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.memberToEdit != null;

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
                isEdit ? 'Edit Panitia' : 'Tambah Panitia Baru',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                  ValidationUtils.nameInputFormatter,
                ],
                maxLength: 50,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (v) => ValidationUtils.validateName(v, 'Nama lengkap'),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _roleController,
                inputFormatters: [LengthLimitingTextInputFormatter(40)],
                maxLength: 40,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(
                  labelText: 'Peran & Tugas (cth: Saksi Nikah, Among Tamu, Meja Resepsi, MC)',
                ),
                validator: (v) => ValidationUtils.validateRequired(v, 'Peran tugas'),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _side,
                decoration: const InputDecoration(labelText: 'Pihak'),
                items: CommitteeSide.values
                    .map((s) => DropdownMenuItem(value: s.value, child: Text(s.label)))
                    .toList(),
                onChanged: (val) => setState(() => _side = val ?? 'KELUARGA_CPP'),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(16),
                  ValidationUtils.phoneInputFormatter,
                ],
                maxLength: 16,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(labelText: 'Nomor Telepon WhatsApp (Opsional)'),
                validator: (v) => ValidationUtils.validatePhoneIndo(v, isRequired: false),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _uniformDescController,
                      inputFormatters: [LengthLimitingTextInputFormatter(80)],
                      maxLength: 80,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: const InputDecoration(labelText: 'Deskripsi Seragam & Warna'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: _fabricMeters > 0 ? _fabricMeters.toString() : '',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                        LengthLimitingTextInputFormatter(4),
                      ],
                      maxLength: 4,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: const InputDecoration(labelText: 'Jatah Kain (Meter)'),
                      onChanged: (val) => _fabricMeters = double.tryParse(val) ?? 0.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _uniformStatus,
                decoration: const InputDecoration(labelText: 'Status Seragam'),
                items: UniformStatus.values
                    .map((u) => DropdownMenuItem(value: u.value, child: Text(u.label)))
                    .toList(),
                onChanged: (val) => setState(() => _uniformStatus = val ?? 'BELUM_DIBAGI'),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveMember,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Panitia'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(weddingRepositoryProvider);
      if (widget.memberToEdit != null) {
        final updated = widget.memberToEdit!.copyWith(
          memberName: _nameController.text.trim(),
          role: _roleController.text.trim(),
          side: _side,
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          uniformDescription: _uniformDescController.text.trim().isEmpty ? null : _uniformDescController.text.trim(),
          fabricMeters: _fabricMeters,
          uniformStatus: _uniformStatus,
        );
        await repo.updateCommittee(updated);
        if (mounted) {
          AppFeedback.showSuccess(context, message: 'Data panitia berhasil diperbarui');
        }
      } else {
        final newMember = WeddingCommitteeMember(
          memberId: UuidUtils.generateId(),
          weddingProfileId: widget.profileId,
          memberName: _nameController.text.trim(),
          role: _roleController.text.trim(),
          side: _side,
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          uniformDescription: _uniformDescController.text.trim().isEmpty ? null : _uniformDescController.text.trim(),
          fabricMeters: _fabricMeters,
          uniformStatus: _uniformStatus,
        );
        await repo.createCommittee(newMember);
        if (mounted) {
          AppFeedback.showSuccess(context, message: 'Anggota panitia berhasil ditambahkan');
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        AppFeedback.showError(context, message: 'Gagal menyimpan data panitia: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
