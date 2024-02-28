import 'dart:io';

//import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../data/data_manager.dart';
import '../shared/global.dart';

class AppStartProvider with ChangeNotifier{

  bool _isDataLoaded = false;
  bool _isError = false;
  dynamic _exception;

  doPreLoadActivities() {

    GlobalVars.dio = Dio();
    GlobalVars.dio.options.headers['who'] = 'MoIAuthorizedApp';
    GlobalVars.dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          return true; // Verify the certificate.
        };
        return client;
      },
    );
    // (GlobalVars.dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
    //   client.badCertificateCallback=(X509Certificate cert, String host, int port){
    //     return true;
    //   };
    //   return null;
    // };

    //load data fpr app
    DataManager.load()
    .then((value) {
      debugPrint("after calling DataManager.load()");
      _isDataLoaded = true;
      notifyListeners();
    }, onError: (error){
      _exception = error;
      _isError = true;
      notifyListeners();
    });
  }

  bool getIsDataLoaded() => _isDataLoaded;
  bool getIsError() => _isError;
  dynamic getException() => _exception;
}