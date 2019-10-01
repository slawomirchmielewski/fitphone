import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';


class FitCircularButton extends StatelessWidget {


  final double radius;
  final VoidCallback onTap;

  FitCircularButton({
    this.radius = 72 ,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: Duration(seconds: 3),
      curve: Curves.bounceIn,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColor,width: 1)
          ),
          child: Icon(Icons.arrow_forward,color: Theme.of(context).iconTheme.color),

        ),
      ),
    );
  }
}
