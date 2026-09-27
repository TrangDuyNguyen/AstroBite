# 📄 PRD: Core Daily Loop — Navigation & Food Tracker UI Overhaul (`FEAT-S13-TRACKER-NAV`)

- **Feature Code**: `FEAT-S13-TRACKER-NAV`
- **Epic**: `EPIC-UI-REFRESH` (Solar Fresh × Duolingo 2D/3D Claymorphic)
- **Sprint**: Sprint 13 (v2.2.0)
- **Author**: Sub-Agent Business Analyst (`business-analyst`) — *"The Pedantic Logician"*
- **Reviewer**: Sub-Agent Product Owner (`product-owner`) & Sub-Agent Tech Lead (`tech-lead`)
- **Status**: 🟡 **Gate 1 SUBMITTED FOR PO SIGN-OFF**
- **Target Screens**:
  1. `ShellScreen` & `ClayBottomNav` ([`lib/core/router/app_router.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/core/router/app_router.dart))
  2. `HomePage` ([`lib/features/tracker/presentation/pages/home_page.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/tracker/presentation/pages/home_page.dart))
  3. `ManualEntryPage` ([`lib/features/tracker/presentation/pages/manual_entry_page.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/tracker/presentation/pages/manual_entry_page.dart))
  4. `MealDetailPage` ([`lib/features/tracker/presentation/pages/meal_detail_page.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/tracker/presentation/pages/meal_detail_page.dart))

---

## 1. Bối Cảnh Nghiệp Vụ & Chỉ Số Đo Lường (Context & Measurable KPIs)

### 1.1 Bối Cảnh Nghiệp Vụ
Sau khi Sprint 12 hoàn tất việc thiết lập hệ thống token `AppColors` sáng và bộ thư viện dùng chung `lib/shared/ui_kit/`, bước đi chiến lược sống còn tiếp theo là nâng cấp **Core Daily Loop** — vòng lặp sử dụng hằng ngày gồm 4 màn hình có tần suất chạm cao nhất (4-6 lần/ngày/user). Nếu không nâng cấp đồng bộ 4 màn hình này, trải nghiệm thị giác của người dùng sẽ bị phân mảnh giữa giao diện tối cũ và giao diện sáng mới.

### 1.2 Mục Tiêu Đo Lường Cụ Thể (Measurable SLAs & Success Metrics)
| Chỉ Số Đo Lường | Hiện Tại (Baseline) | Mục Tiêu Sprint 13 | Phương Pháp Đo Lường |
|:---|:---:|:---:|:---|
| **Thời gian ghi chép món ăn (Time-to-Log)** | 3.5 giây | **< 3.2 giây** | Đồng hồ bấm giờ UX từ lúc chạm `+` đến khi lưu thành công |
| **Tỷ lệ tương phản chữ (WCAG AAA/AA)** | 4.8:1 | **> 12:1 cho Text chính, > 4.8:1 cho Text phụ** | Trình kiểm tra Contrast Ratio trên nền `#FAF8F5` và `#FFFFFF` |
| **Tốc độ khung hình (Frame Rate)** | 56 FPS | **≥ 60 FPS mượt mà** | Flutter Performance Overlay, 0 rớt khung hình (0 jank) |
| **Kích thước vùng bấm (Touch Target)** | 40x40pt | **≥ 44x44pt** | Bố cục chuẩn công thái học ngón tay cái (Thumb Zone) |
| **Độ phủ kiểm thử tự động (Test Pass Rate)** | 214/214 (100%) | **100% Pass** (bao gồm toàn bộ tests mới cho 4 màn hình) | `flutter test` |

---

## 2. Phạm Vi Thực Thi (In-Scope & Out-of-Scope)

### ✅ In-Scope (Bắt Buộc Thực Hiện)
1. **`ShellScreen`**: Chuyển đổi `CelestialBottomNav` sang `ClayBottomNav` ([`lib/shared/ui_kit/navigation/clay_bottom_nav.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/navigation/clay_bottom_nav.dart)), tích hợp nút chụp Camera FAB tròn 3D nhô cao với hiệu ứng đàn hồi tactile squash `0.95`.
2. **`HomePage`**: Tái cấu trúc khu vực Cockpit:
   - Thay thế vòng tròn calo cũ bằng `CalorieProgressArc` và 3 thanh `ChunkyMacroBar` (Carbs 🩵, Fat 🍓, Protein 🧡) trên thẻ `ClayCard` nền trắng tinh với bóng 2D bevel.
   - 4 thẻ bữa ăn (Sáng, Trưa, Tối, Phụ) sử dụng `ClayCard` kết hợp bộ màu pastel tint (`clayBreakfast`, `clayLunch`, `clayDinner`, `claySnack`).
   - Nút `+` ghi nhanh 1-tap tích hợp trực tiếp trên từng thẻ bữa ăn đạt kích thước tối thiểu 44x44pt.
3. **`ManualEntryPage`**: Tái thiết kế toàn diện với:
   - Ô tìm kiếm `ClaySearchBar` bo góc tròn 20pt.
   - Thẻ nhập số lượng và tên món sử dụng `ClayTextField`.
   - Bộ chọn phân loại bữa ăn bằng `ClayMealChip`.
   - Bộ tăng giảm khối lượng nhanh Quick Weight Steppers (+50g, -50g, 1 Bát, 1 Đĩa) dạng nút 3D.
   - Nút lưu nhật ký dạng 3D Duolingo `ClayButton.primary`.
4. **`MealDetailPage`**: Danh sách các món ăn trong bữa hiển thị trên các thẻ `ClayCard` độc lập, tích hợp mini `ChunkyMacroBar` và các nút xóa/sửa dạng `ClayIconButton`.

### ❌ Out-of-Scope (Tuyệt Đối Cấm Làm Phình Phạm Vi)
1. Không đụng đến logic nhận diện ảnh AI của Camera / Gemini Scanner (để dành riêng cho Sprint 14).
2. Không thay đổi backend schema, Firestore models, hoặc Riverpod state controllers (giữ nguyên Clean Architecture).
3. Không sửa các màn hình Profile, Auth, hoặc Recipes trong Sprint này.

---

## 3. Đặc Tả Chi Tiết User Stories & Acceptance Criteria (BDD)

### 📌 US-S13-01: Tactile Shell Navigation & Floating Camera FAB
> **Là một** người dùng AstroBite,  
> **Tôi muốn** thanh điều hướng dưới đáy ứng dụng có dạng dock nổi Claymorphic mềm mại với nút tròn chụp ảnh nhô cao 3D,  
> **Để** tôi có thể chuyển nhanh giữa 4 tab và mở camera quét thức ăn tiện lợi bằng ngón tay cái.

#### Scenario 1: Hiển thị thanh ClayBottomNav với 4 tab và Camera FAB
- **Given** người dùng đang ở bất kỳ tab nào trong `ShellScreen` (Home, Coach, Analytics, Profile),
- **When** màn hình hiển thị thanh điều hướng đáy,
- **Then** thanh điều hướng hiển thị dưới dạng dock nổi bo góc `24pt`, nền trắng `AppColors.surfaceContainer` với đổ bóng 2D bevel,
- **And** 4 icon tab có nhãn rõ ràng: "Home", "Coach", "Stats", "Profile",
- **And** ở vị trí trung tâm có nút tròn Camera FAB với màu xanh chủ đạo `AppColors.primary` (`#1CB0F6`), viền bóng 3D bevel 4pt.

#### Scenario 2: Phản hồi xúc giác (Tactile Squash) khi chạm nút và chuyển tab
- **Given** thanh điều hướng đang hiển thị,
- **When** người dùng bấm vào một tab khác hoặc bấm vào Camera FAB,
- **Then** nút bị nén nhẹ xuống tỉ lệ `0.95` scale trong `100ms`,
- **And** hệ thống phát tín hiệu phản hồi rung xúc giác nhẹ `HapticFeedback.lightImpact()`,
- **And** tab tương ứng được chọn ngay lập tức mà không giật lag.

---

### 📌 US-S13-02: Calorie & Macro Cockpit Dashboard (`HomePage`)
> **Là một** người dùng theo dõi calo hằng ngày,  
> **Tôi muốn** thẻ tổng quan đầu ngày hiển thị trực quan vòng năng lượng và 3 chất dinh dưỡng đa lượng Carbs, Fat, Protein với màu sắc chuẩn mực,  
> **Để** tôi nắm bắt ngay tình trạng năng lượng còn lại trong ngày dưới 1.5 giây.

#### Scenario 1: Hiển thị thẻ Cockpit chuẩn Claymorphic
- **Given** người dùng mở ứng dụng và vào `HomePage`,
- **When** dữ liệu nhật ký hôm nay được tải thành công,
- **Then** thẻ Cockpit trên cùng hiển thị dưới dạng `ClayCard` nền trắng bo góc `20pt`,
- **And** bên trái thẻ là widget `CalorieProgressArc` hiển thị Calo đã nạp / Mục tiêu và Calo còn lại,
- **And** bên phải là 3 thanh `ChunkyMacroBar` hiển thị độc lập:
  - Carbs có màu xanh dương `AppColors.primary` (`#1CB0F6`)
  - Fat có màu hồng kem dâu `AppColors.secondary` (`#FF5C8D`)
  - Protein có màu cam mật ong `AppColors.tertiary` (`#FF9600`)
- **And** thanh tiến độ có hoạt ảnh đàn hồi tween mượt mà khi giá trị thay đổi.

#### Scenario 2: Hiển thị 4 thẻ Bữa ăn với màu Clay Pastel và nút Thêm nhanh 1-tap
- **Given** người dùng cuộn xem lịch trình các bữa ăn trong `HomePage`,
- **When** danh sách 4 bữa ăn hiển thị,
- **Then** mỗi bữa ăn (Sáng, Trưa, Tối, Phụ) được bọc trong một `ClayCard` với tông màu nền pastel tương ứng (`clayBreakfast`, `clayLunch`, `clayDinner`, `claySnack`),
- **And** mỗi thẻ có nút tròn `+` thêm món nhanh kích thước chuẩn `≥ 44x44pt`,
- **When** người dùng chạm vào nút `+`,
- **Then** ứng dụng điều hướng ngay sang `ManualEntryRoute` với loại bữa ăn đã được chọn sẵn.

#### Scenario 3: Trạng thái Shimmer Loading ấm áp
- **Given** người dùng đang tải lại dữ liệu hoặc khởi động lại app,
- **When** provider đang ở trạng thái `AsyncLoading`,
- **Then** hiển thị khung xương `ClaySkeletonLoader` với dải shimmer màu kem ấm `#EFF1F5` (thay vì nền xám đen cũ),
- **And** không giật gián đoạn khung hình.

---

### 📌 US-S13-03: Ergonomic Manual Food Entry (`ManualEntryPage`)
> **Là một** người dùng ghi chép thức ăn thủ công,  
> **Tôi muốn** ô tìm kiếm mượt mà, bộ chọn loại bữa ăn dạng chip nổi và các nút tăng giảm gram nhanh bằng 1 chạm,  
> **Để** tôi ghi chép một món ăn xong trong vòng dưới 3.2 giây.

#### Scenario 1: Tìm kiếm món ăn với ClaySearchBar
- **Given** người dùng đang ở `ManualEntryPage`,
- **When** người dùng nhập từ khóa tìm kiếm vào `ClaySearchBar`,
- **Then** ô tìm kiếm hiển thị viền clay mềm mại bo góc `20pt`,
- **And** icon kính lúp hiển thị rõ ràng, có nút `x` xóa nhanh khi có ký tự,
- **And** danh sách gợi ý Recent Foods hiển thị ngay bên dưới dạng thẻ chip 1 chạm.

#### Scenario 2: Điều chỉnh khối lượng gram với Quick Weight Steppers
- **Given** người dùng đã chọn một món ăn,
- **When** màn hình hiển thị ô nhập gram,
- **Then** ô nhập sử dụng `ClayTextField` với nhãn đơn vị rõ ràng ("g"),
- **And** hiển thị hàng nút tăng giảm nhanh Quick Steppers: `-50g`, `+50g`, `1 Bát`, `1 Đĩa` dạng nút 3D,
- **When** chạm vào nút `+50g`,
- **Then** giá trị gram tự động cộng 50 và các giá trị Carbs, Fat, Protein tự tính toán cập nhật tức thời.

#### Scenario 3: Lưu món ăn thành công bằng ClayButton 3D
- **Given** người dùng đã nhập đầy đủ thông tin món ăn,
- **When** người dùng bấm nút "Lưu vào Nhật Ký" (`ClayButton.primary`),
- **Then** nút bị ấn lún 3D, hiển thị spinner nếu đang lưu,
- **And** hiển thị thông báo snackbar dạng card tròn nổi,
- **And** tự động quay trở về màn hình trước đó với dữ liệu đã được cập nhật.

---

### 📌 US-S13-04: Tactile Meal Detail & Item Management (`MealDetailPage`)
> **Là một** người dùng muốn xem lại hoặc điều chỉnh các món đã ăn trong một bữa cụ thể,  
> **Tôi muốn** danh sách món ăn hiển thị mạch lạc từng thẻ card và có nút điều chỉnh gram hoặc xóa nhanh,  
> **Để** tôi quản lý khẩu phần ăn chính xác mà không tốn công nhập lại từ đầu.

#### Scenario 1: Danh sách món ăn trong bữa
- **Given** người dùng chọn xem chi tiết bữa Trưa (Lunch),
- **When** `MealDetailPage` mở ra,
- **Then** tiêu đề hiển thị tên bữa ăn kèm chip tổng calo bữa ăn,
- **And** từng món ăn được hiển thị trong thẻ `ClayCard` độc lập,
- **And** mỗi món hiển thị tên món, số gram, calo và 3 chỉ số micro Carbs/Fat/Protein.

#### Scenario 2: Xóa món ăn khỏi bữa ăn
- **Given** một món ăn trong danh sách,
- **When** người dùng bấm nút xóa `ClayIconButton` (icon thùng rác đỏ nhạt),
- **Then** hiển thị hộp thoại xác nhận dạng `ClayCard` tròn nổi,
- **When** xác nhận xóa,
- **Then** món ăn biến mất với hiệu ứng fade-out mượt mà và tổng calo của bữa ăn tự động giảm trừ ngay lập tức.

---

## 4. Đặc Tả 5 Trạng Thái Giao Diện Bắt Buộc (The 5 Mandatory UI States)

| Màn Hình | 1. Default (Dữ liệu đầy đủ) | 2. Loading (Đang tải) | 3. Empty (Chưa có dữ liệu) | 4. Error (Có lỗi phát sinh) | 5. Offline (Mất kết nối mạng) |
|:---|:---|:---|:---|:---|:---|
| **`ShellScreen`** | Dock nổi với 4 tab & Camera FAB sáng rõ | Giữ nguyên dock đáy | N/A | N/A | Icon đám mây gạch chéo nhỏ góc trên |
| **`HomePage`** | Cockpit Calo & 3 Macro + 4 thẻ bữa ăn | Khung xương `ClaySkeletonLoader` nền `#EFF1F5` | Thẻ hướng dẫn thân thiện: "Chưa có món nào hôm nay, hãy bấm + để thêm món!" | Thẻ báo lỗi dạng `ClayCard` đỏ kem với nút "Thử Lại" 3D | Banner Claymorphic màu vàng kem: "Đang ở chế độ offline — Dữ liệu đã lưu tạm cục bộ" |
| **`ManualEntryPage`** | Form tìm kiếm, Recent foods, Quick Steppers, nút Lưu | Shimmer ô nhập liệu | Thông báo: "Không tìm thấy món ăn phù hợp. Bấm để tạo món mới" | Báo lỗi trường nhập liệu dưới chân ô input bằng màu đỏ tương phản cao | Vẫn cho phép tìm kiếm trong danh mục offline và ghi vào bộ nhớ tạm |
| **`MealDetailPage`** | Danh sách món ăn trong bữa | Shimmer 3 card món ăn | Thẻ thông báo: "Bữa ăn này chưa có món nào" kèm nút thêm món | Thông báo lỗi không thể đồng bộ với Firestore | Cho phép xóa/sửa trên bộ nhớ đệm offline |

---

## 5. Bảng Đối Soát Tính Khả Thi Kỹ Thuật (Tech Lead Sign-Off Checklist)

- [x] **0 Package Mới**: 100% components tái sử dụng từ `lib/shared/ui_kit/ui_kit.dart`.
- [x] **SLAs Hiệu Năng**: Đảm bảo 60 FPS, không dùng shader `BackdropFilter` phức tạp lặp lại trong danh sách cuộn.
- [x] **Nutrient Colors**: Tuyệt đối tuân thủ Carbs `AppColors.primary`, Fat `AppColors.secondary`, Protein `AppColors.tertiary`, Vitality `AppColors.brandGreen`.
- [x] **Clean Architecture**: 100% tầng Domain & Data giữ nguyên vẹn.

---

## 6. Biên Bản Bàn Giao Cổng Gate 1

- **Người lập**: Sub-Agent Business Analyst (`business-analyst`)
- **Tình trạng**: Đã hoàn thiện 100% PRD & 4 User Stories BDD có tiêu chí nghiệm thu rõ ràng.
- **Yêu cầu**: Trình Sub-Agent **`product-owner`** thẩm định tiêu chuẩn Zero-Tolerance và ký duyệt Gate 1 để chuyển giao sang **`ui-ux-designer`** (Gate 2).
