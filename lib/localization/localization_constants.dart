import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/global.dart';

// String getTranslated(BuildContext context, String key){
//   return AppLocalizations.of(context).getTranslatedValue(key);
// }

class Translations {
  static const String homePageContent = "home_page_content";
  static const String settingsPageTitle = "settings_page_title";
  static const String settingsPageRegWilayat = "settings_page_reg_wilayat";
  static const String settingsPageRegWilayatPlaceHolder = "settings_page_reg_wilayat_place_holder";
  static const String mapsPageSelectWilayat = "maps_page_select_wilayat";
  static const String mapsPageSelectWilayatPlaceHolder = "maps_page_select_wilayat_place_holder";
  static const String candidatesPageSelectWilayat = "candidates_page_select_wilayat";
  static const String candidatesPageSelectWilayatPlaceHolder = "candidates_page_select_wilayat_place_holder";
  static const String statsPageSelectWilayat = "stats_page_select_wilayat";
  static const String statsPageSelectWilayatPlaceHolder = "stats_page_select_wilayat_place_holder";
  static const String genericSelectWilayat = "generic_select_wilayat";
  static const String genericSelectWilayatPlaceHolder = "generic_select_wilayat_place_holder";
}

class Languages{
  //static String currentLanguageCode = Languages.english_code;
  static String currentLanguageName = Languages.enLangName;
  static const String enLangCode = "en";
  static const String enLangCountryIndia = "IN";
  static const String enLangName = "English";
  static const String arLangCode = "ar";
  static const String arLangCountryOman = "OM";
  static const String arLangName = "Arabic";
  static bool isEnglish = Languages.currentLanguageName == Languages.enLangName;
}

Future<Locale> setLocale(String languageCode, String languageCountry) async{
  Languages.currentLanguageName = languageCode == Languages.enLangCode ? Languages.enLangName : Languages.arLangName;
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(StorageKeys.langCode, languageCode);
  await _prefs.setString(StorageKeys.langCountry, languageCountry);
  return _locale(languageCode, languageCountry);
}
Future<Locale> getLocale() async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(StorageKeys.langCode) ?? Languages.enLangCode;
  String languageCountry = _prefs.getString(StorageKeys.langCountry) ?? Languages.enLangCountryIndia;
  return _locale(languageCode, languageCountry);
}

Locale _locale(String languageCode, String languageCountry){
  // Locale _tempLocale;
  // switch(languageCode){
  //   case Languages.english_lang_code:
  //     _tempLocale = Locale(languageCode, "IN");
  //     break;
  //   case Languages.arabic_lang_code:
  //     _tempLocale = Locale(languageCode, "OM");
  //     break;
  //   default:
  //     _tempLocale = Locale(Languages.english_lang_code, "IN");
  //     break;
  // }
  // return _tempLocale;
  return Locale(languageCode, languageCountry);
}