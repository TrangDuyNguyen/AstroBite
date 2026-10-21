# ADR-039 & Architectural Spec: Water Intake & Hydration Tracker (Sprint 33)

> **Sub-Agent**: Tech Lead & System Architect (`tech-lead`)  
> **Gate**: Gate 0 (Tech Spike & Architecture Decision Record)  
> **Feature**: `FEAT-S33-WATER-TRACKER` | **Target Version**: `v3.5.0`  
> **Status**: ✅ **APPROVED & SIGNED-OFF**

---

## 1. Context & Business Drivers

- **Goal**: Cung cấp tính năng ghi nhận và nhắc nhở uống nước (Water Intake Tracker) mượt mà 60 FPS, tích hợp trực tiếp trên Home Dashboard và trang Daily Tracker của AstroBite.
- **Vấn đề cần giải quyết**:
  - Ghi nhận nhanh (Quick Log: +250ml, +500ml) chỉ bằng 1 cú chạm (1-tap interaction), không được làm khựng UI hoặc chờ mạng.
  - Hoạt động offline 100%: Khi mất mạng, dữ liệu vẫn được ghi nhận tức thì vào local cache và tự động đồng bộ lên Cloud Firestore khi có kết nối trở lại.
  - Reset theo ngày (00:00 mỗi ngày) theo múi giờ địa phương của thiết bị.

---

## 2. Decision & Architecture (ADR-039)

### 2.1 State Management & Data Flow (Riverpod 2.x)
- Sử dụng `@riverpod` `Notifier<AsyncValue<WaterDayLog>>` trong `lib/features/tracker/presentation/controllers/water_controller.dart`.
- Tách biệt rõ ràng:
  - **Domain (`lib/features/tracker/domain/`)**:
    - `water_log.dart`: `@freezed` immutable entity `WaterDayLog` và `WaterEntry`.
    - `water_preset.dart`: Enhanced Enum `WaterQuickPreset` (glass250, bottle500, custom) đóng gói metadata `amountMl`, `label`, `icon`.
    - `water_goal_calculator.dart`: Pure function tính nhu cầu nước khuyến nghị:
      $$\text{Target (ml)} = \text{weightKg} \times 35 + (\text{activeMinutes} / 30) \times 350$$
  - **Data (`lib/features/tracker/data/`)**:
    - `water_repository.dart`: Chiến lược Cache-First (Local SharedPreferences JSON cache $\rightarrow$ Stream Firestore collection `users/{uid}/water_logs/{yyyyMMdd}`).
  - **Presentation (`lib/features/tracker/presentation/widgets/`)**:
    - `clay_water_card.dart`: Thẻ Claymorphic hiển thị tiến độ nước, wave animation 60 FPS, 2 nút quick-log +250ml / +500ml.

### 2.2 Storage Strategy (Zero Bloat - Strict Ponytail)
- **NO new packages**: Tuyệt đối không cài thêm SQLite, Isar hay Realm.
- Sử dụng hạ tầng sẵn có: `shared_preferences` cho local hot cache và `cloud_firestore` cho cloud persistence.

### 2.3 Performance & Ergonomics SLA
- Cold start: $\le 1.8\text{s}$.
- FPS: 60 FPS ổn định với `CustomPainter` vẽ làn sóng nước mượt mà, giải phóng `AnimationController` sạch sẽ (0 memory leak).
- Code limit: $\le 200\text{ lines}$ cho từng widget và controller.

---

## 3. Feasibility Sign-off (Gate 0 Clearance)

- **Feasibility**: 100% khả thi với Riverpod 2.x và Canvas `CustomPainter`.
- **Rủi ro kỹ thuật**: Đã có giải pháp xử lý lệch múi giờ (lưu UTC ISO string cho từng entry và định dạng ngày local `yyyyMMdd` cho key tài liệu).
- **Chuyển giao**: Bàn giao context cho **Sub-Agent BA (`business-analyst`)** để tiến hành soạn PRD & User Stories BDD tại Gate 1.
