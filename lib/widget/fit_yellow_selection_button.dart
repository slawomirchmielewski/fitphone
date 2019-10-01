import 'package:flutter/material.dart';

class FitYellowSelectionButton  extends StatelessWidget {


  final name;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChange;
  final double width;

  FitYellowSelectionButton({this.name,this.value,this.groupValue,this.onChange,this.width});


  @override
  Widget build(BuildContext context) {

    final TextStyle marketStyle = Theme.of(context).textTheme.subtitle.copyWith(
       fontWeight: FontWeight.bold,
       color: Theme.of(context).primaryColor
    );


    final TextStyle normalStyle = Theme.of(context).textTheme.subtitle.copyWith(
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.title.color
    );


    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8),
      child: GestureDetector(
        onTap: onChange != null ? () {onChange(value);} : null,
        child: Chip(
          elevation: 0,
          label: Text(value , style:  value == groupValue ? marketStyle : normalStyle),
          backgroundColor: value == groupValue ? Theme.of(context).primaryColorLight : Theme.of(context).scaffoldBackgroundColor,
          shape: value == groupValue ? null :  StadiumBorder(side: BorderSide(color: Colors.grey[200].withOpacity(0.6)))
        ),
      ),
    );
  }
}
