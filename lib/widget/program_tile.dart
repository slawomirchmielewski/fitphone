import 'package:fitphone/model/program_model.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:flutter/material.dart';


class ProgramTile extends StatelessWidget{

  final ProgramModel program;

  ProgramTile({this.program});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 4,
                decoration: BoxDecoration(color: CustomColors.colorRed),
              ),
              SizedBox(width: 16),
              Text(program.name,style: Theme.of(context).textTheme.title,)
            ],
          ),
          Icon(program.isPrimary ? Icons.check : null,color: Theme.of(context).iconTheme.color,),
        ],
      ),
    );
  }

}