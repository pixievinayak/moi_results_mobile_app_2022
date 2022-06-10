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

  static const String countNotStarted = "count_not_started";
  static const String finalResults = "final_results";
  static const String initialResults = "initial_results";
  static const String position = "position";
  static const String votes = "votes";
  static const String name = "name";
  static const String civilID = "civil_id";
  static const String civilIDValMsg = "civil_id_val_msg";
  static const String dob = "dob";
  static const String dobValMsg = "dob_val_msg";
  static const String governorate = "governorate";
  static const String wilayat = "wilayat";
  static const String polStn = "pol_stn";
  static const String selectWilayat = "select_wilayat";
  static const String selectWilayatPlaceHolder = "select_wilayat_place_holder";
  static const String day = "day";
  static const String days = "days";
  static const String hour = "hour";
  static const String hours = "hours";
  static const String min = "min";
  static const String mins = "mins";
  static const String sec = "sec";
  static const String secs = "secs";
  static const String yes = "yes";
  static const String no = "no";
  static const String male = "male";
  static const String female = "female";

  static const String settingsPageTitle = "settings_page_title";
  static const String settingsPageRegWilayat = "settings_page_reg_wilayat";
  static const String settingsPageRegWilayatPlaceHolder = "settings_page_reg_wilayat_place_holder";
  static const String settingsPageLang = "settings_page_lang";
  static const String settingsPageVer = "settings_page_ver";
  static const String settingsPageLocDatMsg = "settings_page_loc_dat_msg";
  
  static const String mapsPageSelectWilayat = "maps_page_select_wilayat";
  static const String mapsPageSelectWilayatPlaceHolder = "maps_page_select_wilayat_place_holder";
  static const String mapsPageTitle = "maps_page_title";
  static const String mapsPageGetDir = "maps_page_get_dir";
  static const String mapsPageRegular = "maps_page_regular";
  static const String mapsPageUnified = "maps_page_unified";

  static const String candidateProfilePageTitle = "candidate_profile_page_title";

  static const String candidatesPageTitle = "candidates_page_title";
  static const String candidatesPageSelWilMsg = "candidates_page_sel_wil_msg";
  static const String candidatesPageSelectWilayat = "candidates_page_select_wilayat";
  static const String candidatesPageSelectWilayatPlaceHolder = "candidates_page_select_wilayat_place_holder";

  static const String errorPageTitle = "error_page_title";
  static const String errorPageTechDetails = "error_page_tech_details";
  static const String errorPagePressBack = "error_page_press_back";
  
  static const String statsPageSelectWilayat = "stats_page_select_wilayat";
  static const String statsPageSelectWilayatPlaceHolder = "stats_page_select_wilayat_place_holder";
  static const String statsPageTitle = "stats_page_title";
  static const String statsPageCandSeats = "stats_page_cand_seats";
  static const String statsPageCandidates = "stats_page_candidates";
  static const String statsPageSeats = "stats_page_seats";
  static const String statsPageRegVoters = "stats_page_reg_voters";
  static const String statsPageVoterTurnout = "stats_page_voter_turnout";
  static const String statsPageMaleTurnout = "stats_page_male_turnout";
  static const String statsPageFemaleTurnout = "stats_page_female_turnout";
  static const String statsPageTotTurnout = "stats_page_tot_turnout";
  static const String statsPageTotReg = "stats_page_tot_reg";
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