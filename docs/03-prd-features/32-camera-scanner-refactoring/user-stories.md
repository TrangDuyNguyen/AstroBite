# User Stories (BDD Gherkin) — Sprint 25: Camera Scanner Pipeline

### Feature: Camera & Viewfinder Scanner Pipeline (Modular Architecture)

#### Scenario: Người dùng xem số lượt quét hôm nay
  Given Người dùng mở màn hình CameraPage
  When Kiểm tra thông tin quota hôm nay
  Then Huy hiệu CameraQuotaBadge hiển thị số lượt quét còn lại (Ví dụ: "Còn lại 9/10 lượt quét hôm nay")
  And Nếu đã hết lượt quét, huy hiệu chuyển sang màu đỏ cảnh báo

#### Scenario: Người dùng mở bảng mẹo chụp ảnh
  Given Người dùng ở CameraPage
  When Nhấn vào nút "?" trên thanh AppBar
  Then Modal bottom sheet CameraScanningTipsSheet mở lên với 3 mẹo chụp ảnh
  And Khi nhấn "Đã hiểu", bottom sheet tự động đóng lại

#### Scenario: Quét thành công và hiển thị nhãn Holographic
  Given Quá trình quét ảnh định vị được món ăn "Phở Bò Tái"
  When Viewfinder cập nhật detectedDishName = "Phở Bò Tái" và detectedCalories = 450
  Then Thẻ ViewfinderDetectedTag hiển thị nổi bên dưới khung ngắm
  And Kèm huy hiệu "AI VERIFIED" màu xanh lá và chip 450 kcal
