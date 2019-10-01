import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class FitColorSelector extends StatelessWidget {


  final int value;
  final int groupValue;
  final ValueChanged<int> onChange;

  FitColorSelector({
    this.value,
    this.groupValue,
    this.onChange,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange != null ? () {onChange(value);} : null,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(value) ?? Colors.grey[100],
        ),
        child: value == groupValue ? Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Ionicons.ios_checkmark_circle_outline,color: Colors.white),
          )) : Container(),
      ),
    );
  }


}
