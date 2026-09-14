Feature: Authentication and Onboarding Flow
  As a new or returning user of AstroBite
  I want to securely sign in and configure my physical profile
  So that I get personalized calorie and macro targets

  Background:
    Given the app is launched on the device
    And Firebase services are initialized

  @smoke @critical
  Scenario: Successful registration with valid email and password
    Given I am on the Welcome Screen
    When I tap "Bắt đầu ngay"
    And I enter "qa_cucumber@astrobite.io" into the email field
    And I enter "AstroBite@2026" into the password field
    And I enter "AstroBite@2026" into the confirm password field
    And I tap the "Tạo tài khoản" button
    Then I should be navigated to the Onboarding Gender Screen
    And a new user document should be created in Firestore

  @regression
  Scenario: Completing 5-step onboarding and calculating TDEE
    Given I am on the Onboarding Survey
    When I select gender "Nam"
    And I enter birth year "1998" and height "175" cm
    And I enter weight "80" kg and target weight "75" kg
    And I select activity level "Lightly Active"
    And I select main goal "Giảm cân"
    And I tap "Hoàn thành khảo sát"
    Then I should see the Goal Summary with calorie target around 1918 kcal
    And tapping "Bắt đầu hành trình" should navigate me to the Dashboard

  @smoke @critical
  Scenario: Successful login with valid email and password
    Given I am on the Login Screen
    When I enter "qa_test_01@astrobite.io" into the email field
    And I enter "AstroBite@2026" into the password field
    And I tap the "Đăng nhập" button
    Then I should be navigated to the Dashboard
    And I should see my nutrition summary

  @regression @negative
  Scenario: Login failure with incorrect credentials
    Given I am on the Login Screen
    When I enter "qa_test_01@astrobite.io" into the email field
    And I enter "WrongPassword999" into the password field
    And I tap the "Đăng nhập" button
    Then I should see a SnackBar with error message "Email hoặc mật khẩu không chính xác."
    And I should remain on the Login Screen

  @smoke
  Scenario: Successful Google Sign-In authentication
    Given I am on the Login Screen
    When I tap the "Tiếp tục với Google" button
    And I select my Google account
    Then I should be authenticated with Firebase Auth
    And I should be navigated to the Dashboard

  @regression
  Scenario: Request password reset link
    Given I am on the Login Screen
    When I tap "Quên mật khẩu?"
    And I enter "qa_test_01@astrobite.io" into the reset email field
    And I tap "Gửi liên kết"
    Then I should see a success SnackBar with "Đã gửi liên kết đặt lại mật khẩu về email của bạn"

