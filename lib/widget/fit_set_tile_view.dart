import 'package:fitphone/model/exercise_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';


class ExerciseReturnObject{
  double weight;
  int rep;


  ExerciseReturnObject({this.weight,this.rep});

}

class FitSetListTile extends StatefulWidget {

  final String set;
  final double weight;
  final int doneReps;
  final String reps;
  final Function(ExerciseReturnObject) onDonePressed;

  FitSetListTile({
    @required this.set,
    @required this.weight,
    @required this.doneReps,
    @required this.reps,
    @required this.onDonePressed
  });

  @override
  _FitSetListTileState createState() => _FitSetListTileState();
}



class _FitSetListTileState extends State<FitSetListTile> {


  bool isMark;
  int doneRep;
  double weight;


  static const double iconSize = 32;


  @override
  void initState() {
    super.initState();
    setState(() {
      isMark = false;
      weight = 0.0;
      doneRep = 0;
    });

  }

  onPressed(){
    if(!isMark){
      setState(() {
        isMark = true;
      });

      ExerciseReturnObject exerciseReturnObject = ExerciseReturnObject(weight: weight,rep: doneRep);

      widget.onDonePressed(exerciseReturnObject);
    }
  }

  @override
  Widget build(BuildContext context) {

    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    TextStyle _textStyle = Theme.of(context).textTheme.subhead.copyWith(
        fontWeight: FontWeight.bold
    );


    TextStyle _textHint = Theme.of(context).textTheme.subhead.copyWith(
        fontWeight: FontWeight.bold,
        color:  Colors.grey
    );

    TextStyle _textStyleDone = Theme.of(context).textTheme.subhead.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 38,
                  child: Text(widget.set,textAlign: TextAlign.center,style:isMark == true ? _textStyleDone : _textStyle,),
                ),
                Container(
                  width: 70,
                  child: Text("${settingsManager.getConvertedWeight(widget.weight).toInt()} ${settingsManager.unitShortName} x ${widget.doneReps}",textAlign: TextAlign.center,style:isMark == true ? _textStyleDone : _textStyle,),
                ),
                Container(
                  width: 60,
                  child:  isMark != true ? TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hasFloatingPlaceholder: false,
                      fillColor: Theme.of(context).primaryColorLight,
                      filled: false,
                      hintText: ("${settingsManager.getConvertedWeight(widget.weight).toInt()}"),
                      hintStyle: _textHint,
                      hintMaxLines: 1,
                    ),
                    onChanged: (value){
                      setState(() {
                        weight = double.tryParse(value);
                      });
                    } ,
                  ) : Text("${weight.toInt()}",textAlign: TextAlign.center,style: isMark == true ? _textStyleDone : _textStyle),
                ),

                Container(
                  width: 80,
                  child:  isMark != true ? TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).primaryColorLight,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hasFloatingPlaceholder: false,
                      filled: false,
                      hintText: widget.reps,
                      hintStyle: _textHint,
                      hintMaxLines:1,
                    ),
                    onChanged: (value){
                      setState(() {
                        doneRep = int.parse(value);
                      });
                    } ,
                  ) : Text(doneRep.toString(),textAlign: TextAlign.center,maxLines: 2,style: isMark == true ? _textStyleDone : _textStyle),
                ),
                GestureDetector(
                  onTap:(){
                    onPressed();
                  } ,
                  child: Container(
                    width: 38,
                    child: Icon(isMark == true ? Ionicons.ios_checkmark_circle : Ionicons.ios_radio_button_off,color:isMark == true ? Theme.of(context).primaryColor : Colors.grey,size: iconSize, )
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
