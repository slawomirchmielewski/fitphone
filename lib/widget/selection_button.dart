import 'package:flutter/material.dart';
import 'package:fitphone/utils/colors.dart';


class SelectionButton<T> extends StatelessWidget{

  final String title;
  final String subtitles;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChange;


  SelectionButton({this.title = "",
    this.subtitles = "",
    @required this.value,
    @required this.groupValue,
    @required this.onChange});

  @override
  Widget build(BuildContext context) {

    Color unselectedColor = Color.fromARGB(50, 0,0, 0);

    return GestureDetector(
      onTap: onChange != null ?() {onChange(value);} : null,
      child: Container(
        padding: EdgeInsets.all(16.0),
        //height: 200,
        decoration: BoxDecoration(
            gradient:  value == groupValue ? LinearGradient(colors: [CustomColors.colorLightRed,CustomColors.colorViolet],begin: Alignment.centerLeft,end: Alignment.centerRight) :
            LinearGradient(colors: [Colors.transparent,Colors.transparent],begin: Alignment.centerLeft,end: Alignment.centerRight) ,
            border: Border.all(
            color: value == groupValue ? Theme.of(context).scaffoldBackgroundColor : unselectedColor,
            width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(title,textAlign: TextAlign.center, style: value == groupValue ?  Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold,color: Colors.white) : Theme.of(context).textTheme.title),
              SizedBox(height: 16),
              Text(subtitles,textAlign: TextAlign.center, style: value == groupValue ?  Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.bold,color: Colors.white) : Theme.of(context).textTheme.subtitle)
              ],
          )
        ),
      ),
    );
  }

}