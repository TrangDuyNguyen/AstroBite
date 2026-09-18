Feature: Manual Food Entry and Diary Logging
  As a fitness and nutrition conscious user
  I want to manually search, adjust portion weight, or create custom food logs
  So that I can maintain an accurate daily calorie and macronutrient diary without needing photos

  Background:
    Given I am logged in and on the Manual Food Entry Screen

  Scenario: Searching and selecting a common Vietnamese dish
    Given the search input field is empty
    When I type "phở" into the search bar
    Then the food list should only display dishes containing "phở"
    And "Phở bò" should appear with its base serving and calorie count

  Scenario: Dynamically adjusting food portion weight via slider
    Given I have selected "Ức gà áp chảo" with base 100g and 165 kcal
    When I adjust the weight slider to 200g
    Then the displayed weight should update to "200g"
    And the calculated calories should update to "330 kcal"
    And the protein value should update to "62g"
    And the save button label should indicate 330 kcal

  Scenario: Successfully logging a food item to lunch
    Given I selected "Bữa trưa" as the target meal
    And I selected "Cơm tấm sườn" with 550 kcal
    When I press the "Lưu vào Bữa trưa" button
    Then a new food log should be created with mealType "lunch" and source "manual_entry"
    And a notification saying "Đã lưu Cơm tấm sườn vào Bữa trưa!" should appear

  Scenario: Creating and saving a custom food entry
    When I open the custom food dialog
    And I enter dish name "Salad cá hồi quả bơ"
    And I enter weight 250
    And I enter calories 380
    And I enter protein 22, carbs 10, fat 28
    And I submit the custom food form
    Then the custom dish should be saved to my daily log
    And the notification should confirm "Đã lưu Salad cá hồi quả bơ vào Bữa ăn!"

  Scenario: Form validation fails when required fields are empty
    When I open the custom food dialog
    And I leave the dish name empty
    And I submit the custom food form
    Then a validation error should state "Vui lòng nhập tên món ăn"
    And no food log should be submitted to the database

  Scenario: Pre-selecting meal type when navigating from Dashboard
    Given I am on the Today Overview Dashboard Screen
    When I tap the add food button on the "Bữa tối" meal card
    Then the Manual Food Entry Screen should open with "Bữa tối" selected by default
