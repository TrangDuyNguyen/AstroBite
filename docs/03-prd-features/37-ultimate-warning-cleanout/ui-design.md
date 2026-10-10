# Gate 2 UI Blueprint & Layout Spec: Sprint 30 — Ultimate Warning Cleanout

> **Chủ trì**: Sub-Agent UI/UX Designer (*The Celestial Aesthetic Purist*)  
> **Người duyệt**: Sub-Agent BA & Sub-Agent PO  
> **Ngày phê duyệt**: 2026-10-10  
> **Trạng thái**: 🟢 **GATE 2 SIGNED-OFF**

---

## 1. Blueprint Thiết Kế Cho 4 Nhóm Giao Diện

### 1.1 Zero Gravity Food Background
- **Specs Tọa Độ**: 10 điểm neo tương đối (`relativeX`, `relativeY`, `size`, `amplitudeY`, `amplitudeX`, `speed`, `phase`).
- **Painter**: `CosmicStardustPainter` vẽ 10 ngôi sao micro-sparkle tỏa hào quang 4 cánh.
- **Surface**: `Clay3DFoodArt` + `Container` ánh xạ hào quang nebula `auraColor` mờ ảo.

### 1.2 Health Components
- **`EnergyBalanceCard`**:
  - `ClayCard` (radius 20pt, elevation 4).
  - Vòng tiến trình tròn `CircularProgressIndicator` (strokeWidth 8, Primary Blue).
  - Row hiển thị 2 metrics (Calo In: `#1CB0F6`, Calo Out: `#FF5C8D`).
- **`StepsActivityCard`**:
  - `ClayCard` (radius 20pt, elevation 4).
  - Bảng thống kê bước chân (`AppColors.onSurface`, bold) và danh sách workouts kèm icon.

### 1.3 Guild Member Action Sheet
- **`MemberActionHeaderCard`**:
  - Avatar tròn 52pt với màu pastel theo vai trò (`clayDinner` cho Leader, `clayLunch` cho Elder, `clayMint` cho Member).
  - Role Badge (8pt radius, 1pt border).
  - Streak flame và XP tuần màu `AppColors.brandGreen`.
- **`MemberActionDialogs`**:
  - `showTransferDialog`: Xác nhận quyền Bang Chủ màu tím `#7C3AED`.
  - `showKickDialog`: Xác nhận trục xuất màu đỏ `#EF4444`.
