class CandidateVM{
  final String? civilId;
  final String? nameEn;
  final String? nameAr;
  final String? govCode;
  final String? wilayatCode;
  final int? ballotPosition;
  int? voteCount;
  int? pollPosition;
  bool? isElected;

  CandidateVM({this.civilId, this.nameEn, this.nameAr, this.govCode, this.wilayatCode, this.ballotPosition});
}