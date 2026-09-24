# Gate 3: Test Plan — AstroCoach Conversation History

- **Feature**: `FEAT-16-EXT` / `EPIC-18`
- **Sub-Agent**: QA Tester (`qa-tester`) — *"The Paranoid Inquisitor"*

---

## 1. Test Scenarios

```gherkin
Feature: AstroCoach Conversation History
  Scenario: Open history sheet and list previous sessions
    When User taps history button on AppBar
    Then A bottom sheet appears with title "Lịch sử hội thoại"
    And List of past dates is shown

  Scenario: Switch to a past session
    Given History sheet is open with a past date "2026-09-22"
    When User taps on date "2026-09-22"
    Then Messages from "2026-09-22" are displayed in chat
    And A banner appears: "Đang xem lại phiên ngày 2026-09-22"

  Scenario: Return to today's active session
    Given User is reviewing a past session
    When User taps "Quay lại Hôm nay"
    Then Today's active session is restored
    And The past session banner disappears
```
