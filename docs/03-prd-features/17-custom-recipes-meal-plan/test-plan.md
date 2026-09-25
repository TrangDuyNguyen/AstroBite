# Gate 3: Master Test Plan & Adversarial Test Design — Custom Recipes & Meal Planning Architecture

- **Feature**: `FEAT-17` / `EPIC-12` (Custom Recipes & Meal Planning Architecture)
- **Sub-Agent**: QA/QC Tester (`qa-tester`) — *"The Paranoid Inquisitor"*
- **Target Coverage**: 100% Traceability với PRD (`US-01` đến `US-04`) & UI/UX Spec (5 UI States)
- **Chính sách**: **CẤM DU DI TUYỆT ĐỐI (Zero-Tolerance Policy)**
- **Ngày lập**: 25/09/2026
- **Trạng thái**: 🟢 **Gate 3 Test Design Approved & Signed Off**

---

## 🔍 1. Ma Trận Truy Vết Kiểm Thử (Traceability Matrix: EP & BVA)

| Mã US | Hạng Mục Kiểm Thử | Kỹ Thuật ISTQB | Điều Kiện Đầu Vào / Ca Biên Ác Ý | Kết Quả Mong Đợi (Strict Assertion) |
| :--- | :--- | :---: | :--- | :--- |
| **US-01** | Tạo công thức hợp lệ | EP (Happy) | Nhập tên "Salad Ức Gà Quinoa", Ức gà 150g (247.5 kcal, 46.5g Pro), Quinoa 100g (120 kcal, 21.3g Carb). | Tự động tổng hợp chính xác: 367.5 kcal, 21.3g Carbs, 50.9g Protein, 7.3g Fat. Không làm tròn sai lệch quá 0.1g. |
| **US-01** | Kiểm tra rỗng (Validation) | Negative EP | Tên công thức chỉ có khoảng trắng `"   "` hoặc danh sách `ingredients = []`. Bấm "Lưu Công Thức". | Chặn submit; hiển thị viền đỏ `#FFB4AB` tại ô input; SnackBar cảnh báo; không tạo document rác trên Firestore. |
| **US-01** | Tên cực dài & ký tự đặc biệt | BVA | Tên công thức chứa 60 ký tự UTF-8 kèm Emoji (`🥗 Bát Ăn Eat-Clean Siêu Đạm Pro Max...`). | Text hiển thị gọn gàng, không bị vỡ hàng, không `RenderFlex overflow`, lưu Firestore an toàn. |
| **US-01** | Trọng lượng biên nguyên liệu | BVA | Trọng lượng nhập 0g, 0.1g, hoặc 2000g (cực đại). | Giá trị 0g bị chặn hoặc cảnh báo; giá trị > 0 tính toán chính xác theo tỷ lệ O(N). |
| **US-01** | Chống Spam Click (Debounce) | Concurrency | Spam click nút "Lưu Công Thức" 10 lần liên tiếp trong 500ms. | Chỉ thực hiện đúng 1 request ghi duy nhất; nút chuyển trạng thái disable trong lúc lưu; không sinh duplicate ID. |
| **US-02** | Co giãn khẩu phần 2x | EP (Scale) | Khẩu phần gốc 1x (367.5 kcal). Nhấn chọn chip "2x". | Tất cả nguyên liệu nhân đôi trọng lượng (300g, 200g); tổng calo = 735 kcal; tỷ lệ % macro giữ nguyên. |
| **US-02** | Co giãn khẩu phần 0.5x | BVA | Khẩu phần 0.5x cho nguyên liệu lẻ gram (ví dụ: 15g chia 2 = 7.5g). | Xử lý số thực float chuẩn xác, hiển thị 1 chữ số thập phân, không crash do phép chia. |
| **US-02** | Màu sắc dinh dưỡng bất biến | Design Rule | Hiển thị 3 thanh tiến trình Macro của công thức. | Carbs màu `#1A73E8`, Protein màu `#FFD700`, Fat màu `#FF69B4`. Tuyệt đối không hoán đổi màu. |
| **US-03** | Lập lịch Meal Planner | EP (Calendar)| Chọn ngày `2026-09-26`, khung giờ "Bữa Trưa", gán công thức. | Document kế hoạch lưu đúng `mealType = 'lunch'`, `date = '2026-09-26'`, hiển thị thẻ món có badge Recipe. |
| **US-03** | Xóa / Sửa món trong lịch | State Transition | Xóa món đã lên kế hoạch khỏi Bữa Tối. | Xóa thành công, cập nhật ngay tổng calo dự kiến của ngày đó; không ảnh hưởng các bữa khác. |
| **US-04** | 1-Tap Log to Diary (Happy) | SLA & State | Nhấn "✓ Ghi Vào Nhật Ký" trên thẻ bữa ăn đã lên kế hoạch. | Tạo `MealLog` trong `meal_logs`, thẻ kế hoạch chuyển thành "✓ Đã Ăn", độ trễ phản hồi UI <= 100ms. |
| **US-04** | 1-Tap Log khi Mất Mạng | Offline | Bật Airplane Mode, nhấn "✓ Ghi Vào Nhật Ký". | Ghi ngay vào SQLite/Prefs Pending Queue; UI hiển thị "Đã lưu (Chờ đồng bộ ☁️)"; không crash văng lỗi mạng. |
| **US-04** | Ngăn chặn Ghi Đè Lặp Lại | Idempotency | Nhấn 1-Tap Log, sau đó cố tình nhấn lại khi đã ghi. | Nút chuyển trạng thái disabled (`isLogged = true`); không sinh thêm bản ghi thứ 2. |

---

## ⚡ 2. Kịch Bản Kiểm Thử Phi Chức Năng (Non-Functional Benchmarks)

1. **Ngân sách hiệu năng (SLA & Latency Budget)**:
   - Thời gian tính toán Macro Aggregator: `<= 5ms` cho công thức có 30 nguyên liệu.
   - Phản hồi Optimistic Update của 1-Tap Log: `<= 100ms`.
   - Tốc độ khung hình (Frame Rate): Duy trì ổn định `>= 55 FPS` (lý tưởng 60 FPS) khi cuộn danh sách 100 công thức.
2. **Quản lý bộ nhớ (Memory Leak Check)**:
   - Rò rỉ RAM: Bằng **0** sau 20 chu kỳ Mở ➔ Thêm nguyên liệu ➔ Đóng màn hình Recipe Builder.
3. **Công thái học di động**:
   - Touch target tối thiểu **44x44pt** trên toàn bộ các nút tăng giảm gram, nút xóa và nút CTA.
   - Text scaling: Kiểm thử ở cỡ chữ lớn (1.3x font size) không bị vỡ layout hoặc `RenderFlex overflow`.

---

## 🛑 3. Tiêu Chí Nghiệm Thu Gate 6 (Acceptance & Exit Criteria)

QC sẽ **BÁC BỎ THẲNG THỪNG VÀ CẤM RELEASE** nếu xảy ra bất kỳ lỗi nào sau đây:
- Có bất kỳ test case nào fail hoặc bị `skip` trong `flutter test`.
- Phát hiện bất kỳ **Fake Green Test** nào (ví dụ: `expect(true, isTrue)` hoặc test không assert payload thực).
- Màu sắc 3 chất đa lượng Carbs / Protein / Fat bị sai lệch mã hex.
- Ứng dụng bị giật hình khi cuộn (< 55 FPS) hoặc bị crash khi thao tác ở chế độ ngoại tuyến (Airplane Mode).
