import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moi_results_mobile_app_2022/pages/voter_profile_page.dart';
import 'package:provider/provider.dart';

import '../localization/localization_constants.dart';
import '../models/voter_eligibility_vm.dart';
import '../providers/countdown_timer_provider.dart';
import '../providers/voter_eligibility_provider.dart';
import '../shared/api_manager.dart';
import '../shared/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {// with WidgetsBindingObserver {

  final _civilIdKey = GlobalKey<FormFieldState>();
  final _dobKey = GlobalKey<FormFieldState>();

  final _eligibilityFormKey = GlobalKey<FormState>();
  final ApiManager _apiManager = ApiManager();

  VoterEligibilityProvider? _voterEligibilityProvider;

  @override
  initState() {
    debugPrint("initState on home page called");
    _voterEligibilityProvider = Provider.of<VoterEligibilityProvider>(context, listen: false);
    super.initState();
  }

  void _getVoterEligibility(String civilID, String dob) async {
    debugPrint('Getting voter eligibility for Civil ID: $civilID, DoB: $dob');
    Map<String, dynamic>? queryParams = {
      "CivilID": civilID,
      "DoB": dob
    };
    await _apiManager.callApiMethod("GetVoterEligibility", queryParams: queryParams)
    // .catchError((e) {
    //   debugPrint("called api GetVoterEligibility() and caught error: ${e.toString()}");
    //   throw(e);
    // })
    .then((eligibilityDataStr) {
      debugPrint('Voter Eligibility Data - $eligibilityDataStr');
      dynamic eligibilityDataJson = json.decode(eligibilityDataStr);
      VoterEligibilityVM voterEligibilityVM = VoterEligibilityVM(
        civilId: eligibilityDataJson['civil_id'],
        voterName: Languages.isEnglish ? eligibilityDataJson['name_en'] : eligibilityDataJson['name_ar'],
        dob: eligibilityDataJson['dob'],
        govName: GlobalMethods.getGovNameFromCode(eligibilityDataJson['gov_code']),
        wilayatName: GlobalMethods.getWilayatNameFromCode(eligibilityDataJson['wilayat_code']),
        isRegisteredToVote: eligibilityDataJson['is_registered_to_vote'],
        hasCompletedRemoteVoting: eligibilityDataJson['has_completed_rv'],
        hasCompletedKioskVoting: eligibilityDataJson['has_completed_kv'],
        canShowCertificate: eligibilityDataJson['can_show_certificate'],
        certificatePath: eligibilityDataJson['certificate_path'],
        polStnName2011: eligibilityDataJson['voter_history']['pol_stn_2011'],
        polStnName2012: eligibilityDataJson['voter_history']['pol_stn_2012'],
        polStnName2015: eligibilityDataJson['voter_history']['pol_stn_2015'],
        polStnName2016: eligibilityDataJson['voter_history']['pol_stn_2016']
      );

      voterEligibilityVM.wilayatName2011 = GlobalMethods.getWilayatNameFromCode(eligibilityDataJson['voter_history']['wilayat_code_2011']);
      voterEligibilityVM.wilayatName2012 = GlobalMethods.getWilayatNameFromCode(eligibilityDataJson['voter_history']['wilayat_code_2012']);
      voterEligibilityVM.wilayatName2015 = GlobalMethods.getWilayatNameFromCode(eligibilityDataJson['voter_history']['wilayat_code_2015']);
      voterEligibilityVM.wilayatName2016 = GlobalMethods.getWilayatNameFromCode(eligibilityDataJson['voter_history']['wilayat_code_2016']);

      // Navigator.pushNamed(context, '/voter_profile', arguments: {'voter_profile_vm': voterEligibilityVM});
      Navigator.push(context, MaterialPageRoute(builder: (context) => VoterProfile(voterEligibilityVM: voterEligibilityVM)));
    });
    // debugPrint('after calling api GetVoterEligibility()');
  }

  Future<void> _selectDoB(BuildContext context) async {
    DateTime? currentDoB = _voterEligibilityProvider!.getDoB();
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDoB ?? DateTime.now().subtract(const Duration(days: (365*18))),
        firstDate: DateTime(1915),
        lastDate: DateTime(DateTime.now().year-17));
    if (pickedDate != null && pickedDate != currentDoB){
      _voterEligibilityProvider!.setDoB(pickedDate);
      FocusScope.of(context).requestFocus(FocusNode());
      Future.delayed(const Duration(milliseconds: 100), () {
        _dobKey.currentState!.validate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('======= build on home page =========');
    return Scaffold(
      appBar: Wjts.appBar(context, Translations.homePageTitle.tr()),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Wjts.text(context, Translations.homePageCountdownTitle.tr(), size: TextSize.xl, weight: FontWeight.bold),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Selector<CountdownTimerProvider, String>(
                                  builder: (context, value, child){
                                    if(value.contains(':')){
                                      String days = value.split(':')[0];
                                      String hours = value.split(':')[1];
                                      String min = value.split(':')[2];
                                      String sec = value.split(':')[3];
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Wjts.text(context, days, size: TextSize.xxl, weight: FontWeight.bold),
                                          const SizedBox(width: 3),
                                          Wjts.text(context, days == '1' ? Translations.day.tr() : Translations.days.tr(), weight: FontWeight.bold),
                                          const SizedBox(width: 7),
                                          Wjts.text(context, hours, size: TextSize.xxl, weight: FontWeight.bold),
                                          const SizedBox(width: 3),
                                          Wjts.text(context, hours == '1' ? Translations.hour.tr() : Translations.hours.tr(), weight: FontWeight.bold),
                                          const SizedBox(width: 7),
                                          Wjts.text(context, min, size: TextSize.xxl, weight: FontWeight.bold),
                                          const SizedBox(width: 3),
                                          Wjts.text(context, min == '1' ? Translations.min.tr() : Translations.mins.tr(), weight: FontWeight.bold),
                                          const SizedBox(width: 7),
                                          Wjts.text(context, sec, size: TextSize.xxl, weight: FontWeight.bold),
                                          const SizedBox(width: 3),
                                          Wjts.text(context, sec == '1' ? Translations.sec.tr() : Translations.secs.tr(), weight: FontWeight.bold),
                                        ],
                                      );
                                    }else{
                                      return Wjts.text(context, value,
                                          size: TextSize.xxl,
                                          weight: FontWeight.bold
                                      );
                                    }
                                  },
                                  selector: (buildContext, model) => model.getRemainingTimeAsStr(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Form(
                          key: _eligibilityFormKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Wjts.text(context, Translations.homePageChkEligibilityTitle.tr(), size: TextSize.xl, weight: FontWeight.bold),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 5,
                                    child: Image(
                                      image: AssetImage('assets/images/eligibility_1.png'),
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                          child: TextFormField(
                                            key: _civilIdKey,
                                            validator: (val) => val!.isEmpty ? Translations.civilIDValMsg.tr() : null,
                                            onChanged: (val) {
                                              _voterEligibilityProvider!.setCivilId(val);
                                              _civilIdKey.currentState!.validate();
                                            },
                                            decoration: InputDecoration(
                                              labelText: Translations.civilID.tr(),
                                              hintText: Translations.civilID.tr(),
                                              isDense: true,
                                              contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: AppColours.white, width: 1),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: AppColours.votElgbtyTbBordColor, width: 1),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                          ),
                                        ),
                                        //SizedBox(height: 5,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              //flex: 8,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Consumer<VoterEligibilityProvider>(
                                                  builder: (context, data, child){
                                                    return TextFormField(
                                                      key: _dobKey,
                                                      onTap: () => _selectDoB(context),
                                                      validator: (val) => val!.isEmpty ? Translations.dobValMsg.tr() : null,
                                                      readOnly: true,
                                                      //enabled: false,
                                                      controller: TextEditingController(
                                                        text: data.getDoBString(),
                                                      ),
                                                      decoration: InputDecoration(
                                                        labelText: Translations.dob.tr(),
                                                        hintText: Translations.dob.tr(),
                                                        isDense: true,
                                                        contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: AppColours.white, width: 1),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: AppColours.votElgbtyTbBordColor, width: 1),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                ),
                                              )
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                              child: OutlinedButton(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                                  child: Wjts.text(context, Translations.homePageChkEligibility.tr(), weight: FontWeight.bold, size: TextSize.l),
                                                ),
                                                onPressed: (){
                                                  // _countdownTimerProvider!.updateRemainingTime('hello world! - ${_counter++}');
                                                  if (_eligibilityFormKey.currentState!.validate()) {
                                                    debugPrint("Civil ID: ${_voterEligibilityProvider!.getCivilID()}, DoB: ${_voterEligibilityProvider!.getDoBString()}");
                                                    _getVoterEligibility(_voterEligibilityProvider!.getCivilID(), _voterEligibilityProvider!.getDoBString());
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}