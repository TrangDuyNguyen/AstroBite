# 🎨 UI/UX Design Specification: High-Value AI Experience (Scanner & GenUI Coach)

- **Feature Code**: `FEAT-S14-AI-EXPERIENCE`
- **Design System**: Claymorphic × Duolingo 2D/3D (Warm Milk `#FAF8F5` & Tactile Clay Surfaces)
- **Author**: Sub-Agent Mobile UI/UX Designer (`ui-ux-designer`) — *"The Celestial Aesthetic Purist"*
- **Reviewers**: Sub-Agent Business Analyst (`business-analyst`) & Sub-Agent Product Owner (`product-owner`)
- **Status**: 🟢 **Gate 2 DESIGN READY FOR SIGN-OFF**

---

## 1. Sơ Đồ Luồng Tương Tác & Điều Hướng (Mermaid Interaction Flow)

```mermaid
graph TD
    classDef page fill:#FFFFFF,stroke:#1CB0F6,stroke-width:2px,color:#1E2337,rx:12px;
    classDef action fill:#FFF2D6,stroke:#FF9600,stroke-width:2px,color:#1E2337,rx:8px;
    classDef button fill:#58CC02,stroke:#46a302,stroke-width:2px,color:#FFFFFF,rx:16px;
    classDef fab fill:#1CB0F6,stroke:#1586bd,stroke-width:2px,color:#FFFFFF,rx:28px;

    Shell["ShellScreen<br/>(Tabs: Home, Coach, Stats, Profile)"]:::page
    CameraScreen["CameraPage<br/>(Live AR Viewfinder & 3D Shutter)"]:::page
    ReviewSheet["ScanReviewPage<br/>(ClaySheet Multi-Dish & ChunkyMacroBar)"]:::page
    CoachTab["CoachPage<br/>(AstroCoach AI Chat Cockpit)"]:::page
    GenUICard["GenUI MealQuickLogCard<br/>(1-Tap Log)"]:::action
    LogAction["Log to Daily Diary<br/>(TrackerNotifier)"]:::button

    Shell -->|Tap Center Camera FAB| CameraScreen
    CameraScreen -->|Tap 3D Shutter / Pick Gallery| ReviewSheet
    ReviewSheet -->|Edit Grams / Change Meal| ReviewSheet
    ReviewSheet -->|Tap 'Lưu vào Nhật Ký'| Shell

    Shell -->|Tab 1: Coach| CoachTab
    CoachTab -->|Send Nutrition Inquiry| CoachTab
    CoachTab -->|AI Returns A2UI GenUI Block| GenUICard
    GenUICard -->|1-Tap 'Ghi ngay vào nhật ký'| LogAction
    LogAction -->|Update Diary State (<150ms)| Shell
```

---

## 2. Bản Vẽ Bố Cục Màn Hình (Screen Layout Blueprints & 4pt Grid)

### 2.1 Màn hình 1: `CameraPage` (Viewfinder & Chunky Shutter)
- **Scaffold**: Nền đen thuần cho live camera stream, các thành phần điều khiển bọc dạng Claymorphic nổi.
- **Top Bar Controls**:
  - Nút Thoát/Đóng: `ClayIconButton` (icon `Icons.close_rounded`) ở góc trái trên, kích thước `48x48pt`.
  - Nút Flash: `ClayIconButton` (icon `Icons.flash_on_rounded` / `flash_off_rounded`), có trạng thái active viền vàng kem khi bật.
  - Vùng bảo vệ tai thỏ: `SafeArea` padding đỉnh `16pt`.
- **Center Viewfinder (Khung ngắm)**:
  - Khung viền chữ nhật bo tròn mềm mại góc $24\text{pt}$, tỷ lệ $1:1$ hoặc $4:3$ ở trung tâm màn hình.
  - Viền mờ màu trắng sữa với 4 góc nhấn mạnh màu xanh chủ đạo `AppColors.primary` (`#1CB0F6`).
  - Hàng gợi ý viễn trắc nhẹ ở đáy khung ngắm: *"Hướng ống kính vào đĩa thức ăn"* (chữ trắng viền bóng, font `13pt`).
- **Bottom Control Deck (Cụm điều khiển đáy trong Thumb Zone)**:
  - Container bo cong nhẹ trên nền tối mờ `Color(0xCC0A192F)` hoặc dock nổi.
  - **Nút chụp chính (Shutter Button)**:
    - Kích thước: `76x76pt` tròn nổi 3D ở chính giữa.
    - Lõi nút: Nền trắng tinh hoặc xanh ngọc Duolingo với viền bóng 3D Bevel đáy dày `5pt` (`Color(0xFFD6D1C7)` hoặc `Color(0xFF1586BD)`).
    - Hiệu ứng xúc giác: Tactile squash `0.92` trong $80\text{ms}$ khi chạm kèm rung `HapticFeedback.mediumImpact()`.
  - **Nút chọn ảnh từ Thư viện (Gallery)**:
    - Nút tròn `ClayIconButton` `48x48pt` bên trái nút Shutter, icon `Icons.photo_library_rounded`.
  - **Nút chuyển đổi Camera Trước/Sau (Flip)**:
    - Nút tròn `ClayIconButton` `48x48pt` bên phải nút Shutter, icon `Icons.flip_camera_ios_rounded`.

---

### 2.2 Màn hình 2: `ScanReviewPage` (ClaySheet Multi-Dish & ChunkyMacroBar)
- **Scaffold**: Nền Warm Milk `AppColors.surface` (`#FAF8F5`).
- **Header Section**:
  - Nút Back `ClayIconButton`, tiêu đề "Kết Quả Quét Món Ăn" (HeadlineSmall, màu Slate Berry `#1E2337`).
- **Khối 1: Ảnh chụp thu nhỏ & Bộ chọn bữa ăn**:
  - Ảnh món ăn thu nhỏ bo góc $16\text{pt}$ với viền soft outline `#E8E5DF`.
  - Hàng chip chọn bữa ăn ngang bằng `ClayMealChip` (Sáng, Trưa, Tối, Phụ).
- **Khối 2: Tổng hợp Dinh dưỡng Đa lượng (`ClayCard`)**:
  - Thẻ `ClayCard` nền trắng tinh `#FFFFFF` bo góc $20\text{pt}$, đổ bóng 2D bevel.
  - Hiển thị tổng Calo to bản: `headlineMedium` (vd: `650 Kcal`).
  - Thanh đa lượng `ChunkyMacroBar` chiều cao `14pt`, bo góc `7pt` với 3 màu dinh dưỡng bất biến:
    - 🩵 **Carbs**: `#1CB0F6` (Duolingo Sky Blue)
    - 🍓 **Fat**: `#FF5C8D` (Strawberry Cream Pink)
    - 🧡 **Protein**: `#FF9600` (Honey Tangerine Orange)
  - Dải micro tags bên dưới: Natri, Chất xơ (nếu có).
- **Khối 3: Danh sách món nhận diện (Dish Items List)**:
  - Mỗi món ăn là một thẻ `ClayCard` độc lập:
    - Tên món (TitleMedium bold).
    - Hàng Stepper gram: Nút `-20g`, hiển thị khối lượng hiện tại (`150g`), nút `+20g` dạng nút 3D nhỏ.
    - Calo tính tương ứng cho khối lượng.
    - Nút xóa món `ClayIconButton` icon thùng rác viền mềm đỏ nhạt.
  - Nút "Thêm món thủ công vào bữa này" `ClayButton.ghost` viền nét đứt.
- **Sticky Bottom Action Deck**:
  - Cố định trong Thumb Zone ở đáy màn hình.
  - Nút "Lưu vào Nhật Ký" `ClayButton.primary` full-width, chiều cao `54pt`, bo góc `18pt`, viền 3D bevel `4pt`.

---

### 2.3 Màn hình 3: `CoachPage` & Generative UI Chat Cockpit
- **Scaffold**: Nền Warm Milk `AppColors.surface` (`#FAF8F5`).
- **App Bar**:
  - Avatar AstroBot linh vật 3D tròn mềm bo góc, tên "AstroCoach AI", trạng thái "Trực tuyến 🟢".
- **Chat Stream (Danh sách tin nhắn)**:
  - **Bong bóng người dùng (User Bubble)**:
    - Canh phải (align right), margin trái `48pt`.
    - Dạng thẻ `ClayCard` với tông nền xanh dương nhạt hoặc pastel primary, bo góc $20\text{pt}$ (góc dưới phải bo nhỏ $6\text{pt}$).
  - **Bong bóng AstroCoach (AI Assistant Bubble)**:
    - Canh trái (align left), margin phải `48pt`.
    - Dạng thẻ `ClayCard` nền trắng tinh `#FFFFFF` bo góc $20\text{pt}$ (góc dưới trái bo nhỏ $6\text{pt}$), đổ bóng 2D bevel.
    - Định dạng Markdown hỗ trợ in đậm, bullet points và danh sách món rõ ràng.
- **3 Widget A2UI Generative UI Nhúng Trực Tiếp Trong Chat**:
  1. **`MealQuickLogCard`**:
     - Thẻ `ClayCard` bo góc $20\text{pt}$, viền vi chất mềm.
     - Hiển thị tên món ăn, tổng calo lớn, và 3 viên thuốc macro mini (Carbs 🩵, Fat 🍓, Protein 🧡).
     - Nút "Ghi ngay vào nhật ký" dạng `ClayButton` màu xanh lá `AppColors.brandGreen` (`#58CC02`) viền 3D bevel đáy `3.5pt`. Khi nhấn: squash `0.95`, rung nhẹ và đổi sang "Đã lưu ✓" trong $<150\text{ms}$.
  2. **`MacroBudgetGauge`**:
     - Thẻ `ClayCard` nền trắng, chứa thanh tiến độ hiển thị Calo dự kiến sẽ nạp so với ngân sách còn lại trong ngày.
  3. **`QuickChoiceChips`**:
     - Danh sách các câu hỏi/hành động gợi ý dạng pill buttons với hiệu ứng nảy 3D khi chạm, tự động gửi nội dung vào khung chat.
- **Bottom Chat Input Deck**:
  - Đáy màn hình cố định với `ClayTextField` bo tròn mềm góc $24\text{pt}$, icon micro hoặc phím gửi `ClayIconButton` màu xanh `AppColors.primary`.

---

## 3. Đặc Tả 5 Trạng Thái Giao Diện Bắt Buộc (5 Mandatory UI States)

```
[1. Default] ──► [2. Loading Shimmer] ──► [3. Empty] ──► [4. Error] ──► [5. Offline]
```

1. **Default State**:
   - Camera hoạt động mượt mà, khung ngắm sắc nét, cụm Shutter 3D nổi bật.
   - ScanReviewPage hiển thị đầy đủ thẻ món, macro bar và nút Lưu.
   - CoachPage hiển thị danh sách hội thoại và các khối GenUI tương tác tức thì.
2. **Loading / Shimmer State**:
   - Khi đang phân tích ảnh hoặc AI đang sinh câu trả lời: Sử dụng `ClaySkeletonLoader` với dải shimmer màu kem ấm `#EFF1F5` (tuyệt đối không dùng dải đen xỉn).
   - Trong Camera: Ảnh chụp đóng băng tĩnh kết hợp hiệu ứng vòng quét radar mượt mà.
3. **Empty State**:
   - Trong Camera / Review: Nếu không nhận diện được món nào, hiển thị thẻ `ClayCard` nền kem nhẹ `#FFF2D6` với icon đĩa thìa, thông điệp: "Chưa nhận diện rõ món ăn. Bạn thử chụp góc gần hơn hoặc nhập thủ công nhé!" kèm 2 nút bấm 3D rõ ràng.
   - Trong Coach: Khung chào ban đầu với avatar AstroBot và hàng gợi ý `QuickChoiceChips`.
4. **Error State**:
   - Lỗi máy ảnh hoặc lỗi server Gemini: Thẻ thông báo `ClayCard` màu hồng pastel `#FFE8EE` viền đỏ nhẹ, có nút "Thử Lại" `ClayButton.secondary`.
5. **Offline State**:
   - Thông báo dạng pill Claymorphic nổi màu vàng kem `#FFF2D6`: "Bạn đang ngoại tuyến. Món ăn sẽ được lưu vào hàng đợi và đồng bộ khi có mạng."

---

## 4. Bảng Ánh Xạ Tokens & Shared Components Handoff cho Dev FE

| Thành Phần Giao Diện | Shared Widget Tái Sử Dụng | Tokens Màu / Thông Số Bắt Buộc | Ràng Buộc Handoff cho Dev FE |
|:---|:---|:---|:---|
| **Nền các màn hình** | `Scaffold` | `AppColors.surface` (`#FAF8F5`) | Đặt `surfaceTintColor: Colors.transparent` |
| **Nút Shutter chụp ảnh** | Custom 3D Shutter (`ClayButton` core) | Nền trắng `#FFFFFF`, viền đáy bevel `4pt` `#D6D1C7` | Touch target $76\times 76\text{pt}$, squash `0.92` |
| **Nút Flash / Gallery** | `ClayIconButton` | Nền trắng `#FFFFFF`, viền bóng 2D | Touch target tối thiểu $48\times 48\text{pt}$ |
| **Thẻ món ăn sau scan** | `ClayCard` | Nền trắng `#FFFFFF`, radius $20\text{pt}$ | Hỗ trợ xóa/sửa gram động |
| **Thước đo dinh dưỡng** | `ChunkyMacroBar` | Carbs 🩵 `#1CB0F6`, Fat 🍓 `#FF5C8D`, Protein 🧡 `#FF9600` | Chiều cao $14\text{pt}$, bo góc $7\text{pt}$ |
| **Bộ chọn loại bữa ăn** | `ClayMealChip` | Types: breakfast, lunch, dinner, snack | Đổi bữa ăn chỉ với 1 chạm |
| **Nút lưu vào nhật ký** | `ClayButton.primary` | Nền `AppColors.primary` (`#1CB0F6`), bevel 4pt | Chiều cao $54\text{pt}$, full-width Thumb Zone |
| **Bong bóng chat AI** | `ClayCard` | Nền `#FFFFFF`, radius $20\text{pt}$, margin phải $48\text{pt}$ | Parse Markdown & block ````a2ui```` |
| **Thẻ GenUI Meal Log** | `MealQuickLogCard` | Bọc trong `ClayCard`, nút `ClayButton` xanh lá | Nút 1-tap ghi nhật ký, squash `0.95` |
| **Khung xương chờ** | `ClaySkeletonLoader` | Base `#EFF1F5`, highlight `#F7F8FA` | Thay thế toàn bộ shimmer đen cũ |
