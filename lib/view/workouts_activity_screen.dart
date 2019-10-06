import 'package:fitphone/view_model/done_workouts_view_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WorkoutsActivityScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final DoneWorkoutsViewModel doneWorkoutsViewModel = Provider.of<DoneWorkoutsViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);


    return Page(
      automaticallyImplyLeading: true,
      pageName: "Finished Workouts",
      appBarTitle: Text("Workouts"),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16, top: 16,bottom: 8),
          child: Text("FINISHED WORKOUTS",style: Theme.of(context).textTheme.subtitle.copyWith(
            fontWeight: FontWeight.w700,
          ),),
        ),
        ListView.builder(
            physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: doneWorkoutsViewModel.doneWorkouts.length,
            itemBuilder: (context,index) => ListTile(
              title: Text(doneWorkoutsViewModel.doneWorkouts[index].name,style: Theme.of(context).textTheme.subhead.copyWith(
                fontWeight: FontWeight.w700
              ),),
              subtitle: Text("${doneWorkoutsViewModel.doneWorkouts[index].time} min / "
                  "${settingsManager.getConvertedWeight(doneWorkoutsViewModel.doneWorkouts[index].maxLift).toInt()} "
                  "${settingsManager.unitShortName}"),
              trailing: Text(doneWorkoutsViewModel.doneWorkouts[index].getDate()),
            )
        )
      ],
    );
  }
}
