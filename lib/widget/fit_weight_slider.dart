import 'package:fitphone/view_model/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'package:fitphone/enums/setup_enums.dart';


class FitWeightSlider extends StatelessWidget {


  final double value;
  final Function(double) onDragging;
  final Function(double) onDragCompleted;


  FitWeightSlider({this.value,this.onDragging,this.onDragCompleted});


  @override
  Widget build(BuildContext context) {

    var settingsManager = Provider.of<SettingsManager>(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(settingsManager.getConvertedWeight(value).round().toString(),style: Theme.of(context).textTheme.display3.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.title.color
            )),
            Text(settingsManager != null ? settingsManager.unitShortName : "",style: Theme.of(context).textTheme.display1.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.title.color
            )),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 100,
          width: double.infinity,
          child: FlutterSlider(
            handler: FlutterSliderHandler(
                disabled: true,
                child: Container(
                  height: 10,
                  width: 10,
                  color: Theme.of(context).primaryColor
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor)
            ),
            values: [settingsManager.getConvertedWeight(value)],
            max: settingsManager.units == Unit.Kilograms ? 200.0 : 440.0,
            min: 0.0,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              onDragging(settingsManager.setConvertedWeight(lowerValue));
            },
            tooltip: FlutterSliderTooltip(
                disabled: true,
                textStyle: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.white : Colors.black),
                boxStyle: FlutterSliderTooltipBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle
                    )
                )
            ),
            trackBar: FlutterSliderTrackBar(
              activeTrackBar: BoxDecoration(color: Theme.of(context).primaryColor),
              inactiveTrackBar: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
              activeTrackBarHeight: 5,
            ),
            onDragCompleted: (handlerIndex, lowerValue, upperValue){
              onDragCompleted(lowerValue);
            },
            hatchMark: FlutterSliderHatchMark(
              bigLine: FlutterSliderSizedBox(height: 10, width: 1,decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
              smallLine: FlutterSliderSizedBox(height: 5, width: 1,decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
              labelTextStyle: Theme.of(context).textTheme.subtitle,
              distanceFromTrackBar: 40,
              density: 0.2, // means 50 lines, from 0 to 100 percent
              labels: [
                FlutterSliderHatchMarkLabel(percent: 0, label: settingsManager.units == Unit.Kilograms ? '0kg' : '0lbs'),
                FlutterSliderHatchMarkLabel(percent: 50, label: settingsManager.units == Unit.Kilograms ? '100kg' : '220lbs'),
                FlutterSliderHatchMarkLabel(percent: 100, label: settingsManager.units == Unit.Kilograms ? '200kg' : '440lbs'),
              ],
            ),
            jump: true,
          ),
        ),
      ],
    );
  }
}
