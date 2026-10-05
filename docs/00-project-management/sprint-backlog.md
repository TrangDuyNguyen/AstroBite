# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 20
- **Tên Sprint**: Hands-Free Voice Logging (AstroVoice AI & Gemini NLU Engine)
- **Mã Epic / Feature**: `EPIC-VOICE` / `FEAT-S20-VOICE-LOG`
- **Phiên bản mục tiêu**: `v3.0.0`
- **Thời gian Sprint**: 05/10/2026 – 19/10/2026
- **Trạng thái Sprint**: 🟡 **IN PROGRESS (Gate 3: QA Test Design)**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **5 / 13 SP — 38%**)

---

## 🎯 Mục Tiêu Sprint 20: Hands-Free Voice Logging (AstroVoice AI)

1. **On-Device Speech-to-Text Pipeline (`TSK-S20-04-VOICE-SERVICE` — 3 SP)**: Tích hợp engine nhận diện giọng nói tiếng Việt on-device (`vi-VN`), stream chữ trực tiếp theo thời gian thực (Live Transcript Feedback), kèm abstract service kháng lỗi trong test.
2. **Gemini 2.0 Flash NLU Natural Language Parser**: Tinh chỉnh prompt phân tích câu nói tiếng Việt tự nhiên, bóc tách món ăn, đơn vị dân dã (bát, tô, quả, cái, cốc), suy luận bữa ăn theo khung giờ và tính toán dinh dưỡng trong vòng $\le 1.0s$.
3. **Interactive AstroVoiceSheet & GenUI 1-Tap Log (`TSK-S20-05-VOICE-UI` — 4 SP)**: Trải nghiệm 5 trạng thái với hiệu ứng sóng âm/pulsing ripple, tự động hiển thị thẻ `MealQuickLogCard` để xác nhận và lưu nhật ký 1 chạm trong tích tắc.

---

## 📋 Bảng Kanban Sprint 20

### 1. 📝 BACKLOG / QUEUED — [7 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S20-04-VOICE-SERVICE` | `features/voice/data/datasources/`, `pubspec.yaml` | **G4** | Native Dev: Cấu hình `speech_to_text`, cấp quyền Mic, Mockable Service | `flutter-native-dev` | 3 | 🟡 **QUEUED** |
| `TSK-S20-05-VOICE-UI` | `features/voice/presentation/`, `home_page.dart` | **G4** | Dev FE: Dựng AstroVoiceSheet, tích hợp GenUI MealQuickLogCard 1-Tap Log | `flutter-core-dev` | 4 | 🟡 **QUEUED** |
| `TSK-S20-06-REVIEW` | Git diff Sprint 20 | **G5** | Reviewer: Ponytail Diff Review & Zero Doc-Code Drift Check | `code-reviewer` | - | 🟡 **QUEUED** |
| `TSK-S20-07-VERIFY` | Automated Test Suite | **G6** | QA Tester: 100% test pass, 0 analyze error, 0 memory leak, latency $\le 1.5s$ | `qa-tester` | - | 🟡 **QUEUED** |
| `TSK-S20-08-SECURITY` | Security Audit & Rules | **G6.5** | Security Auditor: Kiểm toán quyền Mic PII & Prompt Injection qua giọng nói | `security-auditor` | - | 🟡 **QUEUED** |
| `TSK-S20-09-RELEASE` | Tag release `v3.0.0` | **G7** | Hội đồng PO, PM, Tech Lead & Security: Thông cáo phát hành v3.0.0 | `product-owner` | - | 🟡 **QUEUED** |

### 2. ⚡ IN PROGRESS — [1 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S20-03-TEST-PLAN` | `docs/03-prd-features/27-hands-free-voice-logging/gate-3-test.md` | **G3** | QA Tester: Thiết kế test biên BVA và kịch bản BDD Gherkin âm thanh | `qa-tester` | 1 | ⚡ **IN PROGRESS** |

### 3. 🏁 DONE — [5 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S20-00-SPIKE` | `docs/superpowers/specs/2026-10-05-hands-free-voice-logging-design.md` | **G0** | Tech Lead & PO: Brainstorming & Architectural Spec AstroVoice AI | `tech-lead` | 1 | 🟢 **DONE** |
| `TSK-S20-01-PRD` | `docs/03-prd-features/27-hands-free-voice-logging/` | **G1** | BA: Soạn PRD & User Stories BDD cho luồng giọng nói tự nhiên | `business-analyst` | 2 | 🟢 **DONE** |
| `TSK-S20-02-DESIGN` | `docs/03-prd-features/27-hands-free-voice-logging/ui-ux-design.md` | **G2** | UI/UX Designer: Thiết kế AstroVoiceSheet, Pulsing Mic & 5 States | `ui-ux-designer` | 2 | 🟢 **DONE** |

---

## ✅ Định Nghĩa DONE Sprint 20

- [ ] `flutter analyze` 0 lỗi, 0 cảnh báo.
- [ ] `flutter test` pass 100% (bao gồm headless unit/widget tests cho audio & voice).
- [ ] Tổng thời gian phản hồi: Từ lúc ngừng nói đến khi GenUI card render $\le 1.5$ giây.
- [ ] Nhận diện chuẩn xác tiếng Việt có dấu (`vi-VN`) với streaming transcript theo thời gian thực.
- [ ] Gemini NLU bóc tách chuẩn xác các đơn vị ước tính dân dã (bát, tô, cái, ly, cốc, hộp) và tự động suy luận bữa ăn.
- [ ] Thẻ `MealQuickLogCard` cho phép 1-Tap Log ghi nhận vào Food Diary trong $< 150ms$.
- [ ] Giao diện 5 trạng thái đạt chuẩn Claymorphic Duolingo 2D/3D (Listening, Parsing, Ready, Empty, Error).
- [ ] Zero Doc-Code Drift: Cập nhật đồng bộ toàn bộ tài liệu trong `docs/` trước khi đóng Gate 7.


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
