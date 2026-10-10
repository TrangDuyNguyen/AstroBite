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
