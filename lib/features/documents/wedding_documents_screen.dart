import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/currency_utils.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/currency_text_field.dart';
import '../../shared/widgets/date_selector_button.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';

class WeddingDocumentsScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingDocumentsScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingDocumentsScreen> createState() => _WeddingDocumentsScreenState();
}

class _WeddingDocumentsScreenState extends ConsumerState<WeddingDocumentsScreen> {
  String _selectedOwner = 'SEMUA';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(weddingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dokumen Pernikahan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Panduan Fitur',
            onPressed: () => _showDocumentsGuide(context),
          ),
        ],
      ),
      body: StreamBuilder<List<WeddingDocument>>(
        stream: repo.watchDocuments(widget.profileId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data ?? [];
          final completedCount = allDocs.where((d) => d.isCompleted).length;
          final totalCount = allDocs.length;
          final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;
          final totalAdminCost = allDocs.fold(0.0, (acc, d) => acc + d.adminCost);

          final filteredDocs = List<WeddingDocument>.from(
            _selectedOwner == 'SEMUA'
                ? allDocs
                : allDocs.where((d) => d.ownerType == _selectedOwner),
          )..sort((a, b) {
              // 1. Incomplete documents first, completed documents go to the bottom
              if (a.isCompleted != b.isCompleted) {
                return a.isCompleted ? 1 : -1;
              }

              // 2. Sort by closest due date first (ascending)
              if (a.dueDate != null && b.dueDate != null) {
                final dateComp = a.dueDate!.compareTo(b.dueDate!);
                if (dateComp != 0) return dateComp;
              } else if (a.dueDate != null) {
                return -1; // a has due date, prioritize
              } else if (b.dueDate != null) {
                return 1; // b has due date, prioritize
              }

              // 3. Fallback to docName
              return a.docName.compareTo(b.docName);
            });

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Summary Progress Card
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kelengkapan Berkas',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$completedCount dari $totalCount Selesai (${(progress * 100).toInt()}%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                        valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                      ),
                    ),
                    if (totalAdminCost > 0) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Total Biaya Administrasi: ${CurrencyUtils.formatRupiah(totalAdminCost)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Owner Filter Chips
              _buildOwnerFilterChips(allDocs),
              const SizedBox(height: 16),

              // Documents List
              if (filteredDocs.isEmpty)
                _buildEmptyDocumentsState(context)
              else
                ...filteredDocs.map((doc) => _buildDocCard(context, doc)),

              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Dokumen',
        onPressed: () => _showAddDocDialog(context),
        child: const Icon(Icons.note_add_rounded),
      ),
    );
  }

  Widget _buildOwnerFilterChips(List<WeddingDocument> docs) {
    final owners = [
      {'val': 'SEMUA', 'label': 'Semua Berkas'},
      {'val': 'GROOM', 'label': 'Berkas CPP'},
      {'val': 'BRIDE', 'label': 'Berkas CPW'},
      {'val': 'BOTH', 'label': 'Berkas Bersama'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: owners.map((o) {
          final isSelected = _selectedOwner == o['val'];
          final count = o['val'] == 'SEMUA'
              ? docs.length
              : docs.where((d) => d.ownerType == o['val']).length;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('${o['label']} ($count)'),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedOwner = o['val']!),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDocCard(BuildContext context, WeddingDocument doc) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final repo = ref.read(weddingRepositoryProvider);

    DateTime? dueDateTime;
    bool isOverdue = false;
    if (doc.dueDate != null) {
      dueDateTime = DateTime.fromMillisecondsSinceEpoch(doc.dueDate!);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final itemDate = DateTime(dueDateTime.year, dueDateTime.month, dueDateTime.day);
      isOverdue = !doc.isCompleted && itemDate.isBefore(today);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BentoCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: doc.isCompleted,
              onChanged: (val) {
                repo.toggleDocumentCompletion(doc, val ?? false);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.docName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: doc.isCompleted ? TextDecoration.lineThrough : null,
                      color: doc.isCompleted ? Colors.grey : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Owner Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: doc.isCompleted
                              ? (isDark ? Colors.grey[800] : Colors.grey[200])
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getOwnerLabel(doc.ownerType),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: doc.isCompleted
                                ? Colors.grey[500]
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),

                      // Deadline Badge
                      if (dueDateTime != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: doc.isCompleted
                                ? (isDark ? Colors.grey[800] : Colors.grey[200])
                                : isOverdue
                                    ? Colors.red.withValues(alpha: 0.12)
                                    : theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                            border: isOverdue && !doc.isCompleted
                                ? Border.all(color: Colors.red.withValues(alpha: 0.4), width: 0.8)
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isOverdue ? Icons.error_outline_rounded : Icons.event_outlined,
                                size: 12,
                                color: doc.isCompleted
                                    ? Colors.grey[500]
                                    : isOverdue
                                        ? Colors.red
                                        : theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                WeddingDateUtils.formatShort(doc.dueDate!),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: doc.isCompleted
                                      ? Colors.grey[500]
                                      : isOverdue
                                          ? Colors.red
                                          : theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Admin Cost Badge
                      if (doc.adminCost > 0)
                        Text(
                          'Biaya: ${CurrencyUtils.formatRupiah(doc.adminCost)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: doc.isCompleted ? Colors.grey : theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: Icon(Icons.more_vert_rounded, size: 18, color: theme.colorScheme.outline),
              onSelected: (action) {
                if (action == 'edit') {
                  _showAddDocDialog(context, docToEdit: doc);
                } else if (action == 'delete') {
                  showDeleteConfirmDialog(
                    context: context,
                    itemName: doc.docName,
                    onConfirm: () async => await repo.deleteDocument(doc.docId),
                  );
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit Dokumen')),
                const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getOwnerLabel(String owner) {
    switch (owner) {
      case 'GROOM':
        return 'Mempelai Pria (CPP)';
      case 'BRIDE':
        return 'Mempelai Wanita (CPW)';
      default:
        return 'Bersama';
    }
  }

  Widget _buildEmptyDocumentsState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.description_outlined, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'Belum Ada Dokumen Tercatat',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Kelola berkas persyaratan nikah KUA atau Catatan Sipil.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDocDialog(BuildContext context, {WeddingDocument? docToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddDocBottomSheet(
        profileId: widget.profileId,
        docToEdit: docToEdit,
      ),
    );
  }

  void _showDocumentsGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Dokumen Persyaratan Nikah',
      screenPurpose:
          'Daftar kelengkapan berkas administrasi pernikahan (KUA atau Catatan Sipil) agar proses pendaftaran nikah rapi dan selesai tepat waktu.',
      features: const [
        WeddingGuideFeature(
          title: 'Target Selesai & Deadline',
          description: 'Atur batas waktu pengurusan berkas agar tidak mepet dengan hari akad nikah.',
          icon: Icons.event_available_rounded,
        ),
        WeddingGuideFeature(
          title: 'Prioritas Otomatis',
          description: 'Berkas mendesak muncul paling atas, sedangkan berkas yang sudah dicentang otomatis turun ke bawah.',
          icon: Icons.sort_rounded,
        ),
        WeddingGuideFeature(
          title: 'Pemilik Berkas',
          description: 'Kelompokkan berkas milik CPP, CPW, atau berkas bersama agar pembagian tugas jelas.',
          icon: Icons.badge_outlined,
        ),
        WeddingGuideFeature(
          title: 'Catatan Biaya Administrasi',
          description: 'Pantau total biaya pendaftaran nikah dan formulir kelurahan secara transparan.',
          icon: Icons.payments_outlined,
        ),
      ],
      proTip: 'Urus surat pengantar kelurahan (N1 hingga N4) sekitar 1 sampai 3 bulan sebelum tanggal pernikahan.',
    );
  }
}

class _AddDocBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingDocument? docToEdit;

  const _AddDocBottomSheet({required this.profileId, this.docToEdit});

  @override
  ConsumerState<_AddDocBottomSheet> createState() => _AddDocBottomSheetState();
}

class _AddDocBottomSheetState extends ConsumerState<_AddDocBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _ownerType = 'BOTH';
  double _cost = 0.0;
  int? _dueDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.docToEdit != null) {
      final d = widget.docToEdit!;
      _nameController.text = d.docName;
      _ownerType = d.ownerType;
      _cost = d.adminCost;
      _dueDate = d.dueDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.docToEdit != null;

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
                isEdit ? 'Edit Dokumen' : 'Tambah Dokumen Persyaratan',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Dokumen',
                  hintText: 'Cth: Surat Pengantar N1-N4, Akta Kelahiran',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama dokumen wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _ownerType,
                decoration: const InputDecoration(labelText: 'Pemilik Berkas'),
                items: const [
                  DropdownMenuItem(value: 'BOTH', child: Text('Bersama (Kedua Mempelai)')),
                  DropdownMenuItem(value: 'GROOM', child: Text('Mempelai Pria (CPP)')),
                  DropdownMenuItem(value: 'BRIDE', child: Text('Mempelai Wanita (CPW)')),
                ],
                onChanged: (val) => setState(() => _ownerType = val ?? 'BOTH'),
              ),
              const SizedBox(height: 14),

              DateSelectorButton(
                label: 'Target Selesai (Deadline)',
                selectedEpochMillis: _dueDate ?? 0,
                onDateSelected: (millis) => setState(() => _dueDate = millis),
              ),
              const SizedBox(height: 14),

              CurrencyTextField(
                labelText: 'Biaya Administrasi (Opsional)',
                initialValue: _cost,
                onChanged: (val) => _cost = val,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveDoc,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Dokumen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveDoc() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(weddingRepositoryProvider);
      if (widget.docToEdit != null) {
        final updated = widget.docToEdit!.copyWith(
          docName: _nameController.text.trim(),
          ownerType: _ownerType,
          adminCost: _cost,
          dueDate: _dueDate,
        );
        await repo.updateDocument(updated);
      } else {
        final newDoc = WeddingDocument(
          docId: UuidUtils.generateId(),
          weddingProfileId: widget.profileId,
          docName: _nameController.text.trim(),
          ownerType: _ownerType,
          adminCost: _cost,
          dueDate: _dueDate,
        );
        await repo.createDocument(newDoc);
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
