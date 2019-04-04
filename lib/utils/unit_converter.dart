class UnitConverter{

  double convertToKg(double value){
    var result = value * 0.45359237;
    return result;
  }


  double convertToLbs(double value){
    var result = value / 0.45359237;
    return result;
  }
}


UnitConverter unitConverter = UnitConverter();