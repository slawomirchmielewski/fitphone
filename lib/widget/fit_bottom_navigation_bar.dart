import 'package:flutter/material.dart';
import 'dart:io';

class FitBottomNavigationBar extends StatelessWidget {


  final List<Widget> bottomNavigationBarItems;
  final double elevation;
  final Color backgroundColor;

  FitBottomNavigationBar({this.bottomNavigationBarItems,this.elevation,this.backgroundColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: MediaQuery.of(context).platformBrightness == Brightness.light ?  Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.1), blurRadius: 0.3)]
      ),
      height: Platform.isIOS && MediaQuery.of(context).size.height >= 812 ? 88 : 58,
      child: BottomAppBar(
        elevation: elevation,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: bottomNavigationBarItems,
        ),
      ),
    );
  }
}
