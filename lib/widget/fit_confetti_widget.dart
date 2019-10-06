import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';


class FitConfettiWidget extends StatefulWidget {

  final Widget child;

  FitConfettiWidget({this.child});

  @override
  _FitConfettiWidgetState createState() => _FitConfettiWidgetState();
}

class _FitConfettiWidgetState extends State<FitConfettiWidget> {


  ConfettiController _controllerTopCenter;

  @override
  void initState() {
    _controllerTopCenter = ConfettiController(duration: Duration(seconds: 5));
    _controllerTopCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    if(_controllerTopCenter.state == ConfettiControllerState.playing){
      _controllerTopCenter.stop();
    }
    _controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
          confettiController: _controllerTopCenter,
          blastDirection: pi / 2,
          maxBlastForce: 5,
          minBlastForce: 2,
          emissionFrequency: 0.03,
          numberOfParticles: 15,
        ))
      ],
    );
  }
}
