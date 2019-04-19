import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/congratulation_screen.dart';
import 'package:fitphone/widget/exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';

class WorkoutScreen extends StatefulWidget{

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {

  final PageController pageController = PageController(initialPage: 0,keepPage: false);
  static const double PADDING = 16;

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final ExerciseBloc exerciseBloc = BlocProvider.of<ExerciseBloc>(context);

    exerciseBloc.getWorkout(userBloc.getUserData().primaryWorkout);

    Observable(exerciseBloc.getPageIndex).listen((pageIndex) {
      if(pageController.hasClients)
      pageController.animateToPage(pageIndex, duration: Duration(seconds: 2), curve: Curves.ease);
    });

    Observable(exerciseBloc.getIsWorkoutDone).listen((isWorkoutDone){
      if(isWorkoutDone == true){
        userBloc.updateWorkoutsCount();
        userBloc.updatePoints(10);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CongratulationScreen()));
        exerciseBloc.setIsWorkoutDone(false);
      }
    });


    return StreamBuilder<List<ExerciseModel>>(
        stream: exerciseBloc.getExerciseList,
        builder: (context, snapshot) {

          if(!snapshot.hasData) return Scaffold(body: Center(child: CircularProgressIndicator()));

          if(snapshot.data.length == 0){ return Scaffold(
            appBar: AppBar(
              title: Text("Workout",style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: FontWeight.bold
              ),),
              automaticallyImplyLeading:true,
              centerTitle: true,
              elevation: 0.0,
              brightness: Theme.of(context).brightness,
              iconTheme: Theme.of(context).iconTheme,
              textTheme: Theme.of(context).textTheme,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/rest_day.png")),
                    ),
                  ),
                  Text("No programs avaible",style: Theme.of(context).textTheme.subtitle.copyWith(
                    color: Colors.grey,
                  ),)
                ],
              )
            )
          );}

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading:false,
              centerTitle: true,
              elevation: 0.0,
              brightness: Theme.of(context).brightness,
              iconTheme: Theme.of(context).iconTheme,
              textTheme: Theme.of(context).textTheme,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: StreamBuilder<int>(
                  stream: exerciseBloc.getPageIndex,
                  initialData: 0,
                  builder: (context,indexSnap){
                    if(!snapshot.hasData) return Text("");

                    return Text("Exercise ${indexSnap.data + 1} of ${snapshot.data.length}");
                  }
              ),
              actions: <Widget>[
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text("Finish"),
                  onPressed: (){
                    Navigator.pop(context);
                    exerciseBloc.setPageIndex(0);
                    exerciseBloc.setDoneExerciseCounter(0);
                    exerciseBloc.setCurrentPage(0);
                    exerciseBloc.setProgressBarValue(0);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(PADDING),
                child: Column(
                  children: <Widget>[

                    Container(
                      height: 30,
                      child: StreamBuilder<double>(
                        stream: exerciseBloc.getProgressBarValue,
                        initialData: 0,
                        builder: (context, progressBarSnap){
                          return LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - (16*2),
                              lineHeight: 10.0,
                              percent: progressBarSnap.data,
                              backgroundColor: CustomColors.colorLightGrey,
                              progressColor: Theme.of(context).accentColor
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 32),
                    StreamBuilder<int>(
                      stream: exerciseBloc.getPageIndex,
                      initialData: 0,
                      builder: (context, pageIndexSnap) {

                        if(!pageIndexSnap.hasData) return Container();

                        return Expanded(
                          child: PageView.builder(
                              controller: pageController,
                              itemCount: snapshot.data.length,
                              physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (pageIndex){
                                exerciseBloc.setCurrentPage(pageIndex);
                              },
                              itemBuilder: (context,index){
                                return snapshot.hasData ? ExercisePage(exercise: snapshot.data[index]) : Container();
                              }
                          ),
                        );
                      }
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}


