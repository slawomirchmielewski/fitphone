import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:flutter/material.dart';

class WorkoutsView extends StatelessWidget {


  final String workoutName;
  final List<Exercise> exercises;

  WorkoutsView({this.workoutName, this.exercises});


  @override
  Widget build(BuildContext context) {

    return Page(
      automaticallyImplyLeading: true,
      appBarTitle: Text(workoutName),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16, top: 16,bottom: 8),
          child: Text("EXERCISES",style: Theme.of(context).textTheme.subtitle.copyWith(
            fontWeight: FontWeight.w700,
          ),),
        ),
        ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            itemCount: exercises.length,
            itemBuilder: (context,index) => ListTile(
              leading: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColorLight
                ),
                child: Center(child: Text(exercises[index].order.toString())),
              ),
              subtitle: Row(
                children: <Widget>[
                  Text("Set: ${exercises[index].set}"),
                  SizedBox(width: 16),
                  Text("Reps: ${exercises[index].reps}"),
                  SizedBox(width: 16),
                  Text("Rest: ${exercises[index].restTime}"),
                ],
              ),
              title: Text(exercises[index].name),
            )
        )
      ],
    );
  }


}
