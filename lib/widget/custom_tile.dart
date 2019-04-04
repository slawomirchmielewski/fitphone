import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:toast/toast.dart';


class CustomTile extends StatefulWidget{

  final String sets;
  final String reps;
  final Function onPress;

  CustomTile({this.sets,this.reps,this.onPress});

  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {

  bool isPressed;
  double weight;

  @override
  void initState() {
    super.initState();
    setState(() {
      isPressed = false;
      weight = 0.0;
    });
  }


  Widget _buildContainer(Widget widget){
    return Container(
      width: 60,
      child: Align(
        alignment: Alignment.center,
        child: widget,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {


    final ExerciseBloc exerciseBloc = BlocProvider.of<ExerciseBloc>(context);


    TextStyle pressedStyle = Theme.of(context).textTheme.body1.copyWith(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold
    );

    Color pressedIconColor = Theme.of(context).primaryColor;
    Color normalIconColor = Theme.of(context).iconTheme.color;

    TextStyle normalStyle = Theme.of(context).textTheme.body1;

    return Container(
        padding: EdgeInsets.only(top: 8,bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
          _buildContainer(Text(widget.sets != null ? widget.sets : "",style: isPressed ? pressedStyle : normalStyle,)),
          _buildContainer(TextField(
            onChanged: (data){
              setState(() {
                weight = double.parse(data);
              });
            },
            textAlign: TextAlign.center,
            style: isPressed ? pressedStyle : normalStyle,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "weight",
              border: InputBorder.none
            ),
          )),
          _buildContainer(Text(widget.reps != null ? widget.reps : "",style: isPressed ? pressedStyle : normalStyle)),
          _buildContainer(GestureDetector(
                onTap: !isPressed ?(){
                  // ignore: unnecessary_statements
                  if(weight != 0.0){
                    widget.onPress();
                    setState(() {
                      isPressed = true;
                    });
                    exerciseBloc.incrementTotalWeight(weight);
                  }
                  else{
                    Toast.show("Add some weight", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  }

                } : null,
                child: Icon(isPressed ? OMIcons.checkCircle : OMIcons.fiberManualRecord,color: isPressed ? pressedIconColor : normalIconColor,),))
          ],
        ),
      );
  }
}