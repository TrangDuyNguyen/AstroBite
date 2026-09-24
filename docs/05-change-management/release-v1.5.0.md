# Release Notes — AstroBite v1.5.0

> **Phiên bản**: `v1.5.0`  
> **Tên mã**: Glanceable Celestial Core & 1-Tap Quick Log  
> **Sprint**: Sprint 06 (22/09/2026 – 06/10/2026)  
> **Ngày phát hành**: 24/09/2026  
> **Sub-Agent phê duyệt phát hành**: Product Owner (PO - The Strategic Tyrant) & Project Manager (PM - The Clockwork Disciplinarian)  
> **Trạng thái**: 🟢 **RELEASED**

---

## 🌟 Tóm Tắt Phát Hành (Release Summary)

AstroBite v1.5.0 là bước chuyển mình quan trọng về **trải nghiệm công thái học (Ergonomics)** và **tốc độ nhận biết thông tin (Glanceability)** trên màn hình trang chủ "Tổng quan hôm nay" (HomePage). Áp dụng triệt để triết lý **Ponytail**, bản phát hành loại bỏ sự phân mảnh dữ liệu cũ, nén gọn toàn bộ bức tranh dinh dưỡng cốt lõi và rút ngắn thời gian hiểu số liệu xuống dưới 1.5 giây:

| # | Feature / Epic | Mô Tả Giá Trị Kinh Doanh & Trải Nghiệm |
| :---: | :--- | :--- |
| 🚀 | **Glanceable Celestial Cockpit (`EPIC-15` / `FEAT-13`)** | Hợp nhất Vòng cung Calo còn lại (bên trái) và 3 Thanh tiến độ Macro thẳng hàng (bên phải) trên cùng 1 khối thẻ kính mờ `CelestialCockpitCard`. Tiết kiệm > 50% diện tích màn hình theo chiều dọc (~210pt thay vì 450pt). |
| 🔬 | **Collapsible Micronutrients Pill** | Tinh gọn dải theo dõi vi chất (Natri, Xơ, Đường) thành một thanh capsule dạng thu gọn 1 dòng. Chạm mở rộng mượt mà khi người dùng cần xem chi tiết, tránh choáng ngợp thị giác. |
| ⚡ | **Ergonomic Meal Timeline & 1-Tap Quick Log (`EPIC-UI-CORE`)** | Tối ưu 4 thẻ bữa ăn (Sáng, Trưa, Tối, Phụ). Nút `+` Quick Add đáp ứng chuẩn `touchTarget >= 44pt`, tự động điều hướng sang `ManualEntryPage` với loại bữa ăn tương ứng được chọn sẵn. |
| ✨ | **Tinh Gọn AstroCoach Contextual Chip** | Thay thế banner trợ lý ảo cồng kềnh 120pt bằng một chip gợi ý ngữ cảnh 1 dòng duy nhất bên dưới danh sách bữa ăn, giảm ma sát và tăng không gian hiển thị nhật ký. |
| 🌌 | **Celestial Bottom Nav & Time Avatar** | Cập nhật thanh điều hướng 5 slot với nút Scan FAB nổi bật và Avatar thời gian động (`CelestialTimeAvatar`) đồng bộ phong cách nhận diện thiên hà Celestial Dark UI. |

---

## ✨ Chi Tiết Kỹ Thuật (Feature Architecture)

### 🚀 1. EPIC-15: Glanceable Celestial Cockpit
- **Presentation Component**: `CelestialCockpitCard` kế thừa `GlassCard` (nền `#112240`, viền `0x1FFFFFFF`).
- **Parallel Nutrition Layout**: 
  - Vòng Calo Progress Arc đường kính 130pt hiển thị con số kcal còn lại to bản, tự động chuyển màu Tertiary Gold (`#FFD700`) khi vượt ngân sách (`+X kcal over budget`).
  - 3 thanh `MacroBar` thẳng hàng chuẩn màu dinh dưỡng bất biến: Carbs `#1A73E8`, Protein `#FFD700`, Fat `#FF69B4`.
- **Collapsible Drawer**: Toggle mở rộng dải vi chất (Natri, Xơ, Đường) bằng cờ trạng thái boolean đơn giản, triệt tiêu `AnimatedCrossFade` cồng kềnh nhằm tối ưu hóa bộ nhớ và tốc độ render 60 FPS.
- **Backward Compatibility**: `DailySummaryCard` được chuyển đổi thành adapter gọn nhẹ 15 dòng, đảm bảo toàn bộ mã nguồn cũ vẫn hoạt động trơn tru.

### ⚡ 2. EPIC-UI-CORE: Ergonomic Meal Timeline & Quick Log
- **Ergonomic Touch Targets**: Nâng cấp `MealSection` với nút bấm thêm nhanh `+` và nút xóa món ăn tuân thủ kích thước công thái học tối thiểu 44×44pt.
- **Deep-linked Meal Type Routing**: Màn hình `ManualEntryPage` nhận tham số `mealType` từ query string thông qua AutoRoute, tự động gán bữa ăn tương ứng mà không bắt người dùng chọn lại thủ công.
- **Delete Confirmation Flow**: Bổ sung popup xác nhận xóa món an toàn, bảo vệ dữ liệu nhật ký của người dùng khỏi các thao tác chạm nhầm.

---

## 📊 Thống Kê Nghiệm Thu Kỹ Thuật (Technical Stats)

| Chỉ Số Đảm Bảo Chất Lượng | Kết Quả Thực Tế | Tiêu Chuẩn Cam Kết | Đánh Giá |
| :--- | :---: | :---: | :---: |
| **Tổng số Automated Tests** | **148 / 148 Passed** | 100% Pass | 🟢 ĐẠT |
| **Lỗi & Cảnh báo Linter (`flutter analyze`)** | **0 errors, 0 warnings** | 0 issues | 🟢 ĐẠT |
| **Tốc độ đọc số liệu Calo/Macro (TTU)** | **< 1.5 giây** | < 2.0s | 🟢 VƯỢT TRỘI |
| **Tiết kiệm không gian chiều dọc (Vertical Space)** | **Tiết kiệm > 50%** | > 40% | 🟢 VƯỢT TRỘI |
| **Hiệu năng cuộn (Scroll Performance)** | **60 FPS mượt mà** | >= 55 FPS | 🟢 ĐẠT |
| **Rò rỉ bộ nhớ (Memory Leaks)** | **0 leak** | 0 leak | 🟢 ĐẠT |
| **Công thái học (Ergonomics)** | `touchTarget >= 44pt` | >= 44x44pt | 🟢 TUÂN THỦ |
| **Màu dinh dưỡng bất biến** | Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700` | Bất biến theo `DESIGN.md` | 🟢 TUÂN THỦ |

---

## 🚦 Kiểm Soát Chất Lượng 7 Cổng (7-Gate SOP Verification)

1. ✅ **Gate 0 (Tech Lead)**: Thẩm định kiến trúc nén bố cục song song, đánh giá độ trễ và khả năng tương thích ngược.
2. ✅ **Gate 1 (BA)**: Hoàn tất PRD [`prd-glanceable-home-cockpit.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/13-glanceable-home-cockpit/prd-glanceable-home-cockpit.md) chuẩn BDD Given-When-Then.
3. ✅ **Gate 2 (UI/UX Designer)**: Bản thiết kế Google Stitch (Screen ID `db13f5531baf4aeab67ab09be0b5bafa`) và 5 trạng thái giao diện trong [`ui-ux-design-spec.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/13-glanceable-home-cockpit/ui-ux-design-spec.md).
4. ✅ **Gate 3 (QA Test Design)**: Bộ kiểm thử widget tests [`celestial_cockpit_card_test.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/test/features/tracker/presentation/celestial_cockpit_card_test.dart).
5. ✅ **Gate 4 (Dev FE)**: Triển khai Clean Architecture, Riverpod Notifier, tối ưu `HomePage` và `MealSection`.
6. ✅ **Gate 5 (Reviewer)**: Rà soát tinh gọn Ponytail ([`gate-5-ponytail-review.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/13-glanceable-home-cockpit/gate-5-ponytail-review.md)) — Xóa 40+ dòng code thừa, phán quyết: *"Lean already. Ship."*.
7. ✅ **Gate 6 (QA Verification)**: Nghiệm thu tự động 148/148 tests pass ([`signoff-glanceable-home-cockpit.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/13-glanceable-home-cockpit/signoff-glanceable-home-cockpit.md)).
8. ✅ **Gate 7 (Release Gate)**: PO & PM chính thức ký duyệt phát hành `v1.5.0`.
