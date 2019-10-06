import 'package:fitphone/model/done_workout_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:flutter/foundation.dart';

class DoneWorkoutsViewModel extends ChangeNotifier{


  String _userId;
  List<DoneWorkout> _doneWorkouts = [];
  String _comment;

  List<DoneWorkout> get doneWorkouts => _doneWorkouts;
  String get comment => _comment;


  setComment(String value){
    _comment = value;
    notifyListeners();
  }


  DoneWorkoutsViewModel(){
    getUserStream();
  }

  getUserStream() async{
    FirebaseAPI().checkLoginUser().listen((firebaseUser){
      if(firebaseUser != null){
        _userId = firebaseUser.uid;
        fetchDoneWorkouts();
      }
    }).onError((error) => print);
  }

 fetchDoneWorkouts(){
    FirebaseAPI().getDoneWorkouts(_userId).listen((snapshot){

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

}