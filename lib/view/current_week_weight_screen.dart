import 'package:fitphone/enums/setup_enums.dart';
import 'package:fitphone/view/embaded_view/record_weight_view.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_weight_list_tile.dart';
import 'package:fitphone/widget/week_weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:intl/intl.dart';

class CurrentWeekWeightScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    String pageName = "Weight activity";

    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    const double padding = 16;

    return Page(
      automaticallyImplyLeading: true,
      pageName: pageName,
      appBarTitle: Text(pageName),
      actions: <Widget>[
        ActionButton(
          icon: Icons.add,
          onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordWeightView()));
          }
        )
      ],
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: padding,right: padding),
          child: Column(
            children: <Widget>[
              SizedBox(height: 32),
              Center(child: Text("${DateFormat.yMMMd().format(weightViewModel.weekDates.first)} to ${DateFormat.yMMMd().format(weightViewModel.weekDates.last)}",style: Theme.of(context).textTheme.subtitle)),
              SizedBox(height: 32),
              Container(
                 padding: EdgeInsets.all(16),
                 decoration: BoxDecoration( 
                   borderRadius: BorderRadius.circular(15),
                   color: Theme.of(context).primaryColorLight
                 ),
                  child: WeekWeightChart(
                    color: Theme.of(context).primaryColor,
                  )
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  itemCount: weightViewModel.weekWeightList.length,
                  itemBuilder: (context,index) {

                    weightViewModel.weekWeightList.sort((a,b) => a.date.compareTo(b.date));

                    return FitWeightListTile(
                      weightViewModel.weekWeightList[index],
                      onLongPress: () {
                        showRoundedModalBottomSheet(
                            color: Theme.of(context).primaryColorLight,
                            radius: 15,
                            context: context,
                            builder: (context) => Container(
                              padding: EdgeInsets.only(top: 8,bottom: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(SimpleLineIcons.trash),
                                    title: Text("Delete weight"),
                                    onTap: (){
                                    weightViewModel.deleteWeight(weightViewModel.weekWeightList[index].id).then((_){

                                    }).catchError((error){
                                      print(error);
                                    });
                                    Navigator.pop(context);
                                  },),
                                  ListTile(leading: Icon(SimpleLineIcons.pencil),title: Text("Update weight"),onTap: (){
                                    Navigator.pop(context);
                                  },),
                                ],
                              ),
                            ));
                      },
                    );}
              ),
            ],
          ),
        )
      ],
    );
  }
}
