# User Stories & BDD Scenarios: AI Coach & Scanner Review (Sprint 23)

- **Feature**: `FEAT-S23-COACH-SCANNER`
- **Sub-Agent**: `business-analyst`
- **Sign-Off**: `product-owner`

---

## 📖 US-01: Xem & Tương Tác Với AI Coach Cá Nhân Hóa

**As a** người dùng AstroBite  
**I want to** mở màn hình AI Coach để nhận tư vấn dinh dưỡng và gợi ý món ăn  
**So that** tôi duy trì được mục tiêu calo và macro hàng ngày dễ dàng.

### Scenario 1.1: Xem thông tin tiến độ calo và macros trên Context Header
- **Given** người dùng đã log bữa trưa với 500 kcal
- **When** người dùng mở màn hình `CoachPage`
- **Then** `CoachContextHeader` hiển thị lượng calo còn lại chính xác
- **And** 3 thanh mini macro hiển thị tỷ lệ Carbs, Fat, Protein đã nạp.

### Scenario 1.2: Lưu món ăn từ 1-Tap Holographic Meal Card
- **Given** AI Coach gợi ý thẻ món ăn "Phở bò tái" với 450 kcal
- **When** người dùng nhấn nút "Ghi nhận 1-Chạm"
- **Then** món ăn được lưu ngay vào nhật ký của bữa ăn tương ứng
- **And** hiển thị thông báo SnackBar xác nhận thành công.

---

## 📖 US-02: Xem Lại & Điều Chỉnh Kết Quả Quét Món Ăn Đa Món

**As a** người dùng vừa chụp ảnh mâm cơm  
**I want to** xem lại từng món được nhận diện trên màn hình Scan Review  
**So that** tôi có thể tinh chỉnh trọng lượng từng món trước khi lưu.

### Scenario 2.1: Điều chỉnh khối lượng món ăn bằng Quick Stepper
- **Given** màn hình `ScanReviewPage` hiển thị món "Thịt kho tàu" 150g
- **When** người dùng nhấn chip "+50g"
- **Then** khối lượng món tăng lên 200g
- **And** tổng lượng calo và macros cập nhật tương ứng theo thời gian thực.

### Scenario 2.2: Xóa một món phụ trong mâm cơm
- **Given** màn hình hiển thị 3 món: Cơm trắng, Thịt kho, Canh rau
- **When** người dùng nhấn nút xóa (Delete) món "Canh rau"
- **Then** món đó biến mất khỏi danh sách
- **And** tổng lượng calo được trừ đi chính xác.
