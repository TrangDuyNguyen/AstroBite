# 📝 BDD User Stories: Analytics & OS Widgets (`FEAT-S16-WIDGETS`)

## US-01: Bảng điều khiển phân tích (Analytics Dashboard)
**Là một** người dùng muốn theo dõi tiến độ sức khỏe
**Tôi muốn** xem biểu đồ xu hướng calo và cân nặng theo thời gian
**Để** tôi có cái nhìn tổng quan về thói quen ăn uống và hiệu quả giảm/tăng cân của mình.

- **Scenario 1.1**: Xem biểu đồ xu hướng calo (CalorieTrendChart)
  - **Given** người dùng mở tab "Phân tích" (Analytics)
  - **When** màn hình tải xong dữ liệu trong tuần
  - **Then** hiển thị `CalorieTrendChart` (FL Chart) thể hiện lượng calo nạp vào mỗi ngày.
  - **And** biểu đồ được bọc trong `RepaintBoundary` để duy trì cuộn mượt mà >= 60 FPS.
  - **And** đường xu hướng sử dụng màu 🩵 Primary (#1CB0F6).

- **Scenario 1.2**: Xem biểu đồ xu hướng cân nặng (WeightTrendChart)
  - **Given** người dùng đang ở tab "Phân tích"
  - **When** cuộn xuống phần cân nặng
  - **Then** hiển thị `WeightTrendChart` thể hiện cân nặng được ghi nhận trong 30 ngày qua.
  - **And** đường xu hướng sử dụng màu 🍓 Secondary (#FF5C8D).

## US-02: OS Home Widgets (iOS & Android)
**Là một** người dùng có thói quen xem nhanh thông tin
**Tôi muốn** xem lượng calo còn lại và tiến độ macro ngay trên màn hình chính của điện thoại
**Để** tôi không cần mở app mà vẫn kiểm soát được chế độ ăn uống.

- **Scenario 2.1**: Đồng bộ dữ liệu ra Widget sau khi log bữa ăn
  - **Given** người dùng vừa thêm một bữa ăn thành công vào nhật ký
  - **When** dữ liệu được lưu vào Firestore/Local
  - **Then** ứng dụng gọi `home_widget` để cập nhật `SharedPreferences` (Native).
  - **And** widget trên màn hình chính tự động hiển thị số liệu Calo/Macro mới nhất.

- **Scenario 2.2**: Giao diện Widget tĩnh trên iOS/Android
  - **Given** người dùng nhìn vào màn hình chính của điện thoại
  - **When** nhìn vào Widget của AstroBite (Small hoặc Medium)
  - **Then** Widget hiển thị trạng thái hiện tại dưới dạng thẻ nổi ClayCard (Màu nền trắng #FFFFFF) chuẩn Claymorphic UI.
  - **And** hiển thị thanh `CalorieProgress` và `ChunkyMacroBar` thu nhỏ.

## US-03: Xử lý khi Widget không có dữ liệu (Empty State)
**Là một** người dùng vừa cài app hoặc chưa log bữa ăn nào trong ngày
**Tôi muốn** Widget hiển thị lời nhắc nhở trực quan
**Để** tôi nhớ mở app và bắt đầu theo dõi.

- **Scenario 3.1**: Hiển thị Empty State trên Widget
  - **Given** người dùng chưa ghi nhận bất kỳ dữ liệu nào trong ngày
  - **When** xem Widget trên màn hình chính
  - **Then** hiển thị trạng thái "0 Calo" cùng thông điệp "Bắt đầu ghi chú bữa ăn của bạn!".
  - **And** khi bấm vào Widget, ứng dụng mở trực tiếp màn hình `CameraPage` (Deep link).
