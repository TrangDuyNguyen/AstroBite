# Đặc Tả Tích Hợp Hệ Thống Bên Thứ Ba (Third-Party Integrations)

## 1. Google Gemini AI (Multimodal Vision API)
- **SDK**: `firebase_ai` / Google Gen AI SDK.
- **Model Name**: `gemini-2.0-flash`.
- **Vai trò**: Nhận diện hình ảnh món ăn đa phương thức (Multimodal Input: Byte array ảnh + Structured System Prompt).
- **Quy định phản hồi**: Bắt buộc định dạng JSON schema (Strict Output Parsing).
- **Giới hạn & Tần suất (Rate Limits)**: Tối đa 15 requests/phút trên mỗi tài khoản miễn phí; cơ chế retry tối đa 2 lần với Exponential Backoff.

---

## 2. Google Gemini AI — Multi-turn Chat (Sprint 03 — EPIC-07)
- **SDK**: `firebase_ai` (đã có trong dự án, không cần dependency mới).
- **Model Name**: `gemini-2.0-flash`.
- **Vai trò**: Trợ lý dinh dưỡng AI hội thoại thời gian thực (Multi-turn conversation).
- **Cấu hình Chat**:
  - **System Prompt**: Bao gồm vai trò chuyên gia dinh dưỡng, ngữ cảnh bữa ăn hôm nay (calo/macro đã ăn, mục tiêu), quy tắc không chẩn đoán y khoa.
  - **Sliding Window**: Gửi tối đa 10 tin nhắn gần nhất trong mỗi request (giới hạn token).
  - **Session Reset**: Hàng ngày (00:00 giờ local) — tạo chat session mới.
- **Giới hạn**: 50 tin nhắn/người dùng/ngày; cơ chế retry 2 lần với Exponential Backoff.
- **Latency Target**: <= 3 giây cho phản hồi text thông thường.

---

## 3. Firebase Backend Services
- **Firebase Authentication**:
  - Hỗ trợ Email/Password, Google Sign-In, Apple Sign-In (bắt buộc cho iOS App Store).
  - Tự động đồng bộ JWT token cho các truy vấn bảo mật.
- **Cloud Firestore**:
  - Lưu trữ cơ sở dữ liệu NoSQL thời gian thực.
  - Hỗ trợ Offline Cache Persistence để người dùng vẫn xem được lịch sử khi mất mạng.
  - **Sprint 03**: Thêm subcollection `chat_sessions/{date}` cho AI Coach.
- **Firebase Storage**:
  - Lưu trữ ảnh chụp món ăn của người dùng: `gs://astrobite.appspot.com/users/{uid}/scans/{scanId}.jpg`.
  - Tự động nén ảnh chất lượng 80% trước khi upload để tiết kiệm băng thông.
- **Firebase App Check**:
  - Chống gian lận và giả mạo API bằng Play Integrity (Android) và DeviceCheck / App Attest (iOS).

---

## 4. Apple HealthKit & Health Connect (Sprint 03 — EPIC-10)
- **Flutter Package**: `health` (pub.dev) — Cross-platform wrapper cho cả HealthKit và Health Connect.
- **Phiên bản tối thiểu OS**: iOS 15+ (HealthKit), Android 14+ (Health Connect built-in).
- **Data Types Đọc (Read)**:
  - `HealthDataType.STEPS` — Số bước đi.
  - `HealthDataType.ACTIVE_ENERGY_BURNED` — Calo tiêu hao chủ động (kcal).
  - `HealthDataType.WORKOUT` — Danh sách bài tập (tên, thời lượng, calo).
- **Data Types Ghi (Write)**:
  - `HealthDataType.DIETARY_ENERGY_CONSUMED` — Calo nạp vào từ bữa ăn (kcal).
- **Tần suất đọc**: On-demand (khi mở Dashboard hoặc pull-to-refresh), không background polling.
- **Quyền riêng tư**: Dữ liệu Health chỉ đọc và hiển thị local trên thiết bị, **không gửi lên server**.
- **Graceful Degradation**: App hoạt động đầy đủ khi chưa kết nối hoặc quyền bị từ chối.
