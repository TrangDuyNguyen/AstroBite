Feature: Calorie Diary and Meal Logging
  As a daily tracker user
  I want to review and manage my daily meals and nutrition progress
  So that I stay within my calorie deficit and health goals

  Background:
    Given I am on the Today Overview Dashboard Screen

  Scenario: Viewing normal calorie progress within budget
    Given my daily target calories is 2000 kcal
    When I have logged "Bữa sáng" with 500 kcal and "Bữa trưa" with 700 kcal
    Then the progress arc should show 1200 consumed calories
    And the center text should display "800 kcal" with label "còn lại"
    And the progress color should be Primary Blue

  Scenario: Warning alert when exceeding calorie budget
    Given my daily target calories is 2000 kcal
    When I have logged meals totaling 2150 kcal
    Then the center text should display "+150 kcal" with label "vượt mục tiêu"
    And the progress arc and summary card border should turn Tertiary Gold

  Scenario: Deleting an accidental meal log with confirmation
    Given the "Bữa sáng" section contains "Trứng ốp la" with 250 kcal
    When I swipe left on "Trứng ốp la"
    And I confirm the deletion dialog
    Then "Trứng ốp la" should be removed from the list
    And the total consumed calories should decrease by 250 kcal
    And remaining calories should increase by 250 kcal
    And a notification saying "Đã xóa món Trứng ốp la" should appear

  Scenario: Canceling deletion of a meal log
    Given the "Bữa sáng" section contains "Trứng ốp la" with 250 kcal
    When I swipe left on "Trứng ốp la"
    And I cancel the deletion dialog
    Then "Trứng ốp la" should remain in the list
    And the total consumed calories should not change

  Scenario: Switching dates via Date Picker Strip
    Given the Date Picker Strip is displayed at the top
    When I select yesterday's date
    Then the dashboard should update to show yesterday's meal logs
    And when I tap today's date
    Then the dashboard should return to today's meal logs with "Hôm nay" highlighted
