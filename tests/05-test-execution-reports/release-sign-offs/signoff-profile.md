# Biên Bản Nghiệm Thu Kiểm Thử (QA Sign-Off Report)

- **Tính năng**: Hồ Sơ Người Dùng & Chỉ Số BMR/TDEE (User Profile & Goals)
- **Mã tính năng**: `FEAT-05-PROFILE`
- **Phiên bản**: `v1.0.0`
- **Thời gian thực hiện**: 2026-09-18
- **QA Lead**: Sub-Agent QA Tester
- **Trạng thái**: **PASSED & APPROVED**

---

## 1. Phạm Vi Kiểm Thử (Testing Scope)

- **Mô tả kiểm thử**:
  - `TSK-PRO-02`: Kiểm thử thuật toán tính BMR (Mifflin-St Jeor) cho cả nam và nữ, hệ số vận động TDEE (sedentary, moderate, active).
  - Kiểm thử render thẻ chỉ số năng lượng `BmrTdeeCard` và widget `ProfilePage`.
  - Xác thực cập nhật dữ liệu qua StreamProvider và hiển thị email/thể trạng người dùng.

- **Automated Test Cases Phủ Định**:
  - `test/features/profile/domain/user_profile_test.dart` (3 unit tests: Male BMR/TDEE, Female BMR/TDEE, Default profile).
  - `test/features/profile/presentation/widgets/bmr_tdee_card_test.dart` (1 test: BMR & TDEE rounded values and labels).
  - `test/features/profile/presentation/pages/profile_page_test.dart` (1 test: Integration page rendering with stream provider).

---

## 2. Kết Quả Kiểm Thử Tự Động (Automated Test Execution)

| Nhóm Kiểm Thử | File Test | Số Lượng Test | Kết Quả |
| :--- | :--- | :---: | :---: |
| **UserProfile Domain Unit Tests** | `test/features/profile/domain/user_profile_test.dart` | 3 tests | **PASS (100%)** |
| **BmrTdeeCard Widget Test** | `test/features/profile/presentation/widgets/bmr_tdee_card_test.dart` | 1 test | **PASS (100%)** |
| **ProfilePage Widget Test** | `test/features/profile/presentation/pages/profile_page_test.dart` | 1 test | **PASS (100%)** |
| **Toàn Bộ Dự Án AstroBite** | `flutter test` | 94 tests | **PASS (100%)** |

### Kết Quả Static Analysis:
```bash
flutter analyze
# Output: Analyzing AstroBite...
# No issues found! (0 errors, 0 warnings)
```

---

## 3. Kiểm Thử Phi Chức Năng (Non-Functional Checks)

- **Độ chính xác tính toán dinh dưỡng**: Sai số công thức tính BMR/TDEE đạt `< 0.01 kcal`.
- **Celestial Dark UI Tokens**:
  - BMR Highlight: `AppColors.primary` (`#1A73E8`).
  - TDEE Highlight: `AppColors.tertiary` (`#FFD700`).
  - Thẻ nền kính mờ: `GlassCard` với `BackdropFilter` và bo góc chuẩn.

---

## 4. Kết Luận & Quyết Định Nghiệm Thu (Sign-Off Verdict)

- **Số lỗi nghiêm trọng (S1/S2)**: **0**
- **Phán quyết Gate 5**: ✅ **ĐẠT TIÊU CHUẨN NGHIỆM THU (APPROVED)**.
- Đủ điều kiện bàn giao sang Gate 6 để Sub-Agent PO và PM tiến hành đóng gói phát hành v1.0.0.
