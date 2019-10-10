import 'package:fitphone/widget/custom_timer_painter.dart';
import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {

  final int time;
  final ValueChanged<bool> onFinish;


  CountDownTimer({this.time,this.onFinish});

  @override
  _CountDownTimerState createState() => _CountDownTimerState();


}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  AnimationController controller;



  TextStyle _getFontStyle(BuildContext context){
    double width = MediaQuery.of(context).size.width;

    if(width <= 640 ){
      return Theme.of(context).textTheme.display3.copyWith(
        fontWeight: FontWeight.bold
      );
    }

    return Theme.of(context).textTheme.display4.copyWith(
        fontWeight: FontWeight.bold
    );
  }

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.time * 60),
    );

    controller.reverse(from: 1).then((f) => widget.onFinish(true));
    print(controller.isAnimating);


  }

  @override
  void dispose() {

    if(controller.isAnimating){
      controller.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Container(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context,child) => Center(
          child: Text(
            timerString,
            style: _getFontStyle(context))
        ),
      ),
    );

  }
}