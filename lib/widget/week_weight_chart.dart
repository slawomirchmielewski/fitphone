import 'package:fitphone/enums/setup_enums.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fit_custom_weight_chart.dart';

class WeekWeightChart extends StatelessWidget {


  final Color color;

  WeekWeightChart({this.color});

  @override
  Widget build(BuildContext context) {

    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    final List<double> points = [0,0,0,0,0,0,0];
    final List<String> labels = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];

    for(var i = 0 ; i < labels.length;i++){
      for(var y = 0 ; y < weightViewModel.weekWeightList.length ;y++){
        if(weightViewModel.weekWeightList[y].getDayName() == labels[i]){
          points[i] = settingsManager.getConvertedWeight(weightViewModel.weekWeightList[y].weight);
        }
      }
    }

    return Container(
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width,200),
          foregroundPainter: FitCustomWeightChart(
              data: points,
              currentValue: DateTime.now().weekday,
              labels: labels,
              textStyle: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 10,
                color: Colors.grey[700]
              ),
              context: context,
              color: color ?? Colors.redAccent,
              maxValueData: settingsManager.units == Unit.Pounds ? 400 : 200

          ),
        )
    );
  }


}
