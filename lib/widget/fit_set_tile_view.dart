import 'package:fitphone/view_model/settings_manager.dart';
import 'package:flutter/material.dart';
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


  @override
  void initState() {
    super.initState();
    setState(() {
      isMark = false;
      weight = 0;
    });

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
        //color: Theme.of(context).cardColor,
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
            child: TextField(
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
            ),
          ),

          Container(
            width: 60,
            child: Text(widget.reps,textAlign: TextAlign.center,style: isMark == true ? _textStyleDone : _textStyle),
          ),
          GestureDetector(
            onTap:(){
              setState(() {
                isMark = true;
              });
              widget.onDonePressed(weight);
            } ,
            child: Container(
              width: 60,
              child: Icon(isMark == true ? Icons.done : Icons.radio_button_unchecked)
            ),
          )
        ],
      ),
    );
  }
}
