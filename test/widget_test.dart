import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/shared/widgets/bento_card.dart';
import 'package:nikahin_app/shared/widgets/status_chip.dart';
import 'package:nikahin_app/shared/widgets/currency_text_field.dart';

void main() {
  group('Nikahin UI Widgets Test Suite', () {
    testWidgets('StatusChip renders label and proper background for payment status', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusChip(status: 'FULLY_PAID'),
          ),
        ),
      );

      expect(find.text('Lunas'), findsOneWidget);
    });

    testWidgets('BentoCard renders child widget and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BentoCard(
              onTap: () => tapped = true,
              child: const Text('Bento Content'),
            ),
          ),
        ),
      );

      expect(find.text('Bento Content'), findsOneWidget);
      await tester.tap(find.text('Bento Content'));
      expect(tapped, isTrue);
    });

    testWidgets('CurrencyTextField initial formatting', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyTextField(
              labelText: 'Biaya',
              initialValue: 1500000.0,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Rp 1.500.000'), findsOneWidget);
    });
  });
}
