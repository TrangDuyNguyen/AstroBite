# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 09
- **Tên Sprint**: AstroCoach AI Intelligence v2 & Conversational Nutritionist Cockpit
- **Mã Epic / Feature**: `EPIC-18` / `FEAT-16`
- **Phiên bản mục tiêu**: `v1.8.0`
- **Thời gian Sprint**: 24/09/2026 – 08/10/2026
- **Trạng thái Sprint**: 🟢 **Sprint Completed — 100% Hoàn Thành, Sẵn Sàng Release v1.8.0**
- **Tổng Story Points hoàn thành**: **14 / 14 SP (100%)**

---

## 🎯 Mục Tiêu Sprint 09

1. **Context Header Strip (`US-01`)**: Bảng điều khiển dinh dưỡng thời gian thực hiển thị calo còn lại hôm nay, 3 thanh macro chuẩn màu bất biến (Carbs `#1A73E8`, Protein `#FFD700`, Fat `#FF69B4`), và cảnh báo Natri tự động khi >= 1,500mg/2,000mg. 🟢 **Đạt 100%**.
2. **Khối Dữ Liệu Có Cấu Trúc & Trích Xuất An Toàn (`US-02`)**: Hỗ trợ bóc tách khối markdown ` ```astrobite-meal ` song song với thẻ ẩn cũ, cơ chế fallback văn bản an toàn khi block bị lỗi cú pháp. 🟢 **Đạt 100%**.
3. **Thẻ Holographic Bento Meal Card & 1-Tap Log Direct Action (`US-03`, `US-04`)**: Hiển thị thẻ món ăn Bento chuẩn thiết kế Google Stitch MCP (`projects/4740603587325816667`, Screen `3328fde738f24013a34124bfdecd7484`), nút bấm 1-Tap Log nạp tức thì vào nhật ký ăn uống và chuyển trạng thái `✓ Đã ghi vào nhật ký`. 🟢 **Đạt 100%**.
4. **Dynamic Time-of-Day Quick Action Chips (`US-05`)**: Tự động hiển thị gợi ý thông minh phù hợp theo 4 khung giờ thực tế (Sáng, Trưa, Chiều, Tối). 🟢 **Đạt 100%**.
5. **Celestial Dark UI Polish (AppBar to Bottom)**: Avatar hiệu ứng hào quang Aura, trạng thái suy nghĩ Cosmic Pulse nhịp nhàng, thanh input ghim sát đáy công thái học. 🟢 **Đạt 100%**.

---

## 📋 Bảng Kanban Trực Quan Sprint 09

### 1. 📝 BACKLOG / TODO — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🔍 IN REVIEW & VERIFY — [0 SP]

### 4. 🏁 DONE — [14 SP]
| Mã Task | Feature / Epic | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---:|
| `TSK-S9-01-TECH-SPIKE` | `FEAT-16` | **G0** | Nghiên cứu kiến trúc ADR-008 Approach C (Regex block extraction SLA <= 2.5s) | `tech-lead` | 1 | 🟢 **Gate 0 Approved** |
| `TSK-S9-02-PRD-BDD` | `FEAT-16` | **G1** | Soạn thảo PRD 5 User Stories BDD & Data Contract `astrobite-meal` | `business-analyst` | 2 | 🟢 **Gate 1 Signed Off** |
| `TSK-S9-03-STITCH-DESIGN`| `FEAT-16` | **G2** | Sinh bản vẽ Google Stitch MCP, 4pt blueprint, layout từ AppBar tới Bottom | `ui-ux-designer` | 2 | 🟢 **Gate 2 Signed Off** |
| `TSK-S9-04-QA-TEST-PLAN` | `FEAT-16` | **G3** | Master Test Plan, BDD Gherkin scenarios & ma trận kiểm thử EP/BVA | `qa-tester` | 1 | 🟢 **Gate 3 Approved** |
| `TSK-S9-05-DEV-CONTEXT-BAR`| `FEAT-16`| **G4** | Context Header Strip: Calo còn lại, 3 thanh macro & cảnh báo Natri | `flutter-core-dev` | 2 | 🟢 **Done** |
| `TSK-S9-06-DEV-BENTO-CARD` | `FEAT-16`| **G4** | Holographic Bento Meal Card & 1-Tap Log Action Button | `flutter-core-dev` | 3 | 🟢 **Done** |
| `TSK-S9-07-DEV-QUICK-CHIPS`| `FEAT-16`| **G4** | Dynamic Time-of-Day Quick Action chips & Cosmic Pulse thinking | `flutter-core-dev` | 2 | 🟢 **Done** |
| `TSK-S9-08-DEV-AI-PROMPT` | `FEAT-16` | **G4** | Nâng cấp system prompt CoachRepository & làm giàu ngữ cảnh Natri | `cloud-ai-dev` | 1 | 🟢 **Done** |
| `TSK-S9-09-PONYTAIL-REVIEW`| `FEAT-16`| **G5** | Ponytail Code Review: 0 bloat, 0 new deps, phán quyết `Lean already. Ship.` | `code-reviewer` | - | 🟢 **Passed** |
| `TSK-S9-10-QA-VERIFICATION`| `FEAT-16`| **G6** | Automated test suite 163/163 pass (100%), analyze 0 issues | `qa-tester` | - | 🟢 **Gate 6 Signed Off** |
| `TSK-S9-11-RELEASE-GATE7` | `FEAT-16` | **G7** | PO & PM ký duyệt phát hành toàn diện phiên bản `v1.8.0` | `product-owner` | - | 🟢 **Release Approved** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 09 — AstroBite v1.8.0 AstroCoach AI Intelligence v2 Cockpit (Hoàn tất 24/09/2026)
- **Mục tiêu**: Bảng điều khiển dinh dưỡng thời gian thực Context Header Strip, Holographic Bento Meal Card với 1-Tap Log, Dynamic Time-of-Day Quick Action Chips, Cosmic Pulse state, kết nối Google Stitch MCP.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 163/163 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.8.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.8.0.md)

### 🟢 Sprint 08 — AstroBite v1.7.0 Cinematic Celestial UI & AR HUD Scanner (Hoàn tất 24/09/2026)
- **Mục tiêu**: Kính ngắm AR HUD 60 FPS, telemetry viễn trắc, nhãn AI nổi, Holographic Bento Sheet, radial target gauge, bộ 3 Macro màu bất biến, kết nối Google Stitch MCP.
- **Kết quả**: **12 / 12 SP (100% Passed)** — 159/159 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.7.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.7.0.md)

### 🟢 Sprint 07 — AstroBite v1.6.0 Zero-Friction Ergonomic Logging (Hoàn tất 24/09/2026)
- **Mục tiêu**: Cắt giảm Time-to-Log < 3.5s, khay Recent Foods 1 chạm, Quick Weight Steppers, Sticky Bottom Action Bar trong Thumb Zone, Celestial Radar Pulse Viewfinder.
- **Kết quả**: **9 / 9 SP (100% Passed)** — 152/152 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.6.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.6.0.md)
