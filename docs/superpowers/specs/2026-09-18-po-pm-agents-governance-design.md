# Tài Liệu Đặc Tả Thiết Kế: Hệ Sinh Thái Đa Sub-Agent Độc Lập & Quản Trị Dự Án AstroBite

- **Dự án**: AstroBite (`astrobite`)
- **Tác giả**: Pair Programming (Antigravity & Product Team)
- **Ngày cập nhật**: 2026-09-18
- **Phiên bản**: v2.0.0 (Mở rộng: 100% Các Role Đều Là Sub-Agent Độc Lập)
- **Trạng thái**: Draft / In Review
- **Vị trí tài liệu**: `docs/superpowers/specs/2026-09-18-po-pm-agents-governance-design.md`

---

## 1. Bối Cảnh & Mục Tiêu (Executive Summary)

### 1.1. Bối cảnh
Dự án AstroBite đã phát triển qua giai đoạn khởi tạo ban đầu và hiện sở hữu 5 mô-đun chức năng lớn:
1. Xác thực & Nhập môn (`auth`)
2. Nhận diện đồ ăn thông minh qua Gemini 2.0 Flash Vision (`scanner`)
3. Nhật ký bữa ăn & Nhập dữ liệu thủ công (`tracker`)
4. Thống kê & Phân tích xu hướng calo/macro (`analytics`)
5. Hồ sơ cá nhân & Mục tiêu dinh dưỡng (`profile`)

Khi ứng dụng phát triển lớn với nhiều tính năng phức tạp, nếu để một Agent duy nhất kiêm nhiệm mọi việc sẽ dễ dẫn đến thiên vị, tự duyệt code cẩu thả, hoặc bỏ qua các tiêu chuẩn kiểm thử khắt khe. 

### 1.2. Mục tiêu thiết kế
1. **100% Các Role trong dự án đều là Sub-Agent Độc Lập**: Tách biệt rõ ràng 6 Sub-Agents chuyên trách:
   - `product-owner` (PO Sub-Agent)
   - `project-manager` (PM Sub-Agent)
   - `business-analyst` (BA Sub-Agent)
   - `qa-tester` (QA Sub-Agent)
   - `flutter-developer` (Dev FE Sub-Agent)
   - `code-reviewer` (Reviewer Sub-Agent)
2. **Nguyên tắc Kiểm Soát Chéo Khách Quan (Four-Eyes Principle / Checks & Balances)**: Loại bỏ triệt để xung đột lợi ích — Không một Sub-Agent nào được tự phê duyệt hoặc nghiệm thu sản phẩm do chính mình tạo ra.
3. **Quản trị Bằng Markdown Chuẩn Hóa**: Lưu trữ toàn bộ Lộ trình và Kế hoạch trực tiếp trong Git: `docs/00-roadmap/` (do PO sở hữu) và `docs/00-project-management/` (do PM sở hữu).
4. **Chuẩn hóa Phương pháp luận**: Khung ưu tiên **MoSCoW** cho PO, thang điểm **Fibonacci Story Points (1, 2, 3, 5, 8)** theo chu trình 6 Gates cho PM.
5. **Khảo sát & Khởi tạo Dữ liệu Thực tế**: Khảo sát 5 features hiện có, lập ngay **Product Roadmap (v1.0 -> v1.2)** và **Sprint 1 Backlog** kèm ma trận WBS thực tế.

---

## 2. Ma Trận 6 Sub-Agent Độc Lập & Cơ Chế Kiểm Soát Chéo

```
                       ┌─────────────────────────┐
                       │  Sub-Agent PO (Product) │
                       │ [Strategy, Vision, OKR] │
                       │    [MoSCoW & Roadmap]   │
                       └────────────┬────────────┘
                                    │ (Bàn giao Epic & Duyệt PRD Gate 1)
                                    ▼
                       ┌─────────────────────────┐
                       │   Sub-Agent PM (Scrum)  │
                       │  [Sprint, WBS 6 Gates]  │
                       │ [Story Points, Blockers]│
                       └────────────┬────────────┘
                                    │ (Điều phối WBS & Giám sát tiến độ)
       ┌───────────────┬────────────┴───────────┬───────────────┐
       ▼               ▼                        ▼               ▼
 ┌───────────┐   ┌───────────┐            ┌───────────┐   ┌───────────┐
 │ Sub-Agent │   │ Sub-Agent │            │ Sub-Agent │   │ Sub-Agent │
 │    BA     │   │ QA Tester │            │  Dev FE   │   │ Reviewer  │
 │ (Gate 1)  │   │(Gate 2, 5)│            │ (Gate 3)  │   │ (Gate 4)  │
 └───────────┘   └───────────┘            └───────────┘   └───────────┘
```

### 2.1. Danh Sách 6 Sub-Agent Chuyên Biệt

| Sub-Agent | Tên Skill Tương Ứng | Lập Trường & Mục Tiêu Độc Lập | Sản Phẩm Đầu Ra Bắt Buộc | Thẩm Quyền Phê Duyệt |
| :--- | :--- | :--- | :--- | :--- |
| **1. Sub-Agent PO** | `product-owner` | Đại diện Người dùng & Kinh doanh; Tối đa hóa giá trị sản phẩm; Khắt khe về phạm vi. | `docs/00-roadmap/product-roadmap.md`, `epics-backlog.md` | Duyệt PRD Gate 1 & Duyệt Release Gate 6. |
| **2. Sub-Agent PM** | `project-manager` | Kỷ luật Tiến độ, Capacity & Rủi ro; Giữ vững nhịp độ giao hàng và tháo gỡ blockers. | `docs/00-project-management/sprint-backlog.md`, `wbs-task-matrix.md`, `risk-blocker-log.md` | Duyệt phân bổ Task & Đóng/Mở Sprint. |
| **3. Sub-Agent BA** | `business-analyst` | Làm rõ nghiệp vụ, hành vi người dùng; Cung cấp đặc tả chi tiết, không chấp nhận sự mơ hồ. | `docs/03-prd-features/<id>/prd.md`, `user-stories.md` (BDD), `ui-ux-screen-specs.md` | Hoàn thiện tài liệu Gate 1 trình PO duyệt. |
| **4. Sub-Agent QA** | `qa-tester` & `flutter-testing` | Đứng về phía sự hoài nghi lỗi; Đảm bảo chất lượng và độ ổn định; Không thỏa hiệp với bug. | `tests/02-manual-testcases/`, `tests/03-bdd-gherkin-scenarios/*.feature`, `signoff-<feat>.md` | Nghiệm thu Gate 2 và Ký duyệt Gate 5. |
| **5. Sub-Agent Dev FE** | `flutter-expert` & `ponytail` | Triển khai mã nguồn Flutter Clean Architecture tinh gọn; Tuân thủ tuyệt đối màu sắc dinh dưỡng. | `frontend/lib/features/<feat>/` (Domain, Data, Presentation) | Hoàn thành Gate 3 với `flutter analyze` 0 lỗi. |
| **6. Sub-Agent Reviewer**| `code-reviewer` & `ponytail-review` | Cực đoan chống over-engineering; Tìm và xóa bỏ boilerplate, dead code, dependency thừa. | Báo cáo Review 1 dòng/phát hiện: `<file>:L<line>: <tag> <what>. <replacement>.` | Ký duyệt Gate 4 (Phải đạt `Lean already. Ship.`). |

---

### 2.2. Quy Tắc Bất Khả Xâm Phạm (The Four-Eyes Principle)
1. **Không Tự Duyệt**: Tuyệt đối không một Sub-Agent nào có quyền tự phê duyệt hay ký sign-off cho sản phẩm của mình.
   - *BA viết PRD* ➔ Bắt buộc Sub-Agent **PO** duyệt.
   - *Dev FE viết code* ➔ Bắt buộc Sub-Agent **Reviewer** duyệt Gate 4 và Sub-Agent **QA** duyệt Gate 5.
   - *PM muốn đổi Scope* ➔ Bắt buộc Sub-Agent **PO** phê duyệt cập nhật Roadmap.
2. **Phản Biện Khách Quan (Healthy Friction)**:
   - Sub-Agent PO có quyền từ chối PRD nếu BA viết lan man, không bám sát mục tiêu app dinh dưỡng hoặc thiếu tính khả thi.
   - Sub-Agent Reviewer có quyền chặn code của Dev FE nếu phát hiện over-engineering, class thừa, dependency không cần thiết.
   - Sub-Agent QA có quyền bác bỏ phát hành nếu tỷ lệ Pass < 100% hoặc FPS < 55, AI latency > 2.5s.
3. **Cơ Chế Kích Hoạt (Sub-Agent Dispatching)**: Khi thực thi một Gate, hệ thống sẽ kích hoạt chính xác Sub-Agent chuyên trách với System Prompt, Persona và Bộ Tiêu Chuẩn đánh giá độc lập.

---

## 3. Đặc Tả Chi Tiết Hai Sub-Agent Mới (PO & PM)

### 3.1. Sub-Agent Product Owner (`.agents/skills/product-owner/SKILL.md`)
* **Metadata**:
  * `name`: `product-owner`
  * `domain`: `product-management`
  * `role`: `strategic-product-owner`
  * `triggers`: `roadmap, product vision, epic, prioritization, moscow, release planning, approve prd, product owner, po`
* **Lập trường & Trách nhiệm cốt lõi**:
  * Duy trì Tầm nhìn & OKRs (Độ chính xác AI > 85%, Latency < 2.5s, D30 Retention > 35%).
  * Quản lý danh mục Epics (`EPIC-01` đến `EPIC-07`) và phân loại theo **MoSCoW**:
    * **Must-have (M)**: Không có thì gãy Core User Flow (Auth, Quét ảnh AI, Nhật ký ăn uống, Tính BMR/TDEE).
    * **Should-have (S)**: Tác động mạnh tới Retention (Cảnh báo calo, Đồ thị dinh dưỡng tuần/tháng, Nhập thủ công nhanh).
    * **Could-have (C)**: Tính năng gia tăng thích thú (Gợi ý thực đơn, Streak ăn uống, Widget).
    * **Won't-have (W)**: Hoãn lại (Đặt đồ ăn online, Kê đơn bệnh lý).
  * Lộ trình 3 Chân trời (Now: v1.0 MVP, Next: v1.1 Dinh dưỡng nâng cao, Later: v1.2 AI Coach).
  * Ký duyệt Gate 1 và Nghiệm thu phát hành Gate 6.

### 3.2. Sub-Agent Project Manager (`.agents/skills/project-manager/SKILL.md`)
* **Metadata**:
  * `name`: `project-manager`
  * `domain`: `project-management`
  * `role`: `scrum-master-delivery-lead`
  * `triggers`: `sprint, sprint backlog, wbs, task breakdown, story points, project status, blockers, risk log, pm, project manager`
* **Lập trường & Trách nhiệm cốt lõi**:
  * Thiết lập chu kỳ Sprint, Sprint Goal và cam kết Story Points.
  * Phân rã công việc **WBS (Work Breakdown Structure)** theo ma trận 6 Cổng cho từng feature, gán trực tiếp cho Sub-Agent BA, QA, Dev FE, Reviewer.
  * Ước lượng **Fibonacci Story Points (1, 2, 3, 5, 8)**:
    * `1 SP`: Sửa UI nhỏ, update theme token, test case đơn lẻ.
    * `2 SP`: Widget độc lập (`GlassCard`, `MacroBar`), model Freezed cơ bản.
    * `3 SP`: Màn hình CRUD cơ bản + Riverpod Notifier + Firestore repo.
    * `5 SP`: Màn hình tương tác phức tạp, tính toán động realtime (Manual Entry, Custom Food Sheet).
    * `8 SP`: Tính năng AI phức tạp (Gemini Flash Vision scanning, image preprocessing, multi-step error recovery).
    * `>= 13 SP`: Buộc phải phân rã thành các sub-tasks `<= 8 SP`.
  * Quản trị rủi ro và điểm nghẽn kỹ thuật (`risk-blocker-log.md`).
  * Báo cáo tiến độ Sprint (Todo, In Progress, Review, Verify, Done).

---

## 4. Cấu Trúc Thư Mục & Tài Liệu Quản Trị (`docs/`)

```
docs/
├── 00-roadmap/                                  # [DO SUB-AGENT PO SỞ HỮU]
│   ├── README.md                                # Quy chuẩn quản trị Lộ trình & Epics
│   ├── product-roadmap.md                       # Lộ trình 3 Chân trời (Now - Next - Later)
│   └── epics-backlog.md                         # Danh mục Epics & Đánh giá MoSCoW
│
├── 00-project-management/                       # [DO SUB-AGENT PM SỞ HỮU]
│   ├── README.md                                # Quy chuẩn quản trị Sprint & WBS Task
│   ├── sprint-backlog.md                        # Sprint Goal, Story Points, Bảng Kanban
│   ├── wbs-task-matrix.md                       # Phân rã WBS theo 6 Cổng & Gán Sub-Agent
│   └── risk-blocker-log.md                      # Nhật ký rủi ro, điểm nghẽn kỹ thuật
│
└── templates/                                   # Templates chuẩn hóa
    ├── template-epic.md                         # Template Epic mới (PO)
    ├── template-roadmap-item.md                 # Template Hạng mục lộ trình (PO)
    ├── template-sprint.md                       # Template Khởi tạo Sprint (PM)
    └── template-wbs-task.md                     # Template Task WBS (PM)
```

---

## 5. Quy Trình Vận Hành 6-Gate SOP Bằng Hệ Thống Sub-Agent

```
[GATE 1: BA] ────────► [DUYỆT GATE 1: PO] ──────► [LẬP SPRINT & WBS: PM]
(Sub-Agent BA)          (Sub-Agent PO)             (Sub-Agent PM)
                                                          │
                                                          ▼
[GATE 4: REVIEW] ◄──── [GATE 3: DEV FE] ◄──────── [GATE 2: QA TEST]
(Sub-Agent Reviewer)    (Sub-Agent Dev FE)         (Sub-Agent QA)
       │
       ▼
[GATE 5: VERIFY] ────► [GATE 6: RELEASE & SIGN-OFF: PO]
(Sub-Agent QA)          (Sub-Agent PO & PM)
```

1. **Gate 1**: Sub-Agent BA viết PRD ➔ **Sub-Agent PO thẩm định & ký duyệt Gate 1**.
2. **Sprint & WBS**: **Sub-Agent PM** khởi tạo Sprint, phân rã WBS và chấm Story Points.
3. **Gate 2**: **Sub-Agent QA** thiết kế Test Cases và kịch bản `.feature`.
4. **Gate 3**: **Sub-Agent Dev FE** viết mã nguồn Clean Architecture chuẩn Ponytail.
5. **Gate 4**: **Sub-Agent Reviewer** quét diff, loại bỏ over-engineering, xác nhận `Lean already. Ship.`.
6. **Gate 5**: **Sub-Agent QA** chạy test suite 100% Pass, kiểm tra phi chức năng và ký `signoff-<feat>.md`.
7. **Gate 6**: **Sub-Agent PO** ký duyệt phát hành cuối cùng; **Sub-Agent PM** đóng Sprint & cập nhật Roadmap.

---

## 6. Khảo Sát Hiện Trạng & Dữ Liệu Khởi Tạo Thực Tế

### 6.1. Hiện trạng 5 Tính Năng Cốt Lõi

| Mã Feature | Tên Tính Năng | Trạng Thái Hiện Tại | Đánh Giá Của Sub-Agent PM & PO |
| :--- | :--- | :---: | :--- |
| `FEAT-01` | Auth & Onboarding | **Gate 6 Ready** | Đã ký `signoff-auth-login.md`. Đủ điều kiện Release v1.0. |
| `FEAT-02` | Gemini Food Scanner AI | **Gate 6 Ready** | Đã ký `signoff-food-scanner.md`. Đủ điều kiện Release v1.0. |
| `FEAT-03` | Diary & Manual Food Entry | **Gate 6 Ready** | Đã ký `signoff-manual-entry.md` (86 tests pass). Đủ điều kiện Release v1.0. |
| `FEAT-04` | Analytics & Insights | **Gate 4/5 (In Progress)** | Code FE đã có (`lib/features/analytics`), cần hoàn tất Gate 5 Sign-off. |
| `FEAT-05` | User Profile & Goals | **Gate 4/5 (In Progress)** | Code FE đã có (`lib/features/profile`), cần hoàn tất Gate 5 Sign-off. |

### 6.2. Kế hoạch Lộ trình (Roadmap v1.0 -> v1.2) do Sub-Agent PO Lập
* **Now (v1.0.0 MVP Release)**: Đóng gói nghiệm thu Gate 5 & Gate 6 cho `FEAT-04` và `FEAT-05` ➔ Phát hành AstroBite v1.0.0.
* **Next (v1.1.0 Enhanced Nutrition)**: Quét đồ ăn đa món (Multi-item), Phân tích vi chất (Micronutrients), Chế độ Offline Sync với Cloud Firestore.
* **Later (v1.2.0+ AI Proactive Coach)**: Trợ lý dinh dưỡng hội thoại Gemini Chat, Tích hợp Apple Health & Google Health Connect, Home Widget.

### 6.3. Kế hoạch Sprint 01 do Sub-Agent PM Lập
* **Sprint Goal**: Hoàn thiện toàn bộ test suite, rà soát mã nguồn và ký nghiệm thu Gate 5 cho `FEAT-04` (Analytics) & `FEAT-05` (Profile) để PO ký duyệt Release v1.0.0.
* **Cam kết Story Points**: 13 SP.
* **Bảng WBS Matrix ban đầu**: Gán nhiệm vụ cụ thể cho Sub-Agent QA, Dev FE và Reviewer.

---

## 7. Kế Hoạch Triển Khai Thực Tế

1. **Khởi tạo 2 Sub-Agent Skills Mới**:
   - [`.agents/skills/product-owner/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/product-owner/SKILL.md)
   - [`.agents/skills/project-manager/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/project-manager/SKILL.md)
2. **Cập nhật & Chuẩn hóa 4 Sub-Agent Skills Hiện Có**:
   - [`.agents/skills/business-analyst/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/business-analyst/SKILL.md): Đóng gói chuẩn Persona Sub-Agent BA.
   - [`.agents/skills/qa-tester/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/qa-tester/SKILL.md): Đóng gói chuẩn Persona Sub-Agent QA.
   - [`.agents/skills/flutter-expert/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/flutter-expert/SKILL.md): Đóng gói chuẩn Persona Sub-Agent Dev FE.
   - [`.agents/skills/code-reviewer/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/code-reviewer/SKILL.md): Đóng gói chuẩn Persona Sub-Agent Reviewer.
3. **Khởi tạo Hệ thống Thư mục & Dữ liệu Markdown Quản trị**:
   - `docs/00-roadmap/` (`README.md`, `product-roadmap.md`, `epics-backlog.md`)
   - `docs/00-project-management/` (`README.md`, `sprint-backlog.md`, `wbs-task-matrix.md`, `risk-blocker-log.md`)
   - `docs/templates/` (`template-epic.md`, `template-roadmap-item.md`, `template-sprint.md`, `template-wbs-task.md`)
4. **Cập nhật Quy chế Dự án & Điều phối Trung tâm**:
   - [`AGENTS.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/AGENTS.md): Định nghĩa kiến trúc Đa Sub-Agent và nguyên tắc Four-Eyes.
   - [`.agents/skills/feature-lifecycle/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/feature-lifecycle/SKILL.md): Điều phối 6 Sub-Agents qua 6 Gates.
   - [`docs/01-overview/stakeholder-matrix.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/01-overview/stakeholder-matrix.md): Đồng bộ ma trận RACI giữa 6 Sub-Agents.
