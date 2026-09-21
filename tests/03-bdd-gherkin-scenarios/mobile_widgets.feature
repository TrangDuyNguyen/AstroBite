Feature: Mobile Widgets and Quick Glance
  As an on-the-go AstroBite user
  I want to view my remaining calories and macros on my phone's home/lock screen
  And launch the AI camera scanner in 1-tap
  So that I stay within my dietary budget without opening the app every time

  Background:
    Given the user has an active daily calorie target of 2000 kcal

  Scenario: Widget data updates when a meal is logged
    Given the widget displays remaining calories as 1500 kcal
    When the user logs lunch with 600 kcal
    Then the widget payload updates remaining_calories to 900
    And carbs, fat, and protein grams reflect the new intake
    And widget refresh is requested in under 200ms

  Scenario: Widget reflects active streak and shield count
    Given the user has an active streak of 5 days with 1 starlight shield
    When the widget sync service updates native storage
    Then current_streak key contains 5
    And has_shield key contains true

  Scenario: 1-Tap quick scan opens FoodScannerPage
    Given the user taps the quick scan action on the widget
    When the deep-link uri "astrobite://scanner" is handled by the app
    Then the app router navigates immediately to FoodScannerRoute
    And the camera preview starts without intermediate prompts
