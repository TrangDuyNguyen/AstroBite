# Regression Test Plan: Sprint 25 — Camera Scanner Pipeline Refactoring

> **Tác giả**: Sub-Agent QA/QC Lead (*The Paranoid Inquisitor*)  
> **Trạng thái**: 🟢 **READY FOR IMPLEMENTATION (Gate 3 Test Plan)**

---

## 1. Phạm Vi Kiểm Thử (Test Scope)

1. **Scanner Test Suite**:
   - `test/features/scanner/presentation/pages/camera_page_test.dart`: Đảm bảo `CameraPage` render đầy đủ status badge, viewfinder reticle, shutter button, gallery picker và manual entry button.
   - `test/features/scanner/domain/vietnamese_culinary_decomposition_test.dart` (6 tests PASS).
   - `test/features/scanner/data/scan_result_dto_test.dart` (2 tests PASS).
   - `test/features/scanner/presentation/pages/scan_review_page_test.dart` (5 tests PASS).
   - `test/features/scanner/presentation/widgets/broth_topping_widgets_test.dart` (18 tests PASS).
2. **Kích Thước Tệp Tin & Mã Nguồn**:
   - `camera_page.dart`: $< 350$ dòng.
   - `scanning_viewfinder.dart`: $< 350$ dòng (mục tiêu $< 200$ dòng).
   - `scripts/check_file_length.sh`: Không phát sinh lỗi Hard Cap mới.
   - `flutter analyze`: 0 issues found.
