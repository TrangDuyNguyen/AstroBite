# User Stories (BDD Given-When-Then): Sprint 28 Tracker & Dashboard

## User Story 1: Thêm món ăn tùy chỉnh qua CustomFoodSheet
- **Given** người dùng mở `CustomFoodSheet` cho bữa ăn bất kỳ (ví dụ `lunch`),
- **When** nhập tên món "Bún bò Huế", trọng lượng 350g, calo 480 kcal và bấm "Thêm vào bữa ăn",
- **Then** hệ thống tạo đúng `FoodLogDto` với `confidenceScore: 1.0` và `source: 'manual_entry'`, đóng sheet và cập nhật nhật ký.

## User Story 2: Điều hướng Quick Actions trên Dashboard
- **Given** người dùng đang ở `HomePage`,
- **When** nhấn vào "Công thức món", "Kế hoạch 7 ngày" hoặc banner "Bang Hội Vũ Trụ",
- **Then** router điều hướng chính xác tới `RecipesRoute`, `MealPlannerRoute`, hoặc `GuildRoute`.

## User Story 3: Xem & Mở rộng Vi chất trên Celestial Cockpit
- **Given** người dùng đang quan sát `CelestialCockpitCard`,
- **When** bấm vào thanh ngăn kéo vi chất,
- **Then** card mở rộng hiển thị đầy đủ 3 vi chất: Natri, Chất xơ và Lượng đường với tỷ lệ tiến trình trực quan.

## User Story 4: Quản lý món ăn trong MealDetailPage
- **Given** người dùng đang ở `MealDetailPage`,
- **When** bấm icon thùng rác của một món ăn và xác nhận trong hộp thoại,
- **Then** món ăn được xóa thông qua `trackerControllerProvider.notifier.deleteFoodLog` và tổng macro được tính toán lại ngay lập tức.
