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
          children: <Widget>[
            Text(name,style: Theme.of(context).textTheme.subhead.copyWith(
              fontWeight: FontWeight.normal
            ),),
            Spacer(
              flex: 3,
            ),
            IconButton(icon: Icon(SimpleLineIcons.minus),onPressed: onMinusPress),
            SizedBox(width: 8),
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
            SizedBox(width: 8),
            IconButton(icon: Icon(SimpleLineIcons.plus),onPressed: onPlusPress),
          ],
        ),
      );
    }


    return Page(
      automaticallyImplyLeading: true,
      actions: <Widget>[
        FlatButton(
          onPressed: (){

            var map = {
              "fat" : fat,
              "calories" : calories,
              "carbs" : carbs,
              "protein" : protein
            };

            nutritionViewModel.updateNutrition(map).then((_) => Toast.show("Update saved", context))
                .catchError((error) => Toast.show(error, context));
          },
          child: Text("Save",style: Theme.of(context).textTheme.subtitle.copyWith(
            color: Theme.of(context).primaryColor
          ),),
        ),
      ],
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: padding,right: padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 36),
              Text("Update your daily nutrition intake.",style: Theme.of(context).textTheme.title),
              SizedBox(height: 72),
              Container(
                  height: 120,
                  child: Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/nutrition_image.png",fit: BoxFit.fitWidth,)
                  )
              ),
              SizedBox(height: 16),
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

    );
  }
}
