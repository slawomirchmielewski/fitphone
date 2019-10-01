import 'package:fitphone/view_model/setup_manager.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/widget/fit_circular_button.dart';
import 'package:fitphone/widget/fit_small_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitphone/enums/setup_enums.dart';


class GoalPickerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var setupManager = Provider.of<SetupManager>(context);
    var uiHelper = Provider.of<UIHelper>(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: () {
          uiHelper.setSetupPageIndex(2);
          uiHelper.setGoalButtonVisibility(false);
          setupManager.setFitnessGoal(FitnessGoal.None);
        }),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(right: 16,left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 36),
              Text("What is your fitness goal ?",style: Theme.of(context).textTheme.title),
              SizedBox(height: 72),
              Center(
                child: Image.asset("assets/goal_image.png",height: 160,fit: BoxFit.fitHeight),
              ),
              SizedBox(height: 72),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FitSmallSelectionButton(
                      width: 100,
                      value: FitnessGoal.FatLoss,
                      name: "Fat Loss",
                      groupValue: setupManager.fitnessGoal,
                      onChange: (value) {
                        uiHelper.setGoalButtonVisibility(true);
                        setupManager.setFitnessGoal(value);
                      },
                    ),
                    SizedBox(height:16),
                    FitSmallSelectionButton(
                        width: 100,
                        value: FitnessGoal.MuscleGain,
                        name: "Muscle Gain",
                        groupValue: setupManager.fitnessGoal,
                        onChange: (value) {
                          uiHelper.setGoalButtonVisibility(true);
                          setupManager.setFitnessGoal(value);
                        }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 72),
              uiHelper.isGoalButtonVisible == true ? Container(
                  child: Center(child: FitCircularButton(
                      onTap: () =>  uiHelper.setSetupPageIndex(4)))) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
