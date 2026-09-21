# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 05
- **Tên Sprint**: The Cosmic Habit Loop & Frictionless Access
- **Phiên bản mục tiêu**: `v1.4.0`
- **Thời gian Sprint**: 19/09/2026 – 03/10/2026
- **Trạng thái Sprint**: 🟡 **Khởi Động & Thực Thi (Active Execution)**
- **Tổng Story Points**: 26 SP (Must: 13 SP [50%], Should: 8 SP [31%], Could: 5 SP [19%])

---

## 🎯 Mục Tiêu Sprint 05

Thúc đẩy tỷ lệ giữ chân **D30 Retention ≥ 35%** và đưa thời gian log món ăn xuống **< 2s**:
1. **Cosmic Gamification & Streak Engine (`EPIC-13`)**: Vòng năng lượng tiểu vũ trụ (Cosmic Core Energy Ring), hệ thống tính chuỗi ngày ăn sạch (Streak), cơ chế bảo vệ chuỗi Starlight Shield, và hệ thống danh hiệu/huy hiệu hành tinh.
2. **Mobile Widgets & Quick Glance (`EPIC-11`)**: Widget Calo/Macro thu nhỏ ngoài LockScreen / HomeScreen (iOS WidgetKit & Android AppWidget) kèm nút 1 chạm mở camera scan.
3. **AstroCoach AI Enhancement (`EPIC-07-EXT`)**: Bộ nhớ ngữ cảnh dài hạn (đọc profile/dị ứng/thói quen) và nút 1 chạm ghi trực tiếp món ăn gợi ý vào nhật ký (`1-Tap Meal Log`).

---

## 📋 Bảng Kanban Trực Quan Sprint 05

### 1. 📝 BACKLOG / TODO — [0 SP]
*Tất cả hạng mục đã hoàn tất!*

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🔍 IN REVIEW & VERIFY — [0 SP]

### 4. 🏁 DONE — [26 SP]
| Mã Task | Feature / Epic | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---:|
| `TSK-S5-TECH-SPIKE` | Kiến Trúc & Spike | **G0** | Nghiên cứu native widget sync & Streak state machine (ADR-05) | `tech-lead` | 3 | 🟢 Done |
| `TSK-S5-PRD-STREAK` | `EPIC-13` Gamification | **G1** | Soạn thảo PRD & BDD Given-When-Then cho Cosmic Streak & Badges | `business-analyst` | 3 | 🟢 Done |
| `TSK-S5-UI-STREAK` | `EPIC-13` Gamification | **G2** | Thiết kế Celestial Energy Ring, Badges & Shimmer/Streak UI | `ui-ux-designer` | 3 | 🟢 Done |
| `TSK-S5-DEV-STREAK` | `EPIC-13` Gamification | **G4-G6** | Domain Entity `StreakRecord`, Riverpod `streakNotifierProvider`, UI & 13 tests pass | `flutter-expert` | 4 | 🟢 Done |
| `TSK-S5-PRD-WIDGET` | `EPIC-11` Widgets | **G1** | Soạn thảo PRD & Spec dữ liệu đồng bộ Widget iOS/Android | `business-analyst` | 2 | 🟢 Done |
| `TSK-S5-UI-WIDGET` | `EPIC-11` Widgets | **G2** | Thiết kế Wireframe/Layout Widget Small, Medium và Lockscreen | `ui-ux-designer` | 2 | 🟢 Done |
| `TSK-S5-DEV-WIDGET` | `EPIC-11` Widgets | **G4-G6** | Tích hợp package `home_widget`, WidgetSyncService, deep-link scanner & tests pass | `flutter-expert` | 4 | 🟢 Done |
| `TSK-S5-QA-TESTPLAN`| Quality Assurance | **G3** | Xây dựng BDD Gherkin testcases cho 1-Tap AI Coach context | `qa-tester` | 2 | 🟢 Done |
| `TSK-S5-DEV-COACH`  | `EPIC-07-EXT` AI Coach | **G4-G6** | Nâng cấp context memory (profile/streak) và nút 1-Tap Log trong Chat | `flutter-expert` | 3 | 🟢 Done |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 04 — AstroBite v1.3.0 Cosmic Onboarding & Flawless Product Architecture (Hoàn tất 19/09/2026)
- **Mục tiêu**: Khắc phục Google OAuth login, tái cấu trúc Shell Navigation (đưa AstroCoach lên Tab 2), đồng nhất nhận diện thương hiệu Cosmic Nutrition.
- **Kết quả**: **18 / 18 SP (100% Passed)** — 119/119 tests pass, phát hành tag `v1.3.0`.
- **Commit**: `b859712`, `0111be9`.

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 03 — AstroBite v1.2.0 Trợ Lý AI Dinh Dưỡng & Apple Health (Hoàn tất 19/09/2026)
- **Mục tiêu**: Tích hợp Gemini AI Chat Coach (`EPIC-07`) và Apple Health / Health Connect (`EPIC-10`).
- **Kết quả**: **21 / 21 SP (100% Passed)** — 119/119 tests pass, phát hành tag `v1.2.0`.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.2.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.2.0.md)

### 🟢 Sprint 02 — AstroBite v1.1.0 Dinh Dưỡng Nâng Cao & Trải Nghiệm Offline (Hoàn tất 18/09/2026)
- **Mục tiêu**: Mở rộng Gemini Vision AI nhận diện đa món (`FEAT-06`), Offline-First Cache & Sync (`FEAT-07`), vi chất (`FEAT-08`).
- **Kết quả**: **26 / 26 SP (100% Passed)** — 110/110 tests pass, phát hành tag `v1.1.0`.

### 🟢 Sprint 01 — AstroBite v1.0.0 MVP Release (Hoàn tất 18/09/2026)
- **Mục tiêu**: Hoàn tất kiểm thử, rà soát Ponytail cho Analytics & Profile, đóng gói v1.0.0.
- **Kết quả**: **13 / 13 SP (100% Passed)**, 94/94 tests pass, phát hành tag `v1.0.0`.
