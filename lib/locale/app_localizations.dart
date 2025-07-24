import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'language_ar.dart';
import 'language_de.dart';
import 'language_en.dart';
import 'language_fr.dart';
import 'language_hi.dart';
import 'languages.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ar':
        return LanguageAr();
      case 'en':
        return LanguageEn();
      case 'de':
        return LanguageDe();
      case 'fr':
        return LanguageFr();
      case 'hi':
        return LanguageHi();

      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => true;
}
