
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../localization/localization_constants.dart';
import '../models/voter_eligibility_vm.dart';
import '../shared/global.dart';

class VoterProfile extends StatefulWidget {
  final VoterEligibilityVM? voterEligibilityVM;
  const VoterProfile({Key? key, this.voterEligibilityVM}) : super(key: key);

  @override
  _VoterProfileState createState() => _VoterProfileState();
}

class _VoterProfileState extends State<VoterProfile> {

  // VoterEligibilityVM? widget.voterEligibilityVM;
  // Map? _params = {};

  @override
  Widget build(BuildContext context) {

    // _params = _params!.isNotEmpty ? _params : ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;
    // widget.voterEligibilityVM = _params!['voter_profile_vm'];
    if(widget.voterEligibilityVM!.isRegisteredToVote!){
      if(widget.voterEligibilityVM!.hasCompletedRemoteVoting!){
        widget.voterEligibilityVM!.msgToVoter = '${Translations.vpPageCompRV.tr()}.';
      }else if(widget.voterEligibilityVM!.hasCompletedKioskVoting!){
        widget.voterEligibilityVM!.msgToVoter = '${Translations.vpPageCompKV}.';
        if(widget.voterEligibilityVM!.canShowCertificate!){
          widget.voterEligibilityVM!.msgToVoter += '\n${Translations.vpPageViewCertMsg.tr()}.';
        }
      }else{
        widget.voterEligibilityVM!.msgToVoter = '${Translations.vpPageReg.tr()}.';
      }
    }else{
      widget.voterEligibilityVM!.msgToVoter = '${Translations.vpPageNotReg.tr()}.';
    }

    return Scaffold(
        // appBar: AppBar(
        //   title: Wjts.text(context, 'Voter Profile'),
        //   centerTitle: true,
        // ),
        appBar: Wjts.appBar(context, Translations.vpPageTitle.tr(), showIcons: false),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
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
                                        Wjts.text(context, Translations.vpPageVoterEligibility.tr(), size: TextSize.xl, weight: FontWeight.bold, color: AppColours.voterProfTxtColor),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.name.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.voterName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.civilID.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.civilId!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.dob.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.dob!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.governorate.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.govName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.wilayat.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(child: Wjts.text(context, widget.voterEligibilityVM!.msgToVoter, size: TextSize.xl, weight: FontWeight.bold, color: AppColours.voterProfMsgTxtColor, align: TextAlign.center)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        !widget.voterEligibilityVM!.canShowCertificate! ? Container() :
                                        OutlinedButton(
                                          child: Wjts.text(context, Translations.vpPageViewCert.tr(), weight: FontWeight.bold, size: TextSize.l),
                                          onPressed: () async {
                                            //String certificatePath = "https://img1.wsimg.com/blobby/go/7cfa76f8-4a5b-497c-878f-e2d104424cc9/JIO%20IN%20SANDEEP%20VIHAR.pdf";
                                            await launchUrlString(widget.voterEligibilityVM!.certificatePath!);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      //SizedBox(height: 10),
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
                                        Wjts.text(context, '${Translations.vpPageVoterHist.tr()} 2011', size: TextSize.xl, weight: FontWeight.bold, color: AppColours.voterProfTxtColor),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.wilayat.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName2011!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.polStn.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.polStnName2011!)),
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
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Wjts.text(context, '${Translations.vpPageVoterHist.tr()} 2012', size: TextSize.xl, weight: FontWeight.bold, color: AppColours.voterProfTxtColor),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.wilayat.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName2012!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.polStn.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.polStnName2012!)),
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
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Wjts.text(context, '${Translations.vpPageVoterHist.tr()} 2015', size: TextSize.xl, weight: FontWeight.bold, color: AppColours.voterProfTxtColor),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.wilayat.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName2015!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.polStn.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.polStnName2015!)),
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
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Wjts.text(context, '${Translations.vpPageVoterHist.tr()} 2016', size: TextSize.xl, weight: FontWeight.bold, color: AppColours.voterProfTxtColor),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.wilayat.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName2016!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, '${Translations.polStn.tr()}: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.polStnName2016!)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
