# Ma Trận Thiết Bị & Môi Trường Kiểm Thử (Test Environment Matrix)

## 1. Nền Tảng iOS (Apple Devices)

| Thiết bị | Phiên bản iOS | Độ phân giải | Tỷ lệ màn hình | Mức độ ưu tiên |
| :--- | :--- | :--- | :--- | :---: |
| **iPhone 15 Pro** | iOS 17.x / 18.x | 1179 x 2556 | 19.5:9 (Dynamic Island) | **P1 (Tier 1)** |
| **iPhone 13** | iOS 16.x / 17.x | 1170 x 2532 | 19.5:9 (Notch) | **P1 (Tier 1)** |
| **iPhone SE (3rd gen)**| iOS 16.x | 750 x 1334 | 16:9 (Màn hình nhỏ) | **P2 (Tier 2)** |
| **iPad Air (5th gen)** | iPadOS 17.x | 1640 x 2360 | 4:3 (Tablet layout) | **P3 (Tier 3)** |

---

## 2. Nền Tảng Android (Google Ecosystem)

| Thiết bị mẫu | Phiên bản Android | Độ phân giải | Chipset / RAM | Mức độ ưu tiên |
| :--- | :--- | :--- | :--- | :---: |
| **Google Pixel 8** | Android 14 / 15 | 1080 x 2400 | Google Tensor G3, 8GB | **P1 (Tier 1)** |
| **Samsung Galaxy S23**| Android 14 (OneUI 6)| 1080 x 2340 | Snapdragon 8 Gen 2, 8GB | **P1 (Tier 1)** |
| **Xiaomi Redmi Note 12**| Android 13 (MIUI) | 1080 x 2400 | Snapdragon 685, 4GB | **P1 (Tier 1 - Low-end)**|
| **Samsung Galaxy Z Flip5**| Android 14 | 1080 x 2640 | Màn hình gập Foldable | **P2 (Tier 2)** |

---

## 3. Môi Trường Backend & Mạng
- **Môi trường Test**: Firebase Project Staging (`astrobite-staging`).
- **Điều kiện Mạng**:
  - Wi-Fi tốc độ cao (> 50 Mbps).
  - 4G LTE bình thường (10 - 20 Mbps).
  - Mạng 3G yếu / Throttled Network (300 kbps, latency 400ms) để test timeout & retry.
  - Airplane Mode (Không có kết nối mạng) để test Offline Persistence.
