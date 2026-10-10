import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'AstroBite'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get resetPassword;

  /// No description provided for @googleSignIn.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get googleSignIn;

  /// No description provided for @sendResetLink.
  ///
  /// In vi, this message translates to:
  /// **'Gửi liên kết'**
  String get sendResetLink;

  /// No description provided for @resetPasswordSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi liên kết đặt lại mật khẩu về email của bạn. Vui lòng kiểm tra hộp thư.'**
  String get resetPasswordSent;

  /// No description provided for @orDivider.
  ///
  /// In vi, this message translates to:
  /// **'HOẶC'**
  String get orDivider;

  /// No description provided for @breakfast.
  ///
  /// In vi, this message translates to:
  /// **'Bữa sáng'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In vi, this message translates to:
  /// **'Bữa trưa'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In vi, this message translates to:
  /// **'Bữa tối'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In vi, this message translates to:
  /// **'Bữa phụ'**
  String get snack;

  /// No description provided for @todayOverview.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get todayOverview;

  /// No description provided for @nutritionLog.
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký dinh dưỡng'**
  String get nutritionLog;

  /// No description provided for @remaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại'**
  String get remaining;

  /// No description provided for @consumed.
  ///
  /// In vi, this message translates to:
  /// **'Đã nạp'**
  String get consumed;

  /// No description provided for @calories.
  ///
  /// In vi, this message translates to:
  /// **'Calo'**
  String get calories;

  /// No description provided for @protein.
  ///
  /// In vi, this message translates to:
  /// **'Đạm'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In vi, this message translates to:
  /// **'Tinh bột'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In vi, this message translates to:
  /// **'Chất béo'**
  String get fat;

  /// No description provided for @scanFood.
  ///
  /// In vi, this message translates to:
  /// **'Quét món ăn'**
  String get scanFood;

  /// No description provided for @analyzing.
  ///
  /// In vi, this message translates to:
  /// **'Đang phân tích...'**
  String get analyzing;

  /// No description provided for @saveLog.
  ///
  /// In vi, this message translates to:
  /// **'Lưu nhật ký'**
  String get saveLog;

  /// No description provided for @notFood.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận diện được món ăn. Vui lòng chụp lại rõ nét hơn hoặc nhập tay.'**
  String get notFood;

  /// No description provided for @quotaExceeded.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã đạt giới hạn 10 lượt quét AI hôm nay. Vui lòng sử dụng tính năng Nhập tay.'**
  String get quotaExceeded;

  /// No description provided for @networkError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối mạng. Vui lòng thử lại.'**
  String get networkError;

  /// No description provided for @manualEntry.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tay'**
  String get manualEntry;

  /// No description provided for @searchFood.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm món ăn...'**
  String get searchFood;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @analytics.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích'**
  String get analytics;

  /// No description provided for @today.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today;

  /// No description provided for @confirmDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa'**
  String get confirmDelete;

  /// No description provided for @deleteFoodConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa món này khỏi bữa ăn?'**
  String get deleteFoodConfirmMessage;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @overBudget.
  ///
  /// In vi, this message translates to:
  /// **'vượt mục tiêu'**
  String get overBudget;

  /// No description provided for @kcalRemaining.
  ///
  /// In vi, this message translates to:
  /// **'còn lại'**
  String get kcalRemaining;

  /// No description provided for @noMealLogs.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có món ăn nào'**
  String get noMealLogs;

  /// No description provided for @navToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get navToday;

  /// No description provided for @navCoach.
  ///
  /// In vi, this message translates to:
  /// **'AstroCoach'**
  String get navCoach;

  /// No description provided for @navInsights.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get navInsights;

  /// No description provided for @navProfile.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get navProfile;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @languageSelect.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get languageSelect;

  /// No description provided for @systemLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get systemLanguage;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @signOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get signOut;

  /// No description provided for @editProfile.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get editProfile;

  /// No description provided for @viewingOfflineData.
  ///
  /// In vi, this message translates to:
  /// **'Đang xem dữ liệu ngoại tuyến'**
  String get viewingOfflineData;

  /// No description provided for @geminiAiConfig.
  ///
  /// In vi, this message translates to:
  /// **'Cấu hình Gemini AI'**
  String get geminiAiConfig;

  /// No description provided for @apiKeySettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt API Key'**
  String get apiKeySettings;

  /// No description provided for @customKeyPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Key cá nhân: '**
  String get customKeyPrefix;

  /// No description provided for @aiActive.
  ///
  /// In vi, this message translates to:
  /// **'AstroBite AI: Đã kích hoạt'**
  String get aiActive;

  /// No description provided for @aiNotConfigured.
  ///
  /// In vi, this message translates to:
  /// **'Chưa cấu hình API Key'**
  String get aiNotConfigured;

  /// No description provided for @usingCustomKeyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đang dùng key tùy chỉnh • Nhấn để thay đổi'**
  String get usingCustomKeyDesc;

  /// No description provided for @aiReadyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống AI tích hợp sẵn sàng • Tùy chọn nâng cao'**
  String get aiReadyDesc;

  /// No description provided for @addKeyFreeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn để thêm key miễn phí từ AI Studio'**
  String get addKeyFreeDesc;

  /// No description provided for @aiCoach.
  ///
  /// In vi, this message translates to:
  /// **'AI Coach'**
  String get aiCoach;

  /// No description provided for @aiCoachDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tư vấn chế độ ăn uống thông minh'**
  String get aiCoachDesc;

  /// No description provided for @healthConnection.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối Sức khỏe'**
  String get healthConnection;

  /// No description provided for @healthConnectionDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ Apple Health / Health Connect'**
  String get healthConnectionDesc;

  /// No description provided for @homeWidget.
  ///
  /// In vi, this message translates to:
  /// **'Tiện ích Màn hình chính (Widget)'**
  String get homeWidget;

  /// No description provided for @homeWidgetDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xem nhanh Calo/Macro & Quét AI 1-chạm'**
  String get homeWidgetDesc;

  /// No description provided for @recipeCatalog.
  ///
  /// In vi, this message translates to:
  /// **'Công thức món ăn'**
  String get recipeCatalog;

  /// No description provided for @recipeCatalogDesc.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý công thức cá nhân & co giãn khẩu phần'**
  String get recipeCatalogDesc;

  /// No description provided for @mealPlanner.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch thực đơn 7 ngày'**
  String get mealPlanner;

  /// No description provided for @mealPlannerDesc.
  ///
  /// In vi, this message translates to:
  /// **'Lên lịch bữa ăn & 1-chạm nạp nhật ký'**
  String get mealPlannerDesc;

  /// No description provided for @guilds.
  ///
  /// In vi, this message translates to:
  /// **'Bang Hội Vũ Trụ'**
  String get guilds;

  /// No description provided for @guildsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Lập đội thi đua & Thử thách hành tinh tuần'**
  String get guildsDesc;

  /// No description provided for @energyMetricsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số năng lượng (BMR & TDEE)'**
  String get energyMetricsTitle;

  /// No description provided for @standardized.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn hóa'**
  String get standardized;

  /// No description provided for @bmrSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Năng lượng nghỉ ngơi'**
  String get bmrSubtitle;

  /// No description provided for @tdeeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Năng lượng tiêu thụ/ngày'**
  String get tdeeSubtitle;

  /// No description provided for @personalMetricsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông số cá nhân'**
  String get personalMetricsTitle;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get edit;

  /// No description provided for @gender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In vi, this message translates to:
  /// **'Nam'**
  String get male;

  /// No description provided for @female.
  ///
  /// In vi, this message translates to:
  /// **'Nữ'**
  String get female;

  /// No description provided for @height.
  ///
  /// In vi, this message translates to:
  /// **'Chiều cao'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng'**
  String get weight;

  /// No description provided for @birthYear.
  ///
  /// In vi, this message translates to:
  /// **'Năm sinh'**
  String get birthYear;

  /// No description provided for @activityLevel.
  ///
  /// In vi, this message translates to:
  /// **'Mức độ vận động'**
  String get activityLevel;

  /// No description provided for @sedentary.
  ///
  /// In vi, this message translates to:
  /// **'Ít vận động'**
  String get sedentary;

  /// No description provided for @lightActivity.
  ///
  /// In vi, this message translates to:
  /// **'Nhẹ (1-3 ngày)'**
  String get lightActivity;

  /// No description provided for @moderateActivity.
  ///
  /// In vi, this message translates to:
  /// **'Vừa phải (3-5 ngày)'**
  String get moderateActivity;

  /// No description provided for @activeActivity.
  ///
  /// In vi, this message translates to:
  /// **'Năng động (6-7 ngày)'**
  String get activeActivity;

  /// No description provided for @veryActiveActivity.
  ///
  /// In vi, this message translates to:
  /// **'Rất năng động'**
  String get veryActiveActivity;

  /// No description provided for @goalLoseWeight.
  ///
  /// In vi, this message translates to:
  /// **'Giảm mỡ'**
  String get goalLoseWeight;

  /// No description provided for @goalMaintain.
  ///
  /// In vi, this message translates to:
  /// **'Duy trì cân nặng'**
  String get goalMaintain;

  /// No description provided for @goalGainMuscle.
  ///
  /// In vi, this message translates to:
  /// **'Tăng cơ'**
  String get goalGainMuscle;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get saving;

  /// No description provided for @saveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get saveChanges;

  /// No description provided for @errorWithDetails.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: {error}'**
  String errorWithDetails(String error);

  /// No description provided for @loginToSaveLog.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đăng nhập để lưu nhật ký'**
  String get loginToSaveLog;

  /// No description provided for @cameraFlash.
  ///
  /// In vi, this message translates to:
  /// **'Đèn Flash'**
  String get cameraFlash;

  /// No description provided for @scanTips.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo quét'**
  String get scanTips;

  /// No description provided for @scanTipsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo chụp ảnh món ăn chuẩn AI'**
  String get scanTipsTitle;

  /// No description provided for @scanTipLighting.
  ///
  /// In vi, this message translates to:
  /// **'Đảm bảo đủ ánh sáng, tránh bóng đổ tối che khuất thức ăn.'**
  String get scanTipLighting;

  /// No description provided for @scanTipFraming.
  ///
  /// In vi, this message translates to:
  /// **'Đặt trọn vẹn đĩa ăn vào trong khung ngắm trung tâm.'**
  String get scanTipFraming;

  /// No description provided for @scanTipAngle.
  ///
  /// In vi, this message translates to:
  /// **'Nếu đĩa có nhiều món, chụp góc từ trên xuống (top-down view).'**
  String get scanTipAngle;

  /// No description provided for @gotIt.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiểu'**
  String get gotIt;

  /// No description provided for @retakePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chụp lại'**
  String get retakePhoto;

  /// No description provided for @rescan.
  ///
  /// In vi, this message translates to:
  /// **'Quét lại'**
  String get rescan;

  /// No description provided for @aiScanResult.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả phân tích AI'**
  String get aiScanResult;

  /// No description provided for @noScanData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu phân tích món ăn.'**
  String get noScanData;

  /// No description provided for @backToCamera.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại Camera'**
  String get backToCamera;

  /// No description provided for @portionEstimated.
  ///
  /// In vi, this message translates to:
  /// **'Khẩu phần ước lượng'**
  String get portionEstimated;

  /// No description provided for @portionBowl.
  ///
  /// In vi, this message translates to:
  /// **'1 Bát (~150g)'**
  String get portionBowl;

  /// No description provided for @portionPlate.
  ///
  /// In vi, this message translates to:
  /// **'1 Đĩa (~300g)'**
  String get portionPlate;

  /// No description provided for @portionStandard.
  ///
  /// In vi, this message translates to:
  /// **'Phần Chuẩn (~350g)'**
  String get portionStandard;

  /// No description provided for @saveToMeal.
  ///
  /// In vi, this message translates to:
  /// **'Lưu vào {meal} ({calories} kcal)'**
  String saveToMeal(String meal, int calories);

  /// No description provided for @foodSavedToMeal.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu {dishName} vào {meal}!'**
  String foodSavedToMeal(String dishName, String meal);

  /// No description provided for @errorSavingLog.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi lưu nhật ký: {error}'**
  String errorSavingLog(String error);

  /// No description provided for @detectedDishesCount.
  ///
  /// In vi, this message translates to:
  /// **'Thành phần nhận diện ({count} món)'**
  String detectedDishesCount(int count);

  /// No description provided for @addDish.
  ///
  /// In vi, this message translates to:
  /// **'Thêm món'**
  String get addDish;

  /// No description provided for @removeDish.
  ///
  /// In vi, this message translates to:
  /// **'Xóa món'**
  String get removeDish;

  /// No description provided for @confidencePercent.
  ///
  /// In vi, this message translates to:
  /// **'{percent}% tin cậy'**
  String confidencePercent(int percent);

  /// No description provided for @multiDishPlatter.
  ///
  /// In vi, this message translates to:
  /// **'🍱 Mâm cơm ({count} món)'**
  String multiDishPlatter(int count);

  /// No description provided for @andOtherDishes.
  ///
  /// In vi, this message translates to:
  /// **'{firstDish} & {count} món khác'**
  String andOtherDishes(String firstDish, int count);

  /// No description provided for @eatWithBroth.
  ///
  /// In vi, this message translates to:
  /// **'Ăn cả nước (+{calories} kcal)'**
  String eatWithBroth(int calories);

  /// No description provided for @eatWithoutBroth.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ ăn cái (-{calories} kcal)'**
  String eatWithoutBroth(int calories);

  /// No description provided for @brothSodiumSub.
  ///
  /// In vi, this message translates to:
  /// **'Bao gồm ~{sodium}mg Muối nước lèo'**
  String brothSodiumSub(int sodium);

  /// No description provided for @brothFullFlavorSub.
  ///
  /// In vi, this message translates to:
  /// **'Tính trọn vẹn nước dùng & gia vị ninh'**
  String get brothFullFlavorSub;

  /// No description provided for @brothSavedSub.
  ///
  /// In vi, this message translates to:
  /// **'Tiết kiệm {calories} kcal & giảm mỡ béo ✨'**
  String brothSavedSub(int calories);

  /// No description provided for @manualAddDishTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm món ăn thủ công'**
  String get manualAddDishTitle;

  /// No description provided for @dishNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên món ăn'**
  String get dishNameLabel;

  /// No description provided for @dishNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Canh khổ qua, Trứng ốp la...'**
  String get dishNameHint;

  /// No description provided for @caloriesKcalLabel.
  ///
  /// In vi, this message translates to:
  /// **'Calo (kcal)'**
  String get caloriesKcalLabel;

  /// No description provided for @caloriesHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: 120'**
  String get caloriesHint;

  /// No description provided for @portionGramsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khẩu phần (g)'**
  String get portionGramsLabel;

  /// No description provided for @portionHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: 150'**
  String get portionHint;

  /// No description provided for @addToMealPlatter.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào mâm cơm'**
  String get addToMealPlatter;

  /// No description provided for @sodiumChip.
  ///
  /// In vi, this message translates to:
  /// **'Muối: {amount} mg'**
  String sodiumChip(String amount);

  /// No description provided for @fiberChip.
  ///
  /// In vi, this message translates to:
  /// **'Xơ: {amount} g'**
  String fiberChip(String amount);

  /// No description provided for @sugarChip.
  ///
  /// In vi, this message translates to:
  /// **'Đường: {amount} g'**
  String sugarChip(String amount);

  /// No description provided for @highSodiumBadge.
  ///
  /// In vi, this message translates to:
  /// **'Muối cao (>800mg)'**
  String get highSodiumBadge;

  /// No description provided for @highSodiumAlertTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Món ăn chứa hơn 800mg Natri (>1/3 hạn mức khuyến nghị cả ngày). Hãy chú ý uống đủ nước nhé!'**
  String get highSodiumAlertTooltip;

  /// No description provided for @dishNotRecognized.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận diện được món ăn'**
  String get dishNotRecognized;

  /// No description provided for @aiServerBusy.
  ///
  /// In vi, this message translates to:
  /// **'Máy chủ AI hiện đang quá tải (503). Vui lòng bấm \"Thử lại\" sau giây lát.'**
  String get aiServerBusy;

  /// No description provided for @aiOverloaded.
  ///
  /// In vi, this message translates to:
  /// **'Máy chủ AI tạm thời quá tải. Vui lòng thử lại sau giây lát.'**
  String get aiOverloaded;

  /// No description provided for @aiRateLimited.
  ///
  /// In vi, this message translates to:
  /// **'Đã vượt giới hạn gọi AI tạm thời. Vui lòng thử lại sau ít phút.'**
  String get aiRateLimited;

  /// No description provided for @aiConnectionError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể kết nối đến máy chủ AI. Vui lòng thử lại.'**
  String get aiConnectionError;

  /// No description provided for @apiKeyInvalidTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gemini API Key Không Hợp Lệ'**
  String get apiKeyInvalidTitle;

  /// No description provided for @apiKeyRequiredTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cần Gemini API Key'**
  String get apiKeyRequiredTitle;

  /// No description provided for @apiKeyInvalidDesc.
  ///
  /// In vi, this message translates to:
  /// **'Key API bạn đang sử dụng không hợp lệ hoặc đã hết hạn.\n\nVui lòng kiểm tra lại Key trong file .env hoặc tạo Key mới (phải bắt đầu bằng AIzaSy...) từ Google AI Studio.'**
  String get apiKeyInvalidDesc;

  /// No description provided for @apiKeyRequiredDesc.
  ///
  /// In vi, this message translates to:
  /// **'Để quét món ăn bằng AI miễn phí (không cần thẻ tín dụng), bạn cần cài đặt Gemini API Key từ Google AI Studio (aistudio.google.com).\n\nBạn có thể dán Key ngay bây giờ hoặc sử dụng tính năng Nhập tay.'**
  String get apiKeyRequiredDesc;

  /// No description provided for @setupApiKey.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt Key'**
  String get setupApiKey;

  /// No description provided for @apiKeySavedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu Gemini API Key thành công!'**
  String get apiKeySavedSuccess;

  /// No description provided for @apiKeyRemovedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa Gemini API Key cá nhân.'**
  String get apiKeyRemovedSuccess;

  /// No description provided for @apiKeyDialogDescription.
  ///
  /// In vi, this message translates to:
  /// **'AstroBite sử dụng Google Gemini AI để nhận diện món ăn. Bạn có thể dùng API Key miễn phí 100% (không cần thẻ tín dụng).'**
  String get apiKeyDialogDescription;

  /// No description provided for @apiKeyCopiedLink.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép link Google AI Studio vào bộ nhớ tạm!'**
  String get apiKeyCopiedLink;

  /// No description provided for @apiKeyGetFree.
  ///
  /// In vi, this message translates to:
  /// **'Lấy Key miễn phí: aistudio.google.com\n(Bấm để copy đường link)'**
  String get apiKeyGetFree;

  /// No description provided for @pasteFromClipboard.
  ///
  /// In vi, this message translates to:
  /// **'Dán từ bộ nhớ tạm'**
  String get pasteFromClipboard;

  /// No description provided for @apiKeyStatusDefault.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái: Đang dùng Key mặc định của ứng dụng (Sẵn sàng sử dụng)'**
  String get apiKeyStatusDefault;

  /// No description provided for @apiKeyStatusCustom.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái: Đang dùng Key cá nhân ({maskedKey})'**
  String apiKeyStatusCustom(String maskedKey);

  /// No description provided for @apiKeyStatusNone.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái: Chưa có API Key nào được cài đặt'**
  String get apiKeyStatusNone;

  /// No description provided for @deleteKey.
  ///
  /// In vi, this message translates to:
  /// **'Xóa Key'**
  String get deleteKey;

  /// No description provided for @saveKey.
  ///
  /// In vi, this message translates to:
  /// **'Lưu Key'**
  String get saveKey;

  /// No description provided for @calorieTrendDays.
  ///
  /// In vi, this message translates to:
  /// **'Xu hướng Calo nạp vào ({days} ngày)'**
  String calorieTrendDays(int days);

  /// No description provided for @dailyTargetKcal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu hằng ngày: {target} kcal'**
  String dailyTargetKcal(int target);

  /// No description provided for @weightTrendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xu hướng Cân nặng (kg)'**
  String get weightTrendTitle;

  /// No description provided for @weightGoalSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu: {target} kg • Giảm đều đặn'**
  String weightGoalSubtitle(String target);

  /// No description provided for @chartTarget.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu: {target}'**
  String chartTarget(int target);

  /// No description provided for @chartTargetWeight.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu: {target} kg'**
  String chartTargetWeight(String target);

  /// No description provided for @noTrackingData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu theo dõi'**
  String get noTrackingData;

  /// No description provided for @week1.
  ///
  /// In vi, this message translates to:
  /// **'Tuần 1'**
  String get week1;

  /// No description provided for @week2.
  ///
  /// In vi, this message translates to:
  /// **'Tuần 2'**
  String get week2;

  /// No description provided for @week3.
  ///
  /// In vi, this message translates to:
  /// **'Tuần 3'**
  String get week3;

  /// No description provided for @week4.
  ///
  /// In vi, this message translates to:
  /// **'Tuần 4'**
  String get week4;

  /// No description provided for @dayNumber.
  ///
  /// In vi, this message translates to:
  /// **' (Ngày {day})'**
  String dayNumber(int day);

  /// No description provided for @macroBreakdownTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phân bổ Dinh dưỡng Trung bình'**
  String get macroBreakdownTitle;

  /// No description provided for @macroBreakdownSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ năng lượng hấp thu từ các nhóm chất'**
  String get macroBreakdownSubtitle;

  /// No description provided for @balanced.
  ///
  /// In vi, this message translates to:
  /// **'Cân đối'**
  String get balanced;

  /// No description provided for @kpiOnTrack.
  ///
  /// In vi, this message translates to:
  /// **'Đạt chuẩn'**
  String get kpiOnTrack;

  /// No description provided for @kpiSlightlyOver.
  ///
  /// In vi, this message translates to:
  /// **'Vượt nhẹ'**
  String get kpiSlightlyOver;

  /// No description provided for @discipline.
  ///
  /// In vi, this message translates to:
  /// **'Kỷ luật'**
  String get discipline;

  /// No description provided for @daysUnit.
  ///
  /// In vi, this message translates to:
  /// **'ngày'**
  String get daysUnit;

  /// No description provided for @sevenDays.
  ///
  /// In vi, this message translates to:
  /// **'7 ngày'**
  String get sevenDays;

  /// No description provided for @thirtyDays.
  ///
  /// In vi, this message translates to:
  /// **'30 ngày'**
  String get thirtyDays;

  /// No description provided for @energyBalanceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cân bằng Năng lượng'**
  String get energyBalanceTitle;

  /// No description provided for @connectHealthPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối {service} để xem calo đốt cháy'**
  String connectHealthPrompt(String service);

  /// No description provided for @connect.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối'**
  String get connect;

  /// No description provided for @healthErrorMsg.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đọc dữ liệu Health — kiểm tra quyền truy cập'**
  String get healthErrorMsg;

  /// No description provided for @caloriesBurned.
  ///
  /// In vi, this message translates to:
  /// **'Calo đốt'**
  String get caloriesBurned;

  /// No description provided for @caloriesIntake.
  ///
  /// In vi, this message translates to:
  /// **'Calo nạp'**
  String get caloriesIntake;

  /// No description provided for @budgetRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách còn lại: {calories} kcal'**
  String budgetRemaining(int calories);

  /// No description provided for @targetWeight.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng mục tiêu'**
  String get targetWeight;

  /// No description provided for @fitnessGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu thể hình'**
  String get fitnessGoal;

  /// No description provided for @biologicalInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin sinh học'**
  String get biologicalInfo;

  /// No description provided for @biologicalGender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính sinh học'**
  String get biologicalGender;

  /// No description provided for @enterBirthYear.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập năm sinh'**
  String get enterBirthYear;

  /// No description provided for @enterHeight.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập chiều cao'**
  String get enterHeight;

  /// No description provided for @currentWeight.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng hiện tại (kg)'**
  String get currentWeight;

  /// No description provided for @enterCurrentWeight.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập cân nặng hiện tại'**
  String get enterCurrentWeight;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'✨ Đã cập nhật hồ sơ & mục tiêu dinh dưỡng thành công!'**
  String get profileUpdateSuccess;

  /// No description provided for @goalAndActivity.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu & Chế độ vận động'**
  String get goalAndActivity;

  /// No description provided for @weeklyActivityLevel.
  ///
  /// In vi, this message translates to:
  /// **'Mức độ vận động hàng tuần'**
  String get weeklyActivityLevel;

  /// No description provided for @goalLoseWeightTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giảm mỡ & Cải thiện vóc dáng'**
  String get goalLoseWeightTitle;

  /// No description provided for @goalLoseWeightSub.
  ///
  /// In vi, this message translates to:
  /// **'Thâm hụt calo an toàn (-500 kcal/ngày)'**
  String get goalLoseWeightSub;

  /// No description provided for @goalMaintainTitle.
  ///
  /// In vi, this message translates to:
  /// **'Duy trì cân nặng'**
  String get goalMaintainTitle;

  /// No description provided for @goalMaintainSub.
  ///
  /// In vi, this message translates to:
  /// **'Cân bằng calo nạp vào bằng chỉ số TDEE'**
  String get goalMaintainSub;

  /// No description provided for @goalGainMuscleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tăng cơ & Khối lượng nạc'**
  String get goalGainMuscleTitle;

  /// No description provided for @goalGainMuscleSub.
  ///
  /// In vi, this message translates to:
  /// **'Thặng dư nhẹ (+300 kcal/ngày) kết hợp tập luyện'**
  String get goalGainMuscleSub;

  /// No description provided for @syncPendingTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Bữa ăn này đang lưu trên thiết bị. Sẽ tự tải lên khi có mạng.'**
  String get syncPendingTooltip;

  /// No description provided for @syncFailedTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thể tải lên máy chủ. Chạm vào đây để thử lại.'**
  String get syncFailedTooltip;

  /// No description provided for @syncSuccessTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Đã đồng bộ lên đám mây'**
  String get syncSuccessTooltip;

  /// No description provided for @foodDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa món {dishName}'**
  String foodDeleted(String dishName);

  /// No description provided for @recentFoods.
  ///
  /// In vi, this message translates to:
  /// **'Món gần đây:'**
  String get recentFoods;

  /// No description provided for @myRecipes.
  ///
  /// In vi, this message translates to:
  /// **'Công thức của tôi'**
  String get myRecipes;

  /// No description provided for @addCustomDish.
  ///
  /// In vi, this message translates to:
  /// **'Thêm món tùy chỉnh'**
  String get addCustomDish;

  /// No description provided for @popularFoods.
  ///
  /// In vi, this message translates to:
  /// **'Món ăn phổ biến ({count})'**
  String popularFoods(int count);

  /// No description provided for @customFoodEntry.
  ///
  /// In vi, this message translates to:
  /// **'Tự nhập món'**
  String get customFoodEntry;

  /// No description provided for @noFoodFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy món \"{query}\"'**
  String noFoodFound(String query);

  /// No description provided for @enterThisFoodManually.
  ///
  /// In vi, this message translates to:
  /// **'Nhập món này thủ công'**
  String get enterThisFoodManually;

  /// No description provided for @analyzingFood.
  ///
  /// In vi, this message translates to:
  /// **'Đang phân tích món ăn...'**
  String get analyzingFood;

  /// No description provided for @tipWater.
  ///
  /// In vi, this message translates to:
  /// **'💡 Uống đủ 2 lít nước mỗi ngày giúp trao đổi chất tốt hơn.'**
  String get tipWater;

  /// No description provided for @tipVeggies.
  ///
  /// In vi, this message translates to:
  /// **'🥗 Rau xanh chứa ít calo nhưng giàu chất xơ và vitamin.'**
  String get tipVeggies;

  /// No description provided for @tipProtein.
  ///
  /// In vi, this message translates to:
  /// **'🍳 Protein giúp no lâu và duy trì cơ bắp.'**
  String get tipProtein;

  /// No description provided for @tipMealTiming.
  ///
  /// In vi, this message translates to:
  /// **'⏰ Ăn đúng giờ giúp cơ thể điều hòa năng lượng hiệu quả.'**
  String get tipMealTiming;

  /// No description provided for @tipExercise.
  ///
  /// In vi, this message translates to:
  /// **'🏃 Kết hợp vận động 30 phút mỗi ngày để duy trì sức khỏe.'**
  String get tipExercise;

  /// No description provided for @notSet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đặt'**
  String get notSet;

  /// No description provided for @bmiIndex.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số BMI'**
  String get bmiIndex;

  /// No description provided for @dailyCalorieTarget.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu Calo/ngày'**
  String get dailyCalorieTarget;

  /// No description provided for @targetWeightOptional.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng mục tiêu (kg, tùy chọn)'**
  String get targetWeightOptional;

  /// No description provided for @astroBiteRecommendation.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý chuẩn khoa học AstroBite'**
  String get astroBiteRecommendation;

  /// No description provided for @recommendationCalories.
  ///
  /// In vi, this message translates to:
  /// **'Khuyến nghị: {calories} kcal/ngày'**
  String recommendationCalories(int calories);

  /// No description provided for @apply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get apply;

  /// No description provided for @dailyCalorieTargetWithUnit.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu Calo/ngày (kcal)'**
  String get dailyCalorieTargetWithUnit;

  /// No description provided for @enterTargetCalories.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mục tiêu calo'**
  String get enterTargetCalories;

  /// No description provided for @savedFoodToMeal.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu {dishName} vào {meal}!'**
  String savedFoodToMeal(String dishName, String meal);

  /// No description provided for @cannotOpenSource.
  ///
  /// In vi, this message translates to:
  /// **'Không thể mở camera/thư viện: {error}'**
  String cannotOpenSource(String error);

  /// No description provided for @aiDecodingFood.
  ///
  /// In vi, this message translates to:
  /// **'✨ AI đang giải mã cấu trúc món ăn...'**
  String get aiDecodingFood;

  /// No description provided for @pointCameraAtFood.
  ///
  /// In vi, this message translates to:
  /// **'Hướng máy ảnh vào đĩa thức ăn và bấm nút chụp'**
  String get pointCameraAtFood;

  /// No description provided for @scanningLocatingFood.
  ///
  /// In vi, this message translates to:
  /// **'✨ ĐANG ĐỊNH VỊ MÓN ĂN'**
  String get scanningLocatingFood;

  /// No description provided for @selectFromGallery.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ thư viện'**
  String get selectFromGallery;

  /// No description provided for @manualEntryTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tay'**
  String get manualEntryTooltip;

  /// No description provided for @toppingsAndSidesHeader.
  ///
  /// In vi, this message translates to:
  /// **'TOPPING & MÓN PHỤ (CHẠM ĐỂ BỎ BỚT)'**
  String get toppingsAndSidesHeader;

  /// No description provided for @standardPortion.
  ///
  /// In vi, this message translates to:
  /// **'Khẩu phần tiêu chuẩn • {weight}g'**
  String standardPortion(int weight);

  /// No description provided for @scansExhaustedToday.
  ///
  /// In vi, this message translates to:
  /// **'Đã hết lượt quét hôm nay (10/10)'**
  String get scansExhaustedToday;

  /// No description provided for @scansRemainingToday.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại {remaining}/{total} lượt quét hôm nay'**
  String scansRemainingToday(int remaining, int total);

  /// No description provided for @target.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get target;

  /// No description provided for @portion100g.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn (~100g)'**
  String get portion100g;

  /// No description provided for @todayActivityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vận Động Hôm Nay'**
  String get todayActivityTitle;

  /// No description provided for @stepsCount.
  ///
  /// In vi, this message translates to:
  /// **'🚶 {count} bước'**
  String stepsCount(String count);

  /// No description provided for @startMovingPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Hãy bắt đầu di chuyển nào! 🚶'**
  String get startMovingPrompt;

  /// No description provided for @minutesUnit.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String minutesUnit(int minutes);

  /// No description provided for @offlineModeNotice.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ ngoại tuyến — Dữ liệu đang được lưu an toàn trên máy'**
  String get offlineModeNotice;

  /// No description provided for @syncedMealsCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã đồng bộ {count} bữa ăn lên đám mây'**
  String syncedMealsCount(int count);

  /// No description provided for @macroCarbs.
  ///
  /// In vi, this message translates to:
  /// **'Tinh bột'**
  String get macroCarbs;

  /// No description provided for @macroProtein.
  ///
  /// In vi, this message translates to:
  /// **'Chất đạm'**
  String get macroProtein;

  /// No description provided for @macroFat.
  ///
  /// In vi, this message translates to:
  /// **'Chất béo'**
  String get macroFat;

  /// No description provided for @coachHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get coachHistory;

  /// No description provided for @coachHistoryTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử hội thoại'**
  String get coachHistoryTooltip;

  /// No description provided for @onlineRealtimeNutritionist.
  ///
  /// In vi, this message translates to:
  /// **'Online • Real-time Nutritionist'**
  String get onlineRealtimeNutritionist;

  /// No description provided for @nutritionOverviewToday.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan dinh dưỡng hôm nay'**
  String get nutritionOverviewToday;

  /// No description provided for @budgetRemainingKcal.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại: {calories} kcal'**
  String budgetRemainingKcal(int calories);

  /// No description provided for @budgetOverKcal.
  ///
  /// In vi, this message translates to:
  /// **'Vượt: {calories} kcal'**
  String budgetOverKcal(int calories);

  /// No description provided for @sodiumWarning.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo Natri: {current}mg / {target}mg (sắp chạm ngưỡng khuyến nghị)'**
  String sodiumWarning(int current, int target);

  /// No description provided for @portionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khẩu phần:'**
  String get portionLabel;

  /// No description provided for @quickLogNow.
  ///
  /// In vi, this message translates to:
  /// **'⚡ Ghi vào nhật ký ngay'**
  String get quickLogNow;

  /// No description provided for @quickLogging.
  ///
  /// In vi, this message translates to:
  /// **'Đang ghi nhật ký...'**
  String get quickLogging;

  /// No description provided for @quickLogged.
  ///
  /// In vi, this message translates to:
  /// **'✓ Đã ghi vào nhật ký'**
  String get quickLogged;

  /// No description provided for @suggestedDish.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý món ăn'**
  String get suggestedDish;

  /// No description provided for @budgetImpactTitle.
  ///
  /// In vi, this message translates to:
  /// **'TÁC ĐỘNG NGÂN SÁCH NGÀY'**
  String get budgetImpactTitle;

  /// No description provided for @budgetOverTarget.
  ///
  /// In vi, this message translates to:
  /// **'⚠️ Vượt {calories} kcal mục tiêu'**
  String budgetOverTarget(int calories);

  /// No description provided for @budgetRemainingAfterMeal.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại sau bữa: {calories} kcal'**
  String budgetRemainingAfterMeal(int calories);

  /// No description provided for @targetKcal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu: {target} kcal'**
  String targetKcal(int target);

  /// No description provided for @ingredientsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thành phần: {ingredients}'**
  String ingredientsLabel(String ingredients);

  /// No description provided for @shuffleSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'🎲 Đổi gợi ý khác'**
  String get shuffleSuggestions;

  /// No description provided for @questionSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý câu hỏi ({count})'**
  String questionSuggestions(int count);

  /// No description provided for @medicalDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'⚕️ AI gợi ý tham khảo, không thay thế chuyên gia y tế'**
  String get medicalDisclaimer;

  /// No description provided for @collapseSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Thu gọn gợi ý'**
  String get collapseSuggestions;

  /// No description provided for @expandSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Mở gợi ý câu hỏi'**
  String get expandSuggestions;

  /// No description provided for @clearContent.
  ///
  /// In vi, this message translates to:
  /// **'Xóa nội dung'**
  String get clearContent;

  /// No description provided for @voiceListeningStop.
  ///
  /// In vi, this message translates to:
  /// **'Đang nghe... Bấm để dừng'**
  String get voiceListeningStop;

  /// No description provided for @voiceInputTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Nói tiếng Việt (Nhấn giữ để mở AstroVoice)'**
  String get voiceInputTooltip;

  /// No description provided for @askCoachHint.
  ///
  /// In vi, this message translates to:
  /// **'Hỏi AstroCoach về thực đơn, macros...'**
  String get askCoachHint;

  /// No description provided for @viewingSession.
  ///
  /// In vi, this message translates to:
  /// **'Đang xem lại phiên: {date}'**
  String viewingSession(String date);

  /// No description provided for @todayReset.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay ↺'**
  String get todayReset;

  /// No description provided for @coachWelcomeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào! Tôi là AstroBot ✨'**
  String get coachWelcomeTitle;

  /// No description provided for @coachWelcomeBody.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn đã nạp {calories} kcal ({protein}g Protein).\nHãy chọn câu hỏi nhanh bên dưới hoặc nhập thực đơn bạn muốn tư vấn!'**
  String coachWelcomeBody(int calories, int protein);

  /// No description provided for @coachHistorySheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử hội thoại AstroCoach'**
  String get coachHistorySheetTitle;

  /// No description provided for @coachHistorySheetSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại hoặc chuyển phiên tư vấn dinh dưỡng'**
  String get coachHistorySheetSubtitle;

  /// No description provided for @coachHistoryLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải lịch sử: {error}'**
  String coachHistoryLoadError(String error);

  /// No description provided for @coachHistoryEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cuộc trò chuyện nào trước đó.'**
  String get coachHistoryEmptyTitle;

  /// No description provided for @coachHistoryEmptySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Các phiên tư vấn dinh dưỡng hàng ngày sẽ tự động lưu tại đây.'**
  String get coachHistoryEmptySubtitle;

  /// No description provided for @todayWithDate.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay ({date})'**
  String todayWithDate(String date);

  /// No description provided for @currentViewing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xem'**
  String get currentViewing;

  /// No description provided for @messagesCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} tin nhắn'**
  String messagesCount(int count);

  /// No description provided for @deleteChatTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Xoá cuộc trò chuyện'**
  String get deleteChatTooltip;

  /// No description provided for @deleteChatTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá cuộc trò chuyện?'**
  String get deleteChatTitle;

  /// No description provided for @deleteChatEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc trò chuyện hiện tại đang trống.'**
  String get deleteChatEmpty;

  /// No description provided for @deleteChatConfirmDate.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả tin nhắn trong phiên ngày {date} sẽ bị xoá vĩnh viễn và không thể khôi phục.'**
  String deleteChatConfirmDate(String date);

  /// No description provided for @deleteChatConfirmGeneral.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả tin nhắn trong phiên này sẽ bị xoá vĩnh viễn và không thể khôi phục.'**
  String get deleteChatConfirmGeneral;

  /// No description provided for @deleteChatSuccess.
  ///
  /// In vi, this message translates to:
  /// **'🗑️ Đã xoá cuộc trò chuyện thành công.'**
  String get deleteChatSuccess;

  /// No description provided for @deleteAction.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get deleteAction;

  /// No description provided for @deleteCancel.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get deleteCancel;

  /// No description provided for @coachAnalyzing.
  ///
  /// In vi, this message translates to:
  /// **'AstroCoach đang phân tích...'**
  String get coachAnalyzing;

  /// No description provided for @cannotAccessMicrophone.
  ///
  /// In vi, this message translates to:
  /// **'Không thể truy cập Microphone để nhận diện giọng nói'**
  String get cannotAccessMicrophone;

  /// No description provided for @messageLimitTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giới hạn tin nhắn'**
  String get messageLimitTitle;

  /// No description provided for @messageLimitBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã đạt giới hạn 50 tin nhắn hôm nay. Hãy quay lại ngày mai nhé! 🌙'**
  String get messageLimitBody;

  /// No description provided for @understood.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiểu'**
  String get understood;

  /// No description provided for @dishFromCoach.
  ///
  /// In vi, this message translates to:
  /// **'Món từ AstroCoach'**
  String get dishFromCoach;

  /// No description provided for @addedDishToLog.
  ///
  /// In vi, this message translates to:
  /// **'✨ Đã thêm \"{dishName}\" ({calories} kcal) vào nhật ký!'**
  String addedDishToLog(String dishName, int calories);

  /// No description provided for @coachErrorTimeout.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi quá lâu. Vui lòng thử lại.'**
  String get coachErrorTimeout;

  /// No description provided for @coachErrorInvalidApiKey.
  ///
  /// In vi, this message translates to:
  /// **'Gemini API Key không hợp lệ hoặc chưa được cấu hình. Vui lòng kiểm tra lại API Key.'**
  String get coachErrorInvalidApiKey;

  /// No description provided for @coachErrorServerOverloaded.
  ///
  /// In vi, this message translates to:
  /// **'Máy chủ AI đang quá tải. Vui lòng thử lại sau.'**
  String get coachErrorServerOverloaded;

  /// No description provided for @coachErrorGeneral.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra. Vui lòng thử lại.'**
  String get coachErrorGeneral;

  /// No description provided for @tapToLog.
  ///
  /// In vi, this message translates to:
  /// **'1-Chạm'**
  String get tapToLog;

  /// No description provided for @errorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: {error}'**
  String errorLabel(String error);

  /// No description provided for @promptRemainingCaloriesLongFull.
  ///
  /// In vi, this message translates to:
  /// **'🔥 Còn {calories} kcal, ăn gì no lâu?'**
  String promptRemainingCaloriesLongFull(int calories);

  /// No description provided for @promptRemainingCaloriesLight.
  ///
  /// In vi, this message translates to:
  /// **'🥗 Còn {calories} kcal, món nhẹ dưới 300 kcal?'**
  String promptRemainingCaloriesLight(int calories);

  /// No description provided for @promptExceededCalories.
  ///
  /// In vi, this message translates to:
  /// **'⚠️ Vượt {calories} kcal, mẹo cân bằng?'**
  String promptExceededCalories(int calories);

  /// No description provided for @promptDeficitProtein.
  ///
  /// In vi, this message translates to:
  /// **'🥩 Thiếu {protein}g đạm, ăn gì bù nhanh?'**
  String promptDeficitProtein(int protein);

  /// No description provided for @promptSufficientProtein.
  ///
  /// In vi, this message translates to:
  /// **'💪 Đã đủ đạm, ăn gì tiếp không thừa calo?'**
  String get promptSufficientProtein;

  /// No description provided for @promptHighSodium.
  ///
  /// In vi, this message translates to:
  /// **'🧂 Lượng natri cao, cách giảm tích nước?'**
  String get promptHighSodium;

  /// No description provided for @promptHighFiber.
  ///
  /// In vi, this message translates to:
  /// **'🥦 Gợi ý món nhiều chất xơ dễ tiêu hóa'**
  String get promptHighFiber;

  /// No description provided for @proteinShort.
  ///
  /// In vi, this message translates to:
  /// **'Đạm'**
  String get proteinShort;

  /// No description provided for @carbsShort.
  ///
  /// In vi, this message translates to:
  /// **'Carbs'**
  String get carbsShort;

  /// No description provided for @fatShort.
  ///
  /// In vi, this message translates to:
  /// **'Béo'**
  String get fatShort;

  /// No description provided for @sodiumShort.
  ///
  /// In vi, this message translates to:
  /// **'Natri'**
  String get sodiumShort;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
