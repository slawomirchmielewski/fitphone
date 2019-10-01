import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/utils/images_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'dart:io';

import 'package:flutter/material.dart';


class UserViewModel with ChangeNotifier {


  User _user;
  int _day;
  bool _newLevelAvailable = false;

  User get user => _user;
  int get day => _day;
  bool get newLevelAvailable=> _newLevelAvailable;


  setNewLevelAvailable(bool value){
    _newLevelAvailable = value;
    notifyListeners();
  }


  UserViewModel() {
    getUserStream();
  }

  getUserStream() async{
    FirebaseAPI().checkLoginUser().listen((firebaseUser){

      if(firebaseUser != null){
        getUserInfo(firebaseUser?.uid);
      }
    }).onError((error) => print);
  }


  getUserInfo(String userId) async{
    if(userId != null){

       FirebaseAPI().getUserData(userId).listen((snapshot) {

         if(snapshot.exists){
           User user = User.fromMap(snapshot.data);
           if(user != _user){
             _user = user;
             _checkForLevelUpdate();
             _calculateDate();
             notifyListeners();
           }
         }
      }).onError((error)=>print);
    }
  }


  Future<void> _calculateDate() async {

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(_user.firstRegistrationDate?.millisecondsSinceEpoch,isUtc: true);
    DateTime now = DateTime.now();

    Duration duration = now.difference(dateTime);
    _day = duration.inDays.floor() + 1;
    print(_day);
  }

  _checkForLevelUpdate(){
    if(_user.xp == _user.maxXp || _user.xp > _user.maxXp){
      _newLevelAvailable = true;
      _updateUserLevel();
    }
  }


  _updateUserLevel(){
    var map = {
      "level" : _user.level + 1,
      "xp" : _calculateLeftoverPoints()
    };

    FirebaseAPI().updateUserData(map, _user.id);
  }


  int _calculateLeftoverPoints(){
    return _user.xp - _user.maxXp;
  }


  addPoints(int value){

    var map = {
      "xp" : _user.xp + value
    };

    FirebaseAPI().updateUserData(map, _user.id);
  }


  uploadPicture(File file) async{
   await FirebaseAPI().uploadProfilePicture(file).then((_) => notifyListeners());
  }

  takePhoto(){
   ImagesHelper.getSmallImageFromCamera().then((file){
     ImagesHelper.cropImage(file).then((croppedImage)=> uploadPicture(croppedImage)).catchError((error) => print);
   });

  }

   getPhoto(){
     ImagesHelper.getSmallImageFromGallery().then((file){
       ImagesHelper.cropImage(file).then((croppedImage)=> uploadPicture(croppedImage)).catchError((error) => print);
     });
   }



}