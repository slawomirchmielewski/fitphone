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

  ThemeMode get theme => _getTheme();
  Unit get units => _getUnits();
  String get unitShortName => _getUnitShortName();
  String get themeName => _getThemeName();
  String get unitsName => _getUnitName();


  StreamSubscription _userStream;
  StreamSubscription _settingsStream;

  ThemeMode _getTheme(){

    ThemeMode themeState = ThemeMode.system;

    if(_theme == "Light"){
      themeState = ThemeMode.light;
    }
    else if(_theme == "Dark"){
      themeState = ThemeMode.dark;
    }
    else if(_theme == "System"){
      themeState = ThemeMode.system;
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

  setTheme(ThemeMode themeState){

    ThemeMode state = themeState;

    switch(state){
      case ThemeMode.light:
        _theme = "Light";
        break;
      case ThemeMode.dark:
        _theme = "Dark";
        break;
      case ThemeMode.system:
        _theme = "System";
        break;
    }

    FirebaseAPI().getCurrentUser().then((user){
      if(user != null){
        FirebaseAPI().setTheme(_theme, user.uid);
      }
    });
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

  String _getUnitName(){
    return _units;
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