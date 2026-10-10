import 'package:flutter/widgets.dart';
import 'package:astrobite/l10n/app_localizations.dart';

/// Extension on [BuildContext] for concise access to [AppLocalizations].
/// Gracefully falls back to Vietnamese localization when used in bare widget tests.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('vi'));
}
