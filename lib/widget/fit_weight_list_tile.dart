import 'package:fitphone/model/weight_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FitWeightListTile extends StatelessWidget {

  final WeightModel weightModel;
  final VoidCallback onLongPress;
  
  FitWeightListTile(this.weightModel,{this.onLongPress});

  @override
  Widget build(BuildContext context) {

    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    return ListTile(
      onLongPress: onLongPress,
      contentPadding: EdgeInsets.only(bottom: 8,top: 8),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Theme.of(context).primaryColorLight,
        child: Text(weightModel.getDayName(),style: Theme.of(context).textTheme.subtitle,),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text("${settingsManager.getConvertedWeight(weightModel.weight).round()}",style: Theme.of(context).textTheme.subhead.copyWith(
            fontWeight: FontWeight.bold
          ),),
          Text("${settingsManager.unitShortName}"),
        ],
      ),
      subtitle: Text(weightModel.getDate()),

    );
  }
}
