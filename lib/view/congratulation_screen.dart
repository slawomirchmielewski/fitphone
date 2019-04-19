import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:flutter/material.dart';


class CongratulationScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {


    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    final ExerciseBloc exerciseBloc = BlocProvider.of<ExerciseBloc>(context);



    String getWorkoutNumber(int number){
      String endName;

      switch(number){
        case 1:
          endName = "st";
          break;
        case 2:
          endName = "nd";
          break;
        case 3:
          endName = "rd";
          break;
        default:
          endName = "th";

      }


      return "$number$endName";
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
                if(Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                exerciseBloc.setPageIndex(0);
                exerciseBloc.setDoneExerciseCounter(0);
                exerciseBloc.setCurrentPage(0);
                exerciseBloc.setProgressBarValue(0);


            },
            child: Icon(Icons.close)),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        brightness: Theme.of(context).brightness,
      ),
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/trophy.png"),fit: BoxFit.fill)
                  ),
                ),
                SizedBox(height: 36),
                Text("Congratulation !",style: Theme.of(context).textTheme.headline.copyWith(
                  fontWeight: FontWeight.bold
                )),
                SizedBox(height: 16),
                StreamBuilder<User>(
                  stream: userBloc.getUser,
                  builder: (context, snapshot) {
                    return snapshot.hasData ? Text("You finished your ${getWorkoutNumber(snapshot.data.workoutsCompleted)} workout",style: Theme.of(context).textTheme.subhead,
                    ) : Container();
                  }
                ),
                SizedBox(height: 72),
                Text("Total weight lifted",style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 16),
                StreamBuilder<String>(
                  stream: applicationBloc.getUnitText,
                  builder: (context, unitTextSnap) {
                    return StreamBuilder<double>(
                      stream: exerciseBloc.getTotalWeight,
                      builder: (context, snapshot) {
                        return Text("${snapshot.hasData ? snapshot.data.toString() : ""} ${unitTextSnap.hasData ? unitTextSnap.data : ""}"
                            ,style: Theme.of(context).textTheme.display2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.title.color
                            ));
                      }
                    );
                  }
                )
              ],
            ),
          )),
    );
  }

}