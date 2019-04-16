import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/model/program_model.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/day_converter.dart';
import 'package:fitphone/utils/preferences_controller.dart';
import 'package:rxdart/rxdart.dart';

class ExerciseBloc implements BlocBase {


  List<String> tempData = [];


  final _workoutController = BehaviorSubject<List<WorkoutModel>>();
  Stream<List<WorkoutModel>> get getWorkoutsList => _workoutController.stream;


  final _exerciseController = BehaviorSubject<List<ExerciseModel>>();
  Stream<List<ExerciseModel>> get getExerciseList => _exerciseController.stream;
  Function(List<ExerciseModel>) get setExerciseList => _exerciseController.sink.add;

  final _pageIndexController = BehaviorSubject.seeded(0);

  Stream<int> get getPageIndex => _pageIndexController.stream;

  Function(int) get setPageIndex => _pageIndexController.sink.add;

  final _doneExerciseController = BehaviorSubject.seeded(0);

  Stream<int> get getDoneExerciseCounter => _doneExerciseController.stream;

  Function(int) get setDoneExerciseCounter => _doneExerciseController.sink.add;


  final _currentPageController = BehaviorSubject.seeded(0);

  Stream<int> get getCurrentPage => _currentPageController.stream;

  Function(int) get setCurrentPage => _currentPageController.sink.add;

  final _progressBarValueController = BehaviorSubject.seeded(0.0);

  Stream<double> get getProgressBarValue => _progressBarValueController.stream;

  Function(double) get setProgressBarValue => _progressBarValueController.sink.add;

  final _doneWorkoutController = BehaviorSubject.seeded(false);

  Stream<bool> get getIsWorkoutDone => _doneWorkoutController.stream;

  Function(bool) get setIsWorkoutDone => _doneWorkoutController.sink.add;


  final _totalWeightController = BehaviorSubject.seeded(0.0);

  Stream<double> get getTotalWeight => _totalWeightController.stream;

  Function(double) get setTotalWeight => _totalWeightController.sink.add;


  final _programNotificationController = BehaviorSubject.seeded(false);

  Stream<bool> get getProgramNotification => _programNotificationController.stream;

  Function(bool) get setProgramNotification => _programNotificationController.sink.add;


  final _exercisesController = BehaviorSubject<List<String>>();

  Stream<List<String>> get getExercisesNames => _exercisesController.stream;

  final _programNamesController = BehaviorSubject<List<String>>();

  Stream<List<String>> get getProgramNames => _programNamesController.stream;


  ExerciseBloc(){


    _currentPageController.stream.listen((data){
        if(data != null){
          _calculatePrograssValue(data);
        }
      }
    );
    _doneExerciseController.stream.listen((data) => _checkDoneExercisec(data));

    _programNamesController.stream.listen((data){
      if(tempData.length != 0 && tempData.length != data.length){
        _programNotificationController.sink.add(true);
      }

      tempData = data;

    });
  }

   _calculatePrograssValue(int data){

    List<ExerciseModel> list = _exerciseController.stream.value;

    if(list != null){
      if(data >= 0 && data < list.length ){
        double progress = data/(list.length -1);
        _progressBarValueController.sink.add(progress);
      }
    }
   }


   incrementDoneExerciseCounter(){
    int doneExercise = _doneExerciseController.stream.value;
    _doneExerciseController.sink.add(doneExercise + 1);
   }

   incrementTotalWeight(double value){
     double currentWeight = _totalWeightController.stream.value;
     _totalWeightController.sink.add(currentWeight + value);

   }

   incrementPageIndex(){
      final int pageIndex = _pageIndexController.stream.value;
      final int pagesCount = _exerciseController.stream.value.length;

      if(pageIndex < pagesCount -1){
        _pageIndexController.sink.add(pageIndex +1);
      }
      else if(pageIndex == pagesCount - 1){
        _doneWorkoutController.sink.add(true);
        _pageIndexController.sink.add(0);
        _doneExerciseController.sink.add(0);
        _currentPageController.sink.add(0);
      }

   }

   _checkDoneExercisec(int doneExercises){
      final int pageIndex = _pageIndexController.stream.value;
      final List<ExerciseModel> list = _exerciseController.stream.value;

      if(list != null && pageIndex != null){
        int setsCount = list[pageIndex].set;

        if(doneExercises == setsCount){
          incrementPageIndex();
          _doneExerciseController.sink.add(0);
        }
      }
   }

   setPrimaryProgram(String workout) async {
     await FirebaseUserAPI().updateUserProfile({"primary workout" : workout}).catchError((error) => print);
   }
   
   
   getWorkout() async {

     List<ExerciseModel> exercisesList = [];

     List<String> programsList = _programNamesController.stream.value;

     if(programsList != null) {
       String program = programsList.last;
       String programType;

       String userId = await FirebaseUserAPI().getCurrentUser().then((
           user) => user.uid);

       await FirebaseUserAPI().getUserDataOnce(userId).then((snapshot) {
         User user = User.fromSnapshot(snapshot);
         programType = user.primaryWorkout;
       });

       String workoutDay = DayConverter.getDay(DateTime.now().weekday);

       await FirebaseUserAPI().getWorkout(program, programType, workoutDay).then((snapshot) {

         if (snapshot.value != null) {
           Map<dynamic, dynamic> e = Map.from(snapshot.value);

           if (e != null) {
             e.values.forEach((f) {
               ExerciseModel exerciseModel = ExerciseModel.formMap(f);
               exercisesList.add(exerciseModel);
             });
           }
         }
       });
     }

     _exerciseController.sink.add(exercisesList);

   }


   getProgramsNames(){
    Observable(FirebaseUserAPI().getProgramsName()).listen((event){

        List<String> programs = [];

          if(event.snapshot.value != null){

            Map<dynamic,dynamic> m = event.snapshot.value;


            m?.forEach((key,value){
              print("Event key $key");
              List<String> programsNames = key.split("\n");
              programsNames.forEach((f) => programs.add(f));

              PreferencesController().getLastProgramName().then((value){
                if(programs.last != value){
                  _programNotificationController.sink.add(true);
                  PreferencesController().saveLastProgramName(programs.last);
                }
              });
            });
          }
        _programNamesController.sink.add(programs);
    });
   }


   getWorkouts() async {

    List<WorkoutModel> workouts = [];

    List<String> program = _programNamesController.stream.value;
    String programType;


    if(program?.length != null) {

      String userId = await FirebaseUserAPI().getCurrentUser().then((user) => user.uid);

      await FirebaseUserAPI().getUserDataOnce(userId).then((snapshot){
        User user = User.fromSnapshot(snapshot);
        programType = user.primaryWorkout;
      });

      await FirebaseUserAPI().getWorkoutsDay(program.last, programType).then((snapshot){


        if(snapshot.value != null){
          Map<dynamic,dynamic> m = snapshot.value;

          m?.forEach((key,value) {
            WorkoutModel workoutModel = WorkoutModel(name:key ,exercises:[]);

            if(value != null){
              Map<String,dynamic> exercise = Map.from(value);
              exercise.values.forEach((f){
                if(f != null){
                  ExerciseModel exerciseModel = ExerciseModel.formMap(f);
                  workoutModel.exercises.add(exerciseModel);
                }
              });
            }
            workouts.add(workoutModel);
          });
        }
      });

    }
    _workoutController.sink.add(workouts);

   }


    @override
    void dispose() {
      _workoutController.close();
      _exerciseController.close();
      _pageIndexController.close();
      _doneExerciseController.close();
      _currentPageController.close();
      _progressBarValueController.close();
      _doneWorkoutController.close();
      _totalWeightController.close();
      _programNotificationController.close();
      _exercisesController.close();
      _programNamesController.close();
    }

  String getWorkoutDay() {
    return "Workout A";
  }
}