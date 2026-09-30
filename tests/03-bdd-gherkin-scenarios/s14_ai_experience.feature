@sprint14 @v2.3.0 @ai_experience
Feature: High-Value AI Experience — Camera Scanner & GenUI Coach UI Overhaul
  As an AstroBite health-conscious user
  I want an intuitive, tactile camera scanner and an interactive AI Coach chat
  So that I can log meals with zero friction and receive instant personalized nutritional guidance

  Background:
    Given the AstroBite app is launched and initialized with Claymorphic theme
    And the user is authenticated with a valid profile

  # =========================================================================
  # US-S14-01: Camera Viewfinder & Chunky Shutter Controls
  # =========================================================================
  @camera @ui @positive
  Scenario: Display Camera Viewfinder with 3D Shutter and controls
    Given the user navigates to the Camera screen
    When the camera preview stream is successfully initialized
    Then the screen displays a soft rounded viewfinder with 24pt corners
    And a circular 3D Shutter button of size 76x76pt is centered in the thumb zone
    And the bottom bevel shadow has a thickness of 4pt
    And the Flash toggle and Gallery picker buttons have minimum touch targets of 48x48pt

  @camera @interaction @positive
  Scenario: Tactile squash and haptic feedback on shutter press
    Given the user is on the Camera screen with food in the viewfinder
    When the user taps the 3D Shutter button
    Then the button squashes down to 0.92 scale for 80 milliseconds
    And a medium haptic impact is triggered
    And a frozen frame with a smooth radar scan pulse is displayed while analyzing

  @camera @permissions @negative
  Scenario: Camera permission denied error handling
    Given camera permission is denied by the user or operating system
    When the user opens the Camera screen
    Then a friendly ClayCard warning surface is displayed
    And a primary 3D "Open Settings" ClayButton is shown
    And the application does not crash

  # =========================================================================
  # US-S14-02: Scan Review ClaySheet & ChunkyMacroBar
  # =========================================================================
  @scanner @review @positive
  Scenario: Review detected dishes on ClaySheet with ChunkyMacroBar
    Given Gemini AI returns detected dish items: "Phở Bò Tái" (150g, 420 kcal)
    When the user lands on the ScanReviewPage
    Then the background is Warm Milk "#FAF8F5"
    And each detected item is rendered as an independent Pure White ClayCard
    And the ChunkyMacroBar shows the immutable nutrient colors:
      | Nutrient | Color Name            | Hex Code |
      | Carbs    | Duolingo Sky Blue     | #1CB0F6  |
      | Fat      | Strawberry Cream Pink | #FF5C8D  |
      | Protein  | Honey Tangerine       | #FF9600  |
    And the ClayMealChip selector allows switching between Breakfast, Lunch, Dinner, Snack

  @scanner @dynamic_calc @positive
  Scenario: Real-time recalculation when adjusting dish gram weight
    Given a detected dish card displays "150g" and "420 kcal"
    When the user taps the "+20g" stepper button
    Then the dish weight updates to "170g"
    And the calories automatically recalculate to "476 kcal"
    And the ChunkyMacroBar updates its proportions smoothly within 200ms

  @scanner @save @positive
  Scenario: Save meal from scan review to food diary
    Given the user has reviewed and verified the detected dishes
    When the user taps the primary 3D "Lưu vào Nhật Ký" ClayButton
    Then the button squashes to 0.95 scale
    And the meal is dispatched to TrackerNotifier
    And the user is redirected to the HomePage with a success confirmation

  # =========================================================================
  # US-S14-03: AstroCoach Chat Cockpit & Stream
  # =========================================================================
  @coach @chat @positive
  Scenario: Display conversation in Claymorphic chat cockpit
    Given the user navigates to the Coach tab
    When the chat history loads
    Then user bubbles are styled as soft pastel ClayCards aligned to the right
    And AstroCoach AI bubbles are styled as pure white ClayCards aligned to the left
    And message text renders full Markdown styling with 60 FPS scrolling
    And the input bar features a ClayTextField with a 3D ClayIconButton send button

  @coach @offline @negative
  Scenario: Send message while disconnected from internet
    Given the device loses internet connection while on the Coach screen
    When the user types a question and taps the send button
    Then an offline banner or inline indicator displays: "Đang mất kết nối mạng"
    And no unhandled network exceptions crash the application

  # =========================================================================
  # US-S14-04: 1-Tap Generative UI Meal Logging
  # =========================================================================
  @coach @genui @positive
  Scenario: Render A2UI MealQuickLogCard and execute 1-Tap log
    Given AstroCoach returns a response containing an A2UI MealQuickLogCard component
    When the message block is parsed
    Then a tactile MealQuickLogCard wrapped in a ClayCard is embedded directly in the chat
    And it displays dish name, calorie badge, and mini macro pills
    And a brand green "#58CC02" 3D ClayButton is displayed with label "Ghi vào nhật ký"
    When the user taps the "Ghi vào nhật ký" button
    Then the button squashes to 0.95 scale with light haptic feedback
    And the meal is logged to today's diary in under 150ms
    And the button updates state to "Đã ghi nhận ✓"
