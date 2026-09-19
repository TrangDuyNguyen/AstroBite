# User Stories & BDD Acceptance Criteria — Health Integration (FEAT-10 / EPIC-10)

- **Tính năng**: Apple Health / Health Connect Integration
- **Phiên bản**: v1.2.0 (Sprint 03)
- **Tham chiếu PRD**: [`prd-health-integration.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/10-health-integration/prd-health-integration.md)

---

## US-01: Kết nối Health Platform lần đầu
- **As a**: Người dùng có Apple Watch hoặc thiết bị Android đeo tay
- **I want to**: Kết nối AstroBite với Apple Health / Health Connect
- **So that**: Dữ liệu vận động của tôi được tự động hiển thị trong AstroBite

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Kết nối thành công trên iOS (Happy Path)
- **Given**: Người dùng đang ở màn hình Profile/Settings, chưa kết nối Health
- **And**: Mục "Kết nối Sức khỏe" hiển thị trạng thái "Chưa kết nối" với nút "Kết nối"
- **When**: Người dùng bấm nút "Kết nối"
- **Then**: iOS HealthKit authorization dialog hiện ra yêu cầu quyền Read (Steps, Active Energy, Workouts) và Write (Dietary Energy)
- **When**: Người dùng bấm "Allow All"
- **Then**: Trạng thái đổi thành "Đã kết nối ✅"
- **And**: Firestore cập nhật `users/{uid}.health_connected = true`
- **And**: SnackBar hiển thị "Đã kết nối Apple Health thành công"

#### Scenario 2: Kết nối thành công trên Android
- **Given**: Người dùng đang ở màn hình Profile/Settings trên thiết bị Android
- **When**: Người dùng bấm "Kết nối"
- **Then**: Health Connect permission flow hiện ra
- **When**: Người dùng cấp quyền
- **Then**: Trạng thái đổi thành "Đã kết nối ✅"

#### Scenario 3: Người dùng từ chối quyền
- **Given**: Dialog yêu cầu quyền hiện ra
- **When**: Người dùng bấm "Don't Allow" hoặc chỉ cấp một phần quyền
- **Then**: Trạng thái vẫn "Chưa kết nối"
- **And**: Hiển thị giải thích thân thiện: "AstroBite cần quyền truy cập để hiển thị calo đốt cháy từ vận động của bạn"
- **And**: Nút "Mở Cài đặt" dẫn đến Settings OS để cấp lại quyền

---

## US-02: Xem calo tiêu hao từ vận động trên Dashboard
- **As a**: Người dùng đã kết nối Health Platform
- **I want to**: Xem tổng calo đốt cháy và danh sách bài tập trong ngày
- **So that**: Tôi biết mình đã vận động được bao nhiêu để điều chỉnh bữa ăn

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Hiển thị dữ liệu vận động hôm nay
- **Given**: Người dùng đã kết nối Health và có dữ liệu vận động hôm nay
- **And**: Apple Health ghi nhận: 8,234 bước, Chạy bộ 30 phút (285 kcal), Gym 45 phút (135 kcal)
- **When**: Người dùng mở tab Analytics
- **Then**: Energy Balance Card hiển thị:
  - Calo đốt cháy: 420 kcal (tổng Active Energy)
  - Steps: 8,234 bước
- **And**: Workouts list hiển thị: "🏃 Chạy bộ 30p — 285 kcal", "💪 Gym 45p — 135 kcal"

#### Scenario 2: Chưa có dữ liệu vận động
- **Given**: Người dùng đã kết nối Health nhưng hôm nay chưa vận động
- **When**: Người dùng mở Dashboard
- **Then**: Energy Balance Card hiển thị Calo đốt: 0 kcal
- **And**: Steps: 0 bước với dòng "Hãy bắt đầu di chuyển nào! 🚶"

---

## US-03: Xem Energy Balance (Net Calories) trên Dashboard
- **As a**: Người dùng đã ăn và vận động trong ngày
- **I want to**: Xem bức tranh tổng quan Calo In vs Calo Out
- **So that**: Tôi biết mình đang thâm hụt hay dư thừa calo

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Hiển thị Energy Balance đầy đủ
- **Given**: Người dùng đã log: Sáng 450 kcal, Trưa 650 kcal = 1100 kcal nạp vào
- **And**: Health ghi nhận: 420 kcal đốt cháy
- **And**: Mục tiêu calo: 2000 kcal
- **When**: Người dùng xem Energy Balance Card
- **Then**: Hiển thị:
  - 🔵 Calo nạp: 1100 kcal
  - 🩷 Calo đốt: 420 kcal
  - Net Calories: 680 kcal
  - Ngân sách còn lại: 1320 kcal (2000 - 680)
- **And**: Progress arc hiển thị tỷ lệ 680/2000 = 34%

#### Scenario 2: Calo nạp vượt mức sau trừ vận động
- **Given**: Người dùng đã ăn 2200 kcal, đốt 300 kcal, mục tiêu 2000 kcal
- **When**: Xem Energy Balance
- **Then**: Net = 1900 kcal, hiển thị "Trong ngân sách ✅"
- **And**: Không hiển thị cảnh báo vượt ngưỡng

---

## US-04: Ngắt kết nối Health Platform
- **As a**: Người dùng đã kết nối Health
- **I want to**: Ngắt kết nối nếu không muốn chia sẻ dữ liệu nữa
- **So that**: Quyền riêng tư của tôi được bảo vệ

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Ngắt kết nối thành công
- **Given**: Người dùng đang ở Settings, trạng thái "Đã kết nối ✅"
- **When**: Người dùng bấm "Ngắt kết nối"
- **Then**: Dialog xác nhận hiện ra: "Bạn có chắc muốn ngắt kết nối? Dữ liệu vận động sẽ không hiển thị."
- **When**: Người dùng bấm "Xác nhận"
- **Then**: Trạng thái đổi về "Chưa kết nối"
- **And**: Firestore cập nhật `health_connected = false`
- **And**: Energy Balance Card ẩn khỏi Dashboard
- **And**: SnackBar: "Đã ngắt kết nối Health"

---

## US-05: Ghi calo nạp vào ngược về Health Platform
- **As a**: Người dùng muốn tổng hợp dữ liệu dinh dưỡng trên Health app
- **I want to**: AstroBite tự động ghi calo nạp vào Apple Health / Health Connect
- **So that**: Tôi xem được đầy đủ dữ liệu dinh dưỡng trên Apple Health / Google Fit

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Ghi tự động khi toggle bật
- **Given**: Người dùng đã kết nối Health và bật toggle "Đồng bộ calo sang Health" trong Settings
- **When**: Người dùng lưu bữa trưa: Phở bò 450 kcal
- **Then**: AstroBite ghi 1 bản ghi Dietary Energy (450 kcal) vào HealthKit/Health Connect
- **And**: Không hiển thị UI nào cho hành động ghi (background)

#### Scenario 2: Toggle tắt — không ghi
- **Given**: Toggle "Đồng bộ calo sang Health" đang tắt
- **When**: Người dùng lưu bữa ăn
- **Then**: AstroBite không ghi gì vào Health Platform

#### Scenario 3: Ghi thất bại — không ảnh hưởng UX
- **Given**: Toggle bật nhưng Health API trả lỗi
- **When**: Người dùng lưu bữa ăn
- **Then**: Bữa ăn vẫn lưu thành công vào Firestore/Local Cache
- **And**: Log lỗi ghi Health vào console (không hiện cho người dùng)
