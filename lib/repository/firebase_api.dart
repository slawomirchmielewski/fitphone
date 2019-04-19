import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/utils/firebase_result.dart';
import 'package:fitphone/utils/passcode.dart';
import 'package:intl/intl.dart';

class FirebaseUserAPI {
  static final FirebaseUserAPI _singleton = FirebaseUserAPI._internal();
  FirebaseAuth _firebaseAuth;
  FirebaseDatabase _firebaseDatabase;
  FirebaseApp _firebaseApp;
  DatabaseReference database;

  factory FirebaseUserAPI() {
    return _singleton;
  }

  FirebaseUserAPI._internal() {
    setAppFirebase();
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseDatabase = FirebaseDatabase(app: _firebaseApp);
    _firebaseDatabase.setPersistenceEnabled(true);
    _firebaseDatabase.setPersistenceCacheSizeBytes(10000000);
    database = _firebaseDatabase.reference();
  }

  setAppFirebase() async {
    _firebaseApp = await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
          ? const FirebaseOptions(
              googleAppID: '1:81463391287:ios:04e19056661a789d',
              gcmSenderID: '81463391287',
              databaseURL: 'https://fitphone-93ca4.firebaseio.com',
            )
          : const FirebaseOptions(
              googleAppID: '1:81463391287:ios:04e19056661a789d',
              apiKey: 'AIzaSyBIHZ4uB7-sZKwS1rMG4_1s8XpoTrItdyA',
              databaseURL: 'https://fitphone-93ca4.firebaseio.com',
            ),
    );
  }

  Future<FirebaseResultCallback> loginUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseResultCallback firebaseResultCallback =
        new FirebaseResultCallback();

    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      if (value != null) {
        firebaseResultCallback.success = true;
        firebaseResultCallback.error = "";
      }
    }).catchError((error) {
      firebaseResultCallback.success = false;
      firebaseResultCallback.error = error.toString();
    });

    return firebaseResultCallback;
  }

  Future<FirebaseResultCallback> registerUserWithEmailAndPassword(
      String name, String email, String password, String passcode) async {
    FirebaseResultCallback firebaseResultCallback = FirebaseResultCallback();

    if (passcode == Passcode().passcode) {

      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        if (user != null) {
          firebaseResultCallback.success = true;
          firebaseResultCallback.error = "";
          database.child("users").child(user.uid).child("profile").set(User.empty(name: name).toMap());
        }
      }).catchError((error) {
        firebaseResultCallback.success = false;
        firebaseResultCallback.error = error.toString();
      });
    } else {
      firebaseResultCallback.success = false;
      firebaseResultCallback.error = "Wrong Passcode";
    }

    return firebaseResultCallback;
  }

  Stream<Event>getUserData(String id){
    return database.child("users").child(id).child("profile").onValue;
  }

  Future<DataSnapshot> getUserDataOnce(String id){
    return database.child("users").child(id).child("profile").once();
  }

  updateUserProfile(Map<String,dynamic> data) async{
    var userId = await getCurrentUser().then((user) => user.uid).catchError((error) => print(error?.toString()));
    database.child("users").child(userId).child("profile").update(data);
  }

  Stream<FirebaseUser> checkLoginUser() {
    return _firebaseAuth.onAuthStateChanged;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await FirebaseAuth.instance
        .currentUser()
        .then((firebaseUser) => firebaseUser)
        .catchError((onError) => print)
        .catchError((error) => print);
  }

  Future<Null> signOutUser() async {
    await _firebaseAuth.signOut().catchError((error) => print);
  }

  
  Future<FirebaseResultCallback> resetPassword(String email) async {
    try {
      FirebaseResultCallback resultCallback = FirebaseResultCallback();

      await _firebaseAuth.sendPasswordResetEmail(email: email).then((_) {
        resultCallback.success = true;
      }).catchError((onError) => resultCallback.error = "Resset Feild");

      return resultCallback;
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  Future<Null> uploadProfilePicture(File file) async {
    var id = await getCurrentUser().then((user) => user.uid);

    if (id != null) {
      StorageReference ref =
          FirebaseStorage.instance.ref().child("Photos_$id/profileImage$id");
      StorageUploadTask task = ref.putFile(file);

      StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref
          .getDownloadURL()
          .catchError((error) => print);

      var map = {"photoUrl": downloadUrl};

      await database
          .child("users")
          .child(id)
          .child("profile").update(map);
    }
  }

  Future<Null> uploadSelfie(File file) async {
    var id = await getCurrentUser().then((user) => user.uid);

    String folderName = new DateFormat.yMMMd().format(new DateTime.now()).toString();

    if (id != null) {
      StorageReference ref = FirebaseStorage.instance.ref().child("Photos_$id/$folderName/${id}image${DateFormat.HOUR24_MINUTE}");
      StorageUploadTask task = ref.putFile(file);

      StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      PhotoModel photoModel = PhotoModel(url: downloadUrl, date: DateFormat.yMMMd().format(new DateTime.now()).toString());

      var photoData = photoModel.toMap();

      await database
          .child("users")
          .child(id)
          .child("photos")
          .push()
          .set(photoData);
    }
  }


  Stream<Event>getPhotos(String id){
    return database.child("users").child(id).child("photos").onValue;
  }

  addWeight(double weight) async {
    var id = await getCurrentUser().then((user) => user.uid).catchError((error) => print(error?.toString()));
    var date = DateFormat.yMMMd().format(new DateTime.now()).toString();

    if (id != null) {
      var weightData = {
        "weight": weight,
        "date": date
      };

      await database.child("users").child(id).child("weights").child(date).set(weightData);
    }
  }


  Stream<Event> getWeights(String id){
    return database.child("users").child(id).child("weights").onValue.handleError((error) => print(error?.toString()));
  }

  Future<String> getWeightUnit() async{
    
    var userId = await getCurrentUser().then((user) => user.uid).catchError((error) => print(error?.toString()));
    if(userId !=null){
      Future<String> result = database.child("users").child(userId).child("profile").child("weightUnit").once().then((data) => data.value);
      return result;
    }
    return Future.value("");
  }


  Future<DataSnapshot> getWorkout(String program, String programType, String workoutDay) async{
    return await  database.child("programs").child(program).child(programType).child(workoutDay).once();
  }

  Future<DataSnapshot> getWorkoutsDay(String program, String programType) async{
    return await database.child("programs").child(program).child(programType).once();
  }

  Future<DataSnapshot> getProgramsName(){
    return database.child("programs").once();
  }
}
