# Ma Trận Phân Nhiệm Các Bên Liên Quan (Stakeholder & RACI Matrix)

## 1. Danh Sách Các Bên Liên Quan (Stakeholders)
- **Product Owner (PO)**: Định hướng chiến lược, phê duyệt roadmap và độ ưu tiên tính năng.
- **Business Analyst (BA)**: Thu thập yêu cầu, viết PRD, User Story, quản lý thay đổi nghiệp vụ.
- **UI/UX Designer**: Thiết kế giao diện Celestial Dark UI trên Figma, xây dựng Design System tokens.
- **Frontend Flutter Developer (Dev)**: Triển khai ứng dụng theo Clean Architecture, Riverpod, AutoRoute.
- **Quality Assurance / Tester (QA)**: Lập Master Test Plan, viết testcases, thực thi kiểm thử thủ công và automation BDD.
- **AI / Cloud Engineer**: Cấu hình Gemini API, Firebase Firestore, Firebase App Check, Cloud Functions.

---

## 2. Ma Trận RACI (Responsible, Accountable, Consulted, Informed)

| Hạng mục công việc | PO | BA | Designer | Dev FE | QA | AI/Cloud |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Xác định Tầm nhìn & Roadmap** | **A** | R | C | I | I | C |
| **Viết PRD & Acceptance Criteria** | A | **R** | C | C | C | I |
| **Thiết kế UI/UX & Wireframe** | I | C | **R / A** | C | I | I |
| **Xây dựng Mã nguồn Flutter FE** | I | I | C | **R / A** | C | C |
| **Kịch bản Kiểm thử & Nghiệm thu** | A | C | I | I | **R** | I |
| **Cấu hình Gemini AI & Firebase** | I | I | I | C | I | **R / A** |
| **Sign-off Release App lên Store** | **A** | C | I | C | R | C |

*Ghi chú: R = Responsible (Người thực hiện), A = Accountable (Người chịu trách nhiệm chính), C = Consulted (Người được tham vấn), I = Informed (Người được thông báo)*.
