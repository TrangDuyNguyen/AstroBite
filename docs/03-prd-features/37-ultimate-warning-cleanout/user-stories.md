# User Stories BDD: Sprint 30 — Ultimate Warning Cleanout (v3.10.0)

## Story 1: Guild Mock Data Separation
**Given** Guild Repository đang chạy trong môi trường phát triển / demo,  
**When** Repository được khởi tạo với cờ `seedDefaultData = true`,  
**Then** Dữ liệu mẫu ban đầu được tải từ `GuildMockSeeds` mà không làm phình to file repository chính.

## Story 2: Auth Zero Gravity Decoupling
**Given** Người dùng đang ở màn hình Đăng nhập / Chào mừng,  
**When** Hoạt ảnh nền vũ trụ hiển thị,  
**Then** Các vật thể đồ ăn 3D bay lơ lửng và bụi sao lấp lánh hoạt động mượt mà với 60 FPS, chia tách độc lập giữa spec tọa độ và painter.

## Story 3: Health Cards Modularization
**Given** Người dùng đang xem tab Thống kê (Analytics),  
**When** Dữ liệu Apple Health / Health Connect được kết nối,  
**Then** `EnergyBalanceCard` và `StepsActivityCard` hiển thị chính xác các chỉ số Calo In vs Calo Out và bước chân vận động.

## Story 4: Guild Member Actions Modularity
**Given** Trưởng Bang đang xem danh sách thành viên trong Bang hội,  
**When** Chạm vào một thành viên để mở `MemberActionSheet`,  
**Then** Thẻ header thông tin hiển thị rõ ràng và các hành động thăng cấp/hạ cấp/trục xuất/chuyển giao kích hoạt hộp thoại xác nhận chính xác.
