# Release Notes — AstroBite v1.4.0

> **Phiên bản**: `v1.4.0`  
> **Tên mã**: The Cosmic Habit Loop & Frictionless Access  
> **Sprint**: Sprint 05 (19/09/2026 – 03/10/2026)  
> **Ngày phát hành**: 19/09/2026  
> **Sub-Agent phê duyệt phát hành**: Product Owner (PO - The Strategic Tyrant) & Project Manager (PM)  
> **Trạng thái**: 🟢 **RELEASED**

---

## 🌟 Tóm Tắt Phát Hành (Release Summary)

AstroBite v1.4.0 chuyển dịch trọng tâm sang việc **xây dựng thói quen dinh dưỡng bền vững** và **triệt tiêu ma sát tương tác về 0**, giải quyết điểm nghẽn rơi rụng người dùng (Churn) sau 3–5 ngày:

| # | Feature / Epic | Mô Tả Giá Trị Kinh Doanh & Trải Nghiệm |
| :---: | :--- | :--- |
| 🪐 | **Cosmic Gamification & Streak Engine (`EPIC-13`)** | Vòng năng lượng tiểu vũ trụ (`CosmicEnergyRing`), hệ thống chuỗi ngày ăn sạch liên tiếp (Streak), cơ chế khiên bảo vệ Starlight Shield, và bộ sưu tập 6 huy hiệu Celestial Badges (Stardust, Nebula, Supernova, Orbit Pioneer, Shield Bearer, Starlight Voyager). |
| 📱 | **Mobile Widgets & Quick Glance (`EPIC-11`)** | Đưa thông số Calo & Macro còn lại ra ngoài màn hình chính (HomeScreen) và màn hình khóa (LockScreen) của iOS & Android thông qua `home_widget`, tích hợp Deep Link `astrobite://scanner` mở trực tiếp camera AI scan trong 1 chạm. |
| ⚡ | **AstroCoach Context Memory & 1-Tap Log (`EPIC-07-EXT`)** | AI Coach tự động ghi nhớ thể trạng (BMR, TDEE, cân nặng, mục tiêu) và số ngày Streak hiện tại. Khi gợi ý thực đơn, sinh thẻ tương tác 1-Tap giúp người dùng ghi trực tiếp món ăn và dưỡng chất vào Firestore Diary. |

---

## ✨ Chi Tiết Kỹ Thuật (Feature Architecture)

### 🪐 1. EPIC-13: Cosmic Gamification & Streak Engine
- **Domain Layer**: Entity `StreakRecord` bất biến (`@freezed`) chứa `currentStreak`, `longestStreak`, `lastLoggedDate`, `isShieldActive`, `unlockedBadges`. Tách biệt logic kiểm tra ngày liên tục (`isEligibleForStreakUpdate`) an toàn với múi giờ ISO-8601.
- **Data Layer**: `StreakRepository` hỗ trợ in-memory local caching kết hợp đồng bộ Firestore, độ trễ đọc 0ms khi tải trang chủ.
- **Presentation Layer**:
  - `CosmicStreakBadge`: Huy hiệu lửa vũ trụ gắn trên AppBar HomePage.
  - `StreakDetailSheet`: Bottom sheet hiển thị trực quan số ngày streak, trạng thái Starlight Shield, và danh sách huy hiệu đã/chưa mở khóa.
  - `CosmicEnergyRing`: Vòng sáng năng lượng phản ánh tỷ lệ hoàn thành calo/macro ngày hôm nay.
- **Automated Tests**: 13/13 unit & widget tests pass 100%.

### 📱 2. EPIC-11: Mobile Widgets & Quick Glance
- **Native Data Bridge**: `WidgetSyncService` định dạng payload `WidgetSyncPayload` đồng bộ số calo nạp, calo mục tiêu, carbs, protein, fat vào App Group SharedPreferences (`group.com.astrobite.widget`).
- **Graceful Resilience**: Cơ chế bắt ngoại lệ `MissingPluginException` an toàn tuyệt đối trong môi trường test/desktop.
- **Deep Link Navigation**: Cấu hình `astrobite://scanner` tự động chuyển tiếp tới `CameraRoute`.
- **Automated Tests**: 3/3 tests pass 100%.

### ⚡ 3. EPIC-07-EXT: AstroCoach Contextual Memory & 1-Tap Log
- **Context Injection**: Tự động đưa thông tin BMR, TDEE, cân nặng, mục tiêu dinh dưỡng và Streak vào system prompt của Gemini AI Coach.
- **Structured Tag & Extraction**: AI tự động đính kèm `<!--astrobite-meal:{...}-->` khi gợi ý món ăn.
- **1-Tap Meal Log Card**: Bóc tách thẻ thông tin món ăn trực quan (calo, protein, carbs, fat) ngay bên dưới tin nhắn tư vấn kèm nút "1-Chạm" ghi trực tiếp vào `FoodLogDto`.
- **Automated Tests**: Kiểm tra bóc tách thẻ và tương tác 1-Tap thành công.

---

## 📊 Thống Kê Nghiệm Thu Kỹ Thuật (Technical Stats)

| Chỉ Số Đảm Bảo Chất Lượng | Kết Quả Thực Tế | Tiêu Chuẩn Cam Kết | Đánh Giá |
| :--- | :---: | :---: | :---: |
| **Tổng số Automated Tests** | **136 / 136 Passed** | 100% Pass | 🟢 ĐẠT |
| **Lỗi & Cảnh báo Linter (`flutter analyze`)** | **0 errors, 0 warnings** | 0 issues | 🟢 ĐẠT |
| **Độ trễ đọc Streak Cache (Cold Start)** | **< 5ms** | < 50ms | 🟢 VƯỢT TRỘI |
| **Kỷ luật tinh gọn Ponytail** | **Nguyên vẹn (0 dead abstractions)** | Tối giản, không bloat | 🟢 ĐẠT |
| **Màu dinh dưỡng bất biến** | Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700` | Bất biến theo `DESIGN.md` | 🟢 TUÂN THỦ |
| **Hồi quy giao diện & RenderFlex Overflow** | **0 lỗi overflow** | 0 overflow | 🟢 ĐẠT |

---

## 🚦 Kiểm Soát Chất Lượng 7 Cổng (7-Gate SOP Verification)

1. ✅ **Gate 0 (Tech Lead)**: Ban hành `ADR-05` định rõ cấu trúc dữ liệu Streak và Native Widget Bridge.
2. ✅ **Gate 1 (BA)**: Hoàn tất PRD `EPIC-13`, `EPIC-11` và tiêu chí nghiệm thu BDD Given-When-Then.
3. ✅ **Gate 2 (UI/UX Designer)**: Bản thiết kế Celestial Dark UI 4pt cho Streak Badge, Detail Sheet và Widget Layout.
4. ✅ **Gate 3 (QA Test Design)**: Kịch bản BDD Gherkin `.feature` cho Streak, Mobile Widgets và Coach Context.
5. ✅ **Gate 4 (Dev FE)**: Triển khai Clean Architecture, Riverpod Notifier, AutoRoute.
6. ✅ **Gate 5 (Reviewer)**: Rà soát Ponytail Diff Review, loại bỏ code thừa, rút gọn logic tính ngày.
7. ✅ **Gate 6 (QA Verification)**: Toàn bộ 136 tests pass thực chất, 0 fake green tests, ký biên bản nghiệm thu.
8. ✅ **Gate 7 (Release Gate)**: PO & PM chính thức ký duyệt phát hành `v1.4.0`.
