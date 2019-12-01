import 'package:fitphone/view_model/measurements_view_model.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class RecordMeasurementsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);

    TextStyle style = theme.textTheme.subhead.copyWith(
        color: theme.primaryColor
    );

    TextStyle valueStyle = theme.textTheme.title.copyWith(
      fontWeight: FontWeight.bold
    );


    final MeasurementsViewModel measurementsViewModel = Provider.of<MeasurementsViewModel>(context);


    return Page(
      automaticallyImplyLeading: true,
      appBarTitle: Text("Body Measurements"),
      pageName: "Body Measurements",
      actions: <Widget>[
        FlatButton(
          child: Text("Save",style: style,),
          onPressed: (){
            measurementsViewModel.addMeasurements();
            Provider.of<UserViewModel>(context).addPoints(5);
            measurementsViewModel.clearMeasurements();
            Navigator.pop(context);
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 72),
          Center(child: Text(DateFormat.yMMMd().format(DateTime.now()),style: Theme.of(context).textTheme.headline)),
          SizedBox(height: 72),
          Container(
            width: 120,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "0 cm",
                  ),
                  style: valueStyle,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) => measurementsViewModel.setChestValue(double.parse(text)),
                ),
                SizedBox(height: 8),
                Text("Chest")
              ],
            ),
          ),
          SizedBox(height: 36),
          Container(
            width: 120,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "0 cm",
                  ),
                  style: valueStyle,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) => measurementsViewModel.setArmsValue(double.parse(text)),
                ),
                SizedBox(height: 8),
                Text("Arms")
              ],
            ),
          ),
          SizedBox(height: 36),
          Container(
            width: 120,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "0 cm",
                  ),
                  style: valueStyle,
                  textAlign: TextAlign.center,
                  keyboardType:  TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) => measurementsViewModel.setWaistValue(double.parse(text)),
                ),
                SizedBox(height: 8),
                Text("Waist")
              ],
            ),
          ),
          SizedBox(height: 36),
          Container(
            width: 120,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "0 cm",
                  ),
                  style: valueStyle,
                  textAlign: TextAlign.center,
                  keyboardType:  TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) => measurementsViewModel.setHipsValue(double.parse(text)),
                ),
                SizedBox(height: 8),
                Text("Hips")
              ],
            ),
          ),
          SizedBox(height: 36),
          Container(
            width: 120,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "0 cm",
                  ),
                  style: valueStyle,
                  textAlign: TextAlign.center,
                  keyboardType:  TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) => measurementsViewModel.setCalvesValue(double.parse(text)),
                ),
                SizedBox(height: 8),
                Text("Calves")
              ],
            ),
          ),
          SizedBox(height: 36),
          Container(
            width: 120,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "0 cm",
                  ),
                  style: valueStyle,
                  textAlign: TextAlign.center,
                  keyboardType:  TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) => measurementsViewModel.setThighValue(double.parse(text)),
                ),
                SizedBox(height: 8),
                Text("Thigh")
              ],
            ),

          ),
          SizedBox(height: 36),
        ],
      ),
    );
  }
}
