import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/coach/presentation/widgets/quick_choice_chips.dart';

void main() {
  group('QuickChoiceChips Widget Tests', () {
    testWidgets('renders all chips and fires onSelectChip when tapped', (tester) async {
      String? selectedPayload;

      final props = QuickChoiceChipsProps.fromMap({
        'chips': [
          {'label': 'Bữa sáng', 'payload': 'chọn bữa sáng'},
          {'label': 'Bữa trưa', 'payload': 'chọn bữa trưa'},
          {'label': 'Ăn nhẹ', 'payload': 'chọn ăn nhẹ'},
        ]
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuickChoiceChips(
              props: props,
              onSelectChip: (payload) => selectedPayload = payload,
            ),
          ),
        ),
      );

      expect(find.text('Bữa sáng'), findsOneWidget);
      expect(find.text('Bữa trưa'), findsOneWidget);
      expect(find.text('Ăn nhẹ'), findsOneWidget);

      await tester.tap(find.text('Bữa trưa'));
      await tester.pumpAndSettle();

      expect(selectedPayload, 'chọn bữa trưa');
    });
  });
}
