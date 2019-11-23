import 'package:fitphone/view/nutrition_updater_screen.dart';
import 'package:fitphone/view_model/nutrtion_view_model.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:fitphone/widget/base_widget/image_card_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FitNutritionWidget extends CardBase {


  Widget nutritionColumn(BuildContext context , String value, String name,String unit){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(value,style: Theme.of(context).textTheme.subtitle.copyWith(
              fontWeight: FontWeight.bold
            )),
            Text(unit,style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 10)),
          ],
        ),
        SizedBox(height: 4),
        Text(name,style: Theme.of(context).textTheme.body1.copyWith(
            fontSize: 12,
        ))
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    return Consumer<NutritionViewModel>(
      builder: (context,nutritionViewModel,_) => ImageCardBase(
        title: "Nutrition",
        imagePath: "assets/nutrition_cover_image.png",
        onTap: (){
          showCupertinoModalPopup(context: context, builder: (context) => NutritionUpdaterScreen(
            calories: nutritionViewModel.nutrition.calories,
            protein: nutritionViewModel.nutrition.protein,
            carbs:  nutritionViewModel.nutrition.carbs,
            fat: nutritionViewModel.nutrition.fat,
          ));
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              nutritionColumn(context, (nutritionViewModel.nutrition != null ? nutritionViewModel.nutrition.calories.toString() : "0"), "Calories", "kcal"),
              nutritionColumn(context, (nutritionViewModel.nutrition != null ? nutritionViewModel.nutrition.protein.toString() : "0"), "Protein", "g"),
              nutritionColumn(context, (nutritionViewModel.nutrition != null ? nutritionViewModel.nutrition.carbs.toString() : "0"), "Carbs", "g"),
              nutritionColumn(context, (nutritionViewModel.nutrition != null ? nutritionViewModel.nutrition.fat.toString() : "0") ,"Fat", "g"),
            ],
          ),
      ),
    );
  }
}
