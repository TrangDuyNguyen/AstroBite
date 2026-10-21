# language: vi
Tính năng: Quét ảnh món ăn và hiển thị thẻ dinh dưỡng đa thiết bị
  Với tư cách là người dùng theo dõi calo
  Tôi muốn chụp ảnh món ăn và nhận kết quả phân tích dinh dưỡng chuẩn xác
  Để tôi có thể ghi nhận nhật ký ăn uống nhanh chóng trên mọi thiết bị mà không bị lỗi giao diện

  Bối cảnh:
    Cho rằng người dùng đã đăng nhập vào hệ thống
    Và ứng dụng đã được cấp đầy đủ quyền truy cập Camera
    Và người dùng đang ở màn hình Trang Chủ

  @critical @visual @happy-path
  Kịch bản: Người dùng quét món ăn thành công trên màn hình chuẩn
    Khi người dùng chạm vào tab Camera Scanner trên thanh điều hướng
    Thì màn hình Camera Live Preview hiển thị toàn màn hình
    Và thanh Header không bị lẹm vào cụm Dynamic Island hoặc tai thỏ
    Khi người dùng hướng ống kính vào đĩa "Salad Ức Gà" và nhấn nút "Chụp Ảnh"
    Thì hệ thống hiển thị hiệu ứng Loading Shimmer phân tích trong thời gian không quá 2.5 giây
    Và thẻ kết quả MealCard hiển thị đúng thông số "520 Calo"
    Và mã màu dinh dưỡng khớp chuẩn Design System với Carbs xanh dương, Fat hồng và Protein vàng

  @edge-case @responsive @visual-qa
  Kịch bản: Thẻ dinh dưỡng tự động co giãn khi phóng to cỡ chữ 1.5x trên màn hình nhỏ 375pt
    Cho rằng thiết bị đang hoạt động ở chế độ màn hình nhỏ với chiều rộng 375 điểm ảnh
    Và cài đặt tỉ lệ cỡ chữ hệ thống được kích hoạt ở mức phóng to 1.5 lần
    Khi thẻ kết quả MealCard với tên món dài "Salad Ức Gà Sốt Mè Rang Nhật Bản" được hiển thị
    Thì các thẻ thông số dinh dưỡng tự động xuống dòng mượt mà bằng Wrap layout
    Và giao diện hoàn toàn không xuất hiện vạch sọc vàng đen RenderFlex tràn viền
    Và tên món ăn dài được rút gọn với dấu ba chấm rõ ràng

  @negative @offline @error-state
  Kịch bản: Xử lý ngoại tuyến khi mất kết nối mạng trong lúc quét món ăn
    Cho rằng thiết bị bị mất kết nối Internet hoàn toàn
    Khi người dùng nhấn nút "Chụp Ảnh" để phân tích dinh dưỡng
    Thì ứng dụng không bị đóng đột ngột hoặc văng lỗi Unhandled Exception
    Và màn hình chuyển sang trạng thái Ngoại Tuyến với thông báo nhắc nhở ấm áp
    Và nút "Thử Lại" hiển thị rõ ràng với kích thước chạm đạt tối thiểu 48x48 điểm ảnh
