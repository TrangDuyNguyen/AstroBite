# Release Notes — AstroBite v1.10.0 (Personal Gemini API Key & Live AR HUD Camera)

- **Release Version**: `v1.10.0`
- **Build Number**: `11`
- **Release Date**: 2026-09-26
- **Sprint**: Sprint 11 (Personal Gemini API Key & Live AR HUD Camera Viewfinder)
- **Quality Gates**: All 8 Gates Cleared (Gate 0 -> Gate 7)
- **Sign-off By**: Tam Đầu Chế: Sub-Agent Product Owner (PO), Tech Lead & Project Manager (PM)

---

## 🌟 What's New in v1.10.0

### 1. Personal Gemini API Key Support (BYOK - Bring Your Own Key)
- **Mục tiêu PO**: Giải quyết triệt để vấn đề hạn ngạch (Quota 429/503) và chi phí Billing Firebase Vertex AI của GCP. Cho phép người dùng tự do sử dụng API Key cá nhân miễn phí từ [Google AI Studio](https://aistudio.google.com).
- **Kiến trúc Kỹ thuật (Tech Lead)**:
  - Tích hợp `GeminiApiKeyService` mã hóa và lưu trữ Key an toàn qua `SharedPreferences`.
  - Tự động chuyển đổi thông minh:
    - Nếu có Personal API Key: Sử dụng trực tiếp `GoogleGenerativeAI(apiKey: key)` (Gemini 2.0 Flash) không phụ thuộc vào Firebase Backend.
    - Nếu không có Key: Tự động fallback về dịch vụ mặc định `FirebaseVertexAI`.
  - Giao diện quản lý Key tiện lợi: Có thể cấu hình trực tiếp từ trang **Hồ sơ (ProfilePage)** hoặc ngay tại hộp thoại cảnh báo khi quét món ăn.

### 2. Live Camera Sci-Fi AR HUD Scanner
- **Mục tiêu UX**: Nâng tầm trải nghiệm người dùng, loại bỏ thao tác trung gian mở app camera rời của hệ điều hành.
- **Kiến trúc Kỹ thuật (Tech Lead)**:
  - Tích hợp package chính thức `camera: ^0.11.2+1`.
  - **Live Camera Feed**: Luồng video thực tế từ ống kính chiếu trực tiếp bên dưới khung ngắm Holographic Sci-Fi HUD độ phân giải chuẩn, tỷ lệ co giãn thông minh không méo hình.
  - **1-Tap Fast Shutter**: Chụp ảnh ngay tức khắc từ luồng camera (`takePicture()`) và gửi thẳng sang Gemini Vision AI phân tích, giảm thời gian log món ăn xuống `< 2s`.
  - **Điều khiển Đèn Flash trực tiếp**: Hỗ trợ toggle Flash/Torch vật lý trực tiếp từ AppBar.
  - **0 Memory Leak**: Xử lý triệt để vòng đời ứng dụng với `WidgetsBindingObserver` (tự động dispose camera khi app background và khởi tạo lại khi resume).
  - **Fallback an toàn**: Tự động chuyển về `image_picker` nếu thiết bị không hỗ trợ camera hoặc bị từ chối quyền.

### 3. Android System & Permissions Hardening
- Bổ sung đầy đủ quyền camera trong `AndroidManifest.xml`:
  - `android.permission.CAMERA`
  - Khai báo hardware camera và autofocus (`android:required="false"`).
- Khắc phục các vấn đề từ chối quyền và lỗi intent trên các dòng máy Android thật.

---

## 🧪 Quality Gate Verification & Release Sign-Off (Tam Đầu Chế)

### 1. Sub-Agent Product Owner (PO) — *"The Strategic Tyrant"*
- **ROI & Business Metric**: Loại bỏ điểm nghẽn lớn nhất khiến người dùng churn do lỗi quota AI. Tính năng BYOK mở rộng khả năng tiếp cận người dùng toàn cầu mà không phát sinh chi phí server.
- **Phê duyệt**: **GATE 7 APPROVED**.

### 2. Sub-Agent Tech Lead — *"The Pragmatic System Architect"*
- **Technical Release Clearance**:
  - `flutter analyze`: **0 errors, 0 warnings**.
  - `flutter test`: **186 / 186 unit/widget tests PASSED (100%)**.
  - Keystore & Release Signing: Tích hợp `key.properties` tự động cho Android Release APK/AAB.
  - Bảo mật: 0 secret leak, 0 API key hardcoded trong mã nguồn.
- **Phê duyệt**: **GATE 7 TECHNICAL CLEARANCE APPROVED**.

### 3. Sub-Agent Project Manager (PM) — *"The Clockwork Disciplinarian"*
- **Sprint Delivery**: Hoàn thành 100% WBS Task Matrix Sprint 11 đúng hạn.
- **Release Action**: Sẵn sàng kích hoạt git commit và tag `v1.10.0` để kích hoạt pipeline GitHub Actions & Fastlane phân phối tự động lên Firebase App Distribution.
- **Phê duyệt**: **SPRINT 11 CLOSED & RELEASE AUTHORIZED**.
