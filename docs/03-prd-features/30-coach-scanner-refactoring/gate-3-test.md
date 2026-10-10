# Master Test Plan: AI Coach & Scan Review (Gate 3)

- **Feature**: `FEAT-S23-COACH-SCANNER`
- **Sub-Agent**: `qa-tester` ("The Paranoid Inquisitor")
- **Sign-Off**: 🟢 **Gate 3 Approved**

---

## 🧪 1. Ma Trận Kiểm Thử Tự Động & Hồi Quy (Regression Matrix)

| Test ID | Phân Hệ | File Kiểm Thử | Mục Tiêu & Kịch Bản Kiểm Thử |
| :--- | :--- | :--- | :--- |
| **`TC-COACH-01`** | Coach | `coach_page_test.dart` | Render tiêu đề, bong bóng chat, nút input và disclaimer. |
| **`TC-COACH-02`** | Coach | `coach_page_test.dart` | Gửi tin nhắn thành công, hiển thị typing indicator và phản hồi AI. |
| **`TC-COACH-03`** | Coach | `coach_v2_features_test.dart` | Hiển thị holographic 1-Tap meal suggestion card và trigger log. |
| **`TC-COACH-04`** | Coach | `coach_v2_features_test.dart` | Xử lý lỗi kết nối AI, fallback an toàn và thông báo lỗi. |
| **`TC-SCAN-01`** | Scanner | `scan_review_page_test.dart` | Hiển thị Hero card, tên món, độ tin cậy và thanh macro radial gauge. |
| **`TC-SCAN-02`** | Scanner | `scan_review_page_test.dart` | Tinh chỉnh gram món ăn qua Quick Steppers (+50g, 1 bát, 1 đĩa). |
| **`TC-SCAN-03`** | Scanner | `scan_review_page_test.dart` | Quét đa món (Multi-dish), chỉnh từng món và xóa món phụ. |
| **`TC-SCAN-04`** | Scanner | `scan_review_page_test.dart` | Nhấn nút Lưu và kiểm tra ghi nhận vào FoodLogRepository. |

---

## 🎯 2. Tiêu Chuẩn Nghiệm Thu Cứng (Quality Gate 6 Entry Criteria)
- **Zero Regression**: 100% của 320 tests hiện có phải tiếp tục PASS.
- **Zero Static Issues**: `flutter analyze` 0 warnings, 0 errors.
- **File Length Hard Cap**: `coach_page.dart` < 350 dòng, `scan_review_page.dart` < 350 dòng, 0 sub-widget > 250 dòng.
