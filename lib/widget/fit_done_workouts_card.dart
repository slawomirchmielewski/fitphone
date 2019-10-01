import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:flutter/material.dart';

class FitDoneWorkoutsCard extends StatelessWidget {


  static const double width = double.infinity;

  Widget _buildTitle(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.done_all),
            SizedBox(width: 4),
            Text("Completed this week")
          ],
        ),
      ],
    );
  }


  Widget _buildCircle(){

    const Color color = Colors.lightGreen;

    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color
        )
      ),
      child: Icon(Icons.done,color: color,),
    );
  }


  Widget _buildWorkoutsColumn(String name,BuildContext context){
    return Column(
      children: <Widget>[
        ListTile(
            leading: Text(name,style: Theme.of(context).textTheme.subhead.copyWith(
              fontWeight: FontWeight.w600
            ),),
            trailing: _buildCircle()
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return CardBase(
      icon: Icons.done_all,
      title: "Complated this week",
      haveAction: false,
      child: Column(
        children: <Widget>[
          _buildWorkoutsColumn("Workout A",context),
          _buildWorkoutsColumn("Workout B",context),
          _buildWorkoutsColumn("Workout C",context),
        ],
      ),
    );
  }
}
