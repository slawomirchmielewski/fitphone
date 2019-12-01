import 'package:flutter/material.dart';

class FitSmallSelectionButton<T> extends StatelessWidget {


  final name;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChange;
  final double width;

  FitSmallSelectionButton({
    @required this.name,
    @required this.value,
    @required this.groupValue,
    @required this.onChange,
    this.width = 120
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange != null ? () {onChange(value);} : null,
      child: SizedBox(
        //height: 36,
        width: width,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Text(name,style: Theme.of(context).textTheme.subtitle.copyWith(
              color: value == groupValue ? Colors.white : Theme.of(context).primaryColor,
            ),),
          ),
          decoration: BoxDecoration(
            color: value == groupValue ? Theme.of(context).primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor,width: 1.5)
          ),
        ),
      ),
    );
  }
}
