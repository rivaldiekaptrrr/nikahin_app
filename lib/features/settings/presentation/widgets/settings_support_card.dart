import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/config/business_config.dart';
import '../../../../data/services/device_info_service.dart';
import '../../../../shared/widgets/bento_card.dart';

class SettingsSupportCard extends StatelessWidget {
  const SettingsSupportCard({super.key});

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
    String selectedCategory = 'Laporan Kendala (Bug)';
    final categories = ['Laporan Kendala (Bug)', 'Saran Fitur', 'Pertanyaan'];
    XFile? selectedImage;

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
                    'Kirim Masukan',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Laporkan masalah teknis, kendala, atau saran pengembangan aplikasi.',
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
                      hintText: 'Tuliskan rincian kendala atau masukan yang Anda alami...',
                      hintStyle: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Lampiran Tangkapan Layar (Opsional)
                  if (selectedImage == null)
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        try {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );
                          if (image != null) {
                            setModalState(() => selectedImage = image);
                          }
                        } catch (_) {
                          if (ctx.mounted) {
                            _showErrorSnackBar(ctx, 'Gagal memilih gambar dari galeri');
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lampirkan Tangkapan Layar (Opsional)',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Pilih gambar bukti kendala dari galeri HP',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: kIsWeb
                                ? Image.network(
                                    selectedImage!.path,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(selectedImage!.path),
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tangkapan Layar Terpilih',
                                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selectedImage!.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            color: theme.colorScheme.error,
                            tooltip: 'Hapus Bukti',
                            onPressed: () => setModalState(() => selectedImage = null),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final text = feedbackController.text.trim();
                        if (text.isEmpty) {
                          _showErrorSnackBar(ctx, 'Mohon isi rincian masukan terlebih dahulu');
                          return;
                        }
                        Navigator.pop(ctx);

                        final diagnostics = await DeviceInfoService().getDiagnosticsPayload();
                        final message = 'Halo Admin Nikahin,\nKategori: $selectedCategory\n\nPesan:\n$text$diagnostics';

                        if (selectedImage != null) {
                          try {
                            await SharePlus.instance.share(
                              ShareParams(
                                files: [XFile(selectedImage!.path)],
                                text: message,
                              ),
                            );
                          } catch (_) {
                            final uri = BusinessConfig.getWhatsAppGeneralUri(message);
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        } else {
                          final uri = BusinessConfig.getWhatsAppGeneralUri(message);
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
                      },
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Kirim ke Tim Support'),
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
        'q': 'Apakah data rencana pernikahan saya aman jika berganti HP?',
        'a': 'Tentu sangat aman. Jika Anda masuk (login) dengan Akun Google atau Email, seluruh data rencana pernikahan, anggaran, dan daftar tamu otomatis tersimpan rapi di server aman kami. Saat berganti HP, Anda cukup masuk dengan akun yang sama dan seluruh data langsung kembali seperti semula.',
      },
      {
        'q': 'Apakah aplikasi tetap bisa dipakai saat tidak ada sinyal atau internet?',
        'a': 'Bisa sekali! Nikahin dirancang agar tetap bisa dibuka dan digunakan meski Anda sedang berada di lokasi resepsi yang minim sinyal. Anda tetap dapat mencatat pengeluaran, mengecek susunan acara, dan mendata tamu. Begitu HP Anda kembali terhubung internet, data otomatis disinkronkan ke server.',
      },
      {
        'q': 'Bagaimana cara mencetak atau membagikan Buku Panduan Acara (Rundown)?',
        'a': 'Anda dapat membuka menu "Ekspor Data & Cadangan" di halaman Pengaturan ini, lalu pilih "Ringkasan Eksekutif PDF". Selain itu, Anda juga bisa langsung membuka menu "Susunan Acara (Rundown)" untuk membagikan buku saku panitia berformat PDF langsung ke grup WhatsApp keluarga dan panitia.',
      },
      {
        'q': 'Bisakah saya mengunduh daftar tamu ke format Excel untuk meja resepsi?',
        'a': 'Bisa. Masuk ke menu "Daftar Tamu", lalu pilih ikon ekspor. Anda dapat mengunduh daftar seluruh tamu undangan dalam format Excel (CSV) yang siap dicetak di kertas untuk diletakkan di meja penerima tamu.',
      },
      {
        'q': 'Bagaimana cara membagi tugas panitia dan seragam keluarga?',
        'a': 'Buka menu "Panitia & Seragam". Di sana Anda bisa mendaftarkan anggota keluarga atau sahabat sebagai panitia, menetapkan peran tugas masing-masing, serta mencatat status pembagian kain seragam apakah sudah diserahkan atau belum.',
      },
      {
        'q': 'Bagaimana cara mencatat pembayaran bertahap (DP dan Pelunasan) ke vendor?',
        'a': 'Buka menu "Anggaran (Budget)", lalu pilih pengeluaran vendor yang dimaksud. Anda dapat memilih status pembayaran: "Belum Bayar", "DP Terbayar", atau "Lunas", serta mencatat rincian catatan pembayaran agar keuangan pernikahan tetap transparan.',
      },
      {
        'q': 'Apakah nomor kontak dan data tamu undangan saya aman dan terjaga privasinya?',
        'a': 'Kami sangat menjunjung tinggi privasi Anda. Seluruh data kontak, nama tamu, dan rincian pernikahan hanya tersimpan untuk keperluan acara pernikahan Anda sendiri. Kami tidak pernah membagikan atau menjual data Anda kepada pihak manapun.',
      },
      {
        'q': 'Bagaimana jika saya mengalami kendala atau membutuhkan bantuan langsung?',
        'a': 'Anda dapat mengetuk menu "Kirim Masukan" di atas untuk mengirimkan kendala beserta tangkapan layar langsung ke WhatsApp Tim Support kami (+62 878-3428-4141). Tim kami siap membantu kendala teknis maupun menjawab pertanyaan Anda.',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return DraggableScrollableSheet(
          initialChildSize: 0.68,
          maxChildSize: 0.9,
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
                  'Jawaban cepat seputar panduan penggunaan, fitur, dan keamanan data',
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
          // 1. Kirim Masukan (Laporkan masalah teknis)
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
              'Kirim Masukan',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
            ),
            subtitle: Text(
              'Laporkan masalah teknis',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant, size: 20),
            onTap: () => _showFeedbackModal(context),
          ),
          Divider(height: 1, thickness: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),

          // 2. Pertanyaan Umum (FAQ)
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
