import 'package:fitphone/model/measurments_model.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:fitphone/view_model/measurements_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:toast/toast.dart';


class MeasurementsListTile extends StatelessWidget {

  final Measurements measurements;
  final isYearTile;

  MeasurementsListTile({@required this.measurements,this.isYearTile = false});

  @override
  Widget build(BuildContext context) {

    TextStyle valueStyle = Theme.of(context).textTheme.body1.copyWith(
      fontSize: 14,
    );

    TextStyle nameStyle = Theme.of(context).textTheme.body1.copyWith(
      fontSize: 10,
    );


    String _getDateText(){
      if(isYearTile == true){
        return "${DateHelper.getMonthName(measurements.month)} ${measurements.year}";
      }

      else
        {
          return DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(measurements.date));
        }
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      child: InkWell(
        onLongPress: (){
          showRoundedModalBottomSheet(
              color: Theme.of(context).canvasColor,
              radius: 15,
              context: context,
              builder: (context) => Column(
                mainAxisSize:MainAxisSize.min,
                children: <Widget>[
                  Consumer<MeasurementsViewModel>(
                    builder: (context,measurementsViewModel,_) =>
                    ListTile(
                      onTap: (){
                        measurementsViewModel.deleteMeasurements(measurements.id);
                        Toast.show("Measurements deleted", context);
                        Navigator.pop(context);
                      },
                      leading: Icon(Icons.delete),
                      title: Text("Delete measurements"),
          ),
                  ),
                ],
              ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Text(_getDateText(),style: Theme.of(context).textTheme.body1.copyWith(
                 color: Theme.of(context).primaryColor
               ),),
               SizedBox(height: 8),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 mainAxisSize: MainAxisSize.max,
                 children: <Widget>[
                   Column(
                     children: <Widget>[
                       Text(measurements.chest.roundToDouble().toString(),style: Theme.of(context).textTheme.body1.copyWith(
                         fontSize: 14,
                       ),),
                       Text("Chest",style: nameStyle)
                     ],
                   ),
                   Column(
                     children: <Widget>[
                       Text(measurements.arms.roundToDouble().toString(),style: valueStyle,),
                       Text("Arms",style: nameStyle,)
                     ],
                   ),
                   Column(
                     children: <Widget>[
                       Text(measurements.hips.roundToDouble().toString(),style: valueStyle,),
                       Text("Hips",style: nameStyle,)
                     ],
                   ),
                   Column(
                     children: <Widget>[
                       Text(measurements.waist.roundToDouble().toString(),style: valueStyle,),
                       Text("Waist",style: nameStyle,)
                     ],
                   ),
                   Column(
                     children: <Widget>[
                       Text(measurements.calves.roundToDouble().toString(),style: valueStyle,),
                       Text("Calves",style: nameStyle,)
                     ],
                   ),
                   Column(
                     children: <Widget>[
                       Text(measurements.thigh.roundToDouble().toString(),style: valueStyle,),
                       Text("Thigh",style: nameStyle,)
                     ],
                   )
                 ]
               )
             ],
          ),
        ),
      ),
    );
  }


}
