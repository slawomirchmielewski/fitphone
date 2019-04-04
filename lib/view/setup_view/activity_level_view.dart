import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/setup_bloc.dart';
import 'package:fitphone/widget/page_base.dart';
import 'package:fitphone/widget/selection_button.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/utils/enums.dart';


class ActivityLevelView extends PageBase{


  final String title;

  ActivityLevelView({@required this.title}) : super(title: title);


  @override
  Widget build(BuildContext context) {

    SetupBloc setupBloc = BlocProvider.of<SetupBloc>(context);

    var fatLossContainer = StreamBuilder(
        stream: setupBloc.getActivityLevel,
        initialData: ActivityLevel.SignificantlyOverweightFemale,
        builder: (context, snapshot) {

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Chose your",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "$title",
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 72),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    SelectionButton<ActivityLevel>(
                        title: "Significantly overweight female",
                        subtitles: "select this multiplier if you’re a female with over 40% body fat",
                        value: ActivityLevel.SignificantlyOverweightFemale,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setActivityLevel),
                    SizedBox(height: 16),
                    SelectionButton<ActivityLevel>(
                        title: "Significantly overweight male or slightly overweight female" ,
                        subtitles: "select this multiplier if you’re a male with over 30% body fat OR a female between 30-45% body fat",
                        value: ActivityLevel.SignificantlyOverweightMale,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setActivityLevel),
                    SizedBox(height: 16),
                    SelectionButton<ActivityLevel>(
                        title: "Slightly overweight male or a bit “fluffy” female",
                        subtitles: "select this multiplier if you’re a male between 20-25% body fat OR a female between 25-30% body fat",
                        value: ActivityLevel.SlightlyOverweightMale,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setActivityLevel),
                    SizedBox(height: 16),
                    SelectionButton<ActivityLevel>(
                        title: "A bit “fluffy” male or lean but wanna get leaner female",
                        subtitles: "select this multiplier if you’re a male between 15-20% body fat OR a female around 20% body fat",
                        value: ActivityLevel.ABitFluffyMale,
                        groupValue: snapshot.data,
                        onChange:setupBloc.setActivityLevel),
                    SizedBox(height: 16),
                    SelectionButton<ActivityLevel>(
                        title: "Lean but wanna get leaner male",
                        subtitles: "select this multiplier if you’re a male around 15% body fat",
                        value: ActivityLevel.LeanButWannaGetLeanerMale,
                        groupValue: snapshot.data,
                        onChange:setupBloc.setActivityLevel),
                  ],
                ),
              )
            ],
          );
        });



    var muscleGainContainer  = StreamBuilder(
        stream: setupBloc.getActivityLevel,
        initialData: ActivityLevel.EasyGainerFemale,
        builder: (context, snapshot) {

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Chose your",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "$title",
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 72),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    SelectionButton<ActivityLevel>(
                        title: "Easy gainer female",
                        subtitles: "select this multiplier if you’re a female who gains weight easily",
                        value: ActivityLevel.EasyGainerFemale,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setActivityLevel),
                    SizedBox(height: 16),
                    SelectionButton<ActivityLevel>(
                        title: "Easy gainer male or hard gainer female" ,
                        subtitles: "select this multiplier if you’re a male who gains weight easily OR a female who finds it hard to gain weight",
                        value: ActivityLevel.EasyGainerMaleOrHardGainerFemale,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setActivityLevel),
                    SizedBox(height: 16),
                    SelectionButton<ActivityLevel>(
                        title: "Hard gainer male",
                        subtitles: "select this multiplier if you’re a male who finds it hard to gain weight",
                        value: ActivityLevel.HardGainerMale,
                        groupValue: snapshot.data,
                        onChange: setupBloc.setActivityLevel),
                  ],
                ),
              )
            ],
          );
        });



    return StreamBuilder<FitnessGoal>(
      stream: setupBloc.getFitnessGoal,
      builder: (context,snapshot){

        if(!snapshot.hasData){
          return Container();
        }

        if(snapshot.data == FitnessGoal.FatLoss){
          setupBloc.setActivityLevel(ActivityLevel.SignificantlyOverweightFemale);

          return fatLossContainer;

        }
        else if(snapshot.data == FitnessGoal.MuscleGain){
          setupBloc.setActivityLevel(ActivityLevel.EasyGainerFemale);
          return muscleGainContainer;
        }
        else{
          return Container();
        }

      }
    );
  }
}