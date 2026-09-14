# User Stories & Acceptance Criteria: Food Scanner AI

## US-03: Chụp Ảnh Quét Dinh Dưỡng Bằng AI
- **As a**: Người dùng AstroBite
- **I want to**: Chụp ảnh món ăn đang chuẩn bị ăn
- **So that**: Tôi biết ngay lập tức món ăn đó có bao nhiêu calo, carbs, fat và protein mà không cần tra cứu danh bạ thực phẩm

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Nhận diện thành công món ăn phổ biến**
  - **Given**: Tôi mở màn hình Scanner và hướng camera vào một đĩa "Cơm gà xối mỡ"
  - **When**: Tôi nhấn nút chụp ảnh
  - **Then**: Ứng dụng hiển thị hiệu ứng quét laser đang phân tích (Shimmering Skeleton Loader)
  - **And**: Trong vòng 3 giây, BottomSheet kết quả xuất hiện:
    - Tên món: "Cơm gà xối mỡ" (Độ tin cậy > 85%)
    - Trọng lượng ước tính: 400g
    - Calo: ~650 kcal, Carbs: ~75g, Protein: ~35g, Fat: ~22g
  - **And**: Cho phép tôi chọn bữa ăn (Trưa/Tối) và lưu vào nhật ký

- **Scenario 2: Điều chỉnh lại khẩu phần thực tế**
  - **Given**: Kết quả AI gợi ý món ăn có khẩu phần 400g
  - **When**: Tôi kéo slider trọng lượng từ 400g xuống 300g
  - **Then**: Hệ thống tự động tính toán lại tỷ lệ calo, carbs, fat, protein tương ứng tỷ lệ 75%
  - **And**: Nút "Lưu vào Nhật ký" hiển thị giá trị calo cập nhật mới

- **Scenario 3: Ảnh không rõ món hoặc thiếu sáng**
  - **Given**: Tôi chụp ảnh trong bóng tối hoặc món ăn bị che khuất
  - **When**: AI phản hồi độ tin cậy < 60%
  - **Then**: Hệ thống hiển thị cảnh báo: *"Không nhận diện rõ món ăn. Bạn có muốn nhập tên món thủ công?"* kèm nút "Nhập thủ công".
