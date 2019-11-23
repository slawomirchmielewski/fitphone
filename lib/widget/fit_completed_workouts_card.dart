import 'package:fitphone/view/workouts_activity_screen.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:fitphone/widget/base_widget/image_card_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';


class FitCompletedWorkoutsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);

    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);

    return ImageCardBase(
      imagePath: "assets/workouts_cover_image.png",
      title: "Workouts",
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
          Text("workouts completed",style: theme.textTheme.body1)

        ],
      ),
    );
  }
}
