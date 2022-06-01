class VoterEligibilityVM{
  final String? civilId;
  final String? voterName;
  final String? dob;
  final String? govName;
  final String? wilayatName;
  final bool? isRegisteredToVote;
  final bool? hasCompletedRemoteVoting;
  final bool? hasCompletedKioskVoting;
  final bool? canShowCertificate;
  final String? certificatePath;
  final String? polStnName2011;
  final String? polStnName2012;
  final String? polStnName2015;
  final String? polStnName2016;

  String? wilayatName2011;
  String? wilayatName2012;
  String? wilayatName2015;
  String? wilayatName2016;

  late String msgToVoter;

  VoterEligibilityVM({
    this.civilId,
    this.voterName,
    this.dob,
    this.govName,
    this.wilayatName,
    this.isRegisteredToVote,
    this.hasCompletedRemoteVoting,
    this.hasCompletedKioskVoting,
    this.canShowCertificate,
    this.certificatePath,
    this.polStnName2011,
    this.polStnName2012,
    this.polStnName2015,
    this.polStnName2016
  });
}