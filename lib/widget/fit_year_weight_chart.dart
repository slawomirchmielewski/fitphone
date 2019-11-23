import 'dart:math';

import 'package:fitphone/enums/setup_enums.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/fit_custom_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FitYearWeightChart extends StatelessWidget {
  final Color color;

  FitYearWeightChart({this.color});

  @override
  Widget build(BuildContext context) {

    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    final List<double> points = [];
    final List<String> labels = ["Jun","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

    for(int i = 0 ; i <labels.length ; i++){
      points.add(0);
    }

    for(var i = 0 ; i < labels.length;i++){
      for(var y = 0 ; y < weightViewModel.yearWeightList.length ;y++){
        if(weightViewModel.yearWeightList[y].month == i + 1){
          points[i] = settingsManager.getConvertedWeight(weightViewModel.yearWeightList[y].weight);
        }
      }
    }

    return Container(
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width,200),
          foregroundPainter: FitCustomWeightChart(
              data: points,
              currentValue: DateTime.now().month,
              labels: labels,
              textStyle: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: 10,
                  color: Colors.grey[700]
              ),
              context: context,
              color: color ?? Theme.of(context).primaryColor,
              maxValueData: settingsManager.units == Unit.Pounds ? 400 : 200

          ),
        )
    );
  }
}
