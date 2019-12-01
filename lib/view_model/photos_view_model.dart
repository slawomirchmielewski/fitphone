import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/images_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


enum PhotosView{
  Grid,
  List
}



class PhotosViewModel extends ChangeNotifier with WidgetsBindingObserver {

  String userId;

  String _tempPhotoName;

  List<PhotoModel> _photos = [];


  bool sortDescending = false;

  PhotosView _photosView  = PhotosView.Grid;

  PhotosView get photoView => _photosView;


  List<PhotoModel> get photos => _photos;

  String get tempPhotoName => _tempPhotoName;


  StreamSubscription _userStream;
  StreamSubscription _selfiStream;
  StreamSubscription _foldersStream;

  setPhotoView(PhotosView photosView){
    _photosView = photosView;
    notifyListeners();
  }


  setTempPhotoName(String name) {
    _tempPhotoName = name;
    notifyListeners();
  }


  PhotosViewModel() {
    WidgetsBinding.instance.addObserver(this);
    getUserStream();
  }

  getUserStream() async {
    _userStream = FirebaseAPI().checkLoginUser().listen((firebaseUser) {
      if (firebaseUser != null) {
        userId = firebaseUser.uid;
        getPhotos();
      }
    });
  }


  getPhotos() {
    _selfiStream = FirebaseAPI().getSelfie(userId).listen((snapshot) {
      _photos = [];

      if (snapshot.documents != null) {
        for (var photo in snapshot.documents) {
          PhotoModel photoModel = PhotoModel.fromMap(photo.data);
          photoModel.id = photo.documentID;
          _photos.add(photoModel);
        }

        print(_photos.length);

        notifyListeners();
      }
    });
  }



  Future<void> deletePhoto(PhotoModel photo) async {
    await FirebaseAPI().deletePhoto(userId, photo.id, photo.path);
    notifyListeners();
  }

    Future<void> updateName(PhotoModel photo) async {
    if (_tempPhotoName != null) {
      await FirebaseAPI()
          .updateSelfieName(userId, photo.id, _tempPhotoName)
          .then((_) {
        _tempPhotoName = null;
        notifyListeners();
      });
    }
  }


  uploadFile(File file) async {
    await FirebaseAPI().uploadSelfie(file).then((_) => notifyListeners());
  }

  takePhoto() {
    ImagesHelper.getBigImageFromCamera().then((file) {
      uploadFile(file).catchError((error) => print);
    });
  }

  getPhoto() {
    ImagesHelper.getBigImageFromGallery().then((file) {
      uploadFile(file).catchError((error) => print);
    });
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _userStream?.pause();
      _selfiStream?.pause();
      _foldersStream?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _userStream?.resume();
      _selfiStream?.resume();
      _foldersStream?.resume();
    }
  }

  @override
  void dispose() {
    _userStream?.cancel();
    _selfiStream?.cancel();
    _foldersStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  void sortPhotosList() {

    sortDescending = !sortDescending;

    if (sortDescending == true) {
      photos.sort((a, b) => b.date.compareTo(a.date));
    }
    else {
      photos.sort((a, b) => a.date.compareTo(b.date));
    }
    notifyListeners();
  }

}