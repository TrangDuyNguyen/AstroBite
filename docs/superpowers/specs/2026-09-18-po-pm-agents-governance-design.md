# Tài Liệu Đặc Tả Thiết Kế: Hệ Sinh Thái Sub-Agent PO & PM và Quản Trị Dự Án AstroBite

- **Dự án**: AstroBite (`astrobite`)
- **Tác giả**: Pair Programming (Antigravity & Product Team)
- **Ngày lập**: 2026-09-18
- **Phiên bản**: v1.0.0
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

Khi số lượng tính năng, màn hình và kịch bản kiểm thử tăng lên, dự án đòi hỏi năng lực quản trị cấp cao hơn:
- Phải có người định hình tầm nhìn dài hạn, xếp độ ưu tiên tính năng và kiểm soát chất lượng đầu ra của sản phẩm (Vai trò **Product Owner - PO**).
- Phải có người lập kế hoạch Sprint, phân rã công việc chi tiết theo 6 Cổng (WBS), ước lượng độ phức tạp và gỡ bỏ điểm nghẽn kỹ thuật (Vai trò **Project Manager - PM**).

### 1.2. Mục tiêu thiết kế
1. Xây dựng 2 Sub-Agent độc lập: `product-owner` và `project-manager`.
2. Đảm bảo tính khách quan tối đa thông qua nguyên tắc kiểm soát chéo (Four-Eyes Principle / Separation of Concerns), không một agent nào được tự duyệt sản phẩm của mình.
3. Thiết lập hệ thống lưu trữ dữ liệu quản trị sản phẩm bằng Markdown chuẩn hóa trực tiếp trong kho mã nguồn: `docs/00-roadmap/` và `docs/00-project-management/`.
4. Chuẩn hóa phương pháp luận: Khung ưu tiên **MoSCoW** cho PO và thang điểm **Story Points Fibonacci (1, 2, 3, 5, 8)** theo chu trình 6 Gates cho PM.
5. Khảo sát hiện trạng 5 features hiện có để lập ngay **Product Roadmap (v1.0 -> v1.2)** và **Sprint 1 Backlog** kèm ma trận WBS thực tế.

---

## 2. Kiến Trúc Sub-Agent & Nguyên Tắc Độc Lập Khách Quan

```
                       ┌─────────────────────────┐
                       │   Product Owner (PO)    │
                       │ [Strategy, Vision, OKR] │
                       │   [MoSCoW & Roadmap]    │
                       └────────────┬────────────┘
                                    │ (Bàn giao Epics & Phê duyệt Gate 1)
                                    ▼
                       ┌─────────────────────────┐
                       │  Project Manager (PM)   │
                       │  [Sprint, WBS 6 Gates]  │
                       │ [Story Points, Blockers]│
                       └────────────┬────────────┘
                                    │ (Điều phối thực thi & giám sát)
       ┌───────────────┬────────────┴───────────┬───────────────┐
       ▼               ▼                        ▼               ▼
 ┌───────────┐   ┌───────────┐            ┌───────────┐   ┌───────────┐
 │ Gate 1 BA │   │ Gate 2 QA │            │ Gate 3/4  │   │ Gate 5/6  │
 │ (Analyst) │   │ (Tester)  │            │ (Dev FE & │   │ (Verify & │
 │           │   │           │            │  Review)  │   │  Release) │
 └───────────┘   └───────────┘            └───────────┘   └───────────┘
```

### 2.1. Nguyên tắc Bất Khả Xâm Phạm (Four-Eyes Principle)
Để loại bỏ thiên vị và giữ tính khách quan cao nhất trong quy trình AI-driven development:
- **Dev FE không tự duyệt code của mình**: Bắt buộc phải qua Sub-Agent `code-reviewer` rà soát theo triết lý Ponytail.
- **BA không tự duyệt PRD của mình**: Bắt buộc phải được Sub-Agent `product-owner` phản biện, đối soát với Business Goals và ký duyệt Gate 1.
- **Dev & PM không tự nghiệm thu chất lượng**: Bắt buộc phải có Sub-Agent `qa-tester` chạy kiểm thử tự động độc lập và lập `signoff-<feature>.md` tại Gate 5.
- **PM không tự ý thay đổi Roadmap**: Quyền quyết định ưu tiên và bổ sung tính năng thuộc quyền tối thượng của Sub-Agent `product-owner`.
- **PO là người ký duyệt Release Gate 6**: Đảm bảo sản phẩm đạt đầy đủ giá trị cam kết trước khi đóng gói phát hành.

---

## 3. Đặc Tả Hai Sub-Agent Mới

### 3.1. Sub-Agent Product Owner (`.agents/skills/product-owner/SKILL.md`)
- **Metadata**:
  - `name`: `product-owner`
  - `domain`: `product-management`
  - `role`: `strategic-product-owner`
  - `triggers`: `roadmap, product vision, epic, prioritization, moscow, release planning, approve prd, product owner, po`
- **Lập trường & Nhiệm vụ cốt lõi**:
  1. **Product Vision & OKRs**: Đảm bảo mọi tính năng giữ vững bản sắc Celestial Dark UI và công năng tính toán dinh dưỡng chính xác từ Gemini AI.
  2. **Quản lý danh mục Epics**: Định nghĩa các Epic lớn (`EPIC-01` đến `EPIC-07`), xác định mục tiêu và phạm vi kinh doanh.
  3. **Phân loại MoSCoW**:
     - **Must-have (M)**: Bắt buộc để Core User Flow không bị đứt đoạn.
     - **Should-have (S)**: Tác động mạnh đến tỷ lệ giữ chân D30 (Retention) và hiệu quả dinh dưỡng.
     - **Could-have (C)**: Gia tăng độ yêu thích (Delight factors).
     - **Won't-have (W)**: Chưa thực hiện trong phiên bản này.
  4. **Quản lý Lộ trình 3 Chân trời (Now - Next - Later)**: Duy trì `docs/00-roadmap/product-roadmap.md`.
  5. **Cổng Phê duyệt & Nghiệm thu**: Ký duyệt Gate 1 (PRD Approval) và nghiệm thu Gate 6 (Final Release Sign-off).

### 3.2. Sub-Agent Project Manager (`.agents/skills/project-manager/SKILL.md`)
- **Metadata**:
  - `name`: `project-manager`
  - `domain`: `project-management`
  - `role`: `scrum-master-delivery-lead`
  - `triggers`: `sprint, sprint backlog, wbs, task breakdown, story points, project status, blockers, risk log, pm, project manager`
- **Lập trường & Nhiệm vụ cốt lõi**:
  1. **Sprint Planning & Goal**: Thiết lập mục tiêu Sprint, kiểm soát sức chứa (Capacity) theo Story Points.
  2. **WBS Task Matrix**: Phân rã User Story thành danh sách task kỹ thuật ánh xạ trực tiếp vào 6 Cổng, gán cho từng Agent chuyên môn.
  3. **Ước lượng Fibonacci Story Points**:
     - `1 SP`: Sửa UI nhỏ, update constant, bổ sung 1 test case.
     - `2 SP`: Widget độc lập (`GlassCard`, `MacroBar`), Freezed entity đơn giản.
     - `3 SP`: Màn hình CRUD cơ bản + Riverpod Notifier + Firestore repo.
     - `5 SP`: Màn hình tương tác phức tạp, tính toán dinh dưỡng realtime (Manual Entry, Custom Sheet).
     - `8 SP`: Tính năng AI phức tạp (Gemini Flash Vision scanning, image preprocessing, multi-step error recovery).
     - `>= 13 SP`: Bắt buộc phân rã (Decompose) thành các task `<= 8 SP`.
  4. **Giám sát Tiến độ & Điểm nghẽn (Blockers)**: Duy trì `docs/00-project-management/risk-blocker-log.md`.
  5. **Báo cáo Tiến độ Dự án**: Cập nhật trạng thái Kanban trong `sprint-backlog.md` (Todo, In Progress, Review, Done).

---

## 4. Cấu Trúc Thư Mục & Tài Liệu Quản Trị

```
docs/
├── 00-roadmap/                                  # [PO SỞ HỮU]
│   ├── README.md                                # Quy chuẩn vận hành Roadmap của PO
│   ├── product-roadmap.md                       # Lộ trình 3 Chân trời (Now - Next - Later)
│   └── epics-backlog.md                         # Danh mục Epics & Độ ưu tiên MoSCoW
│
├── 00-project-management/                       # [PM SỞ HỮU]
│   ├── README.md                                # Quy chuẩn Sprint & Task của PM
│   ├── sprint-backlog.md                        # Sprint Goal, Story Points, Bảng Kanban
│   ├── wbs-task-matrix.md                       # Phân rã WBS theo ma trận 6 Cổng
│   └── risk-blocker-log.md                      # Bảng theo dõi điểm nghẽn & rủi ro kỹ thuật
│
└── templates/                                   # Templates chuẩn hóa
    ├── template-epic.md                         # Mẫu Epic mới (PO)
    ├── template-roadmap-item.md                 # Mẫu hạng mục lộ trình (PO)
    ├── template-sprint.md                       # Mẫu mở Sprint mới (PM)
    └── template-wbs-task.md                     # Mẫu task WBS (PM)
```

---

## 5. Quy Trình Vận Hành Liên Hoàn 6-Gate SOP

```
[BƯỚC 1: PO]          [BƯỚC 2: BA]         [BƯỚC 3: PO DUYỆT]       [BƯỚC 4: PM]
Chiến lược & Epic  ➔  Viết PRD & BDD   ➔   Ký duyệt Gate 1     ➔   Lập Sprint & WBS
(MoSCoW & Roadmap)    (docs/03-prd-...)    (PO Sign-off PRD)        (Story Points & Tasks)
                                                                           │
                                                                           ▼
[BƯỚC 7: PO DUYỆT]    [BƯỚC 6: VERIFY]     [BƯỚC 5: DEV & REVIEW] ◄────────┘
Ký duyệt Release   ◄─ QA & Test 100%   ◄─  Code Ponytail & Review
(Đóng Milestone)      (Gate 5 Sign-off)    (Gate 3 & Gate 4)
```

1. **Gate 1 (BA Gate)**: BA viết PRD ➔ **PO kiểm tra & ký duyệt**.
2. **Khởi tạo WBS**: PM nhận PRD đã duyệt, mở Sprint, tạo task WBS với Story Points.
3. **Gate 2 (QA Gate)**: QA viết test cases và kịch bản `.feature`.
4. **Gate 3 (Dev FE Gate)**: Dev FE triển khai code Clean Architecture chuẩn Ponytail.
5. **Gate 4 (Code Review Gate)**: Code Reviewer quét diff, loại bỏ mã thừa.
6. **Gate 5 (Verification Gate)**: QA chạy test tự động 100% Pass và lập `signoff-<feature>.md`.
7. **Gate 6 (Release Gate)**: **PO ký duyệt Release**, PM cập nhật đóng Sprint & đóng Milestone.

---

## 6. Khảo Sát Hiện Trạng & Dữ Liệu Khởi Tạo Thực Tế

### 6.1. Bảng hiện trạng 5 Core Features của AstroBite

| Mã Feature | Tên Tính Năng | Trạng Thái Hiện Tại | Nhiệm Vụ Tiếp Theo |
| :--- | :--- | :---: | :--- |
| `FEAT-01` | Auth & Onboarding | **Gate 6 Ready** | Đã ký `signoff-auth-login.md`. |
| `FEAT-02` | Gemini Food Scanner AI | **Gate 6 Ready** | Đã ký `signoff-food-scanner.md`. |
| `FEAT-03` | Diary & Manual Food Entry | **Gate 6 Ready** | Đã ký `signoff-manual-entry.md` (86 tests pass). |
| `FEAT-04` | Analytics & Insights | **Gate 4/5 (In Progress)** | Cần hoàn tất bộ test suite và lập sign-off Gate 5. |
| `FEAT-05` | User Profile & Goals | **Gate 4/5 (In Progress)** | Cần hoàn tất bộ test suite và lập sign-off Gate 5. |

### 6.2. Kế hoạch khởi tạo Lộ trình (Roadmap v1.0 -> v1.2)
- **Now (v1.0.0 MVP)**: Hoàn tất Gate 5 & Gate 6 cho Analytics và Profile ➔ Phát hành trọn gói v1.0.0.
- **Next (v1.1.0 Enhanced Insights & Multi-Scanning)**: Quét nhiều món cùng lúc (Multi-item), Thống kê vi chất (Micronutrients), Chế độ Offline Sync với Cloud Firestore.
- **Later (v1.2.0+ AI Proactive Coach & Ecosystem)**: AI Nutrition Coach tư vấn hội thoại trực tiếp, Apple Health / Health Connect, Home Widget.

### 6.3. Kế hoạch khởi tạo Sprint 1 Backlog
- **Sprint 01**: "Hoàn thiện nghiệm thu Gate 5 & Phát hành AstroBite v1.0.0".
- **Story Points cam kết**: 13 SP.
- **Mục tiêu**: Đưa `FEAT-04` và `FEAT-05` vượt qua Gate 4 và Gate 5, đủ điều kiện để PO ký duyệt Release.

---

## 7. Kế Hoạch Cập Nhật & Tích Hợp Hệ Thống
1. Tạo 2 file kỹ năng mới:
   - [`.agents/skills/product-owner/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/product-owner/SKILL.md)
   - [`.agents/skills/project-manager/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/project-manager/SKILL.md)
2. Tạo cấu trúc thư mục & dữ liệu thực tế:
   - `docs/00-roadmap/` (`README.md`, `product-roadmap.md`, `epics-backlog.md`)
   - `docs/00-project-management/` (`README.md`, `sprint-backlog.md`, `wbs-task-matrix.md`, `risk-blocker-log.md`)
   - `docs/templates/` (`template-epic.md`, `template-roadmap-item.md`, `template-sprint.md`, `template-wbs-task.md`)
3. Cập nhật các tài liệu cốt lõi:
   - [`AGENTS.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/AGENTS.md): Thêm PO & PM vào danh sách quy định Agent.
   - [`.agents/skills/feature-lifecycle/SKILL.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/.agents/skills/feature-lifecycle/SKILL.md): Tích hợp sự điều phối của PO & PM vào 6 Gates.
   - [`docs/01-overview/stakeholder-matrix.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/01-overview/stakeholder-matrix.md): Cập nhật ma trận RACI chi tiết.
