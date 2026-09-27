# AstroBite — Design System

**Version:** 3.0
**Theme:** Puffy 3D Claymorphism × Duolingo Chunky
**Inspiration:** [Claymorphism Kids Learning App — Hitesh Tapaniya (Dribbble)](https://dribbble.com/shots/27571529-Claymorphism-Kids-Learning-Mobile-App-UI-UX-Design) · [Morphicons Spring Icons](https://www.morphicons.com/)
**Last Updated:** 2026-09-27

---

## 1. Design Philosophy

AstroBite transforms nutrition tracking into a **tactile, toy-like experience** where every card, button, and indicator feels like molded soft modelling clay. The aesthetic fuses the playful depth of **Duolingo 3D cartoon UI** with the inflated, squishy surfaces of **Claymorphism** — chunky bottom bevels, glossy top highlights, spring-physics icon morphs, and elastic squash on every tap.

### Core Pillars

| Pillar | Description |
|:-------|:------------|
| **Puffy Tactile 3D** | Every surface sits on a solid-color bottom bevel (`3.5–4.5pt`), giving the illusion of a physical toy button that presses down when tapped |
| **Warm Appetizing Canvas** | Warm Milk Cream (`#FAF8F5`) replaces cold white, making food photos pop and reducing eye strain |
| **Glossy Top Highlight** | Key elements (FAB, macro bars, badges) get a subtle white gradient reflection on top to sell the inflated 3D illusion |
| **Spring-Physics Motion** | Icons morph via `ClayMorphIcon` with elastic scale, rotation flip, and fade — inspired by [Morphicons](https://www.morphicons.com/) |
| **Vibrant Nutrient Semantics** | Immutable color → nutrient mapping: Sky Blue = Carbs, Pink = Fat, Tangerine = Protein, Lime = Vitality |

---

## 2. Color Palette

### 2.1 M3 ColorScheme Mapping

> [!IMPORTANT]
> Set `surfaceTintColor: Colors.transparent` in `CardTheme` and `AppBarTheme` to prevent Material 3's default purple surface tinting.

| Flutter M3 Token | Hex | Name | Claymorphic Context |
|:-----------------|:----|:-----|:--------------------|
| `brightness` | `Brightness.light` | — | System-wide Light Mode |
| `surface` | `#FAF8F5` | Warm Milk Cream | Scaffold canvas background |
| `surfaceContainer` | `#FFFFFF` | Pure White Clay | Card/sheet/dialog surfaces |
| `shimmerBase` | `#F0EFEB` | Warm Shimmer | Skeleton loader base |
| `primary` | `#1CB0F6` | Duolingo Sky Blue | **Carbs indicator**, active tabs, primary CTAs, FAB |
| `secondary` | `#FF5C8D` | Strawberry Cream Pink | **Fat indicator**, analytics trend lines |
| `tertiary` | `#FF9600` | Honey Tangerine Orange | **Protein indicator**, calorie overflow warning |
| `brandGreen` | `#58CC02` | Duolingo Lime Green | Streak, goal milestones, success states |
| `onSurface` | `#1E2337` | Deep Slate Berry | Primary text (WCAG AAA > 13:1 on canvas) |
| `onSurfaceVariant` | `#78829A` | Cool Slate | Secondary text & descriptions (WCAG AA > 4.8:1) |
| `outline` | `#E8E5DF` | Soft Clay Edge | Card borders, subtle dividers |
| `error` | `#EA2B2B` | Crisp Red | Error states, destructive actions |

### 2.2 Clay 3D Depth Colors

| Token | Hex | Purpose |
|:------|:----|:--------|
| Default Bevel | `#DDD8CE` | Solid bottom bevel for white surfaces |
| Card Border | `#EDE9E1` | Subtle warm clay edge around cards |
| Primary Bevel | `#1488C2` | Darker blue solid bevel under Sky Blue surfaces (FAB, primary buttons) |
| Ambient Shadow | `#181E2337` (9.4% alpha) | Soft floating drop shadow beneath all elevated elements |
| Glossy Highlight | `#73FFFFFF` (45% alpha → transparent) | Top-edge white gradient for inflated 3D sheen |

### 2.3 Clay Pastel Tints (Chips & Badges)

| Token | Hex | Element |
|:------|:----|:--------|
| `clayBreakfast` | `#FFF2D6` | Honey pastel — Breakfast chip |
| `clayLunch` | `#E5F6FD` | Sky pastel — Lunch chip |
| `clayDinner` | `#F0E8FF` | Taro purple pastel — Dinner chip |
| `claySnack` | `#FFE8EE` | Strawberry milk pastel — Snack chip |
| `clayMint` | `#E8F9D8` | Cucumber mint — Hydration & veggie badges |

### 2.4 Semantic Color Rules

> [!CAUTION]
> Nutrient color semantics are **immutable** across the entire app. Do not repurpose or invert them.

| Color | Primary Semantic | Secondary Semantic |
|:------|:-----------------|:-------------------| 
| 🧡 Tangerine (`#FF9600`) | Protein nutrient indicator | Calorie overflow / budget warning |
| 🩵 Sky Blue (`#1CB0F6`) | Carbs nutrient indicator | Primary interactive state (tabs, FAB, progress) |
| 🍓 Pink (`#FF5C8D`) | Fat nutrient indicator | Long-term analytics & trend curves |
| 🥑 Lime (`#58CC02`) | Streak / Goal completion | Positive nutritional feedback |

---

## 3. 3D Shadow Anatomy (The Puffy Clay Recipe)

Every elevated surface in AstroBite uses a **2-layer shadow stack** to create the signature puffy 3D clay effect:

```
┌─────────────────────────────────────┐
│  ╭─ Glossy top highlight (optional) │  ← White gradient 45%→0% alpha
│  │                                  │
│  │     Component Surface            │  ← backgroundColor (white or tinted)
│  │                                  │
│  ╰──────────────────────────────────│
├═════════════════════════════════════╡  ← border (1.2px, #EDE9E1)
│▓▓▓▓▓ LAYER 1: Solid Bottom Bevel ▓▓│  ← Offset(0, 3.5), blur: 0, color: #DDD8CE
└─────────────────────────────────────┘
     ░░░ LAYER 2: Ambient Float ░░░     ← Offset(0, 7.5), blur: 14, color: 9% #1E2337
```

### Shadow Specs by Component

| Component | Bevel Offset | Bevel Color | Ambient Blur | Ambient Offset |
|:----------|:-------------|:------------|:-------------|:---------------|
| `ClayCard` | `0, 3.5` | `#DDD8CE` (or lerp from bg) | 14 | `0, 7.5` |
| `ClayButton` | `0, 3.5` | darker variant of fill | 8 | `0, 5.5` |
| `ClayIconButton` | `0, 2.5` | `#DDD8CE` or `#1488C2` (primary) | 8 | `0, 4.5` |
| `ClayBottomNav` dock | `0, 4.5` | `#DDD8CE` | 18 | `0, 8` |
| Camera FAB | `0, 4.5` | `#1488C2` | 14 | `0, 7` |
| `CalorieProgressArc` dial | `0, 2.5` | `#DDD8CE` | 8 | `0, 4` |
| `ChunkyMacroBar` track | `0, 2` | lerp(color, black, 0.22) | 0 | — |

### Bevel Color Derivation Rules

```dart
// White / default surface → fixed warm clay bevel
Color bevel = const Color(0xFFDDD8CE);

// Tinted surface (pastel badge, colored card) → darken 14%
Color bevel = Color.lerp(backgroundColor, Colors.black, 0.14);

// Primary blue surface → fixed deep blue bevel  
Color bevel = const Color(0xFF1488C2);
```

---

## 4. Typography System

**Font Family:** Inter (via `google_fonts` package) — fallback: system font (SF Pro / Roboto)

### 4.1 Type Scale

| M3 TextTheme | Size | Weight | Color Token | Usage |
|:-------------|:-----|:-------|:------------|:------|
| `headlineMedium` | 20pt | Bold (700) | `onSurface` | Screen titles ("Tổng quan hôm nay") |
| `titleMedium` | 14pt | SemiBold (600) | `onSurface` | Section headers ("Bữa sáng"), active tab labels |
| `bodyMedium` | 14pt | Regular (400) | `onSurfaceVariant` | Food names, descriptions, body copy |
| `labelMedium` | 12pt | Medium (500) / Bold (700) | `onSurfaceVariant` | Timestamps, gram counters, micro-copy |
| Custom: Calorie | 18pt+ | ExtraBold (800) | Dynamic | Large calorie numbers (`letterSpacing: +0.5`) |

---

## 5. Interaction States & Animation

### 5.1 Tactile Squash Feedback

All tappable clay elements follow a consistent press → release cycle:

| State | Scale | Bevel Offset | Ambient Blur | Shadow Offset | Duration |
|:------|:------|:-------------|:-------------|:--------------|:---------|
| **Default** | `1.0` | Full (3.5pt) | Full (14) | Full | — |
| **Pressed** | `0.98` (card) / `0.95` (button) | Reduced (1.0pt) | Reduced (3–4) | Reduced | 100–120ms |
| **Released** | `1.0` | Full | Full | Full | 120ms `easeOutCubic` |

### 5.2 ClayMorphIcon — Spring-Physics Icon Morphing

Inspired by [Morphicons](https://www.morphicons.com/), the `ClayMorphIcon` component transitions icons with spring-physics motion:

```
Old icon ──→ Scale 1.0 → 0.4 + Rotate 0° → -12° + Fade out
New icon ──→ Scale 0.4 → 1.0 + Rotate -12° → 0° + Fade in
```

| Property | Value |
|:---------|:------|
| Duration | `280ms` |
| Switch-in Curve | `Curves.easeOutBack` (spring overshoot) |
| Switch-out Curve | `Curves.easeInBack` |
| Scale Range | `0.4 → 1.0` |
| Rotation Range | `-0.12 turns → 0.0 turns` |
| Keying | `ValueKey<IconData>(icon)` |

> [!TIP]
> Use `ClayMorphIcon` everywhere instead of raw `Icon()` for consistency. It wraps `AnimatedSwitcher` internally — no extra code needed.

### 5.3 Progress Animations

| Component | Animation | Duration | Curve |
|:----------|:----------|:---------|:------|
| `ChunkyMacroBar` | `TweenAnimationBuilder` 0→progress | 500ms | `easeOutCubic` |
| `CalorieProgressArc` | `CustomPaint` sweepAngle | Immediate (stateless) | — |

---

## 6. Layout & Spacing

### 6.1 The 4pt Grid System

All spacing, padding, margin, and dimension values **must** be multiples of 4:

```
4  ·  8  ·  12  ·  16  ·  20  ·  24  ·  32  ·  44  ·  48
```

### 6.2 Global Radii

| Element | Radius | Example |
|:--------|:-------|:--------|
| Cards (`ClayCard`) | `20pt` | Fat rounded corners |
| Bottom Nav dock | `33pt` | Full capsule shape |
| Chips & Pills (`ClayMealChip`) | `24pt` | Capsule radius |
| Buttons (`ClayButton`) | `16pt` | Rounded rectangle |
| Icon Buttons (`ClayIconButton`) | `14pt` | Squircle |
| Macro Bars | `10pt` | Chunky track |
| Input Fields | `16pt` | Rounded rectangle |

### 6.3 Touch Target & Ergonomics

- **Minimum touch target**: `44pt × 44pt` bounding box for all interactive elements
- **Screen padding**: `16pt` horizontal margin
- **Card padding**: `16pt` internal padding
- **FAB size**: `54pt` diameter (Camera FAB in bottom nav)

---

## 7. UI Kit Architecture (`lib/shared/ui_kit/`)

All reusable components are consolidated in [`lib/shared/ui_kit/`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/) and exported through a single barrel:

```dart
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
```

### 7.1 Component Catalog

#### Surfaces

| Component | File | Description |
|:----------|:-----|:------------|
| [`ClayCard`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/surfaces/clay_card.dart) | `surfaces/clay_card.dart` | `#FFFFFF` pure white clay surface. Fat `20pt` radius, `1.2px` warm border (`#EDE9E1`), 2-layer 3D shadow (solid bevel + ambient float), `0.98` tactile squash on tap. Accepts `bevelColor` override for tinted surfaces. *(Legacy alias: `SolarCard`)* |
| [`ClaySheet`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/surfaces/clay_sheet.dart) | `surfaces/clay_sheet.dart` | Bottom sheet with fat `24pt` top radius, clay border, ambient shadow, and pull-bar handle. |

#### Buttons

| Component | File | Description |
|:----------|:-----|:------------|
| [`ClayButton`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/buttons/clay_button.dart) | `buttons/clay_button.dart` | Duolingo 3D tactile button with chunky `3.5pt` bottom bevel, `16pt` radius, squash feedback. Variants: `primary`, `success`, `warning`, `danger`, `outline`. Min touch target `≥44pt`. |
| [`ClayIconButton`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/buttons/clay_icon_button.dart) | `buttons/clay_icon_button.dart` | `44×44pt` squircle with `14pt` radius, 2-layer 3D shadow, `0.95` squash on press. Supports `primary` variant (Sky Blue bg + `#1488C2` bevel). Uses `ClayMorphIcon` internally for spring-physics icon rendering. |

#### Inputs

| Component | File | Description |
|:----------|:-----|:------------|
| [`ClayTextField`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/inputs/clay_text_field.dart) | `inputs/clay_text_field.dart` | `16pt` corners, white clay container, soft clay border `#E8E5DF`, Sky Blue focus glow `#1CB0F6`. |
| [`ClaySearchBar`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/inputs/clay_search_bar.dart) | `inputs/clay_search_bar.dart` | Search input, `16pt` corners, search icon prefix, clear suffix, soft clay shadow. |

#### Indicators & Gauges

| Component | File | Description |
|:----------|:-----|:------------|
| [`ChunkyMacroBar`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/indicators/chunky_macro_bar.dart) | `indicators/chunky_macro_bar.dart` | `14pt` height energy bar with `10pt` radius. 3D clay container: `12%` alpha tinted track + `1px` tinted border + solid darker bevel at bottom. Top `5pt` glossy white reflection strip. Animated via `TweenAnimationBuilder` (500ms `easeOutCubic`). *(Legacy alias: `MacroBar`)* |
| [`CalorieProgressArc`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/indicators/calorie_progress_arc.dart) | `indicators/calorie_progress_arc.dart` | Circular arc: Sky Blue `#1CB0F6` when under budget → Tangerine `#FF9600` when over. Track: `#EDE9E1`. Center: 3D clay coin dial (`72%` of arc size) with bevel + ambient shadow. Displays remaining kcal or "+X kcal" overage. |
| [`ClaySkeletonLoader`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/indicators/clay_skeleton_loader.dart) | `indicators/clay_skeleton_loader.dart` | Shimmer placeholder, Warm Shimmer base `#F0EFEB`, soft clay border. |
| [`ClayMorphIcon`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/indicators/clay_morph_icon.dart) | `indicators/clay_morph_icon.dart` | Spring-physics icon morph (Morphicons-inspired). `AnimatedSwitcher` with scale + rotation + fade. 280ms, `easeOutBack` / `easeInBack`. |

#### Chips

| Component | File | Description |
|:----------|:-----|:------------|
| [`ClayMealChip`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/chips/clay_meal_chip.dart) | `chips/clay_meal_chip.dart` | `24pt` capsule pastel pill. Breakfast `#FFF2D6`, Lunch `#E5F6FD`, Dinner `#F0E8FF`, Snack `#FFE8EE`. Active: `1.8pt` solid border + glow shadow. *(Legacy alias: `MealTypeChip`)* |

#### Navigation

| Component | File | Description |
|:----------|:-----|:------------|
| [`ClayBottomNav`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/navigation/clay_bottom_nav.dart) | `navigation/clay_bottom_nav.dart` | Floating clay dock (`33pt` capsule), `64pt` height, constrained `368pt` max width. `4.5pt` bevel + `blur 18` ambient float. Active tab = Sky Blue tinted pill (`#E5F6FD` bg, `#90D5F7` border, `#BCE3F7` 2pt bevel). Center `54pt` Camera FAB: Sky Blue `#1CB0F6` circle + `#1488C2` bevel + glossy highlight gradient + `35%` alpha blue glow. All nav icons use `ClayMorphIcon` for spring morph. *(Legacy alias: `CelestialBottomNav`)* |

---

## 8. Accessibility & Contrast

### 8.1 WCAG Compliance

| Pair | Ratio | Level |
|:-----|:------|:------|
| `onSurface` (#1E2337) on `surface` (#FAF8F5) | **> 13:1** | AAA |
| `onSurfaceVariant` (#78829A) on `surface` (#FAF8F5) | **> 4.8:1** | AA |
| White text on `primary` (#1CB0F6) | **> 4.5:1** | AA |
| White text on `brandGreen` (#58CC02) | **> 3.2:1** | AA Large Text |

### 8.2 Touch Target Rules

- All interactive elements: `≥ 44×44pt` bounding box
- Adequate spacing between adjacent tappable elements
- `Semantics` widget with `button: true` and descriptive `label` for screen readers
- Camera FAB includes `Semantics(label: 'Scan food')` for VoiceOver/TalkBack

### 8.3 Motion Accessibility

- All animations use `AnimatedContainer` / `AnimatedScale` with short durations (100–280ms)
- Future: respect `MediaQuery.disableAnimations` for reduced motion preference

---

## 9. Component State Matrix

Every UI component must handle these visual states:

| State | Visual Treatment |
|:------|:-----------------|
| **Default** | Full elevation, full bevel, base colors |
| **Pressed / Active** | Scale `0.95–0.98`, reduced bevel `1pt`, reduced ambient shadow |
| **Focused** | Sky Blue outline glow (`#1CB0F6`) for keyboard/switch access |
| **Disabled** | `40%` opacity, no shadow, no interaction |
| **Loading** | `ClaySkeletonLoader` shimmer in component shape |
| **Error** | `error` color (`#EA2B2B`) border or text, with error message |

---

## 10. Screen-Level 5-State Coverage

Every screen in the app must implement all 5 states:

| # | State | Description |
|:--|:------|:------------|
| 1 | **Default** | Happy-path data loaded, all components populated |
| 2 | **Loading (Shimmer)** | `ClaySkeletonLoader` placeholders matching component shapes |
| 3 | **Empty** | Friendly illustration + encouraging CTA when no data |
| 4 | **Error** | Red-bordered message card with retry action |
| 5 | **Offline** | Cached data shown with "Offline" indicator badge |

---

## 11. Quick Reference Palette

```
Background Canvas:   ████  #FAF8F5  (Warm Milk Cream)
Clay Card Surface:   ████  #FFFFFF  (Pure White Clay)
Shimmer Base:        ████  #F0EFEB  (Warm Soft Shimmer)
Card Border:         ████  #EDE9E1  (Warm Clay Edge)
Soft Clay Edge:      ████  #E8E5DF  (Outline / Divider)
Default Bevel:       ████  #DDD8CE  (Solid Clay Bevel)

Primary / Carbs:     ████  #1CB0F6  (Duolingo Sky Blue)
Primary Bevel:       ████  #1488C2  (Deep Blue Bevel)
Secondary / Fat:     ████  #FF5C8D  (Strawberry Cream Pink)
Tertiary / Protein:  ████  #FF9600  (Honey Tangerine Orange)
Brand / Vitality:    ████  #58CC02  (Duolingo Lime Green)

Text Primary:        ████  #1E2337  (Deep Slate Berry — WCAG AAA 13:1)
Text Secondary:      ████  #78829A  (Cool Slate — WCAG AA 4.8:1)
Error:               ████  #EA2B2B  (Crisp Red)
```

---

## 12. File Index

| File | Role |
|:-----|:-----|
| [`lib/core/theme/app_colors.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/core/theme/app_colors.dart) | All color tokens (`AppColors`) |
| [`lib/core/theme/app_theme.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/core/theme/app_theme.dart) | `ThemeData` builder with M3 ColorScheme |
| [`lib/core/constants/app_values.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/core/constants/app_values.dart) | Spacing grid, radii, business rule constants |
| [`lib/shared/ui_kit/ui_kit.dart`](file:///Users/nguyenduytrang/flutter_project/AstroBite/lib/shared/ui_kit/ui_kit.dart) | Master barrel export for entire UI Kit |
| [`DESIGN.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/DESIGN.md) | This document |
