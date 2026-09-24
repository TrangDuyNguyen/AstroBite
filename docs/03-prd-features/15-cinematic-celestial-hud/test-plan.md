# Kế Hoạch Kiểm Thử Toàn Diện (Gate 3 Master Test Plan)
## Tính năng: Đại Trùng Tu Giao Diện — Cinematic Celestial UI & Holographic AR HUD Scanner

- **Mã tính năng**: `FEAT-15`
- **Mã Epic**: `EPIC-17`
- **Phụ trách**: Sub-Agent QA Tester — *"The Paranoid Inquisitor"*
- **Trạng thái**: 🟢 **Ready for Gate 4 Implementation & Automated Verification**
- **Tham chiếu**: [`docs/03-prd-features/15-cinematic-celestial-hud/prd-cinematic-celestial-hud.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/15-cinematic-celestial-hud/prd-cinematic-celestial-hud.md) & [`docs/03-prd-features/15-cinematic-celestial-hud/ui-ux-design-spec.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/15-cinematic-celestial-hud/ui-ux-design-spec.md)

---

## 🧪 1. Ma Trận Test Cases Chức Năng & Visual (Manual & Widget TCs)

| Test ID | Hạng mục kiểm thử | Điều kiện tiên quyết & Thao tác | Kết quả kỳ vọng (Expected Result) | Mức độ |
| :--- | :--- | :--- | :--- | :---: |
| **TC-HUD-01** | AR HUD Top Bar Glassmorphism | Mở `CameraPage` | Header kính mờ hiển thị nút Back, title "AR Food Scanner" kèm phụ đề "Gemini Vision AI 2.0 • Active", nút Flash trợ sáng và Grid. | P0 |
| **TC-HUD-02** | AR HUD Corner Brackets & Reticle | Mở `CameraPage` khi camera hoạt động | Xuất hiện 4 góc ngắm kép viền Electric Blue `#1A73E8`, tâm ngắm tròn xoay mượt mà 60 FPS, vệt laser quét lên xuống. | P0 |
| **TC-HUD-03** | Telemetry & Focal Lock Badge | Mở `CameraPage` | Hiển thị tọa độ X/Y/Z/FPS và nhãn `[FOCAL LOCK: 98.4% CONFIDENCE]` có chấm tròn phát sáng xanh. | P1 |
| **TC-HUD-04** | Floating AI Tag | Sau khi quét ảnh thành công | Nhãn nổi kính mờ gắn trên món ăn hiển thị tên món, badge `[AI VERIFIED]` màu Vàng Gold, và lượng calo `450 kcal`. | P0 |
| **TC-BEN-01** | Holographic Bento Sheet Macro Triad | Mở `ScanReviewPage` | Hiển thị chính xác 3 cột Bento Macro với màu bất biến: 🔵 Carbs `#1A73E8`, 🟡 Protein `#FFD700`, 🩷 Fat `#FF69B4`. | P0 |
| **TC-BEN-02** | Hero Calorie & Radial Target Gauge | Mở `ScanReviewPage` | Calo hiển thị chữ to đậm kèm vòng tròn tiến độ tỏa sáng thể hiện % mục tiêu ngày (ví dụ: 21% của 2,100 kcal). | P0 |
| **TC-BEN-03** | Portion Steppers & Quick Chips | Bấm các chip `-50g`, `+50g`, `1 Bát`, `1 Đĩa` | Khẩu phần và calo tự động tính toán lại tức thì, chip đang chọn có viền phát sáng xanh `#1A73E8`. | P0 |
| **TC-BEN-04** | Sticky Primary CTA & Save Flow | Bấm nút *"Lưu vào Nhật ký"* ở đáy | Lưu bản ghi vào Firestore/Repository, hiển thị SnackBar thành công và điều hướng mượt mà về Home Cockpit. | P0 |
| **TC-PERF-01**| 60 FPS Animation & 0 Memory Leak | Mở và đóng camera 10 lần liên tục | Không drop frame (< 55 FPS), AnimationController được dispose hoàn toàn, không rò rỉ bộ nhớ. | P0 |

---

## 🥒 2. Kịch Bản BDD Gherkin (`.feature`)

```gherkin
Feature: Cinematic AR HUD Scanner & Holographic Nutrition Review
  As a health-conscious user
  I want a futuristic AR HUD camera viewfinder and a glanceable holographic nutrition sheet
  So that scanning meals feels magical, intuitive, and takes less than 1 second to comprehend.

  Scenario: User views AR HUD camera overlay with telemetry
    Given the user opens the food camera scanner
    Then the top bar displays "AR Food Scanner" with "Gemini Vision AI 2.0 • Active"
    And the viewfinder renders 4 double corner brackets in Electric Blue
    And the central holographic reticle rotates smoothly at 60 FPS
    And the telemetry badge displays "[FOCAL LOCK: 98.4% CONFIDENCE]"

  Scenario: User reviews scanned dish with Holographic Bento Macro Triad
    Given the camera has scanned a dish with 450 kcal
    When the Holographic Bento Sheet is displayed
    Then the hero calorie shows "450 kcal" with radial progress gauge
    And the Carbs pill displays in Electric Blue "#1A73E8"
    And the Protein pill displays in Gold "#FFD700"
    And the Fat pill displays in Hot Pink "#FF69B4"
    And the quick portion steppers allow 1-tap adjustment
    And the sticky bottom bar displays the primary CTA "Lưu vào Nhật ký"
```
