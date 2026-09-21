# Ma Trận Phân Rã Công Việc 7 Cổng (WBS Task Matrix)

- **Quản lý bởi**: Sub-Agent Project Manager (PM) & Sub-Agent Product Owner (PO)
- **Ánh xạ quy trình**: 7-Gate Delivery Flow (BA ➔ UI/UX Designer ➔ QA ➔ Dev FE ➔ Code Review ➔ Verification ➔ Release)
- **Cập nhật lần cuối**: 2026-09-19

---

## 🏗️ 1. Bảng Ma Trận Phân Rã WBS Sprint 05 (v1.4.0 The Cosmic Habit Loop — Active)

### EPIC-13: Gamification & Cosmic Streak Engine (13 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S5-TECH-SPIKE`** | Kiến Trúc & Spike | **Gate 0** | Nghiên cứu thuật toán Streak, xử lý múi giờ địa phương, Starlight Shield & lưu trữ Firestore/Local (ADR-05) | `tech-lead` | 3 | None | 🟢 Done |
| **`TSK-S5-PRD-STREAK`** | `EPIC-13` PRD | **Gate 1** | Soạn thảo PRD chuẩn BDD Given-When-Then, quy chuẩn Data Dictionary cho Streak & Badges | `business-analyst` | 3 | None | 🟢 Done |
| **`TSK-S5-UI-STREAK`** | `EPIC-13` Design | **Gate 2** | Thiết kế Cosmic Energy Ring (vòng năng lượng vũ trụ), huy hiệu Celestial & Empty/Streak state | `ui-ux-designer` | 3 | TSK-S5-PRD-STREAK | 🟢 Done |
| **`TSK-S5-DEV-STREAK`** | `EPIC-13` Flutter | **Gate 4-6** | Triển khai Domain Model `StreakRecord`, Riverpod `streakNotifierProvider` & UI Widget | `flutter-expert` | 4 | TSK-S5-UI-STREAK | 🟢 Done |

### EPIC-11: Mobile Widgets & Quick Glance (8 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S5-PRD-WIDGET`** | `EPIC-11` PRD | **Gate 1** | Xác định thông số dữ liệu đồng bộ Widget (Calo còn lại, Carbs/Fat/Protein, Deep Link Scan) | `business-analyst` | 2 | None | 🟢 Done |
| **`TSK-S5-UI-WIDGET`** | `EPIC-11` Design | **Gate 2** | Thiết kế Layout Widget Small & Medium theo chuẩn Celestial Dark UI | `ui-ux-designer` | 2 | TSK-S5-PRD-WIDGET | 🟢 Done |
| **`TSK-S5-DEV-WIDGET`** | `EPIC-11` Flutter | **Gate 4-6** | Tích hợp package `home_widget`, truyền dữ liệu SharedPreferences native & Deep Link Camera | `flutter-expert` | 4 | TSK-S5-UI-WIDGET | 🟢 Done |

### EPIC-07-EXT: AstroCoach Contextual Memory & 1-Tap Log (5 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S5-QA-COACH`** | `EPIC-07-EXT` BDD | **Gate 3** | Kịch bản BDD Gherkin cho Context Injection & 1-Tap Meal Log card | `qa-tester` | 2 | None | 🟢 Done |
| **`TSK-S5-DEV-COACH`** | `EPIC-07-EXT` Coach | **Gate 4-6** | Nạp User Profile/BMR/Streak vào Prompt, trích xuất meal tag và 1-Tap Log ghi Firestore Diary | `flutter-expert` | 3 | TSK-S5-QA-COACH | 🟢 Done |

---

## 🏛️ 2. Lưu Trữ Ma Trận WBS Sprint 04 (v1.3.0 Cosmic Onboarding & Flawless IA — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-S4-AUTH`** | `FEAT-01` Auth | **Gate 0-4** | Cấu hình `serverClientId` OAuth từ Web Client ID `google-services.json`, fix idToken Firebase Auth & xử lý lỗi hủy / mất mạng | `tech-lead` & `flutter-expert` | 5 | 🟢 Done |
| **`TSK-S4-NAV`** | Shell Navigation | **Gate 2-4** | Tái cấu trúc ShellScreen đưa `CoachRoute` (AstroCoach) lên Tab chính NavigationBar; giữ ManualEntryRoute top-level | `ui-ux-designer` & `flutter-expert` | 5 | 🟢 Done |
| **`TSK-S4-BRAND`** | Onboarding Flow | **Gate 1-4** | Nâng cấp 5 bước Onboarding gắn kết triết lý "Tiểu vũ trụ dinh dưỡng", tối ưu thông điệp y khoa & BMR/TDEE | `business-analyst` & `flutter-expert` | 3 | 🟢 Done |
| **`TSK-S4-COACH-UI`** | AI Coach UI | **Gate 2-4** | Thêm AstroCoach Proactive Card trên HomePage (1 chạm hỏi AI); mở rộng Quick Action Chips phong phú | `ui-ux-designer` & `flutter-expert` | 3 | 🟢 Done |
| **`TSK-S4-HLTH-DASH`** | Health Sync | **Gate 2-4** | Tối ưu hiển thị kết nối Apple Health từ Profile và chuẩn bị thẻ cân bằng năng lượng Calo In/Out | `flutter-expert` | 2 | 🟢 Done |
| **`TSK-S4-POLISH`** | Polish | **Gate 4-5** | Tinh chỉnh mượt mà chuyển tab Navigation, hiệu ứng bụi sao và bóng Celestial glow | `flutter-expert` | 4 | 🟢 Done |

---

## 🏛️ 3. Lưu Trữ Ma Trận WBS Sprint 03 (v1.2.0 AI Coach & Health — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-CHAT-01..06`** | `EPIC-07` AI Coach | **Gate 1 - 6** | PRD, UI Chat Bubble, BDD Gherkin, Domain/Data/Presentation, Ponytail Review, Test 100% Pass | Đa Sub-Agents | 13 | 🟢 Done |
| **`TSK-HLTH-01..06`** | `EPIC-10` Health | **Gate 1 - 6** | PRD Health 2 chiều, UI Health Dashboard, BDD TCs, Health plugin wrapper, Ponytail Review, Test 100% Pass | Đa Sub-Agents | 8 | 🟢 Done |
| **`TSK-REL-03`** | Release v1.2.0 | **Gate 7** | Gắn Git Tag v1.2.0, cập nhật Roadmap, đóng Sprint 03 | PO & PM | 2 | 🟢 Done |

---

## 🏛️ 4. Lưu Trữ Ma Trận WBS Sprint 02 (v1.1.0 Enhancements — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-MUL-01..04`** | `FEAT-06` Multi-Item | **Gate 1 - 4** | PRD, UI đa món, BDD scenarios, Gemini Vision Prompt | Đa Sub-Agents | 9 | 🟢 Done |
| **`TSK-OFF-01..04`** | `FEAT-07` Offline-Sync | **Gate 1 - 4** | PRD Offline, UI Banner, BDD TCs, Local Cache & Queue | Đa Sub-Agents | 6 | 🟢 Done |
| **`TSK-MIC-01..04`** | `FEAT-08` Micronutrients | **Gate 1 - 4** | PRD Vi chất, UI Chips, BDD TCs, DailyMicronutrientCard | Đa Sub-Agents | 4 | 🟢 Done |
| **`TSK-S2-REV / VER`**| Sprint 02 Quality | **Gate 5 - 6** | Ponytail Code Review & Automated test 100% Pass | Code Reviewer & QA | 4 | 🟢 Done |
| **`TSK-REL-02`** | Release v1.1.0 | **Gate 7** | Gắn Git Tag v1.1.0, cập nhật Roadmap, đóng Sprint 02 | PO & PM | 2 | 🟢 Done |

---

## 🏛️ 5. Lưu Trữ Ma Trận WBS Sprint 01 (v1.0.0 MVP — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-AUT-01..05`** | `FEAT-01` Auth | **Gate 1 - 5** | PRD, TCs, UI LoginPage, Riverpod, Sign-off | Đa Sub-Agents | 11 | 🟢 Done |
| **`TSK-SCN-01..05`** | `FEAT-02` Scanner | **Gate 1 - 5** | PRD Vision AI, TCs, FoodScannerPage, Latency < 2.5s | Đa Sub-Agents | 19 | 🟢 Done |
| **`TSK-TRK-01..05`** | `FEAT-03` Diary | **Gate 1 - 5** | PRD Diary, TCs Slider, ManualEntryPage, 86 tests pass | Đa Sub-Agents | 13 | 🟢 Done |
| **`TSK-ANA-01..02`** | `FEAT-04` Analytics | **Gate 4 - 5** | Ponytail Review, RepaintBoundary FL Chart, Sign-off | Đa Sub-Agents | 5 | 🟢 Done |
| **`TSK-PRO-01..02`** | `FEAT-05` Profile | **Gate 4 - 5** | Ponytail Review, BMR/TDEE calculations, Sign-off | Đa Sub-Agents | 5 | 🟢 Done |
| **`TSK-REL-01`** | Release v1.0.0 | **Gate 6** | Release notes, Git Tag v1.0.0, PO sign-off phát hành | PO & PM | 3 | 🟢 Done |
