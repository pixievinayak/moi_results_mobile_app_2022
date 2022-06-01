import 'package:flutter/foundation.dart';

import '../models/candidate_vm.dart';
import '../models/wilayat_vm.dart';
import '../shared/global.dart';

class CandidatesListProvider extends ChangeNotifier{
  List<CandidateVM> _allCandidates;
  List<CandidateVM> _filteredCandidates = [];
  List<WilayatVM> _wilayats;
  // bool _isEnglish;
  WilayatVM? _wilayat;
  bool _canShowResults = false;
  bool _canShowResultType = false;
  String _resultType = '';

  CandidatesListProvider({required List<CandidateVM> candidates, required List<WilayatVM> wilayats})//, required bool isEnglish})
    : _allCandidates = candidates,
        _wilayats = wilayats;//,
      // _isEnglish = isEnglish;

  setWilayat(String? wilayatCode, {bool callNotifyListeners = true}){
    _wilayat = GlobalMethods.isNullOrEmpty(wilayatCode) ? null : _wilayats.firstWhere((wilayat) => wilayat.code == wilayatCode);
    _filteredCandidates = GlobalMethods.isNullOrEmpty(wilayatCode) ? [] : _allCandidates.where((candidate) => candidate.wilayatCode == wilayatCode).toList();
    if(callNotifyListeners){
      notifyListeners();
    }
  }

  bool isSelectedWilayatNull() => _wilayat == null;

  WilayatVM? getWilayat() => _wilayat;
  String? getWilayatCode() => _wilayat == null ? null : _wilayat!.code;

  List<CandidateVM> getCandidates() => _filteredCandidates;

  void sortCandidatesByPollPosition(){
    _filteredCandidates.sort((a, b) => a.pollPosition!.compareTo(b.pollPosition!));
    notifyListeners();
  }

  void sortCandidatesByBallotPosition(){
    _filteredCandidates.sort((a, b) => a.ballotPosition!.compareTo(b.ballotPosition!));
    notifyListeners();
  }

  String getResultType() => _resultType;
  void setResultType(String value){
    _resultType = value;
    notifyListeners();
  }

  bool getCanShowResults() => _canShowResults;
  void setCanShowResults(bool value){
    _canShowResults = value;
    notifyListeners();
  }

  bool getCanShowResultType() => _canShowResultType;
  void setCanShowResultType(bool value){
    _canShowResultType = value;
    notifyListeners();
  }
}