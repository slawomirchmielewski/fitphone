import 'package:fitphone/view/measurements_month_view.dart';
import 'package:fitphone/view/measurements_week_view.dart';
import 'package:fitphone/view/measurements_year_view.dart';
import 'package:fitphone/view_model/measurements_view_model.dart';
import 'package:fitphone/widget/fit_measurement_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MeasurementView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final MeasurementsViewModel measurementsViewModel = Provider.of<MeasurementsViewModel>(context);


    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FitMeasurementCard(
                name: "Hips",
                vale: measurementsViewModel.currentMeasurement.length > 0 ?  measurementsViewModel.currentMeasurement[0]?.hips: 0,
                onTap: (){},
              ),
              FitMeasurementCard(
                name: "Chest",
                vale: measurementsViewModel.currentMeasurement.length > 0 ?  measurementsViewModel.currentMeasurement[0]?.chest : 0,
                onTap: (){},
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FitMeasurementCard(
                name: "Waist",
                vale: measurementsViewModel.currentMeasurement.length > 0 ?  measurementsViewModel.currentMeasurement[0]?.waist : 0,
                onTap: (){},
              ),
              FitMeasurementCard(
                name: "Arms",
                vale: measurementsViewModel.currentMeasurement.length > 0 ?  measurementsViewModel.currentMeasurement[0]?.arms : 0,
                onTap: (){},
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FitMeasurementCard(
                name: "Calves",
                vale: measurementsViewModel.currentMeasurement.length > 0 ?  measurementsViewModel.currentMeasurement[0]?.calves : 0,
                onTap: (){},
              ),
              FitMeasurementCard(
                name: "Thigh",
                vale: measurementsViewModel.currentMeasurement.length > 0 ?  measurementsViewModel.currentMeasurement[0]?.thigh : 0,
                onTap: (){},
              ),
            ],
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("Activity",style: Theme.of(context).textTheme.title.copyWith(
              fontWeight: FontWeight.bold
            )),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text("This week"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> MeasurementsWeekView()))
          ),
          ListTile(
            title: Text("This month"),
            trailing: Icon(Icons.arrow_forward_ios),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> MeasurementsMonthView()))
          ),
          ListTile(
            title: Text("This year"),
            trailing: Icon(Icons.arrow_forward_ios),
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> MeasurementsYearView()))
          )
        ],
      ),
    );
  }
}
