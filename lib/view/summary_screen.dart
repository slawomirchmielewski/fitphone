import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/model/weight_model.dart';
import 'package:fitphone/widget/weight_chart.dart';
import 'package:flutter/material.dart';

class SummeryScreen extends StatelessWidget{
  

  Icon _getIcon(List<WeightModel> data, int index){
     Icon icon =  Icon(Icons.arrow_drop_down);

     if(index == 0){
       icon = Icon(Icons.arrow_right,color: Colors.orange,);
     }
     else if(index > 0 && index < data.length){

       if(data[index].weight < data[index - 1].weight){
         icon = Icon(Icons.arrow_drop_down,color: Colors.green,);
       }
       else if(data[index].weight > data[index - 1].weight){
         icon = Icon(Icons.arrow_drop_up,color: Colors.red,);
       }
       else{
         icon = Icon(Icons.arrow_right,color: Colors.orange,);
       }

     }
     return icon;
  }

  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);


  return CustomScrollView(
    slivers: <Widget>[
      SliverAppBar(
        elevation: 3,
        centerTitle: true,
        forceElevated: false,
        expandedHeight: 100,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          titlePadding: EdgeInsets.only(left: 16,bottom: 16),
          centerTitle: false,
          title:Text("Summary",style: Theme.of(context).textTheme.title.copyWith(
              fontWeight: FontWeight.bold
          ),),
        ),
        automaticallyImplyLeading: false,
        brightness: Theme.of(context).brightness,
        textTheme: Theme.of(context).textTheme,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      SliverList(delegate: SliverChildListDelegate([
        StreamBuilder<List<WeightModel>>(
          stream: userBloc.getWeightList,
          builder: (context, snapshot) {


            if(!snapshot.hasData) return Center(child: CircularProgressIndicator());

            if(snapshot.data.length == 0) return Center(child: Text("No data"));

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                WeightChart(name: "Weight", data: snapshot.data),
                ListView.builder(
                    shrinkWrap: true,
                    physics: PageScrollPhysics(parent: NeverScrollableScrollPhysics()),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index){
                      return StreamBuilder<String>(
                          stream: applicationBloc.getUnitText,
                          builder: (context, unit) {
                            return ListTile(
                              leading: _getIcon(snapshot.data, index),
                              title: Text("${snapshot.data[index].weight} ${unit.data}",style: Theme.of(context).textTheme.body1.copyWith(
                                  fontWeight: FontWeight.bold
                              ),),
                              trailing: Text((snapshot.data[index].date)),
                            );
                          }
                      );
                    }
                )

              ],
            );
          }
        )
      ]))
    ],
  );

  }
}