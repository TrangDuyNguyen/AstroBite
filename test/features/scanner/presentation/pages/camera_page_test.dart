import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/scanner/presentation/pages/camera_page.dart';
import 'package:astrobite/features/scanner/presentation/widgets/scanning_viewfinder.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: CameraPage(),
      ),
    );
  }

  group('CameraPage Widget Tests', () {
    testWidgets('renders all core UI elements on initial load', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // App bar title
      expect(find.text(AppStrings.scanFood), findsOneWidget);

      // Guidance subtitle
      expect(
        find.text('Hướng máy ảnh vào đĩa thức ăn và bấm nút chụp'),
        findsOneWidget,
      );

      // Scanning Viewfinder
      expect(find.byType(ScanningViewfinder), findsOneWidget);

      // Bottom action buttons: Gallery icon, Shutter camera icon, Manual entry icon
      expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byIcon(Icons.edit_note_outlined), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });

    testWidgets('tapping help icon opens tips bottom sheet', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.help_outline));
      await tester.pumpAndSettle();

      expect(find.text('Mẹo chụp ảnh món ăn chuẩn AI'), findsOneWidget);
      expect(find.text('Đã hiểu'), findsOneWidget);

      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();

      expect(find.text('Mẹo chụp ảnh món ăn chuẩn AI'), findsNothing);
    });
  });
}
