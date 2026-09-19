# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 03
- **Phiên bản mục tiêu**: `v1.2.0`
- **Thời gian Sprint**: 19/09/2026 – 03/10/2026
- **Trạng thái Sprint**: 🟢 **Hoàn Tất & Đã Phát Hành (Released v1.2.0)**
- **Tổng Story Points**: 21 SP

---

## 🎯 Mục Tiêu Sprint 03

Chuyển đổi AstroBite từ ứng dụng ghi chép dinh dưỡng thụ động sang **Trợ lý AI dinh dưỡng chủ động** (Proactive AI Nutrition Coach):
1. **EPIC-07** Smart Realtime AI Coach — Chat hội thoại với Gemini AI (Must-have, 13 SP)
2. **EPIC-10** Apple Health / Health Connect Integration — Kết nối thiết bị đeo (Should-have, 8 SP)

---

## 📋 Bảng Kanban Trực Quan

### 1. 📝 TODO — [0 SP]
*(Toàn bộ task đã hoàn thành)*

### 2. ⚡ IN PROGRESS — [0 SP]
*(Không còn tác vụ đang chạy)*

### 3. 🔍 IN REVIEW & VERIFY — [0 SP]
*(Gate 5 Review & Gate 6 QA Verification đã hoàn tất 100%)*

### 4. 🏁 DONE — [21 SP]

| Mã Task | Feature / Epic | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---:|
| `TSK-CHAT-01` | `EPIC-07` AI Coach | **G1** | Soạn PRD & BDD cho AI Chat Coach | `business-analyst` | 2 | 🟢 Done |
| `TSK-CHAT-02` | `EPIC-07` AI Coach | **G2** | Thiết kế UI Chat Screen: Bubble, typing indicator, Quick Actions | `ui-ux-designer` | 2 | 🟢 Done |
| `TSK-CHAT-03` | `EPIC-07` AI Coach | **G3** | Manual TCs & BDD Gherkin cho hội thoại AI | `qa-tester` | 1 | 🟢 Done |
| `TSK-CHAT-04` | `EPIC-07` AI Coach | **G4** | Triển khai `features/coach/` — Domain, Data, Presentation | `flutter-expert` | 5 | 🟢 Done |
| `TSK-CHAT-05` | `EPIC-07` AI Coach | **G5** | Ponytail Code Review cho chat feature | `code-reviewer` | 1 | 🟢 Done |
| `TSK-CHAT-06` | `EPIC-07` AI Coach | **G6** | Automated test suite + integration test | `qa-tester` | 2 | 🟢 Done |
| `TSK-HLTH-01` | `EPIC-10` Health | **G1** | Soạn PRD & BDD kết nối 2 chiều Health Platform | `business-analyst` | 1 | 🟢 Done |
| `TSK-HLTH-02` | `EPIC-10` Health | **G2** | Thiết kế UI Health Dashboard & biểu đồ cân bằng năng lượng | `ui-ux-designer` | 1 | 🟢 Done |
| `TSK-HLTH-03` | `EPIC-10` Health | **G3** | Manual TCs & BDD cho đồng bộ dữ liệu & quyền truy cập | `qa-tester` | 1 | 🟢 Done |
| `TSK-HLTH-04` | `EPIC-10` Health | **G4** | Triển khai `features/health/` — Domain, Data, Presentation | `flutter-expert` | 3 | 🟢 Done |
| `TSK-HLTH-05` | `EPIC-10` Health | **G5** | Ponytail Code Review cho health integration | `code-reviewer` | 1 | 🟢 Done |
| `TSK-HLTH-06` | `EPIC-10` Health | **G6** | Automated test suite + kiểm thử quyền platform | `qa-tester` | 1 | 🟢 Done |

---

## 📊 Burndown Sprint 03

| Ngày | SP Còn Lại | Ghi Chú |
|:---:|:---:|:---|
| 19/09 | 21 | Khởi động Sprint 03 |
| 19/09 | 0 | Hoàn tất 7 Cổng (Gate 1 - Gate 7), 118/118 tests Pass, phát hành v1.2.0 |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 02 — AstroBite v1.1.0 Dinh Dưỡng Nâng Cao & Trải Nghiệm Offline (Hoàn tất 18/09/2026)
- **Mục tiêu**: Mở rộng Gemini Vision AI nhận diện đa món (`FEAT-06`), kiến tạo Offline-First Cache & Sync (`FEAT-07`), và theo dõi vi chất dinh dưỡng (`FEAT-08`).
- **Kết quả**: **26 / 26 SP (100% Passed)** — 7-Gate SOP hoàn tất toàn bộ chuỗi Gates 1→7.
- **Kiểm thử**: 110/110 tests passed (100%), `flutter analyze` 0 issues, 0 bugs S1-S4.
- **Ponytail Review**: -121 dòng dead code pruned, verdict: `Lean already. Ship.`
- **Git Tag**: [`v1.1.0`](file:///Users/nguyenduytrang/flutter_project/AstroBite)
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.1.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.1.0.md)
- **Biên bản QA Sign-Off**: [`tests/05-test-execution-reports/release-sign-offs/signoff-sprint-02.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/05-test-execution-reports/release-sign-offs/signoff-sprint-02.md)

### 🟢 Sprint 01 — AstroBite v1.0.0 MVP Release (Hoàn tất 18/09/2026)
- **Mục tiêu**: Hoàn tất kiểm thử, rà soát Ponytail và ký nghiệm thu Gate 5 cho Analytics & Profile, đóng gói v1.0.0.
- **Kết quả**: **13 / 13 SP (100% Passed)**, 94/94 tests tự động passed, 0 lỗi static analysis.
- **Git Tag**: [`v1.0.0`](file:///Users/nguyenduytrang/flutter_project/AstroBite)
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.0.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.0.0.md)
