import 'package:fitphone/utils/colors.dart';
import 'package:flutter/material.dart';


class FitTextForm extends StatelessWidget{

  final String hint;
  final IconData icon;
  final Function(String) onChange;
  final String text;

  FitTextForm({this.onChange,this.icon,this.hint,this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => onChange(text),
      enableInteractiveSelection: false,
      cursorColor: Theme.of(context).accentColor,
      controller: TextEditingController(text: text),
      autocorrect: false,
      style: TextStyle(
        fontWeight: FontWeight.w600
      ),
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: Icon(icon,size: 20,),
        hintText: hint,
        hasFloatingPlaceholder: false,
        filled: true,
        fillColor: Theme.of(context).primaryColorLight,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
