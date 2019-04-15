import 'package:fitphone/model/program_model.dart';
import 'package:fitphone/utils/day_converter.dart';
import 'package:flutter/material.dart';



class WorkoutViewTile extends StatelessWidget{

  final WorkoutModel workoutModel;

  WorkoutViewTile({this.workoutModel});

  @override
  Widget build(BuildContext context) {

    int day = DateTime.now().weekday;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(workoutModel.name,style: Theme.of(context).textTheme.headline.copyWith(
            fontWeight: FontWeight.w500,
            color: DayConverter.getDay(day) == workoutModel.name ? Theme.of(context).primaryColor : Theme.of(context).textTheme.title.color
          ),),
          SizedBox(height: 8),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
              itemCount: workoutModel.exercises.length,
              itemBuilder: (context,index) => ListTile(
                leading: Text("${index + 1}.",style: Theme.of(context).textTheme.subhead.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,),
                title: Text(workoutModel.exercises[index].name,style: Theme.of(context).textTheme.subhead),
              )
          )
        ],
      ),
    );
  }



}