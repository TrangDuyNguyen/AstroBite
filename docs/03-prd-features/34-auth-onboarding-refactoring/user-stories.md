# Kịch Bản Nghiệp Vụ BDD (User Stories) — Sprint 27

### Epic: Auth & Onboarding Flow Clean Architecture

#### Story 1: Khởi động app qua Splash Page
- **Given** người dùng mở ứng dụng AstroBite
- **When** màn hình Splash xuất hiện
- **Then** logo AstroBite phóng to mượt mà cùng 10 món ăn 3D trôi nổi trong không gian
- **And** hệ thống tự động kiểm tra trạng thái đăng nhập và điều hướng sang trang tương ứng sau 1800ms.

#### Story 2: Đăng nhập & Khôi phục mật khẩu
- **Given** người dùng ở màn hình `LoginPage`
- **When** người dùng nhập email và mật khẩu hợp lệ và bấm Đăng nhập
- **Then** hệ thống xác thực thành công và điều hướng sang Onboarding hoặc Trang chủ
- **And** nếu người dùng quên mật khẩu, có thể mở dialog đặt lại mật khẩu và nhận thông báo thành công.

#### Story 3: Hoàn thành khảo sát Onboarding 5 bước
- **Given** người dùng mới chưa hoàn tất hồ sơ
- **When** đi qua từng bước khảo sát từ Giới tính -> Thể trạng -> Mục tiêu
- **Then** thanh tiến trình bước nhảy từ 1/5 đến 5/5
- **And** tại bước cuối cùng, bấm "Xem Kế Hoạch Cá Nhân" chuyển tiếp sang màn hình tóm tắt mục tiêu.
