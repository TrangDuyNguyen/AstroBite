import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/app.dart';

void main() {
  testWidgets('AstroBiteApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AstroBiteApp(),
      ),
    );
    expect(find.byType(AstroBiteApp), findsOneWidget);
  });
}
