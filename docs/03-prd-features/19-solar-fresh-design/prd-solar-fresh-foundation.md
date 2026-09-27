# 📄 PRD: Solar Fresh Foundation Reset (`FEAT-SOLAR-01`)

- **Feature Code**: `FEAT-SOLAR-01`
- **Epic**: `EPIC-UI-REFRESH`
- **Sprint**: Sprint 12
- **Author**: Sub-Agent Business Analyst (`business-analyst`)
- **Reviewer**: Sub-Agent Product Owner (`product-owner`) & Sub-Agent Tech Lead (`tech-lead`)
- **Status**: ✅ **Gate 1 SIGNED-OFF**

---

## 1. Mục Tiêu Nghiệp Vụ (Business Objectives)

1. **Cải thiện thẩm mỹ & Cảm xúc người dùng**:
   - Chuyển đổi toàn diện trải nghiệm hình ảnh từ tối tăm (Celestial Dark) sang tươi sáng, ấm áp, kích thích cảm giác ngon miệng và năng lượng tích cực (Solar Fresh).
   - Lấy cảm hứng từ ngôn ngữ thiết kế 2D hoạt hình, tinh nghịch, chunky của Duolingo.
2. **Khả năng tiếp cận & Độ tương phản (WCAG AA)**:
   - Đảm bảo tỷ lệ tương phản chữ chính trên nền đạt chuẩn tối thiểu 4.5:1 (thực tế đạt > 10:1).
   - Màu protein chuyển từ vàng sáng (`#FFD700` dễ chìm trên nền trắng) sang Honey Orange (`#FF9600`), bảo toàn khả năng nhận diện dinh dưỡng.

---

## 2. User Stories & Acceptance Criteria (BDD Format)

### US-S12-01: Light Color Token System
> **Là một** người dùng AstroBite,  
> **Tôi muốn** giao diện app hiển thị với tông nền sáng ấm áp và các mảng màu rực rỡ,  
> **Để** việc ghi chép món ăn và theo dõi dinh dưỡng trở nên vui tươi, nhẹ nhàng, không u ám.

- **Scenario 1: Hiển thị nền và chữ chuẩn tương phản cao**
  - **Given** người dùng mở ứng dụng AstroBite ở phiên bản v2.1.0,
  - **When** màn hình tải xong,
  - **Then** màu nền chính (`AppColors.surface`) phải là màu sáng `#F7F8FA`,
  - **And** màu chữ tiêu đề chính (`AppColors.onSurface`) phải là màu `#1A1A2E`,
  - **And** màu chữ phụ (`AppColors.onSurfaceVariant`) phải là màu xám dịu `#6B7280`,
  - **And** tỷ lệ tương phản đạt chuẩn WCAG AA ≥ 4.5:1.

- **Scenario 2: Bảo tồn ngữ nghĩa 3 màu dinh dưỡng (Nutrient Semantics)**
  - **Given** thanh tiến độ và chỉ số dinh dưỡng hiển thị,
  - **When** người dùng quan sát Carbs, Fat và Protein,
  - **Then** Carbs giữ màu xanh dương năng động (`#1A73E8`),
  - **And** Fat giữ màu hồng sinh động (`#FF69B4`),
  - **And** Protein hiển thị màu Honey Orange (`#FF9600`) rõ nét trên nền sáng.

---

### US-S12-02: SolarCard 2D Chunky Component
> **Là một** người dùng,  
> **Tôi muốn** các khối thông tin (thẻ món ăn, bảng thống kê) hiển thị như những tấm thẻ 2D bo tròn có hiệu ứng đổ bóng nổi khối (chunky bevel),  
> **Để** dễ dàng phân biệt các khối nội dung và có cảm giác tương tác chân thật.

- **Scenario 1: Render SolarCard chuẩn thiết kế 2D**
  - **Given** một widget được bọc bởi `SolarCard`,
  - **When** widget render trên màn hình,
  - **Then** thẻ có nền trắng tinh (`#FFFFFF`),
  - **And** bo góc 16pt,
  - **And** có viền 2D mỏng mềm mại (`#E5E7EB` hoặc clay shadow),
  - **And** đổ bóng bên dưới tạo chiều sâu tactile 2D (offset Y 3-4pt).

- **Scenario 2: Tương thích ngược với GlassCard hiện hữu**
  - **Given** các màn hình cũ còn sử dụng `GlassCard`,
  - **When** hiển thị trong Light Theme,
  - **Then** không bị nền đen xỉn hay chữ tối khó đọc,
  - **And** các thành phần bên trong hiển thị rõ ràng trên nền sáng.

---

### US-S12-03: Chunky MacroBar
> **Là một** người dùng,  
> **Tôi muốn** thanh tiến độ macro dinh dưỡng dày dặn hơn và có hoạt ảnh mượt mà khi nạp calo,  
> **Để** tạo cảm giác như thanh năng lượng trong game hoạt hình.

- **Scenario 1: Thanh tiến độ dày 12pt và bo tròn mềm mại**
  - **Given** người dùng xem thanh macro,
  - **When** MacroBar render,
  - **Then** chiều cao thanh tiến độ tăng từ 8pt lên 12pt,
  - **And** bo góc thanh là 6pt,
  - **And** có gradient bóng nhẹ (glossy) tạo cảm giác hoạt hình 2D sống động.

---

### US-S12-04: Light MealTypeChip & Shimmer Skeleton
> **Là một** người dùng,  
> **Tôi muốn** các chip chọn bữa ăn (Sáng, Trưa, Tối, Snack) và trạng thái loading hiển thị phong cách tươi sáng,  
> **Để** đồng bộ toàn diện với trải nghiệm Solar Fresh.

- **Scenario 1: MealTypeChip trạng thái chọn và không chọn**
  - **Given** danh sách chọn bữa ăn,
  - **When** chip chưa được chọn,
  - **Then** nền chip là `#EFF1F5` với viền xám nhẹ,
  - **When** chip được chọn,
  - **Then** nền chuyển sang màu primary dịu và viền primary sắc nét.

- **Scenario 2: Skeleton Loader màu kem ấm**
  - **Given** ứng dụng đang trong trạng thái loading,
  - **When** `SkeletonLoader` xuất hiện,
  - **Then** màu nền placeholder là `#EFF1F5` (warm cream) thay cho nền tối cũ `#112240`.

---

## 3. Non-Functional Requirements (NFRs)

1. **Hiệu năng**:
   - 60 FPS mượt mà trên cả iOS và Android.
   - Thời gian render card ≤ 16ms.
2. **Khả năng tương thích**:
   - 100% tests hiện tại (200 tests) phải pass không lỗi.
   - `flutter analyze` 0 warnings, 0 errors.
3. **Kích thước app (APK size)**:
   - Delta kích thước APK sau Sprint 12 ≤ +0.5MB (không bổ sung thư viện nặng).
