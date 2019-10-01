import 'package:fitphone/widget/fit_chip_button.dart';
import 'package:flutter/material.dart';


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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("$title",style: Theme.of(context).textTheme.subhead.copyWith(
        fontWeight: FontWeight.w600
      ),),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: value != groupValue ? FitChipButton(
        label: "Set primary",
        onTap: onChange != null ? () {onChange(value);} : null,
      ) : Text("PRIMARY",style: Theme.of(context).textTheme.subhead.copyWith(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w700
      ),)
    );
  }


}
