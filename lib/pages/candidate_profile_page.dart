import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/localization_constants.dart';
import '../models/candidate_profile_vm.dart';
import '../providers/candidate_profile_provider.dart';
import '../shared/api_manager.dart';
import '../shared/global.dart';
import '../shared/refresh_timer.dart';
import 'error_page.dart';

class CandidateProfile extends StatefulWidget {
  //final CandidateProfileVM candidateProfileVM;
  final Function onReturn;

  const CandidateProfile({Key? key, required this.onReturn})
    : super(key: key);

  @override
  _CandidateProfileState createState() => _CandidateProfileState();
}

class _CandidateProfileState extends State<CandidateProfile> with WidgetsBindingObserver {

  Function? _onReturn;
  late RefreshTimer _refreshTimer;
  final ApiManager _apiManager = ApiManager();
  final int _pageRefreshIntervalInSec = 30;
  bool _invokeOnReturn = true;
  CandidateProfileProvider? _candidatesProfileProvider;

  void _onRefresh() {
    debugPrint('onRefresh() on Candidate Profile page');
    _doRefresh(false);
  }

  void _doRefresh(bool forceRefresh) {
    debugPrint('doRefresh() on Candidate Profile Page');
    if(_candidatesProfileProvider!.getCandidate().isFinalCountingOver == false || forceRefresh){
      _getLiveCount(_candidatesProfileProvider!.getCandidate().civilId);
    }
  }

  void _getLiveCount(String? civilId) async {
    debugPrint('Getting live count for Candidate - $civilId');
    await _apiManager.callApiMethod("GetLiveCount?WilayatCode=&CivilID=$civilId")
    // .catchError((e) {
    //   debugPrint("called api GetLiveCount() and caught error: ${e.toString()}");
    //   throw(e);
    // })
    .then((resultsDataStr) {
      debugPrint('Live candidate profile data - $resultsDataStr');
      dynamic resultsDataJson = json.decode(resultsDataStr);
      String msg = resultsDataJson['msg'];
      if(msg.isNotEmpty){
        _refreshTimer.cancelRefreshTimer();
        _invokeOnReturn = false;
        // Navigator.pushReplacementNamed(context, '/error_page', arguments: {'msg': msg});
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ErrorPage(ex: null, title: msg,)));
      }else{
        CandidateProfileVM candidate = _candidatesProfileProvider!.getCandidate();
        candidate.isInitialCountingOver = resultsDataJson['is_initial_counting_over'];
        candidate.isFinalCountingOver = resultsDataJson['is_final_counting_over'];
        Iterable resultsDataIterable = resultsDataJson['candidate_data'];
        candidate.voteCount = resultsDataIterable.first['vote_count'];
        candidate.pollPosition = resultsDataIterable.first['position'];
        candidate.isElected = resultsDataIterable.first['is_elected'];
        _candidatesProfileProvider!.setCandidate(candidate);
        _checkCanShowResults();
      }
    });
    debugPrint('after calling api GetLiveCount()');
    //debugPrint('Live candidate data - $candidateLiveDataStr');
  }

  void _checkCanShowResults({bool callNotifyListeners = true}){
    if(GlobalVars.hasCountTimeStarted){
      _candidatesProfileProvider!.setCanShowResultType(true, callNotifyListeners: callNotifyListeners);
      String resultType = Translations.countNotStarted.tr();
      if(_candidatesProfileProvider!.getCandidate().isInitialCountingOver! || _candidatesProfileProvider!.getCandidate().isFinalCountingOver!){
        if(_candidatesProfileProvider!.getCandidate().isFinalCountingOver!){
          resultType = Translations.finalResults.tr();
        }else{
          resultType = Translations.initialResults.tr();
        }
        _candidatesProfileProvider!.setCanShowResults(true, callNotifyListeners: callNotifyListeners);
      }else{
        _candidatesProfileProvider!.setCanShowResults(false, callNotifyListeners: callNotifyListeners);
      }
      _candidatesProfileProvider!.setResultType(resultType, callNotifyListeners: callNotifyListeners);
    }else {
      _candidatesProfileProvider!.setCanShowResultType(false, callNotifyListeners: callNotifyListeners);
    }
    debugPrint('_checkCanShowResults() on Candidates Profile Page - ${_candidatesProfileProvider!.getCanShowResults()}');
  }

  @override
  initState() {
    _candidatesProfileProvider = Provider.of<CandidateProfileProvider>(context, listen: false);
    _onReturn = widget.onReturn;
    debugPrint('initState() on Candidate Profile Page');
    _refreshTimer = RefreshTimer("Candidate Profile Page", _onRefresh, _pageRefreshIntervalInSec);
    _refreshTimer.initRefreshTimer();
    _checkCanShowResults(callNotifyListeners: false);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    debugPrint('dispose() on Candidate Profile Page');
    _refreshTimer.cancelRefreshTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    if(_invokeOnReturn) {
      _onReturn!();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("Candidate Profile Page app in resumed");
        _refreshTimer.initRefreshTimer();
        break;
      case AppLifecycleState.inactive:
        debugPrint("Candidate Profile Page app in inactive");
        _refreshTimer.initRefreshTimer();
        break;
      case AppLifecycleState.paused:
        debugPrint("Candidate Profile Page app in paused");
        break;
      case AppLifecycleState.detached:
        debugPrint("Candidate Profile Page app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Wjts.appBar(context, Translations.candidateProfilePageTitle.tr(), showIcons: false),
        // appBar: AppBar(
        //   title: Wjts.text(context, 'Candidate Profile'),
        //   centerTitle: true,
        // ),
        body: Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  //elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.7,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        image: AssetImage('assets/images/candidates/${_candidatesProfileProvider!.getCandidate().civilId}.jpg'),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Wjts.text(context, 
                                _candidatesProfileProvider!.getCandidate().candidateName!,
                                // maxLines: 2,
                                align: TextAlign.center,
                                size: TextSize.xxl,
                                weight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wjts.text(context, 
                              '${Translations.governorate.tr()}: ',
                              size: TextSize.l,
                              weight: FontWeight.bold,
                            ),
                            Wjts.text(context, 
                              _candidatesProfileProvider!.getCandidate().govName!,
                              size: TextSize.l,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wjts.text(context, 
                              '${Translations.wilayat.tr()}: ',
                              size: TextSize.l,
                              weight: FontWeight.bold,
                            ),
                            Wjts.text(context, 
                              _candidatesProfileProvider!.getCandidate().wilayatName!,
                              size: TextSize.l,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer<CandidateProfileProvider>(
                                builder: (context, data, widget){
                                  if(data.getCanShowResultType()){
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                      child: Card(
                                          color: AppColours.candidateProfileCardBGColor,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Wjts.text(context, 
                                                    data.getResultType(),
                                                    size: 26,
                                                    weight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                              !data.getCanShowResults() ? Container() :
                                              const SizedBox(height: 10),
                                              !data.getCanShowResults() ? Container() :
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Wjts.text(context, 
                                                    '${Translations.position.tr()}: ',
                                                    size: TextSize.xl, weight: FontWeight.bold
                                                  ),
                                                  Wjts.text(context, 
                                                    data.getCandidate().pollPosition.toString(),
                                                    size: TextSize.xxl, weight: FontWeight.bold
                                                  ),
                                                ],
                                              ),
                                              !data.getCanShowResults() ? Container() :
                                              const SizedBox(height: 10),
                                              !data.getCanShowResults() ? Container() :
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Wjts.text(context, 
                                                    '${Translations.votes.tr()}: ',
                                                    size: TextSize.xl, weight: FontWeight.bold
                                                  ),
                                                  Wjts.text(context, 
                                                    data.getCandidate().voteCount.toString(),
                                                    size: TextSize.xxl, weight: FontWeight.bold
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          )
                                      ),
                                    );
                                  }else{
                                    return Container();
                                  }
                                }
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
