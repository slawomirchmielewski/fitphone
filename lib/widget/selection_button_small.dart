import 'package:fitphone/utils/colors.dart';
import 'package:flutter/material.dart';



class SmallSelectionButton<T> extends StatelessWidget{

  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChange;
  final bool isCustom;


  SmallSelectionButton({
    @required this.title,
    @required this.value,
    @required this.groupValue,
    @required this.onChange,
    this.isCustom
  });

  @override
  Widget build(BuildContext context) {
    
    Color selectedColor = Theme.of(context).textTheme.title.color;
    Color unselectedColor = Color.fromARGB(50, 0,0, 0);

    return ButtonTheme(
      minWidth: isCustom == true ? double.infinity : Theme.of(context).buttonTheme.minWidth,
      height: isCustom == true ? 50 : Theme.of(context).buttonTheme.height,
      child: RaisedButton(
        child: Text(title,style: value == groupValue ? Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold) : Theme.of(context).textTheme.body1 ),
        color: Theme.of(context).scaffoldBackgroundColor,
        disabledColor: Colors.transparent,
        shape: RoundedRectangleBorder(side: BorderSide(color: value == groupValue ? selectedColor : unselectedColor),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        onPressed: onChange != null ?() {onChange(value);} : null,
        elevation: 0,
      ),
    );
  }



}