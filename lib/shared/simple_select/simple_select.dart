import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'options_page.dart';
import 'common.dart';
import 'providers/selected_options_provider.dart';

class SimpleSelect extends StatefulWidget {

  final BuildContext context;
  final String? selectedValue;
  final ValueChanged<String?>? onChange;
  final List<OptionItem> options;
  final bool isGrouped;
  final String? placeHolder;
  final String optionsPageTitle;

  final bool isMultiSelect;
  final List<String> selectedValues;
  final ValueChanged<List<String>?>? onMultiChange;

  SimpleSelect(this.context, this.options, {
    this.onChange,
    this.selectedValue,
    this.isGrouped = false,
    this.placeHolder = 'Select an option',
    this.optionsPageTitle = 'Options',
    this.isMultiSelect = false,
    this.selectedValues = const [],
    this.onMultiChange,
  });

  @override
  _SimpleSelectState createState() => _SimpleSelectState();
}

class _SimpleSelectState extends State<SimpleSelect> {

  String? _selectedValue = '';
  List<String>? _selectedValues = [];
  TextEditingController? _txtCtlrDispVal;

  String? _getDisplayValueForSelectedValue(String? selectedValue){
    debugPrint('_getDisplayValueForSelectedValue() called: $selectedValue');
    //return GlobalVars.wilayats.firstWhere((w) => w.code == selectedValue).nameEn;
    return widget.options.firstWhere((o) => o.value == selectedValue).display;
  }

  String _getDisplayValueForSelectedValues(List<String> selectedValues){
    debugPrint('_getDisplayValueForSelectedValues() called: $selectedValues');
    //return GlobalVars.wilayats.firstWhere((w) => w.code == selectedValue).nameEn;
    return widget.options.where((o) => selectedValues.contains(o.value)).map((o) => o.display).join(', ');
  }

  void _setSelectedValue(String? selectedValue){
    debugPrint('_setSelectedValue() called, selectedValue = $selectedValue');
    String dispVal = ['', null].contains(selectedValue) ? widget.placeHolder! : _getDisplayValueForSelectedValue(selectedValue)!;
    debugPrint('_setSelectedValue() called, dispVal = $dispVal');
    _txtCtlrDispVal!.text = dispVal;
  }

  void _setSelectedValues(List<String> selectedValues){
    debugPrint('_setSelectedValues() called, selectedValues = $selectedValues');
    String dispVal = selectedValues.length == 0 ? widget.placeHolder! : _getDisplayValueForSelectedValues(selectedValues);
    debugPrint('_setSelectedValue() called, dispVal = $dispVal');
    _txtCtlrDispVal!.text = dispVal;
  }

  void _showOptions() async {
    debugPrint('_showOptions() called.');
    dynamic resp = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
      ChangeNotifierProvider(
        create: (context) => SelectedOptionsProvider(selectedValue: _selectedValue, selectedValues: _selectedValues),
        child: SelectOptionsPage(
            _selectedValue,
            widget.options,
            widget.isGrouped,
            widget.optionsPageTitle,
            widget.isMultiSelect,
            _selectedValues
        )
      )
    ));
    if(resp != null){
      if(widget.isMultiSelect){
        _selectedValues = resp['selectedValues'];
        _setSelectedValues(_selectedValues!);
        widget.onMultiChange!(_selectedValues);
      }else{
        _selectedValue = resp['selectedValue'];
        _setSelectedValue(_selectedValue);
        widget.onChange!(_selectedValue);
      }
    }
  }

  @override
  void initState() {
    debugPrint('initState() called.');
    _selectedValue = widget.selectedValue;
    _selectedValues = widget.selectedValues;
    super.initState();
  }

  @override
  void dispose() {
    _txtCtlrDispVal!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build() called in options select');
    _txtCtlrDispVal = TextEditingController(text: _selectedValue == null || _selectedValue!.length == 0 ? widget.placeHolder : _getDisplayValueForSelectedValue(_selectedValue));
    return InkWell(
      child: Row(
        children: [
          Expanded(flex: 8,
            child: TextFormField(
              readOnly: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _txtCtlrDispVal,
              style: TextStyle(color: Colors.black54, fontSize: 18),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(1, 20, 10, 0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
              ),
              onTap: (){
                _showOptions();
              },
            )
          ),
          Expanded(flex: 2, child: Icon((Directionality.of(context) == TextDirection.rtl) ? CupertinoIcons.chevron_left :  CupertinoIcons.chevron_right, size: 18, color: Colors.black45,)),
        ],
      ),
      onTap: (){
        _showOptions();
      },
    );
  }
}

