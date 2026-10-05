# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 18
- **Tên Sprint**: Live Social Sync & Streak Nudge
- **Mã Epic / Feature**: `EPIC-COMMUNITY` / `FEAT-S18-LIVE-SOCIAL`
- **Phiên bản mục tiêu**: `v2.8.0`
- **Thời gian Sprint**: 04/10/2026 – 18/10/2026
- **Trạng thái Sprint**: 🏁 **DONE**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **13 / 13 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 18: Live Social Sync & Streak Nudge

1. **Live Leaderboard Stream (`TSK-S18-05-CLIENT` & `TSK-S18-04-BACKEND` — 7 SP)**: Chuyển hóa toàn bộ Leaderboard sang kiến trúc Stream cập nhật thời gian thực qua `SocialRepository` và Riverpod `leaderboardStreamProvider` (1 Read / session).
2. **Real Friend Connection (`social_addFriend` — 3 SP)**: Xử lý logic kết bạn với validation chặt chẽ (chống kết bạn chính mình, chống trùng lặp, chống input rác).
3. **Streak Nudge / Peer Accountability (`TSK-S18-NUDGE` — 3 SP)**: Nút "⚡ Nhắc" (Streak Nudge) kèm hộp thoại xác nhận ClaySheet và cơ chế Anti-Spam (chỉ cho phép nhắc 1 lần / bạn bè / ngày).

---

## 📋 Bảng Kanban Sprint 18

### 1. 📝 BACKLOG / QUEUED — [0 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| Không có task | | | | | | |

### 2. ⚡ IN PROGRESS — [0 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| Không có task | | | | | | |

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S18-00-SPIKE` | Kiến trúc Live Stream & FCM Nudge | **G0** | Tech Lead: Nghiên cứu cấu trúc Document tĩnh cho Firestore Reads & FCM Payload | `tech-lead` | 1 | 🟢 **DONE** |
| `TSK-S18-01-PRD` | `docs/03-prd-features/25-live-social-and-streak-nudge/` | **G1** | BA: Soạn PRD & User Stories BDD cho Live Leaderboard & Streak Nudge | `business-analyst` | 2 | 🟢 **DONE** |
| `TSK-S18-02-DESIGN` | UI Blueprint Modal Nudge & Live Badges | **G2** | UI/UX Designer: Thiết kế ClayBadge, Modal Nudge & 5 UI States | `ui-ux-designer` | 2 | 🟢 **DONE** |
| `TSK-S18-03-TEST-PLAN` | Master Test Plan Sprint 18 | **G3** | QA Tester: Thiết kế 8 kịch bản test biên BVA và kiểm thử phá hoại | `qa-tester` | 1 | 🟢 **DONE** |
| `TSK-S18-04-BACKEND` | `social_repository.dart` | **G4** | Cloud Dev: Triển khai luồng dữ liệu Stream, validation chống trùng & anti-spam | `cloud-ai-dev` | 3 | 🟢 **DONE** |
| `TSK-S18-05-CLIENT` | `leaderboard_page.dart` | **G4** | Dev FE: Tích hợp Riverpod `leaderboardStreamProvider`, Nudge Modal, Shimmer 5 States | `flutter-core-dev` | 4 | 🟢 **DONE** |
| `TSK-S18-06-REVIEW` | Git diff Sprint 18 | **G5** | Reviewer: Ponytail Diff Review & Zero Doc-Code Drift Check | `code-reviewer` | - | 🟢 **DONE** |
| `TSK-S18-07-VERIFY` | Automated Test Suite | **G6** | QA Tester: 256/256 tests pass 100%, 0 analyze error, 0 memory leak | `qa-tester` | - | 🟢 **DONE** |
| `TSK-S18-08-SECURITY` | Security Audit & Rules | **G6.5** | Security Auditor: Kiểm toán bảo mật Anti-Spam & Trust boundaries | `security-auditor` | - | 🟢 **DONE** |
| `TSK-S18-09-RELEASE` | Tag release `v2.8.0` | **G7** | Hội đồng PO, PM, Tech Lead & Security: Thông cáo phát hành v2.8.0 | `product-owner` | - | 🟢 **DONE** |


---

## ✅ Định Nghĩa DONE Sprint 18

- [x] `flutter analyze` 0 lỗi, 0 cảnh báo.
- [x] `flutter test` pass 100% (256/256 tests pass).
- [x] Leaderboard đồng bộ dữ liệu qua Riverpod StreamProvider với chi phí tối ưu (1 Read / session).
- [x] Kết bạn 2 chiều qua Astro ID hoạt động thành công kèm validation chuẩn.
- [x] Tính năng Streak Nudge gửi được thông báo tới bạn bè kèm cơ chế Anti-Spam (1 lần/ngày).
- [x] Quy tắc Docs-as-Code (Zero Doc-Code Drift): Toàn bộ tài liệu trong `docs/` được cập nhật đồng bộ trước khi đóng Gate 7.


---


## 🗺️ Lộ Trình Sprint Nâng Cấp Giao Diện Theo Màn Hình (Sprint 12–16)

| Sprint | Version | Tên Sprint & Nhóm Màn Hình Trọng Tâm | SP | Màn Hình Chi Tiết | Trạng Thái |
|:--|:--:|:---|:--:|:---|:---|
| **S12** | v2.1.0 | **Foundation & UI Kit Core** | 10 SP | `lib/shared/ui_kit/*` | 🟢 **DONE** |
| **S13** | v2.2.0 | **Core Daily Loop (Navigation & Tracker)** | 10 SP | `ShellScreen`, `HomePage`, `ManualEntryPage` | 🟢 **DONE** |
| **S14** | v2.3.0 | **High-Value AI Experience (Scanner & Coach)** | 10 SP | `CameraPage`, `ScanReviewPage`, `CoachPage` | 🟢 **DONE** |
| **S15** | v2.5.2 | **First Impression & Identity (Auth & Profile)** | 14 SP | `GoalSummaryPage`, `ProfilePage`, `ProfileEditPage` | 🟢 **DONE** |
| **S17** | v2.7.0 | **Social Accountability & Leaderboard** | 11 SP | `LeaderboardPage`, `ShareImageService` | 🟢 **DONE** |
| **S18** | v2.8.0 | **Live Social Sync & Streak Nudge** | 13 SP | `LeaderboardPage`, `SocialRepository` | 🟢 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 18 — AstroBite v2.8.0 Live Social Sync & Streak Nudge (Hoàn tất 04/10/2026)
- **Mục tiêu**: Hoàn thiện toàn diện `EPIC-COMMUNITY` với Firestore Stream Leaderboard và tính năng Streak Nudge qua FCM.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 256/256 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.8.0.md`

### 🟢 Sprint 17 — AstroBite v2.7.0 Social Accountability & Astro Leaderboard (Hoàn tất 04/10/2026)

- **Mục tiêu**: Tăng trưởng cộng đồng qua tính năng khoe thành tích Share Card và Astro Leaderboard.
- **Kết quả**: **11 / 11 SP (100% Passed)** — Tích hợp Native Share thành công với RepaintBoundary.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.7.0.md`

### 🟢 Sprint 16 — AstroBite v2.6.0 Deep Domain, Analytics & OS Widgets (Hoàn tất 03/10/2026)
- **Mục tiêu**: Bổ sung `AnalyticsPage` với biểu đồ `CalorieTrendChart`, `WeightTrendChart` và hệ thống Native OS Home Widget (`home_widget`) theo triết lý One-way sync.
- **Kết quả**: **9 / 9 SP (100% Passed)** — Toàn bộ test tự động đạt chuẩn, 0 lỗi, không sụt giảm FPS.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.6.0.md`

### 🟢 Sprint 15 — AstroBite v2.5.2 First Impression & Identity (Hoàn tất 30/09/2026)
- **Mục tiêu**: Nâng cấp trải nghiệm FTUX (First Time User Experience), Auth, Onboarding, và Profile với UI Kit `ClayCard` và nút bấm Duolingo.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 242/242 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.5.2.md`

### 🟢 Sprint 14 — AstroBite v2.3.0 High-Value AI Experience (Hoàn tất 29/09/2026)
- **Mục tiêu**: Nâng cấp `CameraPage` (Viewfinder bo góc 24pt, nút Shutter 3D tactile squash 0.92, haptic feedback), `ScanReviewPage` (ClaySheet, ChunkyMacroBar, ClayMealChip, nút lưu 3D Duolingo), `CoachPage` (bong bóng ClayCard, GenUI 1-Tap Log < 150ms).
- **Kết quả**: **10 / 10 SP (100% Passed)** — 242/242 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.3.0.md`

### 🟢 Sprint 13 — AstroBite v2.2.0 Core Daily Loop Tracker & Navigation (Hoàn tất 27/09/2026)
- **Mục tiêu**: Tái thiết kế `ShellScreen` (ClayBottomNav), `HomePage` (Cockpit `CalorieProgressArc` + `ChunkyMacroBar`), `ManualEntryPage` (ClaySearchBar + ClayTextField + Quick Steppers), `MealDetailPage`.
- **Kết quả**: **10 / 10 SP (100% Passed)** — 216/216 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.2.0.md`

### 🟢 Sprint 12 — AstroBite v2.1.0 Claymorphic UI Kit Foundation Reset (Hoàn tất 27/09/2026)
- **Mục tiêu**: Xây dựng bộ UI Kit chuẩn (`lib/shared/ui_kit/`), tokens `AppColors` & `AppTheme` Light Theme, `SolarCard`, `ClayButton`, `ChunkyMacroBar`, `CalorieProgressArc`, `ClayMealChip`, `ClayBottomNav`.
- **Kết quả**: **10 / 10 SP (100% Passed)** — 214/214 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/signoff-sprint-12.md`

### 🟢 Sprint 11 — AstroBite v2.0.0 Generative UI Chat Cockpit (Hoàn tất 26/09/2026)
- **Mục tiêu**: A2UI Protocol & Gemini 3.8 Flash Adapter, MealQuickLogCard, MacroBudgetGauge, QuickChoiceChips.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 198/198 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.0.0.md`
