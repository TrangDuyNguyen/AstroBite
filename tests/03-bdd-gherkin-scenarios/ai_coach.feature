Feature: Smart Realtime AI Coach
  As a health-conscious user
  I want to chat with an AI nutrition coach
  So that I receive personalized dietary advice based on my daily food intake

  Background:
    Given the user is logged in
    And the user has a calorie target of 2000 kcal

  Scenario: Send a message and receive AI response
    Given the user is on the Coach tab
    And the device has internet connection
    When the user types "Bữa tối nên ăn gì?"
    And the user taps the Send button
    Then a user message bubble appears on the right
    And a typing indicator shimmer appears on the left
    And the AI responds within 3 seconds
    And the chat scrolls to the latest message

  Scenario: Quick Action chip sends preset question
    Given the user is on the Coach tab
    And Quick Actions bar shows "Phân tích hôm nay" chip
    When the user taps the "Phân tích hôm nay" chip
    Then the chip content is sent as a message
    And the Quick Actions bar hides during AI processing
    And the Quick Actions bar reappears after AI responds

  Scenario: AI uses daily meal context for accurate advice
    Given the user has logged breakfast 450 kcal and lunch 650 kcal today
    And the daily calorie target is 2000 kcal
    When the user asks "Bữa tối nên ăn gì?"
    Then the AI response mentions the remaining 900 kcal budget
    And the AI suggests meals fitting the remaining macro targets

  Scenario: Offline mode prevents sending messages
    Given the device has no internet connection
    When the user opens the Coach tab
    Then an offline banner displays "Đang ngoại tuyến"
    And the text input field is disabled
    And previous chat history is still visible

  Scenario: AI response timeout after 15 seconds
    Given the user has sent a message
    When the AI does not respond within 15 seconds
    Then the typing indicator disappears
    And an error bubble shows "AI đang bận, vui lòng thử lại"
    And a "Thử lại" button is displayed
    When the user taps "Thử lại"
    Then the original message is resent

  Scenario: View chat history within the same day
    Given the user has chatted 5 messages in the morning
    When the user reopens the Coach tab in the afternoon
    Then all 5 morning messages are displayed
    And the user can continue the conversation

  Scenario: Chat session resets on a new day
    Given the user chatted yesterday
    When the user opens the Coach tab today
    Then the chat screen shows empty state
    And the message "Chào buổi sáng! Hỏi tôi bất cứ điều gì về dinh dưỡng hôm nay." is displayed
    And Quick Actions bar is visible

  Scenario: Message limit reached at 50 messages per day
    Given the user has sent 50 messages today
    When the user tries to send message number 51
    Then the text input field is disabled
    And a dialog shows "Bạn đã đạt giới hạn 50 tin nhắn hôm nay"

  Scenario: AI declines medical diagnosis questions
    Given the user is on the Coach tab
    When the user asks "Tôi bị tiểu đường, nên uống thuốc gì?"
    Then the AI responds with a disclaimer about consulting a doctor
    And the medical disclaimer "AI gợi ý tham khảo, không thay thế chuyên gia y tế" is displayed
