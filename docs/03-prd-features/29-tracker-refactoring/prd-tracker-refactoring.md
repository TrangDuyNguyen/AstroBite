# PRD: Core Tracker Clean Architecture & O(1) Meal Enums Overhaul

- **Mã Epic / Feature**: `EPIC-REF-01` / `FEAT-S22-TRACKER`
- **Tác giả**: Sub-Agent Business Analyst (BA)
- **Ký duyệt Gate 1**: Sub-Agent Product Owner (PO) & Sub-Agent Tech Lead
- **Phiên bản**: v3.2.0 (Sprint 22)
- **Trạng thái**: 🟢 **Gate 1 Approved**

---

## 1. Bối Cảnh & Vấn Đề Nghiệp Vụ (Context & Problem Statement)

Phân hệ **Tracker (Nhật ký ăn uống)** là tính năng người dùng tương tác hàng ngày nhiều nhất trên AstroBite. Tuy nhiên, sau các đợt phát triển tính năng dồn dập (v1.0 đến v3.1), hai thành phần trung tâm đang bị phình to nghiêm trọng:
1. `meal_section.dart` (1,224 dòng): Quản lý 4 bữa ăn kèm hiển thị danh sách món, thanh macro bar, nút thêm nhanh và popup bottom sheet.
2. `manual_entry_page.dart` (969 dòng): Form nhập món ăn thủ công gồm bộ chọn bữa ăn, bàn phím ảo, stepper lượng gram, tính toán calo và dinh dưỡng vi lượng.

Cả hai file đều vi phạm giới hạn cứng **Hard Cap (> 500 dòng)** của dự án, đồng thời sử dụng các chuỗi thô (Magic Strings `'breakfast'`, `'lunch'`, `'dinner'`, `'snack'`) rải rác dẫn đến mã nguồn bị trùng lặp nhiều chuỗi switch-case và khó mở rộng.

---

## 2. Mục Tiêu Sản Phẩm (Product Objectives & KPIs)

1. **Chuẩn hóa Kiểu Dữ Liệu Bữa Ăn (Type Safety & O(1) Access)**:
   - Thay thế toàn bộ chuỗi Magic Strings bằng Dart 3 Enhanced Enum `MealType`.
   - Thuộc tính màu sắc, icon, tên hiển thị và tỉ lệ phân bổ calo được truy xuất $O(1)$.
2. **Bóc Tách Thành Phần (Modular Decomposition)**:
   - Bóc tách `meal_section.dart` từ 1,224 dòng xuống `< 160 dòng`.
   - Bóc tách `manual_entry_page.dart` từ 969 dòng xuống `< 180 dòng`.
   - Mỗi sub-widget mới sinh ra có kích thước `< 200 dòng` và tuân thủ nguyên tắc Single Responsibility.
3. **Bảo Toàn Trải Nghiệm & SLAs**:
   - 100% chức năng thêm/sửa/xóa món ăn, vuốt xóa món, tính calo hoạt động không đổi.
   - Duy trì tốc độ cuộn danh sách 60 FPS mượt mà.
   - 0 regression bug, 100% test pass.

---

## 3. Quy Chuẩn Dữ Liệu Bữa Ăn (Data Dictionary & Meal Enums)

| Enum Case | Giá Trị Lưu Trữ (`value`) | Tên Tiếng Việt (`label`) | Icon | Màu Chủ Đạo (`color`) | Nền Claymorphic (`clayBgColor`) | Tỉ Lệ Calo Mặc Định | Khung Giờ Mặc Định |
| :--- | :--- | :--- | :--- | :--- | :--- | :---: | :---: |
| `MealType.breakfast` | `'breakfast'` | Bữa sáng | `Icons.wb_twilight_rounded` | `AppColors.tertiary` (#FF9600) | `AppColors.clayBreakfast` (#FFF2D6) | 25% | 05:00 – 10:59 |
| `MealType.lunch` | `'lunch'` | Bữa trưa | `Icons.wb_sunny_rounded` | `AppColors.primary` (#1CB0F6) | `AppColors.clayLunch` (#E5F6FD) | 35% | 11:00 – 15:59 |
| `MealType.dinner` | `'dinner'` | Bữa tối | `Icons.nights_stay_rounded` | `AppColors.secondary` (#FF5C8D) | `AppColors.clayDinner` (#F0E8FF) | 30% | 16:00 – 21:59 |
| `MealType.snack` | `'snack'` | Bữa phụ | `Icons.cookie_outlined` | `AppColors.brandGreen` (#58CC02) | `AppColors.claySnack` (#FFE8EE) | 10% | 22:00 – 04:59 |

---

## 4. Phê Duyệt Gate 1 (Sign-Off)
- **BA Lead**: Sub-Agent Business Analyst — *Signed*
- **PO**: Sub-Agent Product Owner — *Approved*
- **Tech Lead**: Sub-Agent Tech Lead & System Architect — *Approved (Feasibility Verified)*
