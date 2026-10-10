# Release Notes: AstroBite v3.2.0

> **Phiên bản**: `v3.2.0`  
> **Tên phát hành**: Core Tracker Clean Architecture & O(1) Meal Enums Overhaul  
> **Mã Epic**: `EPIC-REF-01` / `FEAT-S22-TRACKER`  
> **Ngày phát hành**: 2026-10-10  
> **Trạng thái**: 🟢 **OFFICIAL RELEASED (Gate 7 Clearance)**

---

## 🌟 Tóm Tắt Bản Phát Hành (Highlights)

1. **Chuẩn Hóa Dart 3 Enhanced Enums $O(1)$ (`MealType` & `NutrientType`)**:
   - Triệt tiêu 100% magic strings ('breakfast', 'lunch', 'dinner', 'snack', 'carbs', 'protein', 'fat') trên toàn bộ phân hệ Tracker.
   - Truy xuất thuộc tính $O(1)$ tức thời: `label`, `icon`, `color`, `clayBgColor`, `calorieRatio`.
   - Phân bổ bữa ăn thông minh theo giờ sinh học qua `MealType.fromCurrentHour()`.
   - Tương thích 100% với Firestore DTO qua `MealType.fromValue()`.

2. **Giải Phẫu Triệt Để 2 "God Files" Khổng Lồ**:
   - `meal_section.dart`: Rút gọn từ **1,224 dòng** xuống **122 dòng** (giảm 90%). Bóc tách thành `MealCardHeader`, `MealFoodItemTile`, `FoodDetailSheet`, `DishesBreakdownSection`, `CaloriePortionCard`, `MacroPill`.
   - `manual_entry_page.dart`: Rút gọn từ **969 dòng** xuống **331 dòng** (giảm 66%). Bóc tách thành `FoodListItemTile`, `FoodPortionCard`, `RecentFoodsTray`, `ManualEntryBottomBar`.
   - Toàn bộ các widget con mới được tạo đều tuân thủ nghiêm ngặt chuẩn Ponytail (< 200–350 dòng).

3. **Chất Lượng & Hiệu Năng Tuyệt Đối (Zero Compromise)**:
   - **306/306 test cases passed (100% xanh)** trên toàn bộ test suite.
   - **`flutter analyze` 0 errors, 0 warnings**.
   - Duy trì trải nghiệm 60 FPS mượt mà khi cuộn trang và mở các sheet chi tiết món ăn.
