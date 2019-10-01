import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/embaded_view/workouts_view.dart';
import 'package:fitphone/view/new_programs_screen.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_done_workouts_card.dart';
import 'package:fitphone/widget/fit_program_card.dart';
import 'package:fitphone/widget/fit_workout_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rounded_modal/rounded_modal.dart';

class ProgramsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);
    final pageName = "Programs";
    final double expandedHeight = 100;


    final List<FitWorkoutCard> treeDays = [
      FitWorkoutCard(
          title: "Workout A",
          subtitle:" ${programsViewModel.workout3A.length} exercises",
          iconColor: Colors.red,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout3A,
              workoutName: "Workout A",
            )));
          }),
      FitWorkoutCard(
          title: "Workout B",
          subtitle:" ${programsViewModel.workout3B.length} exercises",
          iconColor: Colors.indigoAccent,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout3B,
              workoutName: "Workout B",
            )));
          }),
      FitWorkoutCard(
          title: "Workout C",
          subtitle:" ${programsViewModel.workout3C.length} exercises",
          iconColor: Colors.green,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout3C,
              workoutName: "Workout C",
            )));
          })
    ];
    final List<FitWorkoutCard> fourDays = [
      FitWorkoutCard(
          title: "Workout A",
          subtitle:" ${programsViewModel.workout4A.length} exercises",
          iconColor: Colors.red,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout4A,
              workoutName: "Workout A",
            )));
          }),
      FitWorkoutCard(
          title: "Workout A1",
          subtitle:" ${programsViewModel.workout4A1.length} exercises",
          iconColor: Colors.indigoAccent,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout4A1,
              workoutName: "Workout A1",
            )));
          }),
      FitWorkoutCard(
          title: "Workout B",
          subtitle:" ${programsViewModel.workout4B.length} exercises",
          iconColor: Colors.green,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout4B,
              workoutName: "Workout B",
            )));
          }),
      FitWorkoutCard(
          title: "Workout B1",
          subtitle:" ${programsViewModel.workout4B1.length} exercises",
          iconColor: Colors.orangeAccent,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout4B1,
              workoutName: "Workout B1",
            )));
          })
    ];

    Future.delayed(Duration(seconds: 1)).then((_) {
      if(programsViewModel.newPrograms == true){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewProgramsScreen(),fullscreenDialog: true));
        programsViewModel.setNewProgramsValue(false);
      }
    });


    String getProgramText(){
      if(programsViewModel.programInfo.primaryWorkout == "3d"){
        return "3 days per week";
      }
      return "4 days per week";
    }

    return Page(
      expandedHeight: expandedHeight,
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? greyBackground : Theme.of(context).scaffoldBackgroundColor,
      appBarColor: MediaQuery.of(context).platformBrightness == Brightness.light ? greyBackground  : Theme.of(context).scaffoldBackgroundColor,
      pageName: pageName,
      actions: <Widget>[
        GestureDetector(
          onTap: (){
            showRoundedModalBottomSheet(
                color: Theme.of(context).cardColor,
                context: context,
                builder: (context)=> Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RadioListTile(title: Text("3 days per week"),value: "3d",groupValue: programsViewModel.programInfo.primaryWorkout,
                        onChanged:(value) {
                        programsViewModel.setPrimaryWorkout(value);
                        Navigator.pop(context);
                      }),
                      RadioListTile(title: Text("4 days per week"),value: "4d",groupValue: programsViewModel.programInfo.primaryWorkout,
                        onChanged: (value){
                         programsViewModel.setPrimaryWorkout(value);
                         Navigator.pop(context);
                        })
                    ],
                  ),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                Text(getProgramText()),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        )
      ],
      centerTitle: false,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FitProgramCard(),
            FitDoneWorkoutsCard(),
            if(programsViewModel.programInfo.primaryWorkout == "3d") ...treeDays,
            if(programsViewModel.programInfo.primaryWorkout == "4d") ...fourDays,

          ],
        )
      ],
    );
  }
}
