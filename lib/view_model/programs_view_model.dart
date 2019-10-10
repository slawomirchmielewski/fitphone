import 'package:fitphone/model/account_info_model.dart';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/model/program_model.dart';
import 'package:fitphone/model/programs_info_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:flutter/foundation.dart';


enum CopyState{
  idle,
  copy,
  finish,
}

class ProgramsViewModel extends ChangeNotifier{

  ProgramInfo _programInfo;
  AccountInfo _accountInfo;
  List<Program> _programs;
  List<Exercise> _workout3A = [];
  List<Exercise> _workout3B = [];
  List<Exercise> _workout3C = [];
  List<Exercise> _workout4A = [];
  List<Exercise> _workout4A1 = [];
  List<Exercise> _workout4B = [];
  List<Exercise> _workout4B1 = [];
  String _userId;
  bool _newPrograms = false;
  CopyState _copyState = CopyState.idle;




  Program _tempProgram;

  ProgramInfo get programInfo => _programInfo;
  AccountInfo get accountInfo => _accountInfo;
  bool get newPrograms => _newPrograms;
  CopyState get copyState => _copyState;


  List<Program> get programs => _programs;


  List<Exercise> get workout3A => _workout3A;
  List<Exercise> get workout3B => _workout3B;
  List<Exercise> get workout3C => _workout3C;
  List<Exercise> get workout4A => _workout4A;
  List<Exercise> get workout4A1 => _workout4A1;
  List<Exercise> get workout4B => _workout4B;
  List<Exercise> get workout4B1 => _workout4B1;


  ProgramsViewModel(){
    getUserStream();
  }


  setNewProgramsValue(bool value){
    _newPrograms = value;
    notifyListeners();

  }

  getUserStream() async{
    FirebaseAPI().checkLoginUser().listen((firebaseUser){
      if(firebaseUser != null){
        _userId = firebaseUser.uid;
        _fetchAccountInfo();
        _fetchProgramInfo();
        _fetchPrograms();
        _getLatestProgram();
        _resetDoneWorkouts();
      }
    }).onError((error) => print);
  }

  _fetchProgramInfo(){
     FirebaseAPI().getProgramInfo(_userId).listen((snapshot){
      if(snapshot.data != null){
        ProgramInfo programInfo = ProgramInfo.fromMap(snapshot.data);
        _programInfo = programInfo;
        notifyListeners();
      }
    });
  }

 _fetchAccountInfo(){
    FirebaseAPI().getAccountInfo(_userId).listen((snapshot){
      if(snapshot.data != null){
        AccountInfo accountInfo = AccountInfo.fromMap(snapshot.data);
        _accountInfo = accountInfo;
        notifyListeners();
      }
    });
 }

  _fetchPrograms() {

    FirebaseAPI().getPrograms(_userId).listen((value) {

      _programs = [];

      for(var v in value.documents){
        Program program = Program.fromMap(v.data);
        program.id = v.documentID;
        _programs.add(program);


      }
      print("getting programs ${_programs.length}");
      _getWorkouts();
      notifyListeners();
    });
  }

   Future<void> _getWorkouts() async{

    Program program = _programs.where((e) => e.name == _programInfo.primaryProgram).first;

    print("Program Id : ${program.id}");

    if(_programInfo.primaryWorkout == "3d"){

      _workout3A =  await _fetchExercises(program.id,"3d", "Workout A");
      _workout3B =  await _fetchExercises(program.id,"3d", "Workout B");
      _workout3C =  await _fetchExercises(program.id,"3d", "Workout C");
      print("Fetching 3d");
    }
    else if(_programInfo.primaryWorkout == "4d"){
      _workout4A =  await _fetchExercises(program.id,"4d", "Workout A");
      _workout4A1 =  await _fetchExercises(program.id,"4d", "Workout A1");
      _workout4B =  await _fetchExercises(program.id,"4d", "Workout B");
      _workout4B1 =  await _fetchExercises(program.id,"4d", "Workout B1");
      print("Fetching 4d");
    }
  }


  setPrimaryProgram(String programId) async{
    await FirebaseAPI().updateProgramInfo(_userId, {"primaryProgram" : programId});
    _getWorkouts();
    notifyListeners();
  }

  setPrimaryWorkout(String workout) async{
    await FirebaseAPI().updateProgramInfo(_userId, {"primaryWorkout" : workout});
    _getWorkouts();
    notifyListeners();
  }

  setProgramAvailability(bool value)async{
    await FirebaseAPI().updateProgramInfo(_userId, {"isNewProgramAvailable" : value});
    notifyListeners();
  }

  incrementCompletedExercises(){

    var count = programInfo.completedExercises  + 1;
    FirebaseAPI().updateProgramInfo(_userId, {"completedExercises" : count});

  }

  Future<List<Exercise>> _fetchExercises(String programId,String programIntensity, String workoutName) async {

     List<Exercise> exercisesList =[];

     await FirebaseAPI().getExercises(_userId,programId, programIntensity, workoutName).then((snapshot){
        if(snapshot != null){
          for(var s in snapshot.documents){
            Exercise exercise = Exercise.fromMap(s.data);
            exercise.id = s.documentID;
            exercisesList.add(exercise);
          }
        }
      }).catchError((error) => print(error));
      print("Fetching exercises ");
      return exercisesList;
    }


 _getLatestProgram(){

    FirebaseAPI().getLatestProgram().listen((snapshot) {
      if(_userId != null){
        if(_accountInfo.accountStatus == "Active" && _newPrograms == false){
          for(var s in snapshot.documents){
            Program program = Program.fromMap(s.data);
            program.referenceId = s.documentID;

            if(_programs.length > 0){
                var ids = _programs.map((p) => p.referenceId);
                if(!ids.contains(program.referenceId)){
                _tempProgram = program;

                if(programInfo.isNewProgramAvailable == false){
                  setProgramAvailability(true);
                  _newPrograms = true;
                  notifyListeners();
                }
              }
            }
          }
        }
      }

    });
  }


  updateDoneWorkouts(bool value , String workoutName) async{

    var key = "";

    switch(workoutName){
      case "Workout 3A":
        key = "is3AWorkoutDone";
        break;
      case "Workout 3B":
        key = "is3BWorkoutDone";
        break;
      case "Workout 3C":
        key = "is3CWorkoutDone";
        break;
      case "Workout 4A":
        key = "is4AWorkoutDone";
        break;
      case "Workout 4A1":
        key = "is4A1WorkoutDone";
        break;
      case "Workout 4B":
        key = "is4BWorkoutDone";
        break;
      case "Workout 4B1":
        key = "is4B1WorkoutDone";
        break;
    }

    await FirebaseAPI().updateProgramInfo(_userId, {key : value});
  }


  updateWeightList(List<double> weights,exerciseId) async{

    Program program = _programs.where((e) => e.name == _programInfo.primaryProgram).first;

    await FirebaseAPI().updateExerciseWeight(_userId, program.id, exerciseId, {"weights" : weights});
  }


  downloadPrograms() async{

     if(_tempProgram != null){

       print(_tempProgram.name);

       _copyState = CopyState.copy;

       notifyListeners();


       FirebaseAPI().addProgram(_tempProgram.toMap(),_userId).then((programId){

         print("Path $programId");

         FirebaseAPI().getGlobalExercises(_tempProgram.referenceId).then((snapshot){

           if(snapshot.documents != null){

             for(var s in snapshot.documents){

               Exercise exercise = Exercise.fromMap(s.data);

               FirebaseAPI().addExercise(_userId,programId, exercise.toMap());

             }
           }
         });
       }).catchError((error) => print);

       setPrimaryProgram(_tempProgram.name);
       _newPrograms = false;
       setProgramAvailability(false);
       _copyState = CopyState.finish;
       notifyListeners();
     }
  }

  _resetDoneWorkouts() async{

    if(DateTime.now().weekday == 1){

     var map = {
       "is3AWorkoutDone" : false,
       "is3BWorkoutDone" : false,
       "is3CWorkoutDone" : false,
       "is4AWorkoutDone" : false,
       "is4A1WorkoutDone" : false,
       "is4BWorkoutDone" : false,
       "is4B1WorkoutDone" : false,
      };

      await FirebaseAPI().updateProgramInfo(_userId, map);
    }
  }

}