# Biên Bản Công Bố Phát Hành (Release Notes) — AstroBite v1.0.0

- **Sản phẩm**: AstroBite — AI Food Scanner & Macro Tracker
- **Phiên bản phát hành**: `v1.0.0` (MVP Commercial Release)
- **Ngày phát hành**: 2026-09-18
- **Ký duyệt Gate 6**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Tình trạng kiểm thử**: **94/94 tests PASSED (100%)**, `flutter analyze`: **0 issues**

---

## 🚀 1. Điểm Nhấn Phiên Bản (Release Highlights)

Phiên bản `v1.0.0` đánh dấu cột mốc hoàn thiện đầu tiên của AstroBite với đầy đủ 5 tính năng cốt lõi được xây dựng theo chuẩn kiến trúc Feature-First Clean Architecture, Riverpod Notifier, AutoRoute và ngôn ngữ thiết kế Celestial Dark UI:

1. **`FEAT-01` Authentication & Onboarding**:
   - Đăng nhập bảo mật qua Email / Mật khẩu và Google Sign-In.
   - Luồng chào mừng (Onboarding) thu thập chỉ số cá nhân, bảo vệ bởi Firebase App Check.
   - Ký duyệt nghiệm thu: [`signoff-auth-login.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/05-test-execution-reports/release-sign-offs/signoff-auth-login.md).

2. **`FEAT-02` Gemini Food Scanner AI**:
   - Chụp/chọn ảnh đĩa thức ăn, tích hợp Gemini 2.0 Flash Vision AI.
   - Nhận diện món ăn, tự động tính toán Calo, Carbs, Fat, Protein với thời gian phản hồi < 2.5s.
   - Ký duyệt nghiệm thu: [`signoff-food-scanner.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/05-test-execution-reports/release-sign-offs/signoff-food-scanner.md).

3. **`FEAT-03` Diary & Manual Food Entry**:
   - Quản lý nhật ký 4 bữa ăn trong ngày (Sáng, Trưa, Tối, Bữa phụ).
   - Tra cứu danh bạ thực phẩm có sẵn, slider điều chỉnh khối lượng gram động, thêm món tùy chỉnh (Custom Food Sheet).
   - Ký duyệt nghiệm thu: [`signoff-manual-entry.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/05-test-execution-reports/release-sign-offs/signoff-manual-entry.md).

4. **`FEAT-04` Nutrition Analytics & Trends**:
   - Biểu đồ xu hướng calo nạp vào theo 7 ngày / 30 ngày sử dụng FL Chart.
   - Biểu đồ theo dõi biến động cân nặng.
   - Tối ưu hiệu năng FPS >= 55 với `RepaintBoundary` cô lập layer render (`RSK-001 Resolved`).
   - Ký duyệt nghiệm thu: [`signoff-analytics.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/05-test-execution-reports/release-sign-offs/signoff-analytics.md).

5. **`FEAT-05` User Profile & Personalized Goals**:
   - Tự động tính toán chỉ số BMR (Mifflin-St Jeor) và TDEE theo thể trạng và mức độ vận động.
   - Quản lý hồ sơ cá nhân và cấu hình API Key dự phòng (Custom Gemini Key Dialog).
   - Ký duyệt nghiệm thu: [`signoff-profile.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/05-test-execution-reports/release-sign-offs/signoff-profile.md).

---

## 🛡️ 2. Bảng Phán Quyết Nghiệm Thu 6 Cổng (6-Gate Sign-Off Matrix)

| Cổng Chất Lượng | Trách Nhiệm | Tiêu Chí Đánh Giá | Kết Quả |
| :--- | :--- | :--- | :---: |
| **Gate 1: PRD & BDD** | `business-analyst` & `product-owner` | 100% User Stories có kịch bản Given-When-Then, PO ký duyệt | ✅ **PASSED** |
| **Gate 2: QA Design** | `qa-tester` | Ma trận truy vết Testcases phủ 100% User Stories | ✅ **PASSED** |
| **Gate 3: Flutter Dev** | `flutter-expert` | Feature-First Clean Architecture, Riverpod, Celestial UI | ✅ **PASSED** |
| **Gate 4: Ponytail Review** | `code-reviewer` | Loại bỏ over-engineering, RepaintBoundary, "Lean already. Ship." | ✅ **PASSED** |
| **Gate 5: QA Verification** | `qa-tester` | 94/94 automated tests passed, FPS >= 55, 0 bug S1/S2 | ✅ **PASSED** |
| **Gate 6: Release Gate** | `product-owner` & `project-manager` | Đóng Sprint 01, gắn Tag `v1.0.0`, cập nhật Roadmap | ✅ **PASSED** |

---

## 📦 3. Lệnh Phát Hành (Release Command)
```bash
git tag -a v1.0.0 -m "Release v1.0.0: MVP Commercial Release for AstroBite"
```
