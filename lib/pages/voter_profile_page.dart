
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
        widget.voterEligibilityVM!.msgToVoter = 'You have successfully completed remote voting.';
      }else if(widget.voterEligibilityVM!.hasCompletedKioskVoting!){
        widget.voterEligibilityVM!.msgToVoter = 'You have successfully completed kiosk voting.';
        if(widget.voterEligibilityVM!.canShowCertificate!){
          widget.voterEligibilityVM!.msgToVoter += '\nClick on the button below to view your participation certificate.';
        }
      }else{
        widget.voterEligibilityVM!.msgToVoter = 'You are a registered voter.';
      }
    }else{
      widget.voterEligibilityVM!.msgToVoter = 'You have not registered for voting.';
    }

    return Scaffold(
        appBar: AppBar(
          title: Wjts.text(context, 'Voter Profile'),
          centerTitle: true,
        ),
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
                                        Wjts.text(context, 'Voter Eligibility', size: TextSize.xl, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Name: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.voterName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Civil ID: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.civilId!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Date of Birth: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.dob!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Governorate: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.govName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(child: Wjts.text(context, widget.voterEligibilityVM!.msgToVoter, size: TextSize.xl, weight: FontWeight.bold, color: Colors.blue[800], align: TextAlign.center)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        !widget.voterEligibilityVM!.canShowCertificate! ? Container() :
                                        OutlinedButton(
                                          child: Wjts.text(context, 'View Certificate', weight: FontWeight.bold, size: TextSize.l),
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
                                        Wjts.text(context, 'Voter History 2011', size: TextSize.xl, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName2011!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Polling Station: ')),
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
                                        Wjts.text(context, 'Voter History 2012', size: TextSize.xl, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName2012!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Polling Station: ')),
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
                                        Wjts.text(context, 'Voter History 2015', size: TextSize.xl, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName2015!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Polling Station: ')),
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
                                        Wjts.text(context, 'Voter History 2016', size: TextSize.xl, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(context, widget.voterEligibilityVM!.wilayatName2016!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text(context, 'Polling Station: ')),
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
