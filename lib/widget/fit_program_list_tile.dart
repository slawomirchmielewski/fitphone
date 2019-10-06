import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class FitProgramListTile<T> extends StatelessWidget {

  final String title;
  final String subtitle;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChange;

  FitProgramListTile({
    this.title = "",
    this.subtitle,
    this.value,
    this.groupValue,
    this.onChange
  });


  static const double iconSize = 38;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("$title",style: Theme.of(context).textTheme.subhead.copyWith(
        fontWeight: FontWeight.w600
      ),),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: value != groupValue ? GestureDetector(
        child: Icon(Ionicons.ios_radio_button_off,size: iconSize,color: Colors.grey[300],),
        onTap: () => onChange != null ? onChange(value) : null
      ) : Icon(Ionicons.ios_checkmark_circle,size: iconSize,color: Theme.of(context).primaryColor)
    );
  }


}
