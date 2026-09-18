# PRD: Theo Dõi Vi Chất Dinh Dưỡng Nâng Cao (Micronutrients Tracking: Natri, Chất Xơ, Đường)

- **Mã tính năng**: `FEAT-08`
- **Mã Epic liên kết**: `EPIC-08` (Micronutrient Tracking)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA)
- **Trạng thái**: 🟢 **Approved (Gate 1 Sign-off Đã Phê Duyệt)**
- **Mục tiêu phiên bản**: `v1.1.0` (Sprint 02)
- **Đối chiếu UI/UX**: `docs/03-prd-features/08-micronutrients-tracking/ui-ux-design-spec.md` (Gate 2)
- **Đối chiếu QA**: `tests/02-manual-testcases/08-micronutrients-tracking/` & `tests/03-bdd-gherkin-scenarios/micronutrients_tracking.feature` (Gate 3)
- **Đối chiếu FE**: `lib/features/tracker/` & `lib/features/scanner/` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
- Tại phiên bản `v1.0.0`, AstroBite theo dõi 3 đại lượng Macro căn bản (Carbs, Fat, Protein) và tổng Calo.
- Tuy nhiên, nhiều nhóm người dùng có mối quan tâm chuyên sâu về sức khỏe tim mạch, chuyển hóa và tiêu hóa:
  - **Người cao huyết áp / Tim mạch**: Bắt buộc phải kiểm soát lượng muối/Natri (Sodium nạp vào dưới 2,000 - 2,300 mg/ngày). Thức ăn đường phố và món kho Việt Nam thường có lượng muối rất cao.
  - **Người ăn kiêng Eat Clean / Bệnh tiểu đường / Tiền tiểu đường**: Cần kiểm soát lượng đường tự do (Free Sugar < 25g - 36g/ngày) để tránh tích mỡ và kháng insulin.
  - **Người giảm cân / Gymers / Người gặp vấn đề tiêu hóa**: Cần đảm bảo đủ lượng chất xơ (Fiber >= 25g - 38g/ngày) để duy trì cảm giác no lâu và hệ vi sinh đường ruột khỏe mạnh.
- **Nỗi đau**: Việc thiếu 3 chỉ số này khiến người dùng cảm thấy AstroBite chỉ là công cụ tính calo đơn thuần, chưa đủ sâu sắc để cải thiện sức khỏe toàn diện.

### 1.2. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (KPIs & Metrics)
- **Bao phủ dữ liệu vi chất 100%**: 100% các món ăn nhận diện từ Gemini 2.0 Flash Vision và danh bạ thực phẩm có sẵn đều được trích xuất 3 chỉ số vi chất: Natri (mg), Chất xơ (g), Đường (g).
- **Tỷ lệ người dùng tương tác với khối vi chất**: Đạt >= 40% người dùng tích cực xem khối Micronutrients trên Diary.
- **Cảnh báo an toàn chính xác 100%**: Phát hiện và cảnh báo kịp thời khi người dùng nạp món ăn có Natri > 800mg hoặc tổng Natri trong ngày vượt 2,300mg theo khuyến nghị của Tổ chức Y tế Thế giới (WHO).

---

## 2. Đối Tượng Người Dùng (Target Personas)
1. **Người Quan Tâm Sức Khỏe Tim Mạch (Cardio & Blood Pressure Watchers)**: Cần theo dõi sát sao lượng Natri/muối trong đồ ăn ngoài hàng quán.
2. **Người Ăn Kiêng Eat Clean & Cắt Giảm Đường (Sugar Conscious & Low Sugar Dieters)**: Tìm kiếm các bữa ăn ít đường tinh luyện để giữ dáng và phòng bệnh chuyển hóa.
3. **Người Cần Cải Thiện Tiêu Hóa (Gut Health & High Fiber Seekers)**: Muốn biết mình đã ăn đủ lượng rau củ chất xơ trong ngày hay chưa.

---

## 3. Quy Chuẩn Khoa Học & Ngưỡng Khuyến Nghị (Nutritional Benchmarks)

Dựa trên tiêu chuẩn của **Tổ chức Y tế Thế giới (WHO)** và **Viện Dinh Dưỡng Quốc Gia**:

| Vi Chất Dinh Dưỡng | Đơn Vị | Ngưỡng Khuyến Nghị Hàng Ngày | Mức Cảnh Báo An Toàn | Quy Tắc Màu Sắc Giao Diện |
| :--- | :---: | :---: | :---: | :---: |
| **Natri (Sodium)** | `mg` | Tối đa **2,300 mg/ngày** | Vượt > 2,300 mg (hoặc 1 món > 800 mg) | 🟢 < 1,800 mg: Bình thường<br>🟡 1,800 - 2,300 mg: Tiệm cận ngưỡng<br>🔴 > 2,300 mg: Vượt ngưỡng an toàn |
| **Chất Xơ (Fiber)** | `g` | Tối thiểu **25g (Nữ) / 38g (Nam)** | Chưa đạt 50% mục tiêu sau 18:00 | 🟡 < 15g: Cần bổ sung thêm rau xanh<br>🟢 >= 25g: Đạt chuẩn khuyến nghị |
| **Đường (Sugar)** | `g` | Tối đa **25g (Nữ) / 36g (Nam)** | Vượt ngưỡng khuyến nghị WHO | 🟢 < 25g: An toàn<br>🟡 25 - 36g: Cận biên<br>🔴 > 36g: Vượt mức khuyến nghị |

---

## 4. Yêu Cầu Chức Năng Chi Tiết (Functional Requirements)

### `FR-MIC-01`: Mở Rộng Gemini Vision Output Với Vi Chất
- Chỉ thị trong Gemini 2.0 Flash Vision Prompt được mở rộng để bắt buộc trích xuất 3 chỉ số vi chất:
  ```json
  {
    "sodium_mg": 450,
    "fiber_g": 3.5,
    "sugar_g": 2.0
  }
  ```
- Nếu món ăn không chứa vi chất đó (ví dụ dầu ăn tinh khiết không có xơ hay đường), trả về `0.0` (không trả về null).

### `FR-MIC-02`: Hiển Thị Micronutrient Chips Trên Kết Quả Quét & Chi Tiết Món
- Trong BottomSheet kết quả nhận diện món ăn (cả đơn món và đa món):
  - Hiển thị một cụm 3 Chip vi chất nhỏ gọn (Micronutrient Chips Row):
    - Chip 1: `Muối / Natri: 450mg`
    - Chip 2: `Chất xơ: 3.5g`
    - Chip 3: `Đường: 2.0g`
  - Nếu người dùng điều chỉnh thanh trượt gram của món ăn, 3 chỉ số vi chất tự động tính toán lại theo tỷ lệ gram tương ứng.

### `FR-MIC-03`: Khối Tổng Hợp Vi Chất Hàng Ngày Trên Màn Hình Diary
- Trên màn hình Nhật Ký (Diary Screen), bổ sung một thẻ Card mở rộng (Expandable Card):
  - Tiêu đề: *"Vi Chất Dinh Dưỡng Hôm Nay"*
  - 3 thanh đo tiến độ thanh mảnh (Progress Bars):
    1. **Natri (Sodium)**: `... / 2300 mg` (thanh đo chuyển từ Xanh sang Cam khi chạm 80% và sang Đỏ khi vượt 100%).
    2. **Chất xơ (Fiber)**: `... / 25g` (thanh đo màu ngọc bích lấp đầy khi đạt chỉ tiêu).
    3. **Đường (Sugar)**: `... / 36g` (thanh đo cảnh báo khi vượt ngưỡng).

### `FR-MIC-04`: Hệ Thống Cảnh Báo Ngưỡng Vi Chất Thông Minh (Smart Micronutrient Alerts)
- **Cảnh báo cấp độ món (Per-Meal Warning)**:
  - Nếu 1 món ăn có `sodium_mg >= 800mg`: Hiển thị icon cảnh báo màu vàng cạnh tên món kèm tooltip: *"Món ăn có hàm lượng muối cao (>1/3 nhu cầu cả ngày)."*
  - Nếu 1 món ăn có `sugar_g >= 20g`: Cảnh báo: *"Chứa lượng đường cao."*
- **Cảnh báo cấp độ ngày (Daily Warning Banner)**:
  - Khi tổng lượng Natri trong ngày vượt 2,300mg: Thẻ vi chất trên Diary hiển thị badge cảnh báo: *"Hôm nay bạn đã nạp quá lượng Natri khuyến nghị."*

### `FR-MIC-05`: Lưu Trữ & Tương Thích Ngược (Storage & Backward Compatibility)
- Bổ sung 3 trường `sodium_mg`, `fiber_g`, `sugar_g` vào thực thể `FoodLog` và `DishItem`.
- **Tương thích ngược tuyệt đối**:
  - Đối với các bản ghi `meal_logs` cũ từ phiên bản `v1.0.0` (chưa có 3 trường này):
  - Hệ thống tự động gán giá trị mặc định là `0.0` khi đọc từ Firestore/Cache, bảo đảm không bao giờ gây lỗi parse JSON hoặc null exception.

---

## 5. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

- **Hiệu năng hiển thị (UI Rendering)**:
  - Việc hiển thị thêm khối vi chất không làm giảm tốc độ cuộn của màn hình Diary (duy trì 60 FPS mượt mà).
- **Trải nghiệm hình ảnh (Celestial Dark Aesthetics)**:
  - Màu Natri an toàn: `#00E5FF` (Cyan Celestial), cảnh báo vượt ngưỡng: `#FF5252` (Red Alert).
  - Màu Chất xơ: `#00E676` (Emerald Green).
  - Màu Đường an toàn: `#E0E0E0`, vượt ngưỡng: `#FF9100` (Amber Alert).
  - Không phá vỡ quy chuẩn bất biến của 3 màu Macro chính (Carbs: `#1A73E8`, Fat: `#FF69B4`, Protein: `#FFD700`).

---

## 6. Phê Duyệt Của Product Owner (Gate 1 Sign-Off)
- **PO**: AstroBite Strategic Product Owner Sub-Agent
- **Trạng thái**: 🟢 **APPROVED (ĐÃ PHÊ DUYỆT CHÍNH THỨC)**
- **Ngày phê duyệt**: 2026-09-18
- **Ý kiến chỉ đạo**: 
  - Đánh giá nghiệp vụ: Lựa chọn 3 vi chất Natri, Xơ, Đường là rất đúng trọng tâm nhu cầu người dùng Eat Clean và bảo vệ tim mạch, bám sát khuyến nghị WHO.
  - Tương thích ngược bảo đảm an toàn cho các bản ghi cũ của phiên bản v1.0.0.
  - Chuyển giao ngay cho Sub-Agent `ui-ux-designer` để triển khai Gate 2 (`TSK-MIC-02`: Thiết kế UI Chips vi chất & Thanh đo tiến độ).

