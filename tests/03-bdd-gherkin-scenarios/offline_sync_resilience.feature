# language: en
@feature @offline_sync @FEAT-07
Feature: Offline-First Local Cache & Automatic Background Sync
  As an AstroBite user with intermittent or no network connection
  I want to view my diary history and log meals offline seamlessly
  So that my calorie tracking habit is never interrupted and my data automatically syncs when online

  Background:
    Given I am logged in to AstroBite
    And the local storage cache is initialized with my last 30 days of data

  @smoke @critical @offline
  Scenario: Launch app and load dashboard completely offline in under 150ms
    Given the device is in Airplane Mode with Wi-Fi and Cellular disabled
    When I launch the AstroBite app
    Then the Dashboard should render data from local cache in less than 150 milliseconds
    And the CalorieProgressArc should display my daily calories correctly
    And a Celestial Offline Banner should appear at the top: "Chế độ ngoại tuyến — Dữ liệu đang được lưu an toàn trên máy"
    And no blocking error dialogs should be displayed

  @critical @offline_crud
  Scenario: Log a manual meal while offline
    Given the device has no internet connection
    When I navigate to the "Manual Food Entry" screen
    And I enter "Bún chả" with weight "250" and calories "550"
    And I tap "Lưu Bữa Ăn"
    Then the record should be saved locally in under 50 milliseconds
    And the daily calorie total on Dashboard should immediately increase by 550 kcal
    And the meal card should display an amber pulsing cloud badge indicating pending sync

  @critical @auto_sync
  Scenario: Automatically sync pending offline records upon network restoration
    Given there are 2 meal records with "pending_sync" status in local cache
    When internet connection is restored via Wi-Fi or 4G
    Then after 2 seconds the background SyncEngine should push the records to Cloud Firestore
    And the cloud badge on the meal cards should turn green and disappear after 2 seconds
    And the Celestial Offline Banner should slide up and disappear
    And a SnackBar should notify "Đã đồng bộ thành công 2 bữa ăn lên đám mây."

  @edge_case @idempotent
  Scenario: Retry syncing the same record does not create duplicate entries
    Given a meal record with UUID "meal-uuid-1234" was synced to Firestore
    When the sync engine retries sending "meal-uuid-1234" due to an ACK drop
    Then Firestore should perform an idempotent upsert merge on "meal-uuid-1234"
    And no duplicate document should be created in the meal_logs collection
    And the total daily calories should remain unchanged

  @edge_case @ai_fallback
  Scenario: Attempting to use AI Scanner while offline redirects to manual entry
    Given the device is offline
    When I tap the central Camera Scanner FAB
    Then a Celestial Alert dialog should state "Tính Năng Quét AI Cần Kết Nối Mạng"
    When I tap "Nhập Thủ Công Ngay"
    Then I should be navigated to the Manual Food Entry screen
