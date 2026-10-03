import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/date_selector_button.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';

class WeddingRundownScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingRundownScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingRundownScreen> createState() => _WeddingRundownScreenState();
}

class _WeddingRundownScreenState extends ConsumerState<WeddingRundownScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<WeddingEvent> _events = [];

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _updateTabController(List<WeddingEvent> events) {
    final newLength = events.isEmpty ? 1 : events.length;
    if (_tabController == null) {
      _tabController = TabController(length: newLength, vsync: this);
    } else if (_tabController!.length != newLength) {
      final prevIndex = _tabController!.index;
      final targetIndex = prevIndex.clamp(0, newLength - 1);
      _tabController?.dispose();
      _tabController = TabController(
        length: newLength,
        initialIndex: targetIndex,
        vsync: this,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(weddingRepositoryProvider);

    return StreamBuilder<List<WeddingEvent>>(
      stream: repo.watchEvents(widget.profileId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        _events = (snapshot.data ?? [])..sort((a, b) => a.eventDate.compareTo(b.eventDate));
        _updateTabController(_events);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Rundown & Acara'),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                tooltip: 'Panduan Fitur',
                onPressed: () => _showRundownGuide(context),
              ),
            ],
            bottom: _events.isNotEmpty
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                              tabs: _events.map((e) => Tab(text: e.eventName)).toList(),
                            ),
                          ),
                          // Subtle Vertical Divider between tabs and '+' button
                          Container(
                            height: 20,
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                          ),
                          // Frameless web-style '+' icon button
                          IconButton(
                            icon: const Icon(Icons.add_rounded, size: 22),
                            tooltip: 'Tambah Acara Baru',
                            splashRadius: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
                            onPressed: () => _showAddEventDialog(context),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
          body: _events.isEmpty
              ? _buildEmptyEventsState(context)
              : TabBarView(
                  controller: _tabController,
                  children: _events.map((event) => _buildEventRundownView(context, event)).toList(),
                ),
          floatingActionButton: _events.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () {
                    final currentEventIndex = _tabController?.index ?? 0;
                    if (currentEventIndex < _events.length) {
                      _showAddRundownItemDialog(context, _events[currentEventIndex].eventId);
                    }
                  },
                  child: const Icon(Icons.more_time_rounded),
                )
              : null,
        );
      },
    );
  }

  Widget _buildEventRundownView(BuildContext context, WeddingEvent event) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final repo = ref.watch(weddingRepositoryProvider);

    return StreamBuilder<List<WeddingRundownItem>>(
      stream: repo.watchRundownItems(event.eventId),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        final totalMinutes = items.fold(0, (acc, i) => acc + i.durationMinutes);
        final totalHours = (totalMinutes / 60).toStringAsFixed(totalMinutes % 60 == 0 ? 0 : 1);

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          children: [
            // Event Details Hero Overview Card
            BentoCard(
              padding: const EdgeInsets.all(18),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.event_available_rounded, color: theme.colorScheme.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.eventName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${WeddingDateUtils.formatFull(event.eventDate)} • ${event.eventLocation ?? "Lokasi belum diatur"}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[300] : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        icon: Icon(Icons.more_vert_rounded, size: 20, color: theme.colorScheme.outline),
                        onSelected: (action) {
                          if (action == 'edit') {
                            _showAddEventDialog(context, eventToEdit: event);
                          } else if (action == 'delete') {
                            showDeleteConfirmDialog(
                              context: context,
                              itemName: event.eventName,
                              onConfirm: () async {
                                await repo.deleteEvent(event.eventId);
                              },
                            );
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit Acara')),
                          const PopupMenuItem(value: 'delete', child: Text('Hapus Acara', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Divider
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),

                  const SizedBox(height: 12),

                  // Event Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat('Total Durasi', '$totalHours Jam ($totalMinutes mnt)', theme),
                      _buildHeaderStat('Rangkaian Sesi', '${items.length} Sesi Acara', theme),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timeline List Section
            if (items.isEmpty)
              _buildEmptyRundownItemsState(context, event.eventId)
            else
              ...List.generate(items.length, (index) {
                final item = items[index];
                final isLast = index == items.length - 1;
                return _buildTimelineItem(context, item, isLast: isLast);
              }),

            const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  Widget _buildHeaderStat(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, WeddingRundownItem item, {required bool isLast}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final repo = ref.read(weddingRepositoryProvider);
    final hasPic = item.pic != null && item.pic!.trim().isNotEmpty;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Time Header & Vertical Line Connector
          SizedBox(
            width: 68,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.timeStart,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  '${item.durationMinutes} mnt',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      Container(
                        width: 2,
                        color: isLast
                            ? Colors.transparent
                            : theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Timeline Node Indicator (Bullet)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast
                      ? Colors.transparent
                      : theme.colorScheme.primary.withValues(alpha: 0.25),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Right Column: Session Detail Card (Clean without MC Script box)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BentoCard(
                onTap: () => _showAddRundownItemDialog(context, item.eventId, itemToEdit: item),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: Session Title + 3-dots Menu
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            item.sessionTitle,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          icon: Icon(Icons.more_vert_rounded, size: 18, color: theme.colorScheme.outline),
                          onSelected: (action) {
                            if (action == 'edit') {
                              _showAddRundownItemDialog(context, item.eventId, itemToEdit: item);
                            } else if (action == 'delete') {
                              showDeleteConfirmDialog(
                                context: context,
                                itemName: item.sessionTitle,
                                onConfirm: () async => await repo.deleteRundownItem(item.itemId),
                              );
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit Sesi')),
                            const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ],
                    ),

                    // Footer: PIC Badge
                    if (hasPic) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_pin_circle_outlined,
                                  size: 13,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'PIC: ${item.pic}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyEventsState(BuildContext context) {
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
              child: Icon(Icons.event_note_rounded, size: 52, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Acara Pernikahan',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat sesi acara seperti "Akad Nikah", "Resepsi", "Pengajian", atau "Sangjit".',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _showAddEventDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Buat Acara Baru'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRundownItemsState(BuildContext context, String eventId) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.schedule_outlined, size: 44, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            const Text(
              'Belum Ada Susunan Rundown',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Susun jadwal kegiatan menit demi menit dan nama PIC lapangan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => _showAddRundownItemDialog(context, eventId),
              icon: const Icon(Icons.add_alarm_rounded),
              label: const Text('Tambah Sesi Pertama'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== ACTIONS & MODALS ====================
  void _showAddEventDialog(BuildContext context, {WeddingEvent? eventToEdit}) {
    showDialog(
      context: context,
      builder: (ctx) => _AddEventDialog(
        profileId: widget.profileId,
        eventToEdit: eventToEdit,
      ),
    );
  }

  void _showAddRundownItemDialog(BuildContext context, String eventId, {WeddingRundownItem? itemToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddRundownItemBottomSheet(
        eventId: eventId,
        itemToEdit: itemToEdit,
      ),
    );
  }

  void _showRundownGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Panduan Rundown & Susunan Acara',
      screenPurpose:
          'Kelola susunan acara pernikahan bertingkat (Akad Nikah, Resepsi, Pengajian) lengkap dengan jadwal menit demi menit dan penanggung jawab (PIC) lapangan.',
      features: const [
        WeddingGuideFeature(
          title: 'Multi-Acara (Tab)',
          description: 'Kelola jadwal terpisah antara Akad Nikah, Resepsi, Siraman, atau acara adat lainnya dalam tab berbeda.',
          icon: Icons.tab_rounded,
        ),
        WeddingGuideFeature(
          title: 'Alur Waktu Terhubung (Timeline)',
          description: 'Pantau urutan waktu yang saling terhubung dari awal kedatangan hingga acara selesai.',
          icon: Icons.timeline_rounded,
        ),
        WeddingGuideFeature(
          title: 'Penanggung Jawab (PIC)',
          description: 'Tetapkan petugas atau keluarga yang bertanggung jawab pada tiap sesi agar koordinasi lapangan berjalan rapi.',
          icon: Icons.person_pin_circle_outlined,
        ),
        WeddingGuideFeature(
          title: 'Akumulasi Durasi Otomatis',
          description: 'Total jam pelaksanaan dan jumlah sesi acara terhitung otomatis pada ringkasan di atas.',
          icon: Icons.timer_outlined,
        ),
      ],
      proTip: 'Susunan rundown ini dapat langsung diekspor rapi ke file PDF pada menu Pengaturan!',
    );
  }
}

class _AddEventDialog extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingEvent? eventToEdit;

  const _AddEventDialog({required this.profileId, this.eventToEdit});

  @override
  ConsumerState<_AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends ConsumerState<_AddEventDialog> {
  final _nameController = TextEditingController();
  final _locController = TextEditingController();
  int _eventDate = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    if (widget.eventToEdit != null) {
      final e = widget.eventToEdit!;
      _nameController.text = e.eventName;
      _locController.text = e.eventLocation ?? '';
      _eventDate = e.eventDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.eventToEdit != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Acara' : 'Tambah Acara Baru'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Acara',
                hintText: 'Cth: Akad Nikah, Resepsi, Sangjit',
              ),
            ),
            const SizedBox(height: 12),
            DateSelectorButton(
              label: 'Tanggal Acara',
              selectedEpochMillis: _eventDate,
              onDateSelected: (m) => setState(() => _eventDate = m),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locController,
              decoration: const InputDecoration(
                labelText: 'Tempat Acara (Opsional)',
                hintText: 'Cth: Masjid Agung, Ballroom Hotel',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        FilledButton(
          onPressed: () async {
            if (_nameController.text.trim().isEmpty) return;
            final repo = ref.read(weddingRepositoryProvider);
            if (widget.eventToEdit != null) {
              final updated = widget.eventToEdit!.copyWith(
                eventName: _nameController.text.trim(),
                eventLocation: _locController.text.trim().isEmpty ? null : _locController.text.trim(),
                eventDate: _eventDate,
              );
              await repo.updateEvent(updated);
            } else {
              final newEvent = WeddingEvent(
                eventId: UuidUtils.generateId(),
                weddingProfileId: widget.profileId,
                eventName: _nameController.text.trim(),
                eventDate: _eventDate,
                eventLocation: _locController.text.trim().isEmpty ? null : _locController.text.trim(),
              );
              await repo.createEvent(newEvent);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _AddRundownItemBottomSheet extends ConsumerStatefulWidget {
  final String eventId;
  final WeddingRundownItem? itemToEdit;

  const _AddRundownItemBottomSheet({required this.eventId, this.itemToEdit});

  @override
  ConsumerState<_AddRundownItemBottomSheet> createState() => _AddRundownItemBottomSheetState();
}

class _AddRundownItemBottomSheetState extends ConsumerState<_AddRundownItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _picController = TextEditingController();
  TimeOfDay _timeStart = const TimeOfDay(hour: 8, minute: 0);
  int _durationMinutes = 15;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.itemToEdit != null) {
      final i = widget.itemToEdit!;
      _titleController.text = i.sessionTitle;
      _picController.text = i.pic ?? '';
      _timeStart = WeddingDateUtils.parseTime(i.timeStart);
      _durationMinutes = i.durationMinutes;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _picController.dispose();
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
                isEdit ? 'Edit Sesi Rundown' : 'Tambah Sesi Rundown',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _timeStart,
                        );
                        if (picked != null) setState(() => _timeStart = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.schedule_rounded, color: theme.colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Waktu Mulai', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                Text(
                                  WeddingDateUtils.formatTimeOfDay(_timeStart),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: _durationMinutes.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Durasi (Menit)'),
                      onChanged: (val) => _durationMinutes = int.tryParse(val) ?? 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kegiatan & Sesi',
                  hintText: 'Cth: Akad Nikah, Penyambutan, Sungkeman',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama sesi wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _picController,
                decoration: const InputDecoration(
                  labelText: 'Penanggung Jawab PIC (Opsional)',
                  hintText: 'Cth: Mas Dimas (WO), Bapak H. Ahmad (KUA)',
                ),
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
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Sesi'),
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
      final timeFormatted = WeddingDateUtils.formatTimeOfDay(_timeStart);

      if (widget.itemToEdit != null) {
        final updated = widget.itemToEdit!.copyWith(
          timeStart: timeFormatted,
          durationMinutes: _durationMinutes,
          sessionTitle: _titleController.text.trim(),
          pic: _picController.text.trim().isEmpty ? null : _picController.text.trim(),
          mcScript: null,
        );
        await repo.updateRundownItem(updated);
      } else {
        final newItem = WeddingRundownItem(
          itemId: UuidUtils.generateId(),
          eventId: widget.eventId,
          timeStart: timeFormatted,
          durationMinutes: _durationMinutes,
          sessionTitle: _titleController.text.trim(),
          pic: _picController.text.trim().isEmpty ? null : _picController.text.trim(),
          mcScript: null,
        );
        await repo.createRundownItem(newItem);
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
