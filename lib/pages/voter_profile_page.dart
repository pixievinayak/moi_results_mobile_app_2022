
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/voter_eligibility_vm.dart';
import '../shared/global.dart';

class VoterProfile extends StatefulWidget {
  const VoterProfile({Key? key}) : super(key: key);

  @override
  _VoterProfileState createState() => _VoterProfileState();
}

class _VoterProfileState extends State<VoterProfile> {

  VoterEligibilityVM? _voterEligibilityVM;
  Map? _params = {};

  @override
  Widget build(BuildContext context) {

    _params = _params!.isNotEmpty ? _params : ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;
    _voterEligibilityVM = _params!['voter_profile_vm'];
    if(_voterEligibilityVM!.isRegisteredToVote!){
      if(_voterEligibilityVM!.hasCompletedRemoteVoting!){
        _voterEligibilityVM!.msgToVoter = 'You have successfully completed remote voting.';
      }else if(_voterEligibilityVM!.hasCompletedKioskVoting!){
        _voterEligibilityVM!.msgToVoter = 'You have successfully completed kiosk voting.';
        if(_voterEligibilityVM!.canShowCertificate!){
          _voterEligibilityVM!.msgToVoter += '\nClick on the button below to view your participation certificate.';
        }
      }else{
        _voterEligibilityVM!.msgToVoter = 'You are a registered voter.';
      }
    }else{
      _voterEligibilityVM!.msgToVoter = 'You have not registered for voting.';
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Voter Profile'),
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
                                        Wjts.text('Voter Eligibility', size: TextSize.cardHeader, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Name: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.voterName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Civil ID: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.civilId!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Date of Birth: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.dob!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Governorate: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.govName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.wilayatName!)),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(child: Wjts.text(_voterEligibilityVM!.msgToVoter, size: TextSize.msgRegular, weight: FontWeight.bold, color: Colors.blue[800], align: TextAlign.center)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        !_voterEligibilityVM!.canShowCertificate! ? Container() :
                                        OutlinedButton(
                                          child: Text('View Certificate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800]),),
                                          onPressed: () async {
                                            //String certificatePath = "https://img1.wsimg.com/blobby/go/7cfa76f8-4a5b-497c-878f-e2d104424cc9/JIO%20IN%20SANDEEP%20VIHAR.pdf";
                                            await launchUrlString(_voterEligibilityVM!.certificatePath!);
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
                                        Wjts.text('Voter History 2011', size: TextSize.cardHeader, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.wilayatName2011!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Polling Station: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.polStnName2011!)),
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
                                        Wjts.text('Voter History 2012', size: TextSize.cardHeader, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.wilayatName2012!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Polling Station: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.polStnName2012!)),
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
                                        Wjts.text('Voter History 2015', size: TextSize.cardHeader, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.wilayatName2015!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Polling Station: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.polStnName2015!)),
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
                                        Wjts.text('Voter History 2016', size: TextSize.cardHeader, weight: FontWeight.bold, color: Colors.grey[600]),
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Wilayat: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.wilayatName2016!)),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(flex: 3, child: Wjts.text('Polling Station: ')),
                                        Expanded(flex: 7, child: Wjts.text(_voterEligibilityVM!.polStnName2016!)),
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
