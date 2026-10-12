# Kế Hoạch Kiểm Thử Gate 3 (Master Test Plan & BDD Gherkin) — Sprint 32

- **Mã tính năng**: `FEAT-S32-BARCODE-OCR`
- **Tác giả**: Sub-Agent QA Tester (*The Paranoid Inquisitor*)
- **Phê duyệt**: Sub-Agent Tech Lead & Sub-Agent PO
- **Trạng thái**: 🟢 **GATE 3 APPROVED (Zero-Tolerance Checklist Passed)**

---

## 1. Ma Trận Bao Phủ Kiểm Thử (Traceability Matrix 100%)

| User Story | Kịch Bản Kiểm Thử | Loại Test | Mục Tiêu Nghiệm Thu |
| :--- | :--- | :---: | :--- |
| **US-01** | Chuyển đổi tab "Món ăn" ⇄ "Đóng gói" | Widget Test | Tỷ lệ khung ngắm cập nhật tức thì < 50ms, không rebuild camera controller |
| **US-02** | Chụp nhãn Nutrition Facts chuẩn | Integration / Mock Test | Bóc tách chính xác Calo, Carbs, Fat, Protein, Sodium |
| **US-02 (Neg)** | Chụp nhãn bị nhòe / che khuất | Edge Case Test | Hiển thị Error Sheet mềm mại, 0 crash, cho phép chụp lại |
| **US-03** | Quét mã vạch có trong database | Unit / Mock Test | Tra cứu `BarcodeLookupService` trả về đúng tên sản phẩm và serving size |
| **US-03 (Neg)**| Quét mã vạch lạ không có trong database | Fallback Test | Fallback sang Gemini Vision text OCR đọc tên nhãn mác |

---

## 2. Kịch Bản Kiểm Thử BDD Gherkin (.feature)

```gherkin
Feature: Barcode and Nutrition Label OCR Scanner

  Scenario: Switching scan mode updates viewfinder layout
    Given the user is on the CameraPage
    When the user taps on the "Packaged" mode pill
    Then the viewfinder switches to the rectangular smart bounding box
    And the guidance text says "Align nutrition table or barcode within frame"

  Scenario: Successfully parsing nutrition facts from packaged food image
    Given the camera is in "Packaged" mode
    And the image contains a clear nutrition label with 150 kcal and 20g protein
    When the image analysis completes
    Then the app navigates to ScanReviewPage
    And the displayed calories equal 150
    And the displayed protein equals 20.0g

  Scenario: Graceful fallback when barcode is not found in database
    Given the user scanned a valid barcode "8930000000000"
    When the barcode database lookup returns 404 not found
    Then the system triggers Gemini Vision OCR on the package label
    And the user sees the parsed dish/product review without fatal errors
```

---

## 3. Tiêu Chí Nghiệm Thu Gate 6 (Không Du Di)
1. **Automated Tests**: 100% test suite phải pass (Target: >= 335 tests pass).
2. **Static Analysis**: `flutter analyze` 0 errors, 0 warnings.
3. **RAM & Performance**: 0 memory leak sau 10 lần chụp và chuyển đổi mode.
4. **Localization**: Hỗ trợ 100% song ngữ VI/EN cho các chuỗi mới.
