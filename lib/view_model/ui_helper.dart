import 'package:flutter/foundation.dart';


class UIHelper extends ChangeNotifier{


  int _bottomNavigationIndex = 0;
  int _setupPageIndex = 0;
  int _progressTabIndex = 0;
  bool _isWelcomeButtonVisible = false;
  bool _isWeightButtonVisible = false;
  bool _isUnitsButtonVisible = false;
  bool _isGoalButtonVisible = false;
  bool _isDietButtonVisible = false;
  bool _isActivitySelected = false;
  bool _isNutritionVisible = false;
  String _buttonSelectedText = "";

  int get bottomNavigationIndex => _bottomNavigationIndex;
  int get setupPageIndex => _setupPageIndex;
  int get progressTabIndex => _progressTabIndex;
  bool get isWelcomeButtonVisible => _isWelcomeButtonVisible;
  bool get isWeightButtonVisible => _isWeightButtonVisible;
  bool get isUnitsButtonVisible => _isUnitsButtonVisible;
  bool get isDietButtonVisible => _isDietButtonVisible;
  bool get isGoalButtonVisible => _isGoalButtonVisible;
  bool get isActivitySelected => _isActivitySelected;
  bool get isNutritionVisible => _isNutritionVisible;
  String get buttonSelectedText => _buttonSelectedText;

  setBottomNavigationIndex(int index){
    _bottomNavigationIndex = index;
    notifyListeners();
  }

  setWelcomeButtonVisibility(bool visibility){
    _isWelcomeButtonVisible = visibility;
    notifyListeners();
  }

  setWeightButtonVisibility(bool visibility){
    _isWeightButtonVisible = visibility;
    notifyListeners();
  }

  setUnitButtonVisibility(bool visibility){
    _isUnitsButtonVisible = visibility;
    notifyListeners();
  }

  setDietButtonVisibility(bool visibility){
    _isDietButtonVisible = visibility;
    notifyListeners();
  }

  setGoalButtonVisibility(bool visibility){
    _isGoalButtonVisible = visibility;
    notifyListeners();
  }

  setActivitySelections(bool isSelected){
    _isActivitySelected = isSelected;
    notifyListeners();
  }
  
  
  setNutritionVisibility(bool isVisible){
    _isNutritionVisible = isVisible;
    notifyListeners();
  }

  setSetupPageIndex(int value){
    _setupPageIndex = value;
    notifyListeners();
  }

  setButtonSelectedText(String text){
    _buttonSelectedText = text;
    notifyListeners();
  }

  setProgressTabIndex(int index){
    _progressTabIndex = index;
    notifyListeners();
  }
  
  
  



}