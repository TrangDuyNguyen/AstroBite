// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AnalyticsPage]
class AnalyticsRoute extends PageRouteInfo<void> {
  const AnalyticsRoute({List<PageRouteInfo>? children})
    : super(AnalyticsRoute.name, initialChildren: children);

  static const String name = 'AnalyticsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AnalyticsPage();
    },
  );
}

/// generated route for
/// [CameraPage]
class CameraRoute extends PageRouteInfo<void> {
  const CameraRoute({List<PageRouteInfo>? children})
    : super(CameraRoute.name, initialChildren: children);

  static const String name = 'CameraRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CameraPage();
    },
  );
}

/// generated route for
/// [CoachPage]
class CoachRoute extends PageRouteInfo<void> {
  const CoachRoute({List<PageRouteInfo>? children})
    : super(CoachRoute.name, initialChildren: children);

  static const String name = 'CoachRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CoachPage();
    },
  );
}

/// generated route for
/// [GoalSummaryPage]
class GoalSummaryRoute extends PageRouteInfo<GoalSummaryRouteArgs> {
  GoalSummaryRoute({
    Key? key,
    required String gender,
    required int birthYear,
    required double heightCm,
    required double weightKg,
    required double targetWeightKg,
    required String activityLevel,
    required String fitnessGoal,
    List<PageRouteInfo>? children,
  }) : super(
         GoalSummaryRoute.name,
         args: GoalSummaryRouteArgs(
           key: key,
           gender: gender,
           birthYear: birthYear,
           heightCm: heightCm,
           weightKg: weightKg,
           targetWeightKg: targetWeightKg,
           activityLevel: activityLevel,
           fitnessGoal: fitnessGoal,
         ),
         initialChildren: children,
       );

  static const String name = 'GoalSummaryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GoalSummaryRouteArgs>();
      return GoalSummaryPage(
        key: args.key,
        gender: args.gender,
        birthYear: args.birthYear,
        heightCm: args.heightCm,
        weightKg: args.weightKg,
        targetWeightKg: args.targetWeightKg,
        activityLevel: args.activityLevel,
        fitnessGoal: args.fitnessGoal,
      );
    },
  );
}

class GoalSummaryRouteArgs {
  const GoalSummaryRouteArgs({
    this.key,
    required this.gender,
    required this.birthYear,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.activityLevel,
    required this.fitnessGoal,
  });

  final Key? key;

  final String gender;

  final int birthYear;

  final double heightCm;

  final double weightKg;

  final double targetWeightKg;

  final String activityLevel;

  final String fitnessGoal;

  @override
  String toString() {
    return 'GoalSummaryRouteArgs{key: $key, gender: $gender, birthYear: $birthYear, heightCm: $heightCm, weightKg: $weightKg, targetWeightKg: $targetWeightKg, activityLevel: $activityLevel, fitnessGoal: $fitnessGoal}';
  }
}

/// generated route for
/// [HealthConnectionPage]
class HealthConnectionRoute extends PageRouteInfo<void> {
  const HealthConnectionRoute({List<PageRouteInfo>? children})
    : super(HealthConnectionRoute.name, initialChildren: children);

  static const String name = 'HealthConnectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HealthConnectionPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LeaderboardPage]
class LeaderboardRoute extends PageRouteInfo<void> {
  const LeaderboardRoute({List<PageRouteInfo>? children})
    : super(LeaderboardRoute.name, initialChildren: children);

  static const String name = 'LeaderboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LeaderboardPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [ManualEntryPage]
class ManualEntryRoute extends PageRouteInfo<ManualEntryRouteArgs> {
  ManualEntryRoute({
    Key? key,
    String? initialMealType,
    List<PageRouteInfo>? children,
  }) : super(
         ManualEntryRoute.name,
         args: ManualEntryRouteArgs(key: key, initialMealType: initialMealType),
         initialChildren: children,
       );

  static const String name = 'ManualEntryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ManualEntryRouteArgs>(
        orElse: () => const ManualEntryRouteArgs(),
      );
      return ManualEntryPage(
        key: args.key,
        initialMealType: args.initialMealType,
      );
    },
  );
}

class ManualEntryRouteArgs {
  const ManualEntryRouteArgs({this.key, this.initialMealType});

  final Key? key;

  final String? initialMealType;

  @override
  String toString() {
    return 'ManualEntryRouteArgs{key: $key, initialMealType: $initialMealType}';
  }
}

/// generated route for
/// [MealDetailPage]
class MealDetailRoute extends PageRouteInfo<MealDetailRouteArgs> {
  MealDetailRoute({
    Key? key,
    String mealType = 'lunch',
    List<PageRouteInfo>? children,
  }) : super(
         MealDetailRoute.name,
         args: MealDetailRouteArgs(key: key, mealType: mealType),
         initialChildren: children,
       );

  static const String name = 'MealDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MealDetailRouteArgs>(
        orElse: () => const MealDetailRouteArgs(),
      );
      return MealDetailPage(key: args.key, mealType: args.mealType);
    },
  );
}

class MealDetailRouteArgs {
  const MealDetailRouteArgs({this.key, this.mealType = 'lunch'});

  final Key? key;

  final String mealType;

  @override
  String toString() {
    return 'MealDetailRouteArgs{key: $key, mealType: $mealType}';
  }
}

/// generated route for
/// [MealPlannerPage]
class MealPlannerRoute extends PageRouteInfo<void> {
  const MealPlannerRoute({List<PageRouteInfo>? children})
    : super(MealPlannerRoute.name, initialChildren: children);

  static const String name = 'MealPlannerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MealPlannerPage();
    },
  );
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPage();
    },
  );
}

/// generated route for
/// [ProfileEditPage]
class ProfileEditRoute extends PageRouteInfo<void> {
  const ProfileEditRoute({List<PageRouteInfo>? children})
    : super(ProfileEditRoute.name, initialChildren: children);

  static const String name = 'ProfileEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileEditPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [RecipeBuilderPage]
class RecipeBuilderRoute extends PageRouteInfo<void> {
  const RecipeBuilderRoute({List<PageRouteInfo>? children})
    : super(RecipeBuilderRoute.name, initialChildren: children);

  static const String name = 'RecipeBuilderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RecipeBuilderPage();
    },
  );
}

/// generated route for
/// [RecipesPage]
class RecipesRoute extends PageRouteInfo<void> {
  const RecipesRoute({List<PageRouteInfo>? children})
    : super(RecipesRoute.name, initialChildren: children);

  static const String name = 'RecipesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RecipesPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [ScanReviewPage]
class ScanReviewRoute extends PageRouteInfo<ScanReviewRouteArgs> {
  ScanReviewRoute({
    Key? key,
    ScanResult? scanResult,
    Uint8List? imageBytes,
    List<PageRouteInfo>? children,
  }) : super(
         ScanReviewRoute.name,
         args: ScanReviewRouteArgs(
           key: key,
           scanResult: scanResult,
           imageBytes: imageBytes,
         ),
         initialChildren: children,
       );

  static const String name = 'ScanReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ScanReviewRouteArgs>(
        orElse: () => const ScanReviewRouteArgs(),
      );
      return ScanReviewPage(
        key: args.key,
        scanResult: args.scanResult,
        imageBytes: args.imageBytes,
      );
    },
  );
}

class ScanReviewRouteArgs {
  const ScanReviewRouteArgs({this.key, this.scanResult, this.imageBytes});

  final Key? key;

  final ScanResult? scanResult;

  final Uint8List? imageBytes;

  @override
  String toString() {
    return 'ScanReviewRouteArgs{key: $key, scanResult: $scanResult, imageBytes: $imageBytes}';
  }
}

/// generated route for
/// [ShellScreen]
class ShellRoute extends PageRouteInfo<void> {
  const ShellRoute({List<PageRouteInfo>? children})
    : super(ShellRoute.name, initialChildren: children);

  static const String name = 'ShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShellScreen();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}
