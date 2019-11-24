import 'dart:async';

import 'package:fitphone/model/done_workout_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DoneWorkoutsViewModel extends ChangeNotifier with WidgetsBindingObserver{


  String _userId;
  List<DoneWorkout> _doneWorkouts = [];
  String _comment;

  List<DoneWorkout> get doneWorkouts => _doneWorkouts;
  String get comment => _comment;


  StreamSubscription _userStream;
  StreamSubscription _doneWorkoutsStream;


  setComment(String value){
    _comment = value;
    notifyListeners();
  }


  DoneWorkoutsViewModel(){
    WidgetsBinding.instance.addObserver(this);
    getUserStream();
  }

  getUserStream() async{
   _userStream =  FirebaseAPI().checkLoginUser().listen((firebaseUser){
      if(firebaseUser != null){
        _userId = firebaseUser.uid;
        fetchDoneWorkouts();
      }
    });
  }

 fetchDoneWorkouts(){
  _doneWorkoutsStream = FirebaseAPI().getDoneWorkouts(_userId).listen((snapshot){

      _doneWorkouts = [];

      if(snapshot.documents != null){
        for(var s in snapshot.documents){
          DoneWorkout doneWorkout = DoneWorkout.fromMap(s.data);
          _doneWorkouts.add(doneWorkout);
        }
      }
      notifyListeners();
    });
 }

 addDoneWorkout(double weight, String time ,String workoutName) async{

    DoneWorkout doneWorkout = DoneWorkout(
      name: workoutName,
      maxLift: weight,
      time: time,
      date: DateTime.now().toUtc().millisecondsSinceEpoch,
      comment: _comment,
      week: DateHelper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,
      month: DateTime.now().month
    );

   await FirebaseAPI().addDoneWorkout(_userId,doneWorkout.toMap());
 }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      _userStream?.pause();
      _doneWorkoutsStream?.pause();
    }
    else if(state == AppLifecycleState.resumed){
      _userStream?.resume();
      _doneWorkoutsStream?.resume();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}