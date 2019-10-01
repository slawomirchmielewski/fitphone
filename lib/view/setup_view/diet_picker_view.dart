import 'package:fitphone/view_model/setup_manager.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/widget/fit_circular_button.dart';
import 'package:fitphone/widget/fit_small_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitphone/enums/setup_enums.dart';


class DietPickerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var setupManager = Provider.of<SetupManager>(context);
    var uiHelper = Provider.of<UIHelper>(context);

    const double buttonWidth = 200;

    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: () {
            uiHelper.setSetupPageIndex(4);
        }),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 16,right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 36),
              Text("What is your diet style ?",style: Theme.of(context).textTheme.title),
              SizedBox(height: 72),
              Container(
                  height: 120,
                  child: Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/diet_image.png",fit: BoxFit.fitWidth,)
                  )
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height:36),
                     FitSmallSelectionButton(
                      width: buttonWidth,
                      value: DietStyle.BalanceApproach,
                      name: "Balance Approach",
                      groupValue: setupManager.dietStyle,
                      onChange: (value) {
                        setupManager.setDietStyle(value);
                        uiHelper.setDietButtonVisibility(true);
                      },
                    ),
                    SizedBox(height:16),
                    FitSmallSelectionButton(
                        width: buttonWidth,
                        value: DietStyle.HighCarbLowerFat,
                        name: "Higher Carb / Lower Fat",
                        groupValue: setupManager.dietStyle,
                        onChange: (value) {
                          setupManager.setDietStyle(value);
                          uiHelper.setDietButtonVisibility(true);
                        }
                    ),
                    SizedBox(height:16),
                    FitSmallSelectionButton(
                        width: buttonWidth,
                        value: DietStyle.LowCarbHigherFat,
                        name: "Low Carb / Higher Fat",
                        groupValue: setupManager.dietStyle,
                        onChange: (value) {
                          setupManager.setDietStyle(value);
                          uiHelper.setDietButtonVisibility(true);
                        }
                    ),
                    SizedBox(height:16),
                    FitSmallSelectionButton(
                        width: buttonWidth,
                        value: DietStyle.Ketogenic,
                        name: "Kategonic",
                        groupValue: setupManager.dietStyle,
                        onChange: (value) {
                          setupManager.setDietStyle(value);
                          uiHelper.setDietButtonVisibility(true);
                        }
                    ),
                    SizedBox(height: 72),
                    uiHelper.isDietButtonVisible == true ? Container(
                        child: Center(child: FitCircularButton(
                            onTap: () =>  uiHelper.setSetupPageIndex(6)))) : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
