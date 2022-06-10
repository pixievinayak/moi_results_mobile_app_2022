
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:moi_results_mobile_app_2022/localization/localization_constants.dart';

import '../shared/global.dart';

class ErrorPage extends StatefulWidget {

  final Exception? ex;
  final String title;

  const ErrorPage({Key? key, this.ex, this.title = ''}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  Map? _params = {};
  String? _msg = "";
  String? _title = "";
  bool _isMsgExpanded = false;

  @override
  Widget build(BuildContext context) {

    if(widget.ex != null){
      _msg = widget.ex.toString();
      _title = widget.title;
    }else{
      _params = _params!.isNotEmpty ? _params : ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;
      _msg = _params!['msg'];
      _title = _params!['title'];
    }
    debugPrint('build() on Error Page - $_msg');
    return Scaffold(
      appBar: Wjts.appBar(context, Translations.errorPageTitle.tr()),
      body: Stack(
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/bg_01.png"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),
                Row(
                  children: [
                    Expanded(
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(
                              image: AssetImage('assets/images/oops_02.png'),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              // child: Flexible(
                              //     child: Wjts.text(context, _title!, size: TextSize.regular, weight: FontWeight.bold)
                              // ),
                              child: Wjts.text(context, _title!, size: TextSize.m, weight: FontWeight.bold)
                            ),
                            const SizedBox(height: 10,),
                            ExpansionPanelList(
                                animationDuration: const Duration(milliseconds:1000),
                                dividerColor: Theme.of(context).errorColor,
                                elevation:1,
                                expansionCallback: (int item, bool status) {
                                  setState(() {
                                    _isMsgExpanded = !_isMsgExpanded;
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (context, isExpanded) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                        child: Row(
                                          children: [
                                            Wjts.text(context, Translations.errorPageTechDetails.tr(), size: TextSize.m),
                                          ],
                                        ),
                                      );
                                    },
                                    body: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Flexible(
                                          child: Wjts.text(context, _msg!, size: TextSize.s)
                                      ),
                                    ),
                                    canTapOnHeader: true,
                                    isExpanded: _isMsgExpanded,
                                  ),
                                ]
                            ),
                            const SizedBox(height: 40,),
                            Wjts.text(context, Translations.errorPagePressBack.tr(), size: TextSize.m),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}