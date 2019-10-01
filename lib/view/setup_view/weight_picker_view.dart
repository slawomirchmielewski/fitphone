import 'package:fitphone/view_model/setup_manager.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/widget/fit_circular_button.dart';
import 'package:fitphone/widget/fit_weight_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightPickerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var setupManager = Provider.of<SetupManager>(context);
    var uiHelper = Provider.of<UIHelper>(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: () {
          uiHelper.setSetupPageIndex(1);
          uiHelper.setWeightButtonVisibility(false);
          setupManager.setWeight(0.0);
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
              Text("Move slider to set your weight.",style: Theme.of(context).textTheme.title),
              SizedBox(height: 72),
              Container(
                  height: 120,
                  child: Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/weight.png",fit: BoxFit.fitWidth,)
                  )
              ),
              SizedBox(height: 16),
              FitWeightSlider(
                value: setupManager.weight != null ? setupManager.weight : 0.0,
                onDragging:(value)=> setupManager.setWeight(value),
                onDragCompleted: (value) => uiHelper.setWeightButtonVisibility(true),
              ),
              SizedBox(height: 64),
              uiHelper.isWeightButtonVisible ? Container(
                  width: double.infinity,
                  child: Align(
                      alignment: Alignment.center,
                      child: FitCircularButton(onTap: () => uiHelper.setSetupPageIndex(3)))) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
