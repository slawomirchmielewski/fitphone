class ProgramInfo{

  final bool isNewProgramAvailable;
  final String primaryWorkout;
  final String primaryProgram;
  final int completedExercises;
  final bool is3AWorkoutDone;
  final bool is3BWorkoutDone;
  final bool is3CWorkoutDone;
  final bool is4AWorkoutDone;
  final bool is4A1WorkoutDone;
  final bool is4BWorkoutDone;
  final bool is4B1WorkoutDone;

  ProgramInfo({
      this.isNewProgramAvailable,
      this.primaryWorkout,
      this.completedExercises,
      this.primaryProgram,
      this.is3AWorkoutDone,
      this.is3BWorkoutDone,
      this.is3CWorkoutDone,
      this.is4AWorkoutDone,
      this.is4A1WorkoutDone,
      this.is4BWorkoutDone,
      this.is4B1WorkoutDone
  });


  factory ProgramInfo.fromMap(Map<String, dynamic> map){
    return ProgramInfo(
      isNewProgramAvailable: map["isNewProgramAvailable"],
      completedExercises: map["completedExercises"],
      primaryProgram: map["primaryProgram"],
      primaryWorkout: map["primaryWorkout"],
      is3AWorkoutDone: map["is3AWorkoutDone"],
      is3BWorkoutDone: map["is3BWorkoutDone"],
      is3CWorkoutDone: map["is3CWorkoutDone"],
      is4AWorkoutDone: map["is4AWorkoutDone"],
      is4A1WorkoutDone: map["is4A1WorkoutDone"],
      is4BWorkoutDone: map["is4BWorkoutDone"],
      is4B1WorkoutDone: map["is4B1WorkoutDone"],

    );
  }

  factory ProgramInfo.init(){
    return ProgramInfo(
      isNewProgramAvailable: false,
      completedExercises: 0,
      primaryWorkout: "3d",
      primaryProgram: "",
      is3AWorkoutDone: false,
      is3BWorkoutDone: false,
      is3CWorkoutDone: false,
      is4AWorkoutDone: false,
      is4A1WorkoutDone: false,
      is4BWorkoutDone: false,
      is4B1WorkoutDone: false
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "isNewProgramAvailable" : isNewProgramAvailable,
      "completedExercises" : completedExercises,
      "primaryProgram" : primaryProgram,
      "primaryWorkout" : primaryWorkout,
      "is3AWorkoutDone" : is3AWorkoutDone,
      "is3BWorkoutDone" :is3BWorkoutDone,
      "is3CWorkoutDone" : is3CWorkoutDone,
      "is4AWorkoutDone" : is4AWorkoutDone,
      "is4A1WorkoutDone" :is4A1WorkoutDone,
      "is4BWorkoutDone" : is4BWorkoutDone,
      "is4B1WorkoutDone" : is4B1WorkoutDone
    };
  }
}