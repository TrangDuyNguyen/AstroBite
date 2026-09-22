# Bản Đồ Lộ Trình Sản Phẩm AstroBite (Product Roadmap)

- **Quản lý bởi**: Sub-Agent Product Owner (PO)
- **Phiên bản hiện tại**: v1.4.0 (Sprint 05 Released)
- **Cập nhật lần cuối**: 2026-09-22
- **Tình trạng tổng thể**: 🟢 Đã hoàn thành phát hành v1.4.0 — Chuẩn bị Sprint 06 (v1.5.0)

---

## 🧭 Mô Hình Lộ Trình 3 Chân Trời (3-Horizon Framework)

```
       ┌──────────────────────────────────────────────────────────────┐
       │   🟢 CHÂN TRỜI 1: HISTORICAL (v1.0.0, v1.1.0, v1.2.0, v1.3.0)│
       │   - v1.0.0: MVP Core (Auth, Scanner, Diary, Stats, Profile)  │
       │   - v1.1.0: Multi-Item Vision, Offline-First, Micronutrients │
       │   - v1.2.0: Realtime AI Coach, Apple Health Integration      │
       │   - v1.3.0: Cosmic Onboarding, Google Auth Fix, New Shell IA │
       └──────────────────────────────┬───────────────────────────────┘
                                      │
                                      ▼
       ┌──────────────────────────────────────────────────────────────┐
       │   🟡 CHÂN TRỜI 2: NOW (v1.4.0 — SPRINT 05 ACTIVE)            │
       │   - EPIC-13: Gamification & Cosmic Streak Engine (13 SP)     │
       │   - EPIC-11: Mobile Widgets & Quick Glance (8 SP)            │
       │   - EPIC-07-EXT: AI Coach Contextual Memory & 1-Tap Log (5SP)│
       └──────────────────────────────┬───────────────────────────────┘
                                      │
                                      ▼
       ┌──────────────────────────────────────────────────────────────┐
       │   🟣 CHÂN TRỜI 3: NEXT (v1.5.0 — Q1/2027)                     │
       │   - EPIC-12: Custom Recipes & Meal Planning                  │
       │   - EPIC-14: Social Guilds & Planetary Challenges            │
       └──────────────────────────────────────────────────────────────┘
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
  1. `FEAT-01` **Auth & Onboarding**: Email/Pass, Google Sign-in, luồng chào mừng. *(Trạng thái: Released v1.0.0)*.
  2. `FEAT-02` **Gemini Food Scanner AI**: Chụp ảnh món ăn, phân tích Vision AI, bóc tách calo/macro. *(Trạng thái: Released v1.0.0)*.
  3. `FEAT-03` **Diary & Manual Food Entry**: Quản lý 4 bữa ăn, danh bạ món có sẵn, slider điều chỉnh gram, tạo custom food. *(Trạng thái: Released v1.0.0)*.
  4. `FEAT-04` **Analytics & Insights**: Biểu đồ tiêu thụ calo và tỷ lệ 3 chất đa lượng theo tuần/tháng. *(Trạng thái: Released v1.0.0)*.
  5. `FEAT-05` **User Profile & Goals**: Tính BMR/TDEE tự động theo thể trạng và mức độ vận động. *(Trạng thái: Released v1.0.0)*.

---

### 🟢 2. Phiên Bản v1.1.0: Dinh Dưỡng Nâng Cao & Trải Nghiệm Offline
* **Mục tiêu phiên bản**: Nâng cao năng lực của AI Vision khi quét nhiều món cùng lúc và tối ưu hóa tính liên tục khi người dùng mất kết nối internet.
* **Danh sách Features trực thuộc**:
  1. `FEAT-06` **Multi-Item Meal Detection**: Dùng Gemini 2.0 Flash Vision nhận diện đĩa cơm nhiều món trong 1 lần chụp. *(Trạng thái: Released v1.1.0)*.
  2. `FEAT-07` **Offline-First Resilience**: Bộ nhớ đệm cục bộ cho phép ghi nhật ký khi không có mạng, tự động đồng bộ Firestore khi online. *(Trạng thái: Released v1.1.0)*.
  3. `FEAT-08` **Micronutrient Tracking**: Mở rộng theo dõi Natri, Chất xơ, Lượng đường và Vitamin. *(Trạng thái: Released v1.1.0)*.

---

### 🟢 3. Phiên Bản v1.2.0: Trợ Lý Ảo Toàn Diện & Hệ Sinh Thái Sức Khỏe
* **Mục tiêu phiên bản**: Chuyển đổi từ ứng dụng ghi chép thụ động sang Trợ lý AI chủ động (Proactive AI Nutrition Coach).
* **Sprint**: Sprint 03 (19/09 – 03/10/2026)
* **Tổng Story Points**: 21 SP
* **Mục tiêu OKRs**:
  * Daily Engaged Time tăng 40% nhờ AI Chat.
  * Kết nối Apple Health & Health Connect 2 chiều: 100%.
  * `flutter analyze` 0 issues, test coverage ≥ 90%.
* **Danh sách Epics trực thuộc**:
  1. `EPIC-07` **Smart Realtime AI Coach**: Chat trực tiếp với Gemini AI để nhận tư vấn dinh dưỡng tức thì, gợi ý thực đơn theo ngữ cảnh bữa ăn hiện tại. *(Trạng thái: Released v1.2.0)*.
  2. `EPIC-10` **Apple Health / Health Connect Integration**: Đồng bộ dữ liệu calo tiêu thụ và năng lượng đốt cháy từ thiết bị đeo thông minh. *(Trạng thái: Released v1.2.0)*.

---

### 🟣 4. Phiên Bản v1.3.0+: Cá Nhân Hóa & Gamification
* **Mục tiêu phiên bản**: Gia tăng tính cá nhân hóa và tương tác thú vị để thúc đẩy D30 Retention.
* **Danh sách Epics dự kiến**:
  1. `EPIC-11` **Mobile Widgets & Quick Glance**: Widget xem nhanh calo còn lại ngoài LockScreen và HomeScreen.
  2. `EPIC-12` **Custom Recipes & Meal Plans**: Tùy chỉnh công thức món ăn cá nhân và lập kế hoạch bữa ăn hàng tuần.
  3. `EPIC-13` **Gamification**: Streak ăn sạch, huy hiệu thành tích, và bảng xếp hạng bạn bè.

---

## 📈 Ma Trận Theo Dõi Tiến Độ Lộ Trình
 
| Phiên Bản | Tiến Độ Hoàn Thành | Trạng Thái Quản Trị | Dự Kiến Phát Hành | Người Ký Duyệt |
| :---: | :---: | :---: | :---: | :---: |
| **v1.0.0 (MVP)** | **100%** (5/5 features đã ký sign-off) | Đã phát hành chính thức (Release Tag `v1.0.0`) | 2026-09-18 | Sub-Agent PO & PM |
| **v1.1.0** | **100%** (3/3 features đã ký sign-off) | Đã phát hành chính thức (Release Tag `v1.1.0`) | 2026-09-18 | Sub-Agent PO & PM |
| **v1.2.0** | **100%** (2/2 epics hoàn thành) | Đã phát hành chính thức (Release Tag `v1.2.0`) | 2026-09-19 | Sub-Agent PO & PM |
| **v1.3.0** | **100%** (18/18 SP thực tế hoàn thành) | Đã phát hành chính thức (Release Tag `v1.3.0`) | 2026-09-19 | Sub-Agent PO & PM |
| **v1.4.0** | **100%** (26/26 SP hoàn tất kiểm thử & review) | Đã phát hành chính thức (Release Tag `v1.4.0`) | 2026-09-22 | Sub-Agent PO & PM |
| **v1.5.0+** | **0%** | Ý tưởng chiến lược chân trời NEXT | Q1/2027 | Sub-Agent PO |
