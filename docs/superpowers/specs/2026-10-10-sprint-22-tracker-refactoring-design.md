# Architectural Design Spec: Core Tracker Clean Architecture & O(1) Meal Enums Overhaul

- **Sprint**: Sprint 22 (v3.2.0)
- **Epic**: `EPIC-REF-01` / `FEAT-S22-TRACKER`
- **Owner**: Sub-Agent Tech Lead & System Architect
- **Status**: 🟢 **Gate 0 Approved (Technical Feasibility Signed Off)**
- **Date**: 2026-10-10

---

## 1. Context & Problem Statement

Trong quá trình rà soát toàn diện codebase AstroBite, phân hệ **Tracker** là module cốt lõi lớn nhất (24 files | 6,179 dòng code), nhưng đang chứa 2 "God Files" nghiêm trọng:
1. `lib/features/tracker/presentation/widgets/meal_section.dart`: **1,224 dòng** (vượt 145% so với Hard Cap 500 dòng).
2. `lib/features/tracker/presentation/pages/manual_entry_page.dart`: **969 dòng** (vượt 94% so với Hard Cap 500 dòng).

Đồng thời, nghiệp vụ các bữa ăn (`breakfast`, `lunch`, `dinner`, `snack`) đang phân mảnh dưới dạng **Magic Strings** ở 5 file khác nhau (`meal_section.dart`, `custom_food_sheet.dart`, `manual_entry_page.dart`, `home_page.dart`, `meal_detail_page.dart`). Mỗi file tự cài đặt một chuỗi `switch-case` lặp đi lặp lại để lấy icon, màu sắc, tỉ lệ calo và tên hiển thị.

---

## 2. Architectural Solution

### 2.1. Enhanced Enums O(1) (`lib/features/tracker/domain/models/meal_enums.dart`)

Thiết lập Enhanced Enums chuẩn Dart 3:
- **`enum MealType`**:
  - `label`: 'Bữa sáng', 'Bữa trưa', 'Bữa tối', 'Bữa phụ'
  - `icon`: IconData tương ứng (`wb_twilight_rounded`, `wb_sunny_rounded`, `nights_stay_rounded`, `cookie_outlined`)
  - `color`: `AppColors.tertiary`, `AppColors.primary`, `AppColors.secondary`, `AppColors.brandGreen`
  - `clayBgColor`: `AppColors.clayBreakfast`, `AppColors.clayLunch`, `AppColors.clayDinner`, `AppColors.claySnack`
  - `calorieRatio`: 0.25 (sáng/trưa/tối) / 0.15 (phụ)
  - `defaultHourRange`: Xác định tự động bữa ăn theo giờ trong ngày
  - `fromValue(String?)`: Parse an toàn từ chuỗi Firestore DTO.
- **`enum NutrientType`**:
  - `Carbs` (#1CB0F6, 4 kcal/g)
  - `Protein` (#FF9600, 4 kcal/g)
  - `Fat` (#FF5C8D, 9 kcal/g)

### 2.2. Decomposition Blueprint for `meal_section.dart` (1,224 dòng ➔ 4 sub-widgets)
1. `meal_card_header.dart` (~90 dòng): Hiển thị header bữa ăn, icon, tên, ngân sách calo và nút thêm món.
2. `meal_food_item_tile.dart` (~130 dòng): Item món ăn đơn lẻ hỗ trợ swipe dismiss để xóa món, hiển thị gram và calo.
3. `meal_macro_progress_bar.dart` (~80 dòng): Thanh tiến độ macro và calo của bữa ăn.
4. `meal_section.dart` (orchestrator): Rút gọn từ 1,224 dòng xuống **< 160 dòng**.

### 2.3. Decomposition Blueprint for `manual_entry_page.dart` (969 dòng ➔ 4 sub-widgets)
1. `manual_meal_selector.dart` (~100 dòng): Thanh chọn bữa ăn dùng trực tiếp `MealType.values`.
2. `manual_portion_stepper.dart` (~110 dòng): Thanh trượt và nút bấm điều chỉnh gram/khẩu phần nhanh.
3. `manual_nutrition_form.dart` (~140 dòng): Các trường nhập Calo, Carbs, Protein, Fat có validation.
4. `manual_entry_page.dart` (orchestrator): Rút gọn từ 969 dòng xuống **< 180 dòng**.

---

## 3. SLAs & Verification Commitments
- **Dung lượng file**: 100% các file mới sinh ra `< 200 dòng`.
- **Hiệu năng**: 60 FPS mượt mà khi cuộn `HomePage` và mở `ManualEntryPage`.
- **Độ tin cậy**: 100% test pass (299/299 tests), 0 lỗi `flutter analyze`.

---

## 4. Technical Feasibility Sign-Off (Gate 0)
- **Tech Lead**: AstroBite Pragmatic System Architect
- **Trạng thái**: 🟢 **APPROVED (Feasibility Verified)**
- **Chỉ dẫn Dev FE**: Sử dụng trực tiếp `MealType` enum properties, triệt tiêu toàn bộ switch-case so sánh string trong UI widgets.
