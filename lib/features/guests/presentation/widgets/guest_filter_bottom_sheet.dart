import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../domain/models/wedding_models.dart';

/// Bottom Sheet Filter & Urutan Tamu berstandar Appllama High-Fidelity.
/// Menyajikan penyaringan multi-kategori yang luwes dan responsif terhadap gestur.
class GuestFilterBottomSheet extends StatefulWidget {
  final String initialGroup;
  final String initialRsvp;
  final String initialSession;
  final List<WeddingGuest> allGuests;
  final void Function({
    required String selectedGroup,
    required String selectedRsvp,
    required String selectedSession,
  }) onApply;

  const GuestFilterBottomSheet({
    super.key,
    required this.initialGroup,
    required this.initialRsvp,
    required this.initialSession,
    required this.allGuests,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required String currentGroup,
    required String currentRsvp,
    required String currentSession,
    required List<WeddingGuest> allGuests,
    required void Function({
      required String selectedGroup,
      required String selectedRsvp,
      required String selectedSession,
    }) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GuestFilterBottomSheet(
        initialGroup: currentGroup,
        initialRsvp: currentRsvp,
        initialSession: currentSession,
        allGuests: allGuests,
        onApply: onApply,
      ),
    );
  }

  @override
  State<GuestFilterBottomSheet> createState() => _GuestFilterBottomSheetState();
}

class _GuestFilterBottomSheetState extends State<GuestFilterBottomSheet> {
  late String _group;
  late String _rsvp;
  late String _session;

  @override
  void initState() {
    super.initState();
    _group = widget.initialGroup;
    _rsvp = widget.initialRsvp;
    _session = widget.initialSession;
  }

  int get _matchingCount {
    return widget.allGuests.where((g) {
      if (_group != 'SEMUA' && g.groupAllocation != _group) return false;
      if (_rsvp != 'SEMUA' && g.rsvpStatus != _rsvp) return false;
      if (_session != 'SEMUA' && g.sessionTarget != _session) return false;
      return true;
    }).length;
  }

  void _resetFilter() {
    HapticFeedback.lightImpact();
    setState(() {
      _group = 'SEMUA';
      _rsvp = 'SEMUA';
      _session = 'SEMUA';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
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
              const SizedBox(height: 14),

              // Title & Reset Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Tamu',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilter,
                    child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(height: 16),

              // SECTION 1: KELOMPOK ALOKASI
              Text(
                'Kelompok Tamu',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChoiceChip('SEMUA', 'Semua Kelompok', _group, (v) => setState(() => _group = v)),
                  _buildChoiceChip('KELUARGA_CPP', 'Keluarga CPP', _group, (v) => setState(() => _group = v)),
                  _buildChoiceChip('KELUARGA_CPW', 'Keluarga CPW', _group, (v) => setState(() => _group = v)),
                  _buildChoiceChip('VIP', 'VIP', _group, (v) => setState(() => _group = v)),
                  _buildChoiceChip('TEMAN_CPP', 'Teman CPP', _group, (v) => setState(() => _group = v)),
                  _buildChoiceChip('TEMAN_CPW', 'Teman CPW', _group, (v) => setState(() => _group = v)),
                  _buildChoiceChip('TETANGGA', 'Tetangga', _group, (v) => setState(() => _group = v)),
                ],
              ),
              const SizedBox(height: 16),

              // SECTION 2: STATUS RSVP
              Text(
                'Status Konfirmasi Kehadiran',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChoiceChip('SEMUA', 'Semua Status', _rsvp, (v) => setState(() => _rsvp = v)),
                  _buildChoiceChip('ATTENDING', 'Hadir', _rsvp, (v) => setState(() => _rsvp = v)),
                  _buildChoiceChip('PENDING', 'Menunggu Konfirmasi', _rsvp, (v) => setState(() => _rsvp = v)),
                  _buildChoiceChip('DECLINED', 'Tidak Hadir', _rsvp, (v) => setState(() => _rsvp = v)),
                ],
              ),
              const SizedBox(height: 16),

              // SECTION 3: SESI ACARA
              Text(
                'Sesi Acara',
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChoiceChip('SEMUA', 'Semua Sesi', _session, (v) => setState(() => _session = v)),
                  _buildChoiceChip('AKAD', 'Akad', _session, (v) => setState(() => _session = v)),
                  _buildChoiceChip('RESEPSI', 'Resepsi', _session, (v) => setState(() => _session = v)),
                  _buildChoiceChip('KEDUANYA', 'Akad & Resepsi', _session, (v) => setState(() => _session = v)),
                ],
              ),
              const SizedBox(height: 24),

              // Apply Button
              FilledButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  widget.onApply(
                    selectedGroup: _group,
                    selectedRsvp: _rsvp,
                    selectedSession: _session,
                  );
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Tampilkan $_matchingCount Tamu',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(
    String value,
    String label,
    String currentValue,
    ValueChanged<String> onSelected,
  ) {
    final isSelected = currentValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          HapticFeedback.lightImpact();
          onSelected(value);
        }
      },
    );
  }
}
