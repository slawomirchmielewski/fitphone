import 'package:fitphone/view/new_level_screen.dart';
import 'package:fitphone/view/profile_screen.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/fit_completed_workouts_card.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_nutrition_widget.dart';
import 'package:fitphone/widget/fit_profile_image.dart';
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
      haveTitle: true,
      titleTriling: FitProfileImage(
          radius: 20,
          onTap:() => showCupertinoModalPopup(context: context, builder: (context) => ProfileScreen())),
      appBarTitle: Text(pageName),
      actions: <Widget>[

      ],
      child: Column(
        children: <Widget>[
          FitNutritionWidget(),
          FitWeightWidget(),
          FitCompletedWorkoutsCard(),
        ],
      ),
    );
  }
}
