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

    testWidgets('Static ClayCard renders lightweight Container without GestureDetector', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClayCard(
              child: Text('Static Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Static Card Content'), findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byType(AnimatedContainer), findsNothing);
    });

    testWidgets('ClayCard renders without error in complex layouts (Row, Expanded, SlideTransition)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClayCard(
                          onTap: () {},
                          child: const Text('Row Card 1'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClayCard(
                          child: const Text('Row Card 2'),
                        ),
                      ),
                    ],
                  ),
                  ClayCard(
                    elevation: 6.0,
                    child: const Text('Form Container Card'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Row Card 1'), findsOneWidget);
      expect(find.text('Row Card 2'), findsOneWidget);
      expect(find.text('Form Container Card'), findsOneWidget);
    });

    testWidgets('ClayButton sizes properly inside Row with Expanded text without unbounded errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: ClayCard(
                  child: Row(
                    children: [
                      const SizedBox(width: 44, height: 44),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Kết nối Apple Health để xem calo đốt cháy'),
                      ),
                      const SizedBox(width: 8),
                      ClayButton(
                        text: 'Kết nối',
                        height: 38,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Kết nối Apple Health để xem calo đốt cháy'), findsOneWidget);
      expect(find.widgetWithText(ClayButton, 'Kết nối'), findsOneWidget);

      final textSize = tester.getSize(find.text('Kết nối Apple Health để xem calo đốt cháy'));
      final buttonSize = tester.getSize(find.byType(ClayButton));
      expect(textSize.width, greaterThan(50));
      expect(buttonSize.width, greaterThan(50));
      expect(buttonSize.height, equals(38.0));
    });

    testWidgets('ClayButton centers text vertically and horizontally', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ClayButton(
                text: 'Kết nối',
                height: 38,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonRect = tester.getRect(find.byType(ClayButton));
      final textRect = tester.getRect(find.text('Kết nối'));

      // Vertical center difference should be within 1.5 pixels
      expect((buttonRect.center.dy - textRect.center.dy).abs(), lessThan(1.5));
      // Horizontal center difference should be within 1.5 pixels
      expect((buttonRect.center.dx - textRect.center.dx).abs(), lessThan(1.5));
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

    testWidgets('ClayAppBar renders title, subtitle and custom actions', (tester) async {
      var actionTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ClayAppBar(
              title: 'Hồ sơ cá nhân',
              subtitle: 'Đồng bộ đám mây',
              actions: [
                ClayIconButton(
                  icon: Icons.tune,
                  onPressed: () => actionTapped = true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Hồ sơ cá nhân'), findsOneWidget);
      expect(find.text('Đồng bộ đám mây'), findsOneWidget);
      expect(find.byType(ClayIconButton), findsOneWidget);

      await tester.tap(find.byIcon(Icons.tune));
      expect(actionTapped, isTrue);
    });
  });
}
