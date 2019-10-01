import 'package:fitphone/view/current_week_weight_screen.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:fitphone/widget/week_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class FitWeightWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final color = Colors.lightGreen;

    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);

    return CardBase(
        icon: Icons.multiline_chart,
        iconColor: color,
        action: weightViewModel.weekLoadingState == LoadingStates.loading ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            )) : null,
        title: "Weight Activity",
        onTap: (){
          showCupertinoModalPopup(context: context, builder: (context) => CurrentWeekWeightScreen());
        },
        child: Container(
            child: WeekWeightChart(
                color: Theme.of(context).primaryColor
            ),
        ),
    );
  }
}
