import 'dart:async';
import 'dart:io';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/model/level_model.dart';
import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/model/weight_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/firebase_result.dart';
import 'package:fitphone/utils/weight_change_result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fitphone/utils/levels_repo.dart';

class UserBloc implements BlocBase{

  final _userIdController = BehaviorSubject<String>();
  Stream<String> get getUserId => _userIdController.stream;
  Function(String) get setUserID => _userIdController.sink.add;

  final _userController = BehaviorSubject.seeded(User.empty());
  Stream<User> get getUser => _userController.stream;
  Function(User) get setUser =>_userController.sink.add;

  final _nameController = BehaviorSubject<String>();
  Stream<String> get getName => _nameController.stream;
  Function(String) get setName => _nameController.sink.add;

  final _emailController  = BehaviorSubject<String>();
  Stream<String> get getEmail => _emailController.stream;
  Function(String) get setEmail => _emailController.sink.add;

  final _passwordController = BehaviorSubject<String>();
  Stream<String> get getPassword => _passwordController.stream;
  Function(String) get setPassword =>_passwordController.sink.add;

  final _loginController = BehaviorSubject<FirebaseResultCallback>();
  Stream<FirebaseResultCallback> get getLoginResult => _loginController.stream;
  Function(FirebaseResultCallback) get setLoginResult => _loginController.sink.add;


  final _registerController = BehaviorSubject<FirebaseResultCallback>();
  Stream<FirebaseResultCallback> get getRegisterResult => _registerController.stream;
  Function(FirebaseResultCallback) get setRegisterResult => _registerController.sink.add;


  final _resetPasswordController = BehaviorSubject<FirebaseResultCallback>();
  Stream<FirebaseResultCallback> get getResetResult => _resetPasswordController.stream;
  Function(FirebaseResultCallback) get setResetPasswordResult => _resetPasswordController.sink.add;


  final _passcodeController = BehaviorSubject<String>();
  Stream<String> get getPasscode => _passcodeController.stream;
  Function(String) get setPasscode => _passcodeController.sink.add;

  final _weightController = BehaviorSubject<double>();
  Stream<double> get getWeight => _weightController.stream;
  Function(double) get setWeight => _weightController.sink.add;

  final _weightListController = BehaviorSubject<List<WeightModel>>();
  Stream<List<WeightModel>> get getWeightList => _weightListController.stream;
  Function(List<WeightModel>) get setWeightList => _weightListController.sink.add;

  final _progressBarPointController = BehaviorSubject.seeded(0.0);
  Stream<double> get getProgressBarValue => _progressBarPointController.stream;
  Function(double) get setProgressBarValue => _progressBarPointController.sink.add;


  final _monthsSelectorController = BehaviorSubject.seeded(1);
  Stream<int> get getMonthSelectorValue => _monthsSelectorController.stream;
  Function(int) get setMonthSelectorValue => _monthsSelectorController.sink.add;


  final _weightChangeController = BehaviorSubject<WeightChangeResult>();
  Stream<WeightChangeResult> get getWeightChange => _weightChangeController.stream;
  Function(WeightChangeResult) get setWeightChange => _weightChangeController.sink.add;


  final _levelUpgradeNotificationController = BehaviorSubject.seeded(false);
  Stream<bool> get getLevelUpgradeNotification => _levelUpgradeNotificationController.stream;
  Function(bool) get setLevelUpgradeNotification => _levelUpgradeNotificationController.sink.add;

  final _photosListController = BehaviorSubject<List<PhotoModel>>();
  Stream<List<PhotoModel>> get getPhotosList => _photosListController.stream;


  Stream<bool> get registerCheck => Observable.combineLatest3(getEmail, getPassword,getPasscode, (e,p,pa) => true);
  Stream<dynamic> get userCheck => Observable(FirebaseUserAPI().checkLoginUser());


  UserBloc() {
    _userController.stream.listen((data) async {
      if(data != null){
        _progressBarPointController.sink.add(
            _calculateProgressBarPoints(data.points, data.goalPoints));
        await _updateLevel(data);
      }
    });

    _weightListController.stream.listen((data){
      _weightChangeController.sink.add(_calculateChangeRate(data));
    });

    getUserUpdate();
    getWeightUpdate();
    getPhotosUpdate();
  }

  getUserUpdate(){
    FirebaseUserAPI().getCurrentUser().then((user) {
      if(user != null){
        Observable(FirebaseUserAPI().getUserData(user.uid)).listen((event){
          if(event.snapshot.value != null){
            User user = User.fromSnapshot(event.snapshot);
            _userController.sink.add(user);
          }
        }).onError((error) => print(error?.toString()));
      }
    }).catchError((error) => print(error?.toString()));
  }

  getWeightUpdate(){
    FirebaseUserAPI().getCurrentUser().then((user){
      if(user != null){
        Observable(FirebaseUserAPI().getWeights(user.uid)).listen((event){
          
          List<WeightModel> weightsList = [];
          
          if(event.snapshot.value != null){
           Map<String,dynamic> weights = Map.from(event.snapshot.value);
            weights.values.forEach((f){

              //Add weight to list
              weightsList.add(WeightModel.fromMap(f));

              //Sort list by date
             // weightsList.sort((a,b) => a.date.compareTo(b.date));
            });
          }

          _weightListController.sink.add(weightsList);
        });
      }
    }).catchError((error)=> print(error?.toString()));
  }


  getPhotosUpdate(){
    FirebaseUserAPI().getCurrentUser().then((user){
      if(user !=null){
        Observable(FirebaseUserAPI().getPhotos(user.uid)).listen((event){

          List<PhotoModel> photosList = [];

          if(event.snapshot.value != null){
            Map<String,dynamic> photos = Map.from(event.snapshot.value);
            photos.values.forEach((f) => photosList.add(PhotoModel.fromMap(f)));
          }

          _photosListController.sink.add(photosList);

        });
      }
    }).catchError((error)=> print(error?.toString()));
  }
  
  clearData(){
    setEmail(null);
    setPassword(null);
  }

  double _calculateProgressBarPoints(int points, int maxPoints){

    double progress = (points.toDouble()/maxPoints.toDouble());

    if(points > maxPoints){
      return 0.99;
    }

    return progress;
  }

  User getUserData(){
    return _userController.stream.value;
  }


  WeightChangeResult _calculateChangeRate(List<WeightModel> model){

    WeightChangeResult result = WeightChangeResult(value: 0.0 , text: "No changes");

    if(_userController.value != null && model.length >= 2 ){

      var value1 = model[model.length -1]?.weight;
      var value2 = model[model.length - 2]?.weight;

      result.value = (value1 - value2).toDouble().abs();

      if(value2 > value1){
        result.text = "Lost since last month";
      }
      else if(value2 < value1){
        result.text = "Gain since last month";
      }
      else{
        result.text = "No changes from last month";
      }

      return result;
    }

    return result;
  }


  _updateLevel(User user){

    if(user != null){
      int level = _userController.stream.value.level;
      if(user.points >= user.goalPoints) {
        var map = {
          "level": user.level + 1,
          "currents points": 0,
        };
        FirebaseUserAPI().updateUserProfile(map);
        _levelUpgradeNotificationController.sink.add(true);
      }
    }
  }



  updateWorkoutsCount() async{

    int workoutsCount = _userController.stream.value.workoutsCompleted;

    var map = {
      "workout completed" : workoutsCount + 1
    };

    FirebaseUserAPI().updateUserProfile(map);
  }


  Future<void> updatePoints(int value) async {

    int currentPoints = _userController.stream.value.points;

    var map = {"currents points" : currentPoints + value};

    FirebaseUserAPI().updateUserProfile(map);

  }


  Future<FirebaseResultCallback>loginUser() async{

    FirebaseResultCallback callback = await FirebaseUserAPI().loginUserWithEmailAndPassword(_emailController.stream.value, _passwordController.stream.value).
    catchError((error) => print);

    _loginController.sink.add(callback);

    clearData();

    return callback;

  }

  Future<FirebaseResultCallback>registerUser() async {

    FirebaseResultCallback callback = await FirebaseUserAPI().registerUserWithEmailAndPassword(
        _nameController.stream.value,
        _emailController.stream.value,
        _passwordController.stream.value,
        _passcodeController.stream.value).catchError((error) => print);

    _registerController.sink.add(callback);

    clearData();

    return callback;
  }


  Future<Null> logoutUser() async {
     await FirebaseUserAPI().signOutUser().catchError((error) => print);
  }


  resetPassword(){

    String email = _emailController.stream.value;
    print(email);

    if(email != null){
      FirebaseUserAPI().resetPassword(email).then((value) => _resetPasswordController.sink.add(value)).catchError((error) => print);
    }
  }


  Future<Null>uploadProfilePicture(File file) async{
    await FirebaseUserAPI().uploadProfilePicture(file).then((path){
    }).catchError((error) => print);
  }

  Future<Null>uploadSelfie(File file) async{
    await FirebaseUserAPI().uploadSelfie(file).then((path){
    }).catchError((error) => print);
  }

   addNewWeight(){
    if(_weightController.stream.value != null){
      FirebaseUserAPI().addWeight(_weightController.stream.value).catchError((error) => print);
      updatePoints(5);
    }
    
  }
  List<WeightModel> getThreeMonthsData() {
    List<WeightModel> weightList = [];
    List<WeightModel> weightModelList = _weightListController.stream.value;

    if(weightModelList.length >= 3){
      for (int i = weightModelList.length - 3; i < weightModelList.length; i++) {
        weightList.add(weightModelList[i]);
      }
    }

    else {
      weightList = weightModelList;
    }
    return weightList;
  }

  List<WeightModel> getSixMonthsData() {
    List<WeightModel> weightList = [];
    List<WeightModel> weightModelList = _weightListController.stream.value;

    if(weightModelList.length > 6){
      for (int i = weightModelList.length - 6; i < weightModelList.length; i++) {
        weightList.add(weightModelList[i]);
      }
    }

    else {
      weightList = weightModelList;
    }
    return weightList;
  }

  List<WeightModel> getNineMonthsData() {
    List<WeightModel> weightList = [];
    List<WeightModel> weightModelList = _weightListController.stream.value;

    if(weightModelList.length > 10){
      for (int i = weightModelList.length - 9; i < weightModelList.length; i++) {
        weightList.add(weightModelList[i]);
      }
    }

    else {
      weightList = weightModelList;
    }
    return weightList;
  }


  double calculateBodyWeightPercent(){
    var change = _weightListController.stream.value.first.weight - _weightListController.stream.value.last.weight;
    var result  = (change / _weightListController.stream.value.first.weight).abs()*100;

    return result;
  }


  updateProgramIntensity(String value){

    var map = {"primary workout": value};

    FirebaseUserAPI().updateUserProfile(map);
  }


  clearUserData(){
    _userController.sink.add(null);
    _nameController.sink.add(null);
    _emailController.sink.add(null);
    _passwordController.sink.add(null);
    _passcodeController.sink.add(null);
    _loginController.sink.add(null);
    _registerController.sink.add(null);
    _userIdController.sink.add(null);
    _resetPasswordController.sink.add(null);
    _weightController.sink.add(null);
    _weightListController.sink.add(null);
    _progressBarPointController.sink.add(0);
    _monthsSelectorController.sink.add(1);
    _weightChangeController.sink.add(null);
    _levelUpgradeNotificationController.sink.add(null);
    _photosListController.sink.add(null);
  }
  
  @override
  void dispose() {
    _userController.close();
    _nameController.close();
    _emailController.close();
    _passwordController.close();
    _passcodeController.close();
    _loginController.close();
    _registerController.close();
    _userIdController.close();
    _resetPasswordController.close();
    _weightController.close();
    _weightListController.close();
    _progressBarPointController.close();
    _monthsSelectorController.close();
    _weightChangeController.close();
    _levelUpgradeNotificationController.close();
    _photosListController.close();
  }
}