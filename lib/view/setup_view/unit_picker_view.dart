import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/widget/fit_circular_button.dart';
import 'package:fitphone/widget/fit_small_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitphone/enums/setup_enums.dart';

class UnitPickerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var uiHelper = Provider.of<UIHelper>(context);
    var settingsManager = Provider.of<SettingsManager>(context);

    String imageURI = MediaQuery.of(context).platformBrightness == Brightness.light ? 'assets/unit_light.png' : 'assets/unit_dark.png';
    
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: () {
          uiHelper.setSetupPageIndex(0);
          settingsManager.setUnits(Unit.None);
          uiHelper.setUnitButtonVisibility(false);
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
              Text("With units you would like to use ?",style: Theme.of(context).textTheme.title,),
              SizedBox(height: 72),
              Center(
                child: Image.asset(imageURI,height: 160,fit: BoxFit.fitHeight),
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
                      value: Unit.Kilograms,
                      name: "Kg",
                      groupValue: settingsManager.units,
                      onChange: (value) {
                        settingsManager.setUnits(value);
                        uiHelper.setUnitButtonVisibility(true);
                      },
                    ),
                    SizedBox(height:16),
                    FitSmallSelectionButton(
                      width: 100,
                      value: Unit.Pounds,
                      name: "Lbs",
                      groupValue: settingsManager.units,
                      onChange: (value) {
                        settingsManager.setUnits(value);
                        uiHelper.setUnitButtonVisibility(true);
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 72),
              uiHelper.isUnitsButtonVisible == true ? Container(
                child: Center(child: FitCircularButton(
                  onTap: () =>  uiHelper.setSetupPageIndex(2)))) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
