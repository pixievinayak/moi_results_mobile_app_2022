import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/global.dart';

// String getTranslated(BuildContext context, String key){
//   return AppLocalizations.of(context).getTranslatedValue(key);
// }

class Translations {
  static const String homePageTitle = "home_page_title";
  static const String homePageCountdownTitle = "home_page_countdown_title";
  static const String homePageChkEligibilityTitle = "home_page_chk_eligibility_title";
  static const String homePageChkEligibility = "home_page_chk_eligibility";

  static const String vpPageTitle = "vp_page_title";
  static const String vpPageVoterEligibility = "vp_page_voter_eligibility";
  static const String vpPageViewCert = "vp_page_view_cert";
  static const String vpPageVoterHist = "vp_page_voter_hist";
  static const String vpPageCompRV = "vp_page_comp_rv";
  static const String vpPageCompKV = "vp_page_comp_kv";
  static const String vpPageViewCertMsg = "vp_page_view_cert_msg";
  static const String vpPageReg = "vp_page_reg";
  static const String vpPageNotReg = "vp_page_not_reg";

  static const String commonName = "common_name";
  static const String commonCivilID = "common_civil_id";
  static const String commonCivilIDValMsg = "common_civil_id_val_msg";
  static const String commonDoB = "common_dob";
  static const String commonDoBValMsg = "common_dob_val_msg";
  static const String commonGovernorate = "common_governorate";
  static const String commonWilayat = "common_wilayat";
  static const String commonPolStn = "common_pol_stn";
  static const String commonSelectWilayat = "common_select_wilayat";
  static const String commonSelectWilayatPlaceHolder = "common_select_wilayat_place_holder";
  static const String day = "day";
  static const String days = "days";
  static const String hour = "hour";
  static const String hours = "hours";
  static const String min = "min";
  static const String mins = "mins";
  static const String sec = "sec";
  static const String secs = "secs";

  static const String settingsPageTitle = "settings_page_title";
  static const String settingsPageRegWilayat = "settings_page_reg_wilayat";
  static const String settingsPageRegWilayatPlaceHolder = "settings_page_reg_wilayat_place_holder";
  static const String mapsPageSelectWilayat = "maps_page_select_wilayat";
  static const String mapsPageSelectWilayatPlaceHolder = "maps_page_select_wilayat_place_holder";
  static const String candidatesPageSelectWilayat = "candidates_page_select_wilayat";
  static const String candidatesPageSelectWilayatPlaceHolder = "candidates_page_select_wilayat_place_holder";
  static const String statsPageSelectWilayat = "stats_page_select_wilayat";
  static const String statsPageSelectWilayatPlaceHolder = "stats_page_select_wilayat_place_holder";
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