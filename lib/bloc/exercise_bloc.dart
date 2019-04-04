import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/model/program_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fitphone/repository/firebase_api.dart';

class ExerciseBloc implements BlocBase {


  final _programController = BehaviorSubject<List<ProgramModel>>();
  Stream<List<ProgramModel>> get getPrograms => _programController.stream;

  final _workoutController = BehaviorSubject<List<ExerciseModel>>();
  Stream<List<ExerciseModel>> get getExerciseList => _workoutController.stream;
  Function(List<ExerciseModel>) get setExerciseList => _workoutController.sink.add;

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


  final _programsController = BehaviorSubject<List<String>>();

  Stream<List<String>> get getProgramsNames => _programsController.stream;


  ExerciseBloc(){

    List<String> list= [];


    _programsController.sink.add(list);

    List<ExerciseModel> exList = [
      ExerciseModel(
      name: "Back Squats",
      reps: "6-8",
      set:  4,
      url: "https://www.youtube.com/watch?v=qTDYVZ9HslI&feature=youtu.be"
    ),
    ExerciseModel(
        name: "BB Romanian Deadlifts",
        reps: "6-8",
        set:  4,
        url: "https://www.youtube.com/watch?v=Zu9RVJvnHyE&feature=youtu.be"
    ),
      ExerciseModel(
          name: "Back Squats",
          reps: "6-8",
          set:  4,
          url: "https://www.youtube.com/watch?v=qTDYVZ9HslI&feature=youtu.be"
      ),
      ExerciseModel(
          name: "BB Romanian Deadlifts",
          reps: "6-8",
          set:  4,
          url: "https://www.youtube.com/watch?v=Zu9RVJvnHyE&feature=youtu.be"
      )
    ];


    _workoutController.sink.add(exList);
    _currentPageController.stream.listen((data) =>_calculatePrograssValue(data));
    _doneExerciseController.stream.listen((data) => _checkDoneExercisec(data));
  }

   _calculatePrograssValue(int data){

     if(data >= 0 && data < _workoutController.stream.value.length){
       double progress = data/(_workoutController.stream.value.length -1);
       _progressBarValueController.sink.add(progress);
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
      final int pagesCount = _workoutController.stream.value.length;

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
      final List<ExerciseModel> list = _workoutController.stream.value;
      int setsCount = list[pageIndex].set;

      if(doneExercises == setsCount){
        incrementPageIndex();
        _doneExerciseController.sink.add(0);
      }

   }

   setPrimaryProgram(String workout) async {
     await FirebaseUserAPI().updateUserProfile({"primary workout" : workout}).catchError((error) => print);
   }


    @override
    void dispose() {
      _programController.close();
      _workoutController.close();
      _pageIndexController.close();
      _doneExerciseController.close();
      _currentPageController.close();
      _progressBarValueController.close();
      _doneWorkoutController.close();
      _totalWeightController.close();
      _programNotificationController.close();
      _programsController.close();
    }

}