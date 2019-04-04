class ExerciseModel{

  String name;
  int set;
  int weights;
  String reps;
  String url;

  ExerciseModel({this.name,this.set,this.url,this.weights,this.reps});

  factory ExerciseModel.formMap(Map<String,dynamic> map){
    return ExerciseModel(
      name: map["name"],
      set: map["sets"],
      weights: 0,
      reps: map["reps"],
      url: map["url"]
    );
  }

}