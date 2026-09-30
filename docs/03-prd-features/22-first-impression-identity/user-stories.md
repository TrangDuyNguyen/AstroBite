# 📝 BDD User Stories: First Impression & Identity (`FEAT-S15-FTUX`)

## US-01: Giao diện Đăng Nhập & Đăng Ký (AuthPage)
**Là một** người dùng mới  
**Tôi muốn** đăng nhập hoặc tạo tài khoản với giao diện thân thiện, trực quan  
**Để** tôi cảm thấy tin tưởng và có động lực bắt đầu hành trình cải thiện sức khỏe.

- **Scenario 1.1**: Form Đăng nhập cơ bản hiển thị chuẩn công thái học
  - **Given** người dùng mở màn hình Đăng nhập (AuthPage)
  - **When** màn hình render hoàn tất
  - **Then** hiển thị form nhập Email và Mật khẩu dưới dạng `ClayTextField` nền trắng, bo góc 20pt.
  - **And** các nút Đăng nhập Google/Apple hiển thị dạng nút lồi 3D (Tactile squash).
  - **And** touch target của các nút bấm tối thiểu 44x44pt.

- **Scenario 1.2**: Xử lý lỗi không có kết nối mạng
  - **Given** người dùng bị ngắt mạng (Offline state)
  - **When** người dùng bấm nút Đăng nhập
  - **Then** chặn request và hiển thị thông báo "Vui lòng kiểm tra kết nối mạng".

## US-02: Khảo Sát BMR & Onboarding
**Là một** người dùng vừa tạo tài khoản  
**Tôi muốn** nhập thông tin cá nhân (Chiều cao, Cân nặng, Giới tính, Mức vận động) thật nhanh chóng  
**Để** ứng dụng tính toán BMR và TDEE chính xác cho tôi.

- **Scenario 2.1**: Chọn mức độ vận động nhanh qua thẻ 3D
  - **Given** người dùng đang ở bước chọn "Mức độ vận động" trong luồng Onboarding
  - **When** danh sách hiển thị
  - **Then** các tùy chọn được trình bày dưới dạng `QuickChoiceChips` nổi 3D.
  - **And** khi bấm chọn, thẻ lún nhẹ xuống để tạo cảm giác bấm chạm (squash effect).

- **Scenario 2.2**: Chặn lưu khi thông tin không hợp lệ
  - **Given** người dùng để trống hoặc nhập chiều cao < 50cm
  - **When** bấm nút "Tiếp tục"
  - **Then** hiển thị thông báo lỗi màu đỏ (Error state) và không chuyển trang.

## US-03: Trang Tổng Kết Mục Tiêu (Goal Summary)
**Là một** người dùng đã hoàn thành Onboarding  
**Tôi muốn** xem một bản tổng kết trực quan lượng Calo và Macro tôi cần ăn mỗi ngày  
**Để** nắm rõ mục tiêu trước khi bước vào trang chính của ứng dụng.

- **Scenario 3.1**: Hiển thị CalorieProgressArc tổng quan
  - **Given** người dùng nhập thành công toàn bộ dữ liệu Onboarding
  - **When** chuyển tới bước cuối
  - **Then** màn hình `GoalSummaryPage` xuất hiện với biểu đồ vòng cung calo mục tiêu (CalorieProgressArc) ở chính giữa.
  - **And** bên dưới là nút "Bắt đầu hành trình" bự, dễ bấm.

## US-04: Quản Lý Hồ Sơ & Kết Nối Health (ProfilePage)
**Là một** người dùng ứng dụng  
**Tôi muốn** xem và chỉnh sửa hồ sơ cá nhân cũng như quản lý kết nối Apple Health / Health Connect  
**Để** đảm bảo thông tin sức khỏe luôn được đồng bộ.

- **Scenario 4.1**: Hiển thị thông tin Profile dạng thẻ nổi
  - **Given** người dùng chuyển sang tab Hồ sơ
  - **When** tab render
  - **Then** hiển thị thẻ `ClayCard` chứa thông tin BMR, TDEE, và nút "Cập nhật hồ sơ".
  
- **Scenario 4.2**: Toggle kết nối HealthKit/HealthConnect
  - **Given** người dùng mở trang Health Connection
  - **When** trang tải
  - **Then** hiển thị một nút gạt `ClaySwitch` hoặc nút 3D rõ ràng báo trạng thái (Đã kết nối / Chưa kết nối).
  - **And** nếu người dùng từ chối quyền, nút sẽ trở về trạng thái "Chưa kết nối" mượt mà không crash ứng dụng.
