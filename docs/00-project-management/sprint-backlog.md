# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 04
- **Tên Sprint**: Cosmic Onboarding & Flawless Product Architecture
- **Phiên bản mục tiêu**: `v1.3.0`
- **Thời gian Sprint**: 19/09/2026 – 03/10/2026
- **Trạng thái Sprint**: 🟡 **Đang Triển Khai (Active Execution)**
- **Tổng Story Points**: 22 SP (Must: 13 SP [59%], Should: 5 SP [23%], Could: 4 SP [18%])

---

## 🎯 Mục Tiêu Sprint 04

Khắc phục triệt để các lỗ hổng nền tảng được PO thẩm định & User phê duyệt:
1. **Google Sign-In & Auth Resiliency**: Cập nhật cấu hình OAuth/Server Client ID, loại bỏ triệt để lỗi đăng nhập Google, xử lý mượt mà cả khi offline hoặc token refresh.
2. **Information Architecture (IA) Restructuring**: Đưa **AstroCoach AI** ra vị trí trang trọng tại Tab chính thứ 2 của Navigation Bar, chuyển Manual Entry thành nút hành động nhanh từ Home/Tracker.
3. **Cosmic Nutrition Brand Connection**: Gắn kết triết lý "Mỗi cơ thể là một tiểu vũ trụ, Calo & Macro là năng lượng vận hành các hành tinh sinh học" vào toàn bộ luồng Onboarding và Dashboard.
4. **Hero Entry Point trên HomePage**: Thẻ AstroCoach AI Proactive Card và Health summary hiển thị trực tiếp 1 chạm trên Dashboard.

---

## 📋 Bảng Kanban Trực Quan

### 1. 📝 TODO — [4 SP]
| Mã Task | Feature / Epic | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---:|
| `TSK-S4-POLISH` | UI/UX Polish | **G4-G5** | Tinh chỉnh chuyển động hạt bụi sao & Celestial glow 60 FPS | `flutter-expert` | 4 | ⚪ Backlog |

### 2. ⚡ IN PROGRESS — [0 SP]
*(Không còn tác vụ dở dang)*

### 3. 🔍 IN REVIEW & VERIFY — [0 SP]
*(Đang chuẩn bị nghiệm thu Gate 6)*

### 4. 🏁 DONE — [18 SP]

| Mã Task | Feature / Epic | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---:|
| `TSK-S4-AUTH` | `FEAT-01` Auth | **G0-G4** | Cấu hình `serverClientId` Google OAuth từ Web Client ID, fix crash & idToken | `tech-lead` / `flutter-expert` | 5 | 🟢 Done |
| `TSK-S4-NAV` | `FEAT-NAV` Shell | **G2-G4** | Tái cấu trúc ShellScreen đưa `CoachRoute` lên Tab chính NavigationBar | `ui-ux-designer` / `flutter-expert` | 5 | 🟢 Done |
| `TSK-S4-BRAND` | `FEAT-01` Onboarding | **G1-G4** | Gắn kết triết lý Cosmic Nutrition vào 5 bước Onboarding & Launcher assets | `ui-ux-designer` / `flutter-expert` | 3 | 🟢 Done |
| `TSK-S4-COACH-UI` | `EPIC-07` AI Coach | **G2-G4** | Thêm AstroCoach Quick Card trên Home & Quick Action Chips phong phú | `flutter-expert` | 3 | 🟢 Done |
| `TSK-S4-HLTH-DASH` | `EPIC-10` Health | **G2-G4** | Tối ưu hiển thị và điều hướng thẻ Health từ Profile & Home | `flutter-expert` | 2 | 🟢 Done |

---

## 📊 Burndown Sprint 04

| Ngày | SP Còn Lại | Ghi Chú |
|:---:|:---:|:---|
| 19/09 | 22 | Khởi động Sprint 04 theo phê duyệt PO |
| 19/09 | 4 | Hoàn tất Auth Google fix, Shell Navigation, Cosmic Onboarding, AstroCoach Home Card (18/22 SP) |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 03 — AstroBite v1.2.0 Trợ Lý AI Dinh Dưỡng & Apple Health (Hoàn tất 19/09/2026)
- **Mục tiêu**: Tích hợp Gemini AI Chat Coach (`EPIC-07`) và Apple Health / Health Connect (`EPIC-10`).
- **Kết quả**: **21 / 21 SP (100% Passed)** — 119/119 tests pass, phát hành tag `v1.2.0`.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.2.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.2.0.md)

### 🟢 Sprint 02 — AstroBite v1.1.0 Dinh Dưỡng Nâng Cao & Trải Nghiệm Offline (Hoàn tất 18/09/2026)
- **Mục tiêu**: Mở rộng Gemini Vision AI nhận diện đa món (`FEAT-06`), Offline-First Cache & Sync (`FEAT-07`), vi chất (`FEAT-08`).
- **Kết quả**: **26 / 26 SP (100% Passed)** — 110/110 tests pass, phát hành tag `v1.1.0`.

### 🟢 Sprint 01 — AstroBite v1.0.0 MVP Release (Hoàn tất 18/09/2026)
- **Mục tiêu**: Hoàn tất kiểm thử, rà soát Ponytail cho Analytics & Profile, đóng gói v1.0.0.
- **Kết quả**: **13 / 13 SP (100% Passed)**, 94/94 tests pass, phát hành tag `v1.0.0`.
