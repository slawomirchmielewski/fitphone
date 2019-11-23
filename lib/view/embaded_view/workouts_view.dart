import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class WorkoutsView extends StatelessWidget {


  final String workoutName;
  final bool isDone;
  final List<Exercise> exercises;

  WorkoutsView({this.workoutName, this.exercises,this.isDone});


  @override
  Widget build(BuildContext context) {

    return Page(
      automaticallyImplyLeading: true,
      appBarTitle: Text(workoutName),
      actions: <Widget>[
        if(isDone)Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(Ionicons.ios_checkmark_circle,size: 32,color: Theme.of(context).primaryColor),
        )
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16,bottom: 8),
            child: Text("EXERCISES",style: Theme.of(context).textTheme.subtitle.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.grey
            ),),
          ),
          ListView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
              itemCount: exercises.length,
              itemBuilder: (context,index) => ListTile(
                leading: AspectRatio(
                  aspectRatio:0.95,
                  child: exercises[index].coverUrl != "" ? FitImage(
                    width: 80,
                    height: 80,
                    imageUrl: exercises[index].coverUrl,
                    radius: 10,
                    boxFit: BoxFit.cover,
                  ) : CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                  ),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text("Set: ${exercises[index].set}",overflow: TextOverflow.ellipsis,),
                    SizedBox(width: 16),
                    Text("Reps: ${exercises[index].reps}",overflow: TextOverflow.ellipsis),
                    SizedBox(width: 16),
                    Flexible(child: Container(child: Text("Rest: ${exercises[index].restTime}min",overflow: TextOverflow.ellipsis))),
                  ],
                ),
                title: Container(
                  child: Text("${exercises[index].order}.${exercises[index].name}",overflow: TextOverflow.ellipsis),
                ),
              )
          )
        ],
      ),
    );
  }


}
