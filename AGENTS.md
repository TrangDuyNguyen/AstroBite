# AGENTS.md — AstroBite Project Guidelines

> This file provides context, architectural constraints, and development guidelines for AI coding assistants (Google Antigravity, Gemini, Cursor, Claude Code, GitHub Copilot).

---

## 1. Project Overview

- **Name**: AstroBite (`astrobite`)
- **Type**: Cross-platform Mobile App (iOS & Android)
- **Description**: AI Food Scanner & Calorie/Macro Tracker powered by Google Gemini Vision AI and Firebase, featuring a signature Celestial Dark UI.
- **Key Reference Docs**:
  - Full Product & Architecture Spec: [`docs/superpowers/specs/2026-07-27-astrobite-design.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/superpowers/specs/2026-07-27-astrobite-design.md)
  - Design System Guide: [`DESIGN.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/DESIGN.md)
  - User-facing Readme: [`README.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/README.md)

---

## 2. Tech Stack & Dependencies

- **Flutter / Dart**: Flutter 3.x, Dart `>=3.0.0 <4.0.0`
- **State Management**: `flutter_riverpod: ^2.6.1`, `riverpod_annotation: ^2.6.1`, `riverpod_generator: ^2.6.3`
- **Routing**: `auto_route: ^9.2.2`, `auto_route_generator: ^9.0.0`
- **Backend & Cloud**:
  - `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_app_check`
  - `firebase_ai`: Multimodal AI calls (Gemini 2.0 Flash)
- **Data Modeling**: `freezed: ^3.0.2`, `json_serializable: ^6.9.4`
- **Charts & Visualization**: `fl_chart: ^0.70.2`
- **Media**: `image_picker: ^1.1.2`, `cached_network_image: ^3.4.1`

---

## 3. Directory Structure & Architecture Rules

AstroBite uses **Feature-First Clean Architecture**:

```
lib/
├── core/                         # Cross-cutting concerns & foundational layer
│   ├── constants/                # App strings, numerical constraints (app_strings.dart, app_values.dart)
│   ├── router/                   # AutoRoute setup (app_router.dart, app_router.gr.dart)
│   ├── theme/                    # Celestial theme tokens (app_colors.dart, app_theme.dart)
│   └── utils/                    # Parsers & calculation logic (nutrition_calculator.dart, json_parser.dart)
├── features/                     # Business domain modules
│   ├── analytics/                # Historical stats & trends (data, domain, presentation)
│   ├── auth/                     # Authentication, login & onboarding (data, domain, presentation)
│   ├── profile/                  # User profile & daily goals (data, domain, presentation)
│   ├── scanner/                  # Food photo scanning via Gemini AI (data, domain, presentation)
│   └── tracker/                  # Food diary, meal logs, macros (data, domain, presentation)
├── shared/                       # Cross-feature reusable widgets
│   └── widgets/                  # GlassCard, MacroBar, CalorieProgressArc, MealTypeChip, SkeletonLoader
├── app.dart                      # Root MaterialApp / AutoRoute configuration
└── main.dart                     # App initialization (Firebase, App Check, ProviderScope)
```

### Layer Constraints
1. **Domain (`features/<feature>/domain`)**:
   - Pure Dart entities and value objects.
   - Use `@freezed` for immutable models.
   - No Flutter UI imports (`package:flutter/...`) in domain models unless strictly necessary.
2. **Data (`features/<feature>/data`)**:
   - Firestore data sources, Firebase Storage uploads, API clients.
   - DTOs / serialization with `json_serializable`.
   - Repository implementations that map DTOs to Domain entities.
3. **Presentation (`features/<feature>/presentation`)**:
   - Riverpod `@riverpod` controllers / Notifiers (`AsyncNotifier`).
   - Screens annotated with `@RoutePage()`.
   - UI widgets, dialogs, and sheets consuming providers via `ConsumerWidget` or `ConsumerStatefulWidget`.
4. **Shared (`shared/widgets`)**:
   - Stateless or purely visual reusable components without direct feature-specific domain couplings.

---

## 4. UI & Design System Rules (Celestial Dark UI)

> [!IMPORTANT]
> Always adhere to the tokens defined in `lib/core/theme/app_colors.dart` and `DESIGN.md`.

- **Strict Nutrient Color Semantics (IMMUTABLE)**:
  - 🔵 **Primary (`#1A73E8`)**: Carbohydrates indicator + active interactive states (FAB, tabs).
  - 🩷 **Secondary (`#FF69B4`)**: Fat indicator + analytics trend lines.
  - 🟡 **Tertiary (`#FFD700`)**: Protein indicator + calorie budget warning.
  - **Do NOT** repurpose or invert these nutrient color associations.
- **Backgrounds & Surfaces**:
  - Midnight background: `AppColors.surface` (`#0A192F`).
  - Elevated cards: `AppColors.surfaceContainer` (`#112240`).
  - Glassmorphic overlays: `AppColors.surfaceBlur` (`0x99192A46`) with `BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20))`.
  - Always set `surfaceTintColor: Colors.transparent` on cards/appbars to avoid default Material 3 purple tinting.
- **Ergonomics**:
  - Follow the 4pt spacing grid (`AppValues.padding*`).
  - Minimum touch target: `44x44pt` for all interactive elements.

---

## 5. Coding & Development Conventions

### Development Philosophy (Strict Ponytail Mindset)
> [!IMPORTANT]
> All coding and development in AstroBite MUST strictly apply the **`ponytail`** skill mindset: ruthless simplicity, zero bloat, deletion over addition.

Before writing any new code, climb the Ponytail ladder:
1. **YAGNI First**: Does this need to be built at all? Never write speculative abstractions or future-proofing nobody asked for.
2. **Reuse Existing Code**: Check if a helper, utility, or widget pattern already exists in `lib/core/` or `lib/shared/`. Reuse it, never reinvent it.
3. **Standard Library & Native Features**: Use Dart standard library and native Flutter features before writing custom algorithms.
4. **Zero Unneeded Dependencies**: Never introduce a new package if standard Flutter/Dart or existing dependencies already solve it.
5. **Shortest Working Diff**: One line before fifty. Shortest working diff wins. Boring over clever. Fewest files possible.
6. **Mark Ceilings**: If a deliberate shortcut is taken, mark it with `// ponytail: <ceiling and upgrade path>`.

### State Management (Riverpod)
- Prefer code-generation syntax (`@riverpod`) over legacy global provider declarations.
- Use `AsyncValue` for asynchronous state handling (loading, error, data).
- Keep side-effects inside Notifier methods; never call asynchronous business logic directly in `build()` methods.

### Routing (AutoRoute)
- Every screen that can be navigated to must be annotated with `@RoutePage()`.
- Whenever adding or updating routes, re-run `build_runner`.
- Access router via `context.router` or typed extension methods.

### Code Generation (`build_runner`)
Run whenever models, routes, or providers are updated:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Testing Rules
- Place all unit and widget tests in the `test/` directory mirroring `lib/`.
- Verify tests before completing tasks:
```bash
flutter test
```
- For mock test doubles, prefer mocktail or manual mocks without unnecessary heavy dependencies.

---

## 6. End-to-End Feature Delivery Lifecycle (6-Gate SOP & Multi Sub-Agent Architecture)

All engineering and delivery in AstroBite is executed by **6 Independent Sub-Agents** operating under the **Four-Eyes Principle (Checks & Balances)**. No Sub-Agent has the authority to self-approve its own deliverables:

```
[PO Sub-Agent] ──────────► [BA Sub-Agent] ──────────► [PO Sub-Agent Duyệt]
(Roadmap & Epics)          (Gate 1: PRD & BDD)         (Gate 1 Sign-Off)
                                                              │
                                                              ▼
[Gate 4: Reviewer] ◄───── [Gate 3: Dev FE] ◄───────── [PM Sub-Agent]
(Sub-Agent Reviewer)       (Sub-Agent Dev FE)          (Sprint & WBS Tasks)
       │                                                      │
       ▼                                                      ▼
[Gate 5: QA Verify] ─────► [Gate 6: PO & PM Release] ◄────── [Gate 2: QA Design]
(Sub-Agent QA Tester)      (Final Release Sign-Off)    (Sub-Agent QA Tester)
```

### The 6 Independent Sub-Agents & Quality Gates

1. **Sub-Agent PO (`product-owner` skill)**:
   - **Thẩm quyền**: Định hướng Tầm nhìn, OKRs, Lộ trình 3 Chân trời (`docs/00-roadmap/product-roadmap.md`), phân loại **MoSCoW** (`docs/00-roadmap/epics-backlog.md`).
   - **Chốt cổng**: Thẩm định & ký duyệt Gate 1 (PRD Sign-off); Ký duyệt phát hành tối cao tại Gate 6.
2. **Sub-Agent PM (`project-manager` skill)**:
   - **Thẩm quyền**: Quản lý Sprint Backlog (`docs/00-project-management/sprint-backlog.md`), phân rã **WBS Task Matrix** (`wbs-task-matrix.md`), chấm **Fibonacci Story Points (1, 2, 3, 5, 8)**, và xử lý điểm nghẽn (`risk-blocker-log.md`).
   - **Chốt cổng**: Kiểm soát tiến độ các Gates và điều phối bàn giao giữa các Sub-Agents.
3. **Gate 1: Sub-Agent BA (`business-analyst` skill)**:
   - Soạn PRD (`docs/03-prd-features/<id>-<name>/prd-<name>.md`), User Stories BDD (`Given-When-Then`), cập nhật Data Dictionary.
   - *Exit Gate*: Sub-Agent PO phê duyệt chính thức (PO Sign-off).
4. **Gate 2: Sub-Agent QA (`qa-tester` skill)**:
   - Thiết kế Manual Testcases (`tests/02-manual-testcases/` EP & BVA) và kịch bản BDD Gherkin (`tests/03-bdd-gherkin-scenarios/*.feature`).
   - *Exit Gate*: Ma trận truy vết (Traceability Matrix) bao phủ 100% User Stories của BA.
5. **Gate 3: Sub-Agent Dev FE (`flutter-expert` & `ponytail` skills)**:
   - Triển khai Feature-First Clean Architecture (`domain` -> `data` -> `presentation`) theo **kỷ luật Ponytail** (code tối giản, stdlib trước, zero over-engineering).
   - Tuyệt đối tuân thủ bảng màu dinh dưỡng: Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700`.
   - *Exit Gate*: `flutter analyze` đạt 0 lỗi, 0 cảnh báo.
6. **Gate 4: Sub-Agent Reviewer (`code-reviewer` & `ponytail-review` skills)**:
   - Rà soát git diff khách quan, loại bỏ triệt để abstraction rác, dead code, dependency thừa.
   - Xuất phát hiện định dạng 1 dòng: `<file>:L<line>: <tag> <what>. <replacement>.`
   - *Exit Gate*: Phải đạt phán quyết `Lean already. Ship.`
7. **Gate 5: Sub-Agent QA Verification (`flutter-testing` & `qa-tester` skills)**:
   - Chạy automated test suite (`flutter test` 100% Pass) và Integration test.
   - Đo lường phi chức năng: FPS >= 55, AI latency <= 2.5s, Offline persistence.
   - *Exit Gate*: 0 bug S1/S2, Sub-Agent QA ký biên bản nghiệm thu `tests/05-test-execution-reports/release-sign-offs/signoff-<name>.md`.
8. **Gate 6: Super-Repo Release Gate (Sub-Agent PO & PM)**:
   - PO kiểm tra nghiệm thu tổng thể và ký duyệt phát hành.
   - PM điều phối: `make update`, `make test-fe && make status`.
   - Commit cập nhật pointer submodules và gắn tag phát hành: `git tag -a vX.Y.Z -m "Release vX.Y.Z" && git push origin vX.Y.Z`.
   - PO cập nhật Roadmap sang trạng thái `Done`, PM đóng Sprint.

---

## 7. Prohibited Actions & Red Flags

- ❌ **Never** hardcode plain hex colors in UI files; always import and use `AppColors`.
- ❌ **Never** edit generated `.freezed.dart`, `.g.dart`, or `.gr.dart` files manually.
- ❌ **Never** bypass Firebase App Check activation in `main.dart`.
- ❌ **Never** introduce heavy state management alternatives (e.g., Bloc, GetX, Provider) alongside Riverpod.
- ❌ **Never** write speculative over-engineered code, dead abstractions, or unneeded dependencies (always apply Ponytail).
- ❌ **Never** merge code without passing Gate 4 (Ponytail Code Review) and Gate 5 (Automated Test Verification).


