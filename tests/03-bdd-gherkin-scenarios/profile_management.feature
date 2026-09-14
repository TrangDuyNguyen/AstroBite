Feature: User Profile and Macro Customization
  As a fitness enthusiast
  I want to adjust my macronutrient distribution ratio
  So that the app reflects my high-protein fitness regimen

  Background:
    Given I am authenticated and navigate to Profile Screen

  Scenario: Switching to High Protein preset
    When I tap "Mục tiêu dinh dưỡng"
    And I choose the "High Protein" preset (35% Carbs, 40% Protein, 25% Fat)
    And I tap "Lưu thay đổi"
    Then the goal settings should be saved successfully
    When I navigate back to the Dashboard
    Then the MacroBar should display 40% target for Protein
