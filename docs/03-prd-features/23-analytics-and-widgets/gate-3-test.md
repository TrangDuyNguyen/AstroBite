# Gate 3: Master Test Plan & BDD (Sprint 16)

**Feature**: Analytics Dashboard & OS Home Widgets (`FEAT-S16-WIDGETS`)
**Người thực hiện**: Sub-Agent QA / QC Tester (The Paranoid Inquisitor)
**Ngày tạo**: 2026-10-03
**Tiêu chuẩn Pass**: 100% Traceability, 0 Memory Leak, >= 60 FPS. Không du di.

## 1. Kiểm Thử Phi Chức Năng (Non-Functional Tests)
- **NFT-01 (Performance)**: Biểu đồ `CalorieTrendChart` và `WeightTrendChart` phải giữ được >= 60 FPS khi cuộn nhanh (sử dụng DevTools để monitor).
- **NFT-02 (Memory Leak)**: Render liên tục 30 điểm dữ liệu trên biểu đồ FL Chart và load đi load lại 20 lần không làm tăng rò rỉ RAM (kiểm tra ranh giới `RepaintBoundary`).
- **NFT-03 (Widget Latency)**: Native OS Widget (iOS/Android) phải render dưới 500ms khi người dùng vừa vuốt sang trang HomeScreen chứa Widget.

## 2. Kịch Bản Kiểm Thử BDD Gherkin (Automated Tests)

```gherkin
Feature: Analytics Dashboard FL Chart
  Để kiểm soát tiến độ calo và cân nặng
  Là một người dùng
  Tôi muốn xem biểu đồ xu hướng chính xác và mượt mà

  Scenario: Vẽ biểu đồ Calorie Trend chính xác
    Given người dùng đang ở tab "Phân tích" (AnalyticsPage)
    And hệ thống có dữ liệu calo của 7 ngày qua: [1500, 1800, 2000, 1600, 1900, 2100, 1750]
    When widget `CalorieTrendChart` được render
    Then biểu đồ FL Chart phải hiển thị đủ 7 điểm dữ liệu trên trục hoành
    And điểm cao nhất trên trục tung phải >= 2100
    And đường line chart sử dụng mã màu `#1CB0F6` (Sky Blue)

  Scenario: Render an toàn khi không có dữ liệu (Empty State)
    Given người dùng mới tạo tài khoản, chưa có dữ liệu calo
    When widget `CalorieTrendChart` được render
    Then biểu đồ không được ném ngoại lệ (Exception)
    And hiển thị thông báo "Chưa đủ dữ liệu để phân tích" giữa `ClayCard`
```

```gherkin
Feature: Native OS Home Widget Data Sync
  Để có thể xem nhanh calo còn lại
  Là một người dùng bận rộn
  Tôi muốn Widget luôn đồng bộ với dữ liệu trong App

  Scenario: Bắn dữ liệu (One-way Sync) ra Widget sau khi Log Meal
    Given lượng calo còn lại trong App là 800 kcal
    When người dùng ghi nhận thành công một bữa ăn 300 kcal
    Then lượng calo còn lại cập nhật thành 500 kcal
    And hệ thống phải gọi hàm `HomeWidget.saveWidgetData` với khóa `calories_remaining` là 500
    And hệ thống phải gọi hàm `HomeWidget.updateWidget` để báo Native OS vẽ lại
```

## 3. Manual Test Cases (Biên và Ngoại Lệ - EP/BVA)
- **TC-001 (Biên dữ liệu biểu đồ)**: Giả lập có 1 điểm dữ liệu đột biến (ví dụ: Log nhầm 15,000 calo). Kiểm tra trục tung (Y-axis) của FL Chart có bị thu nhỏ (scale) đến mức các điểm khác nằm bẹp xuống đáy hay không. (Yêu cầu: Có kịch bản giới hạn trần Y-axis hợp lý).
- **TC-002 (Offline OS Widget)**: Đặt máy ở chế độ Airplane Mode, log món ăn bằng dữ liệu Local Cache. Kiểm tra xem Widget ở màn hình chính có được cập nhật bằng số liệu Local Cache không. (Yêu cầu: Widget đọc từ Local SharedPreferences nên vẫn phải hiển thị đúng số liệu ngay cả khi Offline).
- **TC-003 (Widget Deep Link)**: Bấm vào Widget khi App đã bị kill (khỏi RAM). Ứng dụng phải mở lên, init Riverpod và điều hướng an toàn tới `CameraPage` thông qua `DeepLinkHandler`.

## 4. Chữ Ký Nghiệm Thu (Gate 3 Sign-Off)
Tài liệu Test Design đã được rà soát và phủ 100% User Stories của BA. Các Edge Cases cho OS Widget đã được liệt kê. Sẵn sàng bàn giao cho Dev FE.
- **Ký tên**: Sub-Agent QA Tester
