import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';


class WorkoutMarketTile<T> extends StatelessWidget{

  final String title;
  final String subtitles;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChange;

  WorkoutMarketTile({this.title = "",
    this.subtitles = "",
    @required this.value,
    @required this.groupValue,
    @required this.onChange});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,style: Theme.of(context).textTheme.title),
      subtitle: Text(subtitles),
      trailing: value == groupValue ? Icon(OMIcons.checkCircle,color: Theme.of(context).primaryColor,) : Icon(OMIcons.fiberManualRecord),
      onTap: onChange != null ?() {onChange(value);} : null,
    );
  }

}