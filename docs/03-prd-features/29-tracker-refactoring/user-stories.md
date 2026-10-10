# User Stories & Kịch Bản BDD (Sprint 22 — Tracker Refactoring)

- **Mã Feature**: `FEAT-S22-TRACKER`
- **Sub-Agent phụ trách**: `business-analyst`
- **Tiêu chuẩn**: BDD Given-When-Then

---

## 📖 User Story 1: Hiển Thị Bữa Ăn Chuẩn Type Safety (US-S22-01)
**Là một** người dùng theo dõi thực đơn hàng ngày,  
**Tôi muốn** xem các bữa ăn (Sáng, Trưa, Tối, Phụ) với màu sắc, icon và ngân sách calo chính xác,  
**Để** quản lý lượng calo nạp vào một cách trực quan và không bị gián đoạn hay lỗi hiển thị.

### Kịch bản BDD 1.1: Hiển thị đúng màu và icon bữa ăn theo MealType
- **Given** người dùng đang ở màn hình Trang chủ (Tracker Home),
- **When** danh sách các bữa ăn được render từ DailySummary,
- **Then** mỗi khối bữa ăn sử dụng trực tiếp icon và màu sắc từ `MealType` enum ($O(1)$),
- **And** không xảy ra hiện tượng lệch màu hoặc sai tên giữa các màn hình.

---

## 📖 User Story 2: Thao Tác Thêm & Xóa Món Ăn Mượt Mà (US-S22-02)
**Là một** người dùng bận rộn,  
**Tôi muốn** thao tác xóa món ăn bằng cử chỉ vuốt (swipe dismiss) hoặc thêm nhanh món,  
**Để** cập nhật nhật ký thức ăn nhanh chóng trong dưới 3 giây.

### Kịch bản BDD 2.1: Vuốt để xóa món ăn trong MealSection
- **Given** bữa ăn đang có ít nhất 1 món đã được ghi chép,
- **When** người dùng vuốt sang trái (Swipe-to-Dismiss) trên thẻ món ăn `MealFoodItemTile`,
- **Then** hệ thống hiển thị nền đỏ kèm icon thùng rác,
- **And** món ăn được xóa khỏi Firestore và cập nhật lại thanh tiến độ macro ngay lập tức.

---

## 📖 User Story 3: Nhập Món Ăn Thủ Công Chuẩn Gọn (US-S22-03)
**Là một** người dùng tự nấu ăn hoặc ăn món không có trong danh bạ,  
**Tôi muốn** nhập thông tin món ăn thủ công trên giao diện phân tách rõ ràng,  
**Để** không bị rối mắt và điền calo/macro chuẩn xác.

### Kịch bản BDD 3.1: Chuyển đổi bữa ăn trong trang Manual Entry
- **Given** người dùng mở trang `ManualEntryPage`,
- **When** người dùng chọn 1 trong 4 chip bữa ăn (`MealType.values`),
- **Then** chip được kích hoạt hiển thị đúng màu claymorphic tương ứng của bữa ăn đó,
- **And** form tự động gắn giá trị `MealType` đã chọn vào DTO khi lưu.
