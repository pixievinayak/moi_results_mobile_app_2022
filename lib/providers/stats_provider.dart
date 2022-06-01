import 'package:flutter/foundation.dart';

import '../models/candidate_vm.dart';
import '../models/wilayat_vm.dart';

class StatsProvider extends ChangeNotifier{
  List<CandidateVM> _candidates;
  WilayatVM? _wilayat;
  int _noOfSeats = 0, _noOfCandidates = 0;
  int _totRegCnt = 0, _maleRegCnt = 0, _femaleRegCnt = 0;
  int _maleVotedCnt = 0, _femaleVotedCnt = 0;//, _totVotedCnt = 0;

  int _pieTouchedIndex = -1;
  int _barTouchedIndex = -1;

  StatsProvider({WilayatVM? wilayat, required List<CandidateVM> candidates})
      : _wilayat = wilayat,
        _candidates = candidates;

  setWilayat(WilayatVM? wilayat, {bool callNotifyListeners = true}){
    _wilayat = wilayat;
    _noOfCandidates = _candidates.where((c) => (c.wilayatCode == _wilayat!.code || _wilayat!.code == "0") && !c.civilId!.startsWith('NOTA')).length;
    _noOfSeats = _wilayat!.noOfSeats!;
    _maleRegCnt = _wilayat!.regMaleVoterCount!;
    _femaleRegCnt = _wilayat!.regFemaleVoterCount!;
    _totRegCnt = _maleRegCnt + _femaleRegCnt;
    if(callNotifyListeners){
      notifyListeners();
    }
  }

  int getNoOfSeats() => _noOfSeats;
  int getNoOfCandidates() => _noOfCandidates;

  int getMaleRegVoterCount() => _maleRegCnt;
  int getFemaleRegVoterCount() => _femaleRegCnt;
  int getTotalRegVoterCount() => _totRegCnt;

  int getMaleVotedCount() => _maleVotedCnt;
  void setMaleVotedCount(int value){
    _maleVotedCnt = value;
    notifyListeners();
  }

  int getFemaleVotedCount() => _femaleVotedCnt;
  void setFemaleVotedCount(int value){
    _femaleVotedCnt = value;
    notifyListeners();
  }

  int getTotalVotedCount() => _maleVotedCnt + _femaleVotedCnt;

  int getPieTouchIndex() => _pieTouchedIndex;
  void setPieTouchIndex(int value){
    debugPrint('pie touch index: $value');
    if(value != _pieTouchedIndex){
      _pieTouchedIndex = value;
      notifyListeners();
    }
  }

  int getBarTouchIndex() => _barTouchedIndex;
  void setBarTouchIndex(int value){
    if(value != _barTouchedIndex){
      _barTouchedIndex = value;
      notifyListeners();
    }
  }
}