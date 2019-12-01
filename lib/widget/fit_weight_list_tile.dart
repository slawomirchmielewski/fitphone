import 'package:fitphone/model/weight_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';

class FitWeightListTile extends StatelessWidget {

  final WeightModel weightModel;
  
  FitWeightListTile(this.weightModel);

  @override
  Widget build(BuildContext context) {

    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);
    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);


    return ListTile(
      onLongPress: (){
        showRoundedModalBottomSheet(
            color: Theme.of(context).canvasColor,
            radius: 15,
            context: context,
            builder: (context) => Container(
              padding: EdgeInsets.only(top: 8,bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete weight"),
                    onTap: (){
                      weightViewModel.deleteWeight(weightModel.id).then((_){

                      }).catchError((error){
                        print(error);
                      });
                      Navigator.pop(context);
                    },),
                  ListTile(leading: Icon(Icons.edit),title: Text("Update weight"),onTap: (){
                    Navigator.pop(context);
                    showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                          return Transform(
                            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                            child: Opacity(
                              opacity: a1.value,
                              child: AlertDialog(
                                shape: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15.0)),
                                title: Text("Update weight"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("${weightModel.getDate()} : ${settingsManager.getConvertedWeight(weightModel.weight).round()}${settingsManager.unitShortName}",style:
                                      Theme.of(context).textTheme.subhead.copyWith(
                                        fontWeight: FontWeight.bold
                                      ),),
                                    TextField(
                                      onChanged: (text){
                                        weightViewModel.setWeightToUpdate(settingsManager.setConvertedWeight(double.parse(text)));
                                      },
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        hintText: "Enter new weight"
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    FitButton(
                                      buttonText: "Update",
                                      onTap: (){
                                        weightViewModel.updateWeight(weightModel.id);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                )
                              ),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {
                          return Container();
                        });
                  },),
                ],
              ),
            ));
      },
      contentPadding: EdgeInsets.only(bottom: 8,top: 8),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Theme.of(context).primaryColorLight,
        child: Text(weightModel.getDayName(),style: Theme.of(context).textTheme.subtitle,),
      ),
      title: Text("${settingsManager.getConvertedWeight(weightModel.weight).round()} ${settingsManager.unitShortName}"),
      subtitle: Text(weightModel.getDate()),

    );
  }
}
