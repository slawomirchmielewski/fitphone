import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/setup_bloc.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/widget/page_base.dart';
import 'package:fitphone/widget/selection_button_small.dart';
import 'package:fitphone/utils/enums.dart';


class GoalView extends PageBase{

  final String title;

  GoalView({@required this.title}) :super(title : title);


  @override
  Widget build(BuildContext context) {

    SetupBloc setupBloc = BlocProvider.of<SetupBloc>(context);

    return StreamBuilder(
           stream: setupBloc.getFitnessGoal,
           initialData: FitnessGoal.FatLoss,
           builder: (context,snapshot){
             return SingleChildScrollView(
               child: Column(
                 children: <Widget>[
                   SizedBox(height: 36),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Text("What is your",style: Theme.of(context).textTheme.headline,),
                       SizedBox(width: 8),
                       Text("$title ?",style: Theme.of(context).textTheme.headline.copyWith(
                           fontWeight: FontWeight.bold
                       ),)
                     ],
                   ),
                   SizedBox(height: 72),
                   SmallSelectionButton<FitnessGoal>(title: "Fat Loss", value: FitnessGoal.FatLoss,isCustom: true, groupValue: snapshot.data , onChange: setupBloc.setFitnessGoal),
                   SizedBox(height: 16),
                   SmallSelectionButton<FitnessGoal>(title: "Muscle Gain", value: FitnessGoal.MuscleGain,isCustom: true, groupValue: snapshot.data , onChange: setupBloc.setFitnessGoal),
                 ],
               ),
             );
           }
    );
  }
}