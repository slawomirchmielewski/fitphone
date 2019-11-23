import 'dart:async';

import 'package:fitphone/model/nutrition_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NutritionViewModel extends ChangeNotifier  with WidgetsBindingObserver{


  Nutritions _nutrition;

  Nutritions get nutrition => _nutrition;

  StreamSubscription _userStream;
  StreamSubscription _nutritionStream;


  NutritionViewModel() {
    WidgetsBinding.instance.addObserver(this);
    _checkForUser();
  }

  _checkForUser() async {
    _userStream = FirebaseAPI().checkLoginUser().listen((user) {
      if(user != null){
        _fetchNutritionAsync(user.uid);
      }
    });
  }

  ///Fetch nutrition date from datebase from the current user with provided[userId]
  _fetchNutritionAsync(String userId) {
  _nutritionStream = FirebaseAPI().getNutritions(userId).listen((snapshot) {

      if(snapshot.data != null){
        Nutritions nutrition = Nutritions.fromMap(snapshot.data);

        if (nutrition != null) {
          _nutrition = nutrition;
          notifyListeners();
        }
      }
    });

  }

  ///Update nutrition with new values from provided[map]
  Future<void> updateNutrition(Map<String,dynamic> map) async {

      await FirebaseAPI().updateNutritions(map);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      _userStream.pause();
      _nutritionStream.pause();
    }else if(state == AppLifecycleState.resumed){
      _userStream.resume();
      _nutritionStream.resume();;
    }
  }

  @override
  void dispose() {
    _userStream.cancel();
    _nutritionStream.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}
