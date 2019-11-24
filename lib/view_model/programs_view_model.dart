import 'dart:async';

import 'package:fitphone/model/account_info_model.dart';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/model/program_model.dart';
import 'package:fitphone/model/programs_info_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


enum CopyState{
  idle,
  copy,
  finish,
}

class ProgramsViewModel extends ChangeNotifier with WidgetsBindingObserver{

  ProgramInfo _programInfo;
  AccountInfo _accountInfo;
  List<Program> _programs;
  List<Exercise> _exercisesList = [];
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


  StreamSubscription _userStream;
  StreamSubscription _programInfoStream;
  StreamSubscription _accountInfoStream;
  StreamSubscription _programsStream;
  StreamSubscription _exercisesStream;
  StreamSubscription _latestProgramsStream;

  ProgramsViewModel(){
    WidgetsBinding.instance.addObserver(this);
    getUserStream();
  }


  setNewProgramsValue(bool value){
    _newPrograms = value;
    notifyListeners();
  }

  getUserStream() async{
   _userStream = FirebaseAPI().checkLoginUser().listen((firebaseUser){
      if(firebaseUser != null){
        _userId = firebaseUser.uid;
        _fetchAccountInfo();
        _fetchPrograms();
        _fetchProgramInfo();
      }
    });
  }

  _fetchProgramInfo(){
    _programInfoStream = FirebaseAPI().getProgramInfo(_userId).listen((snapshot){
      if(snapshot.data != null){
        ProgramInfo programInfo = ProgramInfo.fromMap(snapshot.data);

        _programInfo = programInfo;
        _fetchExercises();
      }
      notifyListeners();
    });
  }

 _fetchAccountInfo(){
    _accountInfoStream =  FirebaseAPI().getAccountInfo(_userId).listen((snapshot){
      if(snapshot.data != null){
        AccountInfo accountInfo = AccountInfo.fromMap(snapshot.data);
        _accountInfo = accountInfo;
        _getLatestProgram();
        notifyListeners();
      }
    });
 }

  _fetchPrograms() {

   _programsStream = FirebaseAPI().getPrograms(_userId).listen((value) {

      _programs = [];

      for(var v in value.documents){
        Program program = Program.fromMap(v.data);
        program.id = v.documentID;
        _programs.add(program);


      }
      notifyListeners();
    });
  }



  setPrimaryProgram(String programId) async{
    await FirebaseAPI().updateProgramInfo(_userId, {"primaryProgram" : programId});
    notifyListeners();
  }

  setPrimaryWorkout(String workout) async{
    await FirebaseAPI().updateProgramInfo(_userId, {"primaryWorkout" : workout});
    notifyListeners();
  }

  setProgramAvailability(bool value) async{
    await FirebaseAPI().updateProgramInfo(_userId, {"isNewProgramAvailable" : value});
    notifyListeners();
  }

  incrementCompletedExercises(){
    var count = programInfo.completedExercises  + 1;
    FirebaseAPI().updateProgramInfo(_userId, {"completedExercises" : count});

  }

  _fetchExercises(){

    Program program = _programs.where((e) => e.name == _programInfo.primaryProgram).first;

    _exercisesStream = FirebaseAPI().getExercises(_userId,program.id).listen((snapshot){

       _exercisesList =[];

        if(snapshot != null){
          for(var s in snapshot.documents){
            Exercise exercise = Exercise.fromMap(s.data);
            exercise.id = s.documentID;
            _exercisesList.add(exercise);
          }
        }
        _getPrograms(_exercisesList);
      });
    }


   _getPrograms(List<Exercise> ex){

       _clearList();

       _workout3A = ex.where((e) => e.workoutName == "Workout A" && e.programIntensity == "3d").toList();
       _workout3B = ex.where((e) => e.workoutName == "Workout B" && e.programIntensity == "3d").toList();
       _workout3C = ex.where((e) => e.workoutName == "Workout C" && e.programIntensity == "3d").toList();

       _workout4A = ex.where((e) => e.workoutName == "Workout A" && e.programIntensity == "4d").toList();
       _workout4A1 = ex.where((e) => e.workoutName == "Workout A1" && e.programIntensity == "4d").toList();
       _workout4B = ex.where((e) => e.workoutName == "Workout B" && e.programIntensity == "4d").toList();
       _workout4B1 = ex.where((e) => e.workoutName == "Workout B1" && e.programIntensity == "4d").toList();
   }


   _clearList(){
    _workout3A = [];
    _workout3B = [];
    _workout3C = [];
    _workout4A = [];
    _workout4A1 = [];
    _workout4B = [];
    _workout4B1 = [];
   }


  _getLatestProgram(){

  _latestProgramsStream = FirebaseAPI().getLatestProgram().listen((snapshot) {
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


  updateExercise(List<double> weights,List<int> doneReps,exerciseId) async{

    Program program = _programs.where((e) => e.name == _programInfo.primaryProgram).first;

    await FirebaseAPI().updateExercise(_userId, program.id, exerciseId, {
      "weights" : weights,
      "done reps" : doneReps
    });
  }

  updatesNotes(List<String> notes,exerciseId) async{
    Program program = _programs.where((e) => e.name == _programInfo.primaryProgram).first;

    await FirebaseAPI().updateExercise(_userId, program.id, exerciseId, {
      "notes" : notes,
    });
  }


  downloadPrograms() async{

     if(_tempProgram != null){

       print(_tempProgram.name);

       _copyState = CopyState.copy;

       notifyListeners();


       FirebaseAPI().addProgram(_tempProgram.toMap(),_userId).then((programId){

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


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      _userStream?.pause();
      _programInfoStream?.pause();
      _accountInfoStream?.pause();
      _programsStream?.pause();
      _exercisesStream?.pause();
      _latestProgramsStream?.pause();
    }
    else if(state == AppLifecycleState.resumed){
      _userStream?.resume();
      _programInfoStream?.resume();
      _accountInfoStream?.resume();
      _programsStream?.resume();
      _exercisesStream?.resume();
      _latestProgramsStream?.resume();
    }
  }

  @override
  void dispose() {
    _userStream?.cancel();
    _programInfoStream?.cancel();
    _accountInfoStream?.cancel();
    _programsStream?.cancel();
    _exercisesStream?.cancel();
    _latestProgramsStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}