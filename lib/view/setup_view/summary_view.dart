import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/setup_bloc.dart';
import 'package:fitphone/model/nutrition_model.dart';
import 'package:fitphone/widget/nutrition_icons_icons.dart';
import 'package:fitphone/widget/nutrition_tile.dart';
import 'package:fitphone/widget/page_base.dart';
import 'package:flutter/material.dart';



class SummaryView extends PageBase{

  final String title;
  
  SummaryView({@required this.title}) : super(title: title);


  @override
  Widget build(BuildContext context) {

    final SetupBloc setupBloc = BlocProvider.of<SetupBloc>(context);
    setupBloc.calculateMacros();

    return Container(
      padding: EdgeInsets.only(top: 36),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("We calculated nutritions \n based on your anwsers",style: Theme.of(context).textTheme.headline.copyWith(
              fontWeight: FontWeight.bold
            ),textAlign: TextAlign.center,),
            SizedBox(height: 64),
            StreamBuilder<List<Nutrition>>(
              stream: setupBloc.getNutrition,
              builder: (context, snapshot) {

                if(!snapshot.hasData) return Container();

                return Container(
                  height: 480,
                  width: double.infinity,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: <Widget>[
                        NutritionTail(nutrition: snapshot.data[0],icon: NutritionIcons.cauliflower,color: Colors.orange,),
                        NutritionTail(nutrition: snapshot.data[1],icon: NutritionIcons.meat,color: Colors.cyan,),
                        NutritionTail(nutrition: snapshot.data[2],icon: NutritionIcons.wheat_grains,color: Colors.purpleAccent,),
                        NutritionTail(nutrition: snapshot.data[3],icon: NutritionIcons.papaya,color: Colors.pinkAccent,)
                    ],),
                );
              }
            )
          ],
        ),
      ),

    );
  }
}