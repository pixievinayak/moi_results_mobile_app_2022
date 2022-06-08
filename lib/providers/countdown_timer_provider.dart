import 'dart:async';

import 'package:flutter/foundation.dart';

import '../shared/global.dart';

class CountdownTimerProvider with ChangeNotifier{
  Timer? _timerToResults;
  String _remainingTimeAsStr = '-';

  String getRemainingTimeAsStr(){
    // debugPrint('============ remaining time in get: $_remainingTimeAsStr');
    return _remainingTimeAsStr;
  }
  void setRemainingTimeAsString(String value){
    // debugPrint('============ remaining time: $value');
    _remainingTimeAsStr = value;
    // debugPrint('============ remaining time in set: $_remainingTimeAsStr');
    notifyListeners();
  }

  initCountdownTimer() {
    if(_timerToResults == null || !_timerToResults!.isActive){
      debugPrint('============ Countdown Timer Initiated ============');
      _timerToResults = Timer.periodic(const Duration(seconds: 1), (timer) {
        if(GlobalVars.currentOmanTime.isAfter(GlobalVars.countStartTime) || GlobalVars.currentOmanTime.isAtSameMomentAs(GlobalVars.countStartTime)){
          GlobalVars.hasCountTimeStarted = true;
          _timerToResults!.cancel();
          setRemainingTimeAsString("Counting process started!");
        }else{
          GlobalVars.currentOmanTime = GlobalVars.currentOmanTime.add(const Duration(seconds: 1));
          setRemainingTimeAsString(GlobalMethods.formatDuration(GlobalVars.countStartTime.difference(GlobalVars.currentOmanTime)));//.replaceAll(':', ' '));
        }
      });
    }
  }
}