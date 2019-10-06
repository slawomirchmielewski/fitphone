import 'package:fitphone/view_model/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';


class FitSetListTile extends StatefulWidget {

  final String set;
  final double weight;
  final String reps;
  final Function(double) onDonePressed;

  FitSetListTile({
    @required this.set,
    @required this.weight,
    @required this.reps,
    @required this.onDonePressed
  });

  @override
  _FitSetListTileState createState() => _FitSetListTileState();
}

class _FitSetListTileState extends State<FitSetListTile> {


  bool isMark;
  double weight;


  static const double iconSize = 32;


  @override
  void initState() {
    super.initState();
    setState(() {
      isMark = false;
      weight = 0;
    });

  }

  onPressed(){
    if(!isMark){
      setState(() {
        isMark = true;
      });
      widget.onDonePressed(weight);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 60,
            child: Text(widget.set,textAlign: TextAlign.center,style:isMark == true ? _textStyleDone : _textStyle,),
          ),
          Container(
            width: 60,
            child:  isMark != true ? TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,
                filled: false,
                hintText: ("${settingsManager.getConvertedWeight(widget.weight).toInt()} ${settingsManager.unitShortName}"),
                hintStyle: _textHint,
                hintMaxLines: 1,
              ),
              onChanged: (value){
                setState(() {
                  weight = double.tryParse(value);
                });
              } ,
            ) : Text("${weight.toInt()} ${settingsManager.unitShortName}",textAlign: TextAlign.center,style: isMark == true ? _textStyleDone : _textStyle),
          ),

          Container(
            width: 60,
            child: Text(widget.reps,textAlign: TextAlign.center,style: isMark == true ? _textStyleDone : _textStyle),
          ),
          GestureDetector(
            onTap:(){
              onPressed();
            } ,
            child: Container(
              width: 60,
              child: Icon(isMark == true ? Ionicons.ios_checkmark_circle : Ionicons.ios_radio_button_off,color:isMark == true ? Theme.of(context).primaryColor : Colors.grey,size: iconSize, )
            ),
          )
        ],
      ),
    );
  }
}
