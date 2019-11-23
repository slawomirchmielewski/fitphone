import 'package:fitphone/model/settings_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/nutrition_calculator.dart';
import 'package:flutter/foundation.dart';
import 'package:fitphone/enums/setup_enums.dart';

class SetupManager extends ChangeNotifier{

  double _weight = 0;
  int _carbs = 0;
  int _proteins = 0;
  int _calories = 0;
  int _fats = 0;
  int _activityMultiplier = 0;
  FitnessGoal _fitnessGoal = FitnessGoal.None;
  DietStyle _dietStyle= DietStyle.None;
  bool _calculationFinished = false;


  double get weight => _weight;
  int get carbs => _carbs;
  int get proteins => _proteins;
  int get calories => _calories;
  int get fat => _fats;
  bool get calculationFinished => _calculationFinished;
  FitnessGoal get fitnessGoal => _fitnessGoal;
  int get activityMultiplier => _activityMultiplier;
  DietStyle get dietStyle => _dietStyle;


  Future<String> getUnit()async{

    String unit = "";

    String id = await FirebaseAPI().getCurrentUser().then((user) => user.uid).catchError((error) => print);
    await FirebaseAPI().getSettingOnce(id).then((snapshot){
      if(snapshot.data != null){
        Settings settings  = Settings.fromMap(snapshot.data);
        unit = settings.units;
      }
    });

    return unit;
  }


  setWeight(double weight){
    _weight = weight;
    notifyListeners();
  }

  setCarbs(int carbs){
    _carbs = carbs;
    notifyListeners();
  }

  setProteins(int proteins){
    _proteins = proteins;
    notifyListeners();
  }

  setCalories(int calories){
    _calories = calories;
    notifyListeners();
  }

  setFat(int fat) {
    _fats = fat;
    notifyListeners();
  }

  setFitnessGoal(FitnessGoal fitnessGoal){
    _fitnessGoal = fitnessGoal;
    notifyListeners();
  }

  setDietStyle(DietStyle dietStyle){
    _dietStyle = dietStyle;
    notifyListeners();
  }

  setActivityMultiplier(int value){
    _activityMultiplier = value;
  }

  calculateNutrition() async{

    NutritionCalculator nutritionCalculator = NutritionCalculator();
    Map<String,int> nutritions = nutritionCalculator.calculate(_dietStyle, _activityMultiplier, _weight);

    _fats = nutritions["fat"];
    _proteins = nutritions["protein"];
    _carbs = nutritions["carbs"];
    _calories = nutritions["calories"];


     Map<String,dynamic> weight = {"weight" : _weight};
    
    String id = await FirebaseAPI().getCurrentUser().then((user) => user.uid).catchError((error) => print);

    await FirebaseAPI().updateUserData(weight, id);
    await FirebaseAPI().addNutritions(nutritions);
    await FirebaseAPI().addWeight(id,_weight);
    print("Weight added");
    _calculationFinished = true;

  }

}




