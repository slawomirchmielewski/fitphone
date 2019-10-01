import 'package:fitphone/model/weight_model.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:fitphone/repository/firebase_api.dart';


enum LoadingStates{
  idle,
  loading,
  error
}


class WeightViewModel extends ChangeNotifier{


  String userId;
  double _weight = 0.0;
  LoadingStates _weekLoadingState;

  double get weight => _weight;


  List<DateTime> get weekDates => DateHelper.getDatesFromWeek();

  LoadingStates get weekLoadingState => _weekLoadingState;

  List<WeightModel> _weekWeightList = [];
  List<WeightModel> _monthWeightList = [];

  List<WeightModel> get weekWeightList => _weekWeightList;
  List<WeightModel> get monthWeightList => _monthWeightList;


  WeightViewModel(){
    getUserStream();
  }

  getUserStream(){
    FirebaseAPI().checkLoginUser().listen((firebaseUser){

      if(firebaseUser != null){
        userId = firebaseUser.uid;
        getWeightFromWeek(DateHelper.getWeekNumber(DateTime.now()), DateTime.now().year);
      }

    }).onError((error) => print);
  }

  setWeight(double value){
    _weight = value;
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
  Future<void> updateWeight() async{
    if(_weight != null){
      //TODO add update code
    }
  }


  getWeightFromWeek(int week, int year) async {


      _weekLoadingState = LoadingStates.loading;
      notifyListeners();


     FirebaseAPI().getWeightFromWeek(userId, week,year).listen((snapshot){

      _weekWeightList = [];

      for(var v  in snapshot.documents){
        WeightModel weightModel = WeightModel.fromMap(v.data);
        weightModel.id = v.documentID;
        _weekWeightList.add(weightModel);
      }

      _weekLoadingState = LoadingStates.idle;
      notifyListeners();

    });

  }

  getWeightFromMonth(int month,int year) async{

    FirebaseAPI().getWeightFromMonth(userId, month, year).listen((snapshot){

      _monthWeightList = [];

      for(var v  in snapshot.documents){
        WeightModel weightModel = WeightModel.fromMap(v.data);
        weightModel.id = v.documentID;
        _monthWeightList.add(weightModel);
      }

      notifyListeners();
    });
  }


  Future<void> deleteWeight(String weightId) async {

    await FirebaseAPI().deleteWeight(userId,weightId).then((_){
      print("Wieght deleted");

    });

    notifyListeners();

  }

}