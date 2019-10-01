import 'package:fitphone/view/workouts_activity_screen.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FitCompletedWorkoutsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);

    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);

    return CardBase(
      icon: Icons.done,
      title: "Workouts",
      iconColor: Colors.pink,
      onTap: (){
        showCupertinoModalPopup(context: context, builder: (context)=> WorkoutsActivityScreen());
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(programsViewModel.programInfo != null ? programsViewModel.programInfo.completedExercises.toString() : "",style: theme.textTheme.display1.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.textTheme.title.color
          )),
          SizedBox(width: 8),
          Text("workouts completed",style: theme.textTheme.subtitle.copyWith(
            color: Colors.grey[700]
          )),

        ],
      ),
    );
  }
}
