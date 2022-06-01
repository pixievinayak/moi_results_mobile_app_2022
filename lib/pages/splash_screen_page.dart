import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/app_start_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AppStartProvider? _appStartProvider;

  void _listenToAppStartProvider(){
    debugPrint("========== listen called ================");
    debugPrint("1) Is data loaded: ${_appStartProvider!.getIsDataLoaded()}, is there an error: ${_appStartProvider!.getIsError()}");
    if(_appStartProvider!.getIsError()){ //if there is an error, showing the error page
      debugPrint("2) Is data loaded: ${_appStartProvider!.getIsDataLoaded()}, is there an error: ${_appStartProvider!.getIsError()}");
      Navigator.pushReplacementNamed(context, '/error_page', arguments: {'msg': _appStartProvider!.getException().toString()});
    }else if(_appStartProvider!.getIsDataLoaded()){ //if data is loaded, showing the app
      debugPrint("3) Is data loaded: ${_appStartProvider!.getIsDataLoaded()}, is there an error: ${_appStartProvider!.getIsError()}");
      Navigator.pushReplacementNamed(context, '/main_app');
    }
  }

  @override
  void initState() {
    _appStartProvider = Provider.of<AppStartProvider>(context, listen: false);
    _appStartProvider!.doPreLoadActivities();
    _appStartProvider!.addListener(_listenToAppStartProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SpinKitSquareCircle(
            color: Colors.blueGrey,
            size: 50,
          ),
        ),
      ),
    );
  }
}