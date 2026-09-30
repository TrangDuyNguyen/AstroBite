# 📋 User Stories & Tiêu Chí Nghiệm Thu BDD (Sprint 14)

- **Feature Code**: `FEAT-S14-AI-EXPERIENCE`
- **Mã Epic**: `EPIC-UI-REFRESH` (Solar Fresh × Duolingo 2D/3D Claymorphic)
- **Author**: Sub-Agent Business Analyst (`business-analyst`)
- **Reviewer**: Sub-Agent Product Owner (`product-owner`) & Sub-Agent Tech Lead (`tech-lead`)
- **Sprint**: Sprint 14 (`v2.3.0`)

---

## 📌 US-S14-01: Tactile Camera Viewfinder & Chunky Shutter Control (`CameraPage`)
> **Là một** người dùng muốn ghi nhận bữa ăn bằng hình ảnh,  
> **Tôi muốn** giao diện chụp ảnh có cụm nút bấm 3D nổi bật, độ nảy xúc giác cao và khung ngắm thân thiện,  
> **Để** tôi có thể chụp ảnh đĩa thức ăn nhanh chóng bằng một tay với trải nghiệm hứng khởi.

### Scenario 1: Hiển thị cụm điều khiển Camera chuẩn Duolingo 3D (Happy Path)
- **Given** người dùng mở ứng dụng và điều hướng vào `CameraPage`,
- **When** luồng live stream của camera khởi tạo thành công,
- **Then** màn hình hiển thị khung ngắm Viewfinder với 4 góc bo mềm mại $24\text{pt}$,
- **And** ở thanh điều khiển đáy, nút Shutter chụp ảnh hiển thị dạng nút tròn 3D nhô cao với viền bóng bevel dày $4\text{pt}$, kích thước tối thiểu $64\times 64\text{pt}$,
- **And** hai bên nút Shutter là nút Bật/Tắt Flash và nút Chọn ảnh từ Thư viện dạng `ClayIconButton` nổi rõ ràng, kích thước $\ge 48\times 48\text{pt}$.

### Scenario 2: Phản hồi xúc giác (Tactile Squash) khi bấm nút chụp
- **Given** người dùng đang ngắm camera vào đĩa thức ăn,
- **When** người dùng chạm vào nút Shutter,
- **Then** nút bị nén xuống tỉ lệ `0.92` scale trong $80\text{ms}$,
- **And** hệ thống kích hoạt rung phản hồi xúc giác `HapticFeedback.mediumImpact()`,
- **And** màn hình đóng băng khung hình và hiển thị hiệu ứng quét radar mượt mà trong khi gửi ảnh tới Gemini AI.

### Scenario 3: Quyền Camera bị từ chối (Edge Case / Error State)
- **Given** người dùng chưa cấp quyền truy cập Camera hoặc quyền bị từ chối,
- **When** người dùng mở `CameraPage`,
- **Then** hệ thống hiển thị màn hình cảnh báo thân thiện trên nền `AppColors.surface` với thẻ `ClayCard`,
- **And** có nút "Mở Cài Đặt" dạng `ClayButton.primary` 3D để người dùng cấp quyền mà không làm crash ứng dụng.

---

## 📌 US-S14-02: Multi-Dish Review with ClaySheet & ChunkyMacroBar (`ScanReviewPage`)
> **Là một** người dùng vừa chụp ảnh món ăn xong,  
> **Tôi muốn** danh sách các món nhận diện được hiển thị dạng thẻ ClayCard rõ ràng cùng thanh Macro đa lượng,  
> **Để** tôi dễ dàng chỉnh sửa gram từng món và xác nhận lưu vào nhật ký ăn uống dưới 1.5 giây.

### Scenario 1: Hiển thị kết quả nhận diện món trên tấm ClaySheet (Happy Path)
- **Given** Gemini AI trả về kết quả phân tích gồm 1 hoặc nhiều món ăn,
- **When** màn hình `ScanReviewPage` mở ra,
- **Then** danh sách món ăn hiển thị trên nền Warm Milk `#FAF8F5`,
- **And** mỗi món ăn là một thẻ `ClayCard` nền trắng tinh `#FFFFFF` bo góc $20\text{pt}$, hiển thị rõ: tên món, lượng calo, khối lượng (g) và nút xóa món,
- **And** trên cùng là thanh tổng hợp `ChunkyMacroBar` hiển thị 3 màu dinh dưỡng bất biến:
  - Carbs 🩵 `#1CB0F6` (Sky Blue)
  - Fat 🍓 `#FF5C8D` (Strawberry Cream Pink)
  - Protein 🧡 `#FF9600` (Honey Tangerine Orange),
- **And** có bộ chọn bữa ăn bằng `ClayMealChip` (Sáng, Trưa, Tối, Phụ).

### Scenario 2: Chỉnh sửa khối lượng món ăn (Dynamic Recalculation)
- **Given** thẻ món ăn đang hiển thị khối lượng $150\text{g}$,
- **When** người dùng chạm nút tăng/giảm gram (+20g / -20g hoặc nhập số mới),
- **Then** lượng calo của món ăn đó được tính toán lại ngay lập tức,
- **And** thanh `ChunkyMacroBar` tổng của toàn bữa ăn cập nhật giá trị mới với hiệu ứng chuyển đổi mượt mà trong $200\text{ms}$.

### Scenario 3: Lưu bữa ăn thành công với nút 3D ClayButton
- **Given** người dùng đã kiểm tra xong các món ăn,
- **When** người dùng nhấn nút "Lưu vào nhật ký" dạng `ClayButton.primary` ở cuối màn hình,
- **Then** nút có hiệu ứng nén đàn hồi tactile squash `0.95`,
- **And** dữ liệu bữa ăn được lưu vào nhật ký ăn uống hôm nay thông qua `TrackerNotifier`,
- **And** điều hướng người dùng quay trở lại `HomePage` với snackbar xác nhận thành công.

---

## 📌 US-S14-03: Conversational AI Nutrition Cockpit (`CoachPage`)
> **Là một** người dùng cần lời khuyên dinh dưỡng tức thì,  
> **Tôi muốn** giao diện chat với AstroCoach thân thiện, mềm mại và trực quan,  
> **Để** tôi có thể tương tác hỏi đáp như đang trò chuyện với một chuyên gia dinh dưỡng thực thụ.

### Scenario 1: Giao diện hội thoại chuẩn Claymorphic (Happy Path)
- **Given** người dùng mở tab `CoachPage`,
- **When** màn hình hiển thị danh sách tin nhắn lịch sử,
- **Then** nền màn hình là màu Warm Milk `AppColors.surface` (`#FAF8F5`),
- **And** bong bóng tin nhắn của người dùng hiển thị dưới dạng `ClayCard` bo góc $20\text{pt}$ với tông màu xanh nhạt hoặc primary tint,
- **And** bong bóng tin nhắn của AstroCoach hiển thị dưới dạng `ClayCard` trắng tinh bo góc $20\text{pt}$ kèm avatar linh vật AstroBot,
- **And** khung nhập văn bản sử dụng `ClayTextField` tích hợp nút gửi dạng `ClayIconButton` 3D.

### Scenario 2: Mất kết nối internet khi đang chat (Offline State)
- **Given** người dùng đang ở trong `CoachPage` và thiết bị mất kết nối mạng,
- **When** người dùng nhập câu hỏi và nhấn gửi,
- **Then** hệ thống không bị crash,
- **And** bong bóng tin nhắn hiển thị biểu tượng cảnh báo nhẹ kèm thông điệp: "Đang mất kết nối mạng. AI sẽ phản hồi khi có mạng trở lại."

---

## 📌 US-S14-04: 1-Tap Generative UI Meal Logging (`MealQuickLogCard` & `MacroBudgetGauge`)
> **Là một** người dùng nhận được gợi ý món ăn từ AI Coach,  
> **Tôi muốn** chạm 1 lần vào thẻ gợi ý để ghi ngay món ăn vào nhật ký mà không cần thoát khỏi khung chat,  
> **Để** tiết kiệm tối đa thời gian ghi chép và giữ vững chuỗi thói quen lành mạnh.

### Scenario 1: Hiển thị thẻ GenUI MealQuickLogCard sinh từ A2UI Protocol
- **Given** AstroCoach phản hồi tin nhắn có chứa khối block ````a2ui```` với component `MealQuickLogCard`,
- **When** tin nhắn được parse thành công,
- **Then** giao diện nhúng ngay một thẻ `MealQuickLogCard` dạng `ClayCard` nổi bật,
- **And** thẻ hiển thị tên món, lượng calo to bản, 3 viên thuốc macro mini (Carbs 🩵, Fat 🍓, Protein 🧡),
- **And** có nút bấm "Ghi vào nhật ký" dạng `ClayButton` màu xanh lá `AppColors.brandGreen` (`#58CC02`).

### Scenario 2: Bấm nút 1-Tap Log ghi món thành công
- **Given** thẻ `MealQuickLogCard` đang hiển thị trong luồng chat,
- **When** người dùng bấm nút "Ghi vào nhật ký",
- **Then** nút bị nén đàn hồi tactile squash `0.95` và rung nhẹ,
- **And** món ăn được thêm tự động vào bữa ăn hiện tại của ngày hôm nay,
- **And** nút chuyển trạng thái thành "Đã ghi nhận ✓" màu xám nhạt với độ trễ phản hồi $< 150\text{ms}$.
