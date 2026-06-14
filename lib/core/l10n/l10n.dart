import 'package:flutter/widgets.dart';
import 'package:gatewise_app/l10n/app_localizations.dart';

export 'package:gatewise_app/l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this)!;
}
