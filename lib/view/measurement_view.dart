import 'package:fitphone/widget/fit_measurement_card.dart';
import 'package:flutter/material.dart';


class MeasurementView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[

          Row(
            children: <Widget>[
              FitMeasurementCard(
                name: "Hips",
                vale: 67,
                onTap: (){},
              ),
              FitMeasurementCard(
                name: "Chest",
                vale: 67,
                onTap: (){},
              ),
            ],
          ),
          SizedBox(height: 36),
          Row(
            children: <Widget>[
              FitMeasurementCard(
                name: "Waist",
                vale: 67,
                onTap: (){},
              ),
              FitMeasurementCard(
                name: "Arm",
                vale: 67,
                onTap: (){},
              ),
            ],
          )
        ],
      ),
    );
  }
}
