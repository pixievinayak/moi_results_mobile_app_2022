import 'package:flutter/foundation.dart';

class SelectedOptionsProvider extends ChangeNotifier{
  String? _selectedValue;
  List<String>? _selectedValues;

  SelectedOptionsProvider({String? selectedValue = '', List<String>? selectedValues = const []})
    : _selectedValue = selectedValue,
      _selectedValues = selectedValues;

  String? getSelectedValue() => _selectedValue;
  setSelectedValue(String? selectedValue){
    _selectedValue = selectedValue;
    notifyListeners();
  }

  List<String>? getSelectedValues() => _selectedValues;
  setSelectedValues(List<String>? selectedValues){
    _selectedValues = selectedValues;
    notifyListeners();
  }
  addToSelectedValues(String value){
    _selectedValues!.add(value);
    notifyListeners();
  }
  removeFromSelectedValues(String value){
    _selectedValues!.remove(value);
    notifyListeners();
  }
}