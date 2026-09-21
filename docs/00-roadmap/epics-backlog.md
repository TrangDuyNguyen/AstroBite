# Danh Mục Epics & Phân Loại MoSCoW (Epics Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO)
- **Chu kỳ đánh giá**: Mỗi chu kỳ Sprint / Cột mốc Milestone
- **Cập nhật lần cuối**: 2026-09-19

---

## 📊 Bảng Đánh Giá Phân Loại Epics Toàn Diện

| Mã Epic | Tên Epic | Mô Tả Mục Tiêu Nghiệp Vụ | Giá Trị Kinh Doanh | MoSCoW | Chân Trời | Trạng Thái |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| **`EPIC-01`** | **Core Authentication & Onboarding** | Cho phép người dùng tạo tài khoản, đăng nhập an toàn bằng Email & Google, bảo vệ bằng Firebase App Check. | Nền tảng định danh & bảo mật dữ liệu cá nhân. | **Must-have** | HISTORICAL (v1.0) | 🟢 **Done** (Released v1.0.0) |
| **`EPIC-02`** | **Gemini AI Visual Recognition** | Chụp ảnh đĩa thức ăn, gọi Gemini 2.0 Flash Vision để nhận diện món và tính calo/macro tự động < 2.5s. | Lợi thế cạnh tranh cốt lõi; tạo trải nghiệm "Wow" 1 chạm. | **Must-have** | HISTORICAL (v1.0) | 🟢 **Done** (Released v1.0.0) |
| **`EPIC-03`** | **Daily Food Diary & Manual Entry** | Quản lý nhật ký ăn uống 4 bữa; tra cứu danh bạ món có sẵn, slider chỉnh gram, và tạo custom food. | Trải nghiệm ghi chép hằng ngày; dự phòng khi không thể chụp ảnh. | **Must-have** | HISTORICAL (v1.0) | 🟢 **Done** (Released v1.0.0) |
| **`EPIC-04`** | **Nutrition Analytics & Trends** | Trực quan hóa dữ liệu dinh dưỡng qua biểu đồ FL Chart theo ngày/tuần/tháng; đánh giá thâm hụt/dư thừa calo. | Thúc đẩy giữ chân người dùng (D30 Retention >= 35%). | **Must-have** | HISTORICAL (v1.0) | 🟢 **Done** (Released v1.0.0) |
| **`EPIC-05`** | **Personalized Goals & Profile** | Tính toán tự động BMR & TDEE theo độ tuổi, giới tính, chiều cao, cân nặng và mục tiêu (Tăng cơ/Giảm mỡ). | Cá nhân hóa trải nghiệm dinh dưỡng cho từng đối tượng. | **Must-have** | HISTORICAL (v1.0) | 🟢 **Done** (Released v1.0.0) |
| **`EPIC-06`** | **Multi-Item Meal Detection** | Nhận diện nhiều món ăn độc lập trên cùng một khay hoặc bàn ăn, bóc tách dinh dưỡng từng món riêng rẽ. | Giảm 70% số lần chụp khi ăn bữa cơm gia đình; Hero feature v1.1. | **Must-have** | HISTORICAL (v1.1) | 🟢 **Done** (Released v1.1.0) |
| **`EPIC-09`** | **Offline-First Resilience** | Lưu trữ nhật ký cục bộ (Local Cache), tự động đồng bộ Firestore khi kết nối mạng phục hồi. | Trải nghiệm mượt mà, không gián đoạn ở nơi sóng yếu; cốt lõi v1.1. | **Must-have** | HISTORICAL (v1.1) | 🟢 **Done** (Released v1.1.0) |
| **`EPIC-08`** | **Micronutrient Tracking** | Đo lường chi tiết Natri (Sodium), Chất xơ (Fiber), Lượng đường (Sugar) và Vitamin cho người ăn kiêng đặc biệt. | Phục vụ người dùng quan tâm sâu đến sức khỏe. | **Should-have** | HISTORICAL (v1.1) | 🟢 **Done** (Released v1.1.0) |
| **`EPIC-07`** | **Smart Realtime AI Coach** | Chat trực tiếp với Gemini AI để nhận tư vấn dinh dưỡng tức thì (ví dụ: *"Bữa tối nên ăn gì để bù đủ 30g Protein?"*). Gợi ý thực đơn theo ngữ cảnh bữa ăn hiện tại. | Gia tăng tương tác (Daily Engaged Time +40%) đột phá; Hero feature v1.2. | **Must-have** | HISTORICAL (v1.2) | 🟢 **Done** (Released v1.2.0) |
| **`EPIC-10`** | **Apple Health / Health Connect** | Đồng bộ dữ liệu calo tiêu thụ và năng lượng đốt cháy từ smartwatch (Apple Watch, Pixel Watch). Hoàn thiện vòng lặp Calo In ↔ Calo Out. | Hoàn thiện hệ sinh thái thiết bị đeo; cải thiện độ chính xác TDEE thực tế. | **Should-have** | HISTORICAL (v1.2) | 🟢 **Done** (Released v1.2.0) |
| **`EPIC-13`** | **Gamification: Cosmic Streak & Badges** | Vòng năng lượng Cosmic Core, chuỗi ngày ăn sạch (Streak), cơ chế Starlight Shield và huy hiệu tiểu vũ trụ. | Vũ khí số 1 thúc đẩy D30 Retention (giảm nản sau 3-5 ngày). | **Must-have** | NOW (v1.4) | 🟢 **Done** (Sprint 05 Completed) |
| **`EPIC-11`** | **Mobile Widgets & Quick Glance** | Widget xem nhanh calo/macro còn lại ngoài LockScreen và HomeScreen (iOS/Android), 1 chạm mở camera scan. | Giảm ma sát tương tác về 0; tăng tần suất mở app hằng ngày. | **Should-have** | NOW (v1.4) | 🟢 **Done** (Sprint 05 Completed) |
| **`EPIC-07-EXT`** | **AstroCoach Contextual Memory & 1-Tap Log** | Ghi nhớ thể trạng/dị ứng, gợi ý thực đơn kèm nút 1 chạm ghi trực tiếp vào nhật ký ăn uống. | Tối ưu trải nghiệm AI Coach Tab 2; tiết kiệm thời gian nhập liệu. | **Could-have** | NOW (v1.4) | 🟢 **Done** (Sprint 05 Completed) |
| **`EPIC-12`** | **Custom Recipes & Meal Plans** | Tùy chỉnh công thức món ăn cá nhân và lập kế hoạch bữa ăn hàng tuần. | Phục vụ nhóm người dùng nấu ăn tại nhà và meal prep. | **Could-have** | NEXT (v1.5) | ⚪ **Planned** |
| **`EPIC-99`** | **Online Food Ordering** | Đặt món ăn eat-clean giao tận nơi từ các đối tác nhà hàng. | Chưa phù hợp với giai đoạn tập trung công nghệ AI dinh dưỡng. | **Won't-have** | OUT OF SCOPE | 🔴 **Rejected (v1.x)** |

---

## 🧭 Quy Chuẩn Quản Lý Của Sub-Agent PO
1. **Quy tắc phân bổ tải trọng MoSCoW**:
   - Nhóm **Must-have**: Chiếm tối đa 60% năng lực thực thi của 1 phiên bản.
   - Nhóm **Should-have**: Chiếm khoảng 25-30% năng lực.
   - Nhóm **Could-have**: Chiếm khoảng 10-15% (dự phòng để co giãn tiến độ).
2. **Quy trình đưa Epic vào Sprint**:
   - Epic chỉ được Sub-Agent PO chuyển sang trạng thái `In Progress` khi đã có User Personas rõ ràng và Sub-Agent BA đã sẵn sàng khởi động Gate 1.
