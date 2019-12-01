import 'package:fitphone/view/embaded_view/workouts_view.dart';
import 'package:fitphone/view/new_programs_screen.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_new_program_card.dart';
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

    final List<FitWorkoutCard> treeDays = [
      FitWorkoutCard(
          title: "Workout A",
          subtitle:" ${programsViewModel.workout3A.length} exercises",
          isDone: programsViewModel.programInfo.is3AWorkoutDone,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout3A,
              workoutName: "Workout A",
              isDone: programsViewModel.programInfo.is3AWorkoutDone,
            )));
          }),
      FitWorkoutCard(
          title: "Workout B",
          isDone: programsViewModel.programInfo.is3BWorkoutDone,
          subtitle:" ${programsViewModel.workout3B.length} exercises",
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout3B,
              workoutName: "Workout B",
              isDone: programsViewModel.programInfo.is3BWorkoutDone,
            )));
          }),
      FitWorkoutCard(
          title: "Workout C",
          isDone: programsViewModel.programInfo.is3CWorkoutDone,
          subtitle:" ${programsViewModel.workout3C.length} exercises",
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout3C,
              workoutName: "Workout C",
              isDone: programsViewModel.programInfo.is3CWorkoutDone,
            )));
          })
    ];
    final List<FitWorkoutCard> fourDays = [
      FitWorkoutCard(
          title: "Workout A",
          isDone: programsViewModel.programInfo.is4AWorkoutDone,
          subtitle:" ${programsViewModel.workout4A.length} exercises",
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout4A,
              workoutName: "Workout A",
              isDone: programsViewModel.programInfo.is4AWorkoutDone,
            )));
          }),
      FitWorkoutCard(
          title: "Workout A1",
          subtitle:" ${programsViewModel.workout4A1.length} exercises",
          isDone: programsViewModel.programInfo.is4A1WorkoutDone,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout4A1,
              workoutName: "Workout A1",
              isDone: programsViewModel.programInfo.is4A1WorkoutDone,
            )));
          }),
      FitWorkoutCard(
          title: "Workout B",
          subtitle:" ${programsViewModel.workout4B.length} exercises",
          isDone: programsViewModel.programInfo.is4BWorkoutDone,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout4B,
              workoutName: "Workout B",
              isDone: programsViewModel.programInfo.is4BWorkoutDone,
            )));
          }),
      FitWorkoutCard(
          title: "Workout B1",
          subtitle:" ${programsViewModel.workout4B1.length} exercises",
          isDone: programsViewModel.programInfo.is4B1WorkoutDone,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutsView(
              exercises: programsViewModel.workout4B1,
              workoutName: "Workout B1",
              isDone: programsViewModel.programInfo.is4B1WorkoutDone ,
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
      haveTitle: true,
      pageName: pageName,
      appBarTitle: Text(pageName),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FitNewProgramCard(),
              FitProgramCard(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: ()=> showRoundedModalBottomSheet(
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
                  )),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(getProgramText()),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if(programsViewModel.programInfo.primaryWorkout == "3d") ...treeDays,
              if(programsViewModel.programInfo.primaryWorkout == "4d") ...fourDays,

            ],
          )
        ],
      ),
    );
  }
}
