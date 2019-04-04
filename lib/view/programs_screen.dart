import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/widget/notification_dialog.dart';
import 'package:fitphone/widget/workout_marked_tile.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProgramsScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {


    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final ExerciseBloc exerciseBloc = BlocProvider.of<ExerciseBloc>(context);



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
      }
      exerciseBloc.setProgramNotification(false);
    });

   return StreamBuilder<List<String>>(
     stream: exerciseBloc.getProgramsNames,
     builder: (context, snapshot) {

       if(!snapshot.hasData) return Container(child: Center(child: CircularProgressIndicator()));



       if(snapshot.data.length == 0) {
         return Scaffold(
             appBar: AppBar(
                 title: Text("Programs",style: Theme.of(context).textTheme.title.copyWith(
                     fontWeight: FontWeight.bold
                 ),),
                 automaticallyImplyLeading:true,
                 centerTitle: true,
                 elevation: 0.0,
                 brightness: Theme.of(context).brightness,
                 iconTheme: Theme.of(context).iconTheme,
                 textTheme: Theme.of(context).textTheme,
                 backgroundColor: Theme.of(context).scaffoldBackgroundColor
             ),
             body: Center(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Container(
                       width: 150,
                       height: 150,
                       decoration: BoxDecoration(
                         image: DecorationImage(image: AssetImage("assets/list.png"),fit: BoxFit.contain),
                       ),
                     ),
                     SizedBox(height: 16),
                     Text("No programs available",style: Theme.of(context).textTheme.subtitle.copyWith(
                       color: Colors.grey,
                     ),)
                   ],
                 )
             )
         );
       }

       return SafeArea(
         child: Padding(
           padding: const EdgeInsets.all(16.0),
           child: CustomScrollView(
             slivers: <Widget>[
               SliverAppBar(
                 elevation: 0,
                 centerTitle: true,
                 forceElevated: true,
                 automaticallyImplyLeading: false,
                 brightness: Theme.of(context).brightness,
                 title: Text("Programs",style: Theme.of(context).textTheme.title.copyWith(
                   fontWeight: FontWeight.bold
                 ),),
                 textTheme: Theme.of(context).textTheme,
                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
               ),
               SliverList(delegate: SliverChildListDelegate([
                 Text("Program",style: Theme.of(context).textTheme.title.copyWith(
                     fontWeight: FontWeight.bold
                 )),
                 SizedBox(height: 8),
                 ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
                    return StreamBuilder<User>(
                      stream: userBloc.getUser,
                      initialData: User(),
                      builder: (context, user) {
                        return WorkoutMarketTile(
                            title: snapshot.data[index].toString(),
                            groupValue: user.data.primaryWorkout,
                            value: snapshot.data[index].toString(),
                            onChange: (value) {
                                exerciseBloc.setPrimaryProgram(value);
                            },
                        );
                      }
                    );
                   }),
                 Text("History",style: Theme.of(context).textTheme.title.copyWith(
                     fontWeight: FontWeight.bold
                 )),
               ])),
             ],
           ),
         ),
       );
     }
   );
  }
}