import 'package:fitphone/model/nutrition_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:flutter/foundation.dart';

class NutritionViewModel extends ChangeNotifier {


  Nutritions _nutrition;

  Nutritions get nutrition => _nutrition;

  NutritionViewModel() {
    _checkForUser();
  }

  _checkForUser() async {
    FirebaseAPI().checkLoginUser().listen((user) {
      if(user != null){
        _fetchNutritionAsync(user.uid);
      }
    });
  }

  ///Fetch nutrition date from datebase from the current user with provided[userId]
  _fetchNutritionAsync(String userId) {
    FirebaseAPI().getNutritions(userId).listen((snapshot) {

      if(snapshot.data != null){
        Nutritions nutrition = Nutritions.fromMap(snapshot.data);

        if (nutrition != null) {
          _nutrition = nutrition;
          notifyListeners();
        }
      }
    }).onError((error) => print);
  }

  ///Update nutrition with new values from provided[map]
  Future<void> updateNutrition(Map<String,dynamic> map) async {

      await FirebaseAPI().updateNutritions(map);
  }

}
