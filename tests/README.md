# Kho Kịch Bản Kiểm Thử & Quản Trị Chất Lượng (QA & Test Engineering) — AstroBite

Kho lưu trữ này chứa toàn bộ kế hoạch kiểm thử (Test Strategy & Master Test Plan), bộ kịch bản kiểm thử thủ công (Manual Testcases), kịch bản BDD chuẩn Gherkin, kiểm thử phi chức năng và báo cáo nghiệm thu chất lượng cho ứng dụng **AstroBite**, tuân thủ tiêu chuẩn **ISTQB & Agile Testing**.

---

## 📌 Cấu Trúc Kho Kiểm Thử

```
tests/
├── 01-test-strategy-plan/       # Master Test Plan, ma trận thiết bị kiểm thử, phân loại Severity lỗi
├── 02-manual-testcases/         # Testcase kiểm thử thủ công phân theo từng Feature (Khớp 1:1 với BA)
├── 03-bdd-gherkin-scenarios/    # Kịch bản BDD (.feature) cú pháp Given-When-Then
├── 04-non-functional-tests/     # Kế hoạch test hiệu năng, bảo mật, offline mode và UI Consistency
├── 05-test-execution-reports/   # Báo cáo kết quả test theo Sprint và biên bản nghiệm thu Release
└── templates/                   # Mẫu Testcase, Bug Report, Release Checklist chuẩn hóa
```

---

## 🔗 Liên Kết Truy Vết (Traceability)
- Mọi testcase trong `02-manual-testcases/` đều tham chiếu trực tiếp đến `docs/03-prd-features/` của BA.
- Kịch bản BDD trong `03-bdd-gherkin-scenarios/` là nguồn kịch bản cho `frontend/integration_test/` của đội ngũ phát triển.
