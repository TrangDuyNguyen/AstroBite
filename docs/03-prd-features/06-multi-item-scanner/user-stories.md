# User Stories & Acceptance Criteria: Multi-Item Food Scanner AI

- **Mã tính năng**: `FEAT-06`
- **Mã Epic liên kết**: `EPIC-06`
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA)
- **Chuẩn kiểm thử**: Gherkin BDD (`Given - When - Then`)
- **Trạng thái**: 🟡 In Review (Gate 1)

---

## US-MUL-01: Quét Đĩa Cơm Nhiều Món và Bóc Tách Độc Lập
- **As a**: Người dùng AstroBite ăn trưa ở quán cơm văn phòng
- **I want to**: Chụp 1 bức ảnh toàn cảnh đĩa cơm gồm cơm trắng, thịt kho và rau xào
- **So that**: Ứng dụng tự động nhận diện và bóc tách từng món ăn riêng biệt kèm calo và macro của từng món mà tôi không phải chụp từng đĩa một.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Nhận diện thành công khay cơm 3 món (Happy Path)
- **Given**: Tôi đang ở màn hình Scanner và hướng camera vào một khay cơm gồm: "Cơm trắng", "Thịt ba chỉ kho trứng", và "Rau muống xào tỏi"
- **When**: Tôi bấm nút chụp ảnh
- **Then**: Hệ thống hiển thị vòng xoay quét Celestial Shimmer Loader trong thời gian dưới 2.5 giây
- **And**: BottomSheet kết quả xuất hiện hiển thị:
  - Header tổng quan: Tổng calo ~680 kcal, Carbs ~80g, Protein ~28g, Fat ~25g
  - Thẻ 1: "Cơm trắng" — 180g — 234 kcal (Confidence: 94%)
  - Thẻ 2: "Thịt ba chỉ kho trứng" — 150g — 380 kcal (Confidence: 89%)
  - Thẻ 3: "Rau muống xào tỏi" — 100g — 66 kcal (Confidence: 87%)
- **And**: Cả 3 thẻ đều được đánh dấu tích chọn `[✓]` mặc định.

#### Scenario 2: Nhận diện đĩa cơm có 4-5 món phức tạp
- **Given**: Tôi chụp một đĩa cơm tấm đặc biệt gồm: Cơm tấm, Sườn nướng, Chả trứng, Bì heo, Dưa leo cà chua
- **When**: Gemini 2.0 Flash Vision hoàn tất phân tích
- **Then**: Danh sách hiển thị đủ 5 thẻ món ăn con có thanh trượt cuộn dọc mượt mà
- **And**: Tổng calo bằng đúng tổng calo của 5 món cộng lại.

---

## US-MUL-02: Bỏ Chọn Món Không Ăn (Unselect Item)
- **As a**: Người dùng đang trong chế độ ăn kiêng Low-Carb / Keto
- **I want to**: Bỏ tích chọn phần "Cơm trắng" trên khay cơm vừa quét
- **So that**: Calo và lượng Carbs của cơm trắng không bị cộng vào tổng nhật ký của tôi.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Bỏ chọn 1 món và tự động cập nhật tổng calo
- **Given**: BottomSheet hiển thị 3 món: "Cơm trắng (234 kcal)", "Thịt kho (380 kcal)", "Rau muống (66 kcal)" với tổng 680 kcal
- **When**: Tôi bấm bỏ tích chọn hộp kiểm `[ ]` tại thẻ "Cơm trắng"
- **Then**: Thẻ "Cơm trắng" chuyển sang trạng thái mờ (Opacity 40%, xám màu)
- **And**: Tổng calo toàn bữa lập tức giảm từ 680 kcal xuống còn 446 kcal
- **And**: Thanh MacroBar điều chỉnh ngay lập tức: Lượng Carbs giảm tương ứng, màu xanh Carbs `#1A73E8` thu hẹp lại
- **And**: Bản ghi khi lưu sẽ chỉ tính 2 món còn lại.

#### Scenario 2: Bật lại món đã bỏ chọn
- **Given**: Thẻ "Cơm trắng" đang bị bỏ chọn
- **When**: Tôi bấm tích chọn lại `[✓]`
- **Then**: Thẻ "Cơm trắng" phục hồi độ sáng bình thường
- **And**: Tổng calo và thanh MacroBar được cộng dồn trở lại như ban đầu.

---

## US-MUL-03: Tùy Chỉnh Khẩu Phần Riêng Từng Món (Per-Dish Portion Adjustment)
- **As a**: Người dùng AstroBite
- **I want to**: Kéo thanh trượt điều chỉnh gram cho riêng món "Thịt kho" từ 150g xuống 100g
- **So that**: Nhật ký dinh dưỡng phản ánh chính xác lượng thịt tôi thực sự ăn mà không ảnh hưởng tới định lượng của món cơm và rau.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Điều chỉnh trọng lượng một món thành phần
- **Given**: Thẻ "Thịt ba chỉ kho trứng" đang hiển thị 150g (380 kcal)
- **When**: Tôi kéo slider của thẻ này xuống mức 100g
- **Then**: Số hiển thị trên thẻ cập nhật thành: 100g — 253 kcal
- **And**: Các chỉ số Carbs, Fat, Protein của riêng thẻ đó giảm tương ứng theo tỷ lệ $100 / 150$
- **And**: Tổng calo và Macro của cả bữa ăn ở đỉnh màn hình tự động cập nhật tức thì.

#### Scenario 2: Kéo slider chạm ngưỡng tối thiểu hoặc tối đa
- **Given**: Tôi điều chỉnh slider của món rau
- **When**: Tôi kéo xuống mức tối thiểu (20g) hoặc tối đa (800g)
- **Then**: Slider dừng lại tại điểm biên, không cho phép kéo về số âm hoặc số 0 (nếu muốn 0g, người dùng bấm bỏ chọn hoặc xóa món).

---

## US-MUL-04: Bổ Sung Món Ăn Bị AI Bỏ Sót (Add Missing Dish)
- **As a**: Người dùng AstroBite
- **I want to**: Thêm thủ công 1 chén nước mắm hoặc 1 ly trà đá vào bữa ăn đa món
- **So that**: Bữa ăn của tôi được ghi nhận trọn vẹn ngay cả khi AI không nhận diện được món nước/gia vị phụ.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Thêm món từ danh bạ thực phẩm
- **Given**: BottomSheet kết quả đa món đang mở
- **When**: Tôi bấm vào nút `"+ Thêm món"` ở cuối danh sách
- **Then**: Hệ thống mở hộp thoại tìm kiếm nhanh
- **When**: Tôi nhập "Canh chua cá" và chọn từ kết quả tìm kiếm với định lượng 200g
- **Then**: Thẻ "Canh chua cá" (200g, 90 kcal) được thêm vào danh sách các món của bữa ăn
- **And**: Tổng calo và Macro của bữa ăn tự động cộng thêm 90 kcal.

---

## US-MUL-05: Xử Lý Ngoại Lệ & Fallback Thông Minh (Edge Cases & Fallbacks)
- **As a**: Người dùng AstroBite
- **I want to**: Nhận được hướng dẫn rõ ràng khi chụp ảnh không đạt yêu cầu
- **So that**: Tôi không cảm thấy bực bội hay gặp lỗi crash ứng dụng.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Ảnh chỉ có 1 món ăn duy nhất
- **Given**: Tôi chụp một bát "Phở Bò" đơn lẻ
- **When**: Gemini 2.0 Flash trả về kết quả chỉ có 1 món (`dishes.length == 1`)
- **Then**: Hệ thống tự động chuyển đổi sang giao diện xem đơn món (Single-item view) quen thuộc, không hiển thị giao diện danh sách thẻ phức tạp.

#### Scenario 2: Ảnh chụp trong điều kiện quá tối hoặc không phải đồ ăn
- **Given**: Tôi chụp bàn làm việc hoặc chụp trong điều kiện thiếu sáng nghiêm trọng
- **When**: AI phản hồi `isFood == false` hoặc độ tin cậy của tất cả các món < 60%
- **Then**: Hệ thống hiển thị cảnh báo Celestial Alert: *"Không nhận diện rõ các món ăn trên đĩa. Bạn có muốn chụp lại ở góc sáng hơn hoặc nhập tên món thủ công?"*
- **And**: Cung cấp 2 nút hành động: `"Chụp Lại"` và `"Nhập Thủ Công"`.

#### Scenario 3: Mất kết nối internet khi đang gửi ảnh
- **Given**: Tôi chụp ảnh món ăn khi vừa bước vào thang máy (mất sóng mạng)
- **When**: Yêu cầu gọi API Gemini bị timeout (> 10 giây) hoặc báo lỗi No Internet
- **Then**: Hệ thống thông báo: *"Không thể kết nối với AI Scanner. Ảnh đã được lưu tạm vào máy, bạn có thể thử lại sau hoặc nhập thủ công ngay."*
- **And**: Ứng dụng không bị đứng hình hoặc crash.
