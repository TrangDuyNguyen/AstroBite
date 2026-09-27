import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

void main() {
  group('AstroBite UI Kit — Claymorphic × Duolingo 2D/3D Tests', () {
    testWidgets('ClayCard renders child and triggers onTap on click', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClayCard(
              onTap: () => tapped = true,
              child: const Text('Clay Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Clay Card Content'), findsOneWidget);
      await tester.tap(find.text('Clay Card Content'));
      expect(tapped, isTrue);
    });

    testWidgets('ClayButton renders text and responds to press', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClayButton(
              text: 'Bắt đầu ngay',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Bắt đầu ngay'), findsOneWidget);
      await tester.tap(find.text('Bắt đầu ngay'));
      expect(pressed, isTrue);
    });

    testWidgets('ClayButton renders loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClayButton(
              text: 'Đang tải',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Đang tải'), findsNothing);
    });

    testWidgets('ClayIconButton renders icon and triggers callback', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClayIconButton(
              icon: Icons.add,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      expect(pressed, isTrue);
    });

    testWidgets('ClayTextField handles text input correctly', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClayTextField(
              controller: controller,
              labelText: 'Email',
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'user@astrobite.app');
      expect(controller.text, 'user@astrobite.app');
    });

    testWidgets('ClaySearchBar triggers onChanged on input', (tester) async {
      String query = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClaySearchBar(
              onChanged: (val) => query = val,
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Phở bò');
      expect(query, 'Phở bò');
    });

    testWidgets('ChunkyMacroBar displays label, macros, and progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChunkyMacroBar(
              label: 'Carbs',
              currentG: 150,
              targetG: 200,
              color: AppColors.carbs,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Carbs'), findsOneWidget);
      expect(find.text('150g / 200g'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('ClayMealChip selects and displays correctly', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClayMealChip(
              mealType: 'lunch',
              isSelected: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.byType(ClayMealChip), findsOneWidget);
      await tester.tap(find.byType(ClayMealChip));
      expect(tapped, isTrue);
    });

    testWidgets('ClaySheet renders child with rounded header handle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClaySheet(
              child: Text('Sheet Content'),
            ),
          ),
        ),
      );

      expect(find.text('Sheet Content'), findsOneWidget);
    });
  });
}
