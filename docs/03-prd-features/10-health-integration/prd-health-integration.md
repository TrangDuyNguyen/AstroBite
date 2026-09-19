# PRD: Tích Hợp Nền Tảng Sức Khỏe Apple HealthKit & Health Connect (Health Integration)

- **Mã tính năng**: `FEAT-10`
- **Mã Epic liên kết**: `EPIC-10` (Apple Health / Health Connect Integration)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA)
- **Trạng thái**: 🟡 **In Review (Chờ PO Phê Duyệt Gate 1)**
- **Mục tiêu phiên bản**: `v1.2.0` (Sprint 03)
- **Đối chiếu UI/UX**: `docs/03-prd-features/10-health-integration/ui-ux-design-spec.md` (Gate 2)
- **Đối chiếu QA**: `tests/02-manual-testcases/10-health-integration/` & `tests/03-bdd-gherkin-scenarios/health_integration.feature` (Gate 3)
- **Đối chiếu FE**: `lib/features/health/` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
- Ở phiên bản v1.0.0 – v1.1.0, AstroBite chỉ theo dõi **calo nạp vào (Calories In)** từ bữa ăn, nhưng hoàn toàn **không biết calo tiêu hao (Calories Out)** từ vận động thể thao.
- Người dùng có Apple Watch, Pixel Watch, Galaxy Watch hoặc thiết bị đeo thông minh khác đang ghi nhận dữ liệu vận động trên Apple Health / Health Connect, nhưng phải **mở app riêng** để xem và tự tính toán bù trừ calo.
- **Nỗi đau (Pain Point)**: Thiếu bức tranh dinh dưỡng toàn cảnh (Net Calories = Calo nạp – Calo đốt) khiến người dùng không biết mình nên ăn thêm hay giảm bớt, đặc biệt sau khi tập gym.

### 1.2. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (KPIs & Metrics)
- **Hoàn thiện vòng lặp Energy Balance**: 100% người dùng kết nối Health có thể xem Net Calories = Dietary In – Active Out.
- **Tỷ lệ kết nối Health Platform**: >= 40% người dùng iOS kết nối HealthKit, >= 25% Android kết nối Health Connect (trong 3 tháng đầu).
- **Cải thiện độ chính xác TDEE**: So sánh TDEE tính toán (Mifflin-St Jeor) với TDEE thực tế từ thiết bị đeo → sai lệch <= 15%.
- **D30 Retention Impact**: Tăng 5-8% cho nhóm người dùng có thiết bị đeo.

---

## 2. Đối Tượng Người Dùng (Target Personas)

1. **Người Tập Gym với Apple Watch (Gym-goers + Apple Watch)**: Muốn biết chính xác bao nhiêu calo đã đốt sau buổi tập, cần ăn bù bao nhiêu.
2. **Runner / Cyclist với Garmin / Pixel Watch**: Ghi nhận hàng trăm calo tiêu hao mỗi buổi chạy, muốn AstroBite tự động trừ vào ngân sách calo.
3. **Người Dùng Sức Khỏe Tổng Quan (Health-conscious Users)**: Theo dõi số bước đi, calo đốt nhẹ (neat calories) và muốn xem tổng quan năng lượng trong ngày.

---

## 3. Luồng Trải Nghiệm Người Dùng (User Journey & Flow)

```
[Lần đầu: Cài đặt → Kết nối Health]
       │
       ├──► [iOS: Yêu cầu quyền HealthKit]
       │      • Read: Steps, Active Energy Burned, Workouts
       │      • Write: Dietary Energy (calo nạp vào)
       │
       ├──► [Android: Yêu cầu quyền Health Connect]
       │      • Read: Steps, Total Calories Burned, Exercise Sessions
       │      • Write: Nutrition (calo nạp vào)
       │
       └──► [Quyền bị từ chối → Graceful Degradation]
              • App vẫn hoạt động đầy đủ, hiện banner hướng dẫn cấp quyền

[Hàng ngày: Xem Dashboard]
       │
       ▼
[Health Dashboard — Tích hợp trong Analytics Tab]
       │
       ├──► [Energy Balance Card]
       │      • Calo nạp vào (từ Tracker): 1650 kcal
       │      • Calo đốt cháy (từ Health): 420 kcal
       │      • Net Calories: 1230 kcal
       │      • Ngân sách còn lại: 570 kcal
       │
       ├──► [Steps & Activity Card]
       │      • Số bước: 8,234 bước
       │      • Quãng đường: 5.8 km
       │
       └──► [Workouts Today List]
              • 🏃 Chạy bộ 30 phút — 285 kcal
              • 💪 Gym 45 phút — 135 kcal
```

---

## 4. Danh Sách Yêu Cầu Chức Năng (Functional Requirements)

### FR-01: Kết nối Health Platform
- Hiển thị màn hình cài đặt "Kết nối Sức khỏe" trong Profile/Settings.
- iOS: Trigger HealthKit authorization dialog cho các data types cần thiết.
- Android: Trigger Health Connect permission flow.
- Lưu trạng thái kết nối vào Firestore: `users/{uid}.health_connected = true/false`.

### FR-02: Đọc dữ liệu vận động (Read)
- **Steps**: Tổng số bước đi trong ngày (00:00 – 23:59).
- **Active Energy Burned**: Tổng calo tiêu hao chủ động (kcal).
- **Workouts / Exercise Sessions**: Danh sách bài tập (tên, thời lượng, calo đốt).
- Tần suất đọc: Mỗi lần mở Dashboard hoặc pull-to-refresh (không background polling).

### FR-03: Ghi dữ liệu dinh dưỡng (Write)
- Sau mỗi lần người dùng lưu bữa ăn vào Tracker, ghi Dietary Energy vào Health Platform.
- Chỉ ghi khi người dùng đã bật tùy chọn "Đồng bộ calo sang Health".
- Tránh ghi trùng: kiểm tra bản ghi đã tồn tại theo timestamp.

### FR-04: Energy Balance Dashboard
- Hiển thị thẻ tổng hợp trong Analytics tab (không tạo tab mới):
  - **Calo nạp vào** (từ meal_logs hôm nay) — màu `AppColors.primary` (#1A73E8).
  - **Calo đốt cháy** (từ Health) — màu `AppColors.secondary` (#FF69B4).
  - **Net Calories** = Calo nạp – Calo đốt.
  - **Ngân sách còn lại** = Calorie Target – Net Calories.
- Thanh progress arc hiển thị tỷ lệ Calo In / Calo Out.

### FR-05: Quản lý quyền & Ngắt kết nối
- Hiển thị trạng thái kết nối hiện tại (Connected / Disconnected).
- Nút "Ngắt kết nối" xóa trạng thái và ngừng đọc/ghi.
- Nếu quyền bị thu hồi từ Settings OS: app phát hiện và hiện hướng dẫn cấp lại.

---

## 5. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

| Tiêu chí | Chỉ tiêu | Ghi chú |
|:---|:---|:---|
| **Thời gian đọc Health data** | <= 2 giây | Chỉ đọc dữ liệu trong ngày |
| **Graceful degradation** | App hoạt động 100% khi không có Health | Tính năng hoàn toàn tùy chọn |
| **Privacy** | Không gửi Health data lên server | Chỉ đọc và hiển thị local |
| **Platform support** | iOS 15+ (HealthKit), Android 14+ (Health Connect) | Health Connect backward compat via APK |
| **Bảo mật quyền** | Chỉ request quyền cần thiết, giải thích rõ lý do | Tuân thủ Apple/Google policy |

---

## 6. Quy Tắc Nghiệp Vụ (Business Rules)

| Mã | Quy Tắc | Chi Tiết |
|:---|:---|:---|
| **BR-01** | Không background polling | Chỉ đọc Health data khi người dùng chủ động mở Dashboard hoặc pull-to-refresh |
| **BR-02** | Tùy chọn ghi ngược (Opt-in) | Ghi calo nạp vào Health chỉ khi người dùng bật toggle trong Settings |
| **BR-03** | Không thay thế TDEE | Dữ liệu Health chỉ hiển thị bổ sung; TDEE tính theo Mifflin-St Jeor vẫn là nguồn chính |
| **BR-04** | Graceful khi chưa kết nối | Dashboard ẩn Energy Balance card, chỉ hiển thị nút "Kết nối Sức khỏe" |

---

## Phê Duyệt Của Product Owner (Gate 1 Sign-Off)
- **PO**: AstroBite Strategic PO Sub-Agent
- **Trạng thái**: 🟡 PENDING REVIEW
- **Ngày phê duyệt**: *(Chờ PO ký)*
- **Ý kiến chỉ đạo**: *(Chờ PO ghi chú)*
