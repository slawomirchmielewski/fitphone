import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/setup_bloc.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/widget/page_base.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/utils/enums.dart';
import 'package:fitphone/widget/selection_button.dart';

class DietStyleView extends PageBase {
  final String title;

  DietStyleView({@required this.title}) : super(title: title);

  @override
  Widget build(BuildContext context) {

    SetupBloc setupBloc = BlocProvider.of<SetupBloc>(context);

    return StreamBuilder(
        stream: setupBloc.getDietStyle,
        initialData: DietStyle.BalancedApproach,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Chose your",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "$title",
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 72),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    SelectionButton<DietStyle>(
                        title: "Balanced Approach",
                        subtitles: "In this diet, you’ll be eating a balanced amount of carbs and fats and is best for those who prefer an even amount of carbohydrates and fats.",
                        value: DietStyle.BalancedApproach,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setDietStyle),
                    SizedBox(height: 16),
                    SelectionButton<DietStyle>(
                        title: "Higher Carb / Lower Fat" ,
                        subtitles: "This diet is for those who prefer a larger amount of carbs to fats.",
                        value: DietStyle.HigherCarbLowerFat,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setDietStyle),
                    SizedBox(height: 16),
                    SelectionButton<DietStyle>(
                        title: "Lower Carb/Higher Fat",
                        subtitles: "This diet is for those who prefer a larger amount of fats to carbs, but don’t want to eliminate carbohydrates entirely.",
                        value: DietStyle.LowerCarbHigherFat,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setDietStyle),
                    SizedBox(height: 16),
                    SelectionButton<DietStyle>(
                        title: "Ketogenic",
                        subtitles: "This is a super high fat and extremely low carb diet (<30g of carbs per day). This is a really restrictive diet and not best suited for most. But if you enjoy eating keto, then you can use this approach.",
                        value: DietStyle.Ketogenic,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setDietStyle),
                  ],
                ),
              )
            ],
          );
        });
  }
}
