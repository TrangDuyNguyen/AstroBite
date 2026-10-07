# Master Test Plan & BVA Matrix: Social Guilds & Planetary Challenges (Gate 3)

> **Dự án**: AstroBite (`astrobite`)  
> **Mã Epic / Feature**: `EPIC-14` / `FEAT-S21-GUILDS`  
> **Người thiết kế**: Sub-Agent QA Tester — *The Paranoid Inquisitor*  
> **Tiêu chuẩn kiểm thử**: 100% Traceability, Zero-Tolerance đối với kiểm thử hình thức (No Fake Green Test)  
> **Trạng thái**: 🟢 **GATE 3 TEST DESIGN APPROVED**

---

## 1. Chiến Lược Kiểm Thử (Test Strategy & Threat Model)

Dưới góc nhìn của *The Paranoid Inquisitor*, tính năng Social Guilds có các rủi ro hệ thống sau:
1. **Rủi ro Race Condition / Concurrency**: Nhiều thành viên trong cùng 1 bang hội cùng log bữa ăn tại cùng 1 giây dẫn đến mất điểm đóng góp nếu không dùng Atomic Increment.
2. **Rủi ro Tràn Giới Hạn Thành Viên**: Bang hội vượt quá 20 thành viên do hai người dùng cùng bấm "Gia nhập" tại cùng một thời điểm.
3. **Rủi ro Đầu Vào Ác Ý (Malicious Input)**: Tên bang hội chứa mã độc XSS/Script, khoảng trắng thừa, hoặc ký tự đặc biệt phá vỡ Firestore query.
4. **Rủi ro Gian Lận Điểm Số (Score Manipulation)**: Người dùng spam nút log để gian lận điểm XP cho Bang hội.

---

## 2. Ma Trận Phân Vùng Tương Đương & Phân Tích Giá Trị Biên (EP & BVA Matrix)

### 2.1. Phân Tích Biên Tên Bang Hội (Guild Name) — Giới Hạn [3..30 Ký Tự]

| Test ID | Đầu Vào Thử Nghiệm | Phân Vùng | Giá Trị Biên | Kết Quả Mong Đợi |
| :--- | :--- | :---: | :---: | :--- |
| `TC-NAME-01` | `""` (Rỗng) | Không hợp lệ | $N = 0$ | Báo lỗi: "Tên bang hội không được để trống" |
| `TC-NAME-02` | `"AB"` (2 ký tự) | Không hợp lệ | $N = 2$ ($Min - 1$) | Báo lỗi: "Tên bang hội phải từ 3 đến 30 ký tự" |
| `TC-NAME-03` | `"ABC"` (3 ký tự) | Hợp lệ | $N = 3$ ($Min$) | Tạo thành công |
| `TC-NAME-04` | `"Sao Hỏa Thần Tốc"` (16 ký tự)| Hợp lệ | Trung bình | Tạo thành công |
| `TC-NAME-05` | `30 ký tự chuẩn` | Hợp lệ | $N = 30$ ($Max$) | Tạo thành công |
| `TC-NAME-06` | `31 ký tự` | Không hợp lệ | $N = 31$ ($Max + 1$)| Báo lỗi: "Tên bang hội tối đa 30 ký tự" |
| `TC-NAME-07` | `"   "` (Toàn khoảng trắng)| Không hợp lệ | - | Bị trim() và báo lỗi rỗng |

### 2.2. Phân Tích Biên Mã Mời (Invite Code) — Đúng 6 Ký Tự Alphanumeric

| Test ID | Đầu Vào Thử Nghiệm | Phân Vùng | Kết Quả Mong Đợi |
| :--- | :--- | :---: | :--- |
| `TC-CODE-01` | `""` (Rỗng) | Không hợp lệ | Chặn nút "Gia nhập", báo lỗi mã rỗng |
| `TC-CODE-02` | `"MARS1"` (5 ký tự) | Không hợp lệ ($L < 6$) | Báo lỗi: "Mã mời phải gồm đúng 6 ký tự" |
| `TC-CODE-03` | `"mars01"` (chữ thường) | Hợp lệ | Hệ thống tự động uppercase thành `MARS01` và xác thực |
| `TC-CODE-04` | `"MARS01"` (chuẩn 6 ký tự) | Hợp lệ | Tìm thấy bang hội và gia nhập thành công |
| `TC-CODE-05` | `"MARS001"` (7 ký tự) | Không hợp lệ ($L > 6$) | Báo lỗi: "Mã mời phải gồm đúng 6 ký tự" |
| `TC-CODE-06` | `"NOT_EX"` (Không tồn tại) | Không hợp lệ | Báo lỗi: "Không tìm thấy Bang hội với mã mời này" |

### 2.3. Phân Tích Giới Hạn Số Lượng Thành Viên (Member Capacity) — Tối Đa 20

| Test ID | Trạng Thái Bang Hội Hiện Tại | Hành Động | Kết Quả Mong Đợi |
| :--- | :---: | :---: | :--- |
| `TC-MEM-01` | 0 thành viên (Mới tạo) | Khởi tạo bởi Leader | Trở thành 1/20, vai trò Leader |
| `TC-MEM-02` | 19 thành viên | Thành viên thứ 20 join | Thành công, cập nhật số lượng thành 20/20 |
| `TC-MEM-03` | 20 thành viên (Đã đầy) | Người dùng mới nhập mã join | Từ chối: "Bang hội đã đạt tối đa 20 thành viên" |

### 2.4. Phân Tích Đồng Bộ Điểm Năng Lượng (Atomic Starlight XP)

| Test ID | Tình Huống Concurrency | Cơ Chế Xử Lý | Kết Quả Mong Đợi |
| :--- | :--- | :--- | :--- |
| `TC-XP-01` | 1 người dùng log 1 bữa ăn | +50 XP | Điểm cá nhân +50, điểm Bang hội +50 tức thì |
| `TC-XP-02` | 2 thành viên cùng log bữa ăn tại cùng 1 giây | Firestore `FieldValue.increment(50)` | Điểm Bang hội tăng chính xác +100 XP (không bị mất điểm) |
| `TC-XP-03` | Người dùng offline ghi nhật ký | Local cache queue | Điểm tăng trên máy, khi online đồng bộ mượt mà |

---

## 3. Kịch Bản Kiểm Thử Tự Động Hóa (Gherkin Scenarios)

```gherkin
Feature: Social Guilds and Planetary Challenges
  As a user of AstroBite
  I want to create, join, and collaborate in a Guild
  So that I can achieve nutrition goals together with my peers

  Scenario: Create a guild successfully with valid inputs
    Given the user is authenticated and has no active guild
    When the user navigates to the Create Guild screen
    And enters name "Vệ Binh Sao Hỏa" and selects planet "mars"
    And taps the "Khởi Tạo Bang Hội" button
    Then a new guild is created with 1 member
    And a unique 6-character uppercase invite code is generated
    And the user is redirected to the Guild Dashboard

  Scenario: Reject invalid invite code with less than 6 characters
    Given the user is on the Join Guild dialog
    When the user enters "MARS1"
    Then the submit button is disabled or validation error is shown
    And no network request is sent to Firestore

  Scenario: Auto increment Starlight XP on meal log
    Given the user belongs to guild "Vệ Binh Sao Hỏa" with 1,000 XP
    When the user logs a valid meal
    Then the user's weekly contribution increases by 50 XP
    And the guild's total Starlight XP increments to 1,050 XP
    And the challenge progress arc reflects the updated percentage
```

---

## 4. Cam Kết Tiêu Chuẩn Gate 3 Sign-Off

- [x] 100% kịch bản User Stories đã được ánh xạ thành Test Cases chi tiết.
- [x] Đầy đủ các ca biên $Min, Min-1, Max, Max+1$.
- [x] Kịch bản Concurrency và Atomic Increment được đặc tả rõ ràng cho Dev FE và Cloud Dev thực thi.
- [x] Bàn giao sang **Gate 4 (Dev Team)** để tiến hành viết code Clean Architecture chuẩn Ponytail.
