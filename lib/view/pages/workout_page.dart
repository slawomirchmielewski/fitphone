import 'dart:io' show Platform;
import 'dart:math';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:fitphone/widget/fit_coutdown_time.dart';
import 'package:fitphone/widget/fit_set_tile_view.dart';
import 'package:fitphone/widget/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';



class WorkoutPage extends StatefulWidget {

  final List<Exercise> workout;


  WorkoutPage(this.workout);


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


  @override
  void initState() {
    super.initState();
    workout = widget.workout;
    pageController = PageController(initialPage: 0,viewportFraction: 1);
    currentPageIndex = pageController.initialPage;


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


  _finishSet(int maxSets){
    if(pageController.hasClients && doneSet == maxSets && currentPageIndex != workout.length -1){
      pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      setState(() {
        doneSet = 0;
      });
    }
    else if(doneSet == maxSets && currentPageIndex == workout.length - 1){
      print("Finish");
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

  @override
  Widget build(BuildContext context) {

    TextStyle _textStyle = Theme.of(context).textTheme.subhead.copyWith(
      fontWeight: FontWeight.bold
    );

    return Scaffold(
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
              child: Text("02:23", style:Theme.of(context).textTheme.subhead),
            )
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Finish",style: Theme.of(context).textTheme.subhead.copyWith(
              color: Theme.of(context).primaryColor
            )),
            onPressed: (){
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

                      if(workout[setIndex].weights.length == 0){
                        for(int i = 0 ; i <= workout[setIndex].set;i++){
                          workout[setIndex].weights.add(200);
                        }
                      }

                      return  FitSetListTile(
                        set: setIndex.toString(),
                        reps: workout[setIndex].reps,
                        weight: workout[setIndex].weights[setIndex],
                        onDonePressed: (weight) {
                          setState(() {
                            if(workout[index].restTime != 0){
                              _showCounter(context,workout[index].restTime);
                            }
                            setState(() {
                              doneSet++;
                              liftedWeight = liftedWeight + weight;
                            });
                            _finishSet(workout[index].set);
                          });
                        },
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
    );
  }
}
