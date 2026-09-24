# Bản Đồ Lộ Trình Sản Phẩm AstroBite (Product Roadmap)

- **Quản lý bởi**: Sub-Agent Product Owner (PO)
- **Phiên bản hiện tại**: v1.5.0 (Sprint 06 Active)
- **Cập nhật lần cuối**: 2026-09-22
- **Tình trạng tổng thể**: 🟡 Sprint 06 Active — Trọng tâm Glanceable Celestial Core (Màn hình Hôm nay)

---

## 🧭 Mô Hình Lộ Trình 3 Chân Trời (3-Horizon Framework)

```
       ┌──────────────────────────────────────────────────────────────┐
       │   🟢 CHÂN TRỜI 1: HISTORICAL (v1.0.0 đến v1.4.0)             │
       │   - v1.0.0: MVP Core (Auth, Scanner, Diary, Stats, Profile)  │
       │   - v1.1.0: Multi-Item Vision, Offline-First, Micronutrients │
       │   - v1.2.0: Realtime AI Coach, Apple Health Integration      │
       │   - v1.3.0: Cosmic Onboarding, Google Auth Fix, New Shell IA │
       │   - v1.4.0: Cosmic Streak Engine & Mobile OS Widgets (v1.4)  │
       └──────────────────────────────┬───────────────────────────────┘
                                      │
                                      ▼
       ┌──────────────────────────────────────────────────────────────┐
       │   🟡 CHÂN TRỜI 2: NOW (v1.5.0 — SPRINT 06 ACTIVE)            │
       │   - EPIC-15: Glanceable Celestial Cockpit & Quick Log (13 SP)│
       │   - EPIC-UI-CORE: 4pt Grid & Glanceable Polish (5 SP)        │
       └──────────────────────────────┬───────────────────────────────┘
                                      │
                                      ▼
       ┌──────────────────────────────────────────────────────────────┐
       │   🟣 CHÂN TRỜI 3: NEXT (v1.6.0 — Q1/2027)                     │
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
  1. `EPIC-07` **Smart Realtime AI Coach**: Chat trực tiếp với Gemini AI để nhận tư vấn dinh dưỡng tức thì. *(Trạng thái: Released v1.2.0)*.
  2. `EPIC-10` **Apple Health / Health Connect Integration**: Đồng bộ dữ liệu calo tiêu thụ và năng lượng đốt cháy từ thiết bị đeo thông minh. *(Trạng thái: Released v1.2.0)*.

---

### 🟢 4. Phiên Bản v1.4.0: Gamification & Mobile OS Widgets
* **Mục tiêu phiên bản**: Gia tăng tính gắn kết với người dùng thông qua hệ thống Cosmic Streak, Vòng năng lượng và Mobile OS Widgets ngoài màn hình chính. *(Trạng thái: Released v1.4.0)*.
* **Danh sách Epics trực thuộc**:
  1. `EPIC-13` **Cosmic Streak & Gamification Engine**: Vòng năng lượng Cosmic Core, Starlight Shield và Streak tracking.
  2. `EPIC-11` **Mobile Widgets & Quick Glance**: Glanceable Home/Lockscreen widgets cho iOS/Android.
  3. `EPIC-07-EXT` **AI Coach Contextual Memory & 1-Tap Log**: Lưu ngữ cảnh dị ứng, gợi ý thực đơn 1-tap.

---

### 🟢 5. Phiên Bản v1.5.0: Glanceable Celestial Core (Đã Phát Hành v1.5.0)
* **Mục tiêu phiên bản**: Tái cấu trúc màn hình "Tổng quan hôm nay" theo triết lý Ponytail: Tinh gọn, hiển thị trọng tâm Calo & 3 Macro song song trong 1 thẻ Cockpit, thời gian hiểu dữ liệu < 1.5 giây.
* **Sprint**: Sprint 06 (22/09 – 06/10/2026)
* **Tổng Story Points**: 18 SP (100% Hoàn thành)
* **Mục tiêu OKRs**:
  * Time-to-Understand dữ liệu Calo & Macro < 1.5 giây: 🟢 Đạt.
  * Tần suất mở app và ghi chép nhanh 1 chạm tăng 30%: 🟢 Đạt (1-tap quick log & meal deep linking).
  * `flutter analyze` 0 issues, test pass 100% (148/148), FPS >= 55: 🟢 Đạt.
* **Danh sách Epics trực thuộc**:
  1. `EPIC-15` **Glanceable Celestial Cockpit**: Vòng cung Calo bên trái và 3 thanh Macro song song bên phải trên cùng 1 card, thanh vi chất thu gọn (Collapsible), tinh gọn gợi ý AstroCoach 1 dòng. *(Trạng thái: Released v1.5.0)*.
  2. `EPIC-UI-CORE` **Ergonomic Meal Timeline & 1-Tap Quick Log**: Tối ưu 4 thẻ bữa ăn và nút thêm nhanh 1 chạm chuẩn 44pt touch target. *(Trạng thái: Released v1.5.0)*.

---

## 📈 Ma Trận Theo Dõi Tiến Độ Lộ Trình
 
| Phiên Bản | Tiến Độ Hoàn Thành | Trạng Thái Quản Trị | Dự Kiến Phát Hành | Người Ký Duyệt |
| :---: | :---: | :---: | :---: | :---: |
| **v1.0.0 (MVP)** | **100%** (5/5 features đã ký sign-off) | Đã phát hành chính thức (Release Tag `v1.0.0`) | 2026-09-18 | Sub-Agent PO & PM |
| **v1.1.0** | **100%** (3/3 features đã ký sign-off) | Đã phát hành chính thức (Release Tag `v1.1.0`) | 2026-09-18 | Sub-Agent PO & PM |
| **v1.2.0** | **100%** (2/2 epics hoàn thành) | Đã phát hành chính thức (Release Tag `v1.2.0`) | 2026-09-19 | Sub-Agent PO & PM |
| **v1.3.0** | **100%** (18/18 SP thực tế hoàn thành) | Đã phát hành chính thức (Release Tag `v1.3.0`) | 2026-09-19 | Sub-Agent PO & PM |
| **v1.4.0** | **100%** (26/26 SP hoàn tất kiểm thử & review) | Đã phát hành chính thức (Release Tag `v1.4.0`) | 2026-09-22 | Sub-Agent PO & PM |
| **v1.5.0** | **100%** (18/18 SP - 148/148 tests pass) | Đã phát hành chính thức (Release Tag `v1.5.0`) | 2026-09-24 | Sub-Agent PO & PM |
| **v1.6.0** | **100%** (9/9 SP - 152/152 tests pass) | Đã phát hành chính thức (Release Tag `v1.6.0`) | 2026-09-24 | Sub-Agent PO & PM |
| **v1.7.0+** | **0%** | Đại trùng tu giao diện Cinematic AR & Custom Recipes | Q4/2026 | Sub-Agent PO |
