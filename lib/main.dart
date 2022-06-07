import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization/localization_constants.dart';
import 'pages/bottom_nav_bar_page.dart';
import 'pages/splash_screen_page.dart';
import 'providers/app_start_provider.dart';
import 'providers/bottom_nav_bar_provider.dart';
import 'providers/countdown_timer_provider.dart';
import 'shared/global.dart';

// this is from the RnD branch
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale(Languages.enLangCode, Languages.enLangCountryIndia),
          Locale(Languages.arLangCode, Languages.arLangCountryOman)
        ],
        path: 'assets/lang', // <-- change the path of the translation files
        fallbackLocale: const Locale(Languages.enLangCode, Languages.enLangCountryIndia),
        child: const MyApp()
        // child: ChangeNotifierProvider(
        //   create: (context) => AppStartProvider(),
        //   child: MyApp()
        // )
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      Languages.currentLanguageName = locale.languageCode == Languages.enLangCode ? Languages.enLangName : Languages.arLangName;
    });
    debugPrint("didChangeDependencies was called");
    super.didChangeDependencies();
  }

  @override
  initState() {
    debugPrint("initState on main called");
    // _appStartProvider = Provider.of<AppStartProvider>(context, listen: false);
    // _appStartProvider!.doPreLoadActivities();
    // debugPrint("after calling doPreLoadActivities()");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build on main.dart called");

    return MaterialApp(
      theme: ThemeData(
        fontFamily: FontNames.tajawal,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/',
      routes: {
        // '/': (context) => ChangeNotifierProvider(
        //   create: (context) => AuthProvider(),
        //   child: Wrapper(),
        // ),
        '/': (context) => ChangeNotifierProvider(
          create: (context) => AppStartProvider(),
          child: const SplashScreen(),
        ),
        '/main_app': (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => BottomNavBarProvider(initialIndex: 2),
            ),
            ChangeNotifierProvider(
              create: (context) => CountdownTimerProvider(),
            )
          ],
          child: const BottomNavBarPage()
        ),
        // '/error_page': (context) => const ErrorPage(),
        // '/voter_profile': (context) => const VoterProfile(),
      },
    );

    // return Consumer<AppStartProvider>(
    //     builder: (context, data, child){
    //       return mainApp;
    //
    //       // debugPrint("1) Is data loaded: ${data.getIsDataLoaded()}, is there an error: ${data.getIsError()}");
    //       // if(data.getIsError()){ //if there is an error, showing the error page
    //       //   debugPrint("2) Is data loaded: ${data.getIsDataLoaded()}, is there an error: ${data.getIsError()}");
    //       //   return MaterialApp(home: ErrorPage(ex: data.getException()));
    //       // }else if(data.getIsDataLoaded()){ //if data is loaded, showing the app
    //       //   debugPrint("3) Is data loaded: ${data.getIsDataLoaded()}, is there an error: ${data.getIsError()}");
    //       //   return mainApp;
    //       // }else{ //otherwise, showing the loading screen
    //       //   debugPrint("4) Is data loaded: ${data.getIsDataLoaded()}, is there an error: ${data.getIsError()}");
    //       //   return SplashScreen();
    //       // }
    //     }
    // );
  }

}

