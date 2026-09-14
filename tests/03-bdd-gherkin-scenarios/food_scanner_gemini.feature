Feature: Gemini AI Food Scanner
  As a user preparing to eat
  I want to scan my meal with Gemini Vision AI
  So that I don't have to manually look up nutritional facts

  Background:
    Given I am authenticated and on the Dashboard

  @ai @smoke
  Scenario: Successfully scanning a meal and logging it to lunch
    When I tap the central camera scanner button
    And I point the camera at a plate of "Phở Bò"
    And I tap the capture shutter button
    Then I should see the scanning laser animation for less than 3 seconds
    And the Scan Result BottomSheet should appear
    And the detected food name should be "Phở Bò"
    And the confidence score should be greater than 0.70
    When I select the meal type "Trưa"
    And I tap "Lưu vào Nhật ký"
    Then the BottomSheet should close
    And the Dashboard should show "Phở Bò" under the Lunch section
    And remaining daily calories should be decremented accordingly
