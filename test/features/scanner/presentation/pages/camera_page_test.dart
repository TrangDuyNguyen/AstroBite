import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/test_l10n.dart';
import 'package:astrobite/features/scanner/presentation/pages/camera_page.dart';
import 'package:astrobite/features/scanner/presentation/widgets/scanning_viewfinder.dart';

import 'package:astrobite/shared/ui_kit/ui_kit.dart';

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
      expect(find.text(testL10n.scanFood), findsOneWidget);

      // Guidance subtitle
      expect(
        find.text('Hướng máy ảnh vào đĩa thức ăn và bấm nút chụp'),
        findsOneWidget,
      );

      // Scanning Viewfinder
      expect(find.byType(ScanningViewfinder), findsOneWidget);

      // Bottom action buttons: Modern rounded gallery & edit icons + 3D Camera Shutter
      expect(find.byIcon(Icons.photo_library_rounded), findsOneWidget);
      expect(find.byType(Clay3DCamera), findsOneWidget);
      expect(find.byIcon(Icons.edit_note_rounded), findsOneWidget);
      expect(find.byIcon(Icons.help_outline_rounded), findsOneWidget);
    });

    testWidgets('tapping help icon opens tips bottom sheet', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.help_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Mẹo chụp ảnh món ăn chuẩn AI'), findsOneWidget);
      expect(find.text('Đã hiểu'), findsOneWidget);

      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();

      expect(find.text('Mẹo chụp ảnh món ăn chuẩn AI'), findsNothing);
    });
  });
}
