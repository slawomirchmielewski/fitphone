import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/model/nutrition_model.dart';



class NutritionTail extends StatelessWidget{

  final Nutrition nutrition;
  final String footerText;
  final IconData icon;
  final Color color;
  final Color iconColor;

  NutritionTail({this.nutrition,this.color,this.icon,this.iconColor = Colors.black,this.footerText = ""});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 100,
      height: 100,
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(15))),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon,color: Theme.of(context).iconTheme.color,size: 48),
            Text(nutrition.name.toUpperCase(),style: Theme.of(context).textTheme.headline.copyWith(
              fontWeight: FontWeight.bold
            )),
            Text(nutrition.value.toStringAsFixed(1),style: Theme.of(context).textTheme.display1.copyWith(
                fontWeight: FontWeight.bold,
                color: color
            )),
            Text(footerText)
          ],
        ),
      ),
    );
    
  }


}