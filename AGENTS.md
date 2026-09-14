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

## 6. End-to-End Feature Delivery Lifecycle (6-Gate SOP)

All AI agents and developers must adhere to the standardized 6-Gate pipeline for any new feature:

```
[Gate 1: BA] ➔ [Gate 2: QA] ➔ [Gate 3: FE Dev (Ponytail)] ➔ [Gate 4: Code Review] ➔ [Gate 5: Verify] ➔ [Gate 6: Release]
```

1. **Gate 1: BA Gate (`docs/` - `business-analyst` skill)**:
   - Author PRD (`docs/03-prd-features/<id>-<name>/prd-<name>.md`).
   - Write User Stories with BDD Acceptance Criteria (`Given - When - Then`).
   - Update Data Dictionary (`docs/04-specifications/data-dictionary.md`) if data schema changes.
   - *Exit Gate*: PO / Tech Lead approvals.
2. **Gate 2: QA Test Design Gate (`tests/` - `qa-tester` skill)**:
   - Design manual test cases (`tests/02-manual-testcases/` covering Happy Path, Boundary, Edge-cases).
   - Write BDD Gherkin scenarios (`tests/03-bdd-gherkin-scenarios/<name>.feature`).
   - *Exit Gate*: 100% User Story coverage in Traceability Matrix.
3. **Gate 3: Frontend Development Gate (`frontend/` - `flutter-expert` & `ponytail` skills)**:
   - Implement Feature-First Clean Architecture (`domain/` -> `data/` -> `presentation/`) with **strict Ponytail discipline** (minimal code, stdlib first, zero over-engineering).
   - Strictly adhere to Celestial Dark UI tokens (`AppColors.surface`, Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700`).
   - *Exit Gate*: `flutter analyze` with 0 warnings/errors.
4. **Gate 4: Code Review Gate (`code-reviewer` / `ponytail-review` skill)**:
   - Inspect git diff against `main` for over-engineering, unneeded dependencies, boilerplate, and dead code.
   - Output in strict single-line format: `<file>:L<line>: <tag> <what>. <replacement>.`
   - Calculate net line reduction score: `net: -<N> lines possible.`
   - *Exit Gate*: All complexity pruned or verified as `Lean already. Ship.`
5. **Gate 5: Verification & QA Sign-off Gate (`flutter-testing` & `qa-tester` skills)**:
   - Run unit & widget tests (`flutter test` 100% Pass).
   - Execute E2E Integration tests (`frontend/integration_test/<name>_flow_test.dart`).
   - Non-functional mobile checks (FPS 55-60, AI latency <= 2.5s, Offline persistence).
   - *Exit Gate*: 0 S1/S2 bugs, QA Lead & PO signed sign-off checklist.
6. **Gate 6: Super-Repo Release Gate (Root Workspace Coordinator)**:
   - Synchronize all submodules: `make update`.
   - Verify full-workspace integrity: `make test-fe && make status`.
   - Commit submodule pointer updates: `git add docs tests frontend && git commit -m "feat(release): ship <name> (vX.Y.Z)"`.
   - Create and push release tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z" && git push origin vX.Y.Z`.

---

## 7. Prohibited Actions & Red Flags

- ❌ **Never** hardcode plain hex colors in UI files; always import and use `AppColors`.
- ❌ **Never** edit generated `.freezed.dart`, `.g.dart`, or `.gr.dart` files manually.
- ❌ **Never** bypass Firebase App Check activation in `main.dart`.
- ❌ **Never** introduce heavy state management alternatives (e.g., Bloc, GetX, Provider) alongside Riverpod.
- ❌ **Never** write speculative over-engineered code, dead abstractions, or unneeded dependencies (always apply Ponytail).
- ❌ **Never** merge code without passing Gate 4 (Ponytail Code Review) and Gate 5 (Automated Test Verification).


