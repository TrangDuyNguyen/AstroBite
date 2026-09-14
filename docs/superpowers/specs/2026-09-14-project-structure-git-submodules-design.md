# Kiến Trúc Cấu Trúc Dự Án & Quản Trị Git Submodule — AstroBite

- **Tài liệu**: Thiết kế Kiến trúc Thư mục & Quản trị Đa Repository (Git Submodules)
- **Dự án**: AstroBite (`astrobite`)
- **Ngày lập**: 2026-09-14
- **Trạng thái**: Draft / Đã thẩm định thiết kế
- **Tác giả / Phê duyệt**: Pair Programming Brainstorming

---

## 1. Bối cảnh & Mục tiêu (Context & Objectives)

### 1.1. Bối cảnh
AstroBite là ứng dụng theo dõi dinh dưỡng và quét calo thông minh đa nền tảng (iOS & Android) bằng AI Gemini 2.0 Flash và Firebase. Hiện tại, toàn bộ mã nguồn đang tập trung ở một repository đơn nhất. Để mở rộng quy mô phát triển, phân tách trách nhiệm rõ ràng giữa các bộ phận (Business Analyst, Quality Assurance, Frontend Developer) và hỗ trợ quản trị phiên bản linh hoạt, dự án cần một cấu trúc tổ chức mới theo mô hình Super-Repo với Git Submodules.

### 1.2. Mục tiêu cốt lõi
1. **Phân quyền & Độc lập**: Tách biệt 3 nhóm tài nguyên thành 3 Git repository độc lập:
   - **Tài liệu chuẩn BA** (`astrobite-ba-docs`)
   - **Testcase & Kịch bản QA** (`astrobite-testcases`)
   - **Mã nguồn Frontend Flutter** (`astrobite-frontend`)
2. **Quản trị tập trung (Super-Repo)**: `AstroBite` đóng vai trò Root Workspace Coordinator, lưu trữ con trỏ commit (commit pin) đồng bộ của cả 3 submodule.
3. **Tính truy vết 1:1 (Traceability Matrix)**: Mọi yêu cầu nghiệp vụ từ BA (User Story, Acceptance Criteria) liên kết trực tiếp với Testcase của QA và Module mã nguồn của Frontend.
4. **Tự động hóa & Tiêu chuẩn hóa**: Cung cấp bộ kịch bản tự động (Makefile, shell scripts) cho việc clone, đồng bộ và commit, giảm thiểu rủi ro xung đột hay lỗi Detached HEAD trong Git Submodule.

---

## 2. Kiến trúc Tổng thể Super-Repo (Root Workspace)

### 2.1. Sơ đồ Cấu trúc Cấp cao
```
AstroBite/ (Super-Repo / Workspace Coordinator)
├── .git/
├── .gitmodules                         # Cấu hình ánh xạ các submodule
├── .gitignore                          # Loại trừ file build, cache OS/IDE
├── README.md                           # Tài liệu tổng quan & hướng dẫn phát triển chung
├── Makefile                            # Tiện ích quản trị tự động cho lập trình viên
│
├── scripts/                            # Shell scripts hỗ trợ quản trị Submodule
│   ├── setup-workspace.sh              # Khởi tạo toàn bộ submodule khi mới clone
│   ├── sync-submodules.sh              # Kéo bản cập nhật mới nhất từ remote
│   ├── check-status.sh                 # Kiểm tra nhanh diff và branch của các module
│   └── release-tag.sh                  # Tạo tag phiên bản đồng bộ cho Super-repo
│
├── .github/workflows/                  # CI/CD Workflows ở tầng Root
│   ├── submodule-integrity.yml         # Kiểm tra tính toàn vẹn commit pin của submodule
│   └── full-pipeline-validation.yml    # Kích hoạt test của FE khi có thay đổi
│
├── docs/                               # 📁 [Git Submodule] -> astrobite-ba-docs
├── tests/                              # 📁 [Git Submodule] -> astrobite-testcases
└── frontend/                           # 📁 [Git Submodule] -> astrobite-frontend
```

### 2.2. Đặc tả Cấu hình `.gitmodules`
```ini
[submodule "docs"]
	path = docs
	url = https://github.com/TrangDuyNguyen/astrobite-ba-docs.git
	branch = main

[submodule "tests"]
	path = tests
	url = https://github.com/TrangDuyNguyen/astrobite-testcases.git
	branch = main

[submodule "frontend"]
	path = frontend
	url = https://github.com/TrangDuyNguyen/astrobite-frontend.git
	branch = main
```

---

## 3. Chi tiết Submodule 1: Tài liệu Chuẩn BA (`docs/`)

- **Repository**: `astrobite-ba-docs`
- **Tiêu chuẩn áp dụng**: BABOK (Business Analysis Body of Knowledge), Agile Docs-as-Code, Gherkin BDD.
- **Đường dẫn trong Super-repo**: `docs/`

### 3.1. Cây thư mục chi tiết
```
docs/
├── README.md                            # Tổng quan kho tài liệu BA & quy ước viết Docs-as-Code
├── 01-overview/                         # Định hướng chiến lược & tầm nhìn sản phẩm
│   ├── product-vision.md                # Tầm nhìn, giá trị cốt lõi, mục tiêu kinh doanh, OKRs
│   ├── stakeholder-matrix.md            # Ma trận RACI, vai trò của các bên liên quan
│   └── glossary-terms.md                # Từ điển thuật ngữ (TDEE, BMR, Macro, Portion, Gemini AI...)
│
├── 02-business-rules/                   # Quy tắc nghiệp vụ cốt lõi (Core Business Rules)
│   ├── nutrition-algorithms.md          # Công thức BMR Mifflin-St Jeor, tính TDEE, tỷ lệ Carbs/Fat/Protein
│   ├── ai-vision-policy.md              # Quy định nhận diện ảnh món ăn (Gemini 2.0 Flash), độ tin cậy, disclaimer
│   └── compliance-privacy.md            # Chính sách bảo mật dữ liệu sức khỏe người dùng & quyền riêng tư
│
├── 03-prd-features/                     # Đặc tả sản phẩm chi tiết theo từng Feature Module
│   ├── 01-auth-onboarding/              # Module Xác thực & Khảo sát ban đầu
│   │   ├── prd-auth-onboarding.md       # Mục tiêu, User Personas, User Journey Map
│   │   ├── user-stories.md              # Danh sách User Story & Acceptance Criteria (Given-When-Then)
│   │   └── ui-ux-screen-specs.md        # Luồng màn hình, trạng thái tương tác, link Figma
│   ├── 02-food-scanner-ai/              # Module Quét ảnh thức ăn bằng Gemini AI
│   │   ├── prd-food-scanner.md
│   │   ├── user-stories.md              # Kịch bản chụp ảnh, thư viện, chỉnh sửa khẩu phần
│   │   └── ui-ux-screen-specs.md
│   ├── 03-diary-calorie-tracker/        # Module Nhật ký calo & phân bổ bữa ăn (Sáng, Trưa, Tối, Snack)
│   │   ├── prd-calorie-tracker.md
│   │   ├── user-stories.md
│   │   └── ui-ux-screen-specs.md
│   ├── 04-analytics-insights/           # Module Thống kê & xu hướng dinh dưỡng
│   │   ├── prd-analytics.md
│   │   ├── user-stories.md
│   │   └── ui-ux-screen-specs.md
│   └── 05-user-profile-goals/           # Module Hồ sơ cá nhân & điều chỉnh mục tiêu calo
│       ├── prd-user-profile.md
│       ├── user-stories.md
│       └── ui-ux-screen-specs.md
│
├── 04-specifications/                   # Đặc tả kỹ thuật & cấu trúc dữ liệu cho BA
│   ├── data-dictionary.md               # Từ điển thực thể dữ liệu (User, MealLog, FoodItem, Nutrient...)
│   └── third-party-integrations.md      # Yêu cầu tích hợp Gemini API, Firebase Firestore, Auth, Storage
│
├── 05-change-management/                # Quản lý thay đổi yêu cầu
│   └── change-request-log.md            # Bảng theo dõi các yêu cầu thay đổi (Change Request Log)
│
└── templates/                           # Mẫu văn bản chuẩn hóa để tái sử dụng
    ├── template-prd.md                  # Mẫu PRD chuẩn
    ├── template-user-story.md           # Mẫu User Story + BDD Acceptance Criteria chuẩn
    └── template-change-request.md       # Mẫu Change Request chuẩn
```

---

## 4. Chi tiết Submodule 2: Testcases & QA (`tests/`)

- **Repository**: `astrobite-testcases`
- **Tiêu chuẩn áp dụng**: ISTQB, Agile Testing, BDD Gherkin, Mobile App QA Checklist.
- **Đường dẫn trong Super-repo**: `tests/`

### 4.1. Cây thư mục chi tiết
```
tests/
├── README.md                            # Chiến lược kiểm thử & hướng dẫn đóng góp của QA
├── 01-test-strategy-plan/               # Kế hoạch & chiến lược kiểm thử
│   ├── master-test-plan.md              # Phạm vi, tiêu chí chấp nhận (Entry/Exit Criteria), phân bổ tài nguyên
│   ├── test-environment-matrix.md      # Ma trận thiết bị & OS (iOS 15+, Android 10+, các tỷ lệ màn hình)
│   └── defect-management-matrix.md      # Định nghĩa Bug Severity (Blocker/Critical/Major/Minor) & Bug Lifecycle
│
├── 02-manual-testcases/                 # Testcase kiểm thử thủ công (Ánh xạ 1:1 với PRD của BA)
│   ├── 01-auth-onboarding/
│   │   ├── TC-auth-functional.md        # Đăng ký, đăng nhập, quên mật khẩu, logout
│   │   └── TC-onboarding-validation.md  # Kiểm tra tính hợp lệ dữ liệu khảo sát thể trạng ban đầu
│   ├── 02-food-scanner-ai/
│   │   ├── TC-scanner-camera-gallery.md # Chụp từ camera, chọn ảnh từ thư viện, cấp quyền thiết bị
│   │   ├── TC-scanner-ai-response.md    # Ca nhận diện thành công, không nhận diện được, gợi ý món
│   │   └── TC-scanner-portion-edit.md   # Chỉnh sửa khẩu phần, khối lượng và thêm món thủ công
│   ├── 03-diary-calorie-tracker/
│   │   ├── TC-diary-logging.md          # Thêm, sửa, xoá món ăn trong bữa (Sáng/Trưa/Tối/Snack)
│   │   └── TC-macro-calculation.md      # Kiểm tra độ chính xác thanh calo & tỷ lệ Carbs/Fat/Protein
│   ├── 04-analytics-insights/
│   │   └── TC-analytics-charts.md       # Kiểm tra vẽ biểu đồ FlChart, bộ lọc tuần/tháng/năm
│   └── 05-user-profile-goals/
│       └── TC-profile-goal-setting.md   # Đổi mục tiêu calo, cân nặng mục tiêu, cập nhật profile
│
├── 03-bdd-gherkin-scenarios/            # Kịch bản BDD (.feature) chuẩn Gherkin
│   ├── auth_onboarding.feature          # Kịch bản đăng nhập & onboarding
│   ├── food_scanner_gemini.feature      # Kịch bản quét thức ăn bằng Gemini AI
│   ├── calorie_diary.feature            # Kịch bản ghi nhật ký calo
│   └── profile_management.feature       # Kịch bản quản lý hồ sơ & mục tiêu
│
├── 04-non-functional-tests/             # Kiểm thử phi chức năng
│   ├── performance-testing.md           # Đo FPS cuộn trang, thời gian phản hồi của Gemini Vision AI, memory leak
│   ├── security-compliance.md           # Kiểm tra Firebase App Check, mã hóa token, bảo mật Firestore
│   ├── network-offline-testing.md       # Kiểm tra Firestore offline persistence & retry mechanism
│   └── ui-ux-design-consistency.md      # Đối soát giao diện Celestial Dark UI (AppColors, spacing 4pt, font size)
│
├── 05-test-execution-reports/           # Báo cáo thực thi kiểm thử & nghiệm thu
│   ├── release-sign-offs/               # Biên bản nghiệm thu trước khi đưa app lên store
│   └── sprint-reports/                  # Báo cáo kết quả kiểm thử theo từng Sprint / Milestone
│
└── templates/                           # Mẫu văn bản QA chuẩn hóa
    ├── template-testcase.md             # Mẫu viết Test Case chi tiết
    ├── template-bug-report.md           # Mẫu báo cáo lỗi chi tiết kèm log/screenshot
    └── template-release-checklist.md    # Mẫu checklist kiểm tra trước giờ release
```

---

## 5. Chi tiết Submodule 3: Code FE Flutter (`frontend/`)

- **Repository**: `astrobite-frontend`
- **Tiêu chuẩn áp dụng**: Feature-First Clean Architecture, Celestial Dark UI Design System, Riverpod State Management, AutoRoute.
- **Đường dẫn trong Super-repo**: `frontend/`

### 5.1. Cây thư mục chi tiết
```
frontend/
├── README.md                            # Hướng dẫn setup Flutter SDK, chạy debug, build app
├── pubspec.yaml                         # Quản lý dependencies (Riverpod, AutoRoute, Freezed, FlChart...)
├── pubspec.lock
├── analysis_options.yaml                # Bộ lint rules nghiêm ngặt cho Dart/Flutter
├── android/                             # Mã nguồn native Android
├── ios/                                 # Mã nguồn native iOS
│
├── assets/                              # Tài nguyên tĩnh của ứng dụng
│   ├── icons/                           # Bộ icon vector / SVG (Macro icons, navigation icons)
│   ├── images/                          # Ảnh onboarding, background celestial, placeholders
│   └── fonts/                           # Bộ typography chuẩn (Outfit, Inter)
│
├── lib/                                 # Mã nguồn ứng dụng Dart / Flutter
│   ├── main.dart                        # Khởi tạo App Check, Firebase, ProviderScope, runApp
│   ├── app.dart                         # Root MaterialApp, cấu hình AutoRoute router
│   │
│   ├── core/                            # Tầng nền tảng dùng chung toàn app
│   │   ├── constants/
│   │   │   ├── app_strings.dart         # Chuỗi hằng số, thông báo lỗi đa ngôn ngữ
│   │   │   └── app_values.dart          # Kích thước, padding (4pt grid), radius, animation duration
│   │   ├── router/                      # Cấu hình AutoRoute định tuyến kiểu Type-Safe
│   │   │   ├── app_router.dart
│   │   │   └── app_router.gr.dart       # Sinh tự động bởi build_runner
│   │   ├── theme/                       # Design System Celestial Dark UI
│   │   │   ├── app_colors.dart          # Màu chuẩn bất biến: Carbs (#1A73E8), Fat (#FF69B4), Protein (#FFD700)
│   │   │   └── app_theme.dart           # Cấu hình ThemeData, CardTheme, AppBarTheme
│   │   └── utils/                       # Tiện ích tính toán & phân tích dữ liệu
│   │       ├── nutrition_calculator.dart # Thuật toán tính BMR, TDEE, calo, macro ratio
│   │       └── json_parser.dart         # Tiện ích bóc tách dữ liệu phản hồi từ AI / Firebase
│   │
│   ├── shared/                          # Thành phần UI dùng chung giữa các feature
│   │   └── widgets/
│   │       ├── glass_card.dart          # Card hiệu ứng kính mờ (BackdropFilter blur 20 + surfaceBlur)
│   │       ├── macro_bar.dart           # Thanh hiển thị tỷ lệ dinh dưỡng Carbs/Fat/Protein chuẩn màu
│   │       ├── calorie_progress_arc.dart# Vòng cung tiến trình calo tiêu thụ trong ngày
│   │       ├── meal_type_chip.dart      # Chip chọn bữa ăn (Sáng / Trưa / Tối / Snack)
│   │       └── skeleton_loader.dart     # Hiệu ứng shimmering khi đang chờ AI hoặc mạng
│   │
│   └── features/                        # Phân rã tính năng độc lập (Khớp 1:1 với BA và QA)
│       ├── auth/                        # Xác thực & Onboarding
│       │   ├── domain/                  # Entity, Value Object, Abstract Repositories (Freezed)
│       │   ├── data/                    # Firebase Auth Data Source, DTOs, Repository Implementation
│       │   └── presentation/            # Riverpod Notifiers (@riverpod), Screens (@RoutePage), Widgets
│       ├── scanner/                     # Nhận diện món ăn qua Gemini 2.0 Flash AI
│       │   ├── domain/                  # FoodItemEntity, GeminiScanResultEntity
│       │   ├── data/                    # Camera/Gallery Picker, Gemini Vision Client, Cache
│       │   └── presentation/            # ScannerScreen, BoundingBoxOverlay, PortionAdjustmentSheet
│       ├── tracker/                     # Nhật ký calo và quản lý bữa ăn
│       │   ├── domain/                  # MealLogEntity, DailyNutritionEntity
│       │   ├── data/                    # Firestore MealLog DataSource, DTOs, Repositories
│       │   └── presentation/            # DashboardScreen, MealDetailSheet, AddFoodManualDialog
│       ├── analytics/                   # Báo cáo thống kê dinh dưỡng & xu hướng
│       │   ├── domain/                  # AnalyticsSummaryEntity, WeeklyTrendEntity
│       │   ├── data/                    # Firestore aggregation queries, Cache
│       │   └── presentation/            # AnalyticsScreen, FlChartCustomTrends, MacroBreakdownChart
│       └── profile/                     # Thông tin cá nhân & mục tiêu calo
│           ├── domain/                  # UserProfileEntity, CalorieGoalEntity
│           ├── data/                    # User Profile Firestore DataSource
│           └── presentation/            # ProfileScreen, GoalSettingScreen, DietaryPreferencesForm
│
├── test/                                # Unit Test & Widget Test (Ánh xạ từ QA Testcase)
│   ├── core/                            # Test tiện ích tính toán dinh dưỡng, router, theme
│   ├── features/                        # Test logic domain, mock repository, Riverpod notifier
│   └── shared/                          # Test giao diện các custom widget
│
└── integration_test/                    # Automated E2E Test (Thực thi kịch bản BDD từ QA)
    ├── auth_flow_test.dart
    ├── scanner_flow_test.dart
    └── diary_logging_test.dart
```

---

## 6. Ma Trận Truy Vết Toàn Diện (Traceability Matrix)

Hệ thống thư mục được thiết kế tương thích 1:1 giữa các bộ phận:

| Feature / Nghiệp Vụ | Đặc tả BA (`docs/`) | Kịch bản QA (`tests/`) | Triển khai Mã nguồn FE (`frontend/`) |
| :--- | :--- | :--- | :--- |
| **Xác thực & Khảo sát** | `03-prd-features/01-auth-onboarding/` | `02-manual-testcases/01-auth-onboarding/` & `auth_onboarding.feature` | `lib/features/auth/` & `integration_test/auth_flow_test.dart` |
| **Quét Thức Ăn AI** | `03-prd-features/02-food-scanner-ai/` | `02-manual-testcases/02-food-scanner-ai/` & `food_scanner_gemini.feature` | `lib/features/scanner/` & `integration_test/scanner_flow_test.dart` |
| **Nhật Ký Dinh Dưỡng** | `03-prd-features/03-diary-calorie-tracker/` | `02-manual-testcases/03-diary-calorie-tracker/` & `calorie_diary.feature` | `lib/features/tracker/` & `integration_test/diary_logging_test.dart` |
| **Báo Cáo Thống Kê** | `03-prd-features/04-analytics-insights/` | `02-manual-testcases/04-analytics-insights/` | `lib/features/analytics/` |
| **Hồ Sơ & Mục Tiêu** | `03-prd-features/05-user-profile-goals/` | `02-manual-testcases/05-user-profile-goals/` & `profile_management.feature` | `lib/features/profile/` |

---

## 7. Kịch Bản Chuyển Đổi & Hướng Dẫn Vận Hành Git Submodule

### 7.1. Quy trình Chuyển đổi từ Monolithic sang Submodules (Migration Steps)

1. **Bước 1: Khởi tạo 3 Remote Repositories mới trên GitHub/GitLab**:
   - `https://github.com/TrangDuyNguyen/astrobite-ba-docs.git`
   - `https://github.com/TrangDuyNguyen/astrobite-testcases.git`
   - `https://github.com/TrangDuyNguyen/astrobite-frontend.git`

2. **Bước 2: Chuyển mã nguồn Flutter sang repository `astrobite-frontend`**:
   - Push toàn bộ mã nguồn Flutter hiện có vào nhánh `main` của repo `astrobite-frontend`.

3. **Bước 3: Khởi tạo nội dung mẫu cho BA Docs và Testcases**:
   - Tạo cấu trúc thư mục và các file template chuẩn hóa như đặc tả ở Mục 3 và Mục 4 vào lần lượt `astrobite-ba-docs` và `astrobite-testcases`.

4. **Bước 4: Cấu hình Submodule vào Super-Repo `AstroBite`**:
   ```bash
   # Tại thư mục gốc AstroBite:
   git submodule add -b main https://github.com/TrangDuyNguyen/astrobite-ba-docs.git docs
   git submodule add -b main https://github.com/TrangDuyNguyen/astrobite-testcases.git tests
   git submodule add -b main https://github.com/TrangDuyNguyen/astrobite-frontend.git frontend
   
   git add .gitmodules docs tests frontend
   git commit -m "chore(root): initialize git submodules for BA docs, testcases, and frontend"
   git push origin main
   ```

### 7.2. Quy trình Làm Việc Hàng Ngày (Daily Workflow)

#### A. Clone dự án cho thành viên mới
```bash
# Clone cả Super-repo và tự động kéo toàn bộ submodules
git clone --recurse-submodules https://github.com/TrangDuyNguyen/AstroBite.git
```
*(Nếu đã clone thông thường không có cờ `--recurse-submodules`, chạy lệnh: `git submodule update --init --recursive`)*.

#### B. Đồng bộ cập nhật mới nhất từ tất cả Submodules
```bash
git submodule update --remote --merge
```

#### C. Quy tắc Commit an toàn (Chống Detached HEAD)
1. **Bước 1 (Trong Submodule)**: Luôn kiểm tra nhánh trước khi commit:
   ```bash
   cd frontend
   git checkout main
   # Thực hiện thay đổi mã nguồn...
   git add .
   git commit -m "feat(scanner): update portion adjustment sheet"
   git push origin main
   ```
2. **Bước 2 (Ngoài Super-Repo)**: Cập nhật con trỏ commit của submodule tại Root:
   ```bash
   cd ..
   git add frontend
   git commit -m "chore(root): bump frontend submodule commit"
   git push origin main
   ```

### 7.3. Tự động hóa với `Makefile`
Tại thư mục gốc Super-Repo, cung cấp file `Makefile`:
```makefile
.PHONY: setup update status pull test-fe

setup:
	git submodule update --init --recursive

update:
	git submodule update --remote --merge

status:
	git submodule status
	git status

pull:
	git pull --recurse-submodules

test-fe:
	cd frontend && flutter test
```
Lập trình viên chỉ cần chạy `make setup` hoặc `make update` mà không cần ghi nhớ các lệnh git phức tạp.

---

## 8. Kế Hoạch Triển Khai (Next Steps)

Sau khi tài liệu đặc tả thiết kế này được duyệt, bước tiếp theo sẽ chuyển sang kỹ năng **writing-plans** để lập kế hoạch thực thi chi tiết theo từng nhiệm vụ cụ thể.
