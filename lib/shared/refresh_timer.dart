import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'global.dart';

class RefreshTimer{
  Timer? _refreshTimer;
  final String pageName;
  final Function refreshCallback;
  final int intervalInSec;

  RefreshTimer(this.pageName, this.refreshCallback, this.intervalInSec);

  void initRefreshTimer() {
    if ((_refreshTimer == null || !_refreshTimer!.isActive) && GlobalVars.hasCountTimeStarted) {
      debugPrint("========== Initiating RefreshTimer for $pageName");
      _refreshTimer = Timer.periodic(Duration(seconds: intervalInSec), (Timer t) {
        DateTime now = DateTime.now();
        String _timeOfRefresh = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
        debugPrint('RefreshTimer for $pageName - $_timeOfRefresh');
        refreshCallback();
      });
    }else{
      debugPrint('RefreshTimer for $pageName - NOT ACTIVE');
    }
  }

  void cancelRefreshTimer() {
    if (_refreshTimer != null) {
      debugPrint("Cancelling RefreshTimer for $pageName");
      _refreshTimer!.cancel();
    }
  }
}