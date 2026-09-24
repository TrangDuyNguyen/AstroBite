# PRD: Màn Hình Tổng Quan Hôm Nay Chuẩn Glanceable (Celestial Cockpit & Quick Log)

- **Mã tính năng**: `FEAT-13`
- **Mã Epic liên kết**: `EPIC-15` (Glanceable Celestial Cockpit & Quick Log)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA) — *"The Pedantic Logician"*
- **Trạng thái**: 🟢 **Approved (Đã được PO & Tech Lead Phê Duyệt Gate 1)**
- **Mục tiêu phiên bản**: `v1.5.0` (Sprint 06)
- **Tham chiếu thiết kế**: `docs/03-prd-features/13-glanceable-home-cockpit/ui-ux-design-spec.md` (Gate 2 - Stitch Screen ID: `db13f5531baf4aeab67ab09be0b5bafa`)
- **Đối chiếu QA**: `test/features/tracker/presentation/celestial_cockpit_card_test.dart` (Gate 3 & Gate 6)
- **Đối chiếu FE**: `lib/features/tracker/presentation/widgets/celestial_cockpit_card.dart` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
- **Quá tải nhận thức (Cognitive Overload)**: Màn hình Home cũ phân mảnh dữ liệu: Vòng tròn Calo to đùng, bên dưới là 3 thanh Macro xếp dọc dài, tiếp đến là Card Vi chất chiếm diện tích lớn và Banner AstroCoach to bản. Người dùng mở app phải cuộn trang mới thấy được danh sách bữa ăn.
- **Tốc độ đọc dữ liệu chậm (Slow Glanceability)**: Mất trung bình 4–6 giây để người dùng tính nhẩm *"hôm nay mình còn ăn được bao nhiêu calo và macro đang thiếu chất gì"*.
- **Ma sát khi ghi chép**: Nhật ký bữa ăn bị đẩy xuống sâu, thiếu nút tắt thêm nhanh 1 chạm tối ưu công thái học.

### 1.2. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (KPIs & Metrics)
- **Time-to-Understand (TTU)**: Giảm thời gian nắm bắt Calo còn lại và 3 Macro xuống **< 1.5 giây**.
- **Tần suất tương tác 1 chạm (Quick Log Adoption)**: Tăng **35%** số lượt ghi món nhanh thông qua nút `+` trực tiếp trên từng bữa ăn.
- **Tiết kiệm diện tích màn hình**: Nén chiều dọc khối tóm tắt dinh dưỡng từ ~450pt xuống **~210pt** (tiết kiệm > 50% vertical space).
- **Hiệu năng giao diện**: 60 FPS mượt mà khi cuộn, không gây hiện tượng giật lag hoặc `RenderFlex overflow`.

---

## 2. Đối Tượng Người Dùng (Target Personas)

1. **Người Theo Dõi Calo Bận Rộn (Speed-Tracker)**: Muốn mở app trong 2 giây khi đang đứng ở quầy gọi đồ ăn, nhìn vào là biết ngay được nạp thêm bao nhiêu kcal và thiếu bao nhiêu gram Protein.
2. **Người Dùng Giữ Chuỗi (Streak-Engaged User)**: Muốn thấy ngay chuỗi ngày ăn sạch (Cosmic Streak) và trạng thái cân bằng năng lượng để duy trì động lực.

---

## 3. Đặc Tả Yêu Cầu Chức Năng (Functional Requirements)

### 3.1. US-01: Bảng Điều Khiển Trung Tâm (Celestial Cockpit Card)
- **Mô tả**: Toàn bộ bức tranh Calo và 3 Macro chính được đặt song song trong 1 khối Card kính mờ (`GlassCard` nền `#112240`).
- **Phía bên trái (Calorie Gauge)**:
  - Vòng cung tiến độ tỏa sáng (Glow Arc, đường kính 130–140pt).
  - Con số trung tâm: Số kcal còn lại (hoặc số kcal vượt mức nếu over budget) định dạng to bản, `letterSpacing: +0.5`.
  - Phụ đề đối chiếu: `còn lại / [target] kcal mục tiêu`.
- **Phía bên phải (Macro Progress Bars)**:
  - 3 thanh tiến độ thẳng hàng, chuẩn màu dinh dưỡng bất biến:
    - 🔵 **Carbs**: Xanh Electric (`#1A73E8`) — `[current]g / [target]g`
    - 🟡 **Protein**: Vàng Gold (`#FFD700`) — `[current]g / [target]g`
    - 🩷 **Fat**: Hồng Hot Pink (`#FF69B4`) — `[current]g / [target]g`
  - Tự động hiển thị tỷ lệ % hoàn thành trên từng thanh.

### 3.2. US-02: Thanh Vi Chất Thu Gọn (Collapsible Micronutrients Pill)
- **Mô tả**: Thay thế thẻ vi chất to bản cũ bằng một thanh dải mỏng tinh tế dạng Capsule/Pill.
- **Trạng thái mặc định**: Thu gọn (Collapsed), hiển thị 1 dòng tóm tắt: `Vi chất: Natri Xmg • Xơ Yg • Đường Zg ▾`.
- **Khi chạm vào**: Bung ra bảng chi tiết 4 chỉ số (Natri, Xơ, Đường, Nước) kèm cảnh báo vượt ngưỡng an toàn.

### 3.3. US-03: Tinh Gọn AstroCoach Thành Dòng Gợi Ý Ngữ Cảnh
- **Mô tả**: Loại bỏ thẻ banner to chiếm 120pt. Thay bằng một thanh bo tròn tinh tế 1 dòng duy nhất bên trên hoặc bên dưới Nhật ký bữa ăn:
  - Biểu tượng AI ✨ + Text gợi ý ngắn: *"Cần thêm [X]g Protein để hoàn thành mục tiêu hôm nay"*.
  - Chạm vào dòng này sẽ chuyển hướng trực tiếp sang màn hình `CoachPage`.

### 3.4. US-04: Tối Ưu Bữa Ăn & Nút Thêm Nhanh 1 Chạm (1-Tap Quick Add)
- **Mô tả**: 4 khối bữa ăn (Sáng, Trưa, Tối, Phụ) hiển thị:
  - Tên món ăn đã log, tổng calo và phân bổ C-P-F.
  - Nút tròn `+` Quick-Add hoặc dấu tích hoàn thành với vùng chạm tối thiểu **44 × 44pt**.
  - Bấm nút `+` sẽ mở trực tiếp trang `ManualEntryRoute` với `initialMealType` tương ứng.

---

## 4. Kịch Bản Nghiệm Thu BDD (Given - When - Then)

### Kịch Bản 1: Hiển thị đúng số liệu Calo và 3 Macro trên Celestial Cockpit
- **Given**: Người dùng đã nạp 1.450 kcal trên mục tiêu 2.100 kcal (Carbs: 120g/220g, Protein: 85g/130g, Fat: 38g/65g).
- **When**: Người dùng mở màn hình Tổng quan hôm nay.
- **Then**: 
  - Khối Celestial Cockpit hiển thị ở đỉnh màn hình trong 1 thẻ Card duy nhất.
  - Vòng calo bên trái hiển thị con số `650` kèm chữ `KCAL CÒN LẠI`.
  - Bên phải hiển thị 3 thanh tiến độ thẳng hàng với đúng mã màu Carbs (`#1A73E8`), Protein (`#FFD700`), Fat (`#FF69B4`).
  - Toàn bộ thời gian hiển thị hoàn tất < 200ms.

### Kịch Bản 2: Thu gọn và mở rộng thanh Vi chất dinh dưỡng
- **Given**: Người dùng đang ở màn hình Tổng quan hôm nay.
- **When**: Màn hình vừa tải xong.
- **Then**: Thanh vi chất ở trạng thái thu gọn 1 dòng `Vi chất: Natri ... ▾`.
- **When**: Người dùng chạm vào thanh vi chất.
- **Then**: Thanh bung mở hiển thị chi tiết 4 chỉ số mà không làm tràn khung hình (0 overflow).

### Kịch Bản 3: Chạm nút Thêm nhanh trên Bữa ăn
- **Given**: Bữa phụ (Snack) chưa có món ăn nào.
- **When**: Người dùng chạm vào nút `+` trên thẻ Bữa phụ (vùng chạm >= 44x44pt).
- **Then**: Ứng dụng lập tức chuyển sang màn hình `ManualEntryPage` với loại bữa ăn được chọn sẵn là `snack`.

---

## 5. Từ Điển Dữ Liệu & Quy Chuẩn Giao Diện (Data Dictionary & Tokens)

| Trường Dữ Liệu | Kiểu Dữ Liệu | Nguồn / State | Quy Chuẩn Hiển Thị |
| :--- | :--- | :--- | :--- |
| `remainingCalories` | `int` | `DailySummary.targetCalories - totalCalories` | Chữ số to `26pt Bold`, màu xanh `#1A73E8` (hoặc vàng `#FFD700` khi over budget). |
| `carbsRatio` | `double` | `totalCarbsG / targetCarbsG` | Thanh tiến độ màu Electric Blue `#1A73E8`. |
| `proteinRatio` | `double` | `totalProteinG / targetProteinG` | Thanh tiến độ màu Warm Gold `#FFD700`. |
| `fatRatio` | `double` | `totalFatG / targetFatG` | Thanh tiến độ màu Hot Pink `#FF69B4`. |
| `isMicronutrientsExpanded` | `bool` | Local UI State (Stateful / Riverpod) | Mặc định `false`. |

---

## 6. Tiêu Chí Nghiệm Thu Gate 1 (Sign-Off Criteria)
- [x] Có đầy đủ số liệu đo lường cụ thể (Time-to-Understand < 1.5s, kích thước thẻ ~210pt).
- [x] 100% User Stories có kịch bản BDD Given-When-Then.
- [x] Tuân thủ bảng màu dinh dưỡng bất biến và không có Scope Creep.
- [x] Sub-Agent PO và Tech Lead đồng ký duyệt Feasibility Sign-off.
