import 'package:btl_food_delivery_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

enum LanguageType {
  English(Locale('en'), "English"),
  VietNamese(Locale('vi'), "Tiếng Việt");

  final Locale locale;
  final String nameLanguage;
  const LanguageType(this.locale, this.nameLanguage);
}

class L10n {
  static final all = LanguageType.values.map((e) => e.locale);
}

class S {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
