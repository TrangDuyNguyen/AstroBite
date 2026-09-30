# 📄 PRD: High-Value AI Experience — Camera Scanner & GenUI AI Coach UI Overhaul (`FEAT-S14-AI-EXPERIENCE`)

- **Feature Code**: `FEAT-S14-AI-EXPERIENCE`
- **Epic**: `EPIC-UI-REFRESH` (Solar Fresh × Duolingo 2D/3D Claymorphic)
- **Sprint**: Sprint 14 (`v2.3.0`)
- **Author**: Sub-Agent Business Analyst (`business-analyst`) — *"The Pedantic Logician"*
- **Reviewer**: Sub-Agent Product Owner (`product-owner`) & Sub-Agent Tech Lead (`tech-lead`)
- **Status**: 🟡 **Gate 1 SUBMITTED FOR PO SIGN-OFF**
- **Target Screens & Widgets**:
  1. `CameraPage`: Viewfinder & Chunky Shutter ([`lib/features/scanner/presentation/pages/camera_page.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/scanner/presentation/pages/camera_page.dart))
  2. `ScanReviewPage`: ClaySheet & Multi-dish Review ([`lib/features/scanner/presentation/pages/scan_review_page.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/scanner/presentation/pages/scan_review_page.dart))
  3. `CoachPage`: Chat Cockpit & Stream ([`lib/features/coach/presentation/pages/coach_page.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/coach/presentation/pages/coach_page.dart))
  4. GenUI Widgets: [`meal_quick_log_card.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/coach/presentation/widgets/meal_quick_log_card.dart), [`macro_budget_gauge.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/coach/presentation/widgets/macro_budget_gauge.dart), [`quick_choice_chips.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/features/coach/presentation/widgets/quick_choice_chips.dart)

---

## 1. Bối Cảnh Nghiệp Vụ & Chỉ Số Đo Lường (Context & Measurable KPIs)

### 1.1 Bối Cảnh Nghiệp Vụ
Sau khi Sprint 13 hoàn thành xuất sắc việc đưa Core Daily Loop (Shell, Home, Manual Entry, Meal Detail) lên chuẩn giao diện Claymorphic sáng dịu (`#FAF8F5`), sự phân mảnh thị giác xuất hiện rõ rệt nhất khi người dùng bước vào 2 tính năng "Hero Features" của AstroBite: **Camera Scanner** và **AstroCoach AI Chat**. Hai màn hình này vẫn đang dùng phong cách kính tối (`GlassCard`, dark-only backgrounds), gây cảm giác đứt gãy trải nghiệm. 

Sprint 14 sẽ giải quyết triệt để sự đứt gãy này bằng cách chuyển đổi toàn bộ giao diện Camera Viewfinder, trang duyệt món sau scan (Scan Review Sheet), và buồng lái hội thoại AI Coach (bao gồm 3 widgets sinh tự động GenUI A2UI) sang chuẩn **Claymorphic × Duolingo 2D/3D**, mang lại trải nghiệm chạm-nảy sống động và trực quan nhất.

### 1.2 Mục Tiêu Đo Lường Cụ Thể (Measurable SLAs & Success Metrics)

| Chỉ Số Đo Lường | Hiện Tại (Baseline) | Mục Tiêu Sprint 14 | Phương Pháp Đo Lường |
|:---|:---:|:---:|:---|
| **Scan-to-Log Completion Rate** | 78% | **≥ 92%** | Tỷ lệ phiên scan kết thúc bằng hành động lưu món ăn vào nhật ký |
| **Thời gian duyệt món (Time-to-Review)** | 2.6 giây | **< 1.5 giây** | Thời gian từ khi mở `ScanReviewPage` đến khi bấm lưu |
| **Độ trễ tương tác 1-Tap Log trong Coach** | 350ms | **< 150ms** | Thời gian từ lúc chạm nút trên `MealQuickLogCard` đến khi cập nhật state |
| **Tốc độ khung hình (Frame Rate)** | 55 FPS | **≥ 60 FPS** | Đo bằng Flutter Performance Overlay khi camera chạy và cuộn chat |
| **Vùng chạm công thái học (Touch Target)** | 40x40pt | **≥ 44x44pt** | Chuẩn công thái học ngón cái cho mọi nút bấm (Shutter, Action buttons) |
| **Tỷ lệ tương phản chữ (WCAG AAA/AA)** | 4.5:1 | **> 12:1 (Text chính), > 4.8:1 (Text phụ)** | Đo đạc trên nền Warm Milk `#FAF8F5` và Pure White `#FFFFFF` |
| **Rò rỉ bộ nhớ (Memory Leak)** | Nguy cơ rò rỉ Camera | **0 Memory Leak** | Đo bằng DevTools Memory Inspector qua vòng đời dispose camera |
| **Độ phủ kiểm thử tự động (Test Pass Rate)** | 216/216 (100%) | **100% Pass** | Toàn bộ unit/widget tests hiện có và viết mới phải pass |

---

## 2. Phạm Vi Thực Thi (In-Scope & Out-of-Scope)

### ✅ In-Scope (Bắt Buộc Thực Hiện Theo Chuẩn Ponytail)
1. **`CameraPage` (Viewfinder & Controls)**:
   - Thay thế các nút điều khiển tối mờ bằng cụm điều khiển Claymorphic: Nút Shutter tròn 3D nhô cao với hiệu ứng đàn hồi `0.92` squash on press.
   - Nút bật/tắt Flash và nút chọn ảnh từ Thư viện (Gallery) dạng `ClayIconButton` nổi rõ ràng, kích thước $\ge 48\times 48\text{pt}$.
   - Khung ngắm Viewfinder bo góc mềm mại $24\text{pt}$ với viền nét đứt hoặc bo góc thân thiện, duy trì trải nghiệm tập trung vào đĩa thức ăn.
2. **`ScanReviewPage` (Review & Save Sheet)**:
   - Chuyển đổi toàn bộ trang từ nền tối sang nền Warm Milk `#FAF8F5`.
   - Danh sách món nhận diện (`DishItem`) hiển thị trên các thẻ `ClayCard` nền trắng tinh `#FFFFFF` bo góc $20\text{pt}$, có nút tăng giảm gram nhanh dạng nút 3D.
   - Bộ chọn bữa ăn dùng `ClayMealChip` chuẩn Sprint 12/13.
   - Thước đo dinh dưỡng đa lượng tích hợp `ChunkyMacroBar` hiển thị 3 màu bất biến: Carbs 🩵 `#1CB0F6`, Fat 🍓 `#FF5C8D`, Protein 🧡 `#FF9600`.
   - Nút bấm chính "Lưu vào nhật ký" dạng `ClayButton.primary` 3D lớn chiếm trọn Thumb Zone.
3. **`CoachPage` (AI Nutrition Cockpit)**:
   - Nền trang Warm Milk `#FAF8F5`, danh sách tin nhắn cuộn mượt mà với 60 FPS.
   - Bong bóng chat người dùng dạng `ClayCard` pastel xanh hoặc primary tint bo góc $20\text{pt}$. Bong bóng chat của AI dạng `ClayCard` trắng tinh viền bóng bevel 2D.
   - Khung nhập tin nhắn tích hợp `ClayTextField` bo tròn và nút gửi dạng `ClayIconButton` 3D.
4. **GenUI A2UI Widgets Transformation**:
   - `MealQuickLogCard`: Bọc trong `ClayCard`, hiển thị tên món, calo to bản, 3 viên thuốc macro mini, và nút "Ghi ngay" 1-tap dạng `ClayButton` màu xanh lá `AppColors.brandGreen` (`#58CC02`) với hiệu ứng squash $0.95$.
   - `MacroBudgetGauge`: Bọc trong `ClayCard`, hiển thị thanh tiến độ calo dự kiến và calo còn lại với màu sắc chuẩn mực.
   - `QuickChoiceChips`: Các chip gợi ý hành động dạng pill nảy 3D, bấm vào lập tức điền câu hỏi hoặc gửi ngay vào chat.

### ❌ Out-of-Scope (Kiên Quyết Cấm Phạm Vi Phình To)
1. **CẤM** thay đổi logic nhận diện AI Gemini trong `scanner_repository.dart` và `coach_repository.dart`.
2. **CẤM** thêm các tính năng nhận diện giọng nói (Voice AI) hoặc phân tích video trực tiếp.
3. **CẤM** can thiệp vào cấu trúc Firestore hay thay đổi schema DTO.
4. **CẤM** sửa đổi các màn hình không thuộc phạm vi Sprint 14 (Profile, Analytics, Recipes).

---

## 3. Đặc Tả Chi Tiết 5 Trạng Thái Giao Diện Bắt Buộc (5 Mandatory UI States)

Theo chính sách của Sub-Agent UI/UX và PO, mọi màn hình trong Sprint 14 đều phải định nghĩa rõ 5 trạng thái:

| Màn Hình | 1. Default (Bình Thường) | 2. Loading / Shimmer | 3. Empty (Rỗng) | 4. Error (Lỗi) | 5. Offline (Mất Mạng) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`CameraPage`** | Camera stream mượt mà, viewfinder sắc nét, nút Shutter 3D sẵn sàng. | Vòng quay radar quét AI mượt mà trên ảnh đóng băng tĩnh. | Không áp dụng (luôn có live stream camera). | Thông báo lỗi không mở được camera / quyền bị từ chối kèm nút mở Cài đặt. | Chụp ảnh vẫn hoạt động, lưu ảnh vào cache chờ mạng. |
| **`ScanReviewPage`** | Danh sách món trên các thẻ `ClayCard`, macro bar đầy đủ, nút Lưu sẵn sàng. | Shimmer skeleton `ClaySkeletonLoader` mô phỏng danh sách món ăn đang phân tích. | Màn hình "Không tìm thấy món nào" kèm nút "Chụp lại" hoặc "Nhập thủ công". | Thông báo lỗi nhận diện AI kèm gợi ý chụp rõ nét hơn. | Cho phép lưu vào hàng đợi Offline, đồng bộ khi có mạng. |
| **`CoachPage`** | Lịch sử chat và các thẻ GenUI hiển thị sắc nét trên nền Warm Milk. | Bong bóng chat AI dạng `ClaySkeletonLoader` 3 chấm nảy nhịp nhàng. | Màn hình chào với gợi ý câu hỏi ban đầu dạng `QuickChoiceChips`. | Bong bóng lỗi viền đỏ nhạt kèm nút "Thử lại" (Retry). | Banner offline nhẹ cảnh báo AI chỉ trả lời khi có kết nối mạng. |

---

## 4. Bảng Phân Rã Yêu Cầu Chức Năng (Functional Requirements)

- **`FR-S14-01`**: Cụm điều khiển Camera phải đạt touch target tối thiểu 48x48pt, nút Shutter có hiệu ứng nén đàn hồi tactile squash $0.92$ và haptic feedback.
- **`FR-S14-02`**: Trang Scan Review phải hiển thị danh sách món phân tích từ ảnh, cho phép điều chỉnh gram từng món trực tiếp hoặc xóa món ăn.
- **`FR-S14-03`**: Tổng calo và macro của toàn bữa ăn trong Scan Review phải tự động tính toán lại khi người dùng thay đổi gram của từng món.
- **`FR-S14-04`**: Bong bóng chat của Coach AI phải hỗ trợ render đầy đủ cú pháp Markdown và parse chính xác block ````a2ui```` để nhúng động các widget `MealQuickLogCard`, `MacroBudgetGauge`, `QuickChoiceChips`.
- **`FR-S14-05`**: Nút "Ghi ngay" trên `MealQuickLogCard` phải ghi nhận trực tiếp vào nhật ký ngày hôm nay qua `TrackerNotifier` và phản hồi thông báo thành công tức thì dưới 150ms mà không làm gián đoạn luồng chat.

---

## 5. Kế Hoạch Bàn Giao & Thẩm Định (Gate Handoff)

1. Tài liệu này được bàn giao cho **Sub-Agent Product Owner (`product-owner`)** và **Sub-Agent Tech Lead (`tech-lead`)** tại file [`gate-1-signoff-dossier.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/21-ai-experience-scanner-coach/gate-1-signoff-dossier.md).
2. Kèm theo là danh sách User Stories BDD đầy đủ tại [`user-stories.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/21-ai-experience-scanner-coach/user-stories.md).
3. Sau khi PO và Tech Lead ký duyệt Gate 1, dự án sẽ lập tức chuyển giao sang **Gate 2: UI/UX Designer** và **Gate 3: QA Tester**.
