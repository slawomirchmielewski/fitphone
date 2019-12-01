import 'package:fitphone/view_model/setup_manager.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/widget/fit_circular_button.dart';
import 'package:fitphone/widget/fit_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:fitphone/enums/setup_enums.dart';


class ActivityPickerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var setupManager = Provider.of<SetupManager>(context);
    var uiHelper = Provider.of<UIHelper>(context);


    String imageURI = MediaQuery.of(context).platformBrightness == Brightness.light ? 'assets/activity_light.png' : 'assets/activity_dark.png';

    showBottomSheet(String title,String text, int multiplier){
      showRoundedModalBottomSheet(
        dismissOnTap: false,
        context: context,
        radius: 15.0,
        color: Theme.of(context).canvasColor,
        builder: (context) {
          return Container(
            height: 200,
            padding: EdgeInsets.only(right: 32,left: 32),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(text,textAlign: TextAlign.center,style: Theme.of(context).textTheme.title),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(("Set Activity")),
                        onPressed: (){
                          Navigator.pop(context);
                          uiHelper.setButtonSelectedText(title);
                          setupManager.setActivityMultiplier(multiplier);
                          uiHelper.setActivitySelections(true);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 16)
                ],
              ),
            ),
          );
        },
      );
    }

    Widget getFatLossActivity(){
      return Container(
        child: Column(
          children: <Widget>[
            FitTextButton(
              text: "Significantly overweight female (40%+ body fat)",
              onTap: (title) {
                showBottomSheet(title,"Select this multiplier if you’re a female with over 40% body fat", 8);
              },
            ),
            SizedBox(height: 16),
            FitTextButton(
              text: "Significantly overweight male (30%+ body fat)\n OR \nSlightly overweight female (30-35%+ body fat)",
              onTap: (title) => showBottomSheet(title,"Select this multiplier if you’re a male with over 30% body fat OR a female between 30-45% body fat",9),
            ),
            SizedBox(height: 16),
            FitTextButton(
              text: "Slightly overweight male (20-25%+ body fat)\n OR \n a bit “fluffy” female (25-30% body fat)",
              onTap: (title) => showBottomSheet(title,"Select this multiplier if you’re a male between 20-25% body fat OR a female between 25-30% body fat",10),
            ),
            SizedBox(height: 16),
            FitTextButton(
              text: "A bit “fluffy” male (15-20% body fat) \n OR n\ lean but wanna get leaner female (~20% body fat",
              onTap: (title) => showBottomSheet(title,"Select this multiplier if you’re a male between 15-20% body fat OR a female around 20% body fat",11),
            ),
            SizedBox(height: 16),
            FitTextButton(
              text: "Lean but wanna get leaner male (~15% body fat)",
              onTap: (title) => showBottomSheet(title,"Select this multiplier if you’re a male around 15% body fat",12),
            ),
            SizedBox(height: 32),

          ],
        ),
      );
    }


    Widget getMuscleGainActivity(){
      return Container(
        child: Column(
          children: <Widget>[
            FitTextButton(
              text: "Easy gainer female",
              onTap: (title) => showBottomSheet(title,"Select this multiplier if you’re a female who gains weight easily",14),
            ),
            SizedBox(height: 16),
            FitTextButton(
              text: "Easy gainer male or hard gainer female",
              onTap: (title) => showBottomSheet(title,"Select this multiplier if you’re a male who gains weight easily OR a female who finds it hard to gain weight",16),
            ),
            SizedBox(height: 16),
            FitTextButton(
              text: "Hard gainer male",
              onTap: (title)  => showBottomSheet(title,"Select this multiplier if you’re a male who finds it hard to gain weight",18),
            ),
            SizedBox(height: 32),
          ],
        ),
      );
    }

    Widget getActivity(){
      Widget widget;

      if(setupManager.fitnessGoal == FitnessGoal.None){
        widget = Container();
      }
      else if(setupManager.fitnessGoal == FitnessGoal.FatLoss){
        widget = getFatLossActivity();
      }
      else if(setupManager.fitnessGoal == FitnessGoal.MuscleGain){
        widget = getMuscleGainActivity();
      }

      return widget;
    }

    Widget getSelection(){
      return Column(
        children: <Widget>[
          FitTextButton(text: uiHelper.buttonSelectedText, isSelected: true),
          SizedBox(height: 36),
          FlatButton(
              child: Text("Change selection"),
              onPressed: () => uiHelper.setActivitySelections(false)
            ),
          SizedBox(height: 72),
          FitCircularButton(onTap: (){
            uiHelper.setSetupPageIndex(5);
          })
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: () {
          uiHelper.setSetupPageIndex(3);
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
              Text("What is your activity level ?",style: Theme.of(context).textTheme.title),
              SizedBox(height: 72),
              Center(
                child: Image.asset(imageURI,height: 160,fit: BoxFit.fitHeight),
              ),
              SizedBox(height: 35),
              uiHelper.isActivitySelected ? getSelection() : getActivity()
            ],
          ),
        ),
      ),
    );
  }
}
