import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/model/weight_model.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:rounded_modal/rounded_modal.dart';



class WeightChart extends StatelessWidget {

  final List<WeightModel> data;
  final String name;

  WeightChart({this.data, this.name});

  final List<DropdownMenuItem<int>> months = [
    DropdownMenuItem<int>(child: Text("3 Months"), value: 1),
    DropdownMenuItem<int>(child: Text("6 Months"), value: 2),
    DropdownMenuItem<int>(child: Text("9 Months"), value: 3)
  ];


  List<WeightModel> _getDate(int value, UserBloc userBloc){
    
    List<WeightModel> list = [];
    
    switch(value){
      case 1:
        list = userBloc.getThreeMonthsData();
        break;
      case 2:
        list =  userBloc.getSixMonthsData();;
        break;
      case 3:
        list =  userBloc.getNineMonthsData();
        break;
    }
    
    return list;

  }


  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    ApplicationBloc applicationBloc =  BlocProvider.of<ApplicationBloc>(context);

    return Container(
      height: 500.0,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [CustomColors.colorLightRed,CustomColors.colorViolet],begin: Alignment.topLeft,end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name, style: Theme.of(context).textTheme.display1.copyWith(
            color: Colors.white
          )),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DropdownButtonHideUnderline(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.black
                    ),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: StreamBuilder<int>(
                        stream: userBloc.getMonthSelectorValue,
                        builder: (context, snapshot) {
                          return DropdownButton(
                              isExpanded: false,
                              value: snapshot.data,
                              items: months,
                              style: TextStyle(color: Colors.white),
                              elevation: 0,
                              onChanged: userBloc.setMonthSelectorValue
                          );
                        }
                      ),
                    ),
                  )
              ),

              FlatButton.icon(
                icon: Icon(Icons.add),
                label: Text("New Weight"),
                textColor: Colors.white,
                onPressed:() => showRoundedModalBottomSheet(
                  radius: 15,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.all(16),
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Add weight",style: Theme.of(context).textTheme.subhead.copyWith(
                            fontWeight: FontWeight.bold
                        ),),
                        StreamBuilder(
                          stream: applicationBloc.getUnitText,
                          builder: (context, snapshot) => TextField(
                            onChanged: (value) {
                              userBloc.setWeight(double.parse(value));
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.numberWithOptions(),
                            style: Theme.of(context).textTheme.display1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.title.color
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "${snapshot.data}"),
                          ),
                        ),
                        RaisedButton(
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.only(left: 64,right: 64),
                          elevation: 0,
                          child:Text("Add",style: Theme.of(context).textTheme.body1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                          textColor: Colors.white,
                          onPressed:  () {
                            userBloc.addNewWeight();
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  )
                )
              ),
            ],
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  StreamBuilder<List<WeightModel>>(
                    stream: userBloc.getWeightList,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData ? snapshot.data[0].weight.toString() : "No data",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
                      );
                    }
                  ),
                  SizedBox(width: 8),
                  Text("Start", style: Theme.of(context).textTheme.body2.copyWith(
                    color: Colors.white
                  )),
                ],
              ),
              Column(
                children: <Widget>[
                  StreamBuilder<List<WeightModel>>(
                    stream: userBloc.getWeightList,
                    builder: (context, snapshot) {
                      return Text(snapshot.hasData ? snapshot.data.last.weight.toString() : "No data",
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontWeight: FontWeight.bold,color: Colors.white));
                    }
                  ),
                  SizedBox(width: 8),
                  Text("Current", style: Theme.of(context).textTheme.body2.copyWith(
                    color: Colors.white
                  )),
                ],
              ),
              Column(
                children: <Widget>[
                  StreamBuilder<List<WeightModel>>(
                    stream: userBloc.getWeightList,
                    builder: (context, snapshot) {
                      return Row(
                        children: <Widget>[
                          Icon(snapshot.hasData ? (snapshot.data.last.weight - snapshot.data.first.weight > 0 ? Icons.arrow_upward : Icons.arrow_downward): Icons.arrow_upward,
                            color:Colors.white),
                          Text(
                          snapshot.hasData ? "${(snapshot.data.last.weight - snapshot.data.first.weight).abs().toStringAsPrecision(3)}" : "No data",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(fontWeight: FontWeight.bold,color: Colors.white)),
                        ],
                      );
                    }
                  ),
                  SizedBox(width: 8),
                  StreamBuilder<List<WeightModel>>(
                    stream: userBloc.getWeightList,
                    builder: (context, snapshot) {
                      return Text("Change(${userBloc.calculateBodyWeightPercent().toStringAsPrecision(3)}%)",
                          style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white));
                    }
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
              height: 250,
              child: StreamBuilder<WeightUnit>(
                stream: applicationBloc.weightUnit,
                builder: (context, snapshot) {
                  return StreamBuilder<int>(
                    stream: userBloc.getMonthSelectorValue,
                    builder: (context, value) {
                      return LineChart(
                        chartPadding: new EdgeInsets.fromLTRB(40.0, 20.0, 8.0, 30.0),
                        lines: [
                          new Line<WeightModel, String, double>(
                              data: _getDate(value.data,userBloc),
                              xFn: (out) => out.getDateForChart(),
                              yFn: (out) => out.weight,
                              xAxis: new ChartAxis(
                                  hideTickNotch: true,
                                  hideLine: true,
                                  opposite: false,
                                  paint: const PaintOptions.fill(
                                      strokeWidth: 1.0, color: Colors.white10),
                                  tickLabelerStyle: Theme.of(context).textTheme.subtitle.copyWith(
                                      color: Colors.white,
                                      fontSize: 8.0)),
                              yAxis: new ChartAxis(
                                  hideTickNotch: true,
                                  hideLine: true,
                                  span:snapshot.data == WeightUnit.Kilogram ? new DoubleSpan(50, 120) : new DoubleSpan(100, 260),
                                  tickGenerator: snapshot.data == WeightUnit.Kilogram ?  IntervalTickGenerator.byN(10) : IntervalTickGenerator.byN(20),
                                  opposite: false,
                                  paint: const PaintOptions.fill(
                                      strokeWidth: 1.0, color: Colors.white10),
                                  tickLabelerStyle: Theme.of(context).textTheme.body1.copyWith(color: Colors.white)),
                              stroke: PaintOptions.stroke(
                                  color: Colors.white,
                                  strokeWidth: 2.0),
                              fill: PaintOptions.fill(
                                  color: Color.fromARGB(100, 255, 255, 255)),
                              marker: MarkerOptions(
                                  size: 4.0,
                                  shape: MarkerShapes.circle,
                                  paint: PaintOptions.fill(color: Colors.white))),
                        ],
                      );
                    }
                  );
                }
              ))
        ],
      ),
    );
  }
}
