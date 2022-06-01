import 'package:flutter/foundation.dart';

import '../models/candidate_profile_vm.dart';

class CandidateProfileProvider extends ChangeNotifier{
  CandidateProfileVM _candidate;
  bool _canShowResults = false;
  bool _canShowResultType = false;
  String _resultType = '';

  CandidateProfileProvider({required CandidateProfileVM candidate})
    : _candidate = candidate;

  CandidateProfileVM getCandidate() => _candidate;
  void setCandidate(CandidateProfileVM value){
    _candidate = value;
    notifyListeners();
  }

  String getResultType() => _resultType;
  void setResultType(String value, {bool callNotifyListeners = true}){
    _resultType = value;
    if(callNotifyListeners){
      notifyListeners();
    }
  }

  bool getCanShowResults() => _canShowResults;
  void setCanShowResults(bool value, {bool callNotifyListeners = true}){
    _canShowResults = value;
    if(callNotifyListeners){
      notifyListeners();
    }
  }

  bool getCanShowResultType() => _canShowResultType;
  void setCanShowResultType(bool value, {bool callNotifyListeners = true}){
    _canShowResultType = value;
    if(callNotifyListeners){
      notifyListeners();
    }
  }
}