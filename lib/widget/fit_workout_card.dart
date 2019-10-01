import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:flutter/material.dart';


class FitWorkoutCard extends StatelessWidget {

  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  FitWorkoutCard({this.title, this.onTap,this.subtitle,this.iconColor});


  @override
  Widget build(BuildContext context) {
    return CardBase(
      icon: Icons.sort,
      iconColor: iconColor,
      title: "Exercises",
      onTap: onTap,
      child: ListTile(
        title: Text(title,style: Theme.of(context).textTheme.subhead.copyWith(
          fontWeight: FontWeight.w600
        ),),
        subtitle: Text(subtitle),
      ),
    );
  }


}
