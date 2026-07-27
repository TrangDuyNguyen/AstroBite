# DESIGN SYSTEM SPECIFICATION: LUMY APP
## Version 1.0 | Dark Mode Celestial UI

---

## 1. DESIGN PHILOSOPHY & ART DIRECTION
The **Lumy App** design system is built around a "Window to your outside world" theme, merging clean, modern functional minimalism with deep celestial/atmospheric aesthetics. The interface delivers highly critical astronomical and time-based information with a calm, high-contrast, yet eye-friendly dark aesthetic.

### Core Pillars
*   **Atmospheric Depth:** Utilizing deep dark indigo and blue gradients that mimic the night sky and twilight zones.
*   **Information Hierarchy via Glow & Accents:** High-vibrancy accent colors (Gold, Pink, Electric Blue) are reserved exclusively for critical actionable targets, dynamic states, or primary metric highlights.
*   **Glassmorphism & Layering:** Background surfaces leverage soft blurs, low-opacity borders, and subtle drop shadows rather than hard borders to create visual hierarchy and depth.
*   **Touch-First Ergonomics:** Strictly enforcing mobile spacing tokens and touch targets ensuring accessibility under low-light or outdoor viewing conditions.

---

## 2. COLOR PALETTE (TOKENS)

### 2.1 Base & Background Colors
| Token Name | Hex Value | RGB Value | Purpose / Usage |
| :--- | :--- | :--- | :--- |
| `color-bg-main` | `#0A192F` | `rgb(10, 25, 47)` | Master application background. Deep dark midnight blue. |
| `color-surface-card` | `#112240` | `rgb(17, 34, 64)` | Standard component card background with subtle transparency. |
| `color-surface-blur` | `rgba(25, 42, 70, 0.6)` | `rgba(25, 42, 70, 0.6)` | Glassmorphic dropdowns/overlays requiring a backdrop-filter blur. |

### 2.2 Accent & Interactive Colors
| Token Name | Hex Value | RGB Value | Purpose / Usage |
| :--- | :--- | :--- | :--- |
| `color-accent-blue` | `#1A73E8` | `rgb(26, 115, 232)` | Interactive icons, active states, main progress indicators. |
| `color-accent-gold` | `#FFD700` | `rgb(255, 215, 0)` | Critical warning states, primary selection elements, highlighted labels. |
| `color-accent-pink` | `#FF69B4` | `rgb(255, 105, 180)` | Secondary astronomical data tracking, twilight/sunset secondary indicators. |

### 2.3 Typography Colors
| Token Name | Hex Value | RGB Value | Purpose / Usage |
| :--- | :--- | :--- | :--- |
| `color-text-primary` | `#FFFFFF` | `rgb(255, 255, 255)` | Primary headers, data values, high-emphasis text. |
| `color-text-secondary`| `#8892B0` | `rgb(136, 146, 176)`| Subtitles, descriptive paragraphs, unselected options. |
| `color-text-muted` | `#495670` | `rgb(73, 86, 112)` | Placeholders, disabled states, inactive labels. |

---

## 3. TYPOGRAPHY SYSTEM
The typography system uses **San Francisco (SF Pro)** / System Fonts to ensure extreme crispness across high-density displays.

### Typography Hierarchy Tokens
*   **H1 (Primary Hero Header)**
    *   *Size:* 20pt
    *   *Weight:* Bold (700)
    *   *Line-Height:* 1.25
    *   *Color:* `color-text-primary`
*   **H2 (Section Header / Active Tab)**
    *   *Size:* 14pt
    *   *Weight:* Medium (500)
    *   *Line-Height:* 1.3
    *   *Color:* `color-text-primary` / `color-text-secondary`
*   **Body Text (Locations / Descriptions)**
    *   *Size:* 18pt (Large Reading Variant) / 14pt (Standard Variant)
    *   *Weight:* Regular (400)
    *   *Line-Height:* 1.4
    *   *Color:* `color-text-secondary`
*   **Data Values (Times, Durations, Numbers)**
    *   *Size:* 18pt
    *   *Weight:* Regular (400) or Bold (700) depending on prominence
    *   *Letter-Spacing:* `+0.5px` (Optimized for readability)
    *   *Color:* Dynamic (White / Gold / Pink depending on data category)
*   **Accent Labels & Micro-copy**
    *   *Size:* 12pt
    *   *Weight:* Medium (500) or Bold (700)
    *   *Transform:* Sentence Case or Uppercase depending on placement

---

## 4. LAYOUT, GRID & SPACING PRINCIPLES

### 4.1 The 4pt Grid System
All spacing, padding, margin, and dimension parameters must strictly align with a **4pt vertical rhythm grid** (e.g., 4, 8, 12, 16, 24, 32, 44, 48).

*   **Application Edge Margins:** `16pt` fixed padding on Left and Right edges of the screen viewport.
*   **Card Internal Padding:** `16pt` uniform layout spacing inside standard content cards.
*   **Element Gutters:** `12pt` or `16pt` vertical gap separating modular component containers.
*   **Touch Targets:** Minimum structural interaction size of `44pt x 44pt` to ensure robust ergonomic compliance.

---

## 5. COMPONENT LIBRARY & SPECIFIC RULES

### 5.1 Search Bar Component
*   **Typography:** System font, size `11pt`, Bold.
*   **Visual Structure:** Low-opacity background container with a magnifying glass trailing icon aligned to the right edge. Inner padding `12pt`.

### 5.2 Content Cards / List Items
*   **Background Style:** Smooth translucent dark layer with a subtle backdrop filter blur.
*   **Separation Rule:** Avoid harsh borders. Separation must be achieved entirely using soft light-source drop shadows or subtle background differentiation.
*   **Text Layout:** Left-aligned location titles (`color-text-primary`), paired with right-aligned dynamic metric tracking or data status tags.

### 5.3 Interactive Toggles & Segmented Controls
*   **Layout:** Wrapped capsule-shaped containers.
*   **Interactive Target Rule:** Ensure a minimum `44pt` bounding box target size.
*   **Selection Accent:** Highlight active modes or specific buttons using bright `color-accent-gold` or high-contrast filled badges (e.g., capsule active indicators enclosing location text).

### 5.4 Data Visualizations (Curve Graphs)
*   **Sunrise/Sunset Graph:** Smooth bézier curved line with an active tracking thumb/node drifting horizontally.
*   **Grid ticks:** Small vertical hash lines mapped at rhythmic intervals beneath the curve, leveraging `color-text-muted`.

---

## 6. DEVELOPMENT & CURSOR AI IMPLEMENTATION GUIDELINES
When converting this design system into executable frontend code (SwiftUI, Flutter, or Tailwind CSS), the following directives must be natively followed:

1.  **Do not invent intermediate sizes:** If an element padding is not a multiple of 4, reject it and scale up/down to the nearest token step (`12pt`, `16pt`, `24pt`, etc.).
2.  **Maintain Layer Contrast:** Floating windows or bottom sheets must utilize an extra background blur effect (`backdrop-filter: blur(20px)`) to keep text readable against lower graphical curves.
3.  **Color Context Clues:** Gold (`#FFD700`) must only be applied to essential calls-to-action or active parameters requiring immediate user attention. Do not use it as a general text color.
