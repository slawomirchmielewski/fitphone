import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class FitWorkoutCard extends StatelessWidget {

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDone;

  FitWorkoutCard({this.title, this.onTap,this.subtitle,this.isDone = false});


  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isDone == true ? true : false,
      leading: isDone == true ? Icon(Ionicons.ios_checkmark_circle,size: 32) : null,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }


}
