# language: vi
Tính năng: Custom Recipes & Meal Planning Architecture (FEAT-17)
  Là một người dùng AstroBite theo đuổi chế độ ăn kiêng và chuẩn bị đồ ăn tại nhà
  Tôi muốn tạo công thức món ăn tùy biến, co giãn khẩu phần và lên lịch bữa ăn hàng tuần
  Để tôi có thể ghi nhật ký ăn uống chỉ với 1 chạm mà không mất thời gian nhập lại từng món

  Bối cảnh:
    Có người dùng đã đăng nhập với ID "user_test_01"
    Và mục tiêu dinh dưỡng hôm nay là 2000 kcal, 200g Carbs, 150g Protein, 65g Fat
    Và người dùng đang mở ứng dụng AstroBite với giao diện Celestial Dark UI

  @happy @us01
  Kịch bản: Tạo thành công công thức món ăn mới với bộ tính toán Macro tự động
    Cho người dùng đang ở màn hình "Tạo Công Thức Mới"
    Khi người dùng nhập tên công thức là "Salad Ức Gà Quinoa"
    Và thêm nguyên liệu "Ức gà áp chảo" với khối lượng 150 gram
    Và thêm nguyên liệu "Quinoa nấu chín" với khối lượng 100 gram
    Thì hệ thống tự động tổng hợp giá trị dinh dưỡng theo thời gian thực:
      | Chỉ số | Giá trị mong đợi | Màu sắc ngữ nghĩa |
      | Tổng calo | 367.5 kcal | Trắng/Cam nổi bật |
      | Carbohydrates | 21.3 g | #1A73E8 (Electric Blue) |
      | Protein | 50.9 g | #FFD700 (Cosmic Gold) |
      | Fat | 7.3 g | #FF69B4 (Hot Pink) |
    Khi người dùng nhấn nút "Lưu Công Thức"
    Thì bản ghi công thức được lưu thành công vào cơ sở dữ liệu
    Và hệ thống hiển thị thông báo "✓ Đã lưu công thức Salad Ức Gà Quinoa"
    Và đóng màn hình tạo, cập nhật vào danh bạ công thức cá nhân.

  @negative @validation @us01
  Kịch bản: Chặn lưu công thức khi để trống tên hoặc danh sách nguyên liệu rỗng
    Cho người dùng đang ở màn hình "Tạo Công Thức Mới"
    Khi người dùng nhập tên là "   " hoặc không thêm bất kỳ nguyên liệu nào
    Và người dùng nhấn nút "Lưu Công Thức"
    Thì hệ thống từ chối thực hiện lệnh ghi
    Và hiển thị viền cảnh báo màu đỏ "#FFB4AB" tại trường thông tin chưa hợp lệ
    Và hiển thị SnackBar cảnh báo: "Vui lòng nhập tên công thức và ít nhất 1 nguyên liệu!"
    Và ứng dụng không phát sinh lỗi ngoại lệ unhandled.

  @concurrency @security @us01
  Kịch bản: Ngăn chặn spam click nút Lưu tạo trùng lặp bản ghi
    Cho người dùng đã điền đầy đủ thông tin công thức "Salad Ức Gà Quinoa" hợp lệ
    Khi người dùng nhấn liên tục 5 lần vào nút "Lưu Công Thức" trong vòng 300 mili-giây
    Thì hệ thống áp dụng cơ chế debounce
    Và chỉ gửi duy nhất 1 yêu cầu lưu trữ đến cơ sở dữ liệu
    Và không sinh ra các bản ghi trùng lặp (duplicate IDs) trong danh bạ.

  @portion @us02
  Kịch bản: Co giãn khẩu phần động từ 1x sang 2x và 0.5x
    Cho người dùng đang xem chi tiết công thức "Salad Ức Gà Quinoa" có khẩu phần chuẩn 1x
    Khi người dùng nhấn chọn chip khẩu phần "2x"
    Thì trọng lượng hiển thị của từng nguyên liệu tự động nhân đôi:
      | Tên nguyên liệu | Trọng lượng sau khi scale 2x |
      | Ức gà áp chảo | 300 gram |
      | Quinoa nấu chín | 200 gram |
    Và tổng calo hiển thị tương ứng là 735 kcal
    Và tỷ lệ phần trăm giữa 3 chất đa lượng Protein, Carbs, Fat được bảo toàn nguyên vẹn
    Khi người dùng nhấn chọn chip khẩu phần "0.5x"
    Thì trọng lượng Ức gà hiển thị là 75 gram và Quinoa là 50 gram
    Và tổng calo hiển thị là 183.8 kcal.

  @mealplan @us03
  Kịch bản: Lập kế hoạch bữa ăn trên lịch tuần 7 ngày
    Cho người dùng đang ở màn hình "Kế Hoạch Bữa Ăn" (Meal Planner)
    Khi người dùng chọn ngày mai trên thanh trượt lịch 7 ngày
    Và nhấn nút "+" tại khung "Bữa Trưa"
    Và chọn công thức "Salad Ức Gà Quinoa"
    Thì món ăn được gán vào Bữa Trưa của ngày mai
    Và thẻ kế hoạch hiển thị tên món, 367 kcal và badge phân loại Recipe
    Và thanh tổng calo dự kiến của ngày mai được cập nhật tự động.

  @1tap @performance @us04
  Kịch bản: Ghi nhật ký ăn uống 1 chạm từ bữa ăn đã lên kế hoạch (SLA <= 100ms)
    Cho người dùng có món "Salad Ức Gà Quinoa" đã lên lịch cho Bữa Trưa hôm nay
    Khi người dùng nhấn nút "✓ Ghi Vào Nhật Ký"
    Thì hệ thống phản hồi Optimistic Update trong vòng dưới 100 mili-giây
    Và thẻ kế hoạch chuyển trạng thái sang huy hiệu "Đã Ăn (✓ Logged)"
    Và một bản ghi MealLog mới được tạo trong nhật ký ăn uống với đầy đủ dinh dưỡng của công thức
    Và tổng calo và macro trên Home Cockpit được cập nhật tức thì
    Và nút bấm bị vô hiệu hóa để ngăn chặn ghi đúp lần 2.

  @offline @resilience @us04
  Kịch bản: Ghi nhật ký 1 chạm khi thiết bị mất mạng (Offline Mode)
    Cho thiết bị đang ở chế độ máy bay (Airplane Mode)
    Khi người dùng nhấn nút "✓ Ghi Vào Nhật Ký" trên thẻ kế hoạch hôm nay
    Thì hệ thống lưu dữ liệu vào bộ nhớ đệm cục bộ (Pending Queue)
    Và thẻ hiển thị trạng thái "Đã Ăn (Chờ đồng bộ ☁️)"
    Và không xảy ra lỗi gián đoạn hoặc crash ứng dụng
    Khi thiết bị kết nối mạng Internet trở lại
    Thì dữ liệu trong hàng đợi tự động đồng bộ lên máy chủ Cloud Firestore trong nền.
