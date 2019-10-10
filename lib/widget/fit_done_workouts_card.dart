import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class FitDoneWorkoutsCard extends StatelessWidget {


  static const double width = double.infinity;


  Widget _buildWorkoutsColumn(String name,bool value,BuildContext context){
    return Column(
      children: <Widget>[
        ListTile(
            leading: Text(name,style: Theme.of(context).textTheme.subhead.copyWith(
              fontWeight: FontWeight.w600
            ),),
            trailing: Icon(value == true ? Ionicons.ios_checkmark_circle : Ionicons.ios_radio_button_off,size: 38,color: Theme.of(context).iconTheme.color,)
        )
      ],
    );
  }


  Widget _buildTreeDaysTile(BuildContext context,ProgramsViewModel programsViewModel){
    return Column(
      children: <Widget>[
        _buildWorkoutsColumn("Workout A",programsViewModel.programInfo.is3AWorkoutDone,context),
        _buildWorkoutsColumn("Workout B",programsViewModel.programInfo.is3BWorkoutDone,context),
        _buildWorkoutsColumn("Workout C",programsViewModel.programInfo.is3CWorkoutDone,context),
      ],
    );
  }

  Widget _buildFourDaysTile(BuildContext context,ProgramsViewModel programsViewModel){
    return Column(
      children: <Widget>[
        _buildWorkoutsColumn("Workout A",programsViewModel.programInfo.is4AWorkoutDone,context),
        _buildWorkoutsColumn("Workout A1",programsViewModel.programInfo.is4A1WorkoutDone,context),
        _buildWorkoutsColumn("Workout B",programsViewModel.programInfo.is4BWorkoutDone,context),
        _buildWorkoutsColumn("Workout B1",programsViewModel.programInfo.is4B1WorkoutDone,context),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);

    return CardBase(
      icon: Icons.done_all,
      title: "Complated this week",
      haveAction: false,
      child: programsViewModel.programInfo.primaryWorkout == "3d" ? _buildTreeDaysTile(context,programsViewModel) : _buildFourDaysTile(context,programsViewModel)
    );
  }
}
