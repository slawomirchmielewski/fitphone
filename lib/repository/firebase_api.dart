import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/utils/firebase_result.dart';
import 'package:fitphone/utils/passcode.dart';
import 'package:intl/intl.dart';

class FirebaseUserAPI {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseResultCallback> loginUserWithEmailAndPassword(String email , String password) async {

    FirebaseResultCallback firebaseResultCallback = new FirebaseResultCallback();

    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value){
      if(value != null){
        firebaseResultCallback.success = true;
        firebaseResultCallback.error = "";
      }
    }).catchError((error){
      firebaseResultCallback.success = false;
      firebaseResultCallback.error = error.toString();
    });

    return firebaseResultCallback;
  }

  Future<FirebaseResultCallback> registerUserWithEmailAndPassword(String name, String email, String password, String passcode) async{

    FirebaseResultCallback firebaseResultCallback  = FirebaseResultCallback();

    if(passcode == Passcode().passcode){

      User user = User.empty(name: name);

      var userData = {
        "name" : user.name,
        "level" : user.level,
        "photoUrl" : user.photoUrl,
        "workout completed" : user.workoutsCompleted,
        "currents points" : user.points,
        "goal points": user.goalPoints,
        "weight" : user.weight,
        "weightUnit" : user.weightUnit,
        "carbs" : user.carbs,
        "calories" : user.calories,
        "fat" : user.fat,
        "protein": user.protein,
        "primary workout" : user.primaryWorkout
      };

      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((value){


        if(value != null){
          firebaseResultCallback.success = true;
          firebaseResultCallback.error = "";

          String userId = value.uid;

          Firestore.instance.collection("users").document(userId).setData(userData);

          getCurrentUser().then((firebaseUser){
            UserUpdateInfo info = UserUpdateInfo();
            info.displayName = name;
            firebaseUser.updateProfile(info);
          });


        }
      }).catchError((error){
        firebaseResultCallback.success = false;
        firebaseResultCallback.error = error.toString();
      });

    }

    else {
        firebaseResultCallback.success = false;
        firebaseResultCallback.error = "Wrong Passcode";
    }


    return firebaseResultCallback;

  }


  Stream<DocumentSnapshot> listeningForUserData(String id) {


    Stream<DocumentSnapshot> snap = Firestore.instance.collection("users").document(id).snapshots();


    return id != null ? snap : null;

  }
  
  
  Stream<QuerySnapshot> listeningForWeightData(String id){

    Stream<QuerySnapshot> snapQuery = Firestore.instance.collection("users").document(id).collection("weights").snapshots();
    
    return id != null ? snapQuery : null;
  }


  Stream<QuerySnapshot> listeningForImageFoldersData(String id){


    Stream<QuerySnapshot> snapQuery = Firestore.instance.collection("users").document(id).collection("photos").snapshots();

    return id != null ? snapQuery : null;
  }

  Stream<QuerySnapshot> listeningForImagesData(String id){

    Stream<QuerySnapshot> snapQuery = Firestore.instance.collection("users").document(id).collection("photos").snapshots();

    return id != null ? snapQuery : null;
  }
 

  Stream<FirebaseUser> checkLoginUser(){

    return _firebaseAuth.onAuthStateChanged;
  }


  Future<FirebaseUser> getCurrentUser() async{
    return await FirebaseAuth.instance.currentUser().then((firebaseUser) => firebaseUser).catchError((onError) => print).catchError((error)=>print);
  }

  Future<Null> signOutUser() async {
     await _firebaseAuth.signOut().catchError((error) => print);
  }

  Future<bool> updateUserProfile(Map<String,dynamic> map) async{

    getCurrentUser().then((user){
      try{
        if(user !=null){
          DocumentReference ref = Firestore.instance.collection("users").document(user.uid);

          Firestore.instance.runTransaction((Transaction transaction) async {
            DocumentSnapshot snap = await transaction.get(ref);
            if(snap.exists){
              await transaction.update(snap.reference,map);
            }
          });
        }
      }
      catch(e){
        print("User error ${e.toString()}");
        return false;
      }
    });

    return true;
  }


  Future<String> getWeightUnit() async{

    User user;

    try{
      var id = await getCurrentUser().then((user) => user.uid);

      if(id != null){
         DocumentSnapshot snap = await Firestore.instance.collection("users").document(id).get();
         
        if(snap.exists){
          user = User.fromMap(snap.data);
        }

        return user.weightUnit;
      }
    }catch(e){
      print(e.toString());
    }

    return "";

  }


  Future<FirebaseResultCallback> resetPassword(String email) async{

    try{
      FirebaseResultCallback resultCallback = FirebaseResultCallback();

      await _firebaseAuth.sendPasswordResetEmail(email: email).then((_){

        resultCallback.success = true;

      }).catchError((onError) => resultCallback.error = "Resset Feild");

      return resultCallback;

    }catch(e){
      print(e.toString());
    }


    return null;


  }


  Future<Null> uploadProfilePicture(File file) async{


     var id = await getCurrentUser().then((user)=> user.uid);

     if(id != null){
       StorageReference ref = FirebaseStorage.instance.ref().child("Photos_$id/profileImage$id");
       StorageUploadTask task = ref.putFile(file);

       StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
       String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL().catchError((error) => print);

       var map = {"photoUrl" : downloadUrl};
       updateUserProfile(map);
     }
  }

  Future<Null> uploadSelfie(File file) async{

    var id = await getCurrentUser().then((user)=> user.uid);

    String folderName = new DateFormat.yMMMd().format(new DateTime.now()).toString();

    if(id != null){
      StorageReference ref = FirebaseStorage.instance.ref().child("Photos_$id/$folderName/${id}image${Timestamp.now()}");
      StorageUploadTask task = ref.putFile(file);

      StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();


      PhotoModel photoModel = PhotoModel(url: downloadUrl, date: Timestamp.now().toDate());

      var map = photoModel.toMap();
      var folderMap = {"date" : folderName};

      await Firestore.instance.collection("users").document(id).collection("photos").document().setData(map,merge: true);
    }
  }

  Future<Null> addWeight(double weight) async{

    FirebaseUser user = await getCurrentUser().then((user) => user);

    if(user != null){

      var map = {
        "weight" : weight,
        "date" : Timestamp.now()
      };

      await Firestore.instance.collection("users").document(user.uid).collection("weights").document().setData(map,merge: true);
    }


  }

  Future<QuerySnapshot> getWorkout(String programName,String workoutName) async{
    return await Firestore.instance.collection("programs").document(programName).collection(workoutName).getDocuments();
  }

  Future<QuerySnapshot> getPrograms() async {
    return await Firestore.instance.collection("programs").getDocuments();
  }


}


FirebaseUserAPI firebaseAPI = FirebaseUserAPI();