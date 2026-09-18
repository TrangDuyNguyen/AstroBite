# Quản Trị Lộ Trình Sản Phẩm (Product Roadmap Governance)

> Thư mục này do **Sub-Agent Product Owner (PO)** trực tiếp quản lý và sở hữu. Đây là nguồn chân lý duy nhất (Single Source of Truth) về tầm nhìn dài hạn, danh mục Epics, mức độ ưu tiên MoSCoW và lộ trình phát hành của ứng dụng AstroBite.

---

## 📁 Cấu Trúc Tài Liệu Trong Thư Mục

1. **[`product-roadmap.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/00-roadmap/product-roadmap.md)**:
   - Bản đồ Lộ trình 3 Chân trời (**Now - Next - Later**).
   - Xác định rõ mục tiêu của từng phiên bản phát hành (`v1.0.0`, `v1.1.0`, `v1.2.0+`).
   - Cập nhật định kỳ khi các tính năng vượt qua Gate 6.

2. **[`epics-backlog.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/00-roadmap/epics-backlog.md)**:
   - Danh mục toàn bộ các Epics chức năng lớn (`EPIC-01` đến `EPIC-07`).
   - Đánh giá phân loại theo khung **MoSCoW**: Must-have (M), Should-have (S), Could-have (C), Won't-have (W).
   - Ánh xạ trực tiếp sang các thư mục PRD trong `docs/03-prd-features/`.

---

## 🧭 Quy Chuẩn Vận Hành Của Sub-Agent PO
- **Cập nhật trạng thái**: Khi một tính năng vượt qua Gate 6 (Release Gate) và được PO ký duyệt, PO sẽ chuyển trạng thái của Epic/Feature từ `In Progress` sang `Completed (vX.Y.Z)`.
- **Thêm Epic mới**: Bắt buộc sử dụng mẫu chuẩn [`docs/templates/template-epic.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/templates/template-epic.md).
- **Phân định MoSCoW**:
  - Không xếp quá 60% tổng dung lượng Sprint vào nhóm Must-have.
  - Phải có tiêu chuẩn đo lường (OKRs) rõ ràng cho từng Epic trước khi đưa vào chân trời **NOW**.
