import 'dart:io';

import 'package:fitphone/view_model/nutrtion_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:toast/toast.dart';



class NutritionUpdaterScreen extends StatefulWidget {

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  NutritionUpdaterScreen({this.calories,this.protein,this.carbs,this.fat});


  @override
  _NutritionUpdaterScreenState createState() => _NutritionUpdaterScreenState();
}

class _NutritionUpdaterScreenState extends State<NutritionUpdaterScreen> {


  int calories , protein, carbs,fat;

  @override
  void initState() {
    calories = widget.calories;
    protein = widget.protein;
    carbs = widget.carbs;
    fat = widget.fat;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   final nutritionViewModel = Provider.of<NutritionViewModel>(context);


   const double padding  = 16;

    Widget _buildUpdateRow(String name, String units , int vale,VoidCallback onMinusPress, VoidCallback onPlusPress){
      return Container(
        padding: const EdgeInsets.only(left: 8,right: 8),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(icon: Icon(SimpleLineIcons.minus),onPressed: onMinusPress),
            SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 80,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(vale.toString(),style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold
                          ),),
                          Text(units,style: Theme.of(context).textTheme.subtitle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10
                          ),),
                        ],
                      ))
                ),
                Text(name,style: Theme.of(context).textTheme.body1)
            ]),
            SizedBox(width: 8),
            IconButton(icon: Icon(SimpleLineIcons.plus),onPressed: onPlusPress),
          ],
        ),
      );
    }


    return Page(
      automaticallyImplyLeading: true,
      appBarTitle: Text("Nutrition"),
      actions: <Widget>[
        FlatButton(
          onPressed: (){

            var map = {
              "fat" : fat,
              "calories" : calories,
              "carbs" : carbs,
              "protein" : protein
            };

            nutritionViewModel.updateNutrition(map);
            Toast.show("Update saved", context);
            Navigator.pop(context);

          },
          child: Text("Save",style: Theme.of(context).textTheme.subhead.copyWith(
            color: Theme.of(context).primaryColor
          ),),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/nutrition_cover_image.png",fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.only(left: padding,right: padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 36),
                Text("Update your daily nutrition intake",style: Theme.of(context).textTheme.headline,maxLines: 2),
                SizedBox(height: 72),
                _buildUpdateRow("Calories","kcal",calories, () {
                  setState(() {
                    calories--;
                  });
                }, () {
                  setState(() {
                    calories++;
                  });
                }),
                _buildUpdateRow("Protein","g",protein, () {
                  setState(() {
                    protein--;
                  });
                }, () {
                  setState(() {
                    protein++;
                  });
                }),
                _buildUpdateRow("Carbs","g",carbs, () {
                  setState(() {
                    carbs--;
                  });
                }, () {
                  setState(() {
                    carbs++;
                  });

                }),
                _buildUpdateRow("Fat","g",fat, () {
                  setState(() {
                    fat--;
                  });
                }, () {
                  setState(() {
                    fat++;
                  });
                })
              ],
            ),
          )
        ],
      ),


    );
  }
}
