
class Exercise{
  String id;
  String workoutName;
  String programIntensity;
  String name;
  int order;
  int set;
  List<double> weights;
  List<int> doneReps;
  List<String> notes;
  int restTime;
  String reps;
  String url;
  String coverUrl;

  Exercise({
    this.id,
    this.workoutName,
    this.programIntensity,
    this.name,
    this.order,
    this.set,
    this.url,
    this.coverUrl,
    this.weights,
    this.doneReps,
    this.notes,
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
      weights: map["weights"]?.cast<double>() ?? [],
      doneReps: map["done reps"]?.cast<int>() ?? [],
      notes: map["notes"]?.cast<String>() ?? [],
      reps: map["reps"] ?? "",
      url: map["video_url"] ?? "",
      coverUrl: map["image_url"] ?? "",
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
      "notes" : notes,
      "reps" : reps,
      "weights" : [],
      "done reps" : [],
      "video_url" : url,
      "image_url" : coverUrl,
      "rest time" : restTime
    };
  }
}