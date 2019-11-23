import 'package:fitphone/enums/setup_enums.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/fit_custom_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_util/date_util.dart' as date;

class FitMonthWeightChart extends StatelessWidget {
  final Color color;

  FitMonthWeightChart({this.color});

  @override
  Widget build(BuildContext context) {

    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    final List<double> points = [];
    final List<String> labels = [];


    date.DateUtil dateUtil = date.DateUtil();


    for(int i = 1 ; i < dateUtil.daysInMonth(DateTime.now().month, DateTime.now().year) ; i++){
      points.add(0);
      labels.add(i.toString());
    }

     for(var i = 0 ; i < labels.length;i++){
      for(var y = 0 ; y < weightViewModel.monthWeightList.length ;y++){
        if(weightViewModel.monthWeightList[y].day.toString() == labels[i]){
          points[i] = settingsManager.getConvertedWeight(weightViewModel.monthWeightList[y].weight);
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
