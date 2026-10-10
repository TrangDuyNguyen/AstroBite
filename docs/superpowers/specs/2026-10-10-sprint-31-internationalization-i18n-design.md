# Architecture Decision Record (ADR-037): Sprint 31 — Internationalization Foundation (v3.11.0)

> **Trạng thái**: 🟢 **ACCEPTED**  
> **Người chủ trì**: Sub-Agent Tech Lead (*The Pragmatic System Architect*) & Sub-Agent PO (*The Strategic Tyrant*)  
> **Ngày phê duyệt**: 2026-10-10  
> **Phạm vi áp dụng**: Toàn bộ hệ thống UI strings, Theme/MaterialApp localization, Locale persistence và User Preferences  

---

## 1. Bối Cảnh (Context)
AstroBite hiện tại đang hard-code toàn bộ chuỗi hiển thị tiếng Việt trong `lib/core/constants/app_strings.dart` (66 static const keys) và rải rác một số chuỗi trong các presentation widgets.
Nhằm phục vụ mở rộng người dùng toàn cầu và nâng cao tỷ lệ giữ chân (Retention D30) đối với người dùng nói tiếng Anh:
- Ứng dụng cần hỗ trợ song ngữ ban đầu: **Tiếng Việt (`vi`)** và **English (`en`)**.
- Tuân thủ triết lý tối giản **Ponytail**: Sử dụng giải pháp chính quy, có sẵn từ Flutter SDK thay vì kéo thêm dependency bên thứ ba từ pub.dev.
- Tự động nhận diện ngôn ngữ máy người dùng (System Locale) khi khởi động lần đầu, đồng thời cung cấp tùy chọn chuyển đổi thủ công trong màn hình Cá nhân / Cài đặt (Hệ thống / Tiếng Việt / English).
- Xóa sạch hoàn toàn class nợ kỹ thuật `AppStrings` sau khi hoàn tất di chuyển sang `AppLocalizations`.

---

## 2. Quyết Định Kỹ Thuật (Decisions)

### D1: Công Nghệ Bản Địa Hóa (Approach A — Built-in `flutter_localizations`)
- Kích hoạt `flutter_localizations` từ Flutter SDK trong `pubspec.yaml`:
  ```yaml
  dependencies:
    flutter_localizations:
      sdk: flutter
  ```
- Tận dụng `intl: ^0.20.2` đã có sẵn trong dự án.
- Thiết lập cấu hình chuẩn `l10n.yaml` tại thư mục gốc:
  ```yaml
  arb-dir: lib/l10n
  template-arb-file: app_vi.arb
  output-localization-file: app_localizations.dart
  untranslated-messages-file: untranslated_messages.json
  ```
- Không sử dụng `easy_localization` hay bất kỳ thư viện bên thứ ba nào (tuân thủ nguyên tắc Ponytail: stdlib trước, 0 bloat).

### D2: Tổ Chức File ARB & Nguồn Dịch Thuật
- Tạo thư mục `lib/l10n/`:
  - `app_vi.arb`: Bản gốc tiếng Việt (chuyển đổi từ `AppStrings`).
  - `app_en.arb`: Bản dịch tiếng Anh tương ứng 100% key-for-key.
- Tạo tiện ích mở rộng truy cập thuận tiện:
  ```dart
  extension AppLocalizationsX on BuildContext {
    AppLocalizations get l10n => AppLocalizations.of(this)!;
  }
  ```

### D3: Quản Lý State Ngôn Ngữ & Lưu Trữ (Locale State Management)
- Tạo `LocaleNotifier` kế thừa `@riverpod` hoặc `Notifier<Locale?>`:
  - Trạng thái `null`: Theo hệ thống máy (`Locale` của thiết bị).
  - Trạng thái `Locale('vi')`: Cố định Tiếng Việt.
  - Trạng thái `Locale('en')`: Cố định English.
- Lưu trữ lựa chọn của người dùng vào `shared_preferences` với key `astrobite_app_locale` (giá trị: `'system'`, `'vi'`, `'en'`).
- Khởi tạo đồng bộ / đọc cache khi app khởi động để đảm bảo Zero-Flicker.

### D4: Tích Hợp MaterialApp.router
- Cấu hình `lib/app.dart`:
  ```dart
  MaterialApp.router(
    title: 'AstroBite',
    locale: ref.watch(appLocaleProvider),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    ...
  );
  ```

### D5: Kế Hoạch Thanh Lý Kỹ Thuật `AppStrings` (Ponytail Clean Code)
- Bước 1: Giữ `AppStrings` làm fallback tạm thời trong quá trình Dev chuyển đổi các màn hình.
- Bước 2: Chuyển đổi toàn bộ tham chiếu sang `context.l10n.*`.
- Bước 3: Di chuyển nhãn trong `MealType` / `MealEnum` sang dynamic getter nhận `AppLocalizations` hoặc helper method.
- Bước 4: Xóa sạch `lib/core/constants/app_strings.dart`.

---

## 3. Hệ Quả & Cam Kết Kỹ Thuật (Consequences & SLAs)
- **Zero New Third-party Dependencies**: 0 package mới từ pub.dev.
- **Performance**: Chuyển đổi ngôn ngữ tức thì (< 100ms), 0 lag, 60 FPS.
- **Codebase Cleanliness**: 100% các file tuân thủ vùng an toàn < 350 dòng.
- **Test Integrity**: Toàn bộ unit tests và widget tests tương thích với `AppLocalizations`.
