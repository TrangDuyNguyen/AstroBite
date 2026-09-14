# Kho Tài Liệu Phân Tích Nghiệp Vụ (BA Documentation) — AstroBite

Kho tài liệu này lưu trữ toàn bộ các đặc tả yêu cầu kinh doanh (BRD), tài liệu đặc tả sản phẩm (PRD), từ điển dữ liệu và quy chuẩn nghiệp vụ cho ứng dụng **AstroBite**, tuân theo mô hình **Agile Docs-as-Code** và chuẩn **BABOK (Business Analysis Body of Knowledge)**.

---

## 📌 Cấu Trúc Tài Liệu

```
docs/
├── 01-overview/             # Tầm nhìn sản phẩm, ma trận phân quyền RACI, từ điển thuật ngữ
├── 02-business-rules/       # Quy tắc nghiệp vụ dinh dưỡng, chính sách AI Gemini, bảo mật
├── 03-prd-features/         # PRD, User Stories và UI/UX Screen Specs theo từng Feature
├── 04-specifications/       # Từ điển dữ liệu (Data Dictionary), đặc tả tích hợp API
├── 05-change-management/    # Bảng theo dõi các yêu cầu thay đổi (Change Request Log)
└── templates/               # Mẫu PRD, User Story, Change Request chuẩn hóa
```

---

## 🔗 Liên Kết Truy Vết (Traceability)

Mỗi User Story trong thư mục `03-prd-features/` đều tuân theo chuẩn BDD (Given - When - Then) và được ánh xạ trực tiếp sang:
- Kịch bản kiểm thử tại: `tests/02-manual-testcases/` và `tests/03-bdd-gherkin-scenarios/` (Submodule `astrobite-testcases`)
- Triển khai mã nguồn tại: `frontend/lib/features/` (Submodule `astrobite-frontend`)

---

## ✍️ Quy Định Đóng Góp Cho BA
1. Mọi tính năng mới bắt buộc phải có tài liệu PRD hoàn chỉnh trong `03-prd-features/<tên-feature>/`.
2. Định dạng Acceptance Criteria bắt buộc dùng cú pháp **Given - When - Then**.
3. Mọi thay đổi về thuật toán tính calo hoặc chính sách AI phải được ghi nhận vào `05-change-management/change-request-log.md`.
