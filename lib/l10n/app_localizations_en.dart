// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AstroBite';

  @override
  String get login => 'Log In';

  @override
  String get register => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get googleSignIn => 'Continue with Google';

  @override
  String get sendResetLink => 'Send Link';

  @override
  String get resetPasswordSent => 'A password reset link has been sent to your email. Please check your inbox.';

  @override
  String get orDivider => 'OR';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get todayOverview => 'Today';

  @override
  String get nutritionLog => 'Nutrition Log';

  @override
  String get remaining => 'Remaining';

  @override
  String get consumed => 'Consumed';

  @override
  String get calories => 'Calories';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get scanFood => 'Scan Food';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get saveLog => 'Save Log';

  @override
  String get notFood => 'Food could not be recognized. Please retake a clearer photo or enter manually.';

  @override
  String get quotaExceeded => 'You have reached your limit of 10 AI scans today. Please use manual entry.';

  @override
  String get networkError => 'Network connection error. Please try again.';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get searchFood => 'Search food...';

  @override
  String get profile => 'Profile';

  @override
  String get analytics => 'Analytics';

  @override
  String get today => 'Today';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteFoodConfirmMessage => 'Are you sure you want to delete this food item from the meal?';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get overBudget => 'over budget';

  @override
  String get kcalRemaining => 'remaining';

  @override
  String get noMealLogs => 'No meals logged yet';

  @override
  String get navToday => 'Today';

  @override
  String get navCoach => 'AstroCoach';

  @override
  String get navInsights => 'Insights';

  @override
  String get navProfile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get languageSelect => 'Select Language';

  @override
  String get systemLanguage => 'System Default';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get signOut => 'Sign Out';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get viewingOfflineData => 'Viewing offline data';

  @override
  String get geminiAiConfig => 'Gemini AI Configuration';

  @override
  String get apiKeySettings => 'API Key Settings';

  @override
  String get customKeyPrefix => 'Custom key: ';

  @override
  String get aiActive => 'AstroBite AI: Active';

  @override
  String get aiNotConfigured => 'API Key Not Configured';

  @override
  String get usingCustomKeyDesc => 'Using custom key • Tap to change';

  @override
  String get aiReadyDesc => 'Built-in AI system ready • Advanced options';

  @override
  String get addKeyFreeDesc => 'Tap to add free key from AI Studio';

  @override
  String get aiCoach => 'AI Coach';

  @override
  String get aiCoachDesc => 'Smart dietary & nutrition guidance';

  @override
  String get healthConnection => 'Health Connection';

  @override
  String get healthConnectionDesc => 'Sync Apple Health / Health Connect';

  @override
  String get homeWidget => 'Home Screen Widget';

  @override
  String get homeWidgetDesc => 'Quick Calorie/Macro view & 1-tap AI scan';

  @override
  String get recipeCatalog => 'Recipes';

  @override
  String get recipeCatalogDesc => 'Manage custom recipes & portion scaling';

  @override
  String get mealPlanner => '7-Day Meal Plan';

  @override
  String get mealPlannerDesc => 'Schedule meals & 1-tap diary logging';

  @override
  String get guilds => 'Planetary Guilds';

  @override
  String get guildsDesc => 'Form teams & Weekly planetary challenges';

  @override
  String get energyMetricsTitle => 'Energy Metrics (BMR & TDEE)';

  @override
  String get standardized => 'Standardized';

  @override
  String get bmrSubtitle => 'Resting energy expenditure';

  @override
  String get tdeeSubtitle => 'Daily energy expenditure';

  @override
  String get personalMetricsTitle => 'Personal Metrics';

  @override
  String get edit => 'Edit';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get birthYear => 'Birth Year';

  @override
  String get activityLevel => 'Activity Level';

  @override
  String get sedentary => 'Sedentary';

  @override
  String get lightActivity => 'Light (1-3 days)';

  @override
  String get moderateActivity => 'Moderate (3-5 days)';

  @override
  String get activeActivity => 'Active (6-7 days)';

  @override
  String get veryActiveActivity => 'Very Active';

  @override
  String get goalLoseWeight => 'Lose Fat';

  @override
  String get goalMaintain => 'Maintain Weight';

  @override
  String get goalGainMuscle => 'Build Muscle';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String errorWithDetails(String error) {
    return 'Error: $error';
  }

  @override
  String get loginToSaveLog => 'Please login to save food log';

  @override
  String get cameraFlash => 'Flash';

  @override
  String get scanTips => 'Scan Tips';

  @override
  String get scanTipsTitle => 'Tips for AI Food Photography';

  @override
  String get scanTipLighting => 'Ensure good lighting and avoid dark shadows obscuring food.';

  @override
  String get scanTipFraming => 'Fit the entire dish inside the center viewfinder.';

  @override
  String get scanTipAngle => 'For multi-dish meals, shoot from above (top-down view).';

  @override
  String get gotIt => 'Got It';

  @override
  String get retakePhoto => 'Retake Photo';

  @override
  String get rescan => 'Re-scan';

  @override
  String get aiScanResult => 'AI Analysis Results';

  @override
  String get noScanData => 'No food scan data available.';

  @override
  String get backToCamera => 'Back to Camera';

  @override
  String get portionEstimated => 'Estimated Portion';

  @override
  String get portionBowl => '1 Bowl (~150g)';

  @override
  String get portionPlate => '1 Plate (~300g)';

  @override
  String get portionStandard => 'Standard Portion (~350g)';

  @override
  String saveToMeal(String meal, int calories) {
    return 'Save to $meal ($calories kcal)';
  }

  @override
  String foodSavedToMeal(String dishName, String meal) {
    return 'Saved $dishName to $meal!';
  }

  @override
  String errorSavingLog(String error) {
    return 'Error saving food log: $error';
  }

  @override
  String detectedDishesCount(int count) {
    return 'Detected items ($count dishes)';
  }

  @override
  String get addDish => 'Add Dish';

  @override
  String get removeDish => 'Remove dish';

  @override
  String confidencePercent(int percent) {
    return '$percent% confidence';
  }

  @override
  String multiDishPlatter(int count) {
    return '🍱 Meal Platter ($count dishes)';
  }

  @override
  String andOtherDishes(String firstDish, int count) {
    return '$firstDish & $count other dishes';
  }

  @override
  String eatWithBroth(int calories) {
    return 'Eat with broth (+$calories kcal)';
  }

  @override
  String eatWithoutBroth(int calories) {
    return 'Dry without broth (-$calories kcal)';
  }

  @override
  String brothSodiumSub(int sodium) {
    return 'Includes ~${sodium}mg broth sodium';
  }

  @override
  String get brothFullFlavorSub => 'Full broth & seasoning included';

  @override
  String brothSavedSub(int calories) {
    return 'Saves $calories kcal & reduces fat ✨';
  }

  @override
  String get manualAddDishTitle => 'Add Side Dish Manually';

  @override
  String get dishNameLabel => 'Dish Name';

  @override
  String get dishNameHint => 'E.g. Bitter melon soup, Fried egg...';

  @override
  String get caloriesKcalLabel => 'Calories (kcal)';

  @override
  String get caloriesHint => 'E.g. 120';

  @override
  String get portionGramsLabel => 'Portion (g)';

  @override
  String get portionHint => 'E.g. 150';

  @override
  String get addToMealPlatter => 'Add to meal';

  @override
  String sodiumChip(String amount) {
    return 'Sodium: $amount mg';
  }

  @override
  String fiberChip(String amount) {
    return 'Fiber: $amount g';
  }

  @override
  String sugarChip(String amount) {
    return 'Sugar: $amount g';
  }

  @override
  String get highSodiumBadge => 'High Sodium (>800mg)';

  @override
  String get highSodiumAlertTooltip => 'Contains over 800mg Sodium (>1/3 daily limit). Remember to stay hydrated!';

  @override
  String get dishNotRecognized => 'Dish Not Recognized';

  @override
  String get aiServerBusy => 'AI server is currently overloaded (503). Please tap \"Retry\" in a moment.';

  @override
  String get aiOverloaded => 'AI server temporarily overloaded. Please try again shortly.';

  @override
  String get aiRateLimited => 'AI rate limit reached. Please try again in a few minutes.';

  @override
  String get aiConnectionError => 'Cannot connect to AI server. Please try again.';

  @override
  String get apiKeyInvalidTitle => 'Invalid Gemini API Key';

  @override
  String get apiKeyRequiredTitle => 'Gemini API Key Required';

  @override
  String get apiKeyInvalidDesc => 'The API key you are using is invalid or expired.\n\nPlease check your key or create a new one from Google AI Studio.';

  @override
  String get apiKeyRequiredDesc => 'To scan food with AI for free (no credit card needed), set up a Gemini API Key from Google AI Studio (aistudio.google.com).\n\nYou can paste the key now or use Manual Entry.';

  @override
  String get setupApiKey => 'Set Up Key';

  @override
  String get apiKeySavedSuccess => 'Gemini API Key saved successfully!';

  @override
  String get apiKeyRemovedSuccess => 'Personal Gemini API Key removed.';

  @override
  String get apiKeyDialogDescription => 'AstroBite uses Google Gemini AI for food recognition. You can use a 100% free API key (no credit card required).';

  @override
  String get apiKeyCopiedLink => 'Copied Google AI Studio link to clipboard!';

  @override
  String get apiKeyGetFree => 'Get free key: aistudio.google.com\n(Tap to copy link)';

  @override
  String get pasteFromClipboard => 'Paste from clipboard';

  @override
  String get apiKeyStatusDefault => 'Status: Using default app key (Ready)';

  @override
  String apiKeyStatusCustom(String maskedKey) {
    return 'Status: Using personal key ($maskedKey)';
  }

  @override
  String get apiKeyStatusNone => 'Status: No API key configured';

  @override
  String get deleteKey => 'Delete Key';

  @override
  String get saveKey => 'Save Key';

  @override
  String calorieTrendDays(int days) {
    return 'Calorie Intake Trend ($days days)';
  }

  @override
  String dailyTargetKcal(int target) {
    return 'Daily target: $target kcal';
  }

  @override
  String get weightTrendTitle => 'Weight Trend (kg)';

  @override
  String weightGoalSubtitle(String target) {
    return 'Goal: $target kg • Steady loss';
  }

  @override
  String chartTarget(int target) {
    return 'Goal: $target';
  }

  @override
  String chartTargetWeight(String target) {
    return 'Goal: $target kg';
  }

  @override
  String get noTrackingData => 'No tracking data yet';

  @override
  String get week1 => 'Week 1';

  @override
  String get week2 => 'Week 2';

  @override
  String get week3 => 'Week 3';

  @override
  String get week4 => 'Week 4';

  @override
  String dayNumber(int day) {
    return ' (Day $day)';
  }

  @override
  String get macroBreakdownTitle => 'Average Macro Distribution';

  @override
  String get macroBreakdownSubtitle => 'Energy absorption ratio from macronutrients';

  @override
  String get balanced => 'Balanced';

  @override
  String get kpiOnTrack => 'On Track';

  @override
  String get kpiSlightlyOver => 'Slightly Over';

  @override
  String get discipline => 'Discipline';

  @override
  String get daysUnit => 'days';

  @override
  String get sevenDays => '7 days';

  @override
  String get thirtyDays => '30 days';

  @override
  String get energyBalanceTitle => 'Energy Balance';

  @override
  String connectHealthPrompt(String service) {
    return 'Connect $service to view calories burned';
  }

  @override
  String get connect => 'Connect';

  @override
  String get healthErrorMsg => 'Cannot read Health data — check permissions';

  @override
  String get caloriesBurned => 'Calories Burned';

  @override
  String get caloriesIntake => 'Calories In';

  @override
  String budgetRemaining(int calories) {
    return 'Remaining budget: $calories kcal';
  }

  @override
  String get targetWeight => 'Target Weight';

  @override
  String get fitnessGoal => 'Fitness Goal';

  @override
  String get biologicalInfo => 'Biological Information';

  @override
  String get biologicalGender => 'Biological Sex';

  @override
  String get enterBirthYear => 'Please enter birth year';

  @override
  String get enterHeight => 'Please enter height';

  @override
  String get currentWeight => 'Current Weight (kg)';

  @override
  String get enterCurrentWeight => 'Please enter current weight';

  @override
  String get profileUpdateSuccess => '✨ Profile and nutrition goals updated successfully!';

  @override
  String get goalAndActivity => 'Goal & Activity Level';

  @override
  String get weeklyActivityLevel => 'Weekly Activity Level';

  @override
  String get goalLoseWeightTitle => 'Fat Loss & Body Tone';

  @override
  String get goalLoseWeightSub => 'Safe deficit (-500 kcal/day)';

  @override
  String get goalMaintainTitle => 'Maintain Weight';

  @override
  String get goalMaintainSub => 'Balanced calorie intake with TDEE';

  @override
  String get goalGainMuscleTitle => 'Build Muscle & Lean Mass';

  @override
  String get goalGainMuscleSub => 'Slight surplus (+300 kcal/day) with workout';

  @override
  String get syncPendingTooltip => 'Saved on device. Will auto-sync when online.';

  @override
  String get syncFailedTooltip => 'Failed to upload. Tap to retry.';

  @override
  String get syncSuccessTooltip => 'Synced to cloud';

  @override
  String foodDeleted(String dishName) {
    return 'Deleted $dishName';
  }

  @override
  String get recentFoods => 'Recent Foods:';

  @override
  String get myRecipes => 'My Recipes';

  @override
  String get addCustomDish => 'Add Custom Dish';

  @override
  String popularFoods(int count) {
    return 'Popular Foods ($count)';
  }

  @override
  String get customFoodEntry => 'Custom Food';

  @override
  String noFoodFound(String query) {
    return 'No food found for \"$query\"';
  }

  @override
  String get enterThisFoodManually => 'Enter this food manually';

  @override
  String get analyzingFood => 'Analyzing food...';

  @override
  String get tipWater => '💡 Drinking 2 liters of water daily boosts your metabolism.';

  @override
  String get tipVeggies => '🥗 Green vegetables are low in calories but rich in fiber and vitamins.';

  @override
  String get tipProtein => '🍳 Protein keeps you full longer and preserves lean muscle.';

  @override
  String get tipMealTiming => '⏰ Eating on schedule helps regulate your daily energy.';

  @override
  String get tipExercise => '🏃 Combine 30 minutes of daily activity to stay healthy.';

  @override
  String get notSet => 'Not set';

  @override
  String get bmiIndex => 'BMI Index';

  @override
  String get dailyCalorieTarget => 'Daily Calorie Target';

  @override
  String get targetWeightOptional => 'Target weight (kg, optional)';

  @override
  String get astroBiteRecommendation => 'AstroBite Scientific Recommendation';

  @override
  String recommendationCalories(int calories) {
    return 'Recommended: $calories kcal/day';
  }

  @override
  String get apply => 'Apply';

  @override
  String get dailyCalorieTargetWithUnit => 'Daily Calorie Target (kcal)';

  @override
  String get enterTargetCalories => 'Please enter calorie target';

  @override
  String savedFoodToMeal(String dishName, String meal) {
    return 'Saved $dishName to $meal!';
  }

  @override
  String cannotOpenSource(String error) {
    return 'Could not access camera/gallery: $error';
  }

  @override
  String get aiDecodingFood => '✨ AI is decoding food structure...';

  @override
  String get pointCameraAtFood => 'Point camera at your plate and tap capture';

  @override
  String get scanningLocatingFood => '✨ LOCATING FOOD';

  @override
  String get selectFromGallery => 'Choose from gallery';

  @override
  String get manualEntryTooltip => 'Manual entry';

  @override
  String get toppingsAndSidesHeader => 'TOPPINGS & SIDES (TAP TO REMOVE)';

  @override
  String standardPortion(int weight) {
    return 'Standard portion • ${weight}g';
  }

  @override
  String get scansExhaustedToday => 'Daily scan limit reached today (10/10)';

  @override
  String scansRemainingToday(int remaining, int total) {
    return '$remaining/$total daily scans remaining today';
  }

  @override
  String get target => 'Target';

  @override
  String get portion100g => 'Standard (~100g)';

  @override
  String get todayActivityTitle => 'Today\'s Activity';

  @override
  String stepsCount(String count) {
    return '🚶 $count steps';
  }

  @override
  String get startMovingPrompt => 'Let\'s start moving! 🚶';

  @override
  String minutesUnit(int minutes) {
    return '$minutes mins';
  }

  @override
  String get offlineModeNotice => 'Offline Mode — Data safely saved on device';

  @override
  String syncedMealsCount(int count) {
    return 'Synced $count meals to cloud';
  }

  @override
  String get macroCarbs => 'Carbs';

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroFat => 'Fat';

  @override
  String get coachHistory => 'History';

  @override
  String get coachHistoryTooltip => 'Conversation History';

  @override
  String get onlineRealtimeNutritionist => 'Online • Real-time Nutritionist';

  @override
  String get nutritionOverviewToday => 'Today\'s Nutrition Overview';

  @override
  String budgetRemainingKcal(int calories) {
    return 'Remaining: $calories kcal';
  }

  @override
  String budgetOverKcal(int calories) {
    return 'Over: $calories kcal';
  }

  @override
  String sodiumWarning(int current, int target) {
    return 'Sodium Warning: ${current}mg / ${target}mg (near recommended limit)';
  }

  @override
  String get portionLabel => 'Portion:';

  @override
  String get quickLogNow => '⚡ Log Meal Now';

  @override
  String get quickLogging => 'Logging meal...';

  @override
  String get quickLogged => '✓ Meal Logged';

  @override
  String get suggestedDish => 'Suggested Dish';

  @override
  String get budgetImpactTitle => 'DAILY BUDGET IMPACT';

  @override
  String budgetOverTarget(int calories) {
    return '⚠️ Exceeds target by $calories kcal';
  }

  @override
  String budgetRemainingAfterMeal(int calories) {
    return 'Remaining after meal: $calories kcal';
  }

  @override
  String targetKcal(int target) {
    return 'Target: $target kcal';
  }

  @override
  String ingredientsLabel(String ingredients) {
    return 'Ingredients: $ingredients';
  }

  @override
  String get shuffleSuggestions => '🎲 Shuffle Suggestions';

  @override
  String questionSuggestions(int count) {
    return 'Suggested Questions ($count)';
  }

  @override
  String get medicalDisclaimer => '⚕️ AI suggestions for reference only, not a substitute for medical advice';

  @override
  String get collapseSuggestions => 'Collapse suggestions';

  @override
  String get expandSuggestions => 'Expand question suggestions';

  @override
  String get clearContent => 'Clear content';

  @override
  String get voiceListeningStop => 'Listening... Tap to stop';

  @override
  String get voiceInputTooltip => 'Voice Input (Hold to open AstroVoice)';

  @override
  String get askCoachHint => 'Ask AstroCoach about meals, macros...';

  @override
  String viewingSession(String date) {
    return 'Viewing session: $date';
  }

  @override
  String get todayReset => 'Today ↺';

  @override
  String get coachWelcomeTitle => 'Hello! I am AstroBot ✨';

  @override
  String coachWelcomeBody(int calories, int protein) {
    return 'Today you consumed $calories kcal (${protein}g Protein).\nPick a quick question below or ask about your menu!';
  }

  @override
  String get coachHistorySheetTitle => 'AstroCoach Conversation History';

  @override
  String get coachHistorySheetSubtitle => 'Review or switch nutrition consultation sessions';

  @override
  String coachHistoryLoadError(String error) {
    return 'Error loading history: $error';
  }

  @override
  String get coachHistoryEmptyTitle => 'No previous conversations yet.';

  @override
  String get coachHistoryEmptySubtitle => 'Daily nutrition consultation sessions will be automatically saved here.';

  @override
  String todayWithDate(String date) {
    return 'Today ($date)';
  }

  @override
  String get currentViewing => 'Active';

  @override
  String messagesCount(int count) {
    return '$count messages';
  }

  @override
  String get deleteChatTooltip => 'Delete conversation';

  @override
  String get deleteChatTitle => 'Delete conversation?';

  @override
  String get deleteChatEmpty => 'Current conversation is empty.';

  @override
  String deleteChatConfirmDate(String date) {
    return 'All messages in the session on $date will be permanently deleted and cannot be restored.';
  }

  @override
  String get deleteChatConfirmGeneral => 'All messages in this session will be permanently deleted and cannot be restored.';

  @override
  String get deleteChatSuccess => '🗑️ Conversation deleted successfully.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteCancel => 'Cancel';

  @override
  String get coachAnalyzing => 'AstroCoach is analyzing...';

  @override
  String get cannotAccessMicrophone => 'Could not access microphone for voice recognition';

  @override
  String get messageLimitTitle => 'Message Limit';

  @override
  String get messageLimitBody => 'You have reached the limit of 50 messages today. Please come back tomorrow! 🌙';

  @override
  String get understood => 'Understood';

  @override
  String get dishFromCoach => 'Dish from AstroCoach';

  @override
  String addedDishToLog(String dishName, int calories) {
    return '✨ Added \"$dishName\" ($calories kcal) to food log!';
  }

  @override
  String get coachErrorTimeout => 'Response timed out. Please try again.';

  @override
  String get coachErrorInvalidApiKey => 'Invalid or unconfigured Gemini API Key. Please verify your API Key.';

  @override
  String get coachErrorServerOverloaded => 'AI server is overloaded. Please try again later.';

  @override
  String get coachErrorGeneral => 'An error occurred. Please try again.';

  @override
  String get tapToLog => '1-Tap';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String promptRemainingCaloriesLongFull(int calories) {
    return '🔥 $calories kcal left, what keeps you full?';
  }

  @override
  String promptRemainingCaloriesLight(int calories) {
    return '🥗 $calories kcal left, light meal under 300 kcal?';
  }

  @override
  String promptExceededCalories(int calories) {
    return '⚠️ Exceeded $calories kcal, tips to rebalance?';
  }

  @override
  String promptDeficitProtein(int protein) {
    return '🥩 Short ${protein}g protein, what to eat to catch up?';
  }

  @override
  String get promptSufficientProtein => '💪 Reached protein goal, what next without excess cal?';

  @override
  String get promptHighSodium => '🧂 High sodium intake, how to reduce water retention?';

  @override
  String get promptHighFiber => '🥦 Suggest high-fiber, easy to digest foods';

  @override
  String get proteinShort => 'Protein';

  @override
  String get carbsShort => 'Carbs';

  @override
  String get fatShort => 'Fat';

  @override
  String get sodiumShort => 'Sodium';
}
