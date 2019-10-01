import 'package:firebase_database/firebase_database.dart';

class Exercise{

  String workoutName;
  String programIntensity;
  String name;
  int order;
  int set;
  List<double> weights;
  int restTime;
  String reps;
  String url;

  Exercise({
    this.workoutName,
    this.programIntensity,
    this.name,
    this.order,
    this.set,
    this.url,
    this.weights,
    this.reps,
    this.restTime
  });


  factory Exercise.fromMap(Map<dynamic,dynamic> map){
    return Exercise(
      workoutName: map["workout name"] ?? "",
      programIntensity: map["program intensity"] ?? "",
      name: map["name"] ?? "",
      order: map["order"] ?? 0,
      set: map["sets"] ?? 0,
      weights: map["weight"] ?? [],
      reps: map["reps"] ?? "",
      url: map["video_url"] ?? "",
      restTime: map["rest time"] ?? 0
    );
  }


  Map<String,dynamic> toMap(){
    return{
      "workout name" : workoutName,
      "program intensity" : programIntensity,
      "name" : name,
      "order" : order,
      "sets" : set,
      "reps" : reps,
      "weights" : weights,
      "video_url" : url,
      "rest time" : restTime
    };
  }
}