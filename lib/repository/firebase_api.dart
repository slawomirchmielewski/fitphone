import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitphone/model/account_info_model.dart';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/model/program_model.dart';
import 'package:fitphone/model/programs_info_model.dart';
import 'package:fitphone/model/settings_model.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:fitphone/utils/firebase_result.dart';
import 'package:fitphone/utils/passcode.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAPI {
  static final FirebaseAPI _singleton = FirebaseAPI._internal();
  FirebaseAuth _firebaseAuth;
  Firestore _firestore;

  factory FirebaseAPI() {
    return _singleton;
  }

  FirebaseAPI._internal() {
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
  }


  Future<FirebaseResultCallback> loginUserWithEmailAndPassword(String email, String password) async {
    FirebaseResultCallback firebaseResultCallback = new FirebaseResultCallback();

    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) {
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

  Future<FirebaseResultCallback> registerUserWithEmailAndPassword(String name, String email, String password, String passcode) async {
    FirebaseResultCallback firebaseResultCallback = FirebaseResultCallback();

    if (passcode == Passcode().passcode) {

      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((result) {
        if (result != null) {
          firebaseResultCallback.success = true;
          firebaseResultCallback.error = "";
          _firestore.collection("users").document(result.user.uid).setData(User.init(result.user.uid, name, DateTime.now().millisecondsSinceEpoch).toMap());
          _firestore.collection(("users")).document((result.user.uid)).collection("settings").document("settings").setData(Settings.init().toMap());
          _firestore.collection(("users")).document((result.user.uid)).collection("program_info").document("program_info").setData(ProgramInfo.init().toMap());
          _firestore.collection(("users")).document((result.user.uid)).collection("account_info").document("account_info").setData(AccountInfo.init().toMap());
          _initializeDate(result.user.uid);

          getLatestProgramOne().then((value){
            for(var p in value.documents){
              Program program = Program.fromMap(p.data);
              program.referenceId = p.documentID;

              addProgram(program.toMap(), result.user.uid).then((id){
                getGlobalExercises(p.documentID).then((snapshot){
                  for(var s in snapshot.documents){

                    Exercise exercise = Exercise.fromMap(s.data);

                    addExercise(result.user.uid,id, exercise.toMap());

                  }
                });
              });
              updateProgramInfo(result.user.uid, {"primaryProgram": program.name});
            }
          });


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



  _initializeDate(String userId){

    var map = {
      "week" : DateHelper.getWeekNumber(DateTime.now()),
      "month" : DateTime.now().month,
      "year" : DateTime.now().year
    };

    addDate(userId, map);
  }

  Stream<DocumentSnapshot>getUserData(String id){
    return _firestore.collection("users").document(id).snapshots();
  }

  Future<DataSnapshot> getUserDataOnce(String id){
    return null;
  }

  updateUserData(Map<String,dynamic> data, String userId) async {
    await _firestore.collection("users").document(userId).setData(data,merge: true);
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
      String path = "Photos_$id/profileImage$id";
      StorageReference ref = FirebaseStorage.instance.ref().child(path);
      StorageUploadTask task = ref.putFile(file);
      StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref
          .getDownloadURL()
          .catchError((error) => print);

      var map = {"photoUrl" : downloadUrl};

      _firestore.collection("users").document(id).updateData(map);

    }
  }

  Future<void> uploadSelfie(File file) async {

    var id = await getCurrentUser().then((user) => user.uid);

    String folderName = new DateFormat.yMMMd().format(new DateTime.now()).toString();

    if (id != null) {

      String path = "Photos_$id/$folderName/${id}image${randomString(10)}";
      StorageReference ref = FirebaseStorage.instance.ref().child(path);
      StorageUploadTask task = ref.putFile(file);

      StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      PhotoModel photoModel = PhotoModel(
          url: downloadUrl,
          date: DateTime.now().millisecondsSinceEpoch,
          name: "New photo",
          path: path
      );

      final photoData = photoModel.toMap();

      _firestore.collection("users").document(id).collection("photos").add(photoData);

    }

    return "";
  }

  Future<void> updateSelfieFolder(String userId , String photosId,String folderName ) async{
    await  _firestore.collection("users").document(userId).collection("photos").document(photosId).updateData({"folder" : folderName});
  }

  Future<void> updateSelfieName(String userId , String photosId,String name ) async{
    await  _firestore.collection("users").document(userId).collection("photos").document(photosId).updateData({"name" : name});
  }

  Stream<QuerySnapshot>getSelfie(String id){
    return _firestore.collection("users").document(id).collection("photos").orderBy("date").snapshots();
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  addWeight(String id ,double weight) async {

    var date = DateTime.now();

    if (id != null) {
      var weightData = {
        "weight": weight,
        "date": date.millisecondsSinceEpoch,
        "day" : date.day,
        "week" : weekNumber(date),
        "month" : date.month,
        "year" : date.year
      };

    await _firestore.collection("users").document(id).collection("weights").add(weightData);
    }
  }

  Stream<QuerySnapshot> getWeights(String id){
    return  _firestore.collection("users").document(id).collection("weights").snapshots();
  }

  addNutritions(Map<String,dynamic> map) async{
    var id = await getCurrentUser().then((user) => user.uid).catchError((error) => print(error?.toString()));
    await _firestore.collection("users").document(id).collection("nutritions").document("nutritions").setData(map,merge: true);
  }


  updateNutritions(Map<String,dynamic> map) async{
    var id = await getCurrentUser().then((user) => user.uid).catchError((error) => print(error?.toString()));
    await _firestore.collection("users").document(id).collection("nutritions").document("nutritions").updateData(map);
  }
  
  setTheme(String theme , String userId) async{

    var map = {"theme" : theme};

    await _firestore.collection("users").document(userId).collection("settings").document("settings").updateData(map);
  }

  setUnit(String unit , String userId) async{

    var map = {"units" : unit};

    await _firestore.collection("users").document(userId).collection("settings").document("settings").updateData(map);
  }

  addDate(String userId,Map<String,dynamic> map) async {
    await _firestore.collection("users").document(userId).collection("date").document("date").setData(map);
  }

  updateDate(String userId,Map<String,dynamic> map) async {
    await _firestore.collection("users").document(userId).collection("date").document("date").updateData(map);
  }


  addExercise(String userId ,String programID,Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("programs").document(programID).collection("exercises").add(map);
  }


  addMeasurements(String userId, Map<String,dynamic> map) async{
    await  _firestore.collection("users").document(userId).collection("measurements").add(map);
  }

  Future<String>addProgram(Map<String,dynamic> map, String userId) async{
    return await _firestore.collection("users").document(userId).collection("programs").add(map).then((ref) => ref.documentID);
  }

  addPhotosFolder(String userId, Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("folders").add(map);
  }

  updatePhotosFolder(String userId,String folderId, Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("folders").document(folderId).updateData(map);
  }

  updateProgramInfo(String userId, Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("program_info").document("program_info").updateData(map);
  }

  updateExercise(String userId,String programId,String exerciseId, Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("programs").document(programId).collection("exercises").document(exerciseId).setData(map,merge: true);
  }

  addFeedback(Map<String,dynamic> map) async{
    await _firestore.collection("feedback").add(map);
  }

  addDoneWorkout(String userId, Map<String,dynamic> map ) async{
    await _firestore.collection("users").document(userId).collection("done_workouts").add(map);
  }

  addMonthlyAvgWeight(String userId,Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("month_avg_weight").add(map);
  }

  updateMonthlyAvgWeight(String userId,String documentId, Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("month_avg_weight").document(documentId).updateData(map);
  }


  addMonthlyAvgMeasurements(String userId,Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("month_avg_measurement").add(map);
  }

  updateMonthlyAvgMeasurements(String userId,String documentId, Map<String,dynamic> map) async{
    await _firestore.collection("users").document(userId).collection("month_avg_measurement").document(documentId).updateData(map);
  }
  
  Future<void> deleteWeight(String userId, String weightId) async{
    await _firestore.collection("users").document(userId).collection("weights").document(weightId).delete();
  }

  Future<void> deletePhotoFolder(String userId, String folderId) async {
    await _firestore.collection("users").document((userId)).collection("folders").document(folderId).delete();
  }

  Future<void> deletePhoto(String userId, String photoId, String photoPath) async {

    StorageReference ref = FirebaseStorage.instance.ref().child(photoPath);
    await ref.delete().then((_){
      _firestore.collection("users").document((userId)).collection("photos").document(photoId).delete();
    });
  }

  Stream<DocumentSnapshot> getNutritions(String id){
    return  _firestore.collection("users").document(id).collection("nutritions").document("nutritions").snapshots();
  }

  Stream<DocumentSnapshot> getSettings(String id){
    return  _firestore.collection("users").document(id).collection("settings").document("settings").snapshots();
  }

  Future<DocumentSnapshot> getSettingOnce(String id) async{
   return await _firestore.collection("users").document(id).collection("settings").document("settings").get();
  }

  Stream<QuerySnapshot> getLatestProgram(){
   return _firestore.collection("programs").orderBy("date",descending: true).limit(1).snapshots();
  }

  Future<QuerySnapshot> getLatestProgramOne(){
    return _firestore.collection("programs").orderBy("date",descending: true).limit(1).getDocuments(source: Source.server);
  }

  Stream<QuerySnapshot> getPrograms(String userId) {
    return _firestore.collection("users").document(userId).collection("programs").orderBy("date",descending: true).snapshots();
  }

  Stream<DocumentSnapshot> getProgramInfo(String userId){
    return _firestore.collection("users").document(userId).collection("program_info").document("program_info").snapshots();
  }

  Stream<DocumentSnapshot> getAccountInfo(String userId){
    return _firestore.collection("users").document(userId).collection("account_info").document("account_info").snapshots();
  }
  
  Stream<QuerySnapshot> getExercises(String userId,String programId){
    return _firestore.collection("users").document(userId).collection("programs").document(programId).collection("exercises").orderBy("order").snapshots();
  }

  Future<QuerySnapshot> getGlobalExercises(String programId) async {
    return await _firestore.collection("programs").document(programId).collection("exercises").getDocuments();
  }

  Stream<QuerySnapshot> getWeightFromWeek(String id ,int week, int year){
    return  _firestore.collection("users").document(id).collection("weights").where("week" ,isEqualTo: week).where("year",isEqualTo: year).snapshots();
  }

  Stream<QuerySnapshot> getWeightFromMonth(String id ,int month,int year){
    return  _firestore.collection("users").document(id).collection("weights").where("month" ,isEqualTo: month).where("year",isEqualTo: year).snapshots();
  }

  Future<QuerySnapshot> getWeightFromMonthOne(String id ,int month,int year) async{
    return await _firestore.collection("users").document(id).collection("weights").where("month" ,isEqualTo: month).where("year",isEqualTo: year).getDocuments();
  }

  Stream<QuerySnapshot> getPhotoFolders(String userId){
    return _firestore.collection("users").document(userId).collection("folders").snapshots();
  }

  Future<QuerySnapshot> getPhotosFromFolder(String userId,String folderName) async{
    return await _firestore.collection("users").document(userId).collection("photos").where("folder",isEqualTo: folderName).getDocuments();
  }


  Stream<QuerySnapshot> getDoneWorkouts(String userId){
   return _firestore.collection("users").document(userId).collection("done_workouts").orderBy("date",descending: true).snapshots();
  }

  Stream<DocumentSnapshot> getDate(String userId){
    return _firestore.collection("users").document(userId).collection("date").document("date").snapshots();
  }
  
  Stream<QuerySnapshot> getMonthlyAvgWeight(String userId, int year) {
    return _firestore.collection("users").document(userId).collection("month_avg_weight").where("year",isEqualTo: year).snapshots();
  }

  Stream<QuerySnapshot> getCurrentWeight(String userId){
    return _firestore.collection("users").document(userId).collection("weights").orderBy("date",descending: true).limit(1).snapshots();
  }

  Stream<QuerySnapshot> getMeasurementsFromWeek(String userId,int week,int year){
    return _firestore.collection("users").document(userId).collection("measurements").where("week",isEqualTo: week).where("year",isEqualTo: year).snapshots();

  }

  Stream<QuerySnapshot> getMeasurementsFromMonth(String userId,int month,int year){
    return _firestore.collection("users").document(userId).collection("measurements").where("month",isEqualTo: month).where("year",isEqualTo: year).snapshots();

  }

  Stream<QuerySnapshot> getMeasurementsFromYear(String userId,int year){
    return _firestore.collection("users").document(userId).collection("month_avg_weight").where("year",isEqualTo: year).snapshots();

  }
}
