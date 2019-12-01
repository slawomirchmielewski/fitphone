import 'package:fitphone/utils/date_helper.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_month_weight_chart.dart';
import 'package:fitphone/widget/fit_weight_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'embaded_view/record_weight_view.dart';

class CurrentMonthWeightScreen extends StatelessWidget {


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
            Center(child: Text("${DateHelper.getMonthName(DateTime.now().month)} ${DateTime.now().year}",style: Theme.of(context).textTheme.subtitle)),
            SizedBox(height: 32),
            Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                ),
                child: FitMonthWeightChart()
            ),
            SizedBox(height: 32),
            Text("Average weight this month ${settingsManager.getConvertedWeight(weightViewModel.monthlyAvg)?.round()} ${settingsManager.unitShortName}",
              style: Theme.of(context).textTheme.subtitle,),
            SizedBox(height: 16),
            Divider(),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                itemCount: weightViewModel.monthWeightList.length,
                itemBuilder: (context,index) {

                  weightViewModel.monthWeightList.sort((a,b) => a.date.compareTo(b.date));

                  return FitWeightListTile(
                    weightViewModel.monthWeightList[index],
                  );}
            ),
          ],
        ),
      ),
    );
  }
}
