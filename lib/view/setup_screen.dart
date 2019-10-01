import 'package:fitphone/view/setup_view/activity_picker_view.dart';
import 'package:fitphone/view/setup_view/diet_picker_view.dart';
import 'package:fitphone/view/setup_view/goal_picker_view.dart';
import 'package:fitphone/view/setup_view/summary_view.dart';
import 'package:fitphone/view/setup_view/unit_picker_view.dart';
import 'package:fitphone/view/setup_view/weight_picker_view.dart';
import 'package:fitphone/view/setup_view/welcome_view.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/widget/circle_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetupScreen extends StatelessWidget {

  final List<Widget> pages = [
    WelcomeView(),
    UnitPickerView(),
    WeightPickerView(),
    GoalPickerView(),
    ActivityPickerView(),
    DietPickerView(),
    SummaryView()
  ];

  @override
  Widget build(BuildContext context) {

    var uiHelper = Provider.of<UIHelper>(context);

    return Scaffold(
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  child: pages[uiHelper.setupPageIndex],
                ),
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: 30,
                width: double.infinity,
                child: ListView.builder(
                    padding: EdgeInsets.only(right: 32,left: 32),
                    scrollDirection: Axis.horizontal,
                    itemCount: pages.length,
                    itemBuilder: (context,index){
                      return CircleIndicator(
                        index: index,
                        groupIndex: uiHelper.setupPageIndex,
                      );
                    }
                ),
              )
            ],
          )
      ),
    );
  }
}
