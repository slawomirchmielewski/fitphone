import 'dart:async';

import 'package:fitphone/model/weight_model.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fitphone/repository/firebase_api.dart';


enum LoadingStates{
  idle,
  loading,
  error
}

class WeightViewModel extends ChangeNotifier with WidgetsBindingObserver{


  String userId;
  double _weight = 0.0;
  LoadingStates _weekLoadingState;
  WeightModel _currentWeight;

  double _updateWeight;
  double get weightToUpdate => _updateWeight;
  double get weight => _weight;
  WeightModel get currentWeight => _currentWeight;


  List<DateTime> get weekDates => DateHelper.getDatesFromWeek();

  LoadingStates get weekLoadingState => _weekLoadingState;

  List<WeightModel> _weekWeightList = [];
  List<WeightModel> _monthWeightList = [];
  List<WeightModel> _yearWeightList = [];

  List<WeightModel> get weekWeightList => _weekWeightList;
  List<WeightModel> get monthWeightList => _monthWeightList;
  List<WeightModel> get yearWeightList => _yearWeightList;

  double _weeklyAvg  = 0.0;
  double _monthlyAvg = 0.0;
  double _yearlyAvg = 0.0;
  double _monthlyPercent = 0.0;

  double get weeklyAvg => _weeklyAvg;
  double get monthlyAvg => _monthlyAvg;
  double get yearlyAvg => _yearlyAvg;
  double get monthlyPercent => _monthlyPercent;


  StreamSubscription monthlyWeightStream;
  StreamSubscription weeklyWeightStream;
  StreamSubscription yearlyWeightStream;
  StreamSubscription currentWeightStream;
  StreamSubscription userStream;


  WeightViewModel(){
    WidgetsBinding.instance.addObserver(this);
    getUserStream();
  }

  getUserStream(){
   userStream = FirebaseAPI().checkLoginUser().listen((firebaseUser){
      if(firebaseUser != null){
        userId = firebaseUser.uid;
        getWeightFromWeek(DateHelper.getWeekNumber(DateTime.now()), DateTime.now().year);
        getWeightFromYear(DateTime.now().year);
        getWeightFromMonth(DateTime.now().month, DateTime.now().year);
        getCurrentWeight();
      }

    });
  }

  setWeight(double value){
    _weight = value;
    notifyListeners();
  }


  setWeightToUpdate(double value){
    _updateWeight = value;
    notifyListeners();
  }


  ///Record new weight
  Future<void> recordWeight() async{

    if(_weight != 0){
      await FirebaseAPI().addWeight(userId,_weight);
      notifyListeners();
    }

  }


  ///Update current weight
  Future<void> updateWeight(String id) async{
    if(_updateWeight != null){
      await FirebaseAPI().updateWeight(userId, id, _updateWeight).then((_){
        _updateWeight = null;
      });

    }
  }


  getWeightFromWeek(int week, int year) async {


      _weekLoadingState = LoadingStates.loading;
      notifyListeners();


    weeklyWeightStream = FirebaseAPI().getWeightFromWeek(userId, week,year).listen((snapshot){

      _weekWeightList = [];

      for(var v  in snapshot.documents){
        WeightModel weightModel = WeightModel.fromMap(v.data);
        weightModel.id = v.documentID;
        _weekWeightList.add(weightModel);
      }

      _weeklyAvg = _calculateAvg(_weekWeightList);

      _weekLoadingState = LoadingStates.idle;
      notifyListeners();

    });

  }

  getWeightFromMonth(int month,int year) async{

   monthlyWeightStream = FirebaseAPI().getWeightFromMonth(userId, month, year).listen((snapshot){

      _monthWeightList = [];

      for(var v  in snapshot.documents){
        WeightModel weightModel = WeightModel.fromMap(v.data);
        weightModel.id = v.documentID;
        _monthWeightList.add(weightModel);
      }

      _monthlyAvg = _calculateAvg(_monthWeightList);

      _addMonthlyAvgWeight(_monthlyAvg);


      notifyListeners();
    });
  }


  getWeightFromYear(int year) async{
   yearlyWeightStream =  FirebaseAPI().getMonthlyAvgWeight(userId, year).listen((snapshot){

      _yearWeightList = [];

      for(var v in snapshot.documents){
        WeightModel weightModel = WeightModel.fromMap(v.data);
        weightModel.id = v.documentID;
        _yearWeightList.add(weightModel);
      }

      _yearlyAvg = _calculateAvg(_yearWeightList);

      _getPercentWeightFromMonths();

      notifyListeners();
    });
  }


  Future<void> deleteWeight(String weightId) async {

    await FirebaseAPI().deleteWeight(userId,weightId).then((_){
      print("Wieght deleted");

    });

    notifyListeners();

  }

  double calculateWeightDifferent(double startWeight){

    if(startWeight > _currentWeight.weight){
      return startWeight - _currentWeight.weight;
    }
    return _currentWeight.weight - startWeight;
  }

  String getWeightDifferentText(double startWeight) {
    if (startWeight > _currentWeight.weight) {
      return "Loss";
    }
    else if (startWeight < _currentWeight.weight) {
      return "Gain";
    }

    return "No changes";
  }

  getCurrentWeight(){
   currentWeightStream =  FirebaseAPI().getCurrentWeight(userId).listen((snapshot){
      if(snapshot.documents != null){
        for(var s in snapshot.documents){
          WeightModel weightModel = WeightModel.fromMap(s.data);
          _currentWeight = weightModel;

        }
        notifyListeners();
      }
    });
  }


  double _calculateAvg(List<WeightModel> weight){

    var avg = 0.0;
    var sum = 0.0;

    for(var w in weight){
      sum += w.weight;
    }
    if(weight.length > 0){
      avg = sum/weight.length;
    }

    return avg;
  }

  _getPercentWeightFromMonths(){

    double lastMonthWeight;
    double currentMonthWeight;


    if(yearWeightList.length > 1){
      lastMonthWeight = yearWeightList[yearWeightList.length - 2].weight;
      currentMonthWeight = yearWeightList.last.weight;


      print(lastMonthWeight);
      print(currentMonthWeight);

      var percent = (currentMonthWeight/lastMonthWeight) *100;


      print(percent.toString());

      _monthlyPercent = percent;

    }
    else{
      _monthlyPercent = 0.0;
    }
  }


  _addMonthlyAvgWeight(double avgWeight){

    WeightModel weightModel = WeightModel(
        date: DateTime.now().millisecondsSinceEpoch,
        week: DateHelper.getWeekNumber(DateTime.now()),
        day: 0,
        year: DateTime.now().year,
        month:  DateTime.now().month,
        weight: avgWeight
    );

    if(_yearWeightList.length > 0){

      WeightModel lastMonth = _yearWeightList.last;

      if(DateTime.now().month == lastMonth.month){
        if(lastMonth != null){
          FirebaseAPI().updateMonthlyAvgWeight(userId,lastMonth.id, {"weight" : avgWeight});
        }
      }
      else{
        FirebaseAPI().addMonthlyAvgWeight(userId, weightModel.toMap());
      }
    }
    else{
      FirebaseAPI().addMonthlyAvgWeight(userId, weightModel.toMap());
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
     if(state == AppLifecycleState.paused){
       monthlyWeightStream?.pause();
       weeklyWeightStream?.pause();
       yearlyWeightStream?.pause();
       currentWeightStream?.pause();
     }
     else if(state == AppLifecycleState.resumed){
       monthlyWeightStream?.resume();
       weeklyWeightStream?.resume();
       yearlyWeightStream?.resume();
       currentWeightStream?.resume();

     }
  }


  @override
  void dispose() {
    userStream.cancel();
    monthlyWeightStream?.cancel();
    currentWeightStream?.cancel();
    weeklyWeightStream?.cancel();
    yearlyWeightStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}