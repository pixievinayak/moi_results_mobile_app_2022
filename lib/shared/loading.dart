import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SpinKitChasingDots(
            color: Colors.teal,
            size: 50,
          ),
        ),
      ),
    );
  }
}