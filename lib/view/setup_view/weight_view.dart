import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/setup_bloc.dart';
import 'package:fitphone/utils/enums.dart';
import 'package:fitphone/widget/selection_button_small.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/widget/page_base.dart';

class WeightView extends PageBase {

  final String title;


  WeightView({@required this.title}) : super(title : title);


  Widget build(BuildContext context) {

    final SetupBloc setupBloc = BlocProvider.of<SetupBloc>(context);
    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);


    setupBloc.saveWeightUnit(WeightUnit.Kilogram);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("What is your",style: Theme.of(context).textTheme.headline,),
              SizedBox(width: 8),
              StreamBuilder<String>(
                stream: applicationBloc.getUnitText,
                builder: (context, snapshot) {
                  return Text("$title in ${snapshot.data} ?",style: Theme.of(context).textTheme.headline.copyWith(
                      fontWeight: FontWeight.bold
                  ),);
                }
              ),
            ],
          ),
          SizedBox(height: 72),
          StreamBuilder<WeightUnit>(
              stream: setupBloc.weightUnit,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SmallSelectionButton(title: "kg", value: WeightUnit.Kilogram,groupValue: snapshot.data,onChange:(value) {
                      applicationBloc.setWeightUnit(value);
                      setupBloc.saveWeightUnit(value);
                    }),
                    SmallSelectionButton(title: "lbs", value: WeightUnit.Pound,groupValue: snapshot.data,onChange: (value) {
                      applicationBloc.setWeightUnit(value);
                     setupBloc.saveWeightUnit(value);
                    }),
                  ],
                );
              }
          ),
          SizedBox(height: 36),
          StreamBuilder(
            stream: applicationBloc.getUnitText,
            builder: (context,snapshot) =>
                TextField(
                  autofocus: true,
                  onChanged:(value) => setupBloc.setWeight(double.parse(value)),
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.display2.copyWith(
                    color: Theme.of(context).textTheme.title.color,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    hintText: "${snapshot.data}",
                    hintStyle: Theme.of(context).textTheme.display2.copyWith(
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
          ),
        ],
      ),
    );
  }

}