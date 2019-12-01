import 'dart:async';
import 'dart:io' show Platform;

import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/view/finished_workout_view.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/widget/fit_alert_dialog.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:fitphone/widget/fit_coutdown_time.dart';
import 'package:fitphone/widget/fit_on_back_press.dart';
import 'package:fitphone/widget/fit_set_tile_view.dart';
import 'package:fitphone/widget/video_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


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
  List<String> notes = List();
  List<Exercise> doneExercises = List();
  PageController _pageController = PageController(initialPage: 0,viewportFraction: 1);
  PanelController _panelController = new PanelController();
  PageController _pageViewController  = new PageController(initialPage: 0);
  int currentPageIndex;
  int panelPageIndex;

  double bottomSheetHeight;

  int doneSet;
  double liftedWeight;

  bool keyboardVisible;

  TextEditingController _textEditingController = TextEditingController();


  Stopwatch stopwatch;
  Timer timer;
  String counterText = "00:00";


  @override
  void initState() {

    super.initState();

    workout = widget.workout;

    currentPageIndex = _pageController.initialPage;
    panelPageIndex = _pageViewController.initialPage;

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
    _textEditingController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String getNextWorkoutName(){
    if(currentPageIndex >= workout.length-1){
      return "Finish";
    }
    return workout[currentPageIndex + 1].name;
  }


  _finishSet(Exercise exercise, ProgramsViewModel programsViewModel){
    if(_pageController.hasClients && doneSet == exercise.set && currentPageIndex != workout.length -1){
      _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      doneExercises.add(exercise);
      programsViewModel.updateExercise(exercise.weights, exercise.doneReps, exercise.id);
      setState(() {
        doneSet = 0;
      });
    }
    else if(doneSet == exercise.set && currentPageIndex == workout.length - 1){
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
                width: MediaQuery.of(context).size.width * 0.85,
                child: Center(
                  child: CountDownTimer(
                    time: time,
                    screenSize: MediaQuery.of(context).size.height,
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

    TextStyle _textStyle = Theme.of(context).textTheme.subtitle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.bold
    );

    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    return FitOnBackPress(
      child: Material(
        child: SlidingUpPanel(
          backdropEnabled: true,
          backdropOpacity: 0.8,
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.only(top: 16,left: 16,right: 16),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
          controller: _panelController,
          boxShadow: [BoxShadow(color: Colors.transparent)],
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height* 0.96,
          panel: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: Container(
                  height: 8,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(0.2)
                  ),
                )),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          panelPageIndex = 0;
                        });
                        _pageViewController.animateToPage(panelPageIndex, duration: Duration(milliseconds: 200), curve: Curves.easeInSine);
                      },
                      child: Text("Notes",style: Theme.of(context).textTheme.headline.copyWith(
                        fontWeight: FontWeight.bold,
                        color: panelPageIndex == 0 ? Theme.of(context).textTheme.title.color : Colors.grey
                      )),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          panelPageIndex = 1;
                        });
                        _pageViewController.animateToPage(panelPageIndex, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
                      },
                      child: Text("History",style: Theme.of(context).textTheme.headline.copyWith(
                          fontWeight: FontWeight.bold,
                          color: panelPageIndex == 1 ? Theme.of(context).textTheme.title.color : Colors.grey
                      )),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),
                Flexible(
                  child: Container(
                    child: PageView(
                      controller: _pageViewController,
                      onPageChanged: (index){
                        setState(() {
                          panelPageIndex = index;
                        });
                      },
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(workout[currentPageIndex].name,style: Theme.of(context).textTheme.subhead.copyWith(
                                fontWeight: FontWeight.w600
                              )),
                              SizedBox(height: 16),
                              Row(
                                children: <Widget>[

                                  Flexible(
                                    child: Container(
                                      child: TextField(
                                        controller: _textEditingController,
                                        onChanged:(text) => _textEditingController.value,
                                        decoration: InputDecoration(
                                          hintText: "+ Add note",
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Consumer<ProgramsViewModel>(
                                    builder: (context,programViewModel,_) => IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: (){
                                        if(_textEditingController.text != ""){
                                          List<String> notes = List<String>.from( workout[currentPageIndex].notes);
                                          notes.add(_textEditingController.text);
                                          workout[currentPageIndex].notes = notes;
                                          programViewModel.updatesNotes(workout[currentPageIndex].notes, workout[currentPageIndex].id);
                                          _textEditingController.clear();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Flexible(
                                child: Container(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: workout[currentPageIndex].notes.length,
                                      itemBuilder: (context,noteIndex)=> ListTile(
                                        leading: Icon(Icons.assignment),
                                        title: Text("${workout[currentPageIndex].notes[noteIndex]}"),
                                      )
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                              itemCount: doneExercises.length ,
                              itemBuilder: (context,exerIndex) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${exerIndex + 1}. ${doneExercises[exerIndex].name}",style: Theme.of(context).textTheme.title,),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                                    shrinkWrap: true,
                                    itemCount:doneExercises[exerIndex].set,
                                    itemBuilder: (context,i) => ListTile(
                                      title: Text("Set ${i + 1} :      ${doneExercises[exerIndex].doneReps[i]} x ${settingsManager.getConvertedWeight(doneExercises[exerIndex].weights[i]).round()} ${settingsManager.unitShortName}"),
                                    ),
                                  ),
                                  SizedBox(height: 16)
                                ],
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                ]),
          body: Scaffold(
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
                    showDialog(
                        context: context,
                        builder: (context){

                          if(stopwatch.isRunning){
                            stopwatch.stop();
                          }
                          return FitAlertDialog(
                            title: Text("Finish workout"),
                            content: Text("Are you sure you want to finish workout? "),
                            actions: <Widget>[
                              FlatButton(
                              child: Text("Resume"),
                               onPressed: (){
                                 if(!stopwatch.isRunning){
                                   stopwatch.start();
                                 }
                                 Navigator.pop(context);
                               },
                            ),
                              FlatButton(
                                child: Text("Finish",style: Theme.of(context).textTheme.body1.copyWith(
                                  color: Colors.red
                                ),),
                                onPressed: (){
                                  if(stopwatch.isRunning){
                                    stopwatch.stop();
                                  }
                                  Navigator.of(context).popUntil((result) => result.isFirst);
                                },
                              )
                          ],

                        );}

                    );
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
                  controller: _pageController,
                  itemBuilder: (context,index) {

                    if(workout[index].weights.length == 0){

                      List<double> w = List();

                      for(int i = 0 ; i < workout[index].set;i++){
                        w.add(0);
                      }

                      workout[index].weights = w;
                    }

                    if(workout[index].doneReps.length == 0){

                      List<int> r = List();

                      for(int i = 0 ; i < workout[index].set;i++){
                        r.add(0);
                      }

                      workout[index].doneReps = r;
                    }


                    return Container(
                      padding: EdgeInsets.only(right: 16,left: 16),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 32),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  child: Text(workout[index].name,maxLines: 2,style: Theme.of(context).textTheme.display1.copyWith(
                                      color: Theme.of(context).textTheme.title.color,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ),
                              CircleAvatar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child:GestureDetector(
                                      onTap: () => _panelController.animatePanelToPosition(0.5),
                                      child: Icon(Platform.isIOS ? Icons.more_horiz  : Icons.more_vert,color: Colors.white)),
                              )
                            ],
                          ),
                          SizedBox(height: 32),

                          VideoPlayer(
                            workout[index].url,
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
                            ),
                            height: 60,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                        width: 38,
                                        child: Text("SET",textAlign: TextAlign.center,style: _textStyle,),
                                      ),
                                      Container(
                                        width: 70,
                                        child: Text("PREVIOUS",textAlign: TextAlign.center,style: _textStyle,),
                                      ),
                                      Container(
                                        width: 60,
                                        child: Text("${settingsManager.unitShortName.toUpperCase()}",textAlign: TextAlign.center,style: _textStyle),
                                      ),
                                      Container(
                                        width: 80,
                                        child: Text("REPS",textAlign: TextAlign.center,style: _textStyle),
                                      ),
                                      Container(
                                          width: 38,
                                          child: Icon(Icons.done_all)
                                      )
                                    ],
                                  ),
                                ),
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
                                      reps: workout[index].reps,
                                      weight: workout[index].weights[setIndex],
                                      doneReps: workout[index].doneReps[setIndex],
                                      onDonePressed: (returnValue) {
                                          setState(() {
                                            if(workout[index].restTime != 0 && setIndex + 1 != workout[index].set){
                                              _showCounter(context,workout[index].restTime);
                                            }
                                            setState(() {
                                              doneSet++;
                                              liftedWeight = liftedWeight + returnValue.weight;
                                            });

                                            workout[index].weights[setIndex] = settingsManager.setConvertedWeight(returnValue.weight);
                                            workout[index].doneReps[setIndex] = returnValue.rep;
                                            _finishSet(workout[index],programsViewModel);
                                          });
                                        },
                                      ),
                                  ),
                              );
                            }
                          ),
                          SizedBox(height: bottomSheetHeight + 20)
                        ]
                      ),
                    );
                  }
              ),
            bottomSheet: keyboardVisible != true ? Container(
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
          )
          ),
      ),
    );
  }
}
