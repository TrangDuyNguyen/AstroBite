# 📋 User Stories & Acceptance Criteria — Sprint 13 (Core Daily Loop)

- **Mã Feature**: `FEAT-S13-TRACKER-NAV`
- **Mã Epic**: `EPIC-UI-REFRESH`
- **Tài liệu tham chiếu**: [`prd-s13-tracker-nav.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/20-core-daily-loop-tracker-nav/prd-s13-tracker-nav.md)
- **Tác giả**: Sub-Agent Business Analyst (`business-analyst`)

---

## 📌 US-S13-01: Tactile Shell Navigation & Floating Camera FAB (`ShellScreen`)

```gherkin
Feature: Tactile Shell Navigation Dock
  As a daily AstroBite user
  I want a floating claymorphic navigation dock with an elevated 3D camera button
  So that I can effortlessly switch tabs and trigger the food scanner with my thumb

  Scenario: Render floating ClayBottomNav with 4 primary tabs and center Camera FAB
    Given the user is on any tab in ShellScreen
    When the bottom navigation bar is rendered
    Then it should display as a floating dock with 24pt corner radius and AppColors.surfaceContainer background
    And it should show 4 tabs: "Home", "Coach", "Stats", "Profile"
    And it should display an elevated circular Camera FAB in the center with AppColors.primary (#1CB0F6)
    And the center FAB touch target should be at least 56x56pt

  Scenario: Tactile squash animation on tap
    Given the ClayBottomNav is visible
    When the user taps any tab or the center Camera FAB
    Then the tapped widget should animate a scale down to 0.95 within 100ms
    And trigger a light haptic feedback
    And navigate to the corresponding destination with 0 dropped frames
```

---

## 📌 US-S13-02: Calorie & Macro Cockpit Dashboard (`HomePage`)

```gherkin
Feature: Home Cockpit Dashboard with Chunky Indicators
  As a health-conscious user
  I want to see my daily calories and 3 macro nutrients on a tactile cockpit card
  So that I can comprehend my remaining nutritional budget in under 1.5 seconds

  Scenario: Display CalorieProgressArc and 3 ChunkyMacroBars on ClayCard
    Given the user opens HomePage with loaded diary data
    When the Cockpit Card renders
    Then it should be wrapped in a ClayCard with pure white surface and soft clay depth shadow
    And the left segment should show CalorieProgressArc with calories consumed, target, and remaining
    And the right segment should show 3 separate ChunkyMacroBars:
      | Nutrient | Color Token         | Hex Code |
      | Carbs    | AppColors.primary   | #1CB0F6  |
      | Fat      | AppColors.secondary | #FF5C8D  |
      | Protein  | AppColors.tertiary  | #FF9600  |
    And each macro bar should have smooth elastic progress tween animation

  Scenario: 4 Meal Timeline Cards with pastel tints and 1-tap quick log
    Given the user scrolls to the meal timeline
    When the 4 meal cards render (Breakfast, Lunch, Dinner, Snack)
    Then each card should have its respective clay pastel background tint
    And each card should display a 44x44pt "+" Quick Log button
    When the user taps the "+" button
    Then the app should immediately route to ManualEntryRoute with that meal type pre-selected

  Scenario: Warm Shimmer Loading state
    Given the daily diary data is fetching or refreshing
    When AsyncLoading is emitted by dailyDiaryProvider
    Then ClaySkeletonLoader should display with #EFF1F5 warm cream shimmer
    And no black or dark legacy shimmer should be visible
```

---

## 📌 US-S13-03: Ergonomic Manual Food Entry (`ManualEntryPage`)

```gherkin
Feature: Ergonomic Manual Food Entry with Clay Inputs
  As a user logging a custom food item
  I want a responsive search bar, category chips, and quick weight steppers
  So that I can complete logging a meal manually in under 3.2 seconds

  Scenario: Search with ClaySearchBar and recent foods chips
    Given the user is on ManualEntryPage
    When the user views the search area
    Then ClaySearchBar should be rendered with 20pt fat corners and clay outline
    And Recent Foods should be listed below as tap-to-select chips
    When the user types a search query
    Then matching food items should filter dynamically without keyboard flickering

  Scenario: Adjust weight with Quick Weight Steppers
    Given the user has selected or typed a food item
    When the portion adjustment section is displayed
    Then it should present Quick Steppers: "-50g", "+50g", "1 Bát", "1 Đĩa"
    When the user taps "+50g"
    Then the gram input should increment by 50
    And calculated calories, carbs, fat, and protein should update instantly

  Scenario: Save entry with 3D ClayButton
    Given all mandatory food fields are valid
    When the user taps "Lưu vào Nhật Ký" (ClayButton.primary)
    Then the button should execute a 3D bevel press animation
    And show a loading indicator if saving takes > 200ms
    And show a confirmation snackbar
    And pop back to HomePage with updated daily totals
```

---

## 📌 US-S13-04: Tactile Meal Detail Management (`MealDetailPage`)

```gherkin
Feature: Meal Detail & Food Item Management
  As a user reviewing a specific meal
  I want to view itemized foods on tactile cards and adjust or delete them
  So that my daily nutrition log remains 100% accurate

  Scenario: Display itemized food cards with mini macro bars
    Given the user navigates to MealDetailPage for a meal containing foods
    When the page renders
    Then each food item should be displayed in an independent ClayCard
    And each card should display food name, weight in grams, total calories
    And a mini ChunkyMacroBar displaying the proportion of Carbs, Fat, and Protein

  Scenario: Delete food item with confirmation
    Given a food item in the list
    When the user taps the delete ClayIconButton
    Then a tactile confirmation dialog should appear
    When confirmed
    Then the item should be removed from the meal
    And total meal calories should update instantly
```
