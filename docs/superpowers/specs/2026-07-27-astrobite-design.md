# AstroBite — Design Specification

**Project:** AstroBite (AI Food Scanner & Calorie Tracker)
**Version:** 1.0 (MVP)
**Theme:** Celestial Dark UI × Flutter Material 3
**Target Platforms:** Android & iOS (Cross-platform)
**Date:** 2026-07-27

---

## 1. Product Overview

### 1.1 Vision
AstroBite transforms calorie tracking from a tedious chore into a calm, focused, and deeply aesthetic ritual. Users snap a photo of their meal, and Gemini AI instantly analyzes nutritional content — calories, protein, carbs, and fat — displayed within a premium Celestial Dark UI.

### 1.2 Core Value Proposition
- **Chụp ảnh → AI phân tích dinh dưỡng** trong 2-4 giây
- Hỗ trợ đặc biệt tốt cho **ẩm thực Việt Nam** (Phở, Cơm tấm, Bún chả, etc.)
- Giao diện **Dark Mode huyền ảo** giảm mỏi mắt khi dùng sáng sớm/tối muộn
- **Miễn phí** 10 lượt quét AI/ngày

### 1.3 Target User
Solopreneur/người dùng cá nhân quan tâm đến sức khỏe, muốn theo dõi dinh dưỡng hàng ngày một cách nhanh chóng và trực quan.

---

## 2. System Architecture

### 2.1 High-Level Architecture

```
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────────┐
│   Flutter App        │     │   Firebase             │     │   Google Gemini      │
│   (Dart)             │────▶│                        │────▶│   API                │
│                      │     │   • Authentication     │     │   (via Firebase      │
│   • Riverpod         │     │   • Cloud Firestore    │     │    AI Logic)         │
│   • Auto Route       │     │   • Cloud Storage      │     │                      │
│   • Material 3       │     │   • App Check          │     │   gemini-2.0-flash   │
│   • Clean Arch       │     │   • AI Logic SDK       │     │   Multimodal Vision  │
└─────────────────────┘     └──────────────────────┘     └─────────────────────┘
```

### 2.2 Tech Stack

| Layer | Technology | Rationale |
|:------|:-----------|:----------|
| **Frontend** | Flutter (Dart) | Cross-platform, single codebase for Android & iOS |
| **State Management** | Riverpod | Type-safe, testable, modern Flutter standard |
| **Navigation** | Auto Route | Code generation, type-safe routing with deep linking |
| **UI System** | Material 3 (Dark) | Native M3 widgets + Celestial Dark UI overlay |
| **Backend** | Firebase | Google ecosystem integration, generous free tier |
| **Database** | Cloud Firestore | NoSQL, realtime sync, offline support |
| **AI Engine** | Firebase AI Logic → Gemini 2.0 Flash | Direct client-side calls, secured by App Check |
| **Authentication** | Firebase Auth | Email/password + social OAuth |
| **Image Storage** | Firebase Cloud Storage | Store food scan images |
| **Security** | Firebase App Check | Protect AI Logic calls from abuse |

### 2.3 Architecture Pattern: Clean Architecture + Feature-First

```
lib/
├── main.dart
├── app.dart                          # MaterialApp, Theme, Router setup
│
├── core/                             # Shared across all features
│   ├── theme/
│   │   └── app_theme.dart            # M3 ColorScheme (Celestial Dark)
│   ├── constants/
│   │   ├── app_strings.dart          # Vietnamese UI strings
│   │   └── app_values.dart           # Grid spacing, limits (10 scans/day)
│   ├── utils/
│   │   ├── json_parser.dart          # Defensive JSON parsing for Gemini
│   │   └── nutrition_calculator.dart # BMR/TDEE/macro formulas
│   └── router/
│       └── app_router.dart           # Auto Route configuration
│
├── shared/                           # Reusable UI components
│   └── widgets/
│       ├── glass_card.dart           # Glassmorphism card component
│       ├── calorie_progress_arc.dart # Circular progress indicator
│       ├── macro_bar.dart            # Protein/Carbs/Fat bar
│       ├── skeleton_loader.dart      # Loading skeleton with tips
│       └── meal_type_chip.dart       # Sáng/Trưa/Tối/Snack chip
│
└── features/                         # Feature-first modular structure
    ├── auth/                         # Authentication feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_remote_datasource.dart
    │   │   │   └── auth_local_datasource.dart
    │   │   ├── models/
    │   │   │   ├── user_model.dart
    │   │   │   ├── login_request_model.dart
    │   │   │   └── register_request_model.dart
    │   │   ├── mappers/
    │   │   │   └── auth_mapper.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_entity.dart
    │   │   ├── value_objects/
    │   │   │   └── auth_email.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── login_usecase.dart
    │   │       └── register_usecase.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   ├── login_controller.dart
    │       │   ├── register_controller.dart
    │       │   └── auth_session_controller.dart
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   ├── register_page.dart
    │       │   ├── forgot_password_page.dart
    │       │   └── splash_page.dart
    │       └── widgets/
    │           ├── auth_text_field.dart
    │           ├── auth_password_field.dart
    │           ├── auth_submit_button.dart
    │           ├── auth_error_banner.dart
    │           └── social_login_buttons.dart
    │
    ├── scanner/                      # AI Food Scanner feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── gemini_remote_datasource.dart # Firebase AI Logic calls
    │   │   ├── models/
    │   │   │   └── scan_result_dto.dart          # Gemini JSON → DTO
    │   │   ├── mappers/
    │   │   │   └── scan_result_mapper.dart
    │   │   └── repositories/
    │   │       └── food_scan_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── scan_result.dart
    │   │   ├── repositories/
    │   │   │   └── food_scan_repository.dart
    │   │   └── usecases/
    │   │       └── scan_food_usecase.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   └── scanner_controller.dart
    │       ├── pages/
    │       │   ├── camera_page.dart
    │       │   └── scan_review_page.dart
    │       └── widgets/
    │           └── food_item_editor.dart
    │
    ├── tracker/                      # Daily Food Log feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── food_log_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── food_log_dto.dart
    │   │   ├── mappers/
    │   │   │   └── food_log_mapper.dart
    │   │   └── repositories/
    │   │       └── food_log_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── food_log.dart
    │   │   ├── repositories/
    │   │   │   └── food_log_repository.dart
    │   │   └── usecases/
    │   │       ├── add_food_log_usecase.dart
    │   │       └── get_daily_summary_usecase.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   └── tracker_controller.dart
    │       ├── pages/
    │       │   ├── home_page.dart
    │       │   ├── meal_detail_page.dart
    │       │   └── manual_entry_page.dart
    │       └── widgets/
    │           ├── daily_summary_card.dart
    │           ├── meal_section.dart
    │           └── food_search_bar.dart
    │
    ├── analytics/                    # Charts & Trends feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── analytics_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── analytics_dto.dart
    │   │   └── repositories/
    │   │       └── analytics_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── calorie_trend.dart
    │   │   ├── repositories/
    │   │   │   └── analytics_repository.dart
    │   │   └── usecases/
    │   │       └── get_weekly_analytics_usecase.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   └── analytics_controller.dart
    │       ├── pages/
    │       │   └── analytics_page.dart
    │       └── widgets/
    │           ├── calorie_trend_chart.dart
    │           └── weight_trend_chart.dart
    │
    └── profile/                      # User Profile feature
        ├── data/
        │   ├── datasources/
        │   │   └── profile_remote_datasource.dart
        │   ├── models/
        │   │   └── user_profile_dto.dart
        │   └── repositories/
        │       └── profile_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── user_profile.dart
        │   ├── repositories/
        │   │   └── profile_repository.dart
        │   └── usecases/
        │       └── calculate_bmr_tdee_usecase.dart
        └── presentation/
            ├── controllers/
            │   └── profile_controller.dart
            ├── pages/
            │   └── profile_page.dart
            └── widgets/
                └── bmr_tdee_card.dart
```

---

## 3. Firestore Data Model

### 3.1 Collection: `users/{uid}`

Stores user profile and physical metrics for BMR/TDEE calculation.

```
users/{uid}
├── gender: string            // "male" | "female"
├── birthYear: number         // e.g., 1995
├── heightCm: number          // e.g., 170
├── weightKg: number          // e.g., 65.5
├── activityLevel: string     // "sedentary" | "light" | "moderate" | "active"
├── dailyTargetCalories: number // e.g., 2000
├── createdAt: timestamp
└── updatedAt: timestamp
```

### 3.2 Subcollection: `users/{uid}/foodLogs/{logId}`

Each document represents a single food item logged.

```
users/{uid}/foodLogs/{logId}
├── loggedAt: timestamp
├── date: string              // "2026-07-27" (for querying by day)
├── mealType: string          // "breakfast" | "lunch" | "dinner" | "snack"
├── dishName: string          // "Cơm tấm sườn"
├── estimatedWeightG: number  // 200
├── calories: number          // 260
├── proteinG: number          // 15
├── carbsG: number            // 45
├── fatG: number              // 5
├── confidenceScore: number   // 0.92 (only for AI scans)
├── source: string            // "ai_scan" | "manual"
└── imageUrl: string?         // Firebase Storage URL (nullable)
```

### 3.3 Subcollection: `users/{uid}/aiUsage/{date}`

Tracks daily AI scan count for rate limiting.

```
users/{uid}/aiUsage/{date}      // date format: "2026-07-27"
├── scanCount: number           // Increment on each scan
└── lastScannedAt: timestamp
```

### 3.4 Firestore Security Rules (Overview)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Users can only access their own food logs
      match /foodLogs/{logId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // Users can only access their own AI usage
      match /aiUsage/{date} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

---

## 4. UI/UX Design System (Celestial Dark UI × M3)

### 4.1 Design Philosophy

Premium Celestial Dark UI built on Material 3 structural scaffolding. The interface transforms calorie logging into a calm, focused ritual through atmospheric depth, glassmorphism, and semantic color mapping.

**Core Pillars:**
- **Atmospheric Depth**: Deep midnight blue (#0A192F) mimics the night sky
- **Information Hierarchy via Glow**: Neon accents for nutrients and progress
- **Glassmorphism over Elevation**: Backdrop blur replaces shadows
- **4pt Grid Ergonomics**: Strict spacing with 44pt minimum touch targets

### 4.2 M3 ColorScheme Mapping

| Flutter M3 Token | Hex | Celestial UI Context |
|:-----------------|:----|:---------------------|
| `brightness` | `Brightness.dark` | System-wide Dark Mode |
| `surface` | `#0A192F` | App scaffold background (midnight sky) |
| `surfaceContainer` | `#112240` | Meal cards, search containers |
| `primary` | `#1A73E8` | **Carbs indicator**, active tabs, Camera FAB |
| `secondary` | `#FF69B4` | **Fat indicator**, weight trend curves |
| `tertiary` | `#FFD700` | **Protein indicator**, calorie overflow warning |
| `onSurface` | `#FFFFFF` | Primary text, headers, large calorie numbers |
| `onSurfaceVariant` | `#8892B0` | Secondary text, descriptions, gram values |
| `outline` | `#495670` | Separators, card borders, graph grid ticks |

**Critical Rule:** `surfaceTintColor: Colors.transparent` must be set in CardTheme and AppBarTheme to prevent M3's default purple tinting.

### 4.3 Typography System

| M3 TextTheme | Size | Weight | Color | Usage |
|:-------------|:-----|:-------|:------|:------|
| `headlineMedium` | 20pt | Bold (700) | `onSurface` | Screen titles ("Tổng quan hôm nay") |
| `titleMedium` | 14pt | Medium (500) | `onSurface` | Section headers ("Bữa sáng") |
| `bodyMedium` | 14pt | Regular (400) | `onSurfaceVariant` | Food names, descriptions |
| Custom: Calorie | 18pt+ | Bold (700) | Dynamic | Large calorie numbers, `letterSpacing: +0.5` |
| `labelMedium` | 12pt | Medium (500) | `outline` | Timestamps, gram counters |

**Font:** Inter (Google Fonts) or system font (SF Pro / Roboto).

### 4.4 Layout & 4pt Grid System

All spacing must be multiples of 4: `4, 8, 12, 16, 24, 32, 44, 48`

- **App edge margins:** 16pt horizontal padding
- **Card internal padding:** 16pt uniform
- **Element gutters:** 12pt or 16pt vertical
- **Touch targets:** Minimum 44pt × 44pt on all interactive elements

### 4.5 Component Specifications

#### M3 Card (Meal Cards)
- Elevation: 0
- Background: `surfaceContainer` (#112240)
- `surfaceTintColor`: `Colors.transparent`
- Border radius: 12px
- Optional: `BackdropFilter.blur(20)` for overlay sheets

#### Camera FAB
- Shape: Circular, 60×60px
- Background: `primary` (#1A73E8)
- Outer glow: Soft shadow using primary hue
- Touch target: ≥ 44pt

#### M3 SearchBar
- Background: `surfaceContainer`
- Elevation: 0
- Border: 1px `outline`
- Text: `onSurfaceVariant`

#### Calorie Progress Arc
- Smooth Bézier radial track
- Normal state: `primary` (#1A73E8, Carbs blue)
- Over-budget warning: Transitions to `tertiary` (#FFD700, Gold warning)

#### Macro Nutrient Bars
- Protein: `tertiary` (#FFD700)
- Carbs: `primary` (#1A73E8)
- Fat: `secondary` (#FF69B4)

### 4.6 Implementation Directives

1. **Never hardcode hex values.** Always use `Theme.of(context).colorScheme.*`
2. **Eliminate surface tinting.** Set `surfaceTintColor: Colors.transparent` globally
3. **Strict grid checks.** Reject odd-numbered padding/margins (e.g., 13, 45)
4. **Accent color semantics are immutable:**
   - Gold = Protein OR Calorie Overflow Warning
   - Blue = Carbs OR Primary Active Flow
   - Pink = Fat OR Long-term Analytics

---

## 5. Feature Specifications

### 5.1 🔐 Authentication (Firebase Auth)

**Screens:** Login, Register
**Methods:** Email/Password (MVP), expandable to Google Sign-In later
**Flow:**
1. App launches → Check auth state via `FirebaseAuth.instance.authStateChanges()`
2. Not authenticated → Show Login screen
3. Authenticated → Navigate to Home Dashboard
4. Register → Create account → Auto-login → Navigate to Profile setup

### 5.2 📷 AI Food Scanner (Core Feature)

**Flow:**
1. User taps Camera FAB (center of bottom navigation)
2. Camera opens (or image picker for gallery)
3. User captures/selects photo
4. Check AI usage: Query `aiUsage/{today}` → if `scanCount >= 10`, block with snackbar
5. Send image to Gemini via Firebase AI Logic SDK
6. Show skeleton loader with dynamic nutrition tips during processing
7. Parse Gemini JSON response with defensive try-catch
8. Display editable review form (dish names, weights, calories)
9. User confirms → Save each food item to `foodLogs` subcollection
10. Increment `aiUsage/{today}.scanCount`

**Gemini System Prompt:**
```text
You are an expert nutritionist and computer vision AI specialized in Vietnamese 
cuisine and global food mapping.
Analyze the attached image and extract all identifiable food items, their 
estimated weights, and calculated nutritional profiles.

You MUST return a valid, minified JSON object matching the schema below. 
Do NOT wrap the JSON in markdown code blocks, do NOT include any 
introductory or concluding text.

Schema:
{
  "is_food": boolean,
  "total_calories": integer,
  "macros": {
    "protein_g": integer,
    "carbs_g": integer,
    "fat_g": integer
  },
  "dishes": [
    {
      "dish_name": "string",
      "confidence_score": float,
      "estimated_weight_g": integer,
      "calories": integer
    }
  ]
}

Contextual Rules:
1. Prioritize Vietnamese traditional food profiles and default ingredients.
2. If multiple items exist on one plate, segment them into the "dishes" array.
```

**Expected Response (Mock):**
```json
{
  "is_food": true,
  "total_calories": 595,
  "macros": { "protein_g": 34, "carbs_g": 75, "fat_g": 17 },
  "dishes": [
    { "dish_name": "Cơm trắng", "confidence_score": 0.96, "estimated_weight_g": 200, "calories": 260 },
    { "dish_name": "Sườn heo nướng", "confidence_score": 0.92, "estimated_weight_g": 120, "calories": 290 },
    { "dish_name": "Trứng ốp la", "confidence_score": 0.98, "estimated_weight_g": 50, "calories": 45 }
  ]
}
```

### 5.3 ✍️ Manual Food Entry

**Flow:**
1. User navigates to manual entry from meal section
2. Search bar with autocomplete (local dataset of common Vietnamese foods)
3. User selects food → adjust weight via slider → auto-compute macros
4. Save to `foodLogs` with `source: "manual"`

### 5.4 📊 Daily Calorie Dashboard (Home Screen)

**Layout:**
- **Top:** Calorie Progress Arc (circular, showing remaining vs consumed)
- **Below arc:** Macro breakdown bars (Protein/Carbs/Fat with color coding)
- **Middle:** Meal sections (Bữa sáng / Bữa trưa / Bữa tối / Snack)
- **Each meal card:** List of food items with calories, tap to expand
- **Bottom navigation:** Home | Analytics | 📷 Camera FAB | Manual | Profile

### 5.5 📅 Meal Log

**Meal Types:** Breakfast (Bữa sáng), Lunch (Bữa trưa), Dinner (Bữa tối), Snack
**Per meal card:**
- Total calories for that meal
- List of food items (dish name, weight, calories)
- Tap item to edit or delete
- "Add food" button per meal section

### 5.6 👤 User Profile

**Data collected:** Gender, birth year, height, weight, activity level
**Computed:** BMR (Mifflin-St Jeor), TDEE, recommended daily calories
**Formulas:**
- Male BMR = 10 × weight(kg) + 6.25 × height(cm) - 5 × age + 5
- Female BMR = 10 × weight(kg) + 6.25 × height(cm) - 5 × age - 161
- TDEE = BMR × Activity Multiplier (1.2 / 1.375 / 1.55 / 1.725)

### 5.7 📈 Analytics & Charts

**Charts:**
- Daily calorie intake over past 7/30 days (Bézier line chart)
- Weight trend over time (if user logs weight)
- Macro distribution pie/donut chart

**Styling:** Smooth Bézier curves, grid ticks using `outline` color, data points using accent colors.

### 5.8 ⚠️ Rate Limiting (10 AI Scans/Day)

**Implementation:**
1. Before each scan: Read `aiUsage/{today}` document
2. If document doesn't exist → proceed (first scan of the day)
3. If `scanCount < 10` → proceed, then increment
4. If `scanCount >= 10` → block:
   - Grey out Camera FAB
   - Show snackbar: "Bạn đã dùng hết lượt quét AI hôm nay. Vui lòng sử dụng tính năng Nhập tay."

---

## 6. Error Handling Matrix

| Scenario | Expected Behavior |
|:---------|:-----------------|
| Gemini returns valid JSON with `is_food: true` | Transition to editable review form |
| Gemini returns `is_food: false` | Alert: "Không nhận diện được món ăn. Vui lòng chụp lại rõ nét hơn hoặc nhập tay." |
| User hits 10 scans/day | Grey out FAB, snackbar directing to manual entry |
| Network timeout (>10s) | Dismiss loader, show retry toast, no crash |
| Gemini returns malformed JSON | Defensive try-catch, fallback alert, suggest retry or manual |
| Firebase Auth token expired | Auto-refresh via Firebase SDK |
| Firestore write fails | Retry with exponential backoff, show error toast |

---

## 7. Navigation Structure (Auto Route)

```
/                         → SplashScreen (auth check)
├── /login                → LoginScreen
├── /register             → RegisterScreen
├── /home                 → HomeScreen (Dashboard) ← Default after auth
│   ├── /home/meal/:type  → MealDetailScreen
│   └── /home/add         → ManualEntryScreen
├── /scan                 → CameraScreen
│   └── /scan/review      → ScanReviewScreen
├── /analytics            → AnalyticsScreen
└── /profile              → ProfileScreen
    └── /profile/edit     → ProfileEditScreen
```

**Bottom Navigation Tabs:**
1. 🏠 Home (Dashboard)
2. 📈 Analytics
3. 📷 Camera FAB (center, elevated)
4. ✍️ Manual Entry
5. 👤 Profile

---

## 8. Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  firebase_storage: ^latest
  firebase_app_check: ^latest
  firebase_ai: ^latest          # Firebase AI Logic SDK

  # State Management
  flutter_riverpod: ^latest
  riverpod_annotation: ^latest

  # Navigation
  auto_route: ^latest

  # UI
  google_fonts: ^latest         # Inter font
  fl_chart: ^latest             # Charts (Bézier curves)

  # Camera & Image
  image_picker: ^latest
  image_cropper: ^latest        # Optional crop before scan

  # Utilities
  intl: ^latest                 # Date formatting
  cached_network_image: ^latest # Cache food images
  freezed_annotation: ^latest   # Immutable models

dev_dependencies:
  build_runner: ^latest
  auto_route_generator: ^latest
  riverpod_generator: ^latest
  freezed: ^latest
  json_serializable: ^latest
```

---

## 9. QA Test Cases

### TC-01: Successful Image Scan & Log
- **Pre:** User logged in, network active, scans < 10
- **Steps:** Tap Camera FAB → Capture photo → Confirm
- **Expected:** Skeleton loader → Review form with parsed data → Save → Increment tracker

### TC-02: Daily Quota Enforcement
- **Pre:** User has 10 scans today
- **Steps:** Tap Camera FAB
- **Expected:** FAB greyed out, snackbar: "Bạn đã dùng hết lượt quét AI hôm nay."

### TC-03: Non-Food Image
- **Steps:** Upload photo of keyboard/book
- **Expected:** `is_food: false` → Alert dialog → Suggest retry or manual entry

### TC-04: Network Timeout
- **Steps:** Trigger scan → Cut network
- **Expected:** No freeze/crash → Dismiss loader → Retry toast

### TC-05: Manual Food Entry
- **Steps:** Navigate to manual entry → Search "Phở bò" → Adjust weight → Save
- **Expected:** Food logged with `source: "manual"`, dashboard updates

### TC-06: BMR/TDEE Calculation
- **Steps:** Enter profile data (male, 1995, 170cm, 65kg, moderate)
- **Expected:** Correct BMR and TDEE displayed, daily target auto-set

---

## 10. Out of Scope (Future Versions)

- Social OAuth (Google/Apple Sign-In)
- Barcode scanning
- Meal planning & recipe suggestions
- Water intake tracking
- Community/social features
- Push notifications & reminders
- Premium subscription tier
- Multi-language support (English)
- Wearable device integration
