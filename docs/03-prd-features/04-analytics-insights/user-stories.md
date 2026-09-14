# User Stories & Acceptance Criteria: Analytics & Insights

## US-06: Xem Biểu Đồ Xu Hướng Calo 7 Ngày Gần Nhất
- **As a**: Người dùng AstroBite
- **I want to**: Xem biểu đồ đường so sánh calo từng ngày với mục tiêu hàng ngày
- **So that**: Tôi đánh giá được tuần vừa qua mình ăn thừa hay thiếu calo

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Xem biểu đồ tuần thành công**
  - **Given**: Tôi đã ghi nhận nhật ký liên tục trong 7 ngày
  - **When**: Tôi chuyển sang tab "Báo cáo" và chọn bộ lọc "7 ngày"
  - **Then**: Hệ thống vẽ biểu đồ đường FlChart với 7 điểm dữ liệu
  - **And**: Các điểm vượt mục tiêu có chấm tròn màu Vàng Tertiary, các điểm dưới mục tiêu có chấm tròn màu Xanh Primary
  - **And**: Chạm vào bất kỳ điểm nào sẽ hiển thị tooltip chi tiết số calo của ngày đó

---

## US-07: Xem Phân Bổ Tỷ Lệ Đa Lượng (Macro Breakdown)
- **As a**: Người tập thể hình
- **I want to**: Xem biểu đồ hình tròn tỷ lệ Carbs/Fat/Protein thực tế của tuần
- **So that**: Tôi biết mình có nạp đủ lượng Protein cần thiết để phát triển cơ bắp không

### Acceptance Criteria (Given - When - Then)
- **Given**: Tôi đang ở màn hình Báo cáo
- **When**: Tôi xem phần "Phân Bổ Macro"
- **Then**: Biểu đồ hình tròn Donut hiển thị 3 cung màu: Carbs (`#1A73E8`), Fat (`#FF69B4`), Protein (`#FFD700`)
- **And**: Hiển thị tỷ lệ phần trăm và tổng số gram tương ứng bên dưới biểu đồ
