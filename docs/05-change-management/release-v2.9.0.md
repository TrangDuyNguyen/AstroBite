# 🚀 Release Notes: AstroBite v2.9.0 (Multi-Region Food Culture Intelligence)

**Ngày phát hành**: 2026-10-05  
**Sprint**: Sprint 19  
**Version**: `v2.9.0`  
**Chịu trách nhiệm**: Hội Đồng Phát Hành Tối Cao (PO, PM, Tech Lead, QA Lead & Security Auditor)  
**Trạng thái**: 🟢 **Gate 7 Released (Production-Ready)**

---

## 🌟 Có Gì Mới Trong Phiên Bản v2.9.0?

Phiên bản **v2.9.0** triển khai thành công `EPIC-GLOBAL: Multi-Region Food Culture Intelligence`, đưa AstroBite trở thành ứng dụng theo dõi dinh dưỡng đầu tiên hiểu sâu sắc văn hóa ẩm thực Việt Nam và các món ăn đặc thù châu Á.

### 1. Trí Tuệ Thị Giác Bóc Tách Món Ăn Một Lượt (One-Pass Gemini Vision Decomposition)
- **Tách bạch nước dùng & cái**: Tự động nhận diện món nước (Phở, Bún bò, Hủ tiếu, Mì Quảng...) và bóc tách chính xác calo cũng như hàm lượng natri trong nước dùng (`broth_calories`, `broth_sodium_mg`).
- **Bóc tách topping món hỗn hợp**: Tự động bóc tách từng thành phần riêng lẻ của các đĩa cơm tấm, bún chả, bánh mì (`sub_items`: sườn nướng, chả trứng, bì, mỡ hành, pate, xá xíu...).
- **Không gia tăng độ trễ AI**: Sử dụng kỹ thuật Prompt Engineering tinh gọn trong 1 lượt gọi duy nhất (One-Pass), giữ độ trễ trung bình $\sim 1.85s$ ($\le 2.2s$ SLA), chi phí không đổi.

### 2. Công Tắc 1 Chạm "Ăn Nước / Chỉ Ăn Cái" (Interactive Broth Toggle)
- **Chạm chuyển trạng thái tức thì**: `[🍜 Ăn cả nước (+190 kcal)]` ⟷ `[🥢 Chỉ ăn cái (-190 kcal)]`.
- **Cứu tinh cho người giảm cân & người cao huyết áp**: Khi người dùng không húp nước béo của phở/bún, hệ thống lập tức trừ bớt từ 150–220 kcal và giảm 1,200–1,500mg Natri nguy hại.
- **Tương tác Claymorphic Duolingo**: Hiệu ứng đàn hồi tactile squash (`0.98`), màu Pastel dịu mắt, phản hồi xúc giác mượt mà.

### 3. Danh Sách Kiểm Topping Trực Quan (Topping Checklist Wrap)
- **Cá nhân hóa bữa ăn theo thói quen thực tế**: Người dùng ăn Cơm tấm nhưng dặn người bán "không mỡ hành", "không chả trứng"? Chỉ cần chạm nhẹ vào chip để gạch bỏ.
- **Cập nhật dinh dưỡng theo thời gian thực**: Trừ chính xác calo và tỉ lệ Carbs/Protein/Fat của topping bị bỏ bớt ngay trên thanh dinh dưỡng `ChunkyMacroBar` và vòng tròn ngân sách calo.
- **Bảo toàn số học tuyệt đối (Zero-Drift & Non-Negative Clamp)**: Thuật toán bảo đảm giá trị không bao giờ bị âm hoặc trôi số khi chuyển đổi nhiều lần.

---

## 🛡️ Chữ Ký Nghiệm Thu (Quality Gates Passed)

- **Gate 0 (Kiến Trúc & Spikes)**: ADR `ADR-S19-GLOBAL-CUISINE` & Superpowers Spec được Tech Lead và PO phê chuẩn.
- **Gate 1 (PRD & BDD)**: Đạt chuẩn 100% User Stories BDD Given-When-Then, Data Dictionary đồng bộ.
- **Gate 2 (UI/UX Design)**: Hệ màu Claymorphic × Duolingo 2D/3D tuân thủ nghiêm ngặt bảng màu `AppColors`.
- **Gate 3 (Test Design)**: 10 kịch bản kiểm thử biên BVA và kiểm thử phá hoại hoàn chỉnh.
- **Gate 4 (Code Craftsman)**: Feature-First Clean Architecture, Riverpod 2.x, 0 over-engineering.
- **Gate 5 (Code Review - Ponytail)**: Reviewer rà soát git diff, xác nhận đạt chuẩn `Lean already. Ship.`
- **Gate 6 (QA & Verification)**: 
  - `flutter analyze`: **0 lỗi, 0 cảnh báo**.
  - `flutter test`: **266/266 bài test tự động vượt qua 100%**.
- **Gate 6.5 (Security Audit)**: Rà soát biên tin cậy JSON, triệt tiêu nguy cơ Prompt Injection và Poisoning.
- **Gate 7 (Release Gate)**: Hội đồng PO, PM, Tech Lead và Security Auditor ký duyệt phát hành `v2.9.0`.
