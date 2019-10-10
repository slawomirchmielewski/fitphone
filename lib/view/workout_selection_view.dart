import 'package:fitphone/view/pages/workout_page.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WorkoutSelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);

    List<Widget> treeButtons = [FitButton(
      buttonText: "Workout A",
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(workout: programsViewModel.workout3A,workoutName: "Workout 3A")));
      },
    ),
      SizedBox(height: 16),
      FitButton(
        buttonText: "Workout B",
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(workout: programsViewModel.workout3B,workoutName: "Workout 3B")));
        },
      ),
      SizedBox(height: 16),
      FitButton(
        buttonText: "Workout C",
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(workout: programsViewModel.workout3C,workoutName: "Workout C3")));
        },
      )];

    List<Widget> fourButtons = [FitButton(
      buttonText: "Workout A",
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(workout: programsViewModel.workout4A,workoutName: "Workout 4A")));
      },
    ),
      SizedBox(height: 16),
      FitButton(
        buttonText: "Workout A1",
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(workout: programsViewModel.workout4A1,workoutName: "Workout 4A1")));
        },
      ),
      SizedBox(height: 16),
      FitButton(
        buttonText: "Workout B",
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(workout: programsViewModel.workout4B,workoutName: "Workout 4B")));
        },

      ),
      SizedBox(height: 16),
      FitButton(
        buttonText: "Workout B1",
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutPage(workout: programsViewModel.workout4B1,workoutName: "Workout 4B1")));
        },

      )];

    return Page(
      automaticallyImplyLeading: true,
      appBarTitle: Text("Select workout"),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: <Widget>[
              SizedBox(height: 72),
              Text("With workout you would like to start ?",style: Theme.of(context).textTheme.display1.copyWith(
                color: Theme.of(context).textTheme.title.color,
                fontWeight: FontWeight.bold
              )),
              SizedBox(height: 140),
              if(programsViewModel.programInfo.primaryWorkout == "3d") ...treeButtons,
              if(programsViewModel.programInfo.primaryWorkout == "4d") ...fourButtons,

            ],
          ),
        )
      ],
    );
  }
}
