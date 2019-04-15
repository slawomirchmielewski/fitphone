import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/model/program_model.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/programs_history_screen.dart';
import 'package:fitphone/widget/notification_dialog.dart';
import 'package:fitphone/widget/workout_marked_tile.dart';
import 'package:fitphone/widget/workout_view.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rounded_modal/rounded_modal.dart';

class ProgramsScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {


    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final ExerciseBloc exerciseBloc = BlocProvider.of<ExerciseBloc>(context);

    exerciseBloc.getWorkouts();
    Future<Null> _showNotification(){
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => NotificationDialog(
            imagePath: "assets/dumbeell.png",
            title: "New Program Available",
            boxFit: BoxFit.contain,
            backgroundColor: CustomColors.colorViolet,
            onTap: () => Navigator.pop(context),
          )
      );
    }

    Observable(exerciseBloc.getProgramNotification).first.then((data){
      if(data == true){
        print(data);
        _showNotification();
        exerciseBloc.setProgramNotification(false);
      }

    });

    return SafeArea(
         child: CustomScrollView(
           slivers: <Widget>[
             SliverAppBar(
               elevation: 3,
               centerTitle: false,
               forceElevated: false,
               expandedHeight: 100,
               pinned: true,
               iconTheme: Theme.of(context).iconTheme,
               actions: <Widget>[
                 IconButton(icon: Icon(Icons.history), onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ProgramsHistoryScreen()));
                 })
               ],
               flexibleSpace: FlexibleSpaceBar(
                 titlePadding: EdgeInsets.only(left:16,bottom: 16),
                 collapseMode: CollapseMode.pin,
                 centerTitle: false,
                 title:Text("Current Program",style: Theme.of(context).textTheme.title.copyWith(
                   fontWeight: FontWeight.bold
                 ),),
               ),
               automaticallyImplyLeading: false,
               brightness: Theme.of(context).brightness,
               textTheme: Theme.of(context).textTheme,
               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
             ),
             SliverList(delegate: SliverChildListDelegate([
                 Container(
                   padding: EdgeInsets.only(left: 16,right: 16,top: 16),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       StreamBuilder<User>(
                         stream: userBloc.getUser,
                         builder: (context, snapshot) {

                           if(!snapshot.hasData) return Container();

                           return GestureDetector(
                             onTap: () => showRoundedModalBottomSheet(
                               radius: 15,
                               color: Theme.of(context).scaffoldBackgroundColor,
                               context: context,
                               builder: (context) => Container(
                               padding: EdgeInsets.only(top: 16),
                               height: 180,
                               child: StreamBuilder<User>(
                                 stream: userBloc.getUser,
                                 builder: (context, intensitySnap) {

                                   if(!intensitySnap.hasData) return CircularProgressIndicator();

                                   return Column(
                                     children: <Widget>[
                                       Text("Program intensity",style: Theme.of(context).textTheme.headline.copyWith(
                                         color: Theme.of(context).textTheme.title.color
                                       )),
                                       SizedBox(height: 16),
                                       WorkoutMarketTile(title:"3 days",groupValue: intensitySnap.data.primaryWorkout,value: "3 days",onChange:(change){
                                         userBloc.updateProgramIntensity(change);
                                         exerciseBloc.getWorkouts();
                                         Navigator.pop(context);
                                       }),
                                       WorkoutMarketTile(title:"4 days",groupValue: intensitySnap.data.primaryWorkout,value: "4 days",onChange:(change) {
                                         userBloc.updateProgramIntensity(change);
                                         exerciseBloc.getWorkouts();
                                         Navigator.pop(context);
                                       }),
                                     ],
                                   );
                                 }
                               ),
                             )),
                             child: ClipRRect(
                               child: SizedBox(
                                 height: 36,
                                 width: 168,
                                 child: Container(
                                   color: CustomColors.colorLightGrey,
                                   child: Align(
                                     alignment: Alignment.center,
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: <Widget>[
                                         Text("${snapshot.data.primaryWorkout} per week" ,style: Theme.of(context).textTheme.subtitle.copyWith(
                                           fontWeight: FontWeight.w500,
                                           color: Colors.black
                                         ),),
                                         SizedBox(width: 4),
                                         Icon(Icons.arrow_drop_down,color: Colors.black)
                                       ],
                                     ),
                                   )
                                 ),
                               ),
                               borderRadius: BorderRadius.circular(25),
                             ),
                           );
                         }
                       ),

                       SizedBox(height: 32),
                       StreamBuilder<List<WorkoutModel>>(
                         stream: exerciseBloc.getWorkoutsList,
                         builder: (context,snapshot){

                           if(!snapshot.hasData) return Container();


                           if(snapshot.data.length == 0) return Center(child: Text("No data"));

                           return Container(
                             child: ListView.builder(
                               shrinkWrap: true,
                               physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                               itemCount: snapshot.data.length,
                                 itemBuilder: (context,index) => WorkoutViewTile(workoutModel: snapshot.data[index],)
                             ),
                           );
                         },
                       )

                     ],
                   )
                 )
             ])),
           ],
         ),
       );
  }
}