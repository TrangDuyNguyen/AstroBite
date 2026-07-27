# AstroBite — Design System

**Version:** 1.0  
**Theme:** Celestial Dark UI × Flutter Material 3  
**Last Updated:** 2026-07-27

---

## 1. Design Philosophy

AstroBite's interface transforms calorie tracking into a calm, focused ritual through a **Celestial Dark UI** built on Material 3 structural scaffolding. Every visual decision optimizes for readability under low-light conditions and one-handed mobile use.

### Core Pillars

| Pillar | Description |
|:-------|:------------|
| **Atmospheric Depth** | Deep midnight blue backgrounds (`#0A192F`) mimic the night sky, creating visual calm and reducing eye strain |
| **Information Hierarchy via Glow** | High-vibrancy accent colors (Gold, Pink, Electric Blue) are reserved exclusively for nutrient indicators, active states, and warnings |
| **Glassmorphism over Elevation** | Backdrop blur and translucent surfaces replace traditional Material elevation shadows to create layered depth |
| **4pt Grid Ergonomics** | Strict spacing grid with 44pt minimum touch targets ensuring accessibility in all lighting conditions |

---

## 2. Color Palette

### 2.1 M3 ColorScheme Mapping

> [!IMPORTANT]
> Set `surfaceTintColor: Colors.transparent` in `CardTheme` and `AppBarTheme` to prevent Material 3's default purple surface tinting.

| Flutter M3 Token | Hex | RGB | Celestial UI Context |
|:-----------------|:----|:----|:---------------------|
| `brightness` | `Brightness.dark` | — | System-wide Dark Mode |
| `surface` | `#0A192F` | `rgb(10, 25, 47)` | App scaffold background (midnight sky) |
| `surfaceContainer` | `#112240` | `rgb(17, 34, 64)` | Meal cards, search containers, secondary surfaces |
| `primary` | `#1A73E8` | `rgb(26, 115, 232)` | **Carbs indicator**, active tabs, Camera FAB |
| `secondary` | `#FF69B4` | `rgb(255, 105, 180)` | **Fat indicator**, weight trend curves, analytics accent |
| `tertiary` | `#FFD700` | `rgb(255, 215, 0)` | **Protein indicator**, calorie overflow warning |
| `onSurface` | `#FFFFFF` | `rgb(255, 255, 255)` | Primary text, headers, large calorie numbers |
| `onSurfaceVariant` | `#8892B0` | `rgb(136, 146, 176)` | Secondary text, descriptions, gram values |
| `outline` | `#495670` | `rgb(73, 86, 112)` | Separators, card borders, graph grid ticks, disabled states |

### 2.2 Overlay & Blur Surfaces

| Token | Value | Usage |
|:------|:------|:------|
| `surface-blur` | `rgba(25, 42, 70, 0.6)` | Glassmorphic dropdowns, bottom sheets, overlays requiring `BackdropFilter.blur(20)` |

### 2.3 Semantic Color Rules

> [!CAUTION]
> Accent color semantics are **immutable** across the entire app. Do not repurpose them.

| Color | Primary Semantic | Secondary Semantic |
|:------|:-----------------|:-------------------|
| 🟡 Gold (`#FFD700`) | Protein nutrient indicator | Calorie overflow / budget warning |
| 🔵 Blue (`#1A73E8`) | Carbs nutrient indicator | Primary interactive state (tabs, FAB, progress) |
| 🩷 Pink (`#FF69B4`) | Fat nutrient indicator | Long-term analytics & trend curves |

---

## 3. Typography System

**Font Family:** Inter (via `google_fonts` package) — fallback: system font (SF Pro / Roboto)

### 3.1 Type Scale

| M3 TextTheme | Size | Weight | Letter Spacing | Color Token | Usage |
|:-------------|:-----|:-------|:---------------|:------------|:------|
| `headlineMedium` | 20pt | Bold (700) | Default | `onSurface` | Screen titles ("Tổng quan hôm nay") |
| `titleMedium` | 14pt | Medium (500) | Default | `onSurface` | Section headers ("Bữa sáng"), active tab labels |
| `bodyMedium` | 14pt | Regular (400) | Default | `onSurfaceVariant` | Food names, descriptions, body copy |
| `bodyLarge` | 18pt | Regular (400) | Default | `onSurfaceVariant` | Large reading variant for prominent descriptions |
| Custom: Calorie | 18pt+ | Bold (700) | `+0.5px` | Dynamic¹ | Large calorie numbers, primary metric values |
| `labelMedium` | 12pt | Medium (500) | Default | `outline` | Timestamps, gram counters, micro-copy |

> ¹ Dynamic color: White for normal state, Gold for protein or overflow, Pink for fat, Blue for carbs.

### 3.2 Typography Rules

- **Line heights:** H1 = 1.25, H2 = 1.3, Body = 1.4
- **Case transforms:** Labels use Sentence Case by default; uppercase only for special badge text
- **Number formatting:** Calorie values always use `letterSpacing: +0.5` for enhanced readability

---

## 4. Layout & Spacing

### 4.1 The 4pt Grid System

All spacing, padding, margin, and dimension values **must** be multiples of 4.

**Approved spacing tokens:** `4, 8, 12, 16, 24, 32, 44, 48`

> [!WARNING]
> Reject any padding or margin that is not a multiple of 4. Scale to the nearest approved token (e.g., `13pt → 12pt`, `45pt → 44pt`).

### 4.2 Global Layout Tokens

| Token | Value | Usage |
|:------|:------|:------|
| `edge-margin` | `16pt` | Horizontal padding on left/right screen edges |
| `card-padding` | `16pt` | Internal padding for all card components |
| `element-gutter` | `12pt` or `16pt` | Vertical gap between component containers |
| `touch-target-min` | `44pt × 44pt` | Minimum interactive element bounding box |

---

## 5. Component Specifications

### 5.1 M3 Card (Meal Cards)

| Property | Value |
|:---------|:------|
| Elevation | `0` |
| Background | `surfaceContainer` (`#112240`) |
| `surfaceTintColor` | `Colors.transparent` |
| Border radius | `12px` |
| Internal padding | `16pt` |
| Separation method | Soft drop shadows or background differentiation — **no hard borders** |

### 5.2 Camera FAB

| Property | Value |
|:---------|:------|
| Shape | Circular |
| Size | `60 × 60px` |
| Background | `primary` (`#1A73E8`) |
| Outer glow | Soft shadow using primary hue at ~30% opacity |
| Touch target | ≥ `44pt` bounding box |
| Disabled state | Greyed out when daily AI quota reached |

### 5.3 Search Bar

| Property | Value |
|:---------|:------|
| Background | `surfaceContainer` (`#112240`) |
| Elevation | `0` |
| Border | `1px` using `outline` color |
| Text color | `onSurfaceVariant` |
| Font | System, `11pt`, Bold |
| Internal padding | `12pt` |
| Trailing icon | Magnifying glass, aligned right |

### 5.4 Calorie Progress Arc

| Property | Value |
|:---------|:------|
| Style | Smooth Bézier radial track (circular progress) |
| Normal state | `primary` (`#1A73E8`) |
| Over-budget | Transitions to `tertiary` (`#FFD700`) with subtle glow |
| Tracking node | Active thumb/node on curve |

### 5.5 Macro Nutrient Bars

| Macro | Color Token | Hex |
|:------|:------------|:----|
| Protein | `tertiary` | `#FFD700` |
| Carbs | `primary` | `#1A73E8` |
| Fat | `secondary` | `#FF69B4` |

### 5.6 Segmented Controls & Toggles

| Property | Value |
|:---------|:------|
| Shape | Capsule-shaped containers |
| Touch target | ≥ `44pt` bounding box |
| Active indicator | Filled capsule using `tertiary` (`#FFD700`) or high-contrast badge |
| Inactive state | `outline` color text, transparent background |

### 5.7 Glassmorphic Overlays (Bottom Sheets / Dropdowns)

| Property | Value |
|:---------|:------|
| Background | `surface-blur` (`rgba(25, 42, 70, 0.6)`) |
| Backdrop filter | `BackdropFilter.blur(20)` |
| Border | `1px rgba(255, 255, 255, 0.08)` — subtle light border |
| Text readability | Must maintain WCAG AA contrast against blurred background |

### 5.8 Data Visualization (Charts)

| Property | Value |
|:---------|:------|
| Line style | Smooth Bézier curves |
| Grid ticks | Small vertical hash lines using `outline` color |
| Data points | Accent colors matching semantic rules (§2.3) |
| Chart background | Transparent over `surface` |

### 5.9 Meal Type Chips

| Chip | Label |
|:-----|:------|
| Breakfast | Bữa sáng |
| Lunch | Bữa trưa |
| Dinner | Bữa tối |
| Snack | Snack |

- Active: Filled with `primary`, text `onSurface`
- Inactive: Outlined with `outline`, text `onSurfaceVariant`

---

## 6. Skeleton Loader & Loading States

| Property | Value |
|:---------|:------|
| Style | Shimmer animation over `surfaceContainer` shapes |
| Duration | 1.5s repeat cycle |
| Shape | Mimics target content layout (card, text lines, arc) |
| Enhancement | Display rotating nutrition tips during AI scan processing |

---

## 7. Implementation Directives

### 7.1 Color Usage

1. **Never hardcode hex values.** Always reference via `Theme.of(context).colorScheme.*`
2. **Eliminate surface tinting.** Set `surfaceTintColor: Colors.transparent` globally in theme data
3. **Respect semantic mapping.** Gold = Protein / Warning, Blue = Carbs / Active, Pink = Fat / Analytics

### 7.2 Spacing & Grid

4. **Strict 4pt grid.** If a spacing value is not in the approved token list, reject and snap to the nearest valid token
5. **44pt touch targets.** All interactive elements must have a minimum bounding box of `44pt × 44pt`

### 7.3 Surfaces & Depth

6. **Glassmorphism over elevation.** Use `BackdropFilter.blur(20)` for floating surfaces instead of Material elevation shadows
7. **Layer contrast.** Bottom sheets and overlays must use the `surface-blur` token to keep text readable against underlying content

### 7.4 Typography

8. **Use `google_fonts` package** for Inter font family
9. **Calorie number formatting.** Always apply `letterSpacing: +0.5` to numerical data values
10. **No intermediate sizes.** Typography sizes must match the defined type scale exactly

---

## 8. Dark Mode Reference Palette (Quick Reference)

```
Background:       ████  #0A192F  (Midnight Sky)
Card Surface:     ████  #112240  (Deep Navy)
Overlay:          ████  rgba(25, 42, 70, 0.6)

Primary/Carbs:    ████  #1A73E8  (Electric Blue)
Secondary/Fat:    ████  #FF69B4  (Hot Pink)
Tertiary/Protein: ████  #FFD700  (Gold)

Text Primary:     ████  #FFFFFF  (White)
Text Secondary:   ████  #8892B0  (Slate)
Text Muted:       ████  #495670  (Dark Slate)
```
