# PRD: Sprint 19 - Multi-Region Food Culture Intelligence (Vietnamese Culinary Decomposition Engine)

- **Mã Epic**: `EPIC-GLOBAL`
- **Mã Feature**: `FEAT-S19-GLOBAL-CUISINE`
- **Người soạn thảo**: Sub-Agent Business Analyst (BA) — *The Pedantic Logician*
- **Người thẩm định**: Sub-Agent Product Owner (PO) — *The Strategic Tyrant* & Sub-Agent Tech Lead
- **Trạng thái**: 🟡 Submitted for Gate 1 Review
- **Phiên bản mục tiêu**: `v2.9.0`
- **Đối chiếu QA**: `test/features/scanner/`
- **Đối chiếu FE**: `lib/features/scanner/`

---

## 1. Bối Cảnh Nghiệp Vụ & Nỗi Đau Người Dùng (Problem Statement)

Trong các phiên bản từ v1.0.0 đến v2.8.0, module Gemini Food Scanner AI đã bóc tách hiệu quả các món ăn đơn lẻ hoặc khay cơm tiêu chuẩn. Tuy nhiên, đối với ẩm thực Việt Nam và Đông Nam Á:
1. **Sự sai lệch lớn từ Nước Dùng (Broth)**:
   - Các món nước như Phở, Bún bò Huế, Hủ tiếu Nam Vang, Canh chua có lượng calo và natri tập trung cao ở nước hầm xương, mỡ nổi và gia vị ninh (chiếm 35% – 45% tổng calo và 65% – 80% natri của bát).
   - Hành vi người dùng thực tế: Đa số người ăn kiêng, tập gym chỉ ăn bún và thịt/rau, không húp hết nước lèo. Trước đây, app tự động tính 100% dinh dưỡng cả bát, khiến người dùng bị tính dôi dư 150 – 250 kcal và vượt ngưỡng natri cảnh báo.
2. **Sự bất tiện với Món Phối Hợp / Combo Toppings**:
   - Cơm tấm sườn bì chả mỡ hành, Bánh mì thịt sốt pate, Xôi mặn, Trà sữa full topping.
   - Khi người dùng chủ động yêu cầu "không mỡ hành" (-60 kcal) hoặc "bỏ tóp mỡ" (-100 kcal), app trước đây gom toàn bộ thành 1 món duy nhất, buộc người dùng phải xóa bỏ cả món để gõ thủ công từng nguyên liệu.
3. **Thống kê ma sát**: 68% số lần người dùng phải chỉnh sửa thủ công sau khi scan đến từ các món nước và món đĩa phối hợp này.

---

## 2. Mục Tiêu Nghiệp Vụ Đo Lường Được (OKRs & Success Metrics)

* **M1 (Retention D30 Booster)**: Thúc đẩy tỷ lệ giữ chân D30 tăng thêm **+12%** nhờ loại bỏ hoàn toàn ma sát nhập liệu tại tính năng cốt lõi (Core Daily Loop Scanner).
* **M2 (Cắt Giảm Time-to-Log)**: Giảm thời gian điều chỉnh món Việt phức tạp từ 12s xuống **< 2.5s** thông qua công tắc Toggle và Checklist 1 chạm.
* **M3 (AI Latency Budget)**: Cam kết độ trễ nhận diện One-Pass Gemini Vision **≤ 2.2s** trên kết nối mạng tiêu chuẩn, không gây gián đoạn trải nghiệm người dùng (SLA tối đa 2.5s).
* **M4 (Tỷ Lệ Nhận Diện Chính Xác Món Phức Hợp)**: Đạt tỷ lệ bóc tách đúng thành phần nước dùng và toppings **≥ 90%** trên tập dữ liệu kiểm thử 50 món ăn Việt phổ biến.

---

## 3. Chân Dung Người Dùng (Target Personas)

1. **Persona A: Dân Văn Phòng Ăn Quán (Office Worker / Casual Eater)**:
   - Thói quen: Ăn trưa nhanh với Phở, Cơm tấm, Bún bò.
   - Nhu cầu: Scan 1 chạm, gạt nhanh toggle "Chỉ ăn cái" hoặc bỏ tick "Mỡ hành" trong dưới 3 giây rồi cất máy ăn tiếp.
2. **Persona B: Gymer / Fitness Enthusiast Giảm Mỡ**:
   - Thói quen: Cắt giảm calo và hạn chế tích nước do muối (Sodium).
   - Nhu cầu: Cần biết chính xác nếu bỏ nước phở thì tiết kiệm được bao nhiêu calo và giảm bao nhiêu mg natri.

---

## 4. Luồng Trải Nghiệm Người Dùng (User Journey & Flow)

```
[Chụp ảnh / Chọn ảnh món ăn]
            │
            ▼
[Gemini Vision One-Pass API] ➔ Phân tích JSON có `has_broth` & `sub_items` (Latency ≤ 2.2s)
            │
            ▼
[Màn hình ScanReviewPage]
    ├── Nếu `has_broth == true`:
    │     Hiển thị Broth Toggle: [🍜 Ăn cả nước] ⟷ [🥢 Chỉ ăn cái]
    │     (Mặc định: [🍜 Ăn cả nước]; Gạt sang [🥢 Chỉ ăn cái] ➔ Giảm ~40% Calo & ~73% Muối)
    │
    ├── Nếu `sub_items.isNotEmpty`:
    │     Hiển thị Topping Mini Checklist (Sườn, Chả, Bì, Mỡ hành...)
    │     (Mặc định: Tất cả được tick chọn; Chạm bỏ tick ➔ Trừ calo topping tương ứng)
    │
    └── Cập nhật tức thời:
          ChunkyMacroBar & CalorieProgressArc tự động nhảy số theo thời gian thực (< 50ms)
            │
            ▼
[Bấm "Lưu Nhật Ký"] ➔ Ghi nhận bản ghi chính xác vào Firestore / Hive Local Cache
```

---

## 5. Danh Sách Yêu Cầu Chức Năng (Functional Requirements)

### FR-01: Bóc Tách Nước Dùng Trong Mô Hình Dữ Liệu AI (One-Pass Gemini Prompt)
- Hệ thống gửi ảnh tới Gemini 2.0 Flash với System Prompt hướng dẫn phân tách ẩm thực Việt.
- DTO trả về chứa:
  - `has_broth` (bool): `true` nếu món là món nước (Phở, Bún, Hủ tiếu, Canh...).
  - `broth_calories` (int): Lượng calo riêng của nước dùng (chiếm 35–45% tổng calo).
  - `broth_sodium_mg` (double): Lượng muối trong nước dùng (chiếm 65–80% natri).
  - `include_broth` (bool): Trạng thái người dùng chọn có ăn nước hay không (mặc định `true`).

### FR-02: Phân Rã Món Combo Đa Thành Phần (Sub-Items / Toppings)
- Đối với món combo (Cơm tấm, Bánh mì, Xôi thập cẩm), Gemini trả về danh sách `sub_items`:
  - Mỗi phần tử gồm: `name` (tên món phụ), `calories` (calo riêng), `carbs_g`, `protein_g`, `fat_g`, `is_selected` (mặc định `true`).

### FR-03: Công Tắc Broth Toggle Trên ScanReviewPage
- Thẻ món ăn hiển thị chip chuyển đổi công thái học bo góc 24pt chuẩn Claymorphic:
  - Trạng thái 1: `[🍜 Ăn cả nước (+X kcal)]` (Nền Sky Blue `#E5F6FD`, viền `#1CB0F6`).
  - Trạng thái 2: `[🥢 Chỉ ăn cái (-X kcal, giảm Y% Muối)]` (Nền Mint `#E8F9D8`, viền `#58CC02`).
- Thao tác 1 chạm, có phản hồi xúc giác nhẹ (Haptic Feedback).

### FR-04: Topping Checklist Tương Tác Trực Tiếp
- Danh sách topping hiển thị dạng `Wrap` các chip nhỏ gọn.
- Khi người dùng tap bỏ chọn 1 topping:
  - Chip chuyển sang trạng thái xám gạch ngang.
  - Tổng calo món ăn và tổng calo toàn bữa lập tức trừ đi lượng calo tương ứng.
  - Không reload toàn màn hình; cập nhật mượt mà 60 FPS.

### FR-05: Lưu Trữ & Đồng Bộ Dữ Liệu Nhật Ký
- Khi lưu vào Firestore / Local Hive Cache:
  - Lưu đầy đủ metadata `has_broth`, `broth_calories`, `include_broth` và danh sách `sub_items`.
  - Calo và Macro của `meal_logs` phản ánh chính xác con số cuối cùng sau khi người dùng đã tùy chỉnh toggle/toppings.

---

## 6. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

* **NFR-01 (Độ Trễ Phản Hồi)**: Thời gian gọi Gemini Vision và parse dữ liệu hoàn tất `≤ 2.2s` trên mạng 4G/WiFi. Thao tác toggle nút bấm phản hồi giao diện `< 16ms` (60 FPS).
* **NFR-02 (Zero Regression & Backward Compatibility)**: Bản ghi cũ không có trường `has_broth` hoặc `sub_items` phải được deserialized an toàn với giá trị mặc định (`has_broth: false`, `sub_items: []`). Tuyệt đối không gây crash (`NullPointerException = 0`).
* **NFR-03 (Công Thái Học & An Toàn Giao Diện)**: Nút Toggle và các Chip Topping đạt touch target tối thiểu `44x44pt`. Đảm bảo `0 RenderFlex overflow` trên mọi độ phân giải màn hình từ 320pt (iPhone SE) đến máy tính bảng.
* **NFR-04 (Nguyên Tắc Màu Dinh Dưỡng Bất Biến)**: Carbs `#1CB0F6` (Sky Blue), Fat `#FF5C8D` (Strawberry Pink), Protein `#FF9600` (Honey Tangerine) theo đúng token `AppColors`.
