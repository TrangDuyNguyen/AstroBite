# Kho Tài Liệu Quản Trị Sản Phẩm & Nghiệp Vụ — AstroBite

Kho tài liệu này lưu trữ toàn bộ Lộ trình sản phẩm (Product Roadmap), Kế hoạch Sprint (Sprint & WBS Tasks), Đặc tả nghiệp vụ (PRD/BDD), Từ điển dữ liệu và Quy chuẩn vận hành của dự án **AstroBite**, tuân theo mô hình **Agile Docs-as-Code** và hệ thống **6 Sub-Agents Độc Lập**.

---

## 📌 Cấu Trúc Thư Mục Quản Trị

```
docs/
├── 00-roadmap/              # [SUB-AGENT PO] Lộ trình 3 Chân trời (Now-Next-Later) & Danh mục Epics MoSCoW
├── 00-project-management/   # [SUB-AGENT PM] Kế hoạch Sprint Backlog, Ma trận WBS 6 Cổng, Risk & Blocker Log
├── 01-overview/             # Tầm nhìn sản phẩm, Ma trận RACI Đa Sub-Agent, Quy trình Feature Lifecycle SOP
├── 02-business-rules/       # Quy tắc dinh dưỡng (BMR/TDEE), chính sách AI Gemini 2.0 Flash, bảo mật App Check
├── 03-prd-features/         # PRD, User Stories BDD và UI/UX Screen Specs theo từng Feature
├── 04-specifications/       # Từ điển dữ liệu (Data Dictionary), đặc tả tích hợp API
├── 05-change-management/    # Bảng theo dõi các yêu cầu thay đổi (Change Request Log)
├── superpowers/specs/       # Hồ sơ đặc tả kiến trúc kỹ thuật & thiết kế hệ thống
└── templates/               # Mẫu chuẩn: Epic, Roadmap Item, Sprint, WBS Task, PRD, User Story
```

---

## 🔗 Liên Kết Truy Vết (Traceability & Four-Eyes Governance)

Mọi yêu cầu phát triển trong AstroBite đều được liên kết chặt chẽ qua 6 Cổng:
- **Chiến lược & Lộ trình**: `docs/00-roadmap/` do **Sub-Agent PO** định hình và phê duyệt.
- **Kế hoạch & WBS Task**: `docs/00-project-management/` do **Sub-Agent PM** điều phối và gán điểm Fibonacci SP.
- **Nghiệp vụ (PRD & BDD)**: `docs/03-prd-features/` do **Sub-Agent BA** soạn thảo, **PO** ký duyệt Gate 1.
- **Kiểm thử (Manual & BDD)**: `tests/` do **Sub-Agent QA** thiết kế (Gate 2) và nghiệm thu (Gate 5).
- **Mã nguồn (Clean Architecture)**: `lib/features/` do **Sub-Agent Dev FE** triển khai (Gate 3), **Sub-Agent Reviewer** rà soát Ponytail (Gate 4).
- **Phát hành (Release)**: **Sub-Agent PO & PM** nghiệm thu và phát hành (Gate 6).

---

## ✍️ Quy Định Vận Hành Cốt Lõi
1. Mọi tính năng mới bắt buộc phải xuất phát từ một Epic trong `docs/00-roadmap/epics-backlog.md` có phân loại MoSCoW.
2. Không Sub-Agent nào được tự duyệt sản phẩm của chính mình (Nguyên tắc Four-Eyes).
3. Toàn bộ tài liệu phải lưu trữ dưới định dạng Markdown trực tiếp trong Git, cam kết commit với thông điệp chuẩn mực.
