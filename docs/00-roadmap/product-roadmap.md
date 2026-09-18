# Bản Đồ Lộ Trình Sản Phẩm AstroBite (Product Roadmap)

- **Quản lý bởi**: Sub-Agent Product Owner (PO)
- **Phiên bản hiện tại**: v1.0.0
- **Cập nhật lần cuối**: 2026-09-18
- **Tình trạng tổng thể**: 🟢 Đã hoàn tất phát hành phiên bản thương mại v1.0.0 MVP (100% Passed)

---

## 🧭 Mô Hình Lộ Trình 3 Chân Trời (3-Horizon Framework)

```
       ┌────────────────────────────────────────────────────────────┐
       │   🟢 CHÂN TRỜI 1: NOW (v1.0.0 MVP — Q3/2026) [RELEASED]    │
       │   - FEAT-01: Auth & Onboarding (Released)                  │
       │   - FEAT-02: Gemini Food Scanner AI (Released)             │
       │   - FEAT-03: Diary & Manual Food Entry (Released)          │
       │   - FEAT-04: Analytics & Trends (Released)                 │
       │   - FEAT-05: User Profile & Goals (Released)               │
       └─────────────────────────────┬──────────────────────────────┘
                                     │
                                     ▼
       ┌────────────────────────────────────────────────────────────┐
       │   🟡 CHÂN TRỜI 2: NEXT (v1.1.0 Enhancements — Q4/2026)      │
       │   - Quét đồng thời nhiều món trên bàn ăn (Multi-item AI)   │
       │   - Phân tích vi chất (Micronutrients: Natri, Xơ, Đường)   │
       │   - Cơ chế Offline-First Sync dữ liệu với Cloud Firestore  │
       │   - Tùy chỉnh công thức món ăn cá nhân (Custom Recipes)    │
       └─────────────────────────────┬──────────────────────────────┘
                                     │
                                     ▼
       ┌────────────────────────────────────────────────────────────┐
       │   🟣 CHÂN TRỜI 3: LATER (v1.2.0+ Ecosystem — Q1/2027)       │
       │   - Trợ lý AI dinh dưỡng hội thoại thời gian thực (Chat)   │
       │   - Đồng bộ Apple HealthKit & Android Health Connect       │
       │   - Widget màn hình chính iOS / Android                    │
       │   - Gamification: Streak ăn sạch & Huy hiệu thành tích     │
       └────────────────────────────────────────────────────────────┘
```

---

## 🎯 Chi Tiết Từng Phiên Bản Phát Hành

### 🟢 1. Phiên Bản v1.0.0: MVP Đột Phá AI & Trải Nghiệm Cốt Lõi
* **Mục tiêu phiên bản**: Ra mắt phiên bản thương mại hoàn chỉnh đầu tiên của AstroBite, cung cấp trọn vẹn luồng từ Đăng nhập ➔ Nhận diện đồ ăn AI ➔ Nhật ký ăn uống & Nhập thủ công ➔ Thống kê xu hướng ➔ Thiết lập mục tiêu calo/macro cá nhân.
* **Mục tiêu OKRs**:
  * Đạt 50,000 active users trong 6 tháng đầu.
  * Tỷ lệ nhận diện món ăn chính xác > 85%, độ trễ AI < 2.5s.
  * Tỷ lệ giữ chân D30 >= 35%.
* **Danh sách Features trực thuộc**:
  1. `FEAT-01` **Auth & Onboarding**: Email/Pass, Google Sign-in, luồng chào mừng. *(Trạng thái: Gate 6 Ready - Đã ký sign-off)*.
  2. `FEAT-02` **Gemini Food Scanner AI**: Chụp ảnh món ăn, phân tích Vision AI, bóc tách calo/macro. *(Trạng thái: Gate 6 Ready - Đã ký sign-off)*.
  3. `FEAT-03` **Diary & Manual Food Entry**: Quản lý 4 bữa ăn, danh bạ món có sẵn, slider điều chỉnh gram, tạo custom food. *(Trạng thái: Gate 6 Ready - Đã ký sign-off, 86 tests pass)*.
  4. `FEAT-04` **Analytics & Insights**: Biểu đồ tiêu thụ calo và tỷ lệ 3 chất đa lượng theo tuần/tháng. *(Trạng thái: Released - Đã ký sign-off)*.
  5. `FEAT-05` **User Profile & Goals**: Tính BMR/TDEE tự động theo thể trạng và mức độ vận động. *(Trạng thái: Released - Đã ký sign-off)*.

---

### 🟡 2. Phiên Bản v1.1.0: Dinh Dưỡng Nâng Cao & Trải Nghiệm Offline
* **Mục tiêu phiên bản**: Nâng cao năng lực của AI Vision khi quét nhiều món cùng lúc và tối ưu hóa tính liên tục khi người dùng mất kết nối internet.
* **Danh sách Epics dự kiến**:
  1. `EPIC-06` **Multi-Item Meal Detection**: Dùng Gemini 2.0 Flash Vision với bounding box hoặc segmented prompt để nhận diện đĩa cơm có nhiều món (cơm, thịt kho, canh, rau) trong 1 lần chụp.
  2. `EPIC-08` **Micronutrient Tracking**: Mở rộng theo dõi Natri (Sodium), Chất xơ (Fiber), Lượng đường (Sugar) và Vitamin.
  3. `EPIC-09` **Offline-First Resilience**: Bộ nhớ đệm cục bộ (Local Cache/Hive) cho phép ghi nhật ký ngay cả khi không có mạng, tự động đồng bộ Firestore khi online trở lại.

---

### 🟣 3. Phiên Bản v1.2.0+: Trợ Lý Ảo Toàn Diện & Hệ Sinh Thái Sức Khỏe
* **Mục tiêu phiên bản**: Chuyển đổi từ ứng dụng ghi chép thụ động sang Trợ lý AI chủ động (Proactive AI Nutrition Coach).
* **Danh sách Epics dự kiến**:
  1. `EPIC-07` **Smart Realtime AI Coach**: Chat trực tiếp với AI để xin gợi ý thực đơn, hỏi đáp chế độ ăn Keto/Eat Clean.
  2. `EPIC-10` **Health Platform Integration**: Kết nối 2 chiều với Apple Health và Google Health Connect để tự động trừ calo tiêu hao từ vận động thể thao.
  3. `EPIC-11` **Mobile Widgets & Quick Glance**: Widget xem nhanh calo còn lại ngoài LockScreen và HomeScreen.

---

## 📈 Ma Trận Theo Dõi Tiến Độ Lộ Trình

| Phiên Bản | Tiến Độ Hoàn Thành | Trạng Thái Quản Trị | Dự Kiến Phát Hành | Người Ký Duyệt |
| :---: | :---: | :---: | :---: | :---: |
| **v1.0.0 (MVP)** | **80%** (3/5 features đã ký sign-off) | Đang chạy Sprint 01 để đóng 2 features còn lại | Cuối Q3/2026 | Sub-Agent PO |
| **v1.1.0** | **0%** | Đã định hình phạm vi trong Backlog | Q4/2026 | Sub-Agent PO |
| **v1.2.0+** | **0%** | Ý tưởng chiến lược chân trời Later | Q1/2027 | Sub-Agent PO |
