import 'package:fitphone/utils/colors.dart';
import 'package:flutter/material.dart';


class NutritionTileSmall extends StatelessWidget{

  final IconData icon;
  final String name;
  final double value;

  NutritionTileSmall({this.icon,this.name,this.value});


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 120,
        width: 86,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon,size: 24,),
            Text(name,style: Theme.of(context).textTheme.subtitle),
            Text(value.toStringAsFixed(1),style: Theme.of(context).textTheme.title.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold
            ))
          ],
        ),
      ),
    );
  }

}