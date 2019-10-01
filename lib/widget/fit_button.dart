import 'package:flutter/material.dart';


class FitButton extends StatelessWidget {


  final String buttonText;
  final VoidCallback onTap;
  final Color backgroundColor;

  FitButton({this.buttonText,this.onTap,this.backgroundColor });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ButtonTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        textTheme: ButtonTextTheme.primary,
        buttonColor: backgroundColor ?? Theme.of(context).primaryColor,
        child: RaisedButton(
          highlightElevation: 0,
          elevation: 0,
          onPressed: onTap,
          child: Text(buttonText,style: Theme.of(context).textTheme.subtitle.copyWith(
            color: Colors.white
          ),)
        ),
      ),
    );
  }
}
