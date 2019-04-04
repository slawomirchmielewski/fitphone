import 'package:fitphone/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesController{


    void saveTheme(bool value) async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("darkTheme", value);
    }

  Future<bool> getTheme() async{

    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("darkTheme");

  }


  void saveWeightUnit(WeightUnit unit) async{

      SharedPreferences pref = await SharedPreferences.getInstance();

      switch(unit){
        case WeightUnit.Kilogram:
          pref.setString("weightUnit", "Kilograms");
          break;
        case WeightUnit.Pound:
          pref.setString("weightUnit", "Pounds");
          break;
      }

  }


  Future<WeightUnit> getWeightUnit() async{

    final SharedPreferences pref = await SharedPreferences.getInstance();
    String unitName = pref.getString("weightUnit");

    WeightUnit unit;

    switch(unitName){
      case "Kilograms":
         unit = WeightUnit.Kilogram;
         break;
      case "Pounds":
        unit = WeightUnit.Pound;
        break;

    }

    return unit;
  }


}



PreferencesController preferencesController = PreferencesController();