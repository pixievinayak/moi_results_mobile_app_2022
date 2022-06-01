import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

class VoterEligibilityProvider extends ChangeNotifier{
  String _civilId;
  DateTime? _dob;
  final _dateFormat = new DateFormat('dd/MM/yyyy');

  VoterEligibilityProvider({String civilID = '', DateTime? dob})
    : this._civilId = civilID,
      this._dob = dob;

  String getCivilID() => _civilId;
  setCivilId(String value){
    _civilId = value;
    notifyListeners();
  }

  String getDoBString() => _dob == null ? '' : _dateFormat.format(_dob!);
  DateTime? getDoB() => _dob;
  setDoB(DateTime value){
    _dob = value;
    notifyListeners();
  }
}