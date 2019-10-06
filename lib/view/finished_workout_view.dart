import 'package:fitphone/view_model/done_workouts_view_model.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:fitphone/widget/fit_confetti_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:fitphone/widget/fit_on_back_press.dart';



class FinishedWorkoutView extends StatelessWidget {


  final double weight;
  final String time;
  final String workoutName;

  FinishedWorkoutView({this.weight, this.time,this.workoutName});


  String getEnds(int workoutCount){
    switch(workoutCount){
      case 1:
        return "st";
        break;
      case 2:
        return "nd";
        break;
      case 3:
        return "rd";
        break;
      default:
        return "th";
    }
  }

  @override
  Widget build(BuildContext context) {


    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);
    final UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);
    final DoneWorkoutsViewModel doneWorkoutsViewModel = Provider.of<DoneWorkoutsViewModel>(context);

    return FitOnBackPress(
      child: FitConfettiWidget(
        child: Page(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(("assets/trophy.png"),width: MediaQuery.of(context).size.width*0.4,),
                  SizedBox(height: 32),
                  Text("Congratulation", style: Theme.of(context).textTheme.display1.copyWith(
                    fontWeight: FontWeight.bold
                  )),
                  SizedBox(height: 32),
                  Text("You finished your ${programsViewModel.programInfo.completedExercises + 1}${getEnds(programsViewModel.programInfo.completedExercises + 1)}  workout",
                    style: Theme.of(context).textTheme.title),
                  SizedBox(height: 72),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text("$weight ${settingsManager.unitShortName}",style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.w700
                          ),),
                          Text("Total weight lifted"),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text("$time min",style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.w700)),
                          Text("Total workout time"),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 72),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          onChanged: doneWorkoutsViewModel.setComment,
                          decoration: InputDecoration(
                            hintText: "Add comment",
                            filled: true,
                            hasFloatingPlaceholder: false,
                            fillColor: Theme.of(context).primaryColorLight,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      ),
                      SizedBox(width: 16),
                      Consumer<PhotosViewModel>(
                          builder: (context,photosViewModel,_) =>
                          CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: IconButton(icon: Icon(Icons.local_see),onPressed: () {
                            photosViewModel.takePhoto();
                            Toast.show("Photo added to gallery", context);
                          }
                          )
                        )
                      ),

                    ],
                  ),
                  SizedBox(height: 72),
                  FitButton(
                    buttonText: "Finish" ,
                    onTap: (){
                      doneWorkoutsViewModel.addDoneWorkout(
                          settingsManager.setConvertedWeight(weight),
                          time,
                          workoutName
                      );
                      userViewModel.addPoints(10);
                      programsViewModel.incrementCompletedExercises();
                      Navigator.of(context).popUntil((rout) => rout.isFirst);
                    },
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}
