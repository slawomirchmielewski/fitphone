import 'package:fitphone/utils/date_helper.dart';
import 'package:fitphone/view/current_month_weight_screen.dart';
import 'package:fitphone/view/current_week_weight_screen.dart';
import 'package:fitphone/view/current_year_weight_screen.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:fitphone/widget/fit_month_weight_chart.dart';
import 'package:fitphone/widget/fit_year_weight_chart.dart';
import 'package:fitphone/widget/week_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class FitChartsSwitcher extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    final UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
        fontWeight: FontWeight.bold
    );

    return Column(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Start"),
                      Text("${settingsManager.getConvertedWeight(userViewModel.user.weight).roundToDouble()} ${settingsManager.unitShortName}",style: style)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Now"),
                      Text("${settingsManager.getConvertedWeight(weightViewModel.currentWeight.weight).roundToDouble()} ${settingsManager.unitShortName}",style: style)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(weightViewModel.getWeightDifferentText(userViewModel.user.weight)),
                      Text("${settingsManager.getConvertedWeight(weightViewModel.calculateWeightDifferent(userViewModel.user.weight)).roundToDouble()} ${settingsManager.unitShortName}",style: style)
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 36),
        CardBase(
          backgroundColor: Colors.transparent,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentWeekWeightScreen()));
          },

          haveAction: true,
          child: Column(
            children: <Widget>[
              Text("${DateFormat.yMMMd().format(weightViewModel.weekDates.first)} to ${DateFormat.yMMMd().format(weightViewModel.weekDates.last)}",style: Theme.of(context).textTheme.subtitle.copyWith(
                  fontWeight: FontWeight.w700
              )),
              SizedBox(height: 36),
              WeekWeightChart(color: Colors.greenAccent)
            ],
          ),
        ),
        SizedBox(height: 36),
        CardBase(
          backgroundColor: Colors.transparent,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentMonthWeightScreen()));

          },
          haveAction: true,
          child: Column(
            children: <Widget>[
              Text(DateHelper.getMonthName(DateTime.now().month),style: Theme.of(context).textTheme.subhead.copyWith(
                  fontWeight: FontWeight.w700
              ),),
              SizedBox(height: 16),
              FitMonthWeightChart(color: Colors.lightBlueAccent),
            ],
          ),
        ),
        SizedBox(height: 36),
        CardBase(
          backgroundColor: Colors.transparent,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentYearWeightScreen()));
          },
          haveAction: true,
          child: Column(
            children: <Widget>[
              Text("${DateTime.now().year}",style: Theme.of(context).textTheme.subhead.copyWith(
                  fontWeight: FontWeight.w700
              ),),
              SizedBox(height: 16),
              FitYearWeightChart(color: Colors.orange[400],),
            ],
          ),
        ),
      ],
    );
  }
}
