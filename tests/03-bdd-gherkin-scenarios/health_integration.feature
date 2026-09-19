Feature: Apple Health & Health Connect Integration
  As a user with a fitness tracker or smartwatch
  I want to connect AstroBite to my health platform
  So that I can see my complete energy balance (calories in vs calories burned)

  Background:
    Given the user is logged in
    And the user has a calorie target of 2000 kcal

  Scenario: Connect to Apple Health successfully on iOS
    Given the user is on the Health Connection settings screen
    And the health platform is not connected
    When the user taps the "Kết nối" button
    And the iOS HealthKit authorization dialog appears
    And the user taps "Allow All"
    Then the connection status changes to "Đã kết nối ✅"
    And a SnackBar shows "Đã kết nối Apple Health thành công"
    And Firestore updates health_connected to true

  Scenario: Connect to Health Connect successfully on Android
    Given the user is on the Health Connection settings screen on an Android device
    And the health platform is not connected
    When the user taps the "Kết nối" button
    And the Health Connect permission flow appears
    And the user grants all permissions
    Then the connection status changes to "Đã kết nối ✅"

  Scenario: User denies health permissions
    Given the health permission dialog is displayed
    When the user taps "Don't Allow"
    Then the connection status remains "Chưa kết nối"
    And a guidance message explains why permissions are needed
    And a "Mở Cài đặt" button navigates to OS settings

  Scenario: Display Energy Balance with food and exercise data
    Given the user has connected Health
    And the user has logged breakfast 450 kcal and lunch 650 kcal
    And Health reports 420 kcal active energy burned
    When the user opens the Analytics tab
    Then the Energy Balance Card displays:
      | Field           | Value     | Color     |
      | Calo nạp        | 1100 kcal | primary   |
      | Calo đốt        | 420 kcal  | secondary |
      | Net Calories    | 680 kcal  |           |
      | Ngân sách còn   | 1320 kcal |           |
    And the progress arc shows 34% filled

  Scenario: Display steps and workout activity
    Given the user has connected Health
    And Health reports 8234 steps and workouts today
    When the user views the Activity Card in Analytics
    Then the steps show "8,234 bước"
    And the workouts list shows running 30 minutes 285 kcal and gym 45 minutes 135 kcal

  Scenario: No exercise data available
    Given the user has connected Health
    And there is no exercise data today
    When the user views the Activity Card
    Then steps show "0 bước"
    And a message shows "Hãy bắt đầu di chuyển nào! 🚶"

  Scenario: Disconnect from Health platform
    Given the user has connected Health
    When the user taps "Ngắt kết nối"
    And a confirmation dialog appears
    And the user taps "Xác nhận"
    Then the connection status changes to "Chưa kết nối"
    And the Energy Balance Card is hidden from Analytics
    And a SnackBar shows "Đã ngắt kết nối Health"

  Scenario: Write dietary energy back to Health when toggle is on
    Given the user has connected Health
    And the "Đồng bộ calo sang Health" toggle is ON
    When the user saves a meal of 450 kcal
    Then the meal is saved to Firestore
    And a Dietary Energy record of 450 kcal is written to Health

  Scenario: Do not write to Health when toggle is off
    Given the "Đồng bộ calo sang Health" toggle is OFF
    When the user saves a meal
    Then the meal is saved to Firestore
    And no data is written to the Health platform

  Scenario: Health not connected shows connect prompt
    Given the user has never connected Health
    When the user opens the Analytics tab
    Then a banner shows "Kết nối Apple Health để xem calo đốt cháy 🏃"
    And a "Kết nối" button is displayed
    And no Energy Balance or Steps cards are shown
