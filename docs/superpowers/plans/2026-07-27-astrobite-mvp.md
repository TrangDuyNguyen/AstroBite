# AstroBite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build AstroBite — an AI-powered calorie tracker Flutter app with Celestial Dark UI, Firebase backend, and Gemini Vision integration.

**Architecture:** Clean Architecture (Feature-First) with Riverpod state management, Auto Route navigation, and Material 3 theming. Firebase provides auth, Firestore database, Cloud Storage, and AI Logic (Gemini). All features are modular and independently testable.

**Tech Stack:** Flutter/Dart, Riverpod, Auto Route, Firebase (Auth, Firestore, Storage, App Check, AI Logic), Gemini 2.0 Flash, fl_chart, freezed, google_fonts

**Spec:** [2026-07-27-astrobite-design.md](file:///Users/trang.nguyen1/flutter_project/AstroBite/docs/superpowers/specs/2026-07-27-astrobite-design.md)

---

## Phase 1: Project Foundation

### Task 1: Create Flutter Project & Configure Dependencies

**Files:**
- Create: `lib/main.dart`
- Create: `pubspec.yaml`
- Create: `analysis_options.yaml`

- [ ] **Step 1: Create Flutter project**

```bash
cd /Users/trang.nguyen1/flutter_project/AstroBite
flutter create --org com.solopreneur --project-name astrobite --platforms android,ios .
```

Expected: Flutter project scaffolded with default files.

- [ ] **Step 2: Replace pubspec.yaml with project dependencies**

Replace contents of `/Users/trang.nguyen1/flutter_project/AstroBite/pubspec.yaml`:

```yaml
name: astrobite
description: "AstroBite - AI Food Scanner & Calorie Tracker"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.8.0

dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.13.0
  firebase_auth: ^5.7.0
  cloud_firestore: ^5.12.0
  firebase_storage: ^12.6.0
  firebase_app_check: ^0.3.3+2
  firebase_ai: ^0.3.0

  # State Management
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # Navigation
  auto_route: ^9.2.2

  # UI
  google_fonts: ^6.2.1
  fl_chart: ^0.70.2

  # Camera & Image
  image_picker: ^1.1.2

  # Utilities
  intl: ^0.20.2
  cached_network_image: ^3.4.1
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.14
  auto_route_generator: ^9.0.0
  riverpod_generator: ^2.6.3
  freezed: ^3.0.2
  json_serializable: ^6.9.4

flutter:
  uses-material-design: true
```

- [ ] **Step 3: Install dependencies**

```bash
cd /Users/trang.nguyen1/flutter_project/AstroBite
flutter pub get
```

Expected: All packages resolve successfully.

- [ ] **Step 4: Commit**

```bash
cd /Users/trang.nguyen1/flutter_project/AstroBite
git init
git add .
git commit -m "chore: initialize Flutter project with dependencies"
```

---

### Task 2: Configure Material 3 Celestial Dark Theme

**Files:**
- Create: `lib/core/theme/app_theme.dart`
- Create: `lib/core/theme/app_colors.dart`

- [ ] **Step 1: Create app_colors.dart with Celestial Dark tokens**

Create `/Users/trang.nguyen1/flutter_project/AstroBite/lib/core/theme/app_colors.dart`:

```dart
import 'package:flutter/material.dart';

/// Celestial Dark UI color tokens mapped to Material 3 ColorScheme.
///
/// Color semantic mapping:
/// - Primary (Blue #1A73E8) = Carbohydrates + Active UI
/// - Secondary (Pink #FF69B4) = Fat + Analytics curves
/// - Tertiary (Gold #FFD700) = Protein + Calorie overflow warning
abstract final class AppColors {
  // Base & Background
  static const surface = Color(0xFF0A192F);
  static const surfaceContainer = Color(0xFF112240);
  static const surfaceBlur = Color(0x99192A46);

  // Accent & Interactive (Nutrient Mapping)
  static const primary = Color(0xFF1A73E8);
  static const secondary = Color(0xFFFF69B4);
  static const tertiary = Color(0xFFFFD700);

  // Typography
  static const onSurface = Color(0xFFFFFFFF);
  static const onSurfaceVariant = Color(0xFF8892B0);
  static const outline = Color(0xFF495670);

  // Semantic
  static const error = Color(0xFFCF6679);
  static const success = Color(0xFF4CAF50);
}
```

- [ ] **Step 2: Create app_theme.dart with M3 ThemeData**

Create `/Users/trang.nguyen1/flutter_project/AstroBite/lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      surface: AppColors.surface,
      surfaceContainer: AppColors.surfaceContainer,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.black,
      error: AppColors.error,
      onError: Colors.black,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
    );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
      headlineMedium: GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w700,
        height: 1.25, color: AppColors.onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w500,
        height: 1.3, color: AppColors.onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400,
        height: 1.4, color: AppColors.onSurfaceVariant,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.outline,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0, centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0, shape: CircleBorder(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
      ),
    );
  }
}
```

- [ ] **Step 3: Verify theme compiles**

```bash
flutter analyze lib/core/theme/
```

- [ ] **Step 4: Commit**

```bash
git add lib/core/theme/
git commit -m "feat: add Celestial Dark UI theme with M3 ColorScheme"
```

---

### Task 3: Setup Constants & Utilities with Tests

**Files:**
- Create: `lib/core/constants/app_strings.dart`
- Create: `lib/core/constants/app_values.dart`
- Create: `lib/core/utils/nutrition_calculator.dart`
- Create: `lib/core/utils/json_parser.dart`
- Test: `test/core/utils/nutrition_calculator_test.dart`
- Test: `test/core/utils/json_parser_test.dart`

- [ ] **Step 1: Create app_strings.dart** — Vietnamese UI strings (login, meal names, scanner messages, error messages)
- [ ] **Step 2: Create app_values.dart** — 4pt grid spacing tokens, business rules (maxDailyScans=10), activity multipliers
- [ ] **Step 3: Create nutrition_calculator.dart** — Mifflin-St Jeor BMR, TDEE, calorie recalculation
- [ ] **Step 4: Create json_parser.dart** — Defensive Gemini response parser (strips markdown, extracts JSON)
- [ ] **Step 5: Write unit tests for NutritionCalculator** — BMR male/female, TDEE all activity levels, calorie scaling
- [ ] **Step 6: Write unit tests for JsonParser** — Clean JSON, markdown-wrapped, text-surrounded, invalid input
- [ ] **Step 7: Run tests** — `flutter test test/core/`
- [ ] **Step 8: Commit**

```bash
git add lib/core/constants/ lib/core/utils/ test/core/
git commit -m "feat: add constants, nutrition calculator, and JSON parser with tests"
```

---

### Task 4: Configure Auto Route Navigation

**Files:**
- Create: `lib/core/router/app_router.dart`
- Create: `lib/core/router/placeholder_screens.dart`
- Create: `lib/app.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Create app_router.dart** — Define all routes (Splash, Login, Register, Shell with Home/Analytics/Manual/Profile tabs, Camera, ScanReview, MealDetail, ProfileEdit)
- [ ] **Step 2: Create placeholder_screens.dart** — Minimal stub screens for all routes so router compiles
- [ ] **Step 3: Create app.dart** — MaterialApp.router with AppTheme.darkTheme and ProviderScope
- [ ] **Step 4: Update main.dart** — WidgetsFlutterBinding + ProviderScope + AstroBiteApp
- [ ] **Step 5: Run build_runner** — `dart run build_runner build --delete-conflicting-outputs`
- [ ] **Step 6: Verify compiles** — `flutter analyze`
- [ ] **Step 7: Commit**

```bash
git add lib/core/router/ lib/app.dart lib/main.dart
git commit -m "feat: configure Auto Route navigation with placeholder screens"
```

---

### Task 5: Shared UI Widgets

**Files:**
- Create: `lib/shared/widgets/glass_card.dart`
- Create: `lib/shared/widgets/calorie_progress_arc.dart`
- Create: `lib/shared/widgets/macro_bar.dart`
- Create: `lib/shared/widgets/skeleton_loader.dart`
- Create: `lib/shared/widgets/meal_type_chip.dart`

- [ ] **Step 1: Create glass_card.dart** — BackdropFilter blur + translucent background + outline border
- [ ] **Step 2: Create calorie_progress_arc.dart** — Circular arc with CustomPainter, blue normal / gold over-budget, center text
- [ ] **Step 3: Create macro_bar.dart** — Horizontal LinearProgressIndicator with label and gram counter
- [ ] **Step 4: Create skeleton_loader.dart** — CircularProgressIndicator + rotating Vietnamese nutrition tips
- [ ] **Step 5: Create meal_type_chip.dart** — Animated capsule chip with emoji + meal name, selected state
- [ ] **Step 6: Verify compiles** — `flutter analyze lib/shared/`
- [ ] **Step 7: Commit**

```bash
git add lib/shared/
git commit -m "feat: add shared UI widgets (GlassCard, CalorieArc, MacroBar, Skeleton, MealChip)"
```

---

## Phase 2: Firebase Integration

### Task 6: Firebase Project Setup & Configuration

**Files:**
- Modify: `lib/main.dart`
- Create: Firebase config files (generated by FlutterFire CLI)

- [ ] **Step 1: Install FlutterFire CLI** — `dart pub global activate flutterfire_cli`
- [ ] **Step 2: Configure Firebase** — `flutterfire configure --project=<PROJECT_ID>`
- [ ] **Step 3: Update main.dart** — Add `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`
- [ ] **Step 4: Verify compiles** — `flutter analyze`
- [ ] **Step 5: Commit**

```bash
git add .
git commit -m "feat: configure Firebase project with FlutterFire CLI"
```

---

### Task 7: Firebase Auth Feature

**Files:**
- Create: `lib/features/auth/data/auth_repository.dart`
- Create: `lib/features/auth/domain/auth_providers.dart`
- Create: `lib/features/auth/presentation/login_screen.dart`
- Create: `lib/features/auth/presentation/register_screen.dart`

- [ ] **Step 1: Create auth_repository.dart** — FirebaseAuth wrapper (signIn, register, signOut, authStateChanges)
- [ ] **Step 2: Create auth_providers.dart** — Riverpod providers for AuthRepository and auth state stream
- [ ] **Step 3: Create login_screen.dart** — Email/password form, error handling, navigate to Shell on success
- [ ] **Step 4: Create register_screen.dart** — Email/password/confirm form, auto-login after register
- [ ] **Step 5: Update router imports** — Replace placeholder auth screens with real implementations
- [ ] **Step 6: Run code generation and verify** — `dart run build_runner build && flutter analyze`
- [ ] **Step 7: Commit**

```bash
git add lib/features/auth/ lib/core/router/
git commit -m "feat: implement Firebase Auth with login and register screens"
```

---

## Phase 3: Core Features

### Task 8: Firestore Data Layer — Models & Repositories

**Files:**
- Create: `lib/features/scanner/data/models/scan_result_dto.dart`
- Create: `lib/features/tracker/data/models/food_log_dto.dart`
- Create: `lib/features/profile/data/models/user_profile_dto.dart`
- Create: `lib/features/tracker/data/food_log_repository.dart`
- Create: `lib/features/profile/data/profile_repository.dart`

- [ ] **Step 1: Create scan_result_dto.dart** — freezed model matching Gemini JSON schema (is_food, total_calories, macros, dishes array)
- [ ] **Step 2: Create food_log_dto.dart** — freezed model matching Firestore foodLogs document schema
- [ ] **Step 3: Create user_profile_dto.dart** — freezed model matching Firestore users document schema
- [ ] **Step 4: Create food_log_repository.dart** — Firestore CRUD (addLog, getLogs by date, deleteLog, updateLog)
- [ ] **Step 5: Create profile_repository.dart** — Firestore CRUD (getProfile, updateProfile, createProfile)
- [ ] **Step 6: Run build_runner** — `dart run build_runner build --delete-conflicting-outputs`
- [ ] **Step 7: Write unit tests for models**
- [ ] **Step 8: Commit**

```bash
git add lib/features/*/data/ test/features/
git commit -m "feat: add Firestore data models and repositories"
```

---

### Task 9: AI Food Scanner Feature

**Files:**
- Create: `lib/features/scanner/data/gemini_service.dart`
- Create: `lib/features/scanner/data/food_scan_repository.dart`
- Create: `lib/features/scanner/domain/entities/scan_result.dart`
- Create: `lib/features/scanner/domain/scan_food_usecase.dart`
- Create: `lib/features/scanner/domain/scanner_providers.dart`
- Create: `lib/features/scanner/presentation/camera_screen.dart`
- Create: `lib/features/scanner/presentation/scan_review_screen.dart`

- [ ] **Step 1: Create gemini_service.dart** — Firebase AI Logic SDK: initialize model, send image with system prompt, parse response
- [ ] **Step 2: Create scan_result entity** — Domain entity from DTO
- [ ] **Step 3: Create food_scan_repository.dart** — Wraps GeminiService + aiUsage Firestore tracking
- [ ] **Step 4: Create scan_food_usecase.dart** — Check rate limit → call scan → parse → return result
- [ ] **Step 5: Create scanner_providers.dart** — Riverpod providers for all scanner dependencies
- [ ] **Step 6: Create camera_screen.dart** — image_picker capture/gallery, navigate to review on success
- [ ] **Step 7: Create scan_review_screen.dart** — Editable form for dish names/weights, save to Firestore
- [ ] **Step 8: Write tests for rate limiting and scan flow**
- [ ] **Step 9: Commit**

```bash
git add lib/features/scanner/ test/features/scanner/
git commit -m "feat: implement AI food scanner with Gemini and rate limiting"
```

---

### Task 10: Daily Tracker & Home Dashboard

**Files:**
- Create: `lib/features/tracker/domain/entities/food_log.dart`
- Create: `lib/features/tracker/domain/daily_summary.dart`
- Create: `lib/features/tracker/domain/tracker_providers.dart`
- Create: `lib/features/tracker/presentation/home_screen.dart`
- Create: `lib/features/tracker/presentation/meal_detail_screen.dart`
- Create: `lib/features/tracker/presentation/manual_entry_screen.dart`
- Create: `lib/features/tracker/presentation/widgets/*`

- [ ] **Step 1: Create food_log entity and daily_summary domain model**
- [ ] **Step 2: Create tracker_providers.dart** — Daily logs stream, summary computation provider
- [ ] **Step 3: Create home_screen.dart** — CalorieProgressArc + MacroBars + meal sections layout
- [ ] **Step 4: Create meal_detail_screen.dart** — Food items list per meal type
- [ ] **Step 5: Create manual_entry_screen.dart** — Search bar + food selection + weight adjustment
- [ ] **Step 6: Create dashboard widgets** — daily_summary_card, meal_section, food_search_bar
- [ ] **Step 7: Write widget tests**
- [ ] **Step 8: Commit**

```bash
git add lib/features/tracker/ test/features/tracker/
git commit -m "feat: implement home dashboard and daily food tracker"
```

---

### Task 11: User Profile & BMR/TDEE

**Files:**
- Create: `lib/features/profile/domain/entities/user_profile.dart`
- Create: `lib/features/profile/domain/profile_providers.dart`
- Create: `lib/features/profile/presentation/profile_screen.dart`
- Create: `lib/features/profile/presentation/profile_edit_screen.dart`
- Create: `lib/features/profile/presentation/widgets/bmr_tdee_card.dart`

- [ ] **Step 1: Create user_profile entity**
- [ ] **Step 2: Create profile_providers.dart**
- [ ] **Step 3: Create profile_screen.dart** — Display user info + BMR/TDEE card + sign out button
- [ ] **Step 4: Create profile_edit_screen.dart** — Gender/height/weight/activity form
- [ ] **Step 5: Create bmr_tdee_card.dart** — Visual card showing computed BMR, TDEE, daily target
- [ ] **Step 6: Write tests**
- [ ] **Step 7: Commit**

```bash
git add lib/features/profile/ test/features/profile/
git commit -m "feat: implement user profile with BMR/TDEE calculator"
```

---

### Task 12: Analytics & Charts

**Files:**
- Create: `lib/features/analytics/data/analytics_repository.dart`
- Create: `lib/features/analytics/domain/analytics_providers.dart`
- Create: `lib/features/analytics/presentation/analytics_screen.dart`
- Create: `lib/features/analytics/presentation/widgets/calorie_trend_chart.dart`
- Create: `lib/features/analytics/presentation/widgets/weight_trend_chart.dart`

- [ ] **Step 1: Create analytics_repository.dart** — Query Firestore foodLogs by date range
- [ ] **Step 2: Create analytics_providers.dart** — 7-day and 30-day data providers
- [ ] **Step 3: Create analytics_screen.dart** — Tab navigation (7d/30d) with charts
- [ ] **Step 4: Create calorie_trend_chart.dart** — fl_chart LineChart with Bézier curves
- [ ] **Step 5: Create weight_trend_chart.dart** — fl_chart LineChart for weight over time
- [ ] **Step 6: Write tests**
- [ ] **Step 7: Commit**

```bash
git add lib/features/analytics/ test/features/analytics/
git commit -m "feat: implement analytics with calorie and weight trend charts"
```

---

## Phase 4: Integration & Polish

### Task 13: Bottom Navigation Shell & Auth Guard

**Files:**
- Modify: `lib/core/router/app_router.dart`
- Create: `lib/features/auth/presentation/splash_screen.dart`

- [ ] **Step 1: Create splash_screen.dart** — Check auth state, redirect to Login or Shell
- [ ] **Step 2: Update ShellScreen** — NavigationBar with 5 items (Home, Analytics, Camera FAB center, Manual, Profile)
- [ ] **Step 3: Add auth guard to router** — Redirect to LoginRoute if not authenticated
- [ ] **Step 4: Update all router imports to real screens**
- [ ] **Step 5: Run code generation and verify**
- [ ] **Step 6: Commit**

```bash
git add lib/core/router/ lib/features/auth/presentation/
git commit -m "feat: add bottom navigation shell with auth guard"
```

---

### Task 14: Firestore Security Rules & App Check

**Files:**
- Create: `firestore.rules`
- Modify: `lib/main.dart`

- [ ] **Step 1: Create firestore.rules** — User-scoped read/write rules for users, foodLogs, aiUsage
- [ ] **Step 2: Add App Check to main.dart** — `FirebaseAppCheck.instance.activate()`
- [ ] **Step 3: Deploy rules** — `firebase deploy --only firestore:rules`
- [ ] **Step 4: Commit**

```bash
git add firestore.rules lib/main.dart
git commit -m "feat: add Firestore security rules and App Check"
```

---

### Task 15: Final Integration Testing & Polish

- [ ] **Step 1: Run full test suite** — `flutter test`
- [ ] **Step 2: Run flutter analyze** — `flutter analyze`
- [ ] **Step 3: Manual verification on emulator/device** — `flutter run`
  - Login/Register flow
  - Celestial Dark UI theme
  - Dashboard with CalorieArc + MacroBars
  - Camera capture + AI scan
  - Manual food entry
  - Profile BMR/TDEE
  - Analytics charts
  - Rate limiting (10 scans/day)
- [ ] **Step 4: Final commit**

```bash
git add .
git commit -m "feat: AstroBite MVP v1.0 complete"
```
