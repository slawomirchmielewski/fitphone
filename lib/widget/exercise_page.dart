import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/widget/custom_tile.dart';
import 'package:fitphone/widget/youtube_player.dart';
import 'package:flutter/material.dart';


class ExercisePage extends StatelessWidget{

  final ExerciseModel exercise;

  ExercisePage({this.exercise});

  Widget _buildContainer(Widget widget) {
    return Container(
      width: 60,
      child: Align(
        alignment: Alignment.center,
        child: widget,
      ),
    );
  }


  Widget _buildLabels(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildContainer(Text("Set",style: Theme.of(context).textTheme.subtitle.copyWith(
          fontWeight: FontWeight.bold
        ))),
        _buildContainer(Text("Weight",style: Theme.of(context).textTheme.subtitle.copyWith(
            fontWeight: FontWeight.bold
        ))),
        _buildContainer(Text("Reps",style: Theme.of(context).textTheme.subtitle.copyWith(
            fontWeight: FontWeight.bold
        ))),
        _buildContainer(Icon(Icons.done)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final ExerciseBloc exerciseBloc = BlocProvider.of<ExerciseBloc>(context);


    print((exercise.url));

    return Container(
      child: Column(
        children: <Widget>[
          Text(exercise.name != null ? exercise.name : "",style: Theme.of(context).textTheme.title.copyWith(
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 16),
          Container(
            child: exercise != null ?  VideoPlayer(exercise.url) : Container(height: 200)
          ),
          SizedBox(height: 32),
          _buildLabels(context),
          SizedBox(height: 8),
          Flexible(
            flex: 1,
            child: ListView.builder(
                itemCount: exercise.set,
                physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                itemBuilder: (context,index){
                  return CustomTile(
                    sets: (index+1).toString(),
                    reps: exercise.reps,
                    onPress: () => exerciseBloc.incrementDoneExerciseCounter()
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}