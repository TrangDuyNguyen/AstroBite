# Danh Mục Epics & Phân Loại MoSCoW (Epics Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO)
- **Chu kỳ đánh giá**: Mỗi chu kỳ Sprint / Cột mốc Milestone
- **Cập nhật lần cuối**: 2026-09-18

---

## 📊 Bảng Đánh Giá Phân Loại Epics Toàn Diện

| Mã Epic | Tên Epic | Mô Tả Mục Tiêu Nghiệp Vụ | Giá Trị Kinh Doanh | MoSCoW | Chân Trời | Trạng Thái |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| **`EPIC-01`** | **Core Authentication & Onboarding** | Cho phép người dùng tạo tài khoản, đăng nhập an toàn bằng Email & Google, bảo vệ bằng Firebase App Check. | Nền tảng định danh & bảo mật dữ liệu cá nhân. | **Must-have** | NOW (v1.0) | 🟢 **Done** (Gate 6 Ready) |
| **`EPIC-02`** | **Gemini AI Visual Recognition** | Chụp ảnh đĩa thức ăn, gọi Gemini 2.0 Flash Vision để nhận diện món và tính calo/macro tự động < 2.5s. | Lợi thế cạnh tranh cốt lõi; tạo trải nghiệm "Wow" 1 chạm. | **Must-have** | NOW (v1.0) | 🟢 **Done** (Gate 6 Ready) |
| **`EPIC-03`** | **Daily Food Diary & Manual Entry** | Quản lý nhật ký ăn uống 4 bữa; tra cứu danh bạ món có sẵn, slider chỉnh gram, và tạo custom food. | Trải nghiệm ghi chép hằng ngày; dự phòng khi không thể chụp ảnh. | **Must-have** | NOW (v1.0) | 🟢 **Done** (Gate 6 Ready) |
| **`EPIC-04`** | **Nutrition Analytics & Trends** | Trực quan hóa dữ liệu dinh dưỡng qua biểu đồ FL Chart theo ngày/tuần/tháng; đánh giá thâm hụt/dư thừa calo. | Thúc đẩy giữ chân người dùng (D30 Retention >= 35%). | **Must-have** | NOW (v1.0) | 🟢 **Done** (Released v1.0.0) |
| **`EPIC-05`** | **Personalized Goals & Profile** | Tính toán tự động BMR & TDEE theo độ tuổi, giới tính, chiều cao, cân nặng và mục tiêu (Tăng cơ/Giảm mỡ). | Cá nhân hóa trải nghiệm dinh dưỡng cho từng đối tượng. | **Must-have** | NOW (v1.0) | 🟢 **Done** (Released v1.0.0) |
| **`EPIC-06`** | **Multi-Item Meal Detection** | Nhận diện nhiều món ăn độc lập trên cùng một khay hoặc bàn ăn, bóc tách dinh dưỡng từng món riêng rẽ. | Giảm 70% số lần chụp khi ăn bữa cơm gia đình; Hero feature v1.1. | **Must-have** | NOW (v1.1) | 🟡 **In Planning** (Gate 1 Ready) |
| **`EPIC-09`** | **Offline-First Resilience** | Lưu trữ nhật ký cục bộ (Local Cache), tự động đồng bộ Firestore khi kết nối mạng phục hồi. | Trải nghiệm mượt mà, không gián đoạn ở nơi sóng yếu; cốt lõi v1.1. | **Must-have** | NOW (v1.1) | 🟡 **In Planning** (Gate 1 Ready) |
| **`EPIC-08`** | **Micronutrient Tracking** | Đo lường chi tiết Natri (Sodium), Chất xơ (Fiber), Lượng đường (Sugar) và Vitamin cho người ăn kiêng đặc biệt. | Phục vụ người dùng quan tâm sâu đến sức khỏe. | **Should-have** | NOW (v1.1) | 🟡 **In Planning** (Gate 1 Ready) |
| **`EPIC-07`** | **Smart Realtime AI Coach** | Chat trực tiếp với Gemini AI để nhận tư vấn dinh dưỡng tức thì (ví dụ: *"Bữa tối nên ăn gì để bù đủ 30g Protein?"*). | Gia tăng tương tác (Daily Engaged Time) đột phá. | **Could-have** | LATER (v1.2) | ⚪ **Deferred** |
| **`EPIC-10`** | **Apple Health / Health Connect** | Đồng bộ dữ liệu calo tiêu thụ và năng lượng đốt cháy từ smartwatch (Apple Watch, Garmin). | Hoàn thiện hệ sinh thái thiết bị đeo. | **Could-have** | LATER (v1.2) | ⚪ **Deferred** |
| **`EPIC-11`** | **Online Food Ordering** | Đặt món ăn eat-clean giao tận nơi từ các đối tác nhà hàng. | Chưa phù hợp với giai đoạn tập trung công nghệ AI dinh dưỡng. | **Won't-have** | OUT OF SCOPE | 🔴 **Rejected (v1.x)** |

---

## 🧭 Quy Chuẩn Quản Lý Của Sub-Agent PO
1. **Quy tắc phân bổ tải trọng MoSCoW**:
   - Nhóm **Must-have**: Chiếm tối đa 60% năng lực thực thi của 1 phiên bản.
   - Nhóm **Should-have**: Chiếm khoảng 25-30% năng lực.
   - Nhóm **Could-have**: Chiếm khoảng 10-15% (dự phòng để co giãn tiến độ).
2. **Quy trình đưa Epic vào Sprint**:
   - Epic chỉ được Sub-Agent PO chuyển sang trạng thái `In Progress` khi đã có User Personas rõ ràng và Sub-Agent BA đã sẵn sàng khởi động Gate 1.
