import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/model/nutrition_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/enums.dart';
import 'package:fitphone/utils/unit_converter.dart';
import 'package:rxdart/rxdart.dart';

class SetupBloc extends BlocBase{

  
  final _weightController = BehaviorSubject.seeded(80.0);
  Stream<double> get getWeight => _weightController.stream;
  Function(double) get setWeight => _weightController.sink.add;

  final _fitnessGoalController = BehaviorSubject.seeded(FitnessGoal.FatLoss);
  Stream<FitnessGoal> get getFitnessGoal => _fitnessGoalController.stream;
  Function(FitnessGoal) get setFitnessGoal => _fitnessGoalController.sink.add;

  final _dietStyleController = BehaviorSubject.seeded(DietStyle.BalancedApproach);
  Stream<DietStyle> get getDietStyle => _dietStyleController.stream;
  Function(DietStyle) get setDietStyle => _dietStyleController.sink.add;

  final _activityLevelController = BehaviorSubject<ActivityLevel>();
  Stream<ActivityLevel> get getActivityLevel => _activityLevelController.stream;
  Function(ActivityLevel) get setActivityLevel => _activityLevelController.sink.add;

  final _weightTextController = BehaviorSubject.seeded("Kg");
  Stream<String> get getWeightText => _weightTextController.stream;
  Function(String) get setWeightText => _weightTextController.sink.add;

  final _nutritionController = BehaviorSubject<List<Nutrition>>();
  Stream<List<Nutrition>> get getNutrition => _nutritionController.stream;
  Function(List<Nutrition>) get setNutrition => _nutritionController.sink.add;

  final _weightUnitController = BehaviorSubject.seeded(WeightUnit.Kilogram);
  Stream<WeightUnit> get weightUnit => _weightUnitController.stream;
  Function(WeightUnit) get setWeightUnit => _weightUnitController.sink.add;


  SetupBloc(){
    getWeightUnit();
  }


  getWeightUnit() async{
    String unit = await FirebaseUserAPI().getWeightUnit();
    print("unit : $unit");

    if(unit == "Kilograms"){
      _weightUnitController.sink.add(WeightUnit.Kilogram);
    }
    else{
      _weightUnitController.sink.add(WeightUnit.Pound);
    }
  }


   saveWeightUnit(WeightUnit unit) {

    var map;

    _weightUnitController.sink.add(unit);

    switch(unit){
      case WeightUnit.Kilogram:
        map = {"weightUnit":"Kilograms"};
        break;
      case WeightUnit.Pound:
        map = {"weightUnit":"Pounds"};
        break;
    }

    FirebaseUserAPI().updateUserProfile(map);
  }



  double _convertData(double data){

    double value;

    if(_weightUnitController.stream.value == WeightUnit.Kilogram){
      value = UnitConverter().convertToLbs(data);
    }
    else if(_weightUnitController.stream.value == WeightUnit.Pound){
      value = data;
    }
    return value;
  }


   double _calculateCalories(ActivityLevel activityLevel){

    ActivityLevel al = activityLevel;
    double calories = 0.0;

    switch(al){
      case ActivityLevel.SignificantlyOverweightFemale:
        calories = _convertData(_weightController.stream.value) * 8;
        break;
      case ActivityLevel.SignificantlyOverweightMale:
        calories = _convertData(_weightController.stream.value) * 9;
        break;
      case ActivityLevel.SlightlyOverweightMale:
        calories = _convertData(_weightController.stream.value) * 10;
        break;
      case ActivityLevel.ABitFluffyMale:
        calories  = _convertData(_weightController.stream.value) * 11;
        break;
      case ActivityLevel.LeanButWannaGetLeanerMale:
        calories = _convertData(_weightController.stream.value) * 12;
        break;
      case ActivityLevel.EasyGainerFemale:
        calories = _convertData(_weightController.stream.value) * 14;
        break;
      case ActivityLevel.EasyGainerMaleOrHardGainerFemale:
        calories = _convertData(_weightController.stream.value) * 16;
        break;
      case ActivityLevel.HardGainerMale:
        calories = _convertData(_weightController.stream.value) * 18;

    }

    return calories;

  }


  calculateMacros(){

    DietStyle ds = _dietStyleController.stream.value;
    double calories = _calculateCalories(_activityLevelController.stream.value);

    double fat;
    double protein;
    double carbs;

    switch(ds){
      case DietStyle.BalancedApproach:
        fat = _calculateFat(_weightController.stream.value, 0.4);
        protein = _calculateProtein(_weightController.stream.value, 0.7);
        carbs = _calculateCarbs(fat, protein,calories);
       break;
      case DietStyle.HigherCarbLowerFat:
        fat = _calculateFat(_weightController.stream.value, 0.3);
        protein = _calculateProtein(_weightController.stream.value, 0.7);
        carbs = _calculateCarbs(fat, protein,calories);
        break;
      case DietStyle.LowerCarbHigherFat:
        fat = _calculateFat(_weightController.stream.value, 0.5);
        protein = _calculateProtein(_weightController.stream.value, 0.7);
        carbs = _calculateCarbs(fat, protein ,calories);
        break;
      case DietStyle.Ketogenic:
        protein = _calculateProtein(_weightController.stream.value, 0.7);
        carbs = 30.0;
        fat = _calculateFatKategonic(_weightController.stream.value,protein,calories);
        break;
    }

    print("Fat: $fat , Protein: $protein , Carbs: $carbs");

    var map = {
      "fat" : fat,
      "carbs" : carbs,
      "protein" : protein,
      "calories" : calories,
      "weight": _weightController.stream.value

    };

    Nutrition ca = Nutrition(name:"Calories",value: calories);
    Nutrition p = Nutrition(name:"Protein",value: protein);
    Nutrition carb = Nutrition(name:"Carbs",value: carbs);
    Nutrition f = Nutrition(name:"Fat",value: fat);

    List<Nutrition> macros = [ca,p,carb,f];

    _nutritionController.sink.add(macros);

   FirebaseUserAPI().updateUserProfile(map);
    FirebaseUserAPI().addWeight(_weightController.stream.value);
  }


  double _calculateFat(double weight, double value){
    return weight * value;
  }


  double _calculateProtein(double weight, double value){
    return weight * value;
  }

  double _calculateCarbs(double fat , double protein , double calories){
    double proteinCalories = protein * 4;
    double fatCalories = fat * 9;
    double cal = proteinCalories + fatCalories;
    double carbsCalories = calories - cal;

    return carbsCalories / 4;

  }

  double _calculateFatKategonic(double weight, double protein ,double calories){
    double proteinCalories = protein * 4.0;
    double carbsCalories = 30.0 * 4.0;
    double cal = proteinCalories + carbsCalories;
    double fatCalories = calories - cal;


    return fatCalories / 9;

  }


  @override
  void dispose() {
    _fitnessGoalController?.close();
    _weightController?.close();
    _dietStyleController?.close();
    _activityLevelController?.close();
    _weightTextController?.close();
    _nutritionController?.close();
    _weightUnitController?.close();
  }

}