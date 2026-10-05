# Kho Tài Liệu Quản Trị Sản Phẩm & Nghiệp Vụ — AstroBite

Kho tài liệu này lưu trữ toàn bộ Lộ trình sản phẩm (Product Roadmap), Kế hoạch Sprint (Sprint & WBS Tasks), Đặc tả nghiệp vụ (PRD/BDD), Từ điển dữ liệu và Quy chuẩn vận hành của dự án **AstroBite**, tuân theo mô hình **Agile Docs-as-Code** và hệ thống **9 Sub-Agents Độc Lập** vận hành qua **8 Cổng Chất Lượng (Quality Gates 0–7)**.

---

## 📌 Cấu Trúc Thư Mục Quản Trị

```
docs/
├── 00-roadmap/              # [SUB-AGENT PO] Lộ trình 3 Chân trời (Now-Next-Later) & Danh mục Epics MoSCoW
├── 00-project-management/   # [SUB-AGENT PM] Kế hoạch Sprint Backlog, Ma trận WBS 8 Cổng, Risk & Blocker Log
├── 01-overview/             # Tầm nhìn sản phẩm, Ma trận RACI Đa Sub-Agent, Quy trình 8-Gate Lifecycle SOP
├── 02-business-rules/       # Quy tắc dinh dưỡng (BMR/TDEE), chính sách AI Gemini 2.0 Flash, bảo mật App Check
├── 03-prd-features/         # PRD, User Stories BDD và UI/UX Screen Specs theo từng Feature
├── 04-specifications/       # Quyết định kiến trúc (ADR), Từ điển dữ liệu (Data Dictionary), đặc tả tích hợp API
├── 05-change-management/    # Bảng theo dõi các yêu cầu thay đổi (Change Request Log) & Release Notes
├── superpowers/specs/       # Hồ sơ đặc tả kiến trúc kỹ thuật & thiết kế hệ thống
└── templates/               # Mẫu chuẩn: Epic, Roadmap Item, Sprint, WBS Task, PRD, User Story
```

---

## 🔗 Liên Kết Truy Vết (Traceability & Four-Eyes Governance)

Mọi yêu cầu phát triển trong AstroBite đều được liên kết chặt chẽ qua **8 Cổng**:
- **Gate 0 (Kiến trúc & Spikes)**: `docs/04-specifications/` & `docs/03-prd-features/*/adr-*.md` do **Tech Lead** thực hiện.
- **Gate 1 (Chiến lược & PRD/BDD)**: `docs/00-roadmap/` do **PO** phê duyệt; `docs/03-prd-features/` do **BA** soạn thảo, **PO & Tech Lead** đồng ký duyệt Feasibility.
- **Gate 2 (Thiết kế UI/UX)**: `docs/03-prd-features/*/ui-ux-design.md` do **UI/UX Designer** dựng qua Google Stitch & Flutter Preview.
- **Gate 3 (Kiểm thử & Test Plan)**: `docs/03-prd-features/*/gate-3-test.md` do **QA Tester** thiết kế Manual & BDD test cases.
- **Gate 4 (Mã nguồn Clean Architecture)**: `lib/features/` do **Dev FE/Native/Cloud** triển khai theo chuẩn Ponytail.
- **Gate 5 (Rà soát Ponytail & Docs Sync)**: Do **Reviewer** quét git diff code và đối soát cập nhật tài liệu.
- **Gate 6 (Nghiệm thu Thực chất)**: Do **QA Tester** chạy automated test suite 100% xanh, FPS >= 55, AI latency <= 2.5s.
- **Gate 6.5 (Bảo mật Zero-Trust)**: Do **Security Auditor** kiểm toán 6 pha Cloudflare & Mobile AppSec.
- **Gate 7 (Phát hành)**: Do **Hội đồng PO, PM, Tech Lead & Security Auditor** ký duyệt và đẩy lên Firebase App Distribution / Stores.

---

## ✍️ Quy Định Vận Hành Cốt Lõi (Zero Doc-Code Drift)

1. **Code đổi là Doc phải đổi (Backward Sync)**: Mọi thay đổi về tính năng, scope (ví dụ: làm Mock trước, dời Backend sang phase sau), API, data model BẮT BUỘC phải được cập nhật vào `docs/` ngay trong cùng commit.
2. **Minh bạch nhãn trạng thái (Feature State Badges)**: Phải gắn nhãn rõ ràng: `🟡 [Phase 1: Mock/In-Memory UI]`, `🔵 [Client-Only]`, hoặc `🟢 [Full-Stack E2E]`. Tuyệt đối cấm báo cáo "DONE" ảo.
3. **Nguyên tắc Four-Eyes**: Không Sub-Agent nào được tự duyệt sản phẩm của chính mình.
4. **Git-Centric Markdown**: Toàn bộ tài liệu được quản lý trực tiếp trong Git, bảo đảm Single Source of Truth cho toàn bộ dự án.
