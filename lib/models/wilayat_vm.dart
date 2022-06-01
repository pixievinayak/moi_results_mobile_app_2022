class WilayatVM{
  final String? code;
  final String? nameEn;
  final String? nameAr;
  final int? noOfSeats;
  final int? sortOrder;
  final int? regMaleVoterCount;
  final int? regFemaleVoterCount;
  final String? govCode;
  final String? govNameEn;
  final String? govNameAr;
  final int? govSortOrder;
  bool? isInitialCountingOver = false;
  bool? isFinalCountingOver = false;

  WilayatVM({this.code, this.nameEn, this.nameAr, this.noOfSeats, this.sortOrder, this.regMaleVoterCount, this.regFemaleVoterCount, this.govCode, this.govNameEn, this.govNameAr, this.govSortOrder});
}