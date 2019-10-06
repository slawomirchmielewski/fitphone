import 'dart:async';
import 'dart:io' show Platform;
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/view/finished_workout_view.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:fitphone/widget/fit_coutdown_time.dart';
import 'package:fitphone/widget/fit_set_tile_view.dart';
import 'package:fitphone/widget/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:fitphone/widget/fit_on_back_press.dart';
import 'package:provider/provider.dart';



class WorkoutPage extends StatefulWidget {

  final List<Exercise> workout;
  final String workoutName;


  WorkoutPage({
    @required this.workout,
    @required this.workoutName
  });


  @override
  _WorkoutPageState createState() => _WorkoutPageState();

}

class _WorkoutPageState extends State<WorkoutPage> {


  List<Exercise> workout;
  PageController pageController;
  int currentPageIndex;

  double bottomSheetHeight;

  int doneSet;
  double liftedWeight;

  bool keyboardVisible;


  Stopwatch stopwatch;
  Timer timer;
  String counterText = "00:00";


  @override
  void initState() {
    super.initState();
    workout = widget.workout;
    pageController = PageController(initialPage: 0,viewportFraction: 1);
    currentPageIndex = pageController.initialPage;

    stopwatch = Stopwatch();
    stopwatch.start();

    timer = new Timer.periodic(new Duration(milliseconds: 1000), updateTime);


    setState(() {
      doneSet = 0;
      liftedWeight = 0;
    });

    if(Platform.isAndroid){
      setState(() {
        bottomSheetHeight = 80;
      });

    }
    else if(Platform.isIOS){
      setState(() {
        bottomSheetHeight = 90;
      });
    }


    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          keyboardVisible = visible;
        });
      },
    );
  }




  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  String getNextWorkoutName(){
    if(currentPageIndex >= workout.length-1){
      return "Finish";
    }
    return workout[currentPageIndex + 1].name;
  }


  _finishSet(int maxSets, ProgramsViewModel programsViewModel,List<double> weights,String exerciseId){
    if(pageController.hasClients && doneSet == maxSets && currentPageIndex != workout.length -1){
      pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      programsViewModel.updateWeightList(weights, exerciseId);
      setState(() {
        doneSet = 0;
      });
    }
    else if(doneSet == maxSets && currentPageIndex == workout.length - 1){
      stopwatch.stop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => FinishedWorkoutView(
        weight: liftedWeight,
        workoutName: widget.workoutName,
        time: counterText,
      )));
    }

  }


  _showCounter(BuildContext context,int time){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 32),
          children: <Widget>[
            Container(
               height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.height * 0.85,
                child: Center(
                  child: CountDownTimer(
                    time: time,
                    onFinish: (finished){
                      if(finished == true){
                        Navigator.pop(context);
                      }
                    },
                  )
                ),
            ),
            SizedBox(
              width: 100,
              child: FitButton(
                buttonText: "Skip timer",
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            )
          ],);
        }
    );
  }

  updateTime(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {
        counterText = transformMilliSeconds(stopwatch.elapsedMilliseconds);
      });
    }
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {

    TextStyle _textStyle = Theme.of(context).textTheme.subhead.copyWith(
      fontWeight: FontWeight.bold
    );

    return FitOnBackPress(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          textTheme: Theme.of(context).textTheme,
          brightness: Theme.of(context).brightness,
          centerTitle: true,
          elevation: 1,
          title: Text("EXERCISE  ${currentPageIndex + 1} / ${workout.length}"),
          automaticallyImplyLeading: false,
          leading:
          Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(counterText, style:Theme.of(context).textTheme.subhead),
              )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Finish",style: Theme.of(context).textTheme.subhead.copyWith(
                color: Theme.of(context).primaryColor
              )),
              onPressed: (){
                stopwatch.stop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            )
          ],
        ),
        body: PageView.builder(
            physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            itemCount: workout.length,
            onPageChanged: (pageIndex){
              setState(() {
                currentPageIndex = pageIndex;
              });
            },
            controller: pageController,
            itemBuilder: (context,index) {

              if(workout[index].weights.length == 0){

                for(int i = 0 ; i < workout[index].set;i++){
                  workout[index].weights.add(0);
                }
              }

              return Container(
                padding: EdgeInsets.only(right: 16,left: 16),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 32),
                    Text(workout[index].name,maxLines: 2,style: Theme.of(context).textTheme.display1.copyWith(
                      color: Theme.of(context).textTheme.title.color,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 32),
                    VideoPlayer(
                      workout[index].url,
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColorLight,
                      ),
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 60,
                            child: Text("SET",textAlign: TextAlign.center,style: _textStyle,),
                          ),
                          Container(
                            width: 60,
                            child: Text("WEIGHT",textAlign: TextAlign.center,style: _textStyle),
                          ),
                          Container(
                            width: 60,
                            child: Text("REPS",textAlign: TextAlign.center,style: _textStyle),
                          ),
                          Container(
                              width: 60,
                              child: Icon(Icons.done_all)
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap:true,
                      physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                      itemCount: workout[index].set,
                      itemBuilder: (context,setIndex) {

                        return  Consumer<ProgramsViewModel>(
                          builder: (context,programsViewModel,_) =>
                              Consumer<SettingsManager>(
                                builder: (context,settingsManager,_) =>
                                FitSetListTile(
                                set: "${setIndex + 1}",
                                reps: workout[setIndex].reps,
                                weight: workout[index].weights[setIndex],
                                onDonePressed: (weight) {
                                    setState(() {
                                      if(workout[index].restTime != 0 && setIndex + 1 != workout[index].set){
                                        _showCounter(context,workout[index].restTime);
                                      }
                                      setState(() {
                                        doneSet++;
                                        liftedWeight = liftedWeight + weight;
                                      });

                                      workout[index].weights[setIndex] = settingsManager.setConvertedWeight(weight);
                                      _finishSet(workout[index].set,programsViewModel,workout[index].weights,workout[index].id);
                                    });
                                  },
                                ),
                            ),
                        );
                      }
                    ),
                    SizedBox(height: bottomSheetHeight + 20)
                  ],
                ),
              );
            }
        ),
        bottomSheet:keyboardVisible != true ? Container(
          height: bottomSheetHeight,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),
              Text("Next exercise",style: Theme.of(context).textTheme.subtitle),
              SizedBox(height: 8),
              Text(getNextWorkoutName(),style: Theme.of(context).textTheme.subhead),
            ],
          )
        ) : null,
      ),
    );
  }
}
