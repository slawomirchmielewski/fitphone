import 'package:fitphone/model/done_workout_model.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:fitphone/view_model/done_workouts_view_model.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WorkoutsActivityScreen extends StatelessWidget {
  
  
  
  String _getName(String name){
    
    List<String> s = name.split(" ");
     
    return s[1];
  }
  

  @override
  Widget build(BuildContext context) {

    final DoneWorkoutsViewModel doneWorkoutsViewModel = Provider.of<DoneWorkoutsViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);


    final List<DoneWorkout> lastWeekList = doneWorkoutsViewModel.doneWorkouts.where((w) => w.week == DateHelper.getWeekNumber(DateTime.now())).toList();
    final List<DoneWorkout> lastMonthList = doneWorkoutsViewModel.doneWorkouts.where((w) => w.month == DateTime.now().month && w.year == DateTime.now().year && w.week != DateHelper.getWeekNumber(DateTime.now())).toList();
    final List<DoneWorkout> lastOlderList = doneWorkoutsViewModel.doneWorkouts.where((w) => w.month != DateTime.now().month && w.week != DateHelper.getWeekNumber(DateTime.now())).toList();


    Widget buildListView(List<DoneWorkout> list){
      return ListView.builder(
          physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context,index) => ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(_getName(list[index].name),style: Theme.of(context).textTheme.body1.copyWith(
                color: Colors.white
              ),),
            ),
            title: Text(list[index].name),
            subtitle: Text("${list[index].time} min / "
                "${settingsManager.getConvertedWeight(list[index].maxLift).toInt()} "
                "${settingsManager.unitShortName}"),
            trailing: Text(list[index].getDate()),
          )
      );
    }

    return Page(
      automaticallyImplyLeading: true,
      pageName: "Finished Workouts",
      appBarTitle: Text("Workouts"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 150,
            color: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Consumer<ProgramsViewModel>(
                      builder:(context,programsViewModel,_) =>
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(programsViewModel.programInfo != null ? programsViewModel.programInfo.completedExercises.toString() : "",style: Theme.of(context).textTheme.display2.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).textTheme.title.color
                          )),
                          Text("Workouts completed")
                        ],
                      ),
                    ),
                    Consumer<UserViewModel>(
                      builder:(context,userViewModel,_) =>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(userViewModel.day.toString(),style: Theme.of(context).textTheme.display2.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).textTheme.title.color
                              )),
                              Text("Days of trenning")
                            ],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 16, top: 16,bottom: 8),
            child: Text("FINISHED WORKOUTS",style: Theme.of(context).textTheme.subtitle.copyWith(
              color: Colors.grey
            ))
          ),
          SizedBox(height: 16),
          if(lastWeekList.length > 0)Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("This week",style: Theme.of(context).textTheme.subhead.copyWith(
              fontWeight: FontWeight.bold
            )),
          ),
         buildListView(lastWeekList),
          if(lastMonthList.length > 0)Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("This month",style: Theme.of(context).textTheme.subhead.copyWith(
              fontWeight: FontWeight.bold
            )),
          ),
          buildListView(lastMonthList),
          if(lastOlderList.length > 0)Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("Older",style: Theme.of(context).textTheme.subhead.copyWith(
              fontWeight: FontWeight.bold
            )),
          ),
          buildListView(lastOlderList)
        ],
      ),
    );
  }
}
