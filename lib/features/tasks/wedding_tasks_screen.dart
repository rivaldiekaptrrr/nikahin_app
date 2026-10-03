import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/date_selector_button.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';

class WeddingTasksScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingTasksScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingTasksScreen> createState() => _WeddingTasksScreenState();
}

class _WeddingTasksScreenState extends ConsumerState<WeddingTasksScreen> {
  int? _selectedPhase; // null means 'SEMUA'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ref.watch(weddingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showTasksGuide(context),
          ),
        ],
      ),
      body: StreamBuilder<List<WeddingTask>>(
        stream: repo.watchTasks(widget.profileId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allTasks = snapshot.data ?? [];
          final completedCount = allTasks.where((t) => t.isCompleted).length;
          final totalCount = allTasks.length;
          final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;
          final percent = (progress * 100).toInt();

          final filteredTasks = List<WeddingTask>.from(
            _selectedPhase == null
                ? allTasks
                : allTasks.where((t) => t.phaseMonth == _selectedPhase),
          )..sort((a, b) {
              // 1. Incomplete tasks come first, completed tasks go to the bottom
              if (a.isCompleted != b.isCompleted) {
                return a.isCompleted ? 1 : -1;
              }

              // 2. Sort by closest due date first
              if (a.dueDate != null && b.dueDate != null) {
                final dateComp = a.dueDate!.compareTo(b.dueDate!);
                if (dateComp != 0) return dateComp;
              } else if (a.dueDate != null) {
                return -1; // a has due date, prioritize
              } else if (b.dueDate != null) {
                return 1;  // b has due date, prioritize
              }

              // 3. Fallback to phaseMonth or title
              final phaseComp = b.phaseMonth.compareTo(a.phaseMonth);
              if (phaseComp != 0) return phaseComp;
              return a.title.compareTo(b.title);
            });

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Summary Progress Card
              BentoCard(
                padding: const EdgeInsets.all(18),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.9),
                    theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progres Persiapan',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$completedCount / $totalCount Selesai ($percent%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                        valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Phase Filter Chips
              _buildPhaseFilterChips(),
              const SizedBox(height: 16),

              // Task Items
              if (filteredTasks.isEmpty)
                _buildEmptyTasksState(context)
              else
                ...filteredTasks.map((task) => _buildTaskCard(context, task)),

              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildPhaseFilterChips() {
    final phases = [
      {'val': null, 'label': 'Semua Fase'},
      {'val': 12, 'label': '12 Bulan'},
      {'val': 6, 'label': '6 Bulan'},
      {'val': 3, 'label': '3 Bulan'},
      {'val': 1, 'label': '1 Bulan'},
      {'val': 0, 'label': 'Hari-H'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: phases.map((p) {
          final isSelected = _selectedPhase == p['val'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(p['label'] as String),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedPhase = p['val'] as int?),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WeddingTask task) {
    final theme = Theme.of(context);
    final repo = ref.read(weddingRepositoryProvider);
    final picLabel = TaskPic.fromString(task.pic).label;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BentoCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (val) {
                repo.toggleTaskCompletion(task, val ?? false);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.grey : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      task.description!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getPhaseLabel(task.phaseMonth),
                          style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'PIC: $picLabel',
                          style: TextStyle(fontSize: 10, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (task.dueDate != null)
                        Text(
                          'Tenggat: ${WeddingDateUtils.formatShort(task.dueDate!)}',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, size: 18, color: theme.colorScheme.outline),
              onSelected: (action) {
                if (action == 'edit') {
                  _showAddTaskDialog(context, taskToEdit: task);
                } else if (action == 'delete') {
                  showDeleteConfirmDialog(
                    context: context,
                    itemName: task.title,
                    onConfirm: () async => await repo.deleteTask(task.taskId),
                  );
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit Tugas')),
                const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPhaseLabel(int phase) {
    if (phase == 0) return 'Hari-H';
    return '$phase Bulan Sebelum';
  }

  Widget _buildEmptyTasksState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.checklist_rounded, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'Tidak Ada Tugas di Fase Ini',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Tambah checklist tugas persiapan sesuai fase waktu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, {WeddingTask? taskToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddTaskBottomSheet(
        profileId: widget.profileId,
        taskToEdit: taskToEdit,
      ),
    );
  }

  void _showTasksGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Daftar Tugas Pernikahan',
      screenPurpose:
          'Membantumu mencatat dan memantau seluruh hal yang perlu disiapkan secara bertahap agar tidak ada persiapan penting yang terlewat.',
      features: const [
        WeddingGuideFeature(
          icon: Icons.calendar_month_rounded,
          title: 'Fase Waktu',
          description: 'Pilah tugas berdasarkan rentang waktu persiapan, mulai dari 12 bulan sebelum hingga Hari-H pernikahan.',
        ),
        WeddingGuideFeature(
          icon: Icons.assignment_ind_rounded,
          title: 'Penanggung Jawab (PIC)',
          description: 'Bagi tugas dengan jelas antara CPP, CPW, Bersama, Keluarga, atau Wedding Organizer (WO).',
        ),
        WeddingGuideFeature(
          icon: Icons.check_circle_outline_rounded,
          title: 'Urutan Deadline & Selesai',
          description: 'Tugas yang paling mendekati tenggat waktu tampil paling atas, dan tugas yang sudah selesai otomatis berpindah ke paling bawah.',
        ),
      ],
      proTip: 'Centang tugas yang sudah selesai untuk melihat persentase kesiapan pernikahanmu terus bertambah!',
    );
  }
}

class _AddTaskBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingTask? taskToEdit;

  const _AddTaskBottomSheet({required this.profileId, this.taskToEdit});

  @override
  ConsumerState<_AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<_AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  int _phaseMonth = 6;
  String _pic = 'BOTH';
  int? _dueDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      final t = widget.taskToEdit!;
      _titleController.text = t.title;
      _descController.text = t.description ?? '';
      _phaseMonth = t.phaseMonth;
      _pic = t.pic;
      _dueDate = t.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.taskToEdit != null;

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
                isEdit ? 'Edit Tugas' : 'Tambah Tugas Baru',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                initialValue: _phaseMonth,
                decoration: const InputDecoration(labelText: 'Fase Waktu'),
                items: const [
                  DropdownMenuItem(value: 12, child: Text('12 Bulan Sebelumnya')),
                  DropdownMenuItem(value: 6, child: Text('6 Bulan Sebelumnya')),
                  DropdownMenuItem(value: 3, child: Text('3 Bulan Sebelumnya')),
                  DropdownMenuItem(value: 1, child: Text('1 Bulan Sebelumnya')),
                  DropdownMenuItem(value: 0, child: Text('Hari-H (D-Day)')),
                ],
                onChanged: (val) => setState(() => _phaseMonth = val ?? 6),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Tugas'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul tugas wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi / Catatan (Opsional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _pic,
                decoration: const InputDecoration(labelText: 'Penanggung Jawab (PIC)'),
                items: TaskPic.values
                    .map((p) => DropdownMenuItem(value: p.value, child: Text(p.label)))
                    .toList(),
                onChanged: (val) => setState(() => _pic = val ?? 'BOTH'),
              ),
              const SizedBox(height: 14),

              DateSelectorButton(
                label: 'Tenggat Waktu (Due Date - Opsional)',
                selectedEpochMillis: _dueDate ?? 0,
                onDateSelected: (millis) => setState(() => _dueDate = millis),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveTask,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Tugas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(weddingRepositoryProvider);
      if (widget.taskToEdit != null) {
        final updated = widget.taskToEdit!.copyWith(
          phaseMonth: _phaseMonth,
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
          pic: _pic,
          dueDate: _dueDate,
        );
        await repo.updateTask(updated);
      } else {
        final newTask = WeddingTask(
          taskId: UuidUtils.generateId(),
          weddingProfileId: widget.profileId,
          phaseMonth: _phaseMonth,
          title: _titleController.text.trim(),
          description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
          pic: _pic,
          dueDate: _dueDate,
        );
        await repo.createTask(newTask);
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
