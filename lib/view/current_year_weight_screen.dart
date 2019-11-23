import 'package:fitphone/utils/date_helper.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_weight_list_tile.dart';
import 'package:fitphone/widget/fit_year_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'embaded_view/record_weight_view.dart';


class CurrentYearWeightScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    String pageName = "Weight activity";

    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);
    const double padding = 16;

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
            Center(child: Text(DateTime.now().year.toString(),style: Theme.of(context).textTheme.subtitle)),
            SizedBox(height: 32),
            Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  //  color: Theme.of(context).primaryColorLight
                ),
                child: FitYearWeightChart()
            ),
            SizedBox(height: 32),
            Text("Average weight this year ${settingsManager.getConvertedWeight(weightViewModel.yearlyAvg)?.round()} ${settingsManager.unitShortName}",
              style: Theme.of(context).textTheme.subtitle,),
            SizedBox(height: 16),
            Divider(),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                itemCount: weightViewModel.yearWeightList.length,
                itemBuilder: (context,index) {
                  weightViewModel.yearWeightList.sort((a,b) => a.date.compareTo(b.date));
                  return ListTile(
                    title: Text("${settingsManager.getConvertedWeight(weightViewModel.yearWeightList[index].weight).toInt()} ${settingsManager.unitShortName}"),
                    subtitle: Text(DateHelper.getMonthName(weightViewModel.yearWeightList[index].month)),
                  );}
            ),
          ],
        ),
      ),
    );
  }

}
