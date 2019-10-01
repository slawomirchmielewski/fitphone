import 'package:fitphone/widget/rounded_card_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FitRecentWorkoutsWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (BuildContext context, int value, Widget child) => RoundedCardBase(
        title: "Workouts",
        value: "0",
        description: "Workout complated",
        imageUrl: "assets/workout.png",
        onTap: (){
          //TODO Implement on button tap functionality
        },
        iconColor: Colors.orangeAccent,
        icon: Icons.fitness_center,
      ),
    );
  }
}
