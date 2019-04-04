import 'package:flutter/material.dart';


class AnimatedText extends StatefulWidget{

  final int duration;
  final Widget child;

  AnimatedText({this.child,this.duration,});

  @override
  AnimatedTextState createState() {
    return new AnimatedTextState();
  }
}

class AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
      duration: Duration(seconds: widget.duration)
    );


    _animation = Tween(
      begin: 0.0,
      end: 1.0
    ).animate(_animationController);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return FadeTransition(
      opacity: _animation,
      child: widget.child
    );

  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}