import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_year_weight_chart.dart';
import 'package:flutter/material.dart';



class ProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final String pageName = "Progress";

    return Page(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? greyBackground : Theme.of(context).scaffoldBackgroundColor,
      appBarColor: MediaQuery.of(context).platformBrightness == Brightness.light ? greyBackground  : Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 100,
      pageName: pageName,
      children: <Widget>[
        
       Container(
         margin: EdgeInsets.only(left: 8,right: 8),
         padding: EdgeInsets.all(16),
         height: 200,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10),
           color: Theme.of(context).cardColor
         ),
         width: double.infinity,
         child: FitYearWeightChart(),
       )
      ],
    );
  }
}
