# language: en
@feature @micronutrients @FEAT-08
Feature: Advanced Micronutrient Tracking (Sodium, Fiber, Sugar)
  As an AstroBite user conscious of blood pressure, digestive health, or sugar intake
  I want to track Sodium, Fiber, and Sugar alongside core macros
  So that I can avoid excessive salt and sugar while meeting my daily fiber goals

  Background:
    Given I am logged in to AstroBite
    And my user profile specifies a daily sodium limit of 2300mg and fiber goal of 25g

  @smoke @critical @happy_path
  Scenario: View micronutrient chips on AI scan result sheet
    When I scan a plate of "Pan-seared Salmon with Asparagus"
    Then the bottom sheet should display the Micronutrient Chips Row:
      | nutrient | expected_value |
      | Sodium   | 320 mg         |
      | Fiber    | 4.2 g          |
      | Sugar    | 1.5 g          |
    And all three chips should display in calm Celestial tone

  @warning @boundary_alert
  Scenario: High sodium warning triggered when a dish exceeds 800mg sodium
    When I scan a bowl of "Spicy Seafood Instant Noodle"
    And the AI calculates the sodium content as 1450 mg
    Then the Sodium chip should turn to Amber Alert color
    And a "Muối cao" warning badge with a warning triangle icon should be displayed
    And tapping the badge should display an advice tooltip to drink adequate water

  @critical @diary_progress
  Scenario: Daily micronutrient progress bars on Diary screen
    Given my logged meals today total 1600mg Sodium, 28g Fiber, and 22g Sugar
    When I open the Daily Diary screen
    Then the "Vi Chất Dinh Dưỡng Hôm Nay" card should display:
      | nutrient | consumed | target | status_color |
      | Sodium   | 1600     | 2300   | Cyan         |
      | Fiber    | 28       | 25     | Emerald      |
      | Sugar    | 22       | 36     | Light Grey   |
    And the Fiber bar should display a star icon indicating the daily goal is achieved

  @critical @red_alert
  Scenario: Red alert warning when total daily sodium exceeds 2300mg
    Given my logged meals today total 2450mg Sodium
    When I view the Micronutrient Card on the Diary screen
    Then the Sodium progress bar should turn to Red Alert color
    And a warning banner should state "Vượt ngưỡng khuyến nghị (2,450 / 2,300 mg)"

  @compatibility @regression
  Scenario: Gracefully handle historical meals from v1.0 without micronutrient data
    Given a meal log created in version 1.0.0 exists with null sodium, fiber, and sugar
    When I view that meal's details on the Diary screen
    Then the app should default the missing micronutrients to 0.0 without throwing any null exceptions
    And the screen should render normally
