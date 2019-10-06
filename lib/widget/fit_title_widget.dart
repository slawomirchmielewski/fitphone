import 'package:flutter/material.dart';


class FitTitle extends StatelessWidget {

  final String title;

  FitTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,style: Theme.of(context).textTheme.headline.copyWith(
      fontWeight: FontWeight.bold
    ),);
  }
}
