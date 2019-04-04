import 'package:screentheme/screentheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';


class StatusBarController{

  enableLightStatusBar() async {
      await ScreenTheme.lightStatusBar();
  }

  enableDarkStatusBar() async {
      await ScreenTheme.darkStatusBar();
  }

  setTransparentStatusBar() async{
    await FlutterStatusbarManager.setColor(Colors.transparent, animated:true);
  }

  enableLightNavigationBar() async{
    await FlutterStatusbarManager.setNavigationBarStyle(NavigationBarStyle.LIGHT);
  }

  enableDarkNavigationBar() async{
    await FlutterStatusbarManager.setNavigationBarStyle(NavigationBarStyle.DARK);
  }

  setNavigationBarColor(Color color) async{
    await FlutterStatusbarManager.setNavigationBarColor(color, animated: true);
  }

}
