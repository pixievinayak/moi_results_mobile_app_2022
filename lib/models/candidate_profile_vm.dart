class CandidateProfileVM{
  final String? civilId;
  final String? candidateName;
  final String? govName;
  final String? wilayatName;
  int? voteCount;
  int? pollPosition;
  bool? isElected;
  bool? isInitialCountingOver = false;
  bool? isFinalCountingOver = false;

  CandidateProfileVM({this.civilId, this.candidateName, this.govName, this.wilayatName, this.voteCount, this.pollPosition, this.isElected, this.isInitialCountingOver, this.isFinalCountingOver});
}