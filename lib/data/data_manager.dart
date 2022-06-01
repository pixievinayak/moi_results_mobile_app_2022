import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/candidate_vm.dart';
import '../models/polling_station_vm.dart';
import '../models/wilayat_vm.dart';
import '../shared/api_manager.dart';
import '../shared/global.dart';
import '../shared/simple_select/common.dart';
// import 'package:smart_select/smart_select.dart';

class DataManager {
  static Future<void> load() async {
    //bool retVal = true;

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    //-----------------------------------
    // loading data from storage or file
    //-----------------------------------
    //check if wilayat data is persisted and if not loading it from file
    String? wilayatDataString = _prefs.getString(StorageKeys.wilayatDataKey);
    wilayatDataString = wilayatDataString ?? await rootBundle.loadString('assets/data/wilayats.json');
    //convert to json object
    dynamic wilayatDataJson = json.decode(wilayatDataString);
    GlobalVars.wilayatsDataVersion = wilayatDataJson['version'];

    //check if wilayat data is persisted
    String? polStnDataString = _prefs.getString(StorageKeys.polStnDataKey);
    polStnDataString = polStnDataString ?? await rootBundle.loadString('assets/data/pol_stns.json');
    //convert to json object
    dynamic polStnDataJson = json.decode(polStnDataString);
    GlobalVars.polStnsDataVersion = polStnDataJson['version'];

    //check if wilayat data is persisted
    String? candidateDataString = _prefs.getString(StorageKeys.candidatesDataKey);
    candidateDataString = candidateDataString ?? await rootBundle.loadString('assets/data/candidates.json');
    //convert to json object
    dynamic candidateDataJson = json.decode(candidateDataString);
    GlobalVars.candidatesDataVersion = candidateDataJson['version'];

    //-------------------------------------------------
    // checking if updated data is available on server
    //-------------------------------------------------
    ApiManager apiManager = ApiManager();
    await apiManager.callApiMethod("GetUpdatedData?WilayatDataVersion=${GlobalVars.wilayatsDataVersion}&PollingStnDataVersion=${GlobalVars.polStnsDataVersion}&CandidatesDataVersion=${GlobalVars.candidatesDataVersion}", receiveTimeoutInSec: 20)
    .then((updatedDataStr) {
      var updatedDataJson = json.decode(updatedDataStr);
      debugPrint("Updated data from server: $updatedDataJson");
      //GlobalVars.countStartTime = new DateFormat('yyyy-MM-dd HH:mm:ss').parse(updatedDataJson['date_of_election_str']);

      //storing the wilayat data in local storage if it is newer
      if(updatedDataJson['wilayat_data_version'] > GlobalVars.wilayatsDataVersion){
        debugPrint("Received updated Wilayat data");
        GlobalVars.wilayatsDataVersion = updatedDataJson['wilayat_data_version'];
        wilayatDataString = updatedDataJson['wilayat_data'];
        wilayatDataJson = json.decode(wilayatDataString!);
        _prefs.setString(StorageKeys.wilayatDataKey, wilayatDataString!);
      }

      //storing the polling stn data in local storage if it is newer
      if(updatedDataJson['pollingStn_data_version'] > GlobalVars.polStnsDataVersion){
        debugPrint("Received updated Polling Stn data");
        GlobalVars.polStnsDataVersion = updatedDataJson['pollingStn_data_version'];
        polStnDataString = updatedDataJson['polling_stn_data'];
        polStnDataJson = json.decode(polStnDataString!);
        _prefs.setString(StorageKeys.polStnDataKey, polStnDataString!);
      }

      //storing the candidates data in local storage if it is newer
      if(updatedDataJson['candidates_data_version'] > GlobalVars.polStnsDataVersion){
        debugPrint("Received updated Candidate data");
        GlobalVars.candidatesDataVersion = updatedDataJson['candidates_data_version'];
        candidateDataString = updatedDataJson['candidate_data'];
        candidateDataJson = json.decode(candidateDataString!);
        _prefs.setString(StorageKeys.candidatesDataKey, candidateDataString!);
      }
    });

    //---------------------------------
    // loading wilayat data for select
    //---------------------------------
    debugPrint("wilayat version: ${GlobalVars.wilayatsDataVersion}");
    Iterable wilayatsIterable = wilayatDataJson['wilayats'];
    debugPrint("no of wilayats: ${wilayatsIterable.length}");
    GlobalVars.wilayats = wilayatsIterable
        .map((wilayat) => WilayatVM(
              code: wilayat['code'],
              govCode: wilayat['gov_code'],
              govNameAr: wilayat['gov_name_ar'],
              govNameEn: wilayat['gov_name_en'],
              govSortOrder: int.parse(wilayat['gov_sort_order']),
              nameAr: wilayat['name_ar'],
              nameEn: wilayat['name_en'],
              noOfSeats: int.parse(wilayat['no_of_seats']),
              regFemaleVoterCount: int.parse(wilayat['reg_female_voter_count']),
              regMaleVoterCount: int.parse(wilayat['reg_male_voter_count']),
              sortOrder: int.parse(wilayat['sort_order'])
            ))
        .toList();

    GlobalVars.optionsDataWilayatsEn = GlobalVars.wilayats
        .map((wilayat) => OptionItem(
            wilayat.code,
            wilayat.nameEn,
            sortOrder: wilayat.sortOrder,
            groupSortOrder: wilayat.govSortOrder,
            groupValue: wilayat.govCode,
            groupDisplay: wilayat.govNameEn))
        .toList();

    GlobalVars.optionsDataWilayatsAr = GlobalVars.wilayats
        .map((wilayat) => OptionItem(
        wilayat.code,
        wilayat.nameAr,
        sortOrder: wilayat.sortOrder,
        groupSortOrder: wilayat.govSortOrder,
        groupValue: wilayat.govCode,
        groupDisplay: wilayat.govNameAr))
        .toList();

    //-----------------------------------------
    // loading polling stn json data into list
    //-----------------------------------------
    debugPrint("pol stn version: ${GlobalVars.polStnsDataVersion}");
    Iterable polStationsIterable = polStnDataJson['pol_stns'];
    debugPrint("no of pol stns: ${polStationsIterable.length}");
    GlobalVars.pollingStations = polStationsIterable
        .map((polStn) => PollingStationVM(
            id: int.parse(polStn['id']),
            nameAr: polStn['name_ar'],
            nameEn: polStn['name_en'],
            isUnified: polStn['is_uni'] == "1" ? true : false,
            lat: double.parse(polStn['lat']),
            lng: double.parse(polStn['lng']),
            wilayatCode: polStn['wil_code']))
        .toList();

    //---------------------------------------
    // loading candidates json data into list
    //---------------------------------------
    debugPrint("candidate version: ${GlobalVars.candidatesDataVersion}");
    Iterable candidatesIterable = candidateDataJson['candidates'];
    debugPrint("no of candidates: ${candidatesIterable.length}");
    GlobalVars.candidates = candidatesIterable
        .map((candidate) => CandidateVM(
            nameEn: candidate['name_en'],
            nameAr: candidate['name_ar'],
            govCode: candidate['gov_code'],
            ballotPosition: int.parse(candidate['ballot_pos']),
            civilId: candidate['civil_id'],
            wilayatCode: candidate['wil_code']))
        .toList();

    //---------------------------------
    // getting the current Oman time
    //---------------------------------
    //String temp = await _waitForAWhile();
    await apiManager.callApiMethod("GetCurrentTime")
    // .catchError((e) {
    //   debugPrint("called api GetCurrentTime() and caught error: ${e.toString()}");
    //   //retVal = false;
    //   throw (e);
    // })
    .then((serverTimeStr) {
      debugPrint("Server time is $serverTimeStr");
      GlobalVars.currentOmanTime = DateFormat("MMM dd, yyyy HH:mm:ss").parse(serverTimeStr);
      if (GlobalVars.currentOmanTime.isAfter(GlobalVars.countStartTime) || GlobalVars.currentOmanTime.isAtSameMomentAs(GlobalVars.countStartTime)) {
        GlobalVars.hasCountTimeStarted = true;
      }

      //---------------------------------
      // loading registered wilayat code
      //---------------------------------
      GlobalVars.registeredWilayatCode = _prefs.getString(StorageKeys.regWilayatCode);
    });

    //return retVal;
  }
}
