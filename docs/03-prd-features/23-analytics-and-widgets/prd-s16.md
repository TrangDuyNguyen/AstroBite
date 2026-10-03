# PRD: Deep Domain, Analytics & OS Widgets (Sprint 16)

**Epic**: `EPIC-ANALYTICS`
**Feature**: `FEAT-S16-WIDGETS`
**Version**: `v2.6.0`
**Người soạn thảo**: Sub-Agent Business Analyst (BA)

## 1. Mục Tiêu (Objective)
Cung cấp khả năng theo dõi dữ liệu sức khỏe (Calo, Cân nặng) qua biểu đồ trực quan (Analytics) và khả năng xem nhanh tiến độ năng lượng từ màn hình chính của hệ điều hành (Native OS Widgets).

## 2. Đo Lường Thành Công (Metrics)
- **Tương tác**: >= 40% WAU (Weekly Active Users) xem tab Analytics ít nhất 1 lần/tuần.
- **Giữ chân (Retention)**: Người dùng cài đặt OS Widget có tỷ lệ giữ chân D30 cao hơn 20% so với người dùng không cài đặt.
- **Kỹ thuật**: 
  - Biểu đồ cuộn mượt mà >= 60 FPS trên các thiết bị phân khúc tầm trung.
  - OS Widget load dưới 500ms khi view trên màn hình chính (đọc từ SharedPreferences native).

## 3. Phạm Vi Yêu Cầu (Scope)

### 3.1. Analytics Dashboard (In-App)
- Màn hình `AnalyticsPage` (Tab mới trong Bottom Navigation hoặc truy cập từ HomePage).
- Biểu đồ Calorie Trend: Xem trung bình lượng calo nạp vào (In) so với mục tiêu (TDEE).
- Biểu đồ Weight Trend: Xem diễn biến cân nặng theo thời gian (7 ngày, 30 ngày).
- Yêu cầu UI: Sử dụng `FL Chart` với đường viền bo góc, màu sắc chuẩn Claymorphic UI (Sky Blue cho calo, Strawberry Pink cho cân nặng).

### 3.2. Native OS Home Widgets (iOS & Android)
- Cung cấp 2 kích thước Widget:
  - **Small (2x2)**: Hiển thị CalorieProgressArc vòng tròn thu nhỏ và lượng calo còn lại.
  - **Medium (4x2)**: Hiển thị CalorieProgressArc + ChunkyMacroBar (Carb/Fat/Protein).
- Tích hợp package `home_widget` để bắn dữ liệu một chiều (One-Way Data Sync) từ Flutter (khi log meal) ra Native Storage (iOS `UserDefaults` / Android `SharedPreferences`).
- Thêm cơ chế Deep Link: Bấm vào Widget mở thẳng ứng dụng.

## 4. Ràng Buộc Kỹ Thuật (Tech Constraints)
- **Kiến trúc Ponytail**: KHÔNG chạy background task định kỳ tốn pin để update Widget. Widget chỉ update khi app đang mở và user có thao tác làm thay đổi dữ liệu năng lượng.
- Phải bọc `FL Chart` bằng `RepaintBoundary` để tránh Flutter render lại toàn màn hình gây tụt FPS.

## 5. Quyết Định Từ Gate 0 (Tech Lead ADR)
- Chấp thuận sử dụng `fl_chart` cho biểu đồ.
- Chấp thuận sử dụng `home_widget` cho Native Widget. Không tự viết cầu nối MethodChannel phức tạp. Mọi thứ được lưu dưới dạng key-value tĩnh (JSON string) để native UI đọc.
