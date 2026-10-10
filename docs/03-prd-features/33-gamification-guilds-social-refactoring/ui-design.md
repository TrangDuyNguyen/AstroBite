# Thiết Kế UI/UX Blueprint Lưới 4pt — Gate 2 Sign-Off
## Sprint 26: Gamification, Guilds & Social Modular Architecture

- **Chủ trì thiết kế**: Sub-Agent UI/UX Designer (`ui-ux-designer` — *The Celestial Aesthetic Purist*)
- **Phê duyệt**: Sub-Agent PO & Tech Lead
- **Ngày ký duyệt**: 2026-10-10
- **Trạng thái**: 🎨 **GATE 2 APPROVED — STRICT 4PT GRID**

---

### 1. Bố Cục `StreakDetailSheet` (Gamification Sheet)

```
┌─────────────────────────────────────────────────────────────┐
│ [====] Drag Handle (44x5pt, rounded 2.5)                    │
│ [ ✨ TIỂU VŨ TRỤ KỶ LUẬT ] Category Pill                    │
│ "Tiểu Vũ Trụ Dinh Dưỡng" - Header Title (23pt bold)         │
│                                                             │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ 3-Pillar Gamification Metrics Card (ClayCard r:22)      │ │
│ │ [🔥 Chuỗi: 7]   |   [⭐ Kỷ Lục: 14]   |   [🛡️ Khiên: 1/2]│ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Starlight Shield 3D Banner (Gradient + Bevel)           │ │
│ │ [🛡️] Khiên Tinh Tú Đang Bật                              │ │
│ │ [========-----] Còn 2 ngày để nhận thêm khiên           │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ Huy Hiệu Vũ Trụ (2/4 ĐÃ MỞ)                                 │
│ [⭐ Huy Hiệu 1]              [🪐 Huy Hiệu 2]               │
│ [🔒 Huy Hiệu 3]              [🔒 Huy Hiệu 4]               │
│                                                             │
│ [🚀 Bot Tip Card: Mỗi ngày ăn đúng mục tiêu...]             │
│ [ ClayButton: 🏆 Bảng Xếp Hạng Bạn Bè ]                    │
│ [ ClayButton: Tiếp Tục Kỷ Luật ]                           │
└─────────────────────────────────────────────────────────────┘
```

---

### 2. Bố Cục `GuildPage` (Bang Hội Vũ Trụ)

```
┌─────────────────────────────────────────────────────────────┐
│ ClayAppBar: "Bang Hội Vũ Trụ" [➕ Thêm] [❓ Thể lệ]          │
│                                                             │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Guild Header Card (ClayCard r:24)                       │ │
│ │ (🪐 Avatar) [Tên Bang Hội]               [⚙️ Cài đặt]   │ │
│ │             [Mô tả mục tiêu bang]                       │ │
│ │             [15/20 Thành viên]   [📋 Copy Mã: #AST-12] │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ [Thử Thách Hành Tinh Tuần Này - PlanetaryChallengeCard]     │
│                                                             │
│ BẢNG XẾP HẠNG ĐÓNG GÓP (15 thành viên)                      │
│ - Top 1: Member Tile (👑, XP, Nudge / Vai trò)              │
│ - Top 2: Member Tile (🥈, XP, Nudge / Vai trò)              │
│ ...                                                         │
│ [ TextButton: Rời khỏi bang hội này 🚪 ]                   │
└─────────────────────────────────────────────────────────────┘
```

---

### 3. Bố Cục `LeaderboardPage` (Astro Leaderboard)

```
┌─────────────────────────────────────────────────────────────┐
│ ClayAppBar: "Bảng Xếp Hạng" [🪐 Guild] [👤+ Thêm bạn]      │
│                                                             │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ My Astro ID Card (ClayCard r:20)                        │ │
│ │ [🚀] Astro ID của bạn: #ASTRO-8821  [📋 Sao chép]       │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ Thành Viên Thử Thách (8 người)                              │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ 👑  Minh Duy (#AST-1002)     🔥 14d   [ Đạt chuẩn ✨ ]  │ │
│ ├─────────────────────────────────────────────────────────┤ │
│ │ 🥈  Thu Trang (#AST-2041)    🔥 12d   [ Đã nhắc ]       │ │
│ ├─────────────────────────────────────────────────────────┤ │
│ │ 🥉  Bảo Long (#AST-3309)     🔥 8d    [ ⚡ Nhắc ]       │ │
│ └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```
