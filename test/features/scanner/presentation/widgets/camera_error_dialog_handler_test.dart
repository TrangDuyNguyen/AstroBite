import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/l10n/app_localizations.dart';
import 'package:astrobite/features/scanner/domain/usecases/scan_food_usecase.dart';
import 'package:astrobite/features/scanner/presentation/widgets/camera_error_dialog_handler.dart';
import '../../../../helpers/test_l10n.dart';

void main() {
  group('CameraErrorDialogHandler Tests', () {
    testWidgets('formatErrorMessage maps technical SocketException to friendly message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: Builder(
            builder: (context) {
              const rawTechnicalError =
                  "ClientException with SocketException: Failed host lookup: 'generativelanguage.googleapis.com' (OS Error: No address associated with hostname, errno = 7), uri=https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-lite-latest:generateContent";

              final friendly = CameraErrorDialogHandler.formatErrorMessage(context, rawTechnicalError);
              expect(friendly, equals('Không có kết nối Internet. Vui lòng kiểm tra Wi-Fi/4G và thử lại.'));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('handleResult with network error shows friendly offline dialog with manual entry option', (tester) async {
      const rawError =
          "ClientException with SocketException: Failed host lookup: 'generativelanguage.googleapis.com'";

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    CameraErrorDialogHandler.handleResult(
                      context: context,
                      result: ScanError(rawError),
                      bytes: Uint8List(0),
                      onClearPreview: () {},
                      onRetry: (_) async {},
                    );
                  },
                  child: const Text('Simulate Error'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Simulate Error'));
      await tester.pumpAndSettle();

      // Verify the friendly dialog is displayed instead of a raw socket error
      expect(find.text('Mất kết nối mạng'), findsOneWidget);
      expect(
        find.textContaining('AI Vision cần kết nối Internet để phân tích hình ảnh'),
        findsOneWidget,
      );
      expect(find.text(testL10n.manualEntry), findsOneWidget);
      expect(find.text(testL10n.retry), findsOneWidget);
    });
  });
}
