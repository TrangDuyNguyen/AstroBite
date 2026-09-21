Feature: Cosmic Gamification and Streak Engine
  As a health-conscious AstroBite user
  I want to track my daily clean-eating streaks, earn starlight shields, and unlock cosmic badges
  So that I stay consistently motivated and form long-term mindful eating habits

  Background:
    Given the user is authenticated
    And the user has a daily calorie target of 2000 kcal

  Scenario: First meal log starts streak at 1
    Given the user has no previous food logs
    And currentStreak is 0
    When the user logs a meal "Phở Bò" of 500 kcal on "2026-09-19"
    Then the currentStreak becomes 1
    And longestStreak becomes 1
    And lastActiveDate is set to "2026-09-19"
    And the Cosmic Energy Ring displays glowing celebration

  Scenario: Consecutive day log increments streak
    Given the user has a currentStreak of 3
    And lastActiveDate is "2026-09-18"
    When the user logs a meal on "2026-09-19"
    Then the currentStreak increments to 4
    And lastActiveDate updates to "2026-09-19"
    And longestStreak becomes 4

  Scenario: Multiple meal logs on the same day do not over-increment streak
    Given the user already logged breakfast today "2026-09-19"
    And currentStreak is 4
    When the user logs lunch on "2026-09-19"
    Then currentStreak remains 4
    And the Cosmic Energy Ring fills with additional calories

  Scenario: Starlight Shield protects streak when a single day is missed
    Given the user has a currentStreak of 5
    And lastActiveDate is "2026-09-17"
    And the user has 1 starlightShield available
    When the user logs a meal on "2026-09-19"
    Then 1 starlightShield is consumed
    And remaining starlightShields is 0
    And currentStreak is preserved and increments to 6
    And a notification banner displays "Khiên Tinh Tú đã bảo vệ chuỗi ngày của bạn!"

  Scenario: Broken streak resets to 1 when no shields are available
    Given the user has a currentStreak of 6
    And lastActiveDate is "2026-09-16"
    And starlightShields is 0
    When the user logs a meal on "2026-09-19"
    Then longestStreak remains 6
    And currentStreak resets to 1
    And lastActiveDate becomes "2026-09-19"
    And an encouraging reset message is displayed

  Scenario: 7-day milestone awards a Starlight Shield and unlocks badge
    Given the user has a currentStreak of 6
    And lastActiveDate is "2026-09-18"
    And starlightShields is 0
    When the user logs a meal on "2026-09-19"
    Then currentStreak reaches 7
    And 1 bonus starlightShield is awarded
    And the cosmic badge "pulsar_pioneer" is unlocked
    And a celebration modal appears displaying the new cosmic badge

  Scenario: Offline streak update and cloud sync
    Given the device is offline
    And currentStreak is 2
    When the user logs a meal offline today
    Then the streak increments to 3 in local cache
    When internet connection is restored
    Then the streak data is synchronized with Firestore without conflicts
