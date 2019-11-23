import 'package:flutter/material.dart';

class FitTextButton extends StatelessWidget {


  final String text;
  final String subText;
  final bool isSelected;
  final Function(String) onTap;

  FitTextButton({
    this.text = "",
    this.subText= "",
    this.isSelected = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
         color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(color: Theme.of(context).primaryColor,width: 1.5),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(text,style: Theme.of(context).textTheme.subtitle.copyWith(
            color: isSelected ? Colors.white: Theme.of(context).textTheme.title.color
          ),
          textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
