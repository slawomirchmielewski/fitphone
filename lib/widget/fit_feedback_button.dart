import 'package:flutter/material.dart';


class FitFeedbackButton extends StatelessWidget {

  final String imageUri;
  final String name;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChange;


  FitFeedbackButton({this.imageUri,this.name,this.value,this.groupValue,this.onChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange != null ? () {onChange(value);} : null,
      child: Container(
        width: 80,
        child: Column(
          children: <Widget>[
            Opacity(
                opacity: value == groupValue ? 1 : 0.3 ,
                child: Image.asset(imageUri,height: 40,width: 40,fit: BoxFit.cover,)),
            SizedBox(height: 8),
            Text(name,style: Theme.of(context).textTheme.subtitle.copyWith(
              fontSize: 10,
            ))
          ],
        ),
      ),
    );
  }
}
