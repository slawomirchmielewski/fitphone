import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:fitphone/model/folder_model.dart';
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
  String _tempFolderName;

  String _tempPhotoName;

  List<PhotoModel> _photos = [];
  List<Folder> _folders = [];


  bool sortDescending = false;

  PhotosView _photosView  = PhotosView.Grid;

  PhotosView get photoView => _photosView;


  List<int> _colors = [
    0xFFF7D488,
    0xFF00E8B5,
    0xFFA47963,
    0xFFA997DF,
    0xFFDCCFEC,
    0xFFFFE975,
    0xFF28C8E8,
    0XFFab1749,
    0xFFec8248,
    0xFF654bd6,
    0xFF73ab5c,
    0XFF7387b0
  ];

  String _tempFolderColor = "0xFFF7D488";


  List<PhotoModel> get photos => _photos;

  List<Folder> get folders => _folders;

  List<int> get colors => _colors;

  String get tempFolderName => _tempFolderName;

  String get temFolderColor => _tempFolderColor;

  String get tempPhotoName => _tempPhotoName;


  StreamSubscription _userStream;
  StreamSubscription _selfiStream;
  StreamSubscription _foldersStream;

  setPhotoView(PhotosView photosView){
    _photosView = photosView;
    notifyListeners();
  }


  setTempFolderName(String name) {
    _tempFolderName = name;
    notifyListeners();
  }

  setTempFolderColor(String color) {
    _tempFolderColor = color;
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
        getFolders();
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


  Future<List<PhotoModel>> getPhotoFromFolder(Folder folder) async {
    List<PhotoModel> photosList = [];

    await FirebaseAPI().getPhotosFromFolder(userId, folder.name).then((
        snapshot) {
      if (snapshot.documents != null) {
        for (var photo in snapshot.documents) {
          PhotoModel photoModel = PhotoModel.fromMap(photo.data);
          photoModel.id = photo.documentID;
          photosList.add(photoModel);
        }
      }
    });

    print("Get photos");

    return photosList;
  }

  getFolders() {
    _foldersStream = FirebaseAPI().getPhotoFolders(userId).listen((snapshot) {
      _folders = [];

      if (snapshot.documents != null) {
        for (var f in snapshot.documents) {
          Folder folder = Folder.fromMap(f.data);
          folder.id = f.documentID;
          _folders.add(folder);
        }
        notifyListeners();
      }
    });
  }


  Future<void> addFolder() async {
    Map<String, dynamic> map = {};

    if (_tempFolderName == null) {
      map = {
        "name": "New Folder",
        "color": _tempFolderColor,
      };
    }

    if (_tempFolderColor == null) {
      map = {
        "name": _tempFolderName,
        "color": 0xFF5F5F5F,
      };
    }
    else {
      map = {
        "name": _tempFolderName,
        "color": _tempFolderColor
      };
    }

    await FirebaseAPI().addPhotosFolder(userId, map);
  }

  Future<void> deleteFolder(Folder folder) async {
    List<PhotoModel> photos = await getPhotoFromFolder(folder);

    for (var photo in photos) {
      deletePhoto(photo);
    }
    await FirebaseAPI().deletePhotoFolder(userId, folder.id);
  }


  Future<void> deletePhoto(PhotoModel photo) async {
    await FirebaseAPI().deletePhoto(userId, photo.id, photo.path);
    notifyListeners();
  }


  Future<void> addToFolder(PhotoModel photoModel, Folder folder) async {
    await FirebaseAPI().updateSelfieFolder(userId, photoModel.id, folder.name);
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
      _userStream.pause();
      _selfiStream.pause();
      _foldersStream.pause();
    } else if (state == AppLifecycleState.resumed) {
      _userStream.resume();
      _selfiStream.resume();
      _foldersStream.resume();
    }
  }

  @override
  void dispose() {
    _userStream.cancel();
    _selfiStream.cancel();
    _foldersStream.cancel();
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