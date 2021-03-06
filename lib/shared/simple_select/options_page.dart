import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import 'common.dart';
import 'providers/selected_options_provider.dart';

class SelectOptionsPage extends StatefulWidget {

  final String? selectedValue;
  final List<OptionItem>? options;
  final bool isGrouped;
  final String optionsPageTitle;
  final bool isMultiSelect;
  final List<String>? selectedValues;

  const SelectOptionsPage(this.selectedValue, this.options, this.isGrouped, this.optionsPageTitle, this.isMultiSelect, this.selectedValues, {Key? key}) : super(key: key);

  @override
  _SelectOptionsPageState createState() => _SelectOptionsPageState();
}

class _SelectOptionsPageState extends State<SelectOptionsPage> {

  SelectedOptionsProvider? _selectedOptionsProvider;

  _clearSelected(){
    if(widget.isMultiSelect){
      _selectedOptionsProvider!.setSelectedValues([]);
    }else{
      _selectedOptionsProvider!.setSelectedValue('');
      _confirmSelected();
    }
  }

  _confirmSelected(){
    var retVal = widget.isMultiSelect ?
      { 'selectedValues': _selectedOptionsProvider!.getSelectedValues() } :
      { 'selectedValue': _selectedOptionsProvider!.getSelectedValue() };
    Navigator.pop(context, retVal);
  }

  // _confirmOptions(List<String>? selectedValues){
  //   Navigator.pop(context, {
  //     'selectedValues': selectedValues,
  //   });
  // }
  //
  // _confirmOption(String? selectedValue){
  //   Navigator.pop(context, {
  //     'selectedValue': selectedValue,
  //   });
  // }

  ListTile _getItemListTile(OptionItem item){
    return ListTile(
      onTap: (){
        _selectedOptionsProvider!.setSelectedValue(item.value);
        _confirmSelected();
      },
      title: Row(
        children: [
          const SizedBox(width: 10),
          Wjts.text(context, item.display!, size: TextSize.l),
        ],
      ),
      trailing: widget.isMultiSelect ?
      Consumer<SelectedOptionsProvider>(
          builder: (context, data, child){
            return Checkbox(
                value: data.getSelectedValues()!.contains(item.value),
                // groupValue: _selectedValue,
                onChanged: (bool? value) {
                  debugPrint('checkbox onChanged() called: value = $value');
                  value! ? data.addToSelectedValues(item.value!) : data.removeFromSelectedValues(item.value!);
                }
            );
          }
      ) :
      Radio(
        value: item.value,
        groupValue: _selectedOptionsProvider!.getSelectedValue(),
        onChanged: (dynamic value) {
          debugPrint('radio onChanged() called: value = $value');
          _selectedOptionsProvider!.setSelectedValue(value);
          _confirmSelected();
        },
      )
      // Consumer<SelectedOptionsProvider>(
      //     builder: (context, data, child){
      //       return Radio(
      //         value: item.value,
      //         groupValue: data.getSelectedValue(),
      //         onChanged: (dynamic? value) {
      //           debugPrint('radio onChanged() called: value = $value');
      //           _confirmOption(value);
      //         },
      //       );
      //     }
      // ),
    );
  }

  SliverStickyHeader _getHeaderItems(String groupDisplay, List<OptionItem> optionsInGroup){
    return SliverStickyHeader(
      header: Container(
        height: 60.0,
        color: Colors.grey[100],
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(flex: 8, child: Wjts.text(context, groupDisplay, size: TextSize.l, weight: FontWeight.bold)),
            Expanded(flex: 2, child: Wjts.text(context, optionsInGroup.length.toString(), size: TextSize.l, align: TextAlign.end)),
          ],
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, i) =>
            _getItemListTile(optionsInGroup.elementAt(i)),
          childCount: optionsInGroup.length,
        ),
      ),
    );
  }

  List<SliverStickyHeader> _getHeaderList(){
    List<SliverStickyHeader> _optionHeaders = [];
    String? groupValue = '';
    List<OptionItem> optionsInGroup;
    for (var option in widget.options!) {
      if(groupValue != option.groupValue){
        groupValue = option.groupValue;
        optionsInGroup = widget.options!.where((o) => o.groupValue == groupValue).toList();
        _optionHeaders.add(_getHeaderItems(option.groupDisplay!, optionsInGroup));
      }
    }
    return _optionHeaders;
  }

  SliverList _getFlatList(){
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) =>
          _getItemListTile(widget.options!.elementAt(i)),
        childCount: widget.options!.length,
      ),
    );
  }

  @override
  void initState() {
    _selectedOptionsProvider = Provider.of<SelectedOptionsProvider>(context, listen: false);
    //widget.isMultiSelect ? context.read<SelectedOptionsProvider>().setSelectedValues(widget.selectedValues) : context.read<SelectedOptionsProvider>().setSelectedValue(widget.selectedValue);
    //widget.isMultiSelect ? _selectedOptionsProvider!.setSelectedValues(widget.selectedValues) : _selectedOptionsProvider!.setSelectedValue(widget.selectedValue);
    // Future.delayed(const Duration(milliseconds: 10), () {
    //   _selectedOptionsProvider = Provider.of<SelectedOptionsProvider>(context, listen: false);
    //   widget.isMultiSelect ? _selectedOptionsProvider!.setSelectedValues(widget.selectedValues) : _selectedOptionsProvider!.setSelectedValue(widget.selectedValue);
    // });
    debugPrint('initState() called on options page');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build() called on options page');
    return Scaffold(
      appBar: AppBar(
        title: Wjts.text(context, widget.optionsPageTitle),
        actions: [
          //button for select all
          widget.isMultiSelect ? IconButton(icon: const Icon(CupertinoIcons.text_badge_checkmark), onPressed: (){
            _selectedOptionsProvider!.setSelectedValues(widget.options!.map((o) => o.value!).toList());
          }) : Container(),
          //button for clear all
          IconButton(icon: const Icon(CupertinoIcons.trash), onPressed: (){
            _clearSelected();
          }),
          //button for confirm multi election
          widget.isMultiSelect ? IconButton(icon: const Icon(CupertinoIcons.checkmark), onPressed: (){
            _confirmSelected();
          }) : Container()
        ],
      ),
      body: CustomScrollView(
        slivers: widget.isGrouped ? _getHeaderList() : <Widget>[_getFlatList()],
      ),
      //floatingActionButton: const _FloatingActionButton(),
    );
  }
}