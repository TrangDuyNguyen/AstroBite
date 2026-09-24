# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 07
- **Tên Sprint**: Custom Recipes, Meal Planning & Social Guilds
- **Phiên bản mục tiêu**: `v1.6.0`
- **Thời gian Sprint**: 24/09/2026 – 08/10/2026
- **Trạng thái Sprint**: 📋 **Chuẩn Bị Planning & Gate 0 Tech Spike (Pre-Sprint Planning)**
- **Tổng Story Points dự kiến**: ~24 SP

---

## 🎯 Mục Tiêu Sprint 07

1. **Custom Recipes & Meal Planning (`EPIC-12`)**: Cho phép người dùng tạo công thức nấu ăn cá nhân, tính toán tự động macro tổng và lập kế hoạch dinh dưỡng hàng tuần (Weekly Meal Prep).
2. **Social Guilds & Planetary Challenges (`EPIC-14`)**: Thử thách ăn sạch theo nhóm thiên hà, bảng xếp hạng thói quen và chia sẻ thành tích Streak.

---

## 📋 Bảng Kanban Trực Quan Sprint 07

### 1. 📝 BACKLOG / TODO — [6 SP - Đang phân rã WBS]
| Mã Task | Feature / Epic | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---:|
| `TSK-S7-TECH-SPIKE` | Kiến Trúc & Spike | **G0** | Nghiên cứu cấu trúc dữ liệu Recipe & Offline-First sync Firestore | `tech-lead` | 3 | ⏳ Chờ kickoff |
| `TSK-S7-PRD-RECIPE` | `EPIC-12` Recipes | **G1** | Soạn thảo PRD & BDD Given-When-Then cho Custom Recipes | `business-analyst` | 3 | ⏳ Chờ G0 |

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🔍 IN REVIEW & VERIFY — [0 SP]

### 4. 🏁 DONE — [0 SP]

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 06 — AstroBite v1.5.0 Glanceable Celestial Core & 1-Tap Quick Log (Hoàn tất 24/09/2026)
- **Mục tiêu**: Nén khối hiển thị Calo & 3 Macro song song trong 1 card Cockpit duy nhất (tiết kiệm > 50% vertical space), thanh vi chất thu gọn, chip gợi ý Coach 1 dòng, 4 bữa ăn với nút `+` 1-tap quick add và router deep-link `mealType`.
- **Kết quả**: **18 / 18 SP (100% Passed)** — 148/148 tests pass, `flutter analyze` 0 issues, phát hành tag `v1.5.0`.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.5.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.5.0.md)

### 🟢 Sprint 05 — AstroBite v1.4.0 The Cosmic Habit Loop & Frictionless Access (Hoàn tất 22/09/2026)
- **Mục tiêu**: Kéo dài D30 Retention ≥ 35% thông qua Cosmic Streak Engine (`EPIC-13`), Native Home/Lock Screen Widgets (`EPIC-11`), và Trợ lý ảo AstroCoach AI Context Memory + 1-Tap Log (`EPIC-07-EXT`).
- **Kết quả**: **26 / 26 SP (100% Passed)** — 137/137 tests pass, `flutter analyze` 0 issues, phát hành tag `v1.4.0`.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.4.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.4.0.md)

### 🟢 Sprint 04 — AstroBite v1.3.0 Cosmic Onboarding & Flawless Product Architecture (Hoàn tất 19/09/2026)
- **Mục tiêu**: Khắc phục Google OAuth login, tái cấu trúc Shell Navigation (đưa AstroCoach lên Tab 2), đồng nhất nhận diện thương hiệu Cosmic Nutrition.
- **Kết quả**: **18 / 18 SP (100% Passed)** — 119/119 tests pass, phát hành tag `v1.3.0`.
- **Commit**: `b859712`, `0111be9`.

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
