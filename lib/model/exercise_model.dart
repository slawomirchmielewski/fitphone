import 'package:firebase_database/firebase_database.dart';

class ExerciseModel{

  String name;
  int set;
  int weights;
  String reps;
  String url;

  ExerciseModel({this.name,this.set,this.url,this.weights,this.reps});

  factory ExerciseModel.formMap(Map<dynamic,dynamic> map){
    return ExerciseModel(
      name: map["name"],
      set: int.parse(map["sets"].toString()),
      weights: 0,
      reps: map["reps"].toString(),
      url: map["url"]
    );
  }


  factory ExerciseModel.formSnapshot(DataSnapshot snapshot){
    return ExerciseModel(
        name: snapshot.value["name"],
        set: int.parse(snapshot.value["sets"].toString()),
        weights: 0,
        reps: snapshot.value["reps"].toString(),
        url: snapshot.value["url"]
    );
  }

}