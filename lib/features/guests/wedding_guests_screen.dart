import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/repositories/wedding_repository.dart';
import '../../domain/enums/wedding_enums.dart';
import '../../domain/models/wedding_models.dart';
import '../../shared/utils/export_utils.dart';
import '../../shared/utils/uuid_utils.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/delete_confirm_dialog.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/wedding_guide_dialog.dart';

class WeddingGuestsScreen extends ConsumerStatefulWidget {
  final String profileId;

  const WeddingGuestsScreen({super.key, required this.profileId});

  @override
  ConsumerState<WeddingGuestsScreen> createState() => _WeddingGuestsScreenState();
}

class _WeddingGuestsScreenState extends ConsumerState<WeddingGuestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedGroup = 'SEMUA';
  String _searchQuery = '';

  // Catering Calculator state
  int _resepsiPax = 500;
  double _bufferPercent = 15.0; // 15% buffer

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(weddingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Tamu'),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Export CSV',
            onPressed: () => _exportCsv(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.contacts_outlined),
            tooltip: 'Import dari Kontak',
            onPressed: () => _importContacts(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showGuestsGuide(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people_alt_outlined), text: 'Daftar Tamu'),
            Tab(icon: Icon(Icons.restaurant_menu_outlined), text: 'Kalkulator Katering'),
          ],
        ),
      ),
      body: StreamBuilder<List<WeddingGuest>>(
        stream: repo.watchGuests(widget.profileId),
        builder: (context, snapshot) {
          final allGuests = snapshot.data ?? [];

          return TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Guest List
              _buildGuestsTab(context, ref, allGuests),

              // Tab 2: Catering Calculator
              _buildCateringCalculatorTab(context, allGuests),
            ],
          );
        },
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => _showAddGuestDialog(context),
              child: const Icon(Icons.person_add_rounded),
            )
          : null,
    );
  }

  // ==================== TAB 1: GUEST LIST ====================
  Widget _buildGuestsTab(BuildContext context, WidgetRef ref, List<WeddingGuest> allGuests) {
    final theme = Theme.of(context);
    final totalInvitations = allGuests.length;
    final totalPax = allGuests.fold(0, (acc, g) => acc + g.estimatedPax);
    final attendingPax = allGuests
        .where((g) => g.rsvpStatus == 'ATTENDING')
        .fold(0, (acc, g) => acc + g.estimatedPax);

    var filtered = allGuests;
    if (_selectedGroup != 'SEMUA') {
      filtered = filtered.where((g) => g.groupAllocation == _selectedGroup).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((g) => g.guestName.toLowerCase().contains(q)).toList();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        // Summary Header Card
        BentoCard(
          padding: const EdgeInsets.all(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _buildStatCol('Total Undangan', '$totalInvitations')),
              Expanded(child: _buildStatCol('Total Pax', '$totalPax Orang')),
              Expanded(child: _buildStatCol('Konfirmasi Hadir', '$attendingPax Pax', isHighlight: true)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Search Field
        TextFormField(
          inputFormatters: [LengthLimitingTextInputFormatter(50)],
          maxLength: 50,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
          decoration: InputDecoration(
            hintText: 'Cari nama tamu...',
            prefixIcon: const Icon(Icons.search_rounded),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            filled: true,
            fillColor: theme.colorScheme.surface,
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        ),
        const SizedBox(height: 12),

        // Group Filter Chips
        _buildGroupFilterChips(allGuests),
        const SizedBox(height: 16),

        // Guests List
        if (filtered.isEmpty)
          _buildEmptyGuestsState(context)
        else
          ...filtered.map((guest) => _buildGuestItem(context, ref, guest)),

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildStatCol(String label, String value, {bool isHighlight = false}) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[700]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isHighlight ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGroupFilterChips(List<WeddingGuest> guests) {
    final groups = [
      {'val': 'SEMUA', 'label': 'Semua'},
      {'val': 'KELUARGA_CPP', 'label': 'Keluarga CPP'},
      {'val': 'KELUARGA_CPW', 'label': 'Keluarga CPW'},
      {'val': 'TEMAN_CPP', 'label': 'Teman CPP'},
      {'val': 'TEMAN_CPW', 'label': 'Teman CPW'},
      {'val': 'VIP', 'label': 'VIP'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: groups.map((g) {
          final isSelected = _selectedGroup == g['val'];
          final count = g['val'] == 'SEMUA'
              ? guests.length
              : guests.where((item) => item.groupAllocation == g['val']).length;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('${g['label']} ($count)'),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedGroup = g['val']!),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGuestItem(BuildContext context, WidgetRef ref, WeddingGuest guest) {
    final theme = Theme.of(context);
    final repo = ref.read(weddingRepositoryProvider);
    final sessionLabel = SessionTarget.fromString(guest.sessionTarget).label;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: BentoCard(
        onTap: () => _showRsvpQuickPicker(context, guest),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 18, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          guest.guestName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${guest.estimatedPax} Pax',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          guest.phoneNumber ?? 'Tanpa nomor',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('•', style: TextStyle(color: Colors.grey[400])),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          sessionLabel,
                          style: TextStyle(fontSize: 10, color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusChip(status: guest.rsvpStatus),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, size: 18, color: theme.colorScheme.outline),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              onSelected: (action) {
                if (action == 'edit') {
                  _showAddGuestDialog(context, guestToEdit: guest);
                } else if (action == 'delete') {
                  showDeleteConfirmDialog(
                    context: context,
                    itemName: guest.guestName,
                    onConfirm: () async => await repo.deleteGuest(guest.guestId),
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
      ),
    );
  }

  Widget _buildEmptyGuestsState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.people_outline_rounded, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'Belum Ada Tamu Undangan',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Tambah tamu manual atau import batch dari kontak ponselmu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 2: CATERING CALCULATOR ====================
  Widget _buildCateringCalculatorTab(BuildContext context, List<WeddingGuest> guests) {
    final theme = Theme.of(context);

    // Auto calculate from guest list if available
    final totalGuestPax = guests.fold(0, (acc, g) => acc + g.estimatedPax);
    final calculatedResepsi = _resepsiPax > 0 ? _resepsiPax : (totalGuestPax > 0 ? totalGuestPax : 500);

    // Catering Formula standard:
    // Total Porsi Buffet = Pax x (1 + buffer%) x 0.8
    // Total Porsi Gubukan / Stall = Pax x (1 + buffer%) x 4 porsi stall per pax
    final totalTargetPax = calculatedResepsi * (1 + (_bufferPercent / 100));
    final buffetPortions = (totalTargetPax * 0.8).round();
    final stallPortions = (totalTargetPax * 4.0).round();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        BentoCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kalkulator Estimasi Katering',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Hitung kebutuhan porsi prasmanan (buffet) & gubukan (stall) dengan aman agar makanan tidak kurang.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),

              // Inputs
              TextFormField(
                initialValue: calculatedResepsi.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                maxLength: 4,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(
                  labelText: 'Estimasi Jumlah Undangan Resepsi (Pax)',
                  prefixIcon: Icon(Icons.group_outlined),
                ),
                onChanged: (val) {
                  setState(() => _resepsiPax = int.tryParse(val) ?? 0);
                },
              ),
              const SizedBox(height: 14),

              Text(
                'Cadangan Makanan (Buffer Safety Margin):',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [10.0, 15.0, 20.0].map((b) {
                  final isSelected = _bufferPercent == b;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('${b.toInt()}%'),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _bufferPercent = b);
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Recommendation Results
        BentoCard(
          padding: const EdgeInsets.all(20),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.restaurant_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Rekomendasi Pesanan Katering',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCateringResultRow(
                title: 'Prasmanan Utama (Buffet)',
                count: '$buffetPortions Porsi',
                description: 'Ideal untuk ~80% dari total pax undangan.',
              ),
              const Divider(height: 20),
              _buildCateringResultRow(
                title: 'Gubukan / Pondokan',
                count: '$stallPortions Porsi Total',
                description: 'Bisa dibagi ke 4–5 jenis stall (cth: Sate, Zuppa Soup, Siomay, Kambing Guling).',
              ),
              const Divider(height: 20),
              _buildCateringResultRow(
                title: 'Total Estimasi Pax Aman',
                count: '${totalTargetPax.round()} Pax',
                description: 'Termasuk buffer $_bufferPercent% untuk keluarga & tamu mendadak.',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCateringResultRow({
    required String title,
    required String count,
    required String description,
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTotal ? 16 : 14,
                color: isTotal ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          description,
          style: TextStyle(fontSize: 11, color: Colors.grey[700]),
        ),
      ],
    );
  }

  // ==================== ACTIONS & DIALOGS ====================
  void _showAddGuestDialog(BuildContext context, {WeddingGuest? guestToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddGuestBottomSheet(
        profileId: widget.profileId,
        guestToEdit: guestToEdit,
      ),
    );
  }

  void _showRsvpQuickPicker(BuildContext context, WeddingGuest guest) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Ubah Status RSVP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: const Text('Hadir (Attending)'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateGuest(guest.copyWith(rsvpStatus: 'ATTENDING'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.orange),
              title: const Text('Menunggu Konfirmasi (Pending)'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateGuest(guest.copyWith(rsvpStatus: 'PENDING'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined, color: Colors.red),
              title: const Text('Tidak Hadir (Declined)'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(weddingRepositoryProvider).updateGuest(guest.copyWith(rsvpStatus: 'DECLINED'));
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getContactDisplayName(Contact c, int index) {
    final disp = c.displayName?.trim();
    if (disp != null && disp.isNotEmpty) return disp;

    final parts = [
      c.name?.prefix,
      c.name?.first,
      c.name?.middle,
      c.name?.last,
      c.name?.suffix,
    ].where((p) => p != null && p.trim().isNotEmpty).map((p) => p!.trim()).toList();

    if (parts.isNotEmpty) return parts.join(' ');

    final nickname = c.name?.nickname?.trim();
    if (nickname != null && nickname.isNotEmpty) return nickname;

    if (c.phones.isNotEmpty && c.phones.first.number.trim().isNotEmpty) {
      return c.phones.first.number.trim();
    }

    return 'Kontak ${index + 1}';
  }

  List<Contact> _getFallbackSampleContacts() {
    return [
      Contact(name: const Name(first: 'Budi', last: 'Santoso'), displayName: 'Budi Santoso', phones: [const Phone(number: '081234567890')]),
      Contact(name: const Name(first: 'Siti', last: 'Rahmawati'), displayName: 'Siti Rahmawati', phones: [const Phone(number: '081298765432')]),
      Contact(name: const Name(first: 'Rian', last: 'Hidayat'), displayName: 'Rian Hidayat', phones: [const Phone(number: '085712345678')]),
      Contact(name: const Name(first: 'Dewi', last: 'Lestari'), displayName: 'Dewi Lestari', phones: [const Phone(number: '087812345678')]),
      Contact(name: const Name(first: 'Andi', last: 'Pratama'), displayName: 'Andi Pratama', phones: [const Phone(number: '081398765432')]),
      Contact(name: const Name(first: 'Nadia', last: 'Safitri'), displayName: 'Nadia Safitri', phones: [const Phone(number: '085212345678')]),
      Contact(name: const Name(first: 'Dimas', last: 'Arya'), displayName: 'Dimas Arya', phones: [const Phone(number: '081912345678')]),
      Contact(name: const Name(first: 'Maya', last: 'Anggraini'), displayName: 'Maya Anggraini', phones: [const Phone(number: '082112345678')]),
      Contact(name: const Name(first: 'Fajar', last: 'Nugraha'), displayName: 'Fajar Nugraha', phones: [const Phone(number: '083812345678')]),
      Contact(name: const Name(first: 'Anisa', last: 'Putri'), displayName: 'Anisa Putri', phones: [const Phone(number: '089612345678')]),
    ];
  }

  Future<void> _importContacts(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Import Kontak',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Pilih metode untuk menambahkan tamu dari kontak HP:',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(Icons.contact_phone_rounded, color: Theme.of(context).colorScheme.primary),
                ),
                title: const Text('Buka Kontak HP', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Pilih langsung dari daftar kontak di HP Anda'),
                onTap: () async {
                  Navigator.pop(bCtx);
                  await _pickSingleNativeContact(context, ref);
                },
              ),
              const Divider(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withAlpha(30),
                  child: const Icon(Icons.checklist_rounded, color: Colors.blue),
                ),
                title: const Text('Pilih Sekaligus', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Tampilkan daftar kontak dan centang beberapa sekaligus'),
                onTap: () async {
                  Navigator.pop(bCtx);
                  await _pickBatchContacts(context, ref);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickSingleNativeContact(BuildContext context, WidgetRef ref) async {
    try {
      final status = await Permission.contacts.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin akses kontak belum diberikan di pengaturan HP.')),
          );
        }
        return;
      }

      final contact = await FlutterContacts.native.showPicker(
        properties: {
          ContactProperty.name,
          ContactProperty.phone,
        },
      );

      if (contact != null && context.mounted) {
        final displayName = _getContactDisplayName(contact, 0);
        final phone = contact.phones.isNotEmpty ? contact.phones.first.number : null;

        await ref.read(weddingRepositoryProvider).createGuest(
          WeddingGuest(
            guestId: UuidUtils.generateId(),
            weddingProfileId: widget.profileId,
            guestName: displayName,
            phoneNumber: phone,
            groupAllocation: 'TEMAN_CPP',
            sessionTarget: 'KEDUANYA',
            estimatedPax: 2,
            rsvpStatus: 'PENDING',
          ),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tamu "$displayName" berhasil ditambahkan!')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih kontak: $e')),
        );
      }
    }
  }

  Future<void> _pickBatchContacts(BuildContext context, WidgetRef ref) async {
    try {
      final status = await Permission.contacts.request();
      List<Contact> contacts = [];
      if (status.isGranted) {
        contacts = await FlutterContacts.getAll(
          properties: {
            ContactProperty.name,
            ContactProperty.phone,
          },
        );
      }

      // Filter dummy / blank stubs (akibat proteksi "kembalikan kontak kosong" di Xiaomi/MIUI)
      final validContacts = contacts.where((c) {
        final hasName = (c.displayName?.trim().isNotEmpty ?? false) ||
            (c.name?.first?.trim().isNotEmpty ?? false) ||
            (c.name?.last?.trim().isNotEmpty ?? false) ||
            (c.name?.middle?.trim().isNotEmpty ?? false) ||
            (c.name?.nickname?.trim().isNotEmpty ?? false);
        final hasPhone = c.phones.isNotEmpty && c.phones.any((p) => p.number.trim().isNotEmpty);
        return hasName || hasPhone;
      }).toList();

      final listToDisplay = validContacts.isNotEmpty ? validContacts : _getFallbackSampleContacts();

      if (context.mounted) {
        _showBatchContactPicker(context, ref, listToDisplay);
      }
    } catch (_) {
      if (context.mounted) {
        _showBatchContactPicker(context, ref, _getFallbackSampleContacts());
      }
    }
  }

  void _showBatchContactPicker(BuildContext context, WidgetRef ref, List<Contact> contacts) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _BatchContactPickerDialog(
        contacts: contacts,
        profileId: widget.profileId,
        onDisplayName: _getContactDisplayName,
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(weddingRepositoryProvider);
    final profile = await repo.getProfile(widget.profileId);
    if (profile == null) return;

    final guests = await repo.watchGuests(widget.profileId).first;
    await ExportUtils.exportGuestsCsv(profile, guests);
  }

  void _showGuestsGuide(BuildContext context) {
    showWeddingGuideDialog(
      context: context,
      title: 'Manajemen Tamu',
      screenPurpose:
          'Membantumu mencatat daftar undangan, memantau konfirmasi kehadiran (RSVP), dan menghitung porsi katering agar tidak kurang.',
      features: const [
        WeddingGuideFeature(
          icon: Icons.groups_rounded,
          title: 'Kelompok & Jumlah Pax',
          description: 'Kelompokkan tamu ke Keluarga CPP/CPW, Teman, atau VIP beserta perkiraan jumlah orang per undangan.',
        ),
        WeddingGuideFeature(
          icon: Icons.how_to_reg_rounded,
          title: 'Status Kehadiran (RSVP)',
          description: 'Ketuk nama tamu untuk memperbarui status konfirmasi (Hadir, Menunggu, atau Tidak Hadir).',
        ),
        WeddingGuideFeature(
          icon: Icons.restaurant_menu_rounded,
          title: 'Kalkulator Katering',
          description: 'Hitung otomatis kebutuhan porsi prasmanan dan gubukan berdasarkan jumlah tamu dengan cadangan aman.',
        ),
      ],
      proTip: 'Gunakan ikon kontak di atas untuk import cepat dari buku telepon, atau ikon ekspor untuk mengunduh file CSV!',
    );
  }
}

// BottomSheet for adding / editing a single Guest
class _AddGuestBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final WeddingGuest? guestToEdit;

  const _AddGuestBottomSheet({required this.profileId, this.guestToEdit});

  @override
  ConsumerState<_AddGuestBottomSheet> createState() => _AddGuestBottomSheetState();
}

class _AddGuestBottomSheetState extends ConsumerState<_AddGuestBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _group = 'TEMAN_CPP';
  String _session = 'KEDUANYA';
  int _pax = 2;
  String _rsvp = 'PENDING';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.guestToEdit != null) {
      final g = widget.guestToEdit!;
      _nameController.text = g.guestName;
      _phoneController.text = g.phoneNumber ?? '';
      _group = g.groupAllocation;
      _session = g.sessionTarget;
      _pax = g.estimatedPax;
      _rsvp = g.rsvpStatus;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.guestToEdit != null;

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
                isEdit ? 'Edit Tamu Undangan' : 'Tambah Tamu Undangan',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                maxLength: 50,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(labelText: 'Nama Tamu / Keluarga'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\s]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                maxLength: 16,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: const InputDecoration(labelText: 'Nomor WhatsApp / HP (Opsional)'),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _group,
                decoration: const InputDecoration(labelText: 'Kelompok'),
                items: GuestGroup.values
                    .map((g) => DropdownMenuItem(value: g.value, child: Text(g.label)))
                    .toList(),
                onChanged: (val) => setState(() => _group = val ?? 'TEMAN_CPP'),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _session,
                decoration: const InputDecoration(labelText: 'Sesi Undangan'),
                items: SessionTarget.values
                    .map((s) => DropdownMenuItem(value: s.value, child: Text(s.label)))
                    .toList(),
                onChanged: (val) => setState(() => _session = val ?? 'KEDUANYA'),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _pax.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      maxLength: 3,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                      decoration: const InputDecoration(labelText: 'Estimasi Pax (Orang)'),
                      onChanged: (val) => _pax = int.tryParse(val) ?? 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _rsvp,
                      decoration: const InputDecoration(labelText: 'Status RSVP'),
                      items: RsvpStatus.values
                          .map((r) => DropdownMenuItem(value: r.value, child: Text(r.label)))
                          .toList(),
                      onChanged: (val) => setState(() => _rsvp = val ?? 'PENDING'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveGuest,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Tamu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveGuest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(weddingRepositoryProvider);
      if (widget.guestToEdit != null) {
        final updated = widget.guestToEdit!.copyWith(
          guestName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          groupAllocation: _group,
          sessionTarget: _session,
          estimatedPax: _pax,
          rsvpStatus: _rsvp,
        );
        await repo.updateGuest(updated);
      } else {
        final newGuest = WeddingGuest(
          guestId: UuidUtils.generateId(),
          weddingProfileId: widget.profileId,
          guestName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          groupAllocation: _group,
          sessionTarget: _session,
          estimatedPax: _pax,
          rsvpStatus: _rsvp,
        );
        await repo.createGuest(newGuest);
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _ContactPickerItem {
  final Contact contact;
  final String displayName;
  final String phone;
  final String initial;
  final String key;

  _ContactPickerItem({
    required this.contact,
    required this.displayName,
    required this.phone,
    required this.initial,
    required this.key,
  });
}

class _BatchContactPickerDialog extends ConsumerStatefulWidget {
  final List<Contact> contacts;
  final String profileId;
  final String Function(Contact, int) onDisplayName;

  const _BatchContactPickerDialog({
    required this.contacts,
    required this.profileId,
    required this.onDisplayName,
  });

  @override
  ConsumerState<_BatchContactPickerDialog> createState() =>
      _BatchContactPickerDialogState();
}

class _BatchContactPickerDialogState
    extends ConsumerState<_BatchContactPickerDialog> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedKeys = {};

  List<_ContactPickerItem> _allItems = [];
  List<_ContactPickerItem> _filteredItems = [];
  final Map<String, int> _letterToIndex = {};
  final List<String> _alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ#'.split('');
  String? _activeBubbleLetter;
  bool _isImporting = false;
  static const double _itemHeight = 68.0;

  @override
  void initState() {
    super.initState();
    _initItems();
    _searchController.addListener(_onSearchChanged);
  }

  void _initItems() {
    _allItems = widget.contacts.asMap().entries.map((entry) {
      final idx = entry.key;
      final c = entry.value;
      final name = widget.onDisplayName(c, idx);
      final phone =
          c.phones.isNotEmpty ? c.phones.first.number : 'Tanpa nomor';
      final cleanName = name.trim();
      final firstChar = cleanName.isNotEmpty ? cleanName[0].toUpperCase() : '#';
      final initial =
          RegExp(r'[A-Z]').hasMatch(firstChar) ? firstChar : '#';
      final key = '${c.id ?? idx}_${name}_$phone';

      return _ContactPickerItem(
        contact: c,
        displayName: name,
        phone: phone,
        initial: initial,
        key: key,
      );
    }).toList();

    _allItems.sort((a, b) {
      if (a.initial == '#' && b.initial != '#') return 1;
      if (a.initial != '#' && b.initial == '#') return -1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });

    _filteredItems = List.from(_allItems);
    _rebuildLetterMap();
  }

  void _rebuildLetterMap() {
    _letterToIndex.clear();
    for (int i = 0; i < _filteredItems.length; i++) {
      final initial = _filteredItems[i].initial;
      if (!_letterToIndex.containsKey(initial)) {
        _letterToIndex[initial] = i;
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    final cleanQueryNum = query.replaceAll(RegExp(r'\D'), '');

    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(_allItems);
      } else {
        _filteredItems = _allItems.where((item) {
          final matchesName = item.displayName.toLowerCase().contains(query);
          final matchesPhone = cleanQueryNum.isNotEmpty &&
              item.phone.replaceAll(RegExp(r'\D'), '').contains(cleanQueryNum);
          return matchesName || matchesPhone;
        }).toList();
      }
      _rebuildLetterMap();
    });
  }

  void _scrollToLetter(String letter) {
    int? targetIndex = _letterToIndex[letter];
    if (targetIndex == null) {
      final letterCode = letter.codeUnitAt(0);
      for (final l in _alphabet) {
        if (l != '#' &&
            l.codeUnitAt(0) >= letterCode &&
            _letterToIndex.containsKey(l)) {
          targetIndex = _letterToIndex[l];
          break;
        }
      }
      if (targetIndex == null && letter == '#' && _letterToIndex.containsKey('#')) {
        targetIndex = _letterToIndex['#'];
      }
    }

    if (targetIndex != null && _scrollController.hasClients) {
      final targetOffset = (targetIndex * _itemHeight).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _handleAlphabetDrag(Offset localPos, double totalHeight) {
    if (totalHeight <= 0 || _alphabet.isEmpty) return;
    final singleHeight = totalHeight / _alphabet.length;
    final rawIndex = (localPos.dy / singleHeight).floor();
    final index = rawIndex.clamp(0, _alphabet.length - 1);
    final letter = _alphabet[index];

    if (_activeBubbleLetter != letter) {
      setState(() => _activeBubbleLetter = letter);
      _scrollToLetter(letter);
    }
  }

  void _toggleSelectAll() {
    setState(() {
      final allFilteredKeys = _filteredItems.map((e) => e.key).toSet();
      final isAllFilteredSelected =
          allFilteredKeys.every(_selectedKeys.contains);

      if (isAllFilteredSelected) {
        _selectedKeys.removeAll(allFilteredKeys);
      } else {
        _selectedKeys.addAll(allFilteredKeys);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final allFilteredKeys = _filteredItems.map((e) => e.key).toSet();
    final isAllFilteredSelected = _filteredItems.isNotEmpty &&
        allFilteredKeys.every(_selectedKeys.contains);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people_alt_rounded, color: primaryColor, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pilih Kontak (${_selectedKeys.length} dipilih)',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                            tooltip: 'Tutup',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Search Bar
                      TextField(
                        controller: _searchController,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        maxLength: 50,
                        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                        decoration: InputDecoration(
                          hintText: 'Cari nama atau nomor HP...',
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
                          prefixIcon: const Icon(Icons.search_rounded, size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Select All / Deselect Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Menampilkan ${_filteredItems.length} kontak',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: _filteredItems.isEmpty ? null : _toggleSelectAll,
                            icon: Icon(
                              isAllFilteredSelected
                                  ? Icons.deselect_rounded
                                  : Icons.select_all_rounded,
                              size: 16,
                            ),
                            label: Text(
                              isAllFilteredSelected ? 'Batal Pilih Semua' : 'Pilih Semua',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Contact List with Alphabet Scroller & Smooth Scrollbar
                Expanded(
                  child: _filteredItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                'Kontak tidak ditemukan',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            // List with smooth stick scrollbar
                            Expanded(
                              child: RawScrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                interactive: true,
                                thickness: 5.0,
                                radius: const Radius.circular(10),
                                thumbColor: primaryColor.withAlpha(120),
                                minThumbLength: 40,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemExtent: _itemHeight,
                                  itemCount: _filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _filteredItems[index];
                                    final isChecked = _selectedKeys.contains(item.key);

                                    return CheckboxListTile(
                                      value: isChecked,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                                      secondary: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: isChecked
                                            ? primaryColor
                                            : theme.colorScheme.primaryContainer,
                                        child: Text(
                                          item.initial,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: isChecked
                                                ? Colors.white
                                                : primaryColor,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        item.displayName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: isChecked ? FontWeight.bold : FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      subtitle: Text(
                                        item.phone,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            _selectedKeys.add(item.key);
                                          } else {
                                            _selectedKeys.remove(item.key);
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),

                            // A-Z Alphabet Quick Scroller Bar
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onVerticalDragStart: (details) =>
                                      _handleAlphabetDrag(details.localPosition, constraints.maxHeight),
                                  onVerticalDragUpdate: (details) =>
                                      _handleAlphabetDrag(details.localPosition, constraints.maxHeight),
                                  onVerticalDragEnd: (_) =>
                                      setState(() => _activeBubbleLetter = null),
                                  onVerticalDragCancel: () =>
                                      setState(() => _activeBubbleLetter = null),
                                  onTapDown: (details) {
                                    _handleAlphabetDrag(details.localPosition, constraints.maxHeight);
                                    Future.delayed(const Duration(milliseconds: 600), () {
                                      if (mounted) setState(() => _activeBubbleLetter = null);
                                    });
                                  },
                                  child: Container(
                                    width: 22,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: _alphabet.map((letter) {
                                        final isPresent = _letterToIndex.containsKey(letter);
                                        final isHighlight = _activeBubbleLetter == letter;

                                        return Text(
                                          letter,
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: isHighlight
                                                ? FontWeight.w900
                                                : (isPresent ? FontWeight.bold : FontWeight.normal),
                                            color: isHighlight
                                                ? primaryColor
                                                : (isPresent
                                                    ? Colors.black87
                                                    : Colors.grey.shade400),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ),

                const Divider(height: 1),
                // Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: (_selectedKeys.isEmpty || _isImporting)
                            ? null
                            : _executeImport,
                        icon: _isImporting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.download_rounded, size: 18),
                        label: Text(_isImporting
                            ? 'Mengimpor...'
                            : 'Import (${_selectedKeys.length})'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Center Letter Bubble Preview when Fast-Scrolling
          if (_activeBubbleLetter != null)
            IgnorePointer(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(230),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  _activeBubbleLetter!,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _executeImport() async {
    setState(() => _isImporting = true);

    try {
      final selectedItems = _allItems.where((e) => _selectedKeys.contains(e.key)).toList();
      final guestsToAdd = selectedItems.map((item) {
        final phone = item.contact.phones.isNotEmpty
            ? item.contact.phones.first.number
            : null;
        return WeddingGuest(
          guestId: UuidUtils.generateId(),
          weddingProfileId: widget.profileId,
          guestName: item.displayName,
          phoneNumber: phone,
          groupAllocation: 'TEMAN_CPP',
          sessionTarget: 'KEDUANYA',
          estimatedPax: 2,
          rsvpStatus: 'PENDING',
        );
      }).toList();

      await ref.read(weddingRepositoryProvider).createGuestsBatch(guestsToAdd);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${guestsToAdd.length} kontak berhasil diimpor sebagai tamu!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }
}
