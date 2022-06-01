import 'package:flutter/foundation.dart';

class WilayatSelectProvider extends ChangeNotifier {
  String? _selectedWilayatCode;

  WilayatSelectProvider({required String? selectedWilayatCode})
    : _selectedWilayatCode = selectedWilayatCode;

  String? getSelectedWilayatCode() => _selectedWilayatCode;
  setSelectedWilayatCode(String value){
    _selectedWilayatCode = value;
    notifyListeners();
  }
}