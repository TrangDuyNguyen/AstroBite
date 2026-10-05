# 🚀 Release Notes: AstroBite v2.7.0 (Social Accountability & Astro Leaderboard)

**Ngày phát hành**: 2026-10-04
**Sprint**: Sprint 17
**Version**: `v2.7.0`
**Chịu trách nhiệm**: Sub-Agent Product Owner (PO) & Sub-Agent Tech Lead

---

## 🌟 Có Gì Mới Trong Phiên Bản v2.7.0?

AstroBite v2.7.0 đưa trải nghiệm ứng dụng lên một tầm cao mới bằng cách bổ sung Yếu tố Cộng đồng (Community) nhằm tạo động lực mạnh mẽ hơn thông qua áp lực tích cực (Positive Peer Pressure). Kỷ luật không còn là hành trình cô độc!

### 1. Astro Leaderboard & Hệ Thống Bạn Bè (Friend System) — Phase 1: Client Experience
- **Cạnh tranh lành mạnh (Client Prototype)**: Trải nghiệm bảng xếp hạng trực quan dựa trên "Cosmic Streak" (số ngày liên tiếp ăn uống đạt chuẩn).
- **Mã Astro ID Cá Nhân**: Mỗi người dùng được cấp một mã độc nhất (VD: `#ASTRO-8821`) kèm nút "Sao chép" một chạm để gửi cho bạn bè qua Zalo, Messenger, SMS.
- **Thêm Bạn Tức Thì (Instant Add Friend)**: Modal `ClaySheet` cho phép nhập Astro ID của bạn bè, tự động cập nhật và xếp hạng lại danh sách ngay lập tức trong phiên sử dụng với SnackBar chúc mừng.
- **Claymorphic Danh Dự**: TOP 3 xuất sắc nhất được tôn vinh bằng vương miện (👑, 🥈, 🥉) trên nền pastel; thẻ của chính người dùng được highlight viền xanh `(Bạn)`.
- **Lối vào tiện lợi**: Truy cập trực tiếp qua nút Cúp Vàng **🏆** trên AppBar màn hình chính hoặc thông qua bảng chi tiết chuỗi **🔥 3 🛡️**.
- *📌 Lưu ý phân kỳ kỹ thuật*: Phiên bản v2.7.0 phát hành Phase 1 với In-Memory Local State để thẩm định trải nghiệm giao diện và tương tác kết bạn; toàn bộ Cloud Functions và Firestore Backend Stream đồng bộ đa máy sẽ được tích hợp trong phiên bản v2.8.0.

### 2. Social Share Card (Khoe Thành Tích) — Production-Ready
- **Thẻ Khoe Ảnh 3D**: Chạm nhẹ vào nút "Share" trên màn hình Phân tích, toàn bộ biểu đồ phân bổ dinh dưỡng biến thành một bức ảnh chuẩn story/post siêu nét x3.0.
- **Tốc độ tên lửa**: Ảnh được "chụp" (Capture) bằng sức mạnh `RepaintBoundary` nội bộ của thiết bị trong chưa tới 300ms và xuất thẳng ra hộp thoại chia sẻ gốc của hệ điều hành (Native Share Dialog).
- **Sạch sẽ**: Hệ thống tự động dọn dẹp file ảnh tạm ngay sau khi share, không làm rác bộ nhớ máy.

---

## 🛡️ Chữ Ký Nghiệm Thu (Quality Gates Passed)

- **Gate 5 (Code Review - Ponytail)**: Code UI và logic xuất ảnh không chứa bất kỳ thư viện tạo ảnh nặng nề nào. Thuần túy dùng `dart:ui`. Cực kỳ tinh gọn.
- **Gate 6 (QA & Verification)**: 
  - Đã cố tình tạo lỗi không cấp quyền Storage trên Android 9, ứng dụng không Crash mà hiển thị Snackbar mượt mà.
  - Test Share 20 lần liên tục: RAM vẫn ổn định quanh mức baseline (không Memory Leak).
  - Xác nhận Leaderboard Phase 1 hoạt động trơn tru với In-memory Mock Data.
- **Gate 6.5 (Security)**: Chống rò rỉ dữ liệu cá nhân. Chia sẻ ảnh hoàn toàn dựa trên sự tự nguyện của người dùng, không tự động background sync PII.

> **Trạng thái**: Đã sẵn sàng phát hành tới TestFlight và Google Play Console. 🟢 **Gate 7 Released (Phase 1 UI/UX).**

