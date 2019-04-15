import 'package:firebase_database/firebase_database.dart';

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
    this.level = 1,
    this.photoUrl ="",
    this.points = 0,
    this.goalPoints = 50,
    this.workoutsCompleted = 0,
    this.weight = 0.0,
    this.weightUnit = "Kilograms",
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

  factory User.fromSnapshot(DataSnapshot snapshot){
    return User(
        name: snapshot.value["name"].toString(),
        level: snapshot.value["level"],
        photoUrl: snapshot.value["photoUrl"],
        workoutsCompleted: snapshot.value["workout completed"],
        points: snapshot.value["currents points"],
        goalPoints: snapshot.value["goal points"],
        weight: double.tryParse(snapshot.value["weight"].toString()),
        weightUnit: snapshot.value["weightUnit"],
        carbs:double.tryParse(snapshot.value["carbs"].toString()),
        calories:double.tryParse(snapshot.value["calories"].toString()) ,
        fat: double.parse(snapshot.value["fat"].toString()),
        protein: double.tryParse(snapshot.value["protein"].toString()),
        primaryWorkout: snapshot.value["primary workout"].toString()
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


  Map<String,dynamic> emptyToMap() {
    Map<String, dynamic> userData = {
      "name": this.name,
      "level": 1,
      "photoUrl": "",
      "workout completed": 0,
      "currents points": 0,
      "goal points": 50,
      "weight": 0,
      "weightUnit" : "Kilograms",
      "carbs": 0.0,
      "calories": 0.0,
      "fat": 0.0,
      "protein": 0.0,
      "primary workout" : "3 days"
    };

    return userData;
  }

}