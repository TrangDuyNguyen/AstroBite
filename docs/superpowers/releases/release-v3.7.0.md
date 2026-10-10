# Release Notes: AstroBite v3.7.0 — Auth & Onboarding Flow Clean Architecture (Sprint 27)

> **Ngày phát hành**: 2026-10-10  
> **Chủ trì phát hành**: Hội Đồng Tối Cao (PO, PM, Tech Lead & Security Auditor)  
> **Trạng thái**: 🚀 **RELEASED & VERIFIED (13/13 Story Points)**

---

## 🌟 Điểm Nhấn Phiên Bản (Highlights)

1. **Giải Phẫu Triệt Để 4 God Files Phân Hệ Auth**:
   - `clay_3d_food_art.dart`: **762 dòng ➔ 84 dòng (-89.0%)**
   - `onboarding_page.dart`: **677 dòng ➔ 166 dòng (-75.5%)**
   - `splash_page.dart`: **651 dòng ➔ 241 dòng (-63.0%)**
   - `login_page.dart`: **505 dòng ➔ 204 dòng (-59.6%)**
2. **Loại Bỏ Hoàn Toàn Nguy Cơ Vượt Ngưỡng Hard Cap (> 500 dòng)**:
   - Toàn bộ phân hệ Auth & Onboarding hiện không còn bất kỳ file nào vượt quá 350 dòng.
   - Số file vi phạm Hard Cap trên toàn bộ repository giảm từ **6 files** xuống chỉ còn **2 files** (thuộc phân hệ Tracker).
3. **12 Sub-widgets Mới Theo Chuẩn Single Responsibility Principle**:
   - Các CustomPainters đồ họa 3D được tách biệt: trái cây/bánh ngọt vs món ăn/đồ uống.
   - Các bước khảo sát Onboarding được module hóa thành các sub-steps độc lập.
   - Splash screen & Login screen tinh giản còn dưới 250 dòng.
4. **Đảm Bảo 100% Xanh**:
   - `322 / 322 tests passed (100%)`.
   - `flutter analyze` 0 issues.
   - 0 memory leak, 0 UI regression.
