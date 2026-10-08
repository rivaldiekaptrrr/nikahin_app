import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/bento_card.dart';

class SettingsQuoteCard extends StatelessWidget {
  final bool quoteEnabled;
  final TextEditingController quoteController;
  final String quoteFontSize;
  final String quoteFontStyle;
  final ValueChanged<bool> onQuoteEnabledChanged;
  final ValueChanged<String> onQuoteFontSizeChanged;
  final ValueChanged<String> onQuoteFontStyleChanged;
  final VoidCallback onQuoteTextChanged;

  const SettingsQuoteCard({
    super.key,
    required this.quoteEnabled,
    required this.quoteController,
    required this.quoteFontSize,
    required this.quoteFontStyle,
    required this.onQuoteEnabledChanged,
    required this.onQuoteFontSizeChanged,
    required this.onQuoteFontStyleChanged,
    required this.onQuoteTextChanged,
  });

  TextStyle _resolvePreviewStyle(ThemeData theme) {
    double size = 13.0;
    if (quoteFontSize == 'KECIL') size = 11.0;
    if (quoteFontSize == 'BESAR') size = 15.0;

    FontWeight weight = FontWeight.normal;
    FontStyle style = FontStyle.normal;

    if (quoteFontStyle.contains('BOLD')) weight = FontWeight.bold;
    if (quoteFontStyle.contains('ITALIC')) style = FontStyle.italic;

    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
      color: theme.colorScheme.onPrimaryContainer,
      height: 1.35,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BentoCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.format_quote_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            title: const Text(
              'Tampilkan Kutipan di Dashboard',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: const Text(
              'Menampilkan quote romantis pada kartu ringkasan',
              style: TextStyle(fontSize: 12),
            ),
            value: quoteEnabled,
            onChanged: (val) {
              HapticFeedback.selectionClick();
              onQuoteEnabledChanged(val);
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            child: quoteEnabled
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 24),
                      TextFormField(
                        controller: quoteController,
                        inputFormatters: [LengthLimitingTextInputFormatter(150)],
                        maxLength: 150,
                        decoration: const InputDecoration(
                          labelText: 'Teks Kutipan atau Doa',
                          hintText: 'Perjalanan cinta yang luar biasa dimulai dari hari bahagia ini.',
                        ),
                        maxLines: 2,
                        onChanged: (_) => onQuoteTextChanged(),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: quoteFontSize,
                              decoration: const InputDecoration(
                                labelText: 'Ukuran Font',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'KECIL', child: Text('Kecil', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'SEDANG', child: Text('Sedang', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'BESAR', child: Text('Besar', overflow: TextOverflow.ellipsis)),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  HapticFeedback.selectionClick();
                                  onQuoteFontSizeChanged(val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: quoteFontStyle,
                              decoration: const InputDecoration(
                                labelText: 'Gaya Font',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'NORMAL', child: Text('Normal', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'BOLD', child: Text('Tebal', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'ITALIC', child: Text('Miring', overflow: TextOverflow.ellipsis)),
                                DropdownMenuItem(value: 'BOLD_ITALIC', child: Text('Tebal Miring', overflow: TextOverflow.ellipsis)),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  HapticFeedback.selectionClick();
                                  onQuoteFontStyleChanged(val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Live Preview Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.visibility_outlined, size: 14, color: theme.colorScheme.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'Pratinjau Langsung (Live Preview)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '"${quoteController.text.trim().isNotEmpty ? quoteController.text.trim() : 'Perjalanan cinta yang luar biasa dimulai dari sini.'}"',
                              style: _resolvePreviewStyle(theme),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
