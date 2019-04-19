import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:flutter/material.dart';



class ProgramsHistoryScreen extends StatelessWidget{



  @override
  Widget build(BuildContext context) {

    ExerciseBloc exerciseBloc = BlocProvider.of<ExerciseBloc>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Programs",style: Theme.of(context).textTheme.title),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
          child: StreamBuilder<List<String>>(
              stream: exerciseBloc.getProgramNames,
              builder: (context, snapshot){

                if(!snapshot.hasData) return Center(child: CircularProgressIndicator());

                return ListView.builder(

                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index) => ListTile(
                      title: Text(snapshot.data[index]),
                      trailing: IconButton(icon:Icon(Icons.file_download), onPressed: (){})
                    ));
              }
          )
      ),
    );
  }
}
