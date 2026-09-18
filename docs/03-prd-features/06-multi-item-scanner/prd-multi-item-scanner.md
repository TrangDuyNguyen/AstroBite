# PRD: Nhận Diện Đồng Thời Nhiều Món Ăn Bằng AI (Multi-Item Food Scanner AI)

- **Mã tính năng**: `FEAT-06`
- **Mã Epic liên kết**: `EPIC-06` (Multi-Item Meal Detection)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA)
- **Trạng thái**: 🟢 **Approved (Gate 1 Sign-off Đã Phê Duyệt)**
- **Mục tiêu phiên bản**: `v1.1.0` (Sprint 02)
- **Đối chiếu UI/UX**: `docs/03-prd-features/06-multi-item-scanner/ui-ux-design-spec.md` (Gate 2)
- **Đối chiếu QA**: `tests/02-manual-testcases/06-multi-item-scanner/` & `tests/03-bdd-gherkin-scenarios/multi_item_scanner.feature` (Gate 3)
- **Đối chiếu FE**: `lib/features/scanner/` & `lib/features/tracker/` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
- Tại thị trường Việt Nam và Châu Á, thói quen ăn uống điển hình là dùng khay cơm văn phòng, cơm phần gia đình, hoặc mâm cơm có từ 2 đến 5 món riêng biệt trên cùng một bàn/đĩa (ví dụ: cơm trắng, sườn nướng, chả trứng, canh cải thịt bằm, dưa leo).
- Ở phiên bản `v1.0.0`, AI Scanner chỉ nhận diện đơn lẻ 1 món ăn đại diện hoặc gộp chung thành một món mơ hồ, buộc người dùng phải:
  1. Chụp riêng từng đĩa 3 - 4 lần (mất thời gian, trải nghiệm rời rạc).
  2. Hoặc phải chỉnh tay thủ công tên và dinh dưỡng từng món con.
- **Nỗi đau (Pain Point)**: Gây nản lòng và bỏ dở thói quen ghi nhật ký bữa ăn khi ăn các bữa ăn phức hợp hoặc ăn cùng gia đình.

### 1.2. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (KPIs & Metrics)
- **Giảm 70% thao tác chụp ảnh**: Người dùng chỉ cần chụp 1 bức ảnh toàn cảnh đĩa/mâm cơm để bóc tách toàn bộ các món con.
- **Độ chính xác phân rã món (Item Precision)**: Nhận diện chính xác >= 85% số món có trên đĩa (đối với mâm/khay từ 2 - 4 món).
- **Thời gian phản hồi AI (Latency)**: Phân tích đa món qua Gemini 2.0 Flash Vision và trả kết quả có cấu trúc <= 2.5 giây.
- **Tỷ lệ hoàn tất ghi nhật ký (Completion Rate)**: Đạt >= 90% số lượt quét đa món được người dùng bấm "Lưu vào Nhật ký".

---

## 2. Đối Tượng Người Dùng (Target Personas)
1. **Dân Văn Phòng (Office Workers)**: Thường xuyên ăn cơm suất, cơm trưa văn phòng, cơm tấm nhiều món phụ đi kèm.
2. **Người Nấu Ăn & Ăn Cùng Gia Đình (Family Eaters)**: Bữa ăn gồm nhiều đĩa nhỏ đặt trên bàn; muốn ghi nhanh toàn bộ phần ăn của mình trong 1 lần bấm máy.
3. **Người Tập Gym / Eat Clean (Fitness & Dieters)**: Cần kiểm soát chính xác từng thành phần (ví dụ: ăn 150g ức gà nhưng chỉ ăn 80g khoai lang và bỏ bớt cơm trắng).

---

## 3. Luồng Trải Nghiệm Người Dùng (User Journey & Flow)

```
[Mở Camera Quét] 
      │
      ▼
[Chụp Toàn Cảnh Mâm Cơm] ──► [Gemini 2.0 Flash Phân Tích Đa Món] (Latency <= 2.5s)
                                              │
                                              ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ BottomSheet Kết Quả Đa Món (Multi-Item Review Sheet)                        │
│ - Tổng Calo & Tổng Macro Toàn Bữa (Carbs / Fat / Protein)                    │
│ - Danh sách Card từng món con:                                               │
│   [✓] Cơm trắng: 150g (195 kcal) ── Slider chỉnh gram                        │
│   [✓] Sườn nướng: 120g (290 kcal) ── Slider chỉnh gram                      │
│   [✓] Canh cải: 150g (35 kcal) ── Slider chỉnh gram                         │
│   [ ] Canh chua (bỏ chọn nếu không ăn món này)                              │
│ - Nút [+ Thêm món thủ công] (nếu AI bỏ sót)                                 │
└─────────────────────────────────────┬───────────────────────────────────────┘
                                      │
                                      ▼
                        [Chọn Bữa: Trưa / Tối / Sáng]
                                      │
                                      ▼
                      [Bấm "Lưu Bữa Ăn Vào Nhật Ký"]
                                      │
                                      ▼
             [Tạo MealLog kèm mảng dishes[] trên Firestore / Cache]
                                      │
                                      ▼
                  [Cập Nhật Dashboard & Biểu Đồ Calo Tức Thì]
```

---

## 4. Yêu Cầu Chức Năng Chi Tiết (Functional Requirements)

### `FR-MUL-01`: Multi-Item Multimodal Prompting
- Hệ thống xây dựng prompt chuyên biệt gửi tới Google Gemini 2.0 Flash Vision, yêu cầu mô hình:
  1. Quét toàn bộ khung hình, xác định ranh giới các món ăn riêng biệt (tối đa 6 món ăn/bức ảnh).
  2. Bóc tách từng món thành một đối tượng trong mảng `dishes`.
  3. Trả về định dạng JSON nghiêm ngặt có cấu trúc:
     - `food_name`: Tên món ăn tiếng Việt chuẩn.
     - `confidence_score`: Độ tin cậy (0.0 - 1.0).
     - `estimated_weight_g`: Trọng lượng ước tính theo gram.
     - `calories`: Calo tương ứng.
     - `carbs_g`, `fat_g`, `protein_g`: 3 chỉ số đa lượng của từng món con.

### `FR-MUL-02`: Giao Diện Danh Sách Bóc Tách Món Ăn (Multi-Item Dish List)
- Hiển thị danh sách các món ăn con dưới dạng các thẻ (Card) trực quan tuân thủ Celestial Dark UI.
- Mỗi thẻ món ăn hiển thị:
  - Tên món ăn + Badge độ tin cậy.
  - Thanh mini-macro phân bổ Carbs / Fat / Protein của riêng món đó.
  - Slider điều chỉnh trọng lượng linh hoạt từ `20g` đến `800g` (bước nhảy `5g`).
  - Hộp kiểm Checkbox chọn/bỏ chọn (Active/Inactive): Món bị bỏ chọn sẽ bị mờ đi (opacity 0.4) và không được tính vào tổng dinh dưỡng.

### `FR-MUL-03`: Tính Toán Tổng Hợp Tức Thì (Real-Time Reactive Aggregation)
- Bất cứ khi nào người dùng:
  - Kéo slider tăng/giảm trọng lượng của 1 món con.
  - Bật hoặc tắt checkbox của 1 món con.
  - Xóa 1 món con khỏi danh sách.
- Ứng dụng phải tự động tính toán lại tỷ lệ dinh dưỡng theo công thức:
  $$\text{Nutrient}_{\text{new}} = \text{Nutrient}_{\text{base}} \times \left(\frac{\text{Weight}_{\text{new}}}{\text{Weight}_{\text{base}}}\right)$$
- Cập nhật số Calo tổng và biểu đồ Macro tổng ở đỉnh BottomSheet với độ trễ < 16ms (60 FPS, không re-render toàn màn hình).

### `FR-MUL-04`: Thêm Món Bị Bỏ Sót Thủ Công (Add Missing Dish)
- Cung cấp nút `"+ Thêm món"` ở cuối danh sách.
- Khi bấm, mở sheet tìm kiếm nhanh trong cơ sở dữ liệu thực phẩm sẵn có hoặc nhập tay tên món, trọng lượng để ghép vào mâm cơm hiện tại.

### `FR-MUL-05`: Lưu Trữ Bữa Ăn Hợp Nhất (Consolidated Meal Log Storage)
- Khi bấm "Lưu vào Nhật ký", tạo một bản ghi `meal_logs` duy nhất trên Firestore:
  - `dish_name`: Ghép chuỗi các món đã chọn (Ví dụ: *"Cơm tấm, Sườn nướng, Chả trứng"*).
  - `total_calories`, `carbs_g`, `fat_g`, `protein_g`: Tổng giá trị dinh dưỡng của các món được chọn.
  - `dishes`: Mảng lưu trữ chi tiết từng món con phục vụ việc xem lại hoặc chỉnh sửa sau này.

### `FR-MUL-06`: Kịch Bản Fallback Đơn Món (Single-Item Graceful Fallback)
- Nếu ảnh chụp chỉ phát hiện 1 món duy nhất (`dishes.length == 1`):
  - Tự động hiển thị theo bố cục đơn món quen thuộc để không làm rối mắt người dùng.
- Nếu không phát hiện món ăn nào (`isFood == false` hoặc confidence < 0.60):
  - Hiển thị thông báo thân thiện: *"Không nhận diện được rõ các món ăn trên đĩa. Bạn có muốn chụp lại hay nhập thủ công?"*

---

## 5. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

- **Thời gian phản hồi (Performance SLA)**: Tổng thời gian từ lúc bấm chụp đến khi hiển thị kết quả <= 2.5 giây trên mạng 4G/Wifi tiêu chuẩn.
- **Tối ưu hóa ảnh nén (Media Optimization)**: Ảnh chụp được resize tối đa `1024x1024px`, nén JPEG chất lượng 80% (kích thước file < 300KB) trước khi truyền tải qua API.
- **Trải nghiệm thị giác (Celestial Dark UI & 4pt Grid)**:
  - Nền thẻ món ăn: `AppColors.surfaceContainer` (`#112240`).
  - Màu Carbs: `#1A73E8`, Fat: `#FF69B4`, Protein: `#FFD700`.
  - Hiệu ứng chuyển động mượt mà khi thêm/bỏ bớt món ăn.
- **Bảo mật & Phân quyền (Security Rules)**:
  - Bản ghi nhật ký chỉ được đọc/ghi bởi chính `auth.uid` sở hữu.
  - Bắt buộc xác thực hợp lệ qua Firebase App Check.

---

## 6. Phê Duyệt Của Product Owner (Gate 1 Sign-Off)
- **PO**: AstroBite Strategic Product Owner Sub-Agent
- **Trạng thái**: 🟢 **APPROVED (ĐÃ PHÊ DUYỆT CHÍNH THỨC)**
- **Ngày phê duyệt**: 2026-09-18
- **Ý kiến chỉ đạo**: 
  - Đánh giá nghiệp vụ: PRD đạt chất lượng cao, bóc tách đầy đủ các kịch bản thực tế của mâm cơm Việt Nam.
  - Tiêu chí BDD rõ ràng, bảo toàn nguyên tắc màu sắc dinh dưỡng (Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700`).
  - Chuyển giao ngay cho Sub-Agent `ui-ux-designer` để triển khai Gate 2 (`TSK-MUL-02`: UI Flow & Layout 4pt Grid).

