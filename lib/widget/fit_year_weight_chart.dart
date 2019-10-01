import 'package:fitphone/enums/setup_enums.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/widget/fit_custom_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FitYearWeightChart extends StatelessWidget {
  final Color color;

  FitYearWeightChart({this.color});

  @override
  Widget build(BuildContext context) {

    //final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    final List<double> points = [100,89,78,78,120,78,89,87,0,0,0,0];
    final List<String> labels = ["Jun","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

   /* for(var i = 0 ; i < labels.length;i++){
      for(var y = 0 ; y < weightViewModel.weekWeightList.length ;y++){
        if(weightViewModel.weekWeightList[y].getDayName() == labels[i]){
          points[i] = settingsManager.getConvertedWeight(weightViewModel.weekWeightList[y].weight);
        }
      }
    }*/

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
