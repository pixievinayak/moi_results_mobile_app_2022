import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {

  final Exception? ex;

  ErrorPage({this.ex});

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  Map? _params = {};
  String? msg = "";

  // @override
  // initState() {
  //   debugPrint('initState() on Error Page');
  //   Future.delayed(Duration.zero,() {
  //     if(widget.ex != null){
  //       msg = widget.ex.toString();
  //     }else{
  //       _params = _params.isNotEmpty ? _params : ModalRoute.of(context).settings.arguments;
  //       msg = _params['msg'];
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {

    if(widget.ex != null){
      msg = widget.ex.toString();
    }else{
      _params = _params!.isNotEmpty ? _params : ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;
      msg = _params!['msg'];
    }
    debugPrint('build() on Error Page - $msg');
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Page'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text('Oops! We seem to have an issue.',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(msg!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text('Press back to close',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}