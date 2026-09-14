# AstroBite 🌌🥗

> **AI-Powered Food Scanner & Calorie Tracker**  
> An intuitive, aesthetic nutrition tracker featuring a **Celestial Dark UI**, powered by **Flutter**, **Firebase**, and **Google Gemini AI**.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-AI%20%26%20Firestore-FFCA28?logo=firebase)](https://firebase.google.com)
[![Gemini](https://img.shields.io/badge/Google%20Gemini-Multimodal%20Vision-8E75B2?logo=google)](https://deepmind.google/technologies/gemini/)
[![State Management](https://img.shields.io/badge/State-Riverpod%202.x-blue)](https://riverpod.dev)

---

## 📖 Overview

**AstroBite** transforms daily calorie and macro tracking from a tedious chore into a seamless, deeply satisfying ritual. Users simply snap or upload a meal photo, and Google Gemini AI analyzes the nutritional breakdown—calories, protein, carbohydrates, and fats—within 2–4 seconds, with fine-tuned understanding of Vietnamese and global cuisine.

All features are presented inside a **Celestial Dark UI** designed to minimize eye strain during early morning or late-night logging while prioritizing one-handed mobile ergonomics.

---

## ✨ Key Features

- 📸 **AI Food Scanner**: Instant meal photo recognition with multi-macro estimation (Calories, Protein, Carbs, Fat) via Google Gemini Vision API (`firebase_ai`).
- ⚡ **Vietnamese & Global Cuisine Support**: Accurate estimation for complex mixed dishes (Phở, Cơm tấm, Bún chả, Salad, etc.).
- 📊 **Real-time Calorie & Macro Dashboard**: Interactive progress arcs and custom macro bars displaying daily intake goals vs. remaining budget.
- 📈 **Analytics & Trend Insights**: Interactive nutrition and weight progress visualization powered by `fl_chart`.
- 🌙 **Celestial Dark UI**: Material 3 scaffold wrapped in deep midnight navy (`#0A192F`), translucent glassmorphic surfaces, and strict nutrient color hierarchies.
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
│   ├── constants/                # App strings, numerical constraints
│   ├── router/                   # AutoRoute configuration & route guards
│   ├── theme/                    # Celestial Dark UI tokens (AppColors, AppTheme)
│   └── utils/                    # JSON parsers, nutrition calculation helpers
├── features/                     # Functional domain modules
│   ├── analytics/                # Progress charts and historical statistics
│   │   ├── data/                 # Repositories & data sources
│   │   ├── domain/               # Models & business entities
│   │   └── presentation/         # Controllers & UI screens
│   ├── auth/                     # Authentication & onboarding
│   ├── profile/                  # User profile & nutritional targets
│   ├── scanner/                  # Camera snapshot, Gemini AI analysis
│   └── tracker/                  # Daily food diary & meal logs
├── shared/                       # Cross-feature reusable UI components
│   └── widgets/                  # GlassCard, MacroBar, CalorieProgressArc, etc.
├── app.dart                      # Root application widget
├── firebase_options.dart         # Generated Firebase configuration
└── main.dart                     # App entry point
```

---

## 🎨 Celestial Dark UI & Design Tokens

AstroBite follows a strict semantic color mapping defined in [DESIGN.md](DESIGN.md):

| Color Token | Hex Code | Semantic Role |
|:------------|:---------|:--------------|
| **Surface** | `#0A192F` | Midnight sky background (system-wide dark mode) |
| **Surface Container** | `#112240` | Elevated card & container backgrounds |
| **Primary (Blue)** | `#1A73E8` | **Carbohydrates** indicator & active interactive states |
| **Secondary (Pink)** | `#FF69B4` | **Fat** indicator & weight trend analytics |
| **Tertiary (Gold)** | `#FFD700` | **Protein** indicator & calorie budget warnings |
| **Outline** | `#495670` | Subtle card borders & graph grid dividers |

For typography, spacing scales (4pt grid), and glassmorphism specifications, refer to [DESIGN.md](DESIGN.md).

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.0.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.0.0`)
- [Firebase CLI](https://firebase.google.com/docs/cli) (configured for your target Firebase project)
- An active Android / iOS emulator or connected physical device

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/AstroBite.git
   cd AstroBite
   ```

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
