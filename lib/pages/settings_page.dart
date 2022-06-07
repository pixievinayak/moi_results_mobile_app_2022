
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../localization/localization_constants.dart';
import '../shared/global.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void _changeLanguage(String langCode, String langCountry) async {
    Locale _locale = await setLocale(langCode, langCountry);
    context.setLocale(_locale);
  }

  Future<void> _changeRegisteredWilayat(String? wilayatCode) async {
    GlobalVars.registeredWilayatCode = wilayatCode;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(StorageKeys.regWilayatCode, wilayatCode!);
  }

  void _onWilayatChange(String? wilayatCode){
    if(wilayatCode != GlobalVars.registeredWilayatCode) {
      _changeRegisteredWilayat(wilayatCode);
    }
  }

  void _clearStoredData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(StorageKeys.wilayatDataKey);
    _prefs.remove(StorageKeys.polStnDataKey);
    _prefs.remove(StorageKeys.candidatesDataKey);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build() called on settings page');
    return Scaffold(
      appBar: Wjts.appBar(context, Translations.settingsPageTitle.tr()),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              leading: const Image(
                image: AssetImage('assets/images/language_2.png'),
              ),
              title: Wjts.text(context, 'Language'),
              subtitle: Wjts.text(context, Languages.currentLanguageName),
              trailing: Switch(value: Languages.isEnglish, onChanged: (val) {
                Languages.isEnglish = val;
                if(Languages.isEnglish){
                  _changeLanguage(Languages.enLangCode, Languages.enLangCountryIndia);
                }else{
                  _changeLanguage(Languages.arLangCode, Languages.arLangCountryOman);
                }
              }),
              // isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              leading: const Image(
                image: AssetImage('assets/images/wilayat_1.png'),
              ),
              title: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Wjts.wilayatSelect(context, selectedValue: GlobalVars.registeredWilayatCode, onChangeHandler: _onWilayatChange, showOptionForAllWilayats: false, placeHolder: Translations.settingsPageRegWilayatPlaceHolder.tr())
                      // child: OptionsSelect(context, GlobalVars.optionsDataWilayatsEn,
                      //   isGrouped: true,
                      //   placeHolder: Translations.settings_page_reg_wilayat_place_holder.tr(),
                      //   isMultiSelect: true,
                      //   selectedValues: [GlobalVars.registeredWilayatCode!, '0'],
                      //   onMultiChange: (List<String>? selectedValues){
                      //     debugPrint('selected values: $selectedValues');
                      //   },
                      // )
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              leading: const Image(
                image: AssetImage('assets/images/version_1.png'),
              ),
              title: Wjts.text(context, 'Version'),
              subtitle: Wjts.text(context, 'v1.0 (beta) - [w:${GlobalVars.wilayatsDataVersion}, p:${GlobalVars.polStnsDataVersion}, c:${GlobalVars.candidatesDataVersion}]'),
              onLongPress: (){
                debugPrint("Long pressed on version");
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    content: Wjts.text(context, 'Are you sure you want to clear the local data?'),
                    actions: <Widget>[
                      TextButton(
                        child: Wjts.text(context, 'No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Wjts.text(context, 'Yes'),
                        onPressed: () {
                          _clearStoredData();
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  )
                );
              },
              // isThreeLine: true,
            ),
          ),
        ],
      )
    );
  }
}
