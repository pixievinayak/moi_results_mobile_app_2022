import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../localization/localization_constants.dart';
import '../models/candidate_vm.dart';
import '../models/polling_station_vm.dart';
import '../models/wilayat_vm.dart';
import 'simple_select/common.dart';
import 'simple_select/simple_select.dart';

class GlobalVars{

  //use when on emulator on laptop
  //static String mobileApiURL = "https://10.0.2.2/moi_results_web_api_2020/api/MoI";

  //use when on emulator on laptop when web api is in debug mode
  //static String mobileApiURL = "https://10.0.2.2:44359/api/MoI";

  //use when on phone/emulator in iipl office
  static String mobileApiURL = "https://10.10.7.139/moi_results_web_api_2020/api/MoI";

  //use when on phone/emulator in sandeep vihar
  // static String mobileApiURL = "https://192.168.1.101/moi_results_web_api_2020/api/MoI";

  //use when on phone/emulator in Aquamarine
  //static String mobileApiURL = "https://192.168.0.118/moi_results_web_api_2020/api/MoI";

  static String? registeredWilayatCode = "";
  static List<OptionItem> optionsDataWilayatsEn = [];
  static List<OptionItem> optionsDataWilayatsAr = [];
  static late Dio dio;
  static DateTime countStartTime = DateTime(2022, 5, 20, 0, 0, 0);
  static late DateTime currentOmanTime;
  static bool hasCountTimeStarted = false;
  static bool hasDataLoadingErrorOccurred = false;
  static late List<WilayatVM> wilayats;
  static late List<PollingStationVM> pollingStations;
  static late List<CandidateVM> candidates;

  static int? wilayatsDataVersion = 0;
  static int? polStnsDataVersion = 0;
  static int? candidatesDataVersion = 0;

// static User user = User();
}

class TextSize{
  static const double cardHeader = 20;
  static const double msgRegular = 20;
  static const double msgLarge = 26;
  static const double regular = 14;
  static const double large = 18;
  static const double small = 12;
  static const double counter = 40;
}

class Wjts{
  static Text text(String text, {double size = 14, Color? color = Colors.black54, FontWeight weight = FontWeight.normal, TextAlign align = TextAlign.start}){
    return Text(text,
      textAlign: align,
      style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight
      ),
    );
  }

  static SimpleSelect wilayatSelect(BuildContext context, {String? selectedValue, required Function onChangeHandler, required bool showOptionForAllWilayats, String placeHolder = ''}){
    List<OptionItem> options = (Languages.currentLanguageName == Languages.enLangName) ? GlobalVars.optionsDataWilayatsEn : GlobalVars.optionsDataWilayatsAr;
    if(!showOptionForAllWilayats){
      options = options.where((o) => o.value != "0").toList();
    }
    if([null, ''].contains(placeHolder)){
      placeHolder = Translations.genericSelectWilayatPlaceHolder.tr();
    }
    return SimpleSelect(context, options,
      onChange: onChangeHandler as void Function(String?)?,
      selectedValue: selectedValue,
      isGrouped: true,
      placeHolder: placeHolder,
      optionsPageTitle: Translations.genericSelectWilayat.tr(),
    );
  }

  static InputDecoration tbDeco(BuildContext context){
    return const InputDecoration(
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2),
      ),
    );
  }
}

class GlobalMethods{

  static bool isNullOrEmpty(String? str){
    return [null, ''].contains(str);
  }

  static String? getWilayatNameFromCode(String? wilayatCode){
    String? wilayatName = wilayatCode != '-' ? Languages.isEnglish ? GlobalVars.wilayats.firstWhere((w) => w.code == wilayatCode).nameEn : GlobalVars.wilayats.firstWhere((w) => w.code == wilayatCode).nameAr : '-';
    return wilayatName;
  }

  static String? getGovNameFromCode(String? govCode){
    String? govName = govCode != '-' ? Languages.isEnglish ? GlobalVars.wilayats.firstWhere((w) => w.govCode == govCode).govNameEn : GlobalVars.wilayats.firstWhere((w) => w.govCode == govCode).govNameAr : '-';
    return govName;
  }

  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds~/Duration.secondsPerDay;
    seconds -= days*Duration.secondsPerDay;
    final hours = seconds~/Duration.secondsPerHour;
    seconds -= hours*Duration.secondsPerHour;
    final minutes = seconds~/Duration.secondsPerMinute;
    seconds -= minutes*Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0){
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }
}

class StorageKeys{
  static const String regWilayatCode = "reg_wilayat_code";
  static const String langCode = "language_code";
  static const String langCountry = "language_country";
  static const String wilayatDataKey = "wilayat_data";
  static const String polStnDataKey = "pol_stn_data";
  static const String candidatesDataKey = "candidates_data";
}