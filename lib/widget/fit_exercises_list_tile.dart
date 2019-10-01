import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/widget/fit_image.dart';
import 'package:flutter/material.dart';

class FitExerciseListTile extends StatelessWidget {

  final Exercise exercise;

  FitExerciseListTile(this.exercise);



  @override
  Widget build(BuildContext context) {


    final TextStyle smallText = Theme.of(context).textTheme.subtitle.copyWith(
      color: Colors.grey[500]
    );

    final TextStyle orderText = Theme.of(context).textTheme.subtitle.copyWith(
        color: Theme.of(context).primaryColor,
        fontSize: 10
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FitImage(
            imageUrl: "http://i3.ytimg.com/vi/Zt7klOM3XXA/maxresdefault.jpg",
            width: 80,
            height: 80,
            radius: 5,
            boxFit: BoxFit.cover,
          ),
          SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("EXERCISE : ${exercise.order}",style: orderText,),
              Text("${exercise.name}",style: Theme.of(context).textTheme.subhead.copyWith(
                fontWeight: FontWeight.w600
              ),),
              SizedBox(height: 4),
              Text("Sets : ${exercise.set}",style: smallText,),
              Text("Reps : ${exercise.reps}",style: smallText,),
              Text("Rest time : ${exercise.restTime} min",style: smallText,)
            ],
          )
        ],

      ),
    );
  }


}
