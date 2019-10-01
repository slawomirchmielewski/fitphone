import 'dart:io' show Platform;
import 'dart:math';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/widget/fit_set_tile_view.dart';
import 'package:fitphone/widget/video_player_widget.dart';
import 'package:flutter/material.dart';



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
        bottomSheetHeight = 60;
      });

    }
    else if(Platform.isIOS){
      setState(() {
        bottomSheetHeight = 90;
      });
    }

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


  finishSet(int maxSets){
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
                        onDonePressed: () {
                          setState(() {
                            setState(() {
                              doneSet++;
                            });
                            print(doneSet);
                            finishSet(workout[index].set);
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
      bottomSheet: Container(
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
      ),
    );
  }
}
