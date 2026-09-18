# language: en
@feature @multi_item_scanner @FEAT-06
Feature: Multi-Item Food Scanner AI Detection & Reactive Nutrition
  As an AstroBite user eating a combined plate or family meal
  I want to scan the entire plate in one photo and see individual dishes decomposed
  So that I can adjust portions independently and track my calories accurately without multiple scans

  Background:
    Given I am logged in to AstroBite
    And the device camera permission is granted
    And I am on the food scanner screen

  @smoke @critical @happy_path
  Scenario: Successfully detect a 3-item meal plate within 2.5 seconds
    When I point the camera at a tray containing "White Rice", "Braised Pork", and "Stir-fried Water Spinach"
    And I tap the capture button
    Then the laser scanning viewfinder should animate for less than 2.5 seconds
    And a bottom sheet should appear with 3 dish cards:
      | dish_name                   | min_confidence |
      | White Rice                  | 85             |
      | Braised Pork                | 85             |
      | Stir-fried Water Spinach    | 80             |
    And each dish card should have a portion slider and active checkbox
    And the total calorie summary should match the sum of the 3 dishes

  @critical @state_transition
  Scenario: Unselect an item to exclude it from the meal total
    Given the multi-item result sheet displays:
      | dish_name    | calories | is_selected |
      | White Rice   | 234      | true        |
      | Braised Pork | 380      | true        |
      | Soup         | 66       | true        |
    And the initial total calorie displays 680
    When I uncheck the checkbox for "White Rice"
    Then the "White Rice" card should dim with 40% opacity
    And the total calorie should immediately update to 446 kcal
    And the Carbs portion on the MacroBar should shrink accordingly

  @boundary @slider_bva
  Scenario Outline: Adjust dish portion slider at boundary values
    Given the dish "Braised Pork" has a default weight of 150g and 380 kcal
    When I drag the portion slider to <target_weight> grams
    Then the displayed weight should be <target_weight>
    And the calories should scale proportionally to <expected_calories> kcal

    Examples:
      | target_weight | expected_calories |
      | 20            | 51                |
      | 100           | 253               |
      | 800           | 2027              |

  @edge_case @fallback
  Scenario: Graceful fallback when only a single food item is detected
    When I take a photo of a single bowl of "Beef Pho"
    And the AI analysis returns exactly 1 item in the dishes list
    Then the app should display the standard single-item result layout
    And no dish selection checkboxes or multi-dish list should be shown

  @edge_case @negative
  Scenario: Take photo of non-food object or extremely dark scene
    When I take a photo of a laptop on a dark desk
    And the AI confidence score is below 60 percent
    Then I should see a Celestial Alert stating "Không nhận diện rõ các món ăn trên đĩa"
    And I should see two action buttons "Chụp Lại" and "Nhập Thủ Công"
