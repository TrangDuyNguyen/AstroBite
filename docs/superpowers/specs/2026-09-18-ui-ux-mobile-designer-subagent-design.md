# Tài Liệu Đặc Tả Thiết Kế: Tích Hợp Sub-Agent Mobile UI/UX Designer & Chuẩn Hóa Quy Trình 7-Gate SOP

- **Dự án**: AstroBite (`astrobite`)
- **Tác giả**: Pair Programming (Antigravity & Product Team)
- **Ngày cập nhật**: 2026-09-18
- **Phiên bản**: v3.0.0 (Mở rộng: 7 Sub-Agents Độc Lập & Quy Trình 7 Cổng Chất Lượng)
- **Trạng thái**: Draft / In Review
- **Vị trí tài liệu**: `docs/superpowers/specs/2026-09-18-ui-ux-mobile-designer-subagent-design.md`

---

## 1. Bối Cảnh & Mục Tiêu Thiết Kế (Executive Summary)

### 1.1. Bối cảnh
Trước đây, quy trình phát triển tính năng của AstroBite vận hành theo mô hình 6 Cổng (6-Gate SOP) với 6 Sub-Agents độc lập (`product-owner`, `project-manager`, `business-analyst`, `qa-tester`, `flutter-developer`, `code-reviewer`). Trong cấu trúc đó, trách nhiệm thiết kế giao diện (`ui-ux-screen-specs.md`) bị gộp vào Gate 1 do Sub-Agent `business-analyst` đảm nhiệm.

Thực tế phát triển cho thấy sự bất cập:
- **Chồng chéo chuyên môn**: Sub-Agent BA phải gánh cả phân tích nghiệp vụ (PRD, User Stories BDD) lẫn đặc tả giao diện, dẫn đến tài liệu giao diện mang tính sơ lược, thiếu sơ đồ luồng người dùng (User Flows), thiếu bố cục lưới 4pt chuẩn xác, và bỏ sót các trạng thái giao diện phức tạp (Loading/Shimmer, Empty, Error, Offline).
- **Nguy cơ sai lệch Design System**: Giao diện ứng dụng AstroBite có phong cách đặc thù **Celestial Dark UI** với các quy định khắt khe về màu dinh dưỡng (Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700`), bề mặt kính làm mờ (`BackdropFilter.blur(20)`), và công thái học vùng chạm (`44x44pt`). Nếu thiếu một chuyên gia thiết kế chuyên trách, Dev FE dễ rơi vào việc tự sáng tác UI hoặc vi phạm nguyên tắc thiết kế.

### 1.2. Mục tiêu thiết kế
1. **Bổ sung Sub-Agent thứ 7 chuyên biệt**: Tạo lập Sub-Agent `ui-ux-designer` độc lập, chịu trách nhiệm chuyên trách về thiết kế UI/UX di động và bảo vệ hệ thống thiết kế Celestial Dark UI.
2. **Nâng cấp toàn diện sang 7-Gate SOP**: Thiết lập Gate 2 độc lập (Mobile UI/UX Design Gate) nằm giữa Gate 1 (BA) và Gate 3 (QA).
3. **Tuân thủ triệt để Nguyên tắc Four-Eyes Principle (Kiểm soát chéo)**: Đầu ra của Sub-Agent Design phải được Sub-Agent BA đối soát 100% User Stories và Sub-Agent PO ký duyệt thẩm mỹ/trải nghiệm trước khi chuyển tiếp.
4. **Chuẩn hóa Hồ sơ Thiết kế**: Ban hành biểu mẫu `docs/templates/template-ui-ux-spec.md` gồm 6 khối thông tin tiêu chuẩn cho mọi tính năng.
5. **Đồng bộ toàn diện hệ thống**: Cập nhật nhất quán từ `AGENTS.md`, `feature-lifecycle`, `business-analyst`, đến `wbs-task-matrix.md` và `sprint-backlog.md`.

---

## 2. Kiến Trúc 7 Sub-Agents Độc Lập & Quy Trình 7 Cổng (7-Gate SOP)

### 2.1. Sơ Đồ Điều Phối Tổng Thể
Toàn bộ chuỗi cung ứng tính năng từ ý tưởng đến tay người dùng được vận hành qua 7 Cổng khép kín:

```
[PO Sub-Agent] ──────────► [Gate 1: BA Sub-Agent] ──────────► [PO Sub-Agent Duyệt]
(Roadmap & Epics)          (PRD & User Stories BDD)           (Gate 1 Sign-Off)
                                                                     │
                                                                     ▼
[Gate 3: QA Tester] ◄──── [PM Sub-Agent] ◄─────────── [Gate 2: UI/UX Designer]
(Test TCs & Gherkin)      (Sprint & WBS Matrix)       (UI Flow & Screen Layout)
       │                                                             │
       │                                                             ▼
       │                                                     [BA & PO Duyệt]
       │                                                     (Gate 2 Sign-Off)
       ▼
[Gate 4: Dev FE] ────────► [Gate 5: Reviewer] ───────► [Gate 6: QA Verify] ────► [Gate 7: PO & PM Release]
(Flutter Clean Ponytail)   (Ponytail Diff Review)      (Automated 100% Pass)      (Super-Repo Release)
```

### 2.2. Ma Trận Bàn Giao & Kiểm Soát Chéo (Four-Eyes Matrix)

| Cổng | Tên Cổng | Sub-Agent Thực Thi | Sản Phẩm Bàn Giao Cốt Lõi | Sub-Agent Kiểm Soát & Ký Duyệt |
| :---: | :--- | :--- | :--- | :--- |
| **Gate 1** | Phân Tích Nghiệp Vụ | `business-analyst` | `prd-<feature>.md`, `user-stories.md` chuẩn BDD, `data-dictionary.md` | `product-owner` (Gate 1 Sign-Off) |
| **Gate 2** | Thiết Kế UI/UX Mobile | `ui-ux-designer` | `ui-ux-design-spec.md` (Mermaid Flow, Grid 4pt, 5 States, Token Map) | `business-analyst` (Khớp User Stories) & `product-owner` (Gate 2 Sign-Off) |
| *Planning* | Kế Hoạch Sprint & WBS | `project-manager` | `sprint-backlog.md`, `wbs-task-matrix.md` (Gate 3 - Gate 7, Fibonacci SP) | `product-owner` (Duyệt phạm vi Sprint) |
| **Gate 3** | Thiết Kế Kiểm Thử | `qa-tester` | Manual Testcases (EP/BVA), BDD `.feature` kịch bản kiểm thử | QA Lead (Traceability Matrix đạt 100%) |
| **Gate 4** | Phát Triển Mã Nguồn | `flutter-expert` & `ponytail` | Flutter Clean Architecture (`domain`, `data`, `presentation`), 0 errors | `flutter analyze` = 0 issues |
| **Gate 5** | Rà Soát Mã Nguồn Tối Giản | `code-reviewer` | Ponytail diff review, triệt tiêu over-engineering & dead code | `code-reviewer` (Phán quyết: *Lean already. Ship.*) |
| **Gate 6** | Kiểm Thử Tự Động & Nghiệm Thu | `qa-tester` | `flutter test` 100% pass, Integration tests, Performance (FPS>=55, AI<=2.5s) | `qa-tester` & `product-owner` (`signoff-<feature>.md`) |
| **Gate 7** | Tích Hợp Super-Repo & Release | `product-owner` & `project-manager` | `make update`, submodule pointers, Git Tag `vX.Y.Z`, đóng Sprint | PO & PM đồng thuận phát hành |

---

## 3. Đặc Tả Sub-Agent `ui-ux-designer`

### 3.1. Thông Tin Nhận Dạng & Triggers
- **Tên Skill**: `ui-ux-designer`
- **Vị trí**: `.agents/skills/ui-ux-designer/SKILL.md`
- **Triggers**: `design ui`, `ui-ux-designer`, `mobile design`, `design gate`, `screen specs`, `celestial design`, `wireframe`, `thiet ke giao dien`, `gate 2`.
- **Role**: Lead Mobile UI/UX Designer & Celestial Design System Guardian.

### 3.2. Quyền Hạn & Ranh Giới Trách Nhiệm (Boundaries)
- **Nhiệm vụ bắt buộc**:
  1. Đọc và phân tích toàn diện PRD và User Stories do BA bàn giao từ Gate 1.
  2. Vẽ sơ đồ luồng điều hướng và chuyển trạng thái màn hình bằng cú pháp Mermaid (`graph TD` / `stateDiagram-v2`).
  3. Thiết kế layout chi tiết cho từng màn hình (`SCR-xx`), tuân thủ tuyệt đối hệ thống lưới 4pt và touch targets `>= 44x44pt`.
  4. Mô tả đầy đủ 5 trạng thái giao diện: Default, Loading/Skeleton Shimmer, Empty, Error, Offline.
  5. Ánh xạ chính xác các token giao diện tương ứng trong Flutter Theme và `AppColors`.
  6. Soạn thảo chỉ dẫn tái sử dụng widget có sẵn cho Dev FE (`GlassCard`, `MacroBar`, `CalorieProgressArc`, `MealTypeChip`, `SkeletonLoader`).
- **Ranh giới cấm vượt (Negative Constraints)**:
  - ❌ **Không tự ý mở rộng phạm vi nghiệp vụ**: Nếu nhận thấy thiếu luồng logic hoặc thiếu tính năng so với nhu cầu người dùng, Designer phải báo cho BA để tạo Change Request, không tự tiện thêm vào UI.
  - ❌ **Không viết code Flutter trong quá trình thiết kế**: Designer chỉ xuất tài liệu đặc tả và hướng dẫn widget tree; việc triển khai code thực tế thuộc thẩm quyền độc quyền của Dev FE tại Gate 4.
  - ❌ **Không tự duyệt sản phẩm của mình**: Phải có sự thẩm định chéo của BA và PO.

### 3.3. Kỷ Luật Thiết Kế Celestial Dark UI Bất Biến
Mọi thiết kế của Sub-Agent `ui-ux-designer` phải tuân thủ nghiêm ngặt các nguyên lý tại [`DESIGN.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/DESIGN.md):

1. **Bảng màu Dinh Dưỡng Bất Biến (Immutable Nutrient Semantics)**:
   - 🔵 **Primary (`#1A73E8`)**: Carbs + Trạng thái kích hoạt chính (Camera FAB, Active Tab, Progress Arc).
   - 🩷 **Secondary (`#FF69B4`)**: Chất béo (Fat) + Đường xu hướng phân tích dữ liệu (Analytics trends).
   - 🟡 **Tertiary (`#FFD700`)**: Chất đạm (Protein) + Cảnh báo ngân sách calo / calo vượt ngưỡng.
2. **Chiều Sâu Không Gian & Hiệu Ứng Kính Mờ (Surfaces & Glassmorphism)**:
   - Nền chính: `AppColors.surface` (`#0A192F` Midnight Blue).
   - Khối thẻ chứa nội dung: `AppColors.surfaceContainer` (`#112240` Deep Navy), bo góc `12px`.
   - Lớp phủ mờ (Bottom sheet, Modal, Dropdown): `AppColors.surfaceBlur` (`rgba(25, 42, 70, 0.6)`) với `BackdropFilter.blur(20)`.
   - `surfaceTintColor`: Luôn set `Colors.transparent` để tránh ám tím mặc định của M3.
3. **Lưới Công Thái Học Di Động (4pt Grid System)**:
   - Tất cả các giá trị padding, margin, khoảng cách chỉ được dùng bội số của 4: `4, 8, 12, 16, 24, 32, 44, 48`.
   - Touch Target: Tối thiểu `44 × 44pt` cho mọi nút bấm, icon chạm, thanh gạt.
4. **Hệ Thống Chữ (Typography Scale)**:
   - Font Inter (fallback SF Pro/Roboto).
   - Cỡ chữ calo lớn: Luôn có `letterSpacing: +0.5` để tăng độ thông thoáng và dễ đọc khi lướt nhanh.

---

## 4. Chuẩn Hóa Hồ Sơ Thiết Kế & Template Mẫu

Biểu mẫu hồ sơ thiết kế được lưu trữ tại: `docs/templates/template-ui-ux-spec.md`. Mọi tài liệu thiết kế tính năng mới đều phải sinh ra từ template này và lưu tại:  
`docs/03-prd-features/<id>-<feature>/ui-ux-design-spec.md`.

### 4.1. Cấu Trúc 6 Khối Thông Tin Chuẩn:
1. **Khối 1: Danh Sách Màn Hình & Sơ Đồ Điều Hướng (Navigation Flow)**:
   - Bảng tổng mục các màn hình/dialog (`SCR-01`, `SCR-02`,...).
   - Sơ đồ tương tác luồng người dùng (Mermaid Flowchart).
2. **Khối 2: Blueprint Bố Cục & Thông Số Lưới 4pt (Screen Layout Blueprints)**:
   - Cấu trúc thanh điều hướng trên (AppBar), thân màn hình (Body), và vùng hành động dưới (Action/FAB/BottomBar).
   - Thông số Padding cạnh viền (`16pt` / `24pt`), khoảng cách giữa các phần tử (`8pt` / `12pt` / `16pt`), kích thước vùng chạm.
   - Bảng phân cấp kiểu chữ (Typography scale).
3. **Khối 3: Đặc Tả 5 Trạng Thái Giao Diện Bắt Buộc (The 5 Essential States)**:
   - Default State: Đầy đủ dữ liệu.
   - Loading State: Skeleton Shimmer (chu kỳ 1.5s, không layout shift).
   - Empty State: Icon vũ trụ minh họa + Text hướng dẫn + CTA kích hoạt.
   - Error State: Thông báo lỗi tiếng Việt dễ hiểu, nút Thử lại (Retry).
   - Offline State: Huy hiệu mất mạng, cảnh báo dùng dữ liệu đệm.
4. **Khối 4: Bảng Ánh Xạ Design Token Celestial Dark UI (Token Mapping)**:
   - Bảng ánh xạ từng phần tử UI sang token màu và M3 theme token cụ thể.
5. **Khối 5: Chỉ Dẫn Handoff Cho Dev FE (Widget Tree & Ponytail Guidelines)**:
   - Danh sách widget dùng lại từ `shared/widgets/`.
   - Lưu ý tối giản, không viết widget thừa thãi.
6. **Khối 6: Biên Bản Thẩm Định & Ký Duyệt Gate 2 (Gate 2 Sign-Off)**:
   - Checklist đối soát User Stories của BA.
   - Checklist nghiệm thu trải nghiệm của PO.
   - Quyết định thông qua Gate 2.

---

## 5. Kế Hoạch Triển Khai & Đồng Bộ Toàn Bộ Hệ Thống

| STT | File / Cấu Phần | Nội Dung Thực Hiện | Mục Đích |
| :---: | :--- | :--- | :--- |
| 1 | `.agents/skills/ui-ux-designer/SKILL.md` | Tạo mới file hướng dẫn kỹ năng cho Sub-Agent UI/UX Designer | Định hình role, nhiệm vụ, checklist, kỷ luật thiết kế |
| 2 | `docs/templates/template-ui-ux-spec.md` | Tạo mới file template chuẩn 6 khối | Cung cấp chuẩn mực thống nhất cho toàn bộ feature |
| 3 | `AGENTS.md` | Cập nhật Mục 6 thành quy trình 7 Cổng (7-Gate SOP) | Đồng bộ tài liệu gốc của dự án với cấu trúc 7 Sub-Agents |
| 4 | `.agents/skills/feature-lifecycle/SKILL.md` | Cập nhật luồng điều phối 7 Cổng & đối thoại 7 bước | Giúp Agent điều phối chính xác khi người dùng kích hoạt tính năng mới |
| 5 | `.agents/skills/business-analyst/SKILL.md` | Điều chỉnh nhiệm vụ: giải phóng BA khỏi UI, thêm vai trò thẩm định Gate 2 | Tránh chồng chéo trách nhiệm giữa BA và Designer |
| 6 | `docs/00-project-management/wbs-task-matrix.md` | Cập nhật tiêu đề 7 Cổng, thêm các task Gate 2 cho Sprint 02 | Đồng bộ kế hoạch thực thi công việc thực tế |
| 7 | `docs/00-project-management/sprint-backlog.md` | Cập nhật cấu trúc phân rã công việc Sprint 02 | Đảm bảo tính nhất quán về Story Points và thứ tự Gate |

---

## 6. Kế Hoạch Xác Minh Tính Toàn Vẹn (Verification Plan)

### 6.1. Kiểm Tra Tính Nhất Quán Giữa Các Sub-Agent
- [ ] Xác nhận không còn tình trạng BA kiêm nhiệm thiết kế UI chi tiết.
- [ ] Xác nhận mọi references về số lượng cổng đều đã được cập nhật thành **7-Gate SOP** (từ Gate 1 đến Gate 7).
- [ ] Đảm bảo bảng màu và quy chuẩn kỹ thuật trong `template-ui-ux-spec.md` và `ui-ux-designer/SKILL.md` hoàn toàn ăn khớp với `DESIGN.md` và `lib/core/theme/app_colors.dart`.

### 6.2. Kiểm Tra Tài Liệu & Git Trackability
- [ ] Kiểm tra tính toàn vẹn markdown của tất cả các file mới và file cập nhật.
- [ ] Chạy kiểm tra git status và commit tài liệu đặc tả kỹ thuật vào repository.
