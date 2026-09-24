# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 08
- **Tên Sprint**: Đại Trùng Tu Giao Diện: Cinematic Celestial UI & Holographic AR HUD Scanner
- **Mã Epic / Feature**: `EPIC-17` / `FEAT-15`
- **Phiên bản mục tiêu**: `v1.7.0`
- **Thời gian Sprint**: 24/09/2026 – 08/10/2026
- **Trạng thái Sprint**: 🟢 **Sprint Completed — 100% Hoàn Thành, Sẵn Sàng Release v1.7.0**
- **Tổng Story Points hoàn thành**: **12 / 12 SP (100%)**

---

## 🎯 Mục Tiêu Sprint 08

1. **Khung Ngắm AR HUD Sci-Fi**: Double-layered corner brackets xanh Electric `#1A73E8`, rotating reticle ring 60 FPS, real-time telemetry coordinates, focal lock badge 98.4%, và floating AI verified dish tag. 🟢 **Đạt 100%**.
2. **Phiếu Dinh Dưỡng Holographic Bento Sheet**: Hero Calorie Counter, radial target gauge (21% daily goal), bộ 3 Macro Holographic Bento pills chuẩn màu bất biến (Carbs `#1A73E8`, Protein `#FFD700`, Fat `#FF69B4`). 🟢 **Đạt 100%**.
3. **Thanh Header Kính Mờ & Điều Khiển**: Tiêu đề kép Gemini Vision AI 2.0 • Active, Flash toggle button, tips dialog, re-scan button, và Sticky Primary CTA trong Thumb Zone. 🟢 **Đạt 100%**.
4. **Google Stitch MCP Fidelity**: Trực tiếp đồng bộ và hiện thực hóa bản vẽ Stitch MCP (`projects/4740603587325816667/screens/902c781fecba432a84504fb895c44886`) chuẩn xác từng pixel. 🟢 **Đạt 100%**.
5. **Giao Diện Mâm Cơm Đa Món & Chi Tiết Bữa Ăn (Hotfix & Expansion)**: Xử lý triệt để duplicate nhật ký, tối ưu hóa tiêu đề mâm cơm 10 món không vỡ layout, tích hợp Bento Bottom Sheet xem chi tiết từng món con trong bữa. 🟢 **Đạt 100%**.

---

## 📋 Bảng Kanban Trực Quan Sprint 08

### 1. 📝 BACKLOG / TODO — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🔍 IN REVIEW & VERIFY — [0 SP]

### 4. 🏁 DONE — [12 SP]
| Mã Task | Feature / Epic | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---:|
| `TSK-S8-01-PRD` | `FEAT-15` | **G1** | Soạn thảo PRD BDD & Data Dictionary cho AR HUD Scanner | `business-analyst` | 1 | 🟢 **Gate 1 Signed Off** |
| `TSK-S8-02-STITCH-DESIGN`| `FEAT-15` | **G2** | Sinh bản vẽ Google Stitch MCP, HTML/CSS layout & Người dùng ký duyệt | `ui-ux-designer` | 2 | 🟢 **Gate 2 Signed Off** |
| `TSK-S8-03-QA-PLAN` | `FEAT-15` | **G3** | Master Test Plan, BDD Gherkin & ma trận test cases | `qa-tester` | 1 | 🟢 **Gate 3 Approved** |
| `TSK-S8-04-DEV-AR-HUD` | `FEAT-15` | **G4** | Nâng cấp `ScanningViewfinder` thành Sci-Fi AR HUD & Telemetry | `flutter-core-dev` | 2 | 🟢 **Done** |
| `TSK-S8-05-DEV-BENTO-UI`| `FEAT-15` | **G4** | Nâng cấp `CameraPage` AppBar & `ScanReviewPage` Holographic Bento | `flutter-core-dev` | 2 | 🟢 **Done** |
| `TSK-S8-06-HOTFIX-DEDUP`| `FEAT-15` | **G4** | Khắc phục duplicate nhật ký: Deterministic doc ID, in-memory dedup, debounce 2s | `flutter-core-dev` | 1 | 🟢 **Done** |
| `TSK-S8-07-MULTI-DISH-UI`| `FEAT-15` | **G4** | Tinh chỉnh header mâm cơm 10 món: badge đa món, title compact & subtitle tóm tắt | `flutter-core-dev` | 1 | 🟢 **Done** |
| `TSK-S8-08-MEAL-DETAIL` | `FEAT-15` | **G4** | Bento Bottom Sheet xem lại chi tiết dinh dưỡng & danh sách món con trong bữa ăn | `flutter-core-dev` | 2 | 🟢 **Done** |
| `TSK-S8-09-REVIEW` | `FEAT-15` | **G5** | Ponytail review: Phán quyết `Lean already. Ship.` (0 bloat) | `code-reviewer` | - | 🟢 **Passed** |
| `TSK-S8-10-QC-VERIFY` | `FEAT-15` | **G6** | Chạy automated test suite 159/159 pass (100%), analyze 0 issues | `qa-tester` | - | 🟢 **Gate 6 Signed Off** |
| `TSK-S8-11-RELEASE` | `FEAT-15` | **G7** | PO & Người dùng nghiệm thu phát hành phiên bản `v1.7.0` | `product-owner` | - | 🟢 **Release Approved** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 08 — AstroBite v1.7.0 Cinematic Celestial UI & AR HUD Scanner (Hoàn tất 24/09/2026)
- **Mục tiêu**: Kính ngắm AR HUD 60 FPS, telemetry viễn trắc, nhãn AI nổi, Holographic Bento Sheet, radial target gauge, bộ 3 Macro màu bất biến, kết nối Google Stitch MCP.
- **Kết quả**: **8 / 8 SP (100% Passed)** — 154/154 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.7.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.7.0.md)

### 🟢 Sprint 07 — AstroBite v1.6.0 Zero-Friction Ergonomic Logging (Hoàn tất 24/09/2026)
- **Mục tiêu**: Cắt giảm Time-to-Log < 3.5s, khay Recent Foods 1 chạm, Quick Weight Steppers, Sticky Bottom Action Bar trong Thumb Zone, Celestial Radar Pulse Viewfinder.
- **Kết quả**: **9 / 9 SP (100% Passed)** — 152/152 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.6.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.6.0.md)

### 🟢 Sprint 06 — AstroBite v1.5.0 Glanceable Celestial Core & 1-Tap Quick Log (Hoàn tất 24/09/2026)
- **Mục tiêu**: Nén khối hiển thị Calo & 3 Macro song song trong 1 card Cockpit duy nhất (tiết kiệm > 50% vertical space), thanh vi chất thu gọn, chip gợi ý Coach 1 dòng, 4 bữa ăn với nút `+` 1-tap quick add và router deep-link `mealType`.
- **Kết quả**: **18 / 18 SP (100% Passed)** — 148/148 tests pass, `flutter analyze` 0 issues, phát hành tag `v1.5.0`.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.5.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.5.0.md)
