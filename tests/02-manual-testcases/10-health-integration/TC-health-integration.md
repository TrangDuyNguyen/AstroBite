# Manual Testcases — Health Integration (FEAT-10 / EPIC-10)

- **Tính năng**: Apple Health / Health Connect Integration
- **Phiên bản**: v1.2.0 (Sprint 03)
- **Phương pháp**: EP & BVA
- **Tham chiếu**: [`prd-health-integration.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/10-health-integration/prd-health-integration.md), [`user-stories.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/10-health-integration/user-stories.md)

---

## TC-HLTH-001: Kết nối Apple Health thành công (iOS)
- **Tiêu chí**: FR-01, US-01 Scenario 1
- **Precondition**: iOS device, chưa kết nối Health
- **Steps**:
  1. Vào Profile → Settings → Kết nối Sức khỏe
  2. Bấm "Kết nối"
  3. HealthKit dialog: bấm "Allow All"
- **Expected**:
  - Trạng thái đổi "Đã kết nối ✅"
  - SnackBar "Đã kết nối Apple Health thành công"
  - Firestore: `health_connected = true`
- **Priority**: High

## TC-HLTH-002: Kết nối Health Connect thành công (Android)
- **Tiêu chí**: FR-01, US-01 Scenario 2
- **Precondition**: Android 14+ device
- **Steps**: Tương tự TC-HLTH-001 cho Android
- **Expected**: Tương tự TC-HLTH-001
- **Priority**: High

## TC-HLTH-003: Từ chối quyền
- **Tiêu chí**: US-01 Scenario 3
- **Steps**:
  1. Bấm "Kết nối"
  2. Bấm "Don't Allow" trên dialog OS
- **Expected**:
  - Trạng thái vẫn "Chưa kết nối"
  - UI giải thích lý do cần quyền
  - Nút "Mở Cài đặt" dẫn đến OS Settings
- **Priority**: High

## TC-HLTH-004: Hiển thị Energy Balance
- **Tiêu chí**: FR-04, US-03 Scenario 1
- **Precondition**: Đã kết nối, log bữa sáng 450 + trưa 650 kcal, Health ghi 420 kcal burned
- **Steps**:
  1. Mở tab Analytics
- **Expected**:
  - Calo nạp: 1100 kcal (🔵 primary)
  - Calo đốt: 420 kcal (🩷 secondary)
  - Net Calories: 680 kcal
  - Ngân sách: 1320 kcal
  - Progress arc 34% filled
- **Priority**: High

## TC-HLTH-005: Hiển thị Steps & Workouts
- **Tiêu chí**: FR-02, US-02 Scenario 1
- **Precondition**: Đã kết nối, Health có 8234 bước + Chạy bộ 30p + Gym 45p
- **Expected**:
  - Steps card: 8,234 bước, 5.8 km
  - Workouts: "🏃 Chạy bộ 30p — 285 kcal", "💪 Gym 45p — 135 kcal"
- **Priority**: High

## TC-HLTH-006: Chưa có dữ liệu vận động
- **Tiêu chí**: US-02 Scenario 2
- **Precondition**: Đã kết nối nhưng chưa vận động
- **Expected**:
  - Calo đốt: 0 kcal
  - Steps: 0 với "Hãy bắt đầu di chuyển nào! 🚶"
- **Priority**: Medium

## TC-HLTH-007: Ngắt kết nối
- **Tiêu chí**: FR-05, US-04
- **Steps**:
  1. Vào Settings → Kết nối Sức khỏe
  2. Bấm "Ngắt kết nối"
  3. Bấm "Xác nhận" trên dialog
- **Expected**:
  - Trạng thái: "Chưa kết nối"
  - Energy Balance Card ẩn khỏi Analytics
  - SnackBar: "Đã ngắt kết nối Health"
- **Priority**: Medium

## TC-HLTH-008: Ghi calo ngược về Health (Toggle bật)
- **Tiêu chí**: FR-03, US-05 Scenario 1
- **Precondition**: Đã kết nối, toggle "Đồng bộ calo" BẬT
- **Steps**:
  1. Lưu bữa trưa 450 kcal qua Tracker
- **Expected**:
  - Bữa ăn lưu thành công
  - 1 bản ghi Dietary Energy 450 kcal ghi vào HealthKit/Health Connect
- **Priority**: Medium

## TC-HLTH-009: Toggle tắt — không ghi
- **Tiêu chí**: US-05 Scenario 2
- **Precondition**: Toggle "Đồng bộ calo" TẮT
- **Steps**:
  1. Lưu bữa ăn
- **Expected**:
  - Bữa ăn lưu thành công
  - Không ghi gì vào Health Platform
- **Priority**: Medium

## TC-HLTH-010: Empty state chưa kết nối
- **Tiêu chí**: UI Empty State
- **Precondition**: Chưa bao giờ kết nối Health
- **Steps**: Mở Analytics tab
- **Expected**:
  - Banner: "Kết nối Apple Health để xem calo đốt cháy 🏃" + nút "Kết nối"
  - Không hiển thị Energy Balance Card hoặc Steps Card
- **Priority**: Low
