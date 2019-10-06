import 'package:flutter/material.dart';


class FitOnBackPress extends StatelessWidget {

  final Widget child;

  FitOnBackPress({this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: child, onWillPop: () async{
      return false;
    });
  }
}
