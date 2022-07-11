import 'package:permission_handler/permission_handler.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/localization_constants.dart';
import '../providers/bottom_nav_bar_provider.dart';
import '../providers/countdown_timer_provider.dart';
import '../providers/voter_eligibility_provider.dart';
import '../providers/wilayat_select_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/pol_stn_map_provider.dart';
import '../providers/candidates_list_provider.dart';
import '../shared/global.dart';
import 'candidates_page.dart';
import 'home_page.dart';
import 'map_page_json.dart';
import 'settings_page.dart';
import 'stats_page.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({Key? key}) : super(key: key);

  @override
  _BottomNavBarPageState createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {

  CountdownTimerProvider? _countdownTimerProvider;

  static final List<Widget> _tabPages = <Widget>[
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => WilayatSelectProvider(selectedWilayatCode: GlobalVars.registeredWilayatCode),
          ),
          ChangeNotifierProvider(
            create: (context) => CandidatesListProvider(candidates: GlobalVars.candidates, wilayats: GlobalVars.wilayats),
          )
        ],
        child: const CandidatesPage()
    ),
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => WilayatSelectProvider(selectedWilayatCode: GlobalVars.registeredWilayatCode),
          ),
          ChangeNotifierProvider(
            create: (context) => PollingStationMapProvider(pollingStations: GlobalVars.pollingStations, wilayats: GlobalVars.wilayats, isEnglish: Languages.isEnglish),
          )
        ],
        child: const MapPageJSON()
    ),
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context) => CountdownTimerProvider(),
        // ),
        ChangeNotifierProvider(
          create: (context) => VoterEligibilityProvider(),
        )
      ],
      child: const HomePage()
    ),
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => WilayatSelectProvider(selectedWilayatCode: GlobalVars.registeredWilayatCode),
          ),
          ChangeNotifierProvider(
            create: (context) => StatsProvider(candidates: GlobalVars.candidates),
          )
        ],
        child: const StatsPage()
    ),
    // StatsPage(),
    const SettingsPage()
  ];

  _requestPermissions() async {
    await Permission.location.request();
  }

  @override
  initState() {
    _countdownTimerProvider = Provider.of<CountdownTimerProvider>(context, listen: false);
    _requestPermissions();
    debugPrint("initState on bottomNavBar page called");
    //_initTimerToResults();
    _countdownTimerProvider!.initCountdownTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: _tabPages[_selectedIndex],
      body: Consumer<BottomNavBarProvider>(
         builder: (context, data, child){
           return _tabPages[data.getCurrentIndex()];
           // return ChangeNotifierProvider(
           //     create: (context) => CountdownTimerProvider(),
           //     child: StatsPage()
           // );
         }
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColours.navBarBtnColor,
        backgroundColor: AppColours.white,
        buttonBackgroundColor: AppColours.navBarBtnColor,
        height: 50,
        animationDuration: const Duration( milliseconds: 400 ),
        index: 2,
        //animationCurve: Curves.bounceInOut,
        items: const <Widget>[
          Icon(CupertinoIcons.person_3_fill, size: 30,),
          Icon(CupertinoIcons.map_fill, size: 30,),
          Icon(CupertinoIcons.home, size: 30,),
          Icon(CupertinoIcons.chart_pie_fill, size: 30,),
          Icon(CupertinoIcons.settings, size: 30,),
        ],
        onTap: (index){
          BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context, listen: false);
          bottomNavBarProvider.setCurrentIndex(index);
          debugPrint("Current tab index is $index");
        },
      ),
    );
  }
}
