import 'package:fitphone/view/embaded_view/record_weight_view.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_weight_list_tile.dart';
import 'package:fitphone/widget/week_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CurrentWeekWeightScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    String pageName = "Weight activity";

    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    return Page(
      automaticallyImplyLeading: true,
      pageName: pageName,
      appBarTitle: Text(pageName),
      actions: <Widget>[
        ActionButton(
          icon: Icons.add,
          onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordWeightView()));
          }
        )
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text("${DateFormat.yMMMd().format(weightViewModel.weekDates.first)} to ${DateFormat.yMMMd().format(weightViewModel.weekDates.last)}",style: Theme.of(context).textTheme.subtitle)),
            SizedBox(height: 32),
            Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                ),
                child: WeekWeightChart(
                  color: Theme.of(context).primaryColor,
                )
            ),
            SizedBox(height: 32),
            Text("Average weight this week ${settingsManager.getConvertedWeight(weightViewModel.weeklyAvg)?.round()} ${settingsManager.unitShortName}",
              style: Theme.of(context).textTheme.subtitle,),
            SizedBox(height: 16),
            Divider(),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                itemCount: weightViewModel.weekWeightList.length,
                itemBuilder: (context,index) {

                  weightViewModel.weekWeightList.sort((a,b) => a.date.compareTo(b.date));

                  return FitWeightListTile(
                    weightViewModel.weekWeightList[index],
                  );}
            ),
          ],
        ),
      ),
    );
  }
}
