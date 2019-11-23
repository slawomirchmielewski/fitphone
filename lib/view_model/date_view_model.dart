import 'package:fitphone/model/date_model.dart';
import 'package:fitphone/model/weight_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:flutter/foundation.dart';

class DateViewModel extends ChangeNotifier{


  DateViewModel(){
    getUserStream();
  }


  getUserStream() async{
    FirebaseAPI().checkLoginUser().listen((firebaseUser){

      if(firebaseUser != null){
        _getDate(firebaseUser.uid);
      }
    }).onError((error) => print);
  }

  _getDate(String userId){
    FirebaseAPI().getDate(userId).listen((snapshot){
      if(snapshot.data != null){
        DateModel dateModel = DateModel.fromMap(snapshot.data);
        _resetDoneWorkouts(dateModel, userId);
      }
      else{
        var currentDate = _getCurrentDate();
        FirebaseAPI().addDate(userId, currentDate.toMap());
      }
    });
  }


  DateModel _getCurrentDate(){

    DateModel dateModel = DateModel(
      week: DateHelper.getWeekNumber(DateTime.now()),
      month: DateTime.now().month,
      year: DateTime.now().year
    );

    return dateModel;
  }


  _resetDoneWorkouts(DateModel dateModel , String userId) async {

    var currentDate = _getCurrentDate();

    if(dateModel.week != currentDate.week){

      var map = {
        "is3AWorkoutDone" : false,
        "is3BWorkoutDone" : false,
        "is3CWorkoutDone" : false,
        "is4AWorkoutDone" : false,
        "is4A1WorkoutDone" : false,
        "is4BWorkoutDone" : false,
        "is4B1WorkoutDone" : false,
      };

      await FirebaseAPI().updateProgramInfo(userId, map);

      await FirebaseAPI().updateDate(userId, {"week" : currentDate.week});

    }
  }

   Future<List<WeightModel>> getWeightFromMonth(int month,int year , String userId) async{


    final List<WeightModel> monthWeightList = [];

    await FirebaseAPI().getWeightFromMonthOne(userId, month, year).then((snapshot){

      for(var v  in snapshot.documents){
        WeightModel weightModel = WeightModel.fromMap(v.data);
        weightModel.id = v.documentID;
        monthWeightList.add(weightModel);
      }
    });
    return monthWeightList;
  }
}