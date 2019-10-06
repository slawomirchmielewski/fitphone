import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/new_level_screen.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/fit_completed_workouts_card.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_nutrition_widget.dart';
import 'package:fitphone/widget/fit_profile_image.dart';
import 'package:fitphone/widget/fit_progress_bar_widget.dart';
import 'package:fitphone/widget/fit_weight_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final pageName = "Home";
    final UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    Future.delayed(Duration(seconds: 1)).then((_) {
      if(userViewModel.newLevelAvailable == true){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewLevelScreen(),fullscreenDialog: true));
        userViewModel.setNewLevelAvailable(false);
      }
    });


    return Page(
    pageName: pageName,
     // backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? greyBackground : Theme.of(context).scaffoldBackgroundColor,
     // appBarColor: MediaQuery.of(context).platformBrightness == Brightness.light ? greyBackground  : Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 100,
      centerTitle: true,
      actions: <Widget>[
        FitProfileImage(radius: 18,)
      ],
      children: <Widget>[
        FitNutritionWidget(),
        FitProgressBarWidget(),
        FitCompletedWorkoutsCard(),
        FitWeightWidget(),

      ],
    );
  }
}
