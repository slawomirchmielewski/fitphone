import 'package:fitphone/utils/enums.dart';

class User {
  String name;
  int level;
  String photoUrl;
  int points;
  int goalPoints;
  int workoutsCompleted;
  double weight;
  String weightUnit;
  double carbs;
  double calories;
  double fat;
  double protein;
  String primaryWorkout;


  User({
    this.name,
    this.level,
    this.photoUrl,
    this.points,
    this.goalPoints,
    this.workoutsCompleted,
    this.weight ,
    this.weightUnit,
    this.carbs,
    this.calories,
    this.fat,
    this.protein,
    this.primaryWorkout
  });

  User.empty({
    this.name = "",
    this.level = 0,
    this.photoUrl ="",
    this.points = 0,
    this.goalPoints = 2000,
    this.workoutsCompleted = 0,
    this.weight = 0.0,
    this.weightUnit = "kilograms",
    this.carbs = 0.0,
    this.calories = 0.0,
    this.fat = 0.0,
    this.protein = 0.0,
    this.primaryWorkout = "3 days"
  });


  String getFirstName(){
    List<String> list = name.split(" ");
    return list[0];
  }

  WeightUnit getWeightUnit(){

    WeightUnit unit;

    if(this.weightUnit == "Kilograms" ) {
      unit = WeightUnit.Kilogram;
    }
    else if(this.weightUnit == "Pounds") {
      unit = WeightUnit.Pound;
    }

    return unit;

  }

  factory User.fromMap(Map<String,dynamic> map){
    return User(
      name: map["name"],
      level: map["level"],
      photoUrl: map["photoUrl"],
      workoutsCompleted: map["workout completed"],
      points: map["currents points"],
      goalPoints: map["goal points"],
      weight: map["weight"],
      weightUnit: map["weightUnit"],
      carbs: map["carbs"],
      calories: map["calories"],
      fat: map["fat"],
      protein: map["protein"],
      primaryWorkout: map["primary workout"]
    );
  }

  Map<String,dynamic> toMap() {
    Map<String, dynamic> userData = {
      "name": this.name,
      "level": this.level,
      "photoUrl": this.photoUrl,
      "workout completed": this.workoutsCompleted,
      "currents points": this.points,
      "goal points": this.goalPoints,
      "weight": this.weight,
      "weightUnit" : this.weightUnit,
      "carbs": this.carbs,
      "calories": this.calories,
      "fat": this.fat,
      "protein": this.protein,
      "primary workout" : this.primaryWorkout
    };

    return userData;
  }

}