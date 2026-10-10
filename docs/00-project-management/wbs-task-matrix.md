# Ma Trận Phân Rã Công Việc 8 Cổng (WBS Task Matrix)

- **Quản lý bởi**: Sub-Agent Project Manager (PM) & Sub-Agent Product Owner (PO)
- **Ánh xạ quy trình**: 8-Gate Delivery Flow (Tech Spike ➔ BA ➔ UI/UX Designer ➔ QA ➔ Dev FE ➔ Code Review ➔ Verification ➔ Release)
- **Cập nhật lần cuối**: 2026-10-10

## 🏛️ 1. Lưu Trữ Ma Trận Phân Rã WBS Sprint 26 (v3.6.0 Gamification, Guilds & Social — 🟢 100% Done)

### EPIC-REF-05: Gamification, Guilds & Social Modular Architecture (`FEAT-S26-GAMIFICATION-GUILDS-SOCIAL` — 13 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S26-00-SPIKE`** | Kiến trúc Bóc Tách | **Gate 0** | Tech Lead: Architectural Spec & ADR-032 cho Gamification & Guilds | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S26-01-PRD`** | `prd-s26.md` | **Gate 1** | BA: Soạn PRD & User Stories BDD luồng Streak & Guilds & Social | `business-analyst` | 2 | TSK-S26-00-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S26-02-DESIGN`** | `ui-ux-design.md`| **Gate 2** | UI/UX Designer: Component Layout Blueprint lưới 4pt | `ui-ux-designer` | 2 | TSK-S26-01-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S26-03-TEST-PLAN`**| `gate-3-test.md` | **Gate 3** | QA Tester: Regression Test Plan cho Gamification & Social | `qa-tester` | 1 | TSK-S26-02-DESIGN | 🟢 **Gate 3 Approved** |
| **`TSK-S26-04-STREAK`** | `streak_detail_sheet.dart` | **Gate 4** | Dev FE: Bóc tách streak_detail_sheet.dart (796 ➔ 208 dòng) | `flutter-core-dev` | 3 | TSK-S26-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S26-05-GUILD`** | `guild_page.dart` | **Gate 4** | Dev FE: Bóc tách guild_page.dart (718 ➔ 249 dòng) | `flutter-core-dev` | 2 | TSK-S26-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S26-06-LEADERBOARD`**| `leaderboard_page.dart` | **Gate 4** | Dev FE: Bóc tách leaderboard_page.dart (655 ➔ 221 dòng) | `flutter-core-dev` | 2 | TSK-S26-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S26-07-REVIEW`** | Quality Gate | **Gate 5** | Reviewer: Ponytail Diff Review, check hard cap < 350 dòng | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S26-08-QA-VERIFY`**| Quality Gate | **Gate 6** | QA Tester: Test pass 322/322 (100%), analyze 0 issues | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S26-09-SECURITY`** | Security Gate | **Gate 6.5** | Security Auditor: Rà soát PII & Social interaction boundaries | `security-auditor` | - | Gate 6 | 🟢 **Gate 6.5 Approved** |
| **`TSK-S26-10-RELEASE`** | Milestone | **Gate 7** | PO, PM & Tech Lead: Release Clearance v3.6.0 | `product-owner` | - | Gate 6.5 | 🟢 **Gate 7 Released** |

---

## 🏛️ 2. Lưu Trữ Ma Trận Phân Rã WBS Sprint 25 (v3.5.0 Camera Scanner Pipeline — 🟢 100% Done)

### EPIC-REF-04: Camera Scanner Pipeline Modular Clean Architecture (`FEAT-S25-CAMERA-SCANNER` — 13 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S25-00-SPIKE`** | Kiến trúc Bóc Tách | **Gate 0** | Tech Lead: Architectural Spec & ADR-031 cho Scanner Pipeline | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S25-01-PRD`** | `prd-s25.md` | **Gate 1** | BA: Soạn PRD & User Stories BDD luồng Camera & Viewfinder | `business-analyst` | 2 | TSK-S25-00-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S25-02-DESIGN`** | `ui-ux-design.md`| **Gate 2** | UI/UX Designer: Component Layout Blueprint lưới 4pt cho Scanner | `ui-ux-designer` | 2 | TSK-S25-01-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S25-03-TEST-PLAN`**| `gate-3-test.md` | **Gate 3** | QA Tester: Regression Test Plan cho Scanner Pipeline | `qa-tester` | 1 | TSK-S25-02-DESIGN | 🟢 **Gate 3 Approved** |
| **`TSK-S25-04-CAMERA`** | `camera_page.dart` | **Gate 4** | Dev FE: Bóc tách camera_page.dart (965 ➔ 266 dòng) | `flutter-native-dev` | 4 | TSK-S25-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S25-05-VIEWFINDER`**| `scanning_viewfinder.dart`| **Gate 4** | Dev FE: Bóc tách scanning_viewfinder.dart (616 ➔ 256 dòng) | `flutter-core-dev` | 3 | TSK-S25-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S25-06-REVIEW`** | Quality Gate | **Gate 5** | Reviewer: Ponytail Diff Review, check hard cap < 350 dòng | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S25-07-QA-VERIFY`**| Quality Gate | **Gate 6** | QA Tester: Test pass 322/322 (100%), analyze 0 issues | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S25-08-SECURITY`** | Security Gate | **Gate 6.5** | Security Auditor: Rà soát Camera lifecycle & API error sanitization | `security-auditor` | - | Gate 6 | 🟢 **Gate 6.5 Approved** |
| **`TSK-S25-09-RELEASE`** | Milestone | **Gate 7** | PO, PM & Tech Lead: Release Clearance v3.5.0 | `product-owner` | - | Gate 6.5 | 🟢 **Gate 7 Released** |

---

## 🏛️ 2. Lưu Trữ Ma Trận Phân Rã WBS Sprint 24 (v3.4.0 Recipes Modular Architecture — 🟢 100% Done)

### EPIC-REF-03: Recipes & Meal Planning God Files Elimination (`FEAT-S24-RECIPES` — 13 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S24-00-SPIKE`** | Kiến trúc Bóc Tách | **Gate 0** | Tech Lead: Architectural Spec & ADR-030 cho Recipes Refactoring | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S24-01-PRD`** | `prd-s24.md` | **Gate 1** | BA: Soạn PRD & User Stories BDD luồng Recipe & Ingredients | `business-analyst` | 2 | TSK-S24-00-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S24-02-DESIGN`** | `ui-ux-design.md`| **Gate 2** | UI/UX Designer: Component Layout Blueprint lưới 4pt cho Recipes | `ui-ux-designer` | 2 | TSK-S24-01-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S24-03-TEST-PLAN`**| `gate-3-test.md` | **Gate 3** | QA Tester: Regression Test Plan cho Recipes | `qa-tester` | 1 | TSK-S24-02-DESIGN | 🟢 **Gate 3 Approved** |
| **`TSK-S24-04-BUILDER`** | `recipe_builder_page.dart`| **Gate 4** | Dev FE: Bóc tách recipe_builder_page.dart (984 ➔ 245 dòng) | `flutter-core-dev` | 4 | TSK-S24-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S24-05-RECIPES`** | `recipes_page.dart` | **Gate 4** | Dev FE: Bóc tách recipes_page.dart (646 ➔ 161 dòng) | `flutter-core-dev` | 3 | TSK-S24-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S24-06-REVIEW`** | Quality Gate | **Gate 5** | Reviewer: Ponytail Diff Review, check hard cap < 350 dòng | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S24-07-QA-VERIFY`**| Quality Gate | **Gate 6** | QA Tester: Test pass 322/322 (100%), analyze 0 issues | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S24-08-SECURITY`** | Security Gate | **Gate 6.5** | Security Auditor: Rà soát Input sanitization & validation | `security-auditor` | - | Gate 6 | 🟢 **Gate 6.5 Approved** |
| **`TSK-S24-09-RELEASE`** | Milestone | **Gate 7** | PO, PM & Tech Lead: Release Clearance v3.4.0 | `product-owner` | - | Gate 6.5 | 🟢 **Gate 7 Released** |

---

## 🏛️ 2. Lưu Trữ Ma Trận Phân Rã WBS Sprint 23 (v3.3.0 AI Coach & Scanner Elimination — 🟢 100% Done)

### EPIC-REF-02: AI Coach & Scanner God Files Elimination (`FEAT-S23-COACH-SCANNER` — 13 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S23-00-SPIKE`** | Kiến trúc Bóc Tách | **Gate 0** | Tech Lead: Architectural Spec & ADR-029 cho Coach & Scan Review | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S23-01-PRD`** | `prd-s23.md` | **Gate 1** | BA: Soạn PRD & User Stories BDD luồng Chat Coach & Scan Review | `business-analyst` | 2 | TSK-S23-00-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S23-02-DESIGN`** | `ui-ux-design.md`| **Gate 2** | UI/UX Designer: Component Blueprint lưới 4pt cho Coach & Scan Review | `ui-ux-designer` | 2 | TSK-S23-01-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S23-03-TEST-PLAN`**| `gate-3-test.md` | **Gate 3** | QA Tester: Regression Test Plan cho Chat Coach & Scan Review Multi-dish | `qa-tester` | 1 | TSK-S23-02-DESIGN | 🟢 **Gate 3 Approved** |
| **`TSK-S23-04-COACH`** | `coach_page.dart` | **Gate 4** | Dev FE: Bóc tách coach_page.dart (2,153 ➔ 344 dòng) thành 10 sub-widgets | `flutter-core-dev` | 4 | TSK-S23-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S23-05-SCANREVIEW`**| `scan_review_page.dart`| **Gate 4** | Dev FE: Bóc tách scan_review_page.dart (1,482 ➔ 340 dòng) thành 9 sub-widgets | `flutter-core-dev` | 3 | TSK-S23-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S23-06-REVIEW`** | Quality Gate | **Gate 5** | Reviewer: Ponytail Diff Review, check hard cap < 350 dòng | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S23-07-QA-VERIFY`**| Quality Gate | **Gate 6** | QA Tester: Test pass 320/320 (100%), analyze 0 issues | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S23-08-SECURITY`** | Security Gate | **Gate 6.5** | Security Auditor: Rà soát Prompt Injection & Food Log Write permissions | `security-auditor` | - | Gate 6 | 🟢 **Gate 6.5 Approved** |
| **`TSK-S23-09-RELEASE`** | Milestone | **Gate 7** | PO, PM & Tech Lead: Release Clearance v3.3.0 | `product-owner` | - | Gate 6.5 | 🟢 **Gate 7 Released** |

---

## 🏛️ 2. Lưu Trữ Ma Trận Phân Rã WBS Sprint 22 (v3.2.0 Core Tracker Refactoring — 🟢 100% Done)

### EPIC-REF-01: Core Tracker Clean Architecture & O(1) Meal Enums Overhaul (`FEAT-S22-TRACKER` — 13 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S22-00-SPIKE`** | Kiến trúc O(1) Enums | **Gate 0** | Tech Lead: Architectural Spec, khảo sát bóc tách meal_section & manual_entry_page | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S22-01-PRD`** | `prd-s22.md` | **Gate 1** | BA: Soạn PRD & User Stories BDD luồng MealType và phân rã components | `business-analyst` | 2 | TSK-S22-00-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S22-02-DESIGN`** | `ui-ux-design.md`| **Gate 2** | UI/UX Designer: Layout Blueprint 4pt cho 4 sub-widgets MealSection | `ui-ux-designer` | 2 | TSK-S22-01-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S22-03-TEST-PLAN`**| `gate-3-test.md` | **Gate 3** | QA Tester: Regression Test Plan cho nhật ký 4 bữa ăn & Manual Entry | `qa-tester` | 1 | TSK-S22-02-DESIGN | 🟢 **Gate 3 Approved** |
| **`TSK-S22-04-ENUMS`** | `meal_enums.dart` | **Gate 4** | Dev FE: Tạo Enhanced Enum MealType & NutrientType O(1) | `flutter-core-dev` | 1 | TSK-S22-03-TEST-PLAN | 🟢 **Gate 4 Done** |
| **`TSK-S22-05-MEALSECTION`**| `meal_section.dart`| **Gate 4** | Dev FE: Bóc tách meal_section.dart (1,224 dòng ➔ 122 dòng) | `flutter-core-dev` | 3 | TSK-S22-04-ENUMS | 🟢 **Gate 4 Done** |
| **`TSK-S22-06-MANUALENTRY`**| `manual_entry_page.dart`| **Gate 4** | Dev FE: Bóc tách manual_entry_page.dart (969 dòng ➔ 331 dòng) | `flutter-core-dev` | 3 | TSK-S22-04-ENUMS | 🟢 **Gate 4 Done** |
| **`TSK-S22-07-REVIEW`** | Quality Gate | **Gate 5** | Reviewer: Ponytail Diff Review, check độ dài file | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S22-08-QA-VERIFY`**| Quality Gate | **Gate 6** | QA Tester: Test pass 306/306 (100%), analyze 0 issues | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S22-09-SECURITY`** | Security Gate | **Gate 6.5** | Security Auditor: Rà soát quyền ghi Food Log & zero secret leaks | `security-auditor` | - | Gate 6 | 🟢 **Gate 6.5 Approved** |
| **`TSK-S22-10-RELEASE`** | Milestone | **Gate 7** | PO, PM & Tech Lead: Release Clearance v3.2.0 | `product-owner` | - | Gate 6.5 | 🟢 **Gate 7 Released** |


---

## 🏛️ 2. Lưu Trữ Ma Trận Phân Rã WBS Sprint 21 (v3.1.0 Social Guilds — 100% Done)

### EPIC-14: Social Guilds & Planetary Challenges (`FEAT-S21-GUILDS` — 13 SP) — 🟢 RELEASED

---

## 🏛️ 3. Lưu Trữ Ma Trận Phân Rã WBS Sprint 17 (v2.7.0 Social & Leaderboard — 100% Done)

### EPIC-COMMUNITY: Social Accountability & Astro Leaderboard (`FEAT-S17-SOCIAL` — 11 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S17-SPIKE`** | Kiến trúc Share UI | **Gate 0** | Tech Lead: Khảo sát kiến trúc `RepaintBoundary` chuyển Widget thành Image và Cloud Functions | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S17-PRD`** | `prd-s17.md` | **Gate 1** | BA: Soạn PRD BDD Social Share & Leaderboard | `business-analyst` | 1 | TSK-S17-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S17-DESIGN`** | `ui-ux-design.md`| **Gate 2** | UI/UX Designer: Layout Blueprint cho Share Card và Bảng Xếp Hạng | `ui-ux-designer` | 2 | TSK-S17-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S17-TEST-PLAN`**| `gate-3-test.md` | **Gate 3** | QA Tester: Test Plan cho các Permission thư viện ảnh, Edge cases bạn bè | `qa-tester` | 1 | TSK-S17-DESIGN | 🟢 **Gate 3 Approved** |
| **`TSK-S17-RANKING`**| `leaderboard.dart`| **Gate 4** | Dev FE: Xây dựng UI Leaderboard kết nối Firestore Stream | `flutter-core-dev` | 3 | TSK-S17-TEST-PLAN | 🟢 **Gate 4 Ranking Done** |
| **`TSK-S17-SHARE`** | `share_service` | **Gate 4** | Dev Native: Tích hợp `path_provider`, `share_plus` xuất ảnh Native | `flutter-native-dev` | 3 | TSK-S17-TEST-PLAN | 🟢 **Gate 4 Share Done** |
| **`TSK-S17-REVIEW`** | Quality Gate | **Gate 5** | Reviewer: Ponytail Diff Review | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S17-QA-VERIFY`**| Quality Gate | **Gate 6** | QA Tester: Test pass 100%, check Share Native dialog | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S17-RELEASE`** | Milestone | **Gate 7** | PO & PM nghiệm thu, phát hành `v2.7.0` | `product-owner` | - | Gate 6 | 🟢 **Gate 7 Released** |

---

## 🏛️ 2. Lưu Trữ Ma Trận Phân Rã WBS Sprint 16 (v2.6.0 Analytics & OS Widgets — 100% Done)

### EPIC-ANALYTICS: Deep Domain, Analytics & OS Widgets (`FEAT-S16-WIDGETS` — 9 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S16-SPIKE`** | Kiến trúc Analytics | **Gate 0** | Tech Lead: Spike kiến trúc FL Chart `RepaintBoundary` & Native Widget Channel | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S16-PRD`** | `prd-s16.md` | **Gate 1** | BA: Soạn PRD & User Stories BDD Analytics; PO ký Gate 1 Sign-Off | `business-analyst` | 1 | TSK-S16-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S16-DESIGN`** | `ui-ux-design.md`| **Gate 2** | UI/UX Designer: Layout Blueprint 4pt cho biểu đồ & Mockup Native Widget | `ui-ux-designer` | 1 | TSK-S16-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S16-TEST-PLAN`**| `gate-3-test.md` | **Gate 3** | QA Tester: Thiết kế Master Test Plan, kịch bản test cuộn FPS | `qa-tester` | 1 | TSK-S16-DESIGN | 🟢 **Gate 3 Approved** |
| **`TSK-S16-ANALYTICS`**| `analytics_page.dart`| **Gate 4** | Dev FE: Xây dựng biểu đồ `CalorieTrendChart`, `WeightTrendChart` | `flutter-core-dev` | 3 | TSK-S16-TEST-PLAN | 🟢 **Gate 4 Analytics Done** |
| **`TSK-S16-WIDGET`** | `home_widget` | **Gate 4** | Dev Native: Tích hợp Native Widget (Android AppWidget / iOS WidgetKit) | `flutter-native-dev` | 2 | TSK-S16-TEST-PLAN | 🟢 **Gate 4 Widget Done** |
| **`TSK-S16-REVIEW`** | Quality Gate | **Gate 5** | Reviewer: Ponytail Diff Review, cắt code rác | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S16-QA-VERIFY`**| Quality Gate | **Gate 6** | QA Tester: Test pass 100%, 60 FPS | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S16-RELEASE`** | Milestone | **Gate 7** | PO & PM nghiệm thu toàn diện, phát hành `v2.6.0` | `product-owner` & `project-manager` | - | Gate 6 | 🟢 **Gate 7 Released** |

---

## 🏛️ 2. Lưu Trữ Ma Trận Phân Rã WBS Sprint 15 (v2.5.2 FTUX & Identity — 100% Done)

### EPIC-UI-REFRESH: First Impression & Identity (`FEAT-S15` — 11 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S15-SPIKE`** | Kiến trúc FTUX | **Gate 0** | Tech Lead: Spike kiến trúc tích hợp `ClayCard` cho luồng Auth & Onboarding | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S15-PRD`** | `prd-s15.md` | **Gate 1** | BA: Soạn PRD & User Stories BDD; PO ký Gate 1 Sign-Off | `business-analyst` | 1 | TSK-S15-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S15-DESIGN`** | `ui-ux-design.md`| **Gate 2** | UI/UX Designer: Layout Blueprint lưới 4pt, 5 trạng thái Auth & Profile | `ui-ux-designer` | 1 | TSK-S15-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S15-TEST-PLAN`**| `gate-3-test.md` | **Gate 3** | QA Tester: Thiết kế Master Test Plan, Manual TCs | `qa-tester` | 1 | TSK-S15-DESIGN | 🟢 **Gate 3 Approved** |
| **`TSK-S15-AUTH`** | `auth_page.dart` | **Gate 4** | Dev FE: Nâng cấp UI Đăng nhập/Đăng ký với `ClayCard` & Duolingo buttons | `flutter-core-dev` | 3 | TSK-S15-TEST-PLAN | 🟢 **Gate 4 Auth Done** |
| **`TSK-S15-ONBOARD`** | `onboarding.dart`| **Gate 4** | Dev FE: Luồng thiết lập BMR/TDEE, GoalSummaryPage | `flutter-core-dev` | 4 | TSK-S15-TEST-PLAN | 🟢 **Gate 4 Onboard Done** |
| **`TSK-S15-PROFILE`** | `profile_page.dart`| **Gate 4** | Dev FE: ProfilePage, HealthConnectionPage UI refresh | `flutter-core-dev` | 3 | TSK-S15-TEST-PLAN | 🟢 **Gate 4 Profile Done** |
| **`TSK-S15-REVIEW`** | Quality Gate | **Gate 5** | Reviewer: Ponytail Diff Review, triệt tiêu code rác | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S15-QA-VERIFY`**| Quality Gate | **Gate 6** | QA Tester: Automated Test Suite pass 100%, 0 memory leak | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S15-RELEASE`** | Milestone | **Gate 7** | PO & PM nghiệm thu toàn diện, phát hành `v2.5.2` | `product-owner` & `project-manager` | - | Gate 6 | 🟢 **Gate 7 Released** |


## 🏗️ 1. Bảng Ma Trận Phân Rã WBS Sprint 10 (v1.9.0 Custom Recipes & Meal Planning — Active)

### EPIC-12: Custom Recipes & Meal Planning Architecture (`FEAT-17` — 14 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S10-SPIKE`** | `FEAT-17` Tech Spike | **Gate 0** | Khảo sát kiến trúc dữ liệu Recipe & Local Aggregator O(N) | `tech-lead` | 1 | None | 🟢 **Gate 0 Approved** |
| **`TSK-S10-PRD`** | `FEAT-17` PRD BDD | **Gate 1** | Đặc tả 4 User Stories BDD, Data Dictionary & Gate 1 Sign-Off | `business-analyst` | 2 | TSK-S10-SPIKE | 🟢 **Gate 1 Approved** |
| **`TSK-S10-STITCH-UI`** | `FEAT-17` UI/UX | **Gate 2** | Mermaid flow, Blueprint lưới 4pt, 5 UI states, Stitch mockups | `ui-ux-designer` | 2 | TSK-S10-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S10-QA-TESTS`** | `FEAT-17` Test Plan | **Gate 3** | Kịch bản BDD Gherkin, Master Test Plan & ma trận EP/BVA | `qa-tester` | 2 | TSK-S10-STITCH-UI | 🟢 **Gate 3 Approved** |
| **`TSK-S10-DEV-RECIPE`**| `FEAT-17` Flutter | **Gate 4** | Domain `Recipe`, UI Recipe Builder & Auto Macro Aggregator | `flutter-core-dev` | 3 | TSK-S10-QA-TESTS | 🟢 **Gate 4 Implemented** |
| **`TSK-S10-DEV-PLANNER`**| `FEAT-17` Flutter | **Gate 4** | Weekly Day Strip, Meal Planner Calendar & 1-Tap Log to Diary | `flutter-core-dev` | 3 | TSK-S10-DEV-RECIPE | 🟢 **Gate 4 Implemented** |
| **`TSK-S10-DEV-SYNC`** | `FEAT-17` Cloud/Offline | **Gate 4** | Offline SQLite/Prefs Cache, Pending Sync Queue & Firestore | `cloud-ai-dev` | 1 | TSK-S10-DEV-PLANNER| 🟢 **Gate 4 Implemented** |
| **`TSK-S10-REVIEW`** | Quality Gate | **Gate 5** | Ponytail AST review: 0 bloat, stdlib trước, xóa code thừa | `code-reviewer` | - | Gate 4 | 🟢 **Gate 5 Approved** |
| **`TSK-S10-QA-VERIFY`** | Quality Gate | **Gate 6** | Chạy automated test suite 100% pass, analyze 0 issues, 60 FPS | `qa-tester` | - | Gate 5 | 🟢 **Gate 6 Signed Off** |
| **`TSK-S10-RELEASE`** | Milestone | **Gate 7** | PO & PM nghiệm thu toàn diện, phát hành `v1.9.0` & tag Git | `product-owner` & `project-manager` | - | Gate 6 | 🟢 **Gate 7 Released** |

---

## 🏛️ 2. Bảng Ma Trận Phân Rã WBS Sprint 07 (v1.6.0 Zero-Friction Logging — 100% Done)

### EPIC-16: Zero-Friction Ergonomic Food Logging (`FEAT-14` — 9 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S7-PRD`** | `FEAT-14` PRD | **Gate 1** | Đặc tả PRD BDD, SLAs < 3.5s, 1-tap Recent Food, Thumb Zone CTA | `business-analyst` | 1 | None | 🟢 **Gate 1 Approved** |
| **`TSK-S7-UI-SPEC`** | `FEAT-14` Design | **Gate 2** | Mermaid flow, Blueprint 4pt, 5 UI states, Sticky Bottom Bar layout | `ui-ux-designer` | 2 | TSK-S7-PRD | 🟢 **Gate 2 Approved** |
| **`TSK-S7-QA-TESTS`** | `FEAT-14` Test Plan | **Gate 3** | Kịch bản BDD, Widget tests cho Recent tray, Steppers & Sticky CTA | `qa-tester` | 1 | TSK-S7-UI-SPEC | ⚡ **In Progress** |
| **`TSK-S7-DEV-MANUAL`** | `FEAT-14` Flutter | **Gate 4** | Cải tạo `ManualEntryPage`: khay Recent Foods, Quick Steppers, Sticky Thumb CTA | `flutter-core-dev` | 3 | TSK-S7-QA-TESTS | ⚡ **In Progress** |
| **`TSK-S7-DEV-SCANNER`**| `FEAT-14` Flutter | **Gate 4** | Cải tạo `CameraPage` (Radar Wave) & `ScanReviewPage` (Compact Sticky Review) | `flutter-core-dev` | 2 | TSK-S7-DEV-MANUAL | ⏳ Queued Gate 4 |
| **`TSK-S7-REVIEW`** | Quality Gate | **Gate 5** | Ponytail AST review: cắt giảm code thừa, kiểm tra stdlib, 0 bloat | `code-reviewer` | - | Gate 4 | ⏳ Chờ Dev xong |
| **`TSK-S7-QA-VERIFY`** | Quality Gate | **Gate 6** | Chạy automated test suite 100% pass, `flutter analyze` 0 issues, SLA 60 FPS | `qa-tester` | - | Gate 5 | ⏳ Chờ Reviewer |
| **`TSK-S7-RELEASE`** | Milestone | **Gate 7** | PO & PM nghiệm thu toàn diện, phát hành `v1.6.0` và gắn tag Git | `product-owner` & `project-manager` | - | Gate 6 | ⏳ Cổng cuối |

---

## 🏛️ 2. Bảng Ma Trận Phân Rã WBS Sprint 06 (v1.5.0 Glanceable Celestial Core — 100% Done)

### EPIC-15: Glanceable Celestial Cockpit (`FEAT-13` — 10 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S6-PRD-COCKPIT`** | `EPIC-15` PRD | **Gate 1** | Đặc tả PRD BDD Given-When-Then, Data Dictionary cho Cockpit & Collapsible Pill | `business-analyst` | 3 | None | 🟢 Approved |
| **`TSK-S6-UI-COCKPIT`** | `EPIC-15` Design | **Gate 2** | Thiết kế Google Stitch Mockup (`db13f5531baf4aeab67ab09be0b5bafa`), layout 4pt, 5 UI states | `ui-ux-designer` | 3 | TSK-S6-PRD-COCKPIT | 🟢 Approved |
| **`TSK-S6-QA-COCKPIT`** | `EPIC-15` Tests | **Gate 3** | Viết Test Suite cho Cockpit Card, toggle Vi chất & Over-budget state | `qa-tester` | 2 | TSK-S6-UI-COCKPIT | 🟢 Done |
| **`TSK-S6-DEV-COCKPIT`** | `EPIC-15` Flutter | **Gate 4** | Triển khai `CelestialCockpitCard`, adapter `DailySummaryCard`, dải Vi chất thu gọn | `flutter-expert` | 2 | TSK-S6-QA-COCKPIT | 🟢 Done |

### EPIC-UI-CORE: Ergonomic Meal Timeline & 1-Tap Quick Log (8 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S6-DEV-TIMELINE`** | `EPIC-UI-CORE` | **Gate 4** | Tối ưu 4 thẻ `MealSection` với nút `+` 1-tap quick add, popup xác nhận xóa món | `flutter-expert` | 3 | None | 🟢 Done |
| **`TSK-S6-DEV-ROUTER`** | `EPIC-UI-CORE` | **Gate 4** | Cấu hình router truyền `mealType` query param vào `ManualEntryPage` | `flutter-expert` | 2 | TSK-S6-DEV-TIMELINE | 🟢 Done |
| **`TSK-S6-DEV-NAV-BAR`** | `EPIC-UI-CORE` | **Gate 4** | Cập nhật `CelestialBottomNav` & `CelestialTimeAvatar` đồng bộ nhận diện thiên hà | `flutter-expert` | 3 | None | 🟢 Done |

### Sprint 06 Quality Assurance & Delivery Gate (Gate 5 - 7)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S6-PONYTAIL`** | Quality Gate | **Gate 5** | Ponytail diff review: loại bỏ 40 dòng UI rác, thay thế bằng 1 dòng AstroCoach chip | `code-reviewer` | - | Gate 4 | 🟢 Passed |
| **`TSK-S6-QA-VERIFY`** | Quality Gate | **Gate 6** | Automated test 148/148 pass, `flutter analyze` 0 issues, SLA 60 FPS, touch target >= 44pt | `qa-tester` | - | Gate 5 | 🟢 Passed |
| **`TSK-S6-RELEASE`** | Milestone | **Gate 7** | Đóng Sprint 06, biên bản release notes `v1.5.0` và gắn tag Git phát hành | `product-owner` & `project-manager` | - | Gate 6 | ⏳ Ready |

---

## 🏛️ 2. Lưu Trữ Ma Trận WBS Sprint 05 (v1.4.0 The Cosmic Habit Loop — 100% Done)

### EPIC-13: Gamification & Cosmic Streak Engine (13 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S5-TECH-SPIKE`** | Kiến Trúc & Spike | **Gate 0** | Nghiên cứu thuật toán Streak, xử lý múi giờ địa phương, Starlight Shield & lưu trữ Firestore/Local (ADR-05) | `tech-lead` | 3 | None | 🟢 Done |
| **`TSK-S5-PRD-STREAK`** | `EPIC-13` PRD | **Gate 1** | Soạn thảo PRD chuẩn BDD Given-When-Then, quy chuẩn Data Dictionary cho Streak & Badges | `business-analyst` | 3 | None | 🟢 Done |
| **`TSK-S5-UI-STREAK`** | `EPIC-13` Design | **Gate 2** | Thiết kế Cosmic Energy Ring (vòng năng lượng vũ trụ), huy hiệu Celestial & Empty/Streak state | `ui-ux-designer` | 3 | TSK-S5-PRD-STREAK | 🟢 Done |
| **`TSK-S5-DEV-STREAK`** | `EPIC-13` Flutter | **Gate 4-6** | Triển khai Domain Model `StreakRecord`, Riverpod `streakNotifierProvider` & UI Widget | `flutter-expert` | 4 | TSK-S5-UI-STREAK | 🟢 Done |

### EPIC-11: Mobile Widgets & Quick Glance (8 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S5-PRD-WIDGET`** | `EPIC-11` PRD | **Gate 1** | Xác định thông số dữ liệu đồng bộ Widget (Calo còn lại, Carbs/Fat/Protein, Deep Link Scan) | `business-analyst` | 2 | None | 🟢 Done |
| **`TSK-S5-UI-WIDGET`** | `EPIC-11` Design | **Gate 2** | Thiết kế Layout Widget Small & Medium theo chuẩn Celestial Dark UI | `ui-ux-designer` | 2 | TSK-S5-PRD-WIDGET | 🟢 Done |
| **`TSK-S5-DEV-WIDGET`** | `EPIC-11` Flutter | **Gate 4-6** | Tích hợp package `home_widget`, truyền dữ liệu SharedPreferences native & Deep Link Camera | `flutter-expert` | 4 | TSK-S5-UI-WIDGET | 🟢 Done |

### EPIC-07-EXT: AstroCoach Contextual Memory & 1-Tap Log (5 SP)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-S5-QA-COACH`** | `EPIC-07-EXT` BDD | **Gate 3** | Kịch bản BDD Gherkin cho Context Injection & 1-Tap Meal Log card | `qa-tester` | 2 | None | 🟢 Done |
| **`TSK-S5-DEV-COACH`** | `EPIC-07-EXT` Coach | **Gate 4-6** | Nạp User Profile/BMR/Streak vào Prompt, trích xuất meal tag và 1-Tap Log ghi Firestore Diary | `flutter-expert` | 3 | TSK-S5-QA-COACH | 🟢 Done |

---

## 🏛️ 3. Lưu Trữ Ma Trận WBS Sprint 04 (v1.3.0 Cosmic Onboarding & Flawless IA — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-S4-AUTH`** | `FEAT-01` Auth | **Gate 0-4** | Cấu hình `serverClientId` OAuth từ Web Client ID `google-services.json`, fix idToken Firebase Auth & xử lý lỗi hủy / mất mạng | `tech-lead` & `flutter-expert` | 5 | 🟢 Done |
| **`TSK-S4-NAV`** | Shell Navigation | **Gate 2-4** | Tái cấu trúc ShellScreen đưa `CoachRoute` (AstroCoach) lên Tab chính NavigationBar; giữ ManualEntryRoute top-level | `ui-ux-designer` & `flutter-expert` | 5 | 🟢 Done |
| **`TSK-S4-BRAND`** | Onboarding Flow | **Gate 1-4** | Nâng cấp 5 bước Onboarding gắn kết triết lý "Tiểu vũ trụ dinh dưỡng", tối ưu thông điệp y khoa & BMR/TDEE | `business-analyst` & `flutter-expert` | 3 | 🟢 Done |
| **`TSK-S4-COACH-UI`** | AI Coach UI | **Gate 2-4** | Thêm AstroCoach Proactive Card trên HomePage (1 chạm hỏi AI); mở rộng Quick Action Chips phong phú | `ui-ux-designer` & `flutter-expert` | 3 | 🟢 Done |
| **`TSK-S4-HLTH-DASH`** | Health Sync | **Gate 2-4** | Tối ưu hiển thị kết nối Apple Health từ Profile và chuẩn bị thẻ cân bằng năng lượng Calo In/Out | `flutter-expert` | 2 | 🟢 Done |
| **`TSK-S4-POLISH`** | Polish | **Gate 4-5** | Tinh chỉnh mượt mà chuyển tab Navigation, hiệu ứng bụi sao và bóng Celestial glow | `flutter-expert` | 4 | 🟢 Done |

---

## 🏛️ 3. Lưu Trữ Ma Trận WBS Sprint 03 (v1.2.0 AI Coach & Health — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-CHAT-01..06`** | `EPIC-07` AI Coach | **Gate 1 - 6** | PRD, UI Chat Bubble, BDD Gherkin, Domain/Data/Presentation, Ponytail Review, Test 100% Pass | Đa Sub-Agents | 13 | 🟢 Done |
| **`TSK-HLTH-01..06`** | `EPIC-10` Health | **Gate 1 - 6** | PRD Health 2 chiều, UI Health Dashboard, BDD TCs, Health plugin wrapper, Ponytail Review, Test 100% Pass | Đa Sub-Agents | 8 | 🟢 Done |
| **`TSK-REL-03`** | Release v1.2.0 | **Gate 7** | Gắn Git Tag v1.2.0, cập nhật Roadmap, đóng Sprint 03 | PO & PM | 2 | 🟢 Done |

---

## 🏛️ 4. Lưu Trữ Ma Trận WBS Sprint 02 (v1.1.0 Enhancements — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-MUL-01..04`** | `FEAT-06` Multi-Item | **Gate 1 - 4** | PRD, UI đa món, BDD scenarios, Gemini Vision Prompt | Đa Sub-Agents | 9 | 🟢 Done |
| **`TSK-OFF-01..04`** | `FEAT-07` Offline-Sync | **Gate 1 - 4** | PRD Offline, UI Banner, BDD TCs, Local Cache & Queue | Đa Sub-Agents | 6 | 🟢 Done |
| **`TSK-MIC-01..04`** | `FEAT-08` Micronutrients | **Gate 1 - 4** | PRD Vi chất, UI Chips, BDD TCs, DailyMicronutrientCard | Đa Sub-Agents | 4 | 🟢 Done |
| **`TSK-S2-REV / VER`**| Sprint 02 Quality | **Gate 5 - 6** | Ponytail Code Review & Automated test 100% Pass | Code Reviewer & QA | 4 | 🟢 Done |
| **`TSK-REL-02`** | Release v1.1.0 | **Gate 7** | Gắn Git Tag v1.1.0, cập nhật Roadmap, đóng Sprint 02 | PO & PM | 2 | 🟢 Done |

---

## 🏛️ 5. Lưu Trữ Ma Trận WBS Sprint 01 (v1.0.0 MVP — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-AUT-01..05`** | `FEAT-01` Auth | **Gate 1 - 5** | PRD, TCs, UI LoginPage, Riverpod, Sign-off | Đa Sub-Agents | 11 | 🟢 Done |
| **`TSK-SCN-01..05`** | `FEAT-02` Scanner | **Gate 1 - 5** | PRD Vision AI, TCs, FoodScannerPage, Latency < 2.5s | Đa Sub-Agents | 19 | 🟢 Done |
| **`TSK-TRK-01..05`** | `FEAT-03` Diary | **Gate 1 - 5** | PRD Diary, TCs Slider, ManualEntryPage, 86 tests pass | Đa Sub-Agents | 13 | 🟢 Done |
| **`TSK-ANA-01..02`** | `FEAT-04` Analytics | **Gate 4 - 5** | Ponytail Review, RepaintBoundary FL Chart, Sign-off | Đa Sub-Agents | 5 | 🟢 Done |
| **`TSK-PRO-01..02`** | `FEAT-05` Profile | **Gate 4 - 5** | Ponytail Review, BMR/TDEE calculations, Sign-off | Đa Sub-Agents | 5 | 🟢 Done |
| **`TSK-REL-01`** | Release v1.0.0 | **Gate 6** | Release notes, Git Tag v1.0.0, PO sign-off phát hành | PO & PM | 3 | 🟢 Done |
