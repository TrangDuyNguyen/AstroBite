# Master Test Plan & BDD Gherkin: Water Intake Tracker (Sprint 33)

> **Sub-Agent**: QA Tester (`qa-tester`) — *"The Paranoid Inquisitor"*  
> **Gate**: Gate 3 (Master Test Plan & Gherkin Verification Suite)  
> **Feature**: `FEAT-S33-WATER-TRACKER` | **Version**: `v3.5.0`  
> **Status**: ✅ **TEST SUITE READY FOR IMPLEMENTATION**

---

## 1. Test Strategy & Coverage Scope

| Hạng Mục | Phương Pháp | Mục Tiêu Bao Phủ |
| :--- | :--- | :--- |
| **Unit Tests** | `WaterLog` entity & `WaterGoalCalculator` pure functions | 100% Branch Coverage |
| **Repository Tests** | Cache-first fallback, mock SharedPreferences & Firestore | 100% Offline/Online Sync |
| **Widget Tests** | `ClayWaterCard` render, wave animation, tap +250ml, +500ml | 0 Overflow, Text Scale 1.5x |
| **Edge Cases** | Qua ngày mới (00:00), Spam click (+250ml x 10 liên tục), Mất mạng | 0 Crash, 0 Memory Leak |

---

## 2. BDD Gherkin Test Cases (`.feature`)

```gherkin
Feature: Water Intake Tracker Verification Suite

  Scenario Outline: Phân vùng tương đương (EP) & Giá trị biên (BVA) lượng nước
    Given Lượng nước ban đầu là <initial> ml
    When Người dùng ghi nhận thêm <intake> ml
    Then Tổng lượng nước hiển thị là <expected> ml
    And Tỷ lệ phần trăm hiển thị là <percent> %

    Examples:
      | initial | intake | expected | percent |
      | 0       | 250    | 250      | 12.5    |
      | 250     | 500    | 750      | 37.5    |
      | 1800    | 250    | 2050     | 102.5   |
      | 1999    | 1      | 2000     | 100.0   |
      | 4900    | 200    | 5000     | 250.0   |

  Scenario: Chống spam click (Rapid Tap Debounce)
    Given Người dùng ở màn hình Home
    When Người dùng nhấn nút "+250ml" liên tục 5 lần trong 200ms
    Then Hệ thống ghi nhận đúng 1250ml mà không bị race condition hay duplicate state
    And UI hiển thị mượt mà không bị giật frame (FPS >= 55)

  Scenario: Tự động reset sang ngày mới lúc 00:00
    Given Người dùng đã uống 2000ml vào ngày hôm qua (2026-10-20)
    When Đồng hồ hệ thống chuyển sang ngày mới 00:00:01 (2026-10-21)
    Then Lượng nước ngày hôm nay được khởi tạo về 0ml / 2000ml
    And Dữ liệu ngày hôm qua được lưu trữ an toàn trong lịch sử
```

---

## 3. Visual QA & Performance Criteria

- **Render Performance**: Duy trì $\ge 55\text{ FPS}$ trong suốt chu kỳ wave animation.
- **Accessibility & Font Scaling**: Không bị overflow (0 sọc vàng đen) khi text scale đạt $1.5\times$.
- **Memory Safety**: `AnimationController` phải được `dispose()` khi unmount khỏi widget tree (0 memory leak).
