// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class AppLocalizations {
//   final Locale locale;
//
//   AppLocalizations(this.locale);
//
//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }
//
//   late Map<String, String> _localizedValues;
//
//   Future load() async {
//     debugPrint("Loading translations file......");
//     String jsonStringValues = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
//
//     Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
//
//     _localizedValues = mappedJson.map((key, value) => MapEntry(key, value));
//   }
//
//   String? getTranslatedValue(String key){
//     return _localizedValues[key];
//   }
//
//   static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
//
// }
//
// class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();
//
//   @override
//   bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);
//
//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     debugPrint("Loading localization Starting...");
//     AppLocalizations appLocalizations = new AppLocalizations(locale);
//     await appLocalizations.load();
//     debugPrint("Loading localization Ended!");
//     return appLocalizations;
//   }
//
//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }