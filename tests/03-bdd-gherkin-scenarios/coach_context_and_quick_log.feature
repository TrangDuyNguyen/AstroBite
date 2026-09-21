Feature: AstroCoach Contextual Memory and 1-Tap Meal Log
  As an AstroBite user chatting with AstroCoach AI
  I want the coach to remember my fitness goal, TDEE, streak, and today's remaining budget
  And I want to log suggested meals into my diary with a single tap
  So that I get tailored guidance and save logging time

  Background:
    Given the user has an active profile with fitness goal "Fat Loss" and TDEE 2100 kcal
    And the user has an active streak of 4 days
    And the user has consumed 1100 kcal out of 1900 kcal today

  Scenario: Coach receives complete context of user profile, streak, and intake
    When the user sends "Bữa tối nay tôi nên ăn gì?"
    Then the context payload includes "Fat Loss"
    And the context payload includes 800 kcal remaining budget
    And the context payload includes current streak of 4 days

  Scenario: 1-Tap meal suggestion card appears and logs food instantly
    Given the AI responds with advice containing a meal metadata tag
    Then the chat bubble displays a 1-Tap "Thêm Vào Nhật Ký" action card
    When the user taps the 1-Tap button on the card
    Then a new FoodLog is created in the repository
    And today's consumed calories increment by the meal amount
    And a confirmation toast informs the user of the added meal
