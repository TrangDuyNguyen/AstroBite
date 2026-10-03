# 🚀 Release Notes: AstroBite v2.6.0 (Deep Domain, Analytics & OS Widgets)

**Ngày phát hành**: 2026-10-03
**Sprint**: Sprint 16
**Version**: `v2.6.0`
**Chịu trách nhiệm**: Sub-Agent Product Owner (PO) & Sub-Agent Tech Lead

---

## 🌟 Có Gì Mới Trong Phiên Bản v2.6.0?

Phiên bản `v2.6.0` mang đến khả năng theo dõi tiến độ sức khỏe toàn diện và tiện lợi nhất từ trước đến nay, hoàn thiện chu trình "First Impression" bằng cái nhìn tổng quan sâu sắc qua **Analytics Dashboard** và **Native OS Widgets**.

### 1. Bảng Phân Tích Chuyên Sâu (Analytics Dashboard)
- **Calorie Trend Chart**: Theo dõi lượng calo nạp vào 7 ngày gần nhất, đối chiếu với mục tiêu TDEE. Giao diện biểu đồ đường (Line Chart) mượt mà chuẩn Claymorphic UI, tô màu Sky Blue `#1CB0F6`.
- **Weight Trend Chart**: Nắm bắt xu hướng cân nặng 30 ngày qua bằng đường Strawberry Pink `#FF5C8D`.
- *Hiệu năng Ponytail*: Áp dụng kỹ thuật `RepaintBoundary`, đảm bảo giữ vững `>= 60 FPS` khi cuộn qua lại giữa các biểu đồ, kể cả trên các thiết bị đời cũ.

### 2. Tiện Ích Màn Hình Chính (Native OS Home Widgets)
- Không cần mở app vẫn xem được lượng Calo và Macro còn lại trong ngày.
- **2 Kích cỡ linh hoạt**: Small (2x2) hiển thị Vòng cung năng lượng Calo; Medium (4x2) hiển thị thêm thanh tiến độ vi chất (Carb/Fat/Protein).
- **One-Way Sync Tiết Kiệm Pin**: Áp dụng triết lý 0 Background Service, dữ liệu chỉ được bắn tĩnh (key-value) ra hệ điều hành (iOS `AppGroup`, Android `AppWidgetProvider`) ngay tại thời điểm người dùng log bữa ăn thành công.
- **Deep Link Scan**: Chạm vào widget khi chưa có dữ liệu sẽ lập tức gọi ống kính AI Gemini mở ra ở chế độ quét món ăn.

---

## 🛡️ Chữ Ký Nghiệm Thu (Quality Gates Passed)

- **Gate 5 (Code Review - Ponytail)**: Đã cắt bỏ 45 dòng code logic animation thừa, sử dụng cấu trúc hàm static thuần túy để sync dữ liệu. Mức độ tinh gọn: Tuyệt đối.
- **Gate 6 (QA & Verification)**: 
  - `flutter analyze` 0 issues.
  - Automated Tests: 100% Pass (Toàn bộ kịch bản BDD Gherkin).
  - 0 Memory Leak khi load biểu đồ 50 lần liên tục.
- **Gate 6.5 (Security)**: Không lưu trữ PII (thông tin cá nhân) trên Native SharedPreferences, chỉ lưu các con số tính toán.

> **Trạng thái**: Đã sẵn sàng cập bến App Store và Google Play. 🟢 **Gate 7 Released.**
