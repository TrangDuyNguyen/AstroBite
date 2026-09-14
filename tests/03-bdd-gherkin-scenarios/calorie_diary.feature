Feature: Calorie Diary and Meal Logging
  As a daily tracker user
  I want to review and manage my daily meals
  So that I stay within my calorie deficit

  Background:
    Given I am on the Dashboard Screen

  Scenario: Deleting an accidental meal log
    Given the "Breakfast" section contains "Trứng ốp la" with 250 kcal
    When I swipe left on "Trứng ốp la"
    And I confirm the deletion dialog
    Then "Trứng ốp la" should be removed from the list
    And the total consumed calories should decrease by 250 kcal
    And remaining calories should increase by 250 kcal
