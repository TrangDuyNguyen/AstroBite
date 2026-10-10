# User Stories (BDD Given-When-Then): Sprint 29 Deep Clean

## User Story 1: Chuyển đổi chu kỳ phân tích
- **Given** người dùng đang ở `AnalyticsPage`,
- **When** bấm chọn tab "30 ngày" trên Period Selector,
- **Then** đồ thị và 3 thẻ KPI lập tức tính toán lại dữ liệu trung bình theo 30 ngày.

## User Story 2: Điều hướng mượt mà qua Bottom Dock
- **Given** người dùng ở bất kỳ màn hình chính nào,
- **When** bấm vào tab hoặc nút FAB Camera chính giữa,
- **Then** router chuyển tab hoặc mở Camera scanner với hiệu ứng phản hồi xúc giác 60 FPS.

## User Story 3: Xem & quản lý lịch sử tư vấn Coach
- **Given** người dùng mở `CoachHistorySheet`,
- **When** chọn một phiên cũ hoặc bấm xóa một phiên,
- **Then** giao diện chuyển đúng ngữ cảnh chat hoặc thực thi xóa sau khi xác nhận dialog.

## User Story 4: Tùy chỉnh khẩu phần gợi ý món ăn
- **Given** người dùng nhận được thẻ gợi ý món ăn từ AstroCoach,
- **When** bấm tăng/giảm nút stepper (+20g / -20g),
- **Then** các chỉ số calo, carbs, protein, fat được tự động co giãn tương ứng theo tỷ lệ mới.
