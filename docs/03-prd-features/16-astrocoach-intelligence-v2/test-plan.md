# Gate 3: Master Test Plan & BDD Gherkin Scenarios — AstroCoach AI Intelligence v2

- **Feature**: `FEAT-16` / `EPIC-18` (AstroCoach AI Intelligence v2 & Conversational Nutritionist)
- **Sub-Agent**: QA/QC Tester (`qa-tester`) — *"The Paranoid Inquisitor"*
- **Target Coverage**: 100% Traceability with PRD (`US-01` to `US-05`) & Zero du di policy

---

## 1. Traceability Matrix & Test Design (EP & BVA)

| User Story | Test Type | Input Condition / Boundary Case | Expected Outcome |
| :--- | :--- | :--- | :--- |
| **US-01** Context Header Strip | Unit / Widget | Target: 2000 kcal, Consumed: 1350 kcal. Protein remaining: 28g, Carbs remaining: 45g, Fat remaining: 12g. | Hiển thị chính xác "Còn lại: 650 kcal". Thanh Carbs màu xanh `#1A73E8`, Protein màu vàng `#FFD700`, Fat màu hồng `#FF69B4`. |
| **US-01** Sodium Warning | Widget | Natri tiêu thụ >= 1500mg (ngưỡng cảnh báo). | Hiển thị chip cảnh báo màu hổ phách: "Cảnh báo Natri: X mg / 2000mg". |
| **US-02** Block Extraction | Unit / Integration | Gemini trả về text + ` ```astrobite-meal { "name": "...", "calories": 420 ... } ``` `. | Parser tách chuẩn xác text hội thoại và Map JSON dữ liệu món ăn. |
| **US-02** Malformed Fallback | Unit | Gemini trả về block JSON lỗi cú pháp (thiếu ngoặc nhọn, string rác). | Không crash app; fallback hiển thị toàn bộ nội dung dưới dạng text bubble thông thường. |
| **US-03** Holographic Card | Widget | Message có `recommendedMeal != null`. | Render thẻ Holographic Bento Card gồm tên món, 420 kcal, macro badges và nút 1-Tap Log. |
| **US-04** 1-Tap Log Execution | Widget / Integration | Người dùng tap "⚡ Ghi ngay vào Nhật ký (1-Tap Log)". | Gọi meal logger lưu vào `todaySummaryProvider`, nút đổi sang "✓ Đã ghi vào nhật ký", vô hiệu hóa tap lần 2. |
| **US-05** Dynamic Quick Chips | Widget | Khung giờ 19:30 (Buổi tối). | Hiển thị chip: "🥗 Gợi ý bữa tối giàu protein", "⚡ Phân tích natri hôm nay", "💧 Lượng nước cần bù". Tap chip sẽ tự gửi tin nhắn. |

---

## 2. BDD Gherkin Test Scenarios (`astrocoach_v2.feature`)

```gherkin
Feature: AstroCoach AI Intelligence v2 & Conversational Nutritionist
  As an AstroBite user tracking calories and macros
  I want intelligent conversational nutrition advice and 1-tap meal logging
  So that I can meet my daily fitness goals efficiently without manual entry friction

  Background:
    Given User is logged in and today target is 2000 kcal
    And User has consumed 1350 kcal, 130g carbs, 82g protein, 48g fat, 1600mg sodium
    And User navigates to the AstroCoach page

  Scenario: Display accurate Context Header Strip with remaining macros and sodium warning
    Then Context Header should display "Còn lại: 650 kcal"
    And Carbs bar should reflect remaining 45g with color "#1A73E8"
    And Protein bar should reflect remaining 28g with color "#FFD700"
    And Fat bar should reflect remaining 12g with color "#FF69B4"
    And Sodium warning banner should display "Cảnh báo Natri: 1,600mg / 2,000mg"

  Scenario: Parse and render Holographic Bento Meal Card from AI response
    When Gemini AI responds with text and an "astrobite-meal" code block
    """
    Dựa vào chỉ số hôm nay, bạn còn thiếu 28g protein. Đề xuất:
    ```astrobite-meal
    {
      "name": "Ức gà áp chảo quinoa & bông cải xanh",
      "calories": 420,
      "protein": 34,
      "carbs": 38,
      "fat": 8,
      "sodium": 210,
      "ingredients": ["150g ức gà", "100g quinoa", "80g bông cải xanh"]
    }
    ```
    """
    Then The chat message should render conversational text
    And A Holographic Bento Meal Card should be displayed below the text
    And The meal card should show "Ức gà áp chảo quinoa & bông cải xanh"
    And The meal card should display "420 kcal", Protein "34g", Carbs "38g", Fat "8g"
    And The meal card should have a "Ghi ngay vào Nhật ký (1-Tap Log)" action button

  Scenario: Execute 1-Tap Log directly from chat card
    Given An AI recommendation card is displayed in chat
    When The user taps "Ghi ngay vào Nhật ký (1-Tap Log)"
    Then The meal should be logged into today's nutrition diary
    And The button text should change to "✓ Đã ghi vào nhật ký"
    And The button should be disabled for further clicks
    And The Context Header remaining calories should decrease to "230 kcal"

  Scenario: Graceful fallback when meal block is malformed
    When Gemini AI responds with an invalid "astrobite-meal" block
    """
    Tôi đề xuất món này:
    ```astrobite-meal
    { "name": "Bún chả", "calories": "unparseable"
    ```
    """
    Then No app crash or exception should occur
    And The response should be rendered as a regular text bubble
```

---

## 3. Quality Criteria & Acceptance Definition

- **Pass Rate**: 100% (Mọi test case phải Passed thực chất, 0 skipped, 0 fake test).
- **Latency SLA**: Thời gian phản hồi AstroCoach <= 2.5s.
- **Strict Clean Ponytail**: Không thêm thư viện chat mới của bên thứ ba, tái sử dụng toàn bộ cấu trúc Riverpod sẵn có của AstroBite.
