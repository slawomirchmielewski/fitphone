import 'package:flutter/material.dart';
import 'package:fitphone/model/program_model.dart';

class ExerciseTile extends StatelessWidget{

  final List<WorkoutModel> workouts;

  ExerciseTile({@required this.workouts});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      shrinkWrap: true,
      itemCount: workouts.length,
      itemBuilder: (context,workoutsIndex) =>
      ExpansionTile(
        title: Text(workouts != null ? workouts[workoutsIndex].name : "",style: Theme.of(context).textTheme.title),
        children: <Widget>[
          ListView.builder(
            physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            shrinkWrap: true,
            itemCount: workouts[workoutsIndex].exercises.length,
            itemBuilder: (context,index) => ListTile (
               leading: Text((index+1).toString()),
               title: Text(workouts != null ? workouts[workoutsIndex].exercises[index].name : ""),
             )
          )
        ],
      ),
    );
  }

}