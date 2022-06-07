import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/localization_constants.dart';
import '../models/candidate_profile_vm.dart';
import '../models/candidate_vm.dart';
import '../models/wilayat_vm.dart';
import '../providers/candidate_profile_provider.dart';
import '../providers/candidates_list_provider.dart';
import '../providers/wilayat_select_provider.dart';
import '../shared/api_manager.dart';
import '../shared/global.dart';
import '../shared/refresh_timer.dart';
import 'candidate_profile_page.dart';

class CandidatesPage extends StatefulWidget {
  const CandidatesPage({Key? key}) : super(key: key);

  @override
  _CandidatesPageState createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> with WidgetsBindingObserver {

  late RefreshTimer _refreshTimer;
  final ApiManager _apiManager = ApiManager();
  final int _pageRefreshIntervalInSec = 120;
  WilayatSelectProvider? _wilayatSelectProvider;
  CandidatesListProvider? _candidatesListProvider;

  void onReturnFromProfile(){
    debugPrint('candidates page - after return from profile');
    _refreshTimer.initRefreshTimer();
  }

  void _showCandidateProfile(String? civilId){
    CandidateVM candidateVM = _candidatesListProvider!.getCandidates().firstWhere((candidate) => candidate.civilId == civilId);
    WilayatVM _selectedWilayat = _candidatesListProvider!.getWilayat()!;
    CandidateProfileVM candidateProfileVM = CandidateProfileVM(
        civilId: civilId,
        candidateName: Languages.isEnglish ? candidateVM.nameEn : candidateVM.nameAr,
        govName: Languages.isEnglish ? _selectedWilayat.govNameEn : _selectedWilayat.govNameAr,
        wilayatName: Languages.isEnglish ? _selectedWilayat.nameEn : _selectedWilayat.nameAr,
        voteCount: candidateVM.voteCount,
        pollPosition: candidateVM.pollPosition,
        isElected: candidateVM.isElected,
        isInitialCountingOver: _selectedWilayat.isInitialCountingOver,
        isFinalCountingOver: _selectedWilayat.isFinalCountingOver
    );
    debugPrint('candidates page - b4 showing profile');
    _refreshTimer.cancelRefreshTimer();
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
      ChangeNotifierProvider(
        create: (context) => CandidateProfileProvider(candidate: candidateProfileVM),
        child: CandidateProfile(onReturn: onReturnFromProfile)
      )
    ));
  }

  Future<void> _onForceRefresh() async {
    debugPrint('onForceRefresh() on candidate list page');
    _doRefresh(true);
  }

  void _onRefresh() {
    debugPrint('onRefresh() on candidate list page');
    _doRefresh(false);
  }

  void _doRefresh(bool forceRefresh) {
    debugPrint('doRefresh() on candidate list page');
    if(!_candidatesListProvider!.isSelectedWilayatNull() && (_candidatesListProvider!.getWilayat()!.isFinalCountingOver == false || forceRefresh)){
      _getLiveCount(_candidatesListProvider!.getWilayatCode());
    }
  }

  void _getLiveCount(String? wilayatCode) async {
    debugPrint('Getting live count for Wilayat Code - $wilayatCode');
    await _apiManager.callApiMethod("GetLiveCount?WilayatCode=$wilayatCode&CivilID")
    // .catchError((e) {
    //   debugPrint("called api GetLiveCount() and caught error: ${e.toString()}");
    //   throw(e);
    // })
    .then((resultsDataStr) {
      debugPrint('Live candidate data - $resultsDataStr');
      dynamic resultsDataJson = json.decode(resultsDataStr);
      _candidatesListProvider!.getWilayat()!.isInitialCountingOver = resultsDataJson['is_initial_counting_over'];
      _candidatesListProvider!.getWilayat()!.isFinalCountingOver = resultsDataJson['is_final_counting_over'];
      Iterable resultsDataIterable = resultsDataJson['candidate_data'];
      CandidateVM candidateVM;
      for (var resultDataItem in resultsDataIterable) {
        candidateVM = _candidatesListProvider!.getCandidates().firstWhere((candidate) => candidate.civilId == resultDataItem['candidate_civil_id']);
        candidateVM.voteCount = resultDataItem['vote_count'];
        candidateVM.pollPosition = resultDataItem['position'];
        candidateVM.isElected = resultDataItem['is_elected'];
      }
      _checkCanShowResults();
    });
    debugPrint('after calling api GetLiveCount()');
    //debugPrint('Live candidate data - $candidateLiveDataStr');
  }

  void _checkCanShowResults(){
    //if(GlobalVars.hasCountTimeStarted && _candidatesListProvider!.getWilayat() != null && (_candidatesListProvider!.getWilayat()!.isInitialCountingOver! || _candidatesListProvider!.getWilayat()!.isFinalCountingOver!)){
    if(GlobalVars.hasCountTimeStarted && _candidatesListProvider!.getWilayat() != null){
      _candidatesListProvider!.setCanShowResultType(true);
      String resultType = "Counting not yet started";
      if(_candidatesListProvider!.getWilayat()!.isInitialCountingOver! || _candidatesListProvider!.getWilayat()!.isFinalCountingOver!){
        _candidatesListProvider!.sortCandidatesByPollPosition();
        if(_candidatesListProvider!.getWilayat()!.isFinalCountingOver!){
          resultType = "Final Results";
        }else{
          resultType = "Initial Results";
        }
        _candidatesListProvider!.setCanShowResults(true);
      }else{
        _candidatesListProvider!.setCanShowResults(false);
      }
      _candidatesListProvider!.setResultType(resultType);
    }else {
      _candidatesListProvider!.setCanShowResultType(false);
    }
    debugPrint('_checkCanShowResults() on candidates page - ${_candidatesListProvider!.getCanShowResults()}');
  }

  void _onWilayatChange(String? wilayatCode){
    if(wilayatCode != _candidatesListProvider!.getWilayatCode()) {
      _candidatesListProvider!.setWilayat(wilayatCode);
      _onRefresh();
      _checkCanShowResults();
    }
  }

  @override
  initState() {
    _wilayatSelectProvider = Provider.of<WilayatSelectProvider>(context, listen: false);
    _candidatesListProvider = Provider.of<CandidatesListProvider>(context, listen: false);
    _refreshTimer = RefreshTimer("Candidate List Page", _onRefresh, _pageRefreshIntervalInSec);
    _refreshTimer.initRefreshTimer();
    //String? selectedWilayatCode = [null, ''].contains(GlobalVars.registeredWilayatCode) ? "0" : GlobalVars.registeredWilayatCode;
    _candidatesListProvider!.setWilayat(GlobalVars.registeredWilayatCode, callNotifyListeners: false);
    if(GlobalVars.hasCountTimeStarted){
      _doRefresh(false);
    }
    debugPrint('initState() on candidate list page');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("candidate list page app in resumed");
        _refreshTimer.initRefreshTimer();
        break;
      case AppLifecycleState.inactive:
        debugPrint("candidate list page app in inactive");
        _refreshTimer.initRefreshTimer();
        break;
      case AppLifecycleState.paused:
        debugPrint("candidate list page app in paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("candidate list page app in detached");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _refreshTimer.cancelRefreshTimer();
    debugPrint('dispose() on candidate list page');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build() on candidate list page');
    return Scaffold(
      appBar: Wjts.appBar(context, 'Candidates'),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Consumer<CandidatesListProvider>(
                        builder: (context, data, child) {
                          if(data.getCanShowResultType()){
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Wjts.text(context, data.getResultType(), size: TextSize.l, weight: FontWeight.bold),
                            );
                          }else{
                            return Container();
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Wjts.wilayatSelect(context, selectedValue: _wilayatSelectProvider!.getSelectedWilayatCode(), onChangeHandler: _onWilayatChange, showOptionForAllWilayats: false),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Consumer<CandidatesListProvider>(
            builder: (context, data, child){
              if(data.isSelectedWilayatNull()){
                return Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: Colors.grey[200],
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: Wjts.text(context, "Please select a Wilayat to view the candidates", size: 18),
                            )
                        ),
                      ),
                    ),
                  ],
                );
              }else{
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onForceRefresh,
                    child: Consumer<CandidatesListProvider>(
                        builder: (context, data, child){
                          return ListView.builder(
                            itemCount: data.getCandidates().length,
                            itemBuilder: (context, index){
                              CandidateVM candidate = data.getCandidates().elementAt(index);
                              return Card(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  leading: Image(
                                    image: AssetImage('assets/images/candidates/${candidate.civilId}.jpg'),
                                  ),
                                  title: Wjts.text(context, Languages.isEnglish ? candidate.nameEn! : candidate.nameAr!),
                                  subtitle: data.getCanShowResults() ? RichText(
                                      text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: candidate.pollPosition.toString(), style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 20)),
                                            TextSpan(text: ', ', style: TextStyle(color: Colors.grey[800])),
                                            TextSpan(text: 'Votes - ${candidate.voteCount.toString()}', style: TextStyle(color: Colors.green[800])),
                                          ]
                                      )
                                  ) : Container(),
                                  onTap: () => _showCandidateProfile(candidate.civilId),
                                  // isThreeLine: true,
                                ),
                              );
                            },
                          );
                        }
                    ),
                  ),
                );
              }
            }
          ),
        ],
      )
    );
  }
}
