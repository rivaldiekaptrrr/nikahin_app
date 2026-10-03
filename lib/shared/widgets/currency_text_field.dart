import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/currency_utils.dart';

class CurrencyTextField extends StatefulWidget {
  final double? initialValue;
  final ValueChanged<double> onChanged;
  final String labelText;
  final String? hintText;
  final bool isRequired;

  const CurrencyTextField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.labelText = 'Nominal (Rp)',
    this.hintText = 'Rp 0',
    this.isRequired = false,
  });

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final val = widget.initialValue ?? 0.0;
    _controller = TextEditingController(
      text: val > 0 ? CurrencyUtils.formatRupiah(val) : '',
    );
  }

  @override
  void didUpdateWidget(covariant CurrencyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && widget.initialValue != null) {
      final currentParsed = CurrencyUtils.parseRupiah(_controller.text);
      if (currentParsed != widget.initialValue) {
        _controller.text = widget.initialValue! > 0
            ? CurrencyUtils.formatRupiah(widget.initialValue!)
            : '';
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _RupiahInputFormatter(),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.payments_outlined, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: widget.isRequired
          ? (v) {
              if (v == null || v.trim().isEmpty) {
                return '${widget.labelText} wajib diisi';
              }
              final amount = CurrencyUtils.parseRupiah(v);
              if (amount <= 0) {
                return 'Nominal harus lebih dari 0';
              }
              return null;
            }
          : null,
      onChanged: (v) {
        final amount = CurrencyUtils.parseRupiah(v);
        widget.onChanged(amount);
      },
    );
  }
}

class _RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final doubleValue = CurrencyUtils.parseRupiah(newValue.text);
    final formatted = CurrencyUtils.formatRupiah(doubleValue);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
