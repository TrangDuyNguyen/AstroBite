# User Stories BDD: Sprint 19 Multi-Region Food Culture Intelligence

- **Người soạn thảo**: Sub-Agent Business Analyst (BA) — *The Pedantic Logician*
- **Chuẩn kiểm thử**: BDD (Behavior-Driven Development / Gherkin)
- **Traceability**: `EPIC-GLOBAL` / `FEAT-S19-GLOBAL-CUISINE`
- **Phiên bản mục tiêu**: `v2.9.0`

---

## 🎯 User Story 1: Tùy Chọn Húp Nước Dùng Hoặc Chỉ Ăn Cái (Broth Toggle)

**Là một** người theo chế độ ăn kiểm soát năng lượng hoặc huyết áp,  
**Tôi muốn** có công tắc lựa chọn "Ăn cả nước" hoặc "Chỉ ăn cái" ngay trên thẻ món ăn có nước (Phở, Bún bò, Hủ tiếu),  
**Để** ứng dụng tự động khấu trừ lượng calo và natri trong nước dùng mà tôi không ăn, tránh việc tính dư calo ảo.

### Kịch bản 1.1: Gạt công tắc chuyển sang "Chỉ ăn cái" (Happy Path)
- **Given** người dùng vừa quét ảnh một tô "Phở Bò Tái Nạm" (Tổng calo: 520 kcal, Natri: 1,850 mg, Nước dùng: 190 kcal, Natri nước dùng: 1,350 mg)
- **And** người dùng đang ở màn hình `ScanReviewPage`
- **And** công tắc Broth Toggle đang ở trạng thái mặc định: `[🍜 Ăn cả nước (+190 kcal)]`
- **When** người dùng chạm vào công tắc Broth Toggle
- **Then** công tắc chuyển trạng thái sang `[🥢 Chỉ ăn cái (-190 kcal, giảm 73% Muối)]` với nền Mint `#E8F9D8` và viền `#58CC02`
- **And** tổng calo của món ăn giảm tức thì từ 520 kcal xuống 330 kcal (`520 - 190 = 330`)
- **And** tổng calo trên thanh `CalorieProgressArc` và `ChunkyMacroBar` giảm 190 kcal trong dưới 16ms mà không giật khung hình
- **And** lượng natri ghi nhận giảm từ 1,850 mg xuống 500 mg.

### Kịch bản 1.2: Gạt công tắc quay lại "Ăn cả nước"
- **Given** người dùng đang để công tắc ở trạng thái `[🥢 Chỉ ăn cái]` (Calo hiển thị: 330 kcal)
- **When** người dùng chạm lại vào công tắc
- **Then** công tắc chuyển về `[🍜 Ăn cả nước (+190 kcal)]` với nền Sky Blue `#E5F6FD` và viền `#1CB0F6`
- **And** calo món ăn khôi phục về 520 kcal và natri khôi phục về 1,850 mg.

### Kịch bản 1.3: Quét món khô không có nước dùng (Edge Case: Non-broth dish)
- **Given** người dùng quét đĩa "Bánh cuốn thịt nướng" hoặc "Cơm gà xối mỡ"
- **When** Gemini trả về `has_broth: false`
- **Then** thẻ món ăn KHÔNG hiển thị công tắc Broth Toggle
- **And** giao diện co giãn tự nhiên, không để lại khoảng trống thừa hay lỗi layout.

---

## 🎯 User Story 2: Chọn / Bỏ Chọn Topping Trong Món Combo (Topping Checklist)

**Là một** người ăn cơm tấm hoặc bánh mì muốn cắt giảm mỡ béo,  
**Tôi muốn** tick chọn hoặc bỏ bớt các topping cụ thể (như Mỡ hành, Tóp mỡ, Chả trứng) ngay trên thẻ món ăn,  
**Để** calo của bữa ăn được tính chính xác theo những gì tôi thực sự ăn vào bụng.

### Kịch bản 2.1: Bỏ chọn topping "Mỡ hành" trên đĩa Cơm Tấm (Happy Path)
- **Given** người dùng vừa quét đĩa "Cơm Tấm Sườn Bì Chả" (Tổng calo: 680 kcal)
- **And** danh sách topping hiển thị 5 chip: `[✓ Cơm tấm: 210 kcal]`, `[✓ Sườn: 230 kcal]`, `[✓ Chả: 110 kcal]`, `[✓ Bì: 70 kcal]`, `[✓ Mỡ hành: 60 kcal]`
- **When** người dùng chạm vào chip `[✓ Mỡ hành: 60 kcal]`
- **Then** chip chuyển sang trạng thái bỏ chọn `[- Mỡ hành: 60 kcal]` với nền xám mờ và chữ gạch ngang
- **And** calo của đĩa cơm tấm tự động trừ 60 kcal: từ 680 kcal xuống 620 kcal (`680 - 60 = 620`)
- **And** chất béo (Fat) của món ăn giảm tương ứng với lượng mỡ hành được bóc tách
- **And** thanh `ChunkyMacroBar` toàn bữa ăn cập nhật giảm 60 kcal ngay lập tức.

### Kịch bản 2.2: Chọn lại topping vừa bỏ
- **Given** chip `[- Mỡ hành: 60 kcal]` đang ở trạng thái bỏ chọn
- **When** người dùng chạm lại vào chip này
- **Then** chip kích hoạt lại trạng thái active `[✓ Mỡ hành: 60 kcal]`
- **And** calo của đĩa cơm tăng lại +60 kcal lên 680 kcal.

### Kịch bản 2.3: Bỏ chọn tất cả topping trừ cơm trắng
- **Given** người dùng chạm bỏ chọn toàn bộ 4 topping phụ (Sườn, Chả, Bì, Mỡ hành)
- **When** chỉ còn lại topping `[✓ Cơm tấm: 210 kcal]`
- **Then** calo đĩa cơm hiển thị đúng 210 kcal
- **And** hệ thống không báo lỗi, vẫn cho phép lưu nhật ký bình thường.

---

## 🎯 User Story 3: Lưu Nhật Ký Với Dữ Liệu Tùy Biến (Persistence & Sync)

**Là một** người dùng AstroBite ghi nhật ký ăn uống hằng ngày,  
**Tôi muốn** khi bấm "Lưu Bữa Ăn", toàn bộ trạng thái toggle nước dùng và checklist topping được lưu trữ đầy đủ,  
**Để** khi xem lại lịch sử ăn uống tại `TodayPage` hoặc `MealDetailPage`, dữ liệu hiển thị trung thực với lựa chọn của tôi.

### Kịch bản 3.1: Lưu bản ghi món nước đã bỏ nước dùng vào Firestore & Cache
- **Given** người dùng đang ở `ScanReviewPage`, đã gạt phở sang `[🥢 Chỉ ăn cái]` (Calo: 330 kcal)
- **When** người dùng bấm nút Duolingo 3D "Lưu Bữa Ăn"
- **Then** bản ghi `meal_logs` được tạo với `calories: 330`
- **And** mảng `dishes[0]` chứa `has_broth: true`, `include_broth: false`, `broth_calories: 190`
- **And** bản ghi được ghi tức thì vào Local Hive Box `offline_meal_logs` trong < 50ms
- **And** hệ thống đẩy lên Firestore collection `users/{uid}/meal_logs` trong nền
- **And** ứng dụng chuyển hướng về `HomePage`, vòng `CalorieProgressArc` cộng đúng 330 kcal.

### Kịch bản 3.2: Khả năng tương thích ngược khi xem lại bữa ăn cũ (Backward Compatibility)
- **Given** người dùng mở xem chi tiết một bữa ăn phở được lưu từ phiên bản cũ `v2.8.0` (chưa có trường `has_broth` và `sub_items`)
- **When** màn hình `MealDetailPage` tải dữ liệu
- **Then** hệ thống tự động gán giá trị fallback `has_broth: false` và `sub_items: []`
- **And** màn hình hiển thị bình thường, không crash, không xuất hiện `NoSuchMethodError` hay `NullPointerException`.
