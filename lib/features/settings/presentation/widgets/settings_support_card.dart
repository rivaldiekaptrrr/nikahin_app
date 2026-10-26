import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/config/business_config.dart';
import '../../../../shared/widgets/bento_card.dart';

class SettingsSupportCard extends StatelessWidget {
  const SettingsSupportCard({super.key});

  Future<void> _openWhatsAppSupport(BuildContext context) async {
    final uri = BusinessConfig.getWhatsAppGeneralUri(
      'Halo Tim Support Nikahin, saya ingin bertanya dan konsultasi mengenai aplikasi...',
    );
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        _showErrorSnackBar(context, 'Tidak dapat membuka aplikasi WhatsApp');
      }
    } catch (_) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Gagal membuka WhatsApp. Pastikan aplikasi terpasang.');
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFeedbackModal(BuildContext context) {
    final feedbackController = TextEditingController();
    String selectedCategory = 'Saran Fitur';
    final categories = ['Saran Fitur', 'Laporan Kendala (Bug)', 'Pertanyaan'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final theme = Theme.of(ctx);
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
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
                    'Kirim Masukan & Saran',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masukan Anda sangat berharga untuk kesempurnaan aplikasi Nikahin.',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: categories.map((cat) {
                      final isSelected = cat == selectedCategory;
                      return ChoiceChip(
                        label: Text(cat, style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setModalState(() => selectedCategory = cat);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan masukan atau kendala yang Anda alami...',
                      hintStyle: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final text = feedbackController.text.trim();
                        if (text.isEmpty) {
                          _showErrorSnackBar(ctx, 'Mohon isi pesan masukan terlebih dahulu');
                          return;
                        }
                        Navigator.pop(ctx);
                        final message = 'Halo Admin Nikahin,\nKategori: $selectedCategory\n\nPesan:\n$text';
                        final uri = BusinessConfig.getWhatsAppGeneralUri(message);
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Kirim ke WhatsApp Tim Support'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFaqModal(BuildContext context) {
    final faqs = [
      {
        'q': 'Apakah data saya aman jika berganti HP?',
        'a': 'Ya! Jika akun Anda terhubung dengan Google atau Email, seluruh data rencana pernikahan otomatis tersimpan di Cloud Firestore dan langsung sinkron di HP baru.',
      },
      {
        'q': 'Apakah aplikasi bisa dipakai saat jaringan terputus sementara?',
        'a': 'Sangat bisa! Nikahin dilengkapi penyimpanan cache lokal cerdas (SQLite Drift). Bagi akun yang sudah login, Anda tetap bisa mencatat tamu, pengeluaran, dan susunan acara di lokasi resepsi tanpa sinyal, lalu data otomatis tersinkronisasi kembali saat terhubung internet.',
      },
      {
        'q': 'Bagaimana cara membagikan Buku Panduan Acara (Rundown)?',
        'a': 'Buka menu Ekspor Data & Cadangan di atas, lalu pilih "Ringkasan Eksekutif PDF" atau masuk ke menu Rundown untuk mengekspor buku saku panitia ke WhatsApp.',
      },
      {
        'q': 'Bagaimana cara menghubungi developer langsung?',
        'a': 'Anda bisa mengetuk tombol "Chat WhatsApp Tim Support" untuk berkonsultasi langsung dengan tim pengembang Nikahin (+62 878-3428-4141).',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.88,
          minChildSize: 0.4,
          builder: (ctx, scrollController) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: scrollController,
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
                  'Pertanyaan Umum (FAQ)',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jawaban cepat seputar fitur, lisensi, dan data aplikasi',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                ...faqs.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                      child: ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        title: Text(
                          item['q']!,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                            child: Text(
                              item['a']!,
                              style: TextStyle(
                                fontSize: 12.5,
                                height: 1.45,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BentoCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          // 1. WhatsApp Support
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF16A34A), size: 20),
            ),
            title: const Text(
              'Chat WhatsApp Tim Support',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
            ),
            subtitle: Text(
              'Bantuan teknis & konsultasi (+62 878-3428-4141)',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant, size: 20),
            onTap: () => _openWhatsAppSupport(context),
          ),
          Divider(height: 1, thickness: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),

          // 2. Kirim Masukan
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.rate_review_outlined, color: theme.colorScheme.primary, size: 20),
            ),
            title: const Text(
              'Kirim Masukan & Saran Fitur',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
            ),
            subtitle: Text(
              'Bantu kami mengembangkan Nikahin jadi lebih baik',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant, size: 20),
            onTap: () => _showFeedbackModal(context),
          ),
          Divider(height: 1, thickness: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),

          // 3. FAQ
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.help_outline_rounded, color: theme.colorScheme.tertiary, size: 20),
            ),
            title: const Text(
              'Pertanyaan Umum (FAQ)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
            ),
            subtitle: Text(
              'Panduan ringkas penggunaan & sinkronisasi data',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant, size: 20),
            onTap: () => _showFaqModal(context),
          ),
        ],
      ),
    );
  }
}
