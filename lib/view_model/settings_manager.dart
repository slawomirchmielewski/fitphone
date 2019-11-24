import 'dart:async';

import 'package:fitphone/model/settings_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:flutter/foundation.dart';
import 'package:fitphone/enums/setup_enums.dart';
import 'package:fitphone/utils/unit_converter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingsManager extends ChangeNotifier with WidgetsBindingObserver {

  String _theme;
  String _units;

  ThemeState get theme => _getTheme();
  Unit get units => _getUnits();
  String get unitShortName => _getUnitShortName();
  String get themeName => _getThemeName();


  StreamSubscription _userStream;
  StreamSubscription _settingsStream;

  ThemeState _getTheme(){

    ThemeState themeState = ThemeState.SystemSettings;

    if(_theme == "LightTheme"){
      themeState = ThemeState.LightTheme;
    }
    else if(_theme == "DarkTheme"){
      themeState = ThemeState.DarkThem;
    }
    else if(_theme == "SystemSettings"){
      themeState = ThemeState.SystemSettings;
    }
    return themeState;
  }


  SettingsManager(){
    WidgetsBinding.instance.addObserver(this);
    getUserStream();
  }


  double getConvertedWeight(double weight){
    double w;

    if(_units == "Kilograms"){
      w = unitConverter.convertToKg(weight);
    }
    else if(_units == "Pounds"){
      w = weight;
    }

    return w;
  }

  double setConvertedWeight(double weight){
    double w;

    if(_units == "Kilograms"){
      w = unitConverter.convertToLbs(weight);
    }
    else if(_units == "Pounds"){
      w = weight;
    }

    return w;
  }


  getUserStream(){
   _userStream = FirebaseAPI().checkLoginUser().listen((firebaseUser){
      getSettings(firebaseUser?.uid);
    });
  }

  getSettings(String id){
  _settingsStream = FirebaseAPI().getSettings(id).listen((snapshot){

      if(snapshot.data != null){
        Settings settings = Settings.fromMap(snapshot.data);

        if(settings != null){
          _units = settings.units;
          _theme = settings.theme;
          notifyListeners();
        }
      }
    });
  }


  Unit _getUnits(){

    Unit unit = Unit.None;

    if(_units == "Kilograms"){
      unit = Unit.Kilograms;
    }
    else if(_units == "Pounds"){
      unit = Unit.Pounds;
    }
    else{
      unit = Unit.None;
    }
    return unit;
  }

  setTheme(ThemeState themeState){

    ThemeState state = themeState;

    switch(state){
      case ThemeState.LightTheme:
        _theme = "LightTheme";
        break;
      case ThemeState.DarkThem:
        _theme = "DarkTheme";
        break;
      case ThemeState.SystemSettings:
        _theme = "SystemSettings";
        break;
    }
    notifyListeners();
  }

  setUnits(Unit unit){
    Unit u = unit;

    switch(u){
      case Unit.Kilograms:
        _units = "Kilograms";
        break;
      case Unit.Pounds:
        _units = "Pounds";
        break;
      case Unit.None:
        _units = "None";
        break;
    }

   FirebaseAPI().getCurrentUser().then((user){
     if(user != null){
       FirebaseAPI().setUnit(_units, user.uid);
     }
   });
    notifyListeners();
  }

  String _getUnitShortName() {
    String shortName;

    if(_units =="Kilograms"){
      shortName = "kg";
    }
    else if(_units == "Pounds"){
      shortName = "lbs";
    }
    else{
      shortName = "";
    }

    return shortName;
  }

 String _getThemeName() {
    return _theme;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      _settingsStream?.pause();
      _userStream?.pause();

    }else if(state == AppLifecycleState.resumed){
      _userStream?.resume();
      _settingsStream?.resume();
    }
  }

  @override
  void dispose() {
    _userStream?.cancel();
    _settingsStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}