import 'package:flutter/material.dart';

class FitTextFormProtected extends StatelessWidget {

  final Function(String) onChange;
  final Function(bool) onSuffixTap;
  final String hint;
  final IconData icon;
  final TextInputType textInputType;
  final String text;
  final bool isPasswordVisible;

  FitTextFormProtected({this.icon,this.hint,this.textInputType,this.onChange,this.text,@required this.isPasswordVisible,this.onSuffixTap});


  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => onChange(text),
      enableInteractiveSelection: false,
      controller: new TextEditingController.fromValue(new TextEditingValue(text: text,selection: new TextSelection.collapsed(offset: text.length))),
      cursorColor: Theme.of(context).accentColor,
      autocorrect: false,
      style: TextStyle(
          fontWeight: FontWeight.w600
      ),
      obscureText: isPasswordVisible == true ? false : true,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: Icon(icon,size: 20,),
        suffixIcon: GestureDetector(
            onTap: () => onSuffixTap(isPasswordVisible),
            child: Icon(isPasswordVisible == true ? Icons.visibility_off : Icons.visibility)),
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
