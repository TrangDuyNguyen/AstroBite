# User Stories & Acceptance Criteria: Micronutrients Tracking

- **Mã tính năng**: `FEAT-08`
- **Mã Epic liên kết**: `EPIC-08`
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA)
- **Chuẩn kiểm thử**: Gherkin BDD (`Given - When - Then`)
- **Trạng thái**: 🟡 In Review (Gate 1)

---

## US-MIC-01: Xem Thông Tin Vi Chất Khi Quét Món Ăn Bằng AI
- **As a**: Người dùng quan tâm đến chế độ ăn ít muối
- **I want to**: Xem ngay lượng Natri (muối), Chất xơ và Lượng đường khi quét một món ăn
- **So that**: Tôi đánh giá được món ăn có phù hợp với mục tiêu sức khỏe của mình hay không.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Hiển thị 3 chỉ số vi chất trên BottomSheet kết quả (Happy Path)
- **Given**: Tôi quét một đĩa "Cá hồi áp chảo măng tây"
- **When**: Gemini 2.0 Flash Vision phân tích xong
- **Then**: BottomSheet kết quả hiển thị hàng Chips vi chất dinh dưỡng:
  - Chip Natri: "Natri: 320 mg"
  - Chip Chất xơ: "Chất xơ: 4.2 g"
  - Chip Đường: "Đường: 1.5 g"
- **And**: Cả 3 chip hiển thị màu sắc trung tính Celestial dịu nhẹ.

#### Scenario 2: Điều chỉnh gram làm thay đổi tự động vi chất
- **Given**: Món "Cá hồi áp chảo măng tây" ban đầu có trọng lượng 200g và Natri là 320mg
- **When**: Tôi kéo slider tăng trọng lượng lên 300g
- **Then**: Chip Natri tự động tính lại tỷ lệ $320 \times (300 / 200) = 480\text{ mg}$
- **And**: Chất xơ tăng lên $4.2 \times 1.5 = 6.3\text{ g}$, Đường tăng lên $1.5 \times 1.5 = 2.25\text{ g}$.

---

## US-MIC-02: Cảnh Báo Khi Món Ăn Có Hàm Lượng Natri Quá Cao
- **As a**: Người dùng có tiền sử tăng huyết áp
- **I want to**: Được ứng dụng cảnh báo khi một món ăn chứa hàm lượng muối/Natri cao vượt mức an toàn
- **So that**: Tôi có thể cân nhắc giảm bớt nước chấm hoặc không húp hết nước dùng.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Quét món có lượng Natri vượt ngưỡng 800mg (Edge Case Warning)
- **Given**: Tôi chụp một bát "Mì tôm lẩu thái đặc biệt"
- **When**: AI phân tích và trả về lượng Natri là `1450 mg` (vượt 60% hạn mức cả ngày)
- **Then**: Chip Natri chuyển sang màu cam cảnh báo (Amber Alert `#FF9100`)
- **And**: Xuất hiện một biểu tượng cảnh báo hình tam giác nhẹ bên cạnh
- **And**: Chú thích hiển thị bên dưới: *"Món ăn chứa lượng muối khá cao (1450 mg). Nên hạn chế uống hết nước dùng để bảo vệ huyết áp."*

---

## US-MIC-03: Theo Dõi Tổng Lượng Vi Chất Hàng Ngày Trên Diary
- **As a**: Người dùng AstroBite theo đuổi lối sống Eat Clean
- **I want to**: Xem tổng hợp lượng Natri, Xơ và Đường của tất cả các bữa ăn trong ngày
- **So that**: Tôi biết hôm nay mình đã ăn đủ rau củ và có ăn quá nhiều đường hay không.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Xem thẻ vi chất trên màn hình Nhật Ký (Diary)
- **Given**: Tôi đã ghi nhận 3 bữa ăn (Sáng, Trưa, Tối) với tổng cộng: 1600mg Natri, 28g Xơ, 22g Đường
- **When**: Tôi cuộn xem màn hình Diary
- **Then**: Thẻ "Vi Chất Dinh Dưỡng Hôm Nay" hiển thị:
  - Thanh Natri: `1,600 / 2,300 mg` — Màu xanh Cyan (Trong ngưỡng an toàn)
  - Thanh Chất xơ: `28 / 25 g` — Màu xanh Emerald (Đã đạt mục tiêu khuyến nghị) kèm icon ngôi sao
  - Thanh Đường: `22 / 36 g` — Màu xám sáng (Trong mức kiểm soát)
- **And**: Không có cảnh báo tiêu cực nào xuất hiện.

#### Scenario 2: Vượt ngưỡng Natri khuyến nghị trong ngày
- **Given**: Sau bữa tối, tổng lượng Natri trong ngày của tôi chạm mức `2,450 mg` (vượt ngưỡng 2,300mg)
- **When**: Tôi xem thẻ vi chất trên Diary
- **Then**: Thanh đo Natri chuyển sang màu đỏ rực (Red Alert `#FF5252`)
- **And**: Hiển thị badge: *"Vượt ngưỡng khuyến nghị (2,450 / 2,300 mg)"* để nhắc nhở tôi uống nhiều nước hơn.

---

## US-MIC-04: Tương Thích Ngược Bản Ghi Cũ (Backward Compatibility)
- **As a**: Người dùng đã sử dụng ứng dụng từ phiên bản v1.0.0
- **I want to**: Xem lại các ngày ăn trong quá khứ mà không gặp lỗi ứng dụng
- **So that**: Lịch sử ăn uống của tôi được bảo tồn toàn vẹn.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Mở nhật ký của ngày thuộc phiên bản cũ v1.0.0
- **Given**: Ngày 15/09/2026 được ghi ở phiên bản v1.0.0 (không có các trường `sodium_mg`, `fiber_g`, `sugar_g`)
- **When**: Tôi chọn ngày 15/09/2026 trên Diary
- **Then**: Ứng dụng parse dữ liệu bình thường, tự động điền giá trị `0` cho các vi chất
- **And**: Tuyệt đối không xảy ra lỗi Null Pointer Exception hay crash app.
