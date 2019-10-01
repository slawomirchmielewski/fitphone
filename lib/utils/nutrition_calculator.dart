import 'package:fitphone/enums/setup_enums.dart';

class NutritionCalculator{

  Map<String ,int> calculate(var dietStyle,int multiplier,double weight){

    DietStyle ds = dietStyle;
    double fat;
    double protein;
    double carbs;
    double calories = _calculateCalories(multiplier, weight);

    switch(ds){
      case DietStyle.BalanceApproach:
        fat = _calculateFat(weight, 0.4);
        protein = _calculateProtein(weight, 0.7);
        carbs = _calculateCarbs(fat, protein,calories);
        break;
      case DietStyle.HighCarbLowerFat:
        fat = _calculateFat(weight, 0.3);
        protein = _calculateProtein(weight, 0.7);
        carbs = _calculateCarbs(fat, protein,calories);
        break;
      case DietStyle.LowCarbHigherFat:
        fat = _calculateFat(weight, 0.5);
        protein = _calculateProtein(weight, 0.7);
        carbs = _calculateCarbs(fat, protein ,calories);
        break;
      case DietStyle.Ketogenic:
        protein = _calculateProtein(weight, 0.7);
        carbs = 30.0;
        fat = _calculateFatKategonic(weight,protein,calories);
        break;
      case DietStyle.None:
        // TODO: Handle this case.
        break;
    }

    Map<String,int> nutritions = {
      "fat" : fat.round(),
      "carbs" : carbs.round(),
      "protein" : protein.round(),
      "calories" : calories.round(),
    };

    return nutritions;
  }



  double _calculateCalories(int multiplier, double weight){
    return weight * multiplier;
  }


  double _calculateFat(double weight,double value){
    return weight* value;
  }

  double _calculateProtein(double weight ,double value){
    return weight * value;
  }

  double _calculateCarbs(double fat, double protein,double calories){
    double proteinCalories = protein * 4.0;
    double fatCalories =fat * 9.0;
    double cal = proteinCalories + fatCalories;
    double carbsCalories = calories - cal;

    return carbsCalories / 4.0;
  }


  double _calculateFatKategonic(double weight,double protein,double calories){
    double proteinCalories = protein * 4.0;
    double carbsCalories = 30.0 * 4.0;
    double cal = proteinCalories + carbsCalories;
    double fatCalories = calories - cal;

    return fatCalories / 9.0;
  }

}