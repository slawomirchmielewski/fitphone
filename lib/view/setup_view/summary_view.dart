import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fitphone/view_model/session_manager.dart';
import 'package:fitphone/view_model/setup_manager.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/widget/fit_circular_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:fitphone/enums/session_states.dart';

class SummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var setupManager = Provider.of<SetupManager>(context);
    var uiHelper = Provider.of<UIHelper>(context);
    var sessionManager = Provider.of<SessionManager>(context);

    if(uiHelper.isNutritionVisible == false){
      Future.delayed(Duration(milliseconds: 7000),() => uiHelper.setNutritionVisibility(true));
    }

    if(setupManager.calculationFinished == false)
    setupManager.calculateNutrition();


    Widget nutritionText(String value,String unit ,String name){
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(value,style: Theme.of(context).textTheme.headline.copyWith(
                fontWeight: FontWeight.bold
              ),),
              Text(unit,style: Theme.of(context).textTheme.subtitle.copyWith(
                  fontWeight: FontWeight.bold
              ),)
            ],
          ),
          SizedBox(height: 4),
          Text(name,style: Theme.of(context).textTheme.subtitle)
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: () {
         uiHelper.setSetupPageIndex(5);
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
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FadeAnimatedTextKit(
                    duration: Duration(milliseconds: 10000),
                    alignment: Alignment.centerLeft,
                    isRepeatingAnimation: false,
                    textAlign: TextAlign.center,
                    textStyle: Theme.of(context).textTheme.title,
                    text: [
                      "Great job !!!",
                      "We calculated your daily nutrition intake."
                    ],
                  ),

                ),
              ),
              SizedBox(height: 72),
              if(uiHelper.isNutritionVisible) FadeIn(
                duration: Duration(milliseconds: 2000),
                child: Container(
                    height: 120,
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset("assets/summary_image.png",fit: BoxFit.fitWidth,)
                    )
                ),
              ),

              SizedBox(height: 72),
               if(uiHelper.isNutritionVisible) FadeIn(
                duration: Duration(milliseconds: 2000),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        nutritionText(setupManager.calories.round().toString(),"kcal","Calories"),
                        nutritionText(setupManager.proteins.round().toString(),"g","Protein")
                      ],
                    ),
                    SizedBox(height: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        nutritionText(setupManager.carbs.round().toString(),"g","Carbs"),
                        nutritionText(setupManager.fat.round().toString(),"g","Fat")
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 72),
              if(uiHelper.isNutritionVisible) Center(
                child: FitCircularButton(
                  onTap: (){
                    sessionManager.setRegisterStatus(false);
                    sessionManager.setSessionState(SessionState.Authenticated);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
