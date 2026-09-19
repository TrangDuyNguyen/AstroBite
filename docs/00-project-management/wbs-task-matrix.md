# Ma Trận Phân Rã Công Việc 7 Cổng (WBS Task Matrix)

- **Quản lý bởi**: Sub-Agent Project Manager (PM) & Sub-Agent Product Owner (PO)
- **Ánh xạ quy trình**: 7-Gate Delivery Flow (BA ➔ UI/UX Designer ➔ QA ➔ Dev FE ➔ Code Review ➔ Verification ➔ Release)
- **Cập nhật lần cuối**: 2026-09-19

---

## 🏗️ 1. Bảng Ma Trận Phân Rã WBS Sprint 04 (v1.3.0 Cosmic Onboarding & Flawless IA — Active)

### EPIC-01-FIX: Google Sign-in & Authentication Resilience (5 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S4-AUTH`** | `FEAT-01` Auth | **Gate 0-4** | Cấu hình `serverClientId` OAuth từ Web Client ID `google-services.json`, fix idToken Firebase Auth & xử lý lỗi hủy / mất mạng | `tech-lead` & `flutter-expert` | 5 | None | 🟢 Done (Verified) |

### FEAT-NAV: Information Architecture & Navigation Restructuring (5 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S4-NAV`** | Shell Navigation | **Gate 2-4** | Tái cấu trúc ShellScreen đưa `CoachRoute` (AstroCoach) lên Tab chính NavigationBar; giữ ManualEntryRoute top-level | `ui-ux-designer` & `flutter-expert` | 5 | None | 🟢 Done (Verified) |

### FEAT-BRAND: Cosmic Nutrition Storytelling & Onboarding Alignment (3 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S4-BRAND`** | Onboarding Flow | **Gate 1-4** | Nâng cấp 5 bước Onboarding gắn kết triết lý "Tiểu vũ trụ dinh dưỡng", tối ưu thông điệp y khoa & BMR/TDEE | `business-analyst` & `flutter-expert` | 3 | None | 🟢 Done (Verified) |

### EPIC-07-ENH: AstroCoach Proactive Home Card & Quick Prompt Actions (3 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S4-COACH-UI`** | AI Coach UI | **Gate 2-4** | Thêm AstroCoach Proactive Card trên HomePage (1 chạm hỏi AI); mở rộng Quick Action Chips phong phú | `ui-ux-designer` & `flutter-expert` | 3 | TSK-S4-NAV | 🟢 Done (Verified) |

### EPIC-10-ENH: Apple Health / Health Connect Integration Visibility (2 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S4-HLTH-DASH`** | Health Sync | **Gate 2-4** | Tối ưu hiển thị kết nối Apple Health từ Profile và chuẩn bị thẻ cân bằng năng lượng Calo In/Out | `flutter-expert` | 2 | None | 🟢 Done (Verified) |

### Visual Polish & Micro-animations (4 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S4-POLISH`** | Polish | **Gate 4-5** | Tinh chỉnh mượt mà chuyển tab Navigation, hiệu ứng bụi sao và bóng Celestial glow | `flutter-expert` | 4 | TSK-S4-NAV | ⚪ Backlog |

---

## 🏛️ 2. Lưu Trữ Ma Trận WBS Sprint 03 (v1.2.0 AI Coach & Health — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-CHAT-01..06`** | `EPIC-07` AI Coach | **Gate 1 - 6** | PRD, UI Chat Bubble, BDD Gherkin, Domain/Data/Presentation, Ponytail Review, Test 100% Pass | Đa Sub-Agents | 13 | 🟢 Done |
| **`TSK-HLTH-01..06`** | `EPIC-10` Health | **Gate 1 - 6** | PRD Health 2 chiều, UI Health Dashboard, BDD TCs, Health plugin wrapper, Ponytail Review, Test 100% Pass | Đa Sub-Agents | 8 | 🟢 Done |
| **`TSK-REL-03`** | Release v1.2.0 | **Gate 7** | Gắn Git Tag v1.2.0, cập nhật Roadmap, đóng Sprint 03 | PO & PM | 2 | 🟢 Done |

---

## 🏛️ 3. Lưu Trữ Ma Trận WBS Sprint 02 (v1.1.0 Enhancements — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-MUL-01..04`** | `FEAT-06` Multi-Item | **Gate 1 - 4** | PRD, UI đa món, BDD scenarios, Gemini Vision Prompt | Đa Sub-Agents | 9 | 🟢 Done |
| **`TSK-OFF-01..04`** | `FEAT-07` Offline-Sync | **Gate 1 - 4** | PRD Offline, UI Banner, BDD TCs, Local Cache & Queue | Đa Sub-Agents | 6 | 🟢 Done |
| **`TSK-MIC-01..04`** | `FEAT-08` Micronutrients | **Gate 1 - 4** | PRD Vi chất, UI Chips, BDD TCs, DailyMicronutrientCard | Đa Sub-Agents | 4 | 🟢 Done |
| **`TSK-S2-REV / VER`**| Sprint 02 Quality | **Gate 5 - 6** | Ponytail Code Review & Automated test 100% Pass | Code Reviewer & QA | 4 | 🟢 Done |
| **`TSK-REL-02`** | Release v1.1.0 | **Gate 7** | Gắn Git Tag v1.1.0, cập nhật Roadmap, đóng Sprint 02 | PO & PM | 2 | 🟢 Done |

---

## 🏛️ 4. Lưu Trữ Ma Trận WBS Sprint 01 (v1.0.0 MVP — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-AUT-01..05`** | `FEAT-01` Auth | **Gate 1 - 5** | PRD, TCs, UI LoginPage, Riverpod, Sign-off | Đa Sub-Agents | 11 | 🟢 Done |
| **`TSK-SCN-01..05`** | `FEAT-02` Scanner | **Gate 1 - 5** | PRD Vision AI, TCs, FoodScannerPage, Latency < 2.5s | Đa Sub-Agents | 19 | 🟢 Done |
| **`TSK-TRK-01..05`** | `FEAT-03` Diary | **Gate 1 - 5** | PRD Diary, TCs Slider, ManualEntryPage, 86 tests pass | Đa Sub-Agents | 13 | 🟢 Done |
| **`TSK-ANA-01..02`** | `FEAT-04` Analytics | **Gate 4 - 5** | Ponytail Review, RepaintBoundary FL Chart, Sign-off | Đa Sub-Agents | 5 | 🟢 Done |
| **`TSK-PRO-01..02`** | `FEAT-05` Profile | **Gate 4 - 5** | Ponytail Review, BMR/TDEE calculations, Sign-off | Đa Sub-Agents | 5 | 🟢 Done |
| **`TSK-REL-01`** | Release v1.0.0 | **Gate 6** | Release notes, Git Tag v1.0.0, PO sign-off phát hành | PO & PM | 3 | 🟢 Done |
