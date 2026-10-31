# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 34
- **Tên Sprint**: System Security, Native HealthKit/Health Connect, Social Guilds Cloud Backend & Meal Planner 3D Clay Overhaul
- **Mã Epic / Feature**: `EPIC-PROD-READY-01`
- **Phiên bản mục tiêu**: `v3.6.0` (Build 24)
- **Thời gian Sprint**: 21/10/2026 – 31/10/2026
- **Trạng thái Sprint**: 🟢 **COMPLETED**
- **Tổng Story Points cam kết**: **21 SP** (Tiến độ: **21 / 21 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 34: Đạt Chuẩn Sẵn Sàng Sản Xuất (Production-Grade Readiness)

1. **Gate 0 & Gate 1 (4 SP)**: Kiến trúc Backend Gemini AI Proxy qua Firebase Functions (`functions/src/index.ts`) triệt tiêu rò rỉ secret key; thiết kế cầu nối Native Platform Channel cho Apple HealthKit & Android Health Connect.
2. **Gate 2 & Gate 3 (4 SP)**: Cấu hình iOS Widget Extension Target, thiết kế UI/UX 3D Clay Voice Logging không dùng emoji và lập Master Test Plan cho toàn bộ tính năng đồng bộ background.
3. **Gate 4 (8 SP)**: Triển khai Firestore backend cho Bang hội (`GuildRepositoryImpl`), kích hoạt thông báo FCM; bóc tách `add_meal_plan_item_sheet.dart` triệt tiêu 100% file vi phạm Hard Cap (> 500 dòng).
4. **Gate 5, 6, 6.5 & 7 (5 SP)**: Ponytail Clean Review, 395/395 automated tests pass (100%), Security Clearance OWASP MASVS v2.0 và phát hành `v3.6.0`.

---

## 📋 Bảng Kanban Sprint 34

### 1. 📝 BACKLOG / QUEUED — [0 SP]
*(Toàn bộ tasks đã hoàn tất và phát hành)*

### 2. ⚡ IN PROGRESS — [0 SP]
*(Sprint đã hoàn tất 100%)*

### 3. 🏁 DONE — [21 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S34-01-SEC` | `functions/src/index.ts` | **G0/G4** | Cloud AI Dev: Triển khai Firebase Functions Gemini Proxy & ESLint | `cloud-ai-dev` | 5 | 🏁 **DONE** |
| `TSK-S34-02-HEALTH` | `lib/features/health/` | **G0/G4** | Native Dev: Tích hợp HealthKit & Health Connect + iOS Widget Target | `flutter-native-dev` | 5 | 🏁 **DONE** |
| `TSK-S34-03-GUILD` | `lib/features/guilds/` | **G4** | Cloud AI Dev: Chuyển đổi Firestore Backend & FCM notifications | `cloud-ai-dev` | 3 | 🏁 **DONE** |
| `TSK-S34-04-MEAL-PLAN`| `lib/features/recipes/` | **G4** | Dev Core: Bóc tách Meal Planner widgets & triệt tiêu Hard Cap | `flutter-core-dev` | 3 | 🏁 **DONE** |
| `TSK-S34-05-VOICE-UI` | `lib/features/voice/` | **G2/G4** | Dev Core: Chuẩn hóa 3D Clay Voice Logging & triệt tiêu emoji icons | `flutter-core-dev` | 2 | 🏁 **DONE** |
| `TSK-S34-06-REVIEW` | Codebase & Git Diff | **G5** | Reviewer: Ponytail Diff Review, zero bloat, 0 hard cap violations | `code-reviewer` | 1 | 🏁 **DONE** |
| `TSK-S34-07-RELEASE` | Release v3.6.0 | **G6/G7** | QA & Security & Tech Lead & PO: 395 tests pass, Gate 7 Release v3.6.0 | `product-owner` | 2 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 33 — AstroBite v3.5.0 Water Intake Tracker (Hoàn tất 21/10/2026)
- **Mục tiêu**: Theo dõi lượng nước uống hàng ngày, Claymorphic 60 FPS, đồng bộ Local Cache + Cloud Firestore ngầm.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 361/361 tests pass, PO ký duyệt phát hành v3.5.0.
- **Biên bản phát hành**: `docs/03-prd-features/40-water-intake-tracker/` & Git tag `v3.5.0`.

### 🟢 Sprint 32 — AstroBite v3.4.0 Smart Packaged Food Scanning (Hoàn tất 19/10/2026)
- **Mục tiêu**: Quét mã vạch Open Food Facts API & OCR bảng thành phần dinh dưỡng nhãn hộp bằng Gemini 2.0 Flash Vision.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 333/333 tests pass, latency < 0.8s, Git tag `v3.4.0`.

### 🟢 Sprint 31 — AstroBite v3.3.0 Internationalization Foundation (Hoàn tất 11/10/2026)
- **Mục tiêu**: Nền tảng song ngữ VI + EN chuẩn Flutter SDK `flutter_localizations`, loại bỏ toàn bộ chuỗi hardcode.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 327/327 tests pass, Git tag `v3.3.0`.
