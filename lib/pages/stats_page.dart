import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:moi_results_mobile_app_2022/localization/localization_constants.dart';
import 'package:provider/provider.dart';

import '../providers/stats_provider.dart';
import '../providers/wilayat_select_provider.dart';
import '../shared/api_manager.dart';
import '../shared/global.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  final ApiManager _apiManager = ApiManager();
  final numberFormatter = NumberFormat("#,###");
  WilayatSelectProvider? _wilayatSelectProvider;
  StatsProvider? _statsProvider;

  void _setSelectedWilayatObj(String? wilayatCode, {bool callNotifyListeners = true}){
    _statsProvider!.setWilayat(GlobalVars.wilayats.firstWhere((wilayat) => wilayat.code == wilayatCode), callNotifyListeners: callNotifyListeners);
  }

  void _getTurnoutStats(String? wilayatCode) async {
    debugPrint('Getting turnout stats for Wilayat Code - $wilayatCode');
    await _apiManager.callApiMethod("GetElectionTurnoutStats?WilayatCode=$wilayatCode")
    // .catchError((e) {
    //   debugPrint("called api GetElectionTurnoutStats() and caught error: ${e.toString()}");
    //   throw(e);
    // })
    .then((turnoutDataStr) {
      debugPrint('Turnout Stats data - $turnoutDataStr');
      dynamic turnoutDataJson = json.decode(turnoutDataStr);
      _statsProvider!.setMaleVotedCount(turnoutDataJson['turnout_count_male']);
      _statsProvider!.setFemaleVotedCount(turnoutDataJson['turnout_count_female']);
    });
    debugPrint('after calling api GetElectionTurnoutStats()');
  }

  void _checkCanGetStats(){
    if(GlobalVars.hasCountTimeStarted){
      _getTurnoutStats(_wilayatSelectProvider!.getSelectedWilayatCode());
    }
    debugPrint('_checkCanGetStats() on Stats Page');
  }

  void _onWilayatChange(String? wilayatCode){
    if(wilayatCode != _wilayatSelectProvider!.getSelectedWilayatCode()) {
      _wilayatSelectProvider!.setSelectedWilayatCode(wilayatCode!);
      _setSelectedWilayatObj(wilayatCode);
      _checkCanGetStats();
    }
  }

  @override
  initState() {
    _wilayatSelectProvider = Provider.of<WilayatSelectProvider>(context, listen: false);
    _statsProvider = Provider.of<StatsProvider>(context, listen: false);
    String? selectedWilayatCode = [null, ''].contains(GlobalVars.registeredWilayatCode) ? "0" : GlobalVars.registeredWilayatCode;
    _setSelectedWilayatObj(selectedWilayatCode, callNotifyListeners: false);
    _checkCanGetStats();
    debugPrint('initState() on Stats Page');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build() on Stats Page');
    return Scaffold(
      appBar: AppBar(
        title: Wjts.text(context, Translations.statsPageTitle.tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Wjts.wilayatSelect(context, selectedValue: GlobalMethods.isNullOrEmpty(_wilayatSelectProvider!.getSelectedWilayatCode()) ? '0' : _wilayatSelectProvider!.getSelectedWilayatCode(), onChangeHandler: _onWilayatChange, showOptionForAllWilayats: true),
                          )
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Wjts.text(context, Translations.statsPageCandSeats.tr(), size: TextSize.l, weight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container()
                      ),
                      Expanded(
                        flex: 4,
                        child: Selector<StatsProvider, int>(
                          builder: (context, value, child){
                            debugPrint('======= seats counter updated ========');
                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: value.toString(), style: TextStyle(color: AppColours.statsSeatColor, fontWeight: FontWeight.bold, fontSize: 40)),
                                    TextSpan(text: '\n${Translations.statsPageSeats.tr()}', style: TextStyle(color: AppColours.statsCounterColor, fontWeight: FontWeight.normal, fontSize: 14)),
                                  ]
                              ),
                            );
                          },
                          selector: (buildContext, model) => model.getNoOfSeats(),
                        )
                      ),
                      Expanded(
                          flex: 4,
                          child: Consumer<StatsProvider>(
                            builder: (context, data, child){
                              debugPrint('======= candidates counter updated ========');
                              return RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: data.getNoOfCandidates().toString(), style: TextStyle(color: AppColours.statsCounterColor, fontWeight: FontWeight.bold, fontSize: 40)),
                                    TextSpan(text: '\n${Translations.statsPageCandidates.tr()}', style: TextStyle(color: AppColours.statsCounterColor, fontWeight: FontWeight.normal, fontSize: 14)),
                                  ]
                                )
                              );
                            }
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: Container()
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,)
                ],
              ),
            ),
            Card(
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Wjts.text(context, Translations.statsPageRegVoters.tr(), size: TextSize.l, weight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: 260,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Consumer<StatsProvider>(
                              builder: (context, data, child){
                                debugPrint('======= pie-chart updated ========');
                                return PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                                        if(pieTouchResponse != null){
                                          final desiredTouch = event is! PointerExitEvent && event is! PointerUpEvent;
                                          if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                            data.setPieTouchIndex(pieTouchResponse.touchedSection!.touchedSectionIndex);
                                          } else {
                                            data.setPieTouchIndex(-1);
                                          }
                                        }
                                      }),
                                      // pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                      //   final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                      //       pieTouchResponse.touchInput is! PointerUpEvent;
                                      //   if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                      //     data.setPieTouchIndex(pieTouchResponse.touchedSection!.touchedSectionIndex);
                                      //   } else {
                                      //     data.setPieTouchIndex(-1);
                                      //   }
                                      // }),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 0,
                                      sections: List.generate(2, (i) {
                                        final isTouched = i == data.getPieTouchIndex();
                                        final double fontSize = isTouched ? 21 : 18;
                                        final double radius = isTouched ? 110 : 100;
                                        switch (i) {
                                          case 0:
                                            return PieChartSectionData(
                                              color: AppColours.statsMaleColor,
                                              value: data.getMaleRegVoterCount().toDouble(),
                                              title: '${((data.getMaleRegVoterCount()/data.getTotalRegVoterCount())*100).toStringAsFixed(2)}% - ${Translations.male.tr()}',
                                              radius: radius,
                                              titleStyle: TextStyle(
                                                  fontSize: fontSize, fontWeight: FontWeight.normal, color: AppColours.white),
                                            );
                                          case 1:
                                            return PieChartSectionData(
                                              color: AppColours.statsFemaleColor,
                                              value: data.getFemaleRegVoterCount().toDouble(),
                                              title: '${((data.getFemaleRegVoterCount()/data.getTotalRegVoterCount())*100).toStringAsFixed(2)}% - ${Translations.female.tr()}',
                                              radius: radius,
                                              titleStyle: TextStyle(
                                                  fontSize: fontSize, fontWeight: FontWeight.normal, color: AppColours.white),
                                            );
                                          default:
                                            return PieChartSectionData();
                                        }
                                      })
                                  ),
                                  // swapAnimationDuration: Duration(milliseconds: 300), // Optional
                                  // swapAnimationCurve: Curves.linear,
                                );
                              }
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                    child: Wjts.text(context, Translations.statsPageVoterTurnout.tr(), size: TextSize.l, weight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer<StatsProvider>(
                          builder: (context, data, child){
                            debugPrint('======= bar-chart updated ========');
                            return BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: data.getTotalRegVoterCount().toDouble(),
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: AppColours.transparent,
                                    tooltipPadding: const EdgeInsets.all(0),
                                    tooltipMargin: 5,
                                    getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex){
                                      bool isTouched = groupIndex == data.getBarTouchIndex() && groupIndex != 3;
                                      double votedPct = 0;

                                      if(groupIndex == 0){ //calculating female voted pct
                                        votedPct = (rod.toY / data.getTotalVotedCount()) * 100;
                                      }else if(groupIndex == 1){ //calculating male voted pct
                                        votedPct = (rod.toY / data.getTotalVotedCount()) * 100;
                                      }else if(groupIndex == 2){ //calculating for total voted pct
                                        votedPct = (rod.toY / data.getTotalRegVoterCount()) * 100;
                                      }

                                      BarTooltipItem retVal =  BarTooltipItem(
                                        numberFormatter.format(rod.toY.round()),
                                        TextStyle(
                                          color: AppColours.statsToolTipTxtColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: <TextSpan>[
                                          isTouched ? TextSpan(
                                            text: '\n${votedPct.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              color: AppColours.statsToolTipTxtColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ) : const TextSpan(text: '',),
                                        ],
                                      );
                                      return retVal;
                                    },
                                  ),
                                  touchCallback: (FlTouchEvent event, BarTouchResponse? barTouchResponse) {
                                    if(barTouchResponse != null){
                                      if (barTouchResponse.spot != null &&
                                          event is! PointerUpEvent &&
                                          event is! PointerExitEvent) {
                                        data.setBarTouchIndex(barTouchResponse.spot!.touchedBarGroupIndex);
                                      } else {
                                        data.setBarTouchIndex(-1);
                                      }
                                    }
                                  },
                                  // touchCallback: (barTouchResponse) {
                                  //   if (barTouchResponse.spot != null &&
                                  //       barTouchResponse.touchInput is! PointerUpEvent &&
                                  //       barTouchResponse.touchInput is! PointerExitEvent) {
                                  //     data.setBarTouchIndex(barTouchResponse.spot!.touchedBarGroupIndex);
                                  //   } else {
                                  //     data.setBarTouchIndex(-1);
                                  //   }
                                  // },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: (double value, TitleMeta meta){
                                        String text = '';
                                        switch (value.toInt()) {
                                          case 0:
                                            text = Translations.statsPageFemaleTurnout.tr();
                                            break;
                                          case 1:
                                            text = Translations.statsPageMaleTurnout.tr();
                                            break;
                                          case 2:
                                            text = Translations.statsPageTotTurnout.tr();
                                            break;
                                          case 3:
                                            text = Translations.statsPageTotReg.tr();
                                            break;
                                          default:
                                            text = '';
                                        }
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          space: 4.0,
                                          child: Wjts.text(context, text, color: AppColours.statsColChrtTxtColor, weight: FontWeight.normal, size: TextSize.s),
                                        );
                                      },
                                    )
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)
                                  ),
                                  topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: [
                                  BarChartGroupData(
                                    x: 0,
                                    barRods: [
                                      BarChartRodData(toY: data.getFemaleVotedCount().toDouble(), gradient: LinearGradient(colors: [AppColours.statsFemaleColor, AppColours.statsColChrtFemaleGradColor]), width: 20)
                                    ],
                                    showingTooltipIndicators: [0],
                                  ),
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(toY: data.getMaleVotedCount().toDouble(), gradient: LinearGradient(colors: [AppColours.statsMaleColor, AppColours.statsColChrtMaleGradColor]), width: 20)
                                    ],
                                    showingTooltipIndicators: [0],
                                  ),
                                  BarChartGroupData(
                                    x: 2,
                                    barRods: [
                                      BarChartRodData(toY: data.getTotalVotedCount().toDouble(), gradient: LinearGradient(colors: [AppColours.statsColChrtTurnoutColor, AppColours.statsColChrtTurnoutGradColor]), width: 20)
                                    ],
                                    showingTooltipIndicators: [0],
                                  ),
                                  BarChartGroupData(
                                    x: 3,
                                    barRods: [
                                      BarChartRodData(toY: data.getTotalRegVoterCount().toDouble(), gradient: LinearGradient(colors: [AppColours.statsColChrtRegColor, AppColours.statsColChrtRegGradColor]), width: 20)
                                    ],
                                    showingTooltipIndicators: [0],
                                  ),
                                ],
                              ),
                              swapAnimationCurve: Curves.linear,
                              swapAnimationDuration: const Duration(milliseconds: 600),
                            );
                          }
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
