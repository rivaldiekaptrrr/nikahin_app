import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../domain/enums/wedding_enums.dart';
import '../../../../shared/utils/validation_utils.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/currency_text_field.dart';
import '../../../../shared/widgets/date_selector_button.dart';

class SettingsProfileFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController groomController;
  final TextEditingController brideController;
  final int weddingDate;
  final double budgetCap;
  final String culturalGroom;
  final String culturalBride;
  final bool isSaving;
  final ValueChanged<int> onDateSelected;
  final ValueChanged<double> onBudgetChanged;
  final ValueChanged<String> onCulturalGroomChanged;
  final ValueChanged<String> onCulturalBrideChanged;
  final VoidCallback onSave;

  const SettingsProfileFormCard({
    super.key,
    required this.formKey,
    required this.groomController,
    required this.brideController,
    required this.weddingDate,
    required this.budgetCap,
    required this.culturalGroom,
    required this.culturalBride,
    required this.isSaving,
    required this.onDateSelected,
    required this.onBudgetChanged,
    required this.onCulturalGroomChanged,
    required this.onCulturalBrideChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: groomController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
              ValidationUtils.nameInputFormatter,
            ],
            maxLength: 50,
            buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
            decoration: const InputDecoration(
              labelText: 'Nama Mempelai Pria (CPP)',
              hintText: 'Cth: Dimas Arya',
            ),
            validator: (v) => ValidationUtils.validateName(v, 'Nama CPP'),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: brideController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
              ValidationUtils.nameInputFormatter,
            ],
            maxLength: 50,
            buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
            decoration: const InputDecoration(
              labelText: 'Nama Mempelai Wanita (CPW)',
              hintText: 'Cth: Larasati',
            ),
            validator: (v) => ValidationUtils.validateName(v, 'Nama CPW'),
          ),
          const SizedBox(height: 14),
          DateSelectorButton(
            label: 'Tanggal Pernikahan (Hari-H)',
            selectedEpochMillis: weddingDate,
            onDateSelected: onDateSelected,
          ),
          const SizedBox(height: 14),
          CurrencyTextField(
            labelText: 'Batas Total Anggaran (Budget Target)',
            initialValue: budgetCap,
            onChanged: onBudgetChanged,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: culturalGroom,
            decoration: const InputDecoration(labelText: 'Adat Tradisi Mempelai Pria'),
            items: CulturalPreset.values
                .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                HapticFeedback.selectionClick();
                onCulturalGroomChanged(val);
              }
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: culturalBride,
            decoration: const InputDecoration(labelText: 'Adat Tradisi Mempelai Wanita'),
            items: CulturalPreset.values
                .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                HapticFeedback.selectionClick();
                onCulturalBrideChanged(val);
              }
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isSaving ? null : () {
                HapticFeedback.mediumImpact();
                onSave();
              },
              icon: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline_rounded),
              label: Text(isSaving ? 'Menyimpan...' : 'Simpan Profil & Anggaran'),
            ),
          ),
        ],
      ),
    );
  }
}
