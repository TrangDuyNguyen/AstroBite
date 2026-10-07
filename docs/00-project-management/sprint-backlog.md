# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 21
- **Tên Sprint**: Social Guilds & Planetary Challenges (Bang Hội Vũ Trụ & Thử Thách Đồng Đội)
- **Mã Epic / Feature**: `EPIC-14` / `FEAT-S21-GUILDS`
- **Phiên bản mục tiêu**: `v3.1.0`
- **Thời gian Sprint**: 07/10/2026 – 21/10/2026
- **Trạng thái Sprint**: 🟡 **IN PROGRESS (Gate 0 Completed ➔ Sẵn sàng Gate 1)**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **1 / 13 SP — 7.7%**)

---

## 🎯 Mục Tiêu Sprint 21: Social Guilds & Planetary Challenges

1. **Kiến Trúc & Quản Trị Bang Hội (Gate 0 & Gate 1 — 3 SP)**: Thiết lập cấu trúc Firestore Collections đa tầng (`guilds/{guildId}/members`), cơ chế mời bằng mã Invite Code 6 ký tự, chống race condition bằng `FieldValue.increment()`.
2. **Thử Thách Hành Tinh & Auto Contribution (4 SP)**: Thiết kế tiến độ chung nhóm (Team Goal: 50,000 kcal sạch hoặc 100 bữa ăn đúng hạn) với cơ chế tự động tích lũy Starlight XP mỗi khi thành viên log đồ ăn.
3. **Giao Diện Claymorphic Guild Dashboard & Member List (6 SP)**: Trải nghiệm 5 trạng thái với thẻ ClayCard bo góc 24pt, avatar hành tinh nổi 3D, vòng cung tiến độ nhóm và danh sách thành viên hiển thị streak.

---

## 📋 Bảng Kanban Sprint 21

### 1. 📝 BACKLOG / QUEUED — [12 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S21-01-PRD` | `docs/03-prd-features/28-social-guilds-planetary-challenges/` | **G1** | BA: Soạn PRD & User Stories BDD luồng Bang hội & Thử thách | `business-analyst` | 2 | ⏳ **QUEUED** |
| `TSK-S21-02-DESIGN` | `docs/03-prd-features/28-social-guilds-planetary-challenges/ui-ux-design.md` | **G2** | UI/UX Designer: Thiết kế Guild Dashboard, Planetary Arc & 5 States | `ui-ux-designer` | 2 | ⏳ **QUEUED** |
| `TSK-S21-03-TEST-PLAN` | `docs/03-prd-features/28-social-guilds-planetary-challenges/gate-3-test.md` | **G3** | QA Tester: Thiết kế test biên BVA, concurrency & kịch bản Gherkin | `qa-tester` | 1 | ⏳ **QUEUED** |
| `TSK-S21-04-DATA` | `features/guilds/data/`, `features/guilds/domain/` | **G4** | Cloud Dev: Freezed Guild Models, Firestore Datasource & Atomic XP | `cloud-ai-dev` | 3 | ⏳ **QUEUED** |
| `TSK-S21-05-UI` | `features/guilds/presentation/` | **G4** | Dev FE: Xây dựng GuildScreen, PlanetaryChallengeCard & MemberList | `flutter-core-dev` | 4 | ⏳ **QUEUED** |
| `TSK-S21-06-REVIEW` | `gate-5-review.md` | **G5** | Reviewer: Ponytail Diff Review & Zero Doc-Code Drift Check | `code-reviewer` | - | ⏳ **QUEUED** |
| `TSK-S21-07-VERIFY` | `signoff-sprint-21.md` | **G6** | QA Tester: 100% test pass, 0 analyze error, 60 FPS, 0 memory leak | `qa-tester` | - | ⏳ **QUEUED** |
| `TSK-S21-08-SECURITY` | `signoff-security-sprint-21.md` | **G6.5** | Security Auditor: Kiểm toán Firestore Security Rules & Anti-Abuse | `security-auditor` | - | ⏳ **QUEUED** |
| `TSK-S21-09-RELEASE` | `release-v3.1.0.md` | **G7** | Hội đồng PO, PM, Tech Lead & Security: Release v3.1.0 Clearance | `product-owner` | - | ⏳ **QUEUED** |

### 2. ⚡ IN PROGRESS — [0 SP]
*(Đang chuẩn bị kích hoạt Gate 1)*

### 3. 🏁 DONE — [1 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S21-00-SPIKE` | `docs/superpowers/specs/2026-10-07-social-guilds-planetary-challenges-design.md` | **G0** | Tech Lead & PO: Architectural Spec, Data Model & Feasibility Sign-Off | `tech-lead` | 1 | 🟢 **DONE** |

---

## ✅ Định Nghĩa DONE Sprint 21

- [ ] `flutter analyze` 0 lỗi, 0 cảnh báo.
- [ ] `flutter test` pass 100% (bao gồm unit test Guild repository & widget test Guild screen).
- [ ] Race condition ghi điểm: Sử dụng `FieldValue.increment()` không bị lệch điểm.
- [ ] Tốc độ truy vấn dữ liệu Bang hội: $\le 800ms$ (Firestore stream + local cache).
- [ ] Tham gia bang hội thành công bằng Invite Code 6 ký tự.
- [ ] Giao diện 5 trạng thái đạt chuẩn Claymorphic Duolingo 2D/3D (Active, Loading Shimmer, Empty, Error, Offline).
- [ ] Zero Doc-Code Drift: Hoàn tất tài liệu từ Gate 0 đến Gate 7 trước khi đóng Sprint.


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

### 🟢 Sprint 20 — AstroBite v3.0.0 Hands-Free Voice Logging (AstroVoice AI) (Hoàn tất 05/10/2026)
- **Mục tiêu**: Bổ sung `EPIC-VOICE` cho phép người dùng nói tự nhiên bữa ăn tiếng Việt, nhận diện on-device (`speech_to_text`), Gemini 2.0 Flash NLU bóc tách món & đơn vị dân dã kèm suy luận bữa ăn 24h, hiển thị GenUI `MealQuickLogCard` và 1-Tap Log trong $< 150ms$.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 277/277 tests pass thực chất, `flutter analyze` 0 issues, SLA AI latency ~1.1s, 60 FPS, 0 memory leak.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.0.0.md`

### 🟢 Sprint 19 — AstroBite v2.9.0 Multi-Region Food Culture Intelligence (Hoàn tất 05/10/2026)
- **Mục tiêu**: Bóc tách ẩm thực Việt Nam / Châu Á (Phở, Bún bò, Cơm tấm...) với cơ chế nước dùng và topping độc lập qua Gemini 2.0 Flash Vision One-Pass, tích hợp Broth Toggle Chip và Topping Checklist Wrap.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 266/266 tests pass thực chất, `flutter analyze` 0 issues, SLA AI latency ~1.85s, 60 FPS, 0 memory leak.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.9.0.md`

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
