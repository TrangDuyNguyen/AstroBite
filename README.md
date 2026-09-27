# AstroBite 🥑🥗

> **AI-Powered Food Scanner & Calorie Tracker**  
> An intuitive, aesthetic nutrition tracker featuring a **Claymorphic × Duolingo 2D/3D UI**, powered by **Flutter**, **Firebase**, and **Google Gemini AI**.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-AI%20%26%20Firestore-FFCA28?logo=firebase)](https://firebase.google.com)
[![Gemini](https://img.shields.io/badge/Google%20Gemini-Multimodal%20Vision-8E75B2?logo=google)](https://deepmind.google/technologies/gemini/)
[![State Management](https://img.shields.io/badge/State-Riverpod%202.x-blue)](https://riverpod.dev)

---

## 📖 Overview

**AstroBite** transforms daily calorie and macro tracking from a tedious chore into a seamless, deeply satisfying ritual. Users simply snap or upload a meal photo, and Google Gemini AI analyzes the nutritional breakdown—calories, protein, carbohydrates, and fats—within 2–4 seconds, with fine-tuned understanding of Vietnamese and global cuisine.

All features are presented inside an appetizing, playful **Claymorphic × Duolingo 2D/3D UI** with warm milk canvas (`#FAF8F5`), puffy tactile cards, and cheerful food-centric nutrient colors designed to stimulate appetite and make health tracking enjoyable.

---

## ✨ Key Features

- 📸 **AI Food Scanner**: Instant meal photo recognition with multi-macro estimation (Calories, Protein, Carbs, Fat) via Google Gemini Vision API (`firebase_ai`).
- ⚡ **Vietnamese & Global Cuisine Support**: Accurate estimation for complex mixed dishes (Phở, Cơm tấm, Bún chả, Salad, etc.).
- 📊 **Real-time Calorie & Macro Dashboard**: Interactive progress arcs and custom macro bars displaying daily intake goals vs. remaining budget.
- 📈 **Analytics & Trend Insights**: Interactive nutrition and weight progress visualization powered by `fl_chart`.
- 🧸 **Claymorphic × Duolingo 2D/3D UI**: Soft modeling-clay cards with fat rounded corners (`20pt`), tactile squash-on-press feedback, and appetizing food nutrient colors.
- 🔒 **Firebase Infrastructure**: End-to-end authentication, secure Cloud Firestore storage, Cloud Storage for meal snapshots, and Firebase App Check.

---

## 🛠️ Tech Stack & Architecture

### Core Technologies
- **Framework**: Flutter 3.x (Dart 3.x)
- **State Management**: [Riverpod 2.x](https://riverpod.dev) (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`)
- **Navigation & Routing**: [AutoRoute 9.x](https://autoroute.vercel.app/) (`auto_route`, `auto_route_generator`)
- **Backend & Cloud**:
  - Firebase Core & Authentication
  - Cloud Firestore & Cloud Storage
  - Firebase App Check
  - Google Gemini Multimodal AI via `firebase_ai`
- **Data Modeling**: [Freezed](https://pub.dev/packages/freezed) & `json_serializable`
- **Charts & UI**: `fl_chart`, `google_fonts`, custom glassmorphism widgets

### Architecture: Feature-First Clean Architecture

The codebase follows a modular, feature-driven structure:

```
lib/
├── core/                         # Shared core utilities, router, constants, theme
│   ├── constants/                # App strings, numerical constraints (4pt grid)
│   ├── router/                   # AutoRoute configuration & route guards
│   ├── theme/                    # Solar Fresh theme tokens (AppColors, AppTheme)
│   └── utils/                    # JSON parsers, nutrition calculation helpers
├── features/                     # Functional domain modules (Feature-First Clean Architecture)
│   ├── analytics/                # Progress charts and historical statistics
│   ├── auth/                     # Authentication & onboarding
│   ├── coach/                    # AI Nutrition Coach & GenUI widgets
│   ├── health/                   # HealthKit & Health Connect synchronization
│   ├── profile/                  # User profile & nutritional targets
│   ├── recipes/                  # Recipe builder & weekly meal planner
│   ├── scanner/                  # Camera snapshot, Gemini AI multimodal analysis
│   └── tracker/                  # Daily food diary & meal logs
├── shared/                       # Cross-feature reusable UI components & Design System
│   ├── ui_kit/                   # Central Claymorphic UI Kit (ui_kit.dart barrel)
│   │   ├── surfaces/             # ClayCard, ClaySheet
│   │   ├── buttons/              # ClayButton (Duolingo 3D), ClayIconButton
│   │   ├── inputs/               # ClayTextField, ClaySearchBar
│   │   ├── indicators/           # ChunkyMacroBar, CalorieProgressArc, ClaySkeletonLoader
│   │   ├── chips/                # ClayMealChip
│   │   └── navigation/           # ClayBottomNav
│   └── widgets/                  # Legacy widgets & backward-compatibility aliases
├── app.dart                      # Root application widget
├── firebase_options.dart         # Generated Firebase configuration
└── main.dart                     # App entry point
```

---

## 🎨 Claymorphic × Duolingo 2D/3D Design Tokens

AstroBite follows a strict semantic color mapping defined in [DESIGN.md](DESIGN.md):

| Color Token | Hex Code | Semantic Role |
|:------------|:---------|:--------------|
| **Surface** | `#FAF8F5` | Warm Milk Cream canvas (system-wide eye-soothing background) |
| **Surface Container** | `#FFFFFF` | Pure White Clay elevated cards & sheets |
| **Primary (Sky Blue)** | `#1CB0F6` | **Carbohydrates** indicator & active interactive states / primary CTAs |
| **Secondary (Pink)** | `#FF5C8D` | **Fat** indicator & weight trend analytics |
| **Tertiary (Tangerine)** | `#FF9600` | **Protein** indicator & calorie budget overflow warning |
| **Brand Green** | `#58CC02` | **Vitality**, streaks, and goal achievement |
| **Outline** | `#E8E5DF` | Soft clay card borders & dividers |
| **Text Primary** | `#1E2337` | Deep Slate Berry primary text (WCAG AAA > 13:1) |
| **Text Secondary** | `#78829A` | Cool Slate secondary text (WCAG AA > 4.8:1) |

For typography, spacing scales (4pt grid), and UI Kit specifications, refer to [DESIGN.md](DESIGN.md).

---

## 🏛️ Workspace Architecture & Git Submodules

AstroBite adopts an **Enterprise Super-Repo Architecture** coordinating 3 dedicated submodules:

```
AstroBite/ (Super-Repo / Workspace Coordinator)
├── .gitmodules                         # Submodule mapping definitions
├── Makefile                            # Workspace management automation
├── scripts/                            # Setup & synchronization scripts
├── docs/                               # 📁 [Submodule] astrobite-ba-docs (BABOK/Agile BA Specs)
├── tests/                              # 📁 [Submodule] astrobite-testcases (QA Strategy, Testcases & BDD)
└── frontend/                           # 📁 [Submodule] astrobite-frontend (Flutter Clean Architecture)
```

### ⚡ Quick Workspace Commands
- `make setup`  : Initialize and clone all submodules recursively.
- `make update` : Synchronize submodules to their latest remote commits.
- `make status` : Check Git branch and diff status across root and submodules.
- `make pull`   : Pull root repository and all submodules concurrently.
- `make test-fe`: Run unit/widget tests for the Flutter frontend.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.0.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.0.0`)
- [Firebase CLI](https://firebase.google.com/docs/cli) (configured for your target Firebase project)
- An active Android / iOS emulator or connected physical device

### Installation & Workspace Setup

1. **Clone the repository with submodules**:
   ```bash
   git clone --recurse-submodules https://github.com/TrangDuyNguyen/AstroBite.git
   cd AstroBite
   ```
   *(If cloned normally without `--recurse-submodules`, run `make setup`)*.


2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run code generation**:
   AstroBite uses `build_runner` for Riverpod providers, AutoRoute routes, and Freezed data classes:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   *(Use `dart run build_runner watch --delete-conflicting-outputs` during active development).*

4. **Firebase Configuration**:
   Ensure `lib/firebase_options.dart` is populated with your Firebase project credentials:
   ```bash
   flutterfire configure
   ```

5. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run all unit and widget tests:
```bash
flutter test
```

Run test suite with coverage report:
```bash
flutter test --coverage
```

---

## 📚 Documentation & Specifications

- 🎨 [Design System Specification (DESIGN.md)](DESIGN.md)
- 📐 [Product & Architecture Specs (docs/superpowers/specs/)](docs/superpowers/specs/2026-07-27-astrobite-design.md)
- 📋 [MVP Implementation Plan (docs/superpowers/plans/)](docs/superpowers/plans/2026-07-27-astrobite-mvp.md)
- 🤖 [AI Development Instructions (AGENTS.md)](AGENTS.md)
