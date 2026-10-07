# Thiết Kế Chi Tiết Hệ Thống Social Guilds & Planetary Challenges (Gate 0 Architectural Spec)

> **Tài liệu**: Superpowers Architectural Design Specification  
> **Dự án**: AstroBite (`astrobite`)  
> **Mã Epic / Feature**: `EPIC-14` / `FEAT-S21-GUILDS`  
> **Phiên bản mục tiêu**: `v3.1.0` (Sprint 21)  
> **Tác giả**: Sub-Agent Tech Lead (*The Pragmatic System Architect*) & Sub-Agent PO (*The Strategic Tyrant*)  
> **Trạng thái**: 🟢 **GATE 0 APPROVED — FEASIBILITY SIGNED-OFF**

---

## 1. Tầm Nhìn Sản Phẩm & Chỉ Số Thành Công (Product Vision & OKRs)

- **Mục tiêu tối thượng**: Chuyển đổi động lực theo dõi dinh dưỡng từ nỗ lực đơn độc của cá nhân sang sức mạnh đồng hành tập thể (Social Peer Accountability) thông qua mô hình **Bang Hội Vũ Trụ (Social Guilds)** và **Thử Thách Hành Tinh Tuần/Tháng (Planetary Challenges)**.
- **Giá trị kinh doanh & Retention**:
  - Tăng tỷ lệ giữ chân **D30 Retention thêm +18%** nhờ hiệu ứng trách nhiệm tập thể ("bỏ log là ảnh hưởng đến điểm số của cả đội").
  - Gia tăng tần suất mở ứng dụng hàng ngày (**DAU/MAU tăng từ 45% lên $\ge 58\%$**).
- **Chỉ số SLAs Kỹ Thuật (Strict Budgets)**:
  - Tốc độ tải dữ liệu Bang Hội & BXH: $\le 800ms$ (Firestore Cache-first + Stream).
  - Race condition khi cập nhật điểm đồng thời: $0\%$ (áp dụng `FieldValue.increment()` và Firestore Transactions).
  - Tốc độ render giao diện (FPS): $\ge 55$ FPS (đạt chuẩn 60 FPS với UI Kit Claymorphic).
  - Rò rỉ bộ nhớ (Memory Leak): $0$ (tự động cancel Firestore subcription khi dispose controller).

---

## 2. Phân Loại MoSCoW Cho Sprint 21 (Sub-Agent PO Sign-Off)

| Phân Loại | Hạng Mục / Tính Năng | Tỷ Lệ SP | Ghi Chú Chiến Lược |
| :--- | :--- | :---: | :--- |
| **Must-have (M)** | 1. Tạo & Tham gia Bang hội bằng Invite Code (6 ký tự) hoặc duyệt danh sách công khai.<br>2. Guild Dashboard: Avatar Hành tinh, Tên bang, Thanh tiến độ chung (Team Progress Arc).<br>3. Thử thách Tuần Hành Tinh (Ví dụ: Thử thách Sao Hỏa 50,000 kcal sạch hoặc 100 bữa ăn đúng hạn).<br>4. Auto Contribution: Mỗi khi người dùng log món hoặc duy trì streak, điểm XP tự động tích lũy vào Guild. | **61% (8 SP)** | Cốt lõi của sự gắn kết; không có phần này tính năng không có giá trị. |
| **Should-have (S)** | 1. Guild Member Leaderboard: Xếp hạng đóng góp trong bang hội, tôn vinh MVP tuần.<br>2. Streak Nudge trong bang hội: 1-chạm gửi tín hiệu nhắc đồng đội chưa ăn/log bữa. | **23% (3 SP)** | Thúc đẩy tương tác nội bộ và gắn kết. |
| **Could-have (C)** | 1. Huy hiệu Hành tinh (Planetary Badges) lưu vào Profile khi hoàn thành chiến dịch. | **16% (2 SP)** | Gamification nâng cao, có thể phát triển tiếp ở Sprint sau. |
| **Won't-have (W)** | Chat voice realtime, hệ thống giao dịch buôn bán vật phẩm, Guild chiến PvP thời gian thực. | **0%** | Loại bỏ ngay; tránh Scope Creep làm loãng mục tiêu theo dõi sức khỏe. |

---

## 3. Kiến Trúc Dữ Liệu & Giải Pháp Kỹ Thuật (Sub-Agent Tech Lead)

### 3.1. Cấu Trúc Firestore Collections

```
guilds/ {guildId}
  ├── id: String
  ├── name: String
  ├── description: String
  ├── avatar_planet: String ("mars" | "venus" | "jupiter" | "saturn" | "neptune")
  ├── invite_code: String (Unique 6 ký tự uppercase, ví dụ "ASTRO9")
  ├── owner_id: String
  ├── member_count: Integer (max 20)
  ├── member_ids: Array<String>
  ├── total_starlight_xp: Integer (Atomic Increment)
  ├── active_challenge_id: String?
  ├── created_at: Timestamp
  │
  ├── members/ {userId} (Subcollection)
  │     ├── user_id: String
  │     ├── display_name: String
  │     ├── avatar_url: String?
  │     ├── role: String ("leader" | "elder" | "member")
  │     ├── weekly_contribution_xp: Integer
  │     ├── current_streak: Integer
  │     ├── last_logged_at: Timestamp
  │     └── joined_at: Timestamp
  │
  └── challenges/ {challengeId} (Subcollection)
        ├── id: String
        ├── planet_theme: String ("mars" | "mercury" | "jupiter")
        ├── title: String ("Chiến Dịch Sao Hỏa: 50,000 Kcal Sạch")
        ├── target_metric: String ("clean_calories" | "logged_meals" | "streak_days")
        ├── target_value: Integer (50000)
        ├── current_value: Integer (Atomic Increment)
        ├── start_date: Timestamp
        ├── end_date: Timestamp
        └── status: String ("active" | "completed" | "expired")
```

### 3.2. Cơ Chế Chống Race Condition & Atomic Synchronization

Khi một thành viên hoàn thành 1 bữa ăn đạt chuẩn dinh dưỡng (+50 Starlight XP):
1. **Local State**: Cập nhật tức thời (Optimistic UI) trên máy cá nhân để loại bỏ cảm giác chờ đợi.
2. **Cloud Sync**: Sử dụng Firestore `FieldValue.increment(50)` đồng thời cho:
   - `guilds/{guildId}.total_starlight_xp += 50`
   - `guilds/{guildId}/members/{userId}.weekly_contribution_xp += 50`
   - `guilds/{guildId}/challenges/{activeChallengeId}.current_value += 50`
3. **Ưu điểm kiến trúc**:
   - Chi phí đọc/ghi tối thiểu (Zero contention, không bị abort do lock).
   - Kháng lỗi mạng (Firestore Offline Persistence tự động queue write operations).

---

## 4. Trải Nghiệm Giao Diện 5 Trạng Thái (Claymorphic UI Kit Integration)

Giao diện Bang Hội tuân thủ tuyệt đối triết lý **Claymorphic × Duolingo 2D/3D** trên nền **Warm Milk Canvas** (`#FAF8F5`):
1. **Trạng thái 1: DEFAULT / ACTIVE**:
   - Thẻ `ClayCard` bo góc 24pt hiển thị Hành tinh chủ quản với bóng nổi 2 lớp.
   - Vòng cung tiến độ `CalorieProgressArc` tùy biến thành `GuildProgressArc` màu Duolingo Lime Green (`#58CC02`).
   - Danh sách đồng đội với huy hiệu thành viên và chuỗi ngày Streak.
2. **Trạng thái 2: SHIMMER / LOADING**:
   - `ClaySkeletonLoader` mô phỏng avatar hành tinh và các thanh tiến độ dạng xung nhịp nhẹ nhàng.
3. **Trạng thái 3: EMPTY**:
   - Người dùng chưa có Bang hội: Hiển thị minh họa Vũ Trụ Thân Thiện kèm 2 nút bấm Duolingo 3D lớn: **[Tạo Bang Hội Mới]** và **[Nhập Mã Mời]**.
4. **Trạng thái 4: ERROR**:
   - Xử lý mã mời không hợp lệ, mất kết nối mạng hoặc Bang hội đã đầy thành viên (20/20) với hướng dẫn trực quan.
5. **Trạng thái 5: OFFLINE**:
   - Giữ nguyên dữ liệu bộ nhớ đệm cục bộ, gắn nhãn badge `Offline Sync Pending` với icon đám mây thân thiện.

---

## 5. Kế Hoạch 8 Gate & Phân Bổ Fibonacci Story Points (Sprint 21: 13 SP)

| Mã Task | Phân Loại / File | Gate | Mô Tả Tác Vụ | Sub-Agent Phụ Trách | SP |
| :--- | :--- | :---: | :--- | :--- | :---: |
| `TSK-S21-00-SPIKE` | Architectural Spec | **G0** | Tech Lead & PO: Thiết kế kiến trúc Social Guilds & Data Model | `tech-lead` | 1 |
| `TSK-S21-01-PRD` | PRD & BDD Scenarios | **G1** | BA: Soạn PRD & User Stories BDD luồng Bang hội & Thử thách | `business-analyst` | 2 |
| `TSK-S21-02-DESIGN` | UI/UX Design Spec | **G2** | UI/UX Designer: Thiết kế Guild Dashboard, Planetary Arc & 5 States | `ui-ux-designer` | 2 |
| `TSK-S21-03-TEST-PLAN` | QA Master Test Plan | **G3** | QA Tester: Thiết kế test biên BVA, concurrency & kịch bản Gherkin | `qa-tester` | 1 |
| `TSK-S21-04-DATA` | Domain & Repository | **G4** | Cloud Dev: Freezed Guild Models, Firestore Datasource & Atomic XP | `cloud-ai-dev` | 3 |
| `TSK-S21-05-UI` | Presentation & Widgets | **G4** | Dev FE: Xây dựng GuildScreen, PlanetaryChallengeCard & MemberList | `flutter-core-dev` | 4 |
| `TSK-S21-06-REVIEW` | Ponytail Diff Review | **G5** | Reviewer: Rà soát git diff, loại bỏ over-engineering & code thừa | `code-reviewer` | - |
| `TSK-S21-07-VERIFY` | Automated Verification | **G6** | QA Tester: Chạy 100% test suite, kiểm tra 0 analyze error, 60 FPS | `qa-tester` | - |
| `TSK-S21-08-SECURITY` | Security Audit | **G6.5** | Security Auditor: Kiểm toán Firestore Security Rules & Anti-Abuse | `security-auditor` | - |
| `TSK-S21-09-RELEASE` | Release Clearance | **G7** | Hội đồng PO, PM, Tech Lead & Security: Release v3.1.0 | `product-owner` | - |

---

## 6. Kết Luận Khả Thi (Feasibility Sign-Off)

- **Sub-Agent Tech Lead**: 🟢 **APPROVED** — Kiến trúc phân tán tối giản, chi phí Firestore thấp, tận dụng hạ tầng Clean Architecture và UI Kit hiện hữu, không có rủi ro nghẽn SLA.
- **Sub-Agent PO**: 🟢 **APPROVED** — Mục tiêu kinh doanh rõ ràng, bám sát Retention D30, tuân thủ nghiêm ngặt quy tắc MoSCoW. Sẵn sàng bàn giao cho Sub-Agent BA soạn thảo PRD (Gate 1).
