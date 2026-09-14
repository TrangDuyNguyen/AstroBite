# Đặc Tả Tích Hợp Hệ Thống Bên Thứ Ba (Third-Party Integrations)

## 1. Google Gemini AI (Multimodal Vision API)
- **SDK**: `firebase_ai` / Google Gen AI SDK.
- **Model Name**: `gemini-2.0-flash`.
- **Vai trò**: Nhận diện hình ảnh món ăn đa phương thức (Multimodal Input: Byte array ảnh + Structured System Prompt).
- **Quy định phản hồi**: Bắt buộc định dạng JSON schema (Strict Output Parsing).
- **Giới hạn & Tần suất (Rate Limits)**: Tối đa 15 requests/phút trên mỗi tài khoản miễn phí; cơ chế retry tối đa 2 lần với Exponential Backoff.

---

## 2. Firebase Backend Services
- **Firebase Authentication**:
  - Hỗ trợ Email/Password, Google Sign-In, Apple Sign-In (bắt buộc cho iOS App Store).
  - Tự động đồng bộ JWT token cho các truy vấn bảo mật.
- **Cloud Firestore**:
  - Lưu trữ cơ sở dữ liệu NoSQL thời gian thực.
  - Hỗ trợ Offline Cache Persistence để người dùng vẫn xem được lịch sử khi mất mạng.
- **Firebase Storage**:
  - Lưu trữ ảnh chụp món ăn của người dùng: `gs://astrobite.appspot.com/users/{uid}/scans/{scanId}.jpg`.
  - Tự động nén ảnh chất lượng 80% trước khi upload để tiết kiệm băng thông.
- **Firebase App Check**:
  - Chống gian lận và giả mạo API bằng Play Integrity (Android) và DeviceCheck / App Attest (iOS).
