# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 11
- **Tên Sprint**: Generative UI Chat Cockpit (Flutter GenUI SDK & Gemini 3.8 Flash)
- **Mã Epic / Feature**: `EPIC-17` / `FEAT-18`
- **Phiên bản mục tiêu**: `v2.0.0`
- **Thời gian Sprint**: 26/09/2026 – 10/10/2026
- **Trạng thái Sprint**: 🟢 **Sprint Completed & Closed — 8 Gates Cleared, Released v2.0.0**
- **Tổng Story Points cam kết**: **14 SP** (Tiến độ: **14 / 14 SP — 100.0%**)

---

## 🎯 Mục Tiêu Sprint 11

1. **A2UI Protocol & Gemini 3.8 Flash Adapter (`US-03`)**: Tích hợp luồng A2UI JSON streaming với `gemini-3.8-flash`, đảm bảo độ trễ First-Widget `< 1.2s`, 0% lỗi parsing schema.
2. **CatalogItem MealQuickLogCard (`US-01`)**: Thẻ tương tác món ăn gồm tên món, calo, 3 màu Macro chuẩn bất biến (Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700`), Stepper trọng lượng và nút [1-Tap Log to Diary] phản hồi < 100ms.
3. **CatalogItem MacroBudgetGauge (`US-02`)**: Đồng hồ so sánh Calo nạp vào dự kiến vs Ngân sách calo còn lại trong ngày của người dùng.
4. **CatalogItem QuickChoiceChips (`US-04`)**: Dải gợi ý hành động ngữ cảnh (chọn khung giờ ăn, loại món) cho phép tương tác phản hồi ngược lại cho AI.
5. **Celestial Dark UI Integration & Zero-Bloat**: Render 60 FPS trong danh sách chat, kế thừa `GlassCard`, không gây rò rỉ bộ nhớ, tuân thủ kỷ luật Ponytail.

---

## 📋 Bảng Kanban Trực Quan Sprint 11

### 1. 📝 BACKLOG / QUEUED — [0 SP]
*Tất cả task đã hoàn thành 100%.*

### 2. ⚡ READY / IN PROGRESS — [0 SP]
*Không còn task in progress.*

### 3. 🏁 DONE — [14 SP]
| Mã Task | Feature | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S11-01-TECH-FEASIBILITY` | `FEAT-18` | **G0** | Tech Spike GenUI & Dart 3.7.2 compatibility, ban hành ADR-06 | `tech-lead` | 1 | 🟢 **Gate 0 Approved** |
| `TSK-S11-02-PRD-BDD` | `FEAT-18` | **G1** | PRD 4 User Stories BDD, Data Dictionary & Gate 1 Sign-Off | `business-analyst` | 2 | 🟢 **Gate 1 Signed Off** |
| `TSK-S11-03-STITCH-DESIGN` | `FEAT-18` | **G2** | Sinh layout blueprint & 5 trạng thái cho 3 Catalog Items | `ui-ux-designer` | 2 | 🟢 **Gate 2 Signed Off** |
| `TSK-S11-04-QA-TEST-PLAN` | `FEAT-18` | **G3** | Master Test Plan, kịch bản BDD Gherkin & ma trận EP/BVA cho GenUI | `qa-tester` | 2 | 🟢 **Gate 3 Approved** |
| `TSK-S11-05-DEV-GENUI-CORE` | `FEAT-18` | **G4** | GenUI Core Engine (`Catalog`, `CatalogItem`, `SurfaceController`, `DataModel`) | `flutter-core-dev` | 3 | 🟢 **Gate 4 Implemented** |
| `TSK-S11-06-DEV-MEAL-CARD` | `FEAT-18` | **G4** | UI Widget `MealQuickLogCard` (3 Macro chuẩn, Stepper, 1-Tap Log) | `flutter-core-dev` | 2 | 🟢 **Gate 4 Implemented** |
| `TSK-S11-07-DEV-GAUGE-CHIPS` | `FEAT-18` | **G4** | UI Widgets `MacroBudgetGauge` & `QuickChoiceChips` | `flutter-core-dev` | 2 | 🟢 **Gate 4 Implemented** |
| `TSK-S11-08-PONYTAIL-REVIEW` | `FEAT-18` | **G5** | Ponytail Code Review: 0 bloat, diff tối giản | `code-reviewer` | - | 🟢 **Gate 5 Approved** |
| `TSK-S11-09-QA-VERIFICATION` | `FEAT-18` | **G6** | Automated test suite 100% pass (198/198), analyze 0 issues | `qa-tester` | - | 🟢 **Gate 6 Signed Off** |
| `TSK-S11-10-RELEASE-GATE7` | `FEAT-18` | **G7** | PO & Tech Lead nghiệm thu toàn diện, phát hành `v2.0.0` | `product-owner` | - | 🟢 **Gate 7 Released** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 10 — AstroBite v1.9.0 Custom Recipes & Meal Planning Architecture (Hoàn tất 26/09/2026)
- **Mục tiêu**: Interactive Recipe Builder (`US-01`), Dynamic Portion Scaler (`US-02`), Weekly Meal Planner Calendar (`US-03`), 1-Tap Log to Diary (`US-04`), Offline Resilience & Data Integrity.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 175/175 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.9.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.9.0.md)

### 🟢 Sprint 09 — AstroBite v1.8.0 - v1.8.2 AstroCoach Cockpit & Mascot Navigation (Hoàn tất 24/09/2026)
- **Mục tiêu**: Bảng điều khiển dinh dưỡng Context Header Strip, Holographic Bento Meal Card với 1-Tap Log, AstroBot Mascot Navigation Dock, Fastlane Release CI/CD pipeline.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 168/168 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.8.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.8.0.md)

### 🟢 Sprint 08 — AstroBite v1.7.0 Cinematic Celestial UI & AR HUD Scanner (Hoàn tất 24/09/2026)
- **Mục tiêu**: Kính ngắm AR HUD 60 FPS, telemetry viễn trắc, nhãn AI nổi, Holographic Bento Sheet, radial target gauge, bộ 3 Macro màu bất biến, kết nối Google Stitch MCP.
- **Kết quả**: **12 / 12 SP (100% Passed)** — 159/159 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.7.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.7.0.md)

### 🟢 Sprint 07 — AstroBite v1.6.0 Zero-Friction Ergonomic Logging (Hoàn tất 24/09/2026)
- **Mục tiêu**: Cắt giảm Time-to-Log < 3.5s, khay Recent Foods 1 chạm, Quick Weight Steppers, Sticky Bottom Action Bar trong Thumb Zone, Celestial Radar Pulse Viewfinder.
- **Kết quả**: **9 / 9 SP (100% Passed)** — 152/152 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.6.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.6.0.md)
