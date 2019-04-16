import 'package:screentheme/screentheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';



class StatusBarController{

  enableLightStatusBar() async {
      await ScreenTheme.lightStatusBar();
  }

  enableDarkStatusBar() async {
      await ScreenTheme.darkStatusBar();
  }

  setTransparentStatusBar() async{
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent,animate: true);
  }

  enableLightNavigationBar() async{
   await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
   await FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  }

  enableDarkNavigationBar() async{
   await FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
   await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

  }

  setNavigationBarColor(Color color) async{
    await FlutterStatusbarcolor.setNavigationBarColor(color,animate: true);
  }

}
