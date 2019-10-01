import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class FitPictureButton extends StatelessWidget {

  final VoidCallback onTap;
  final bool transparent;

  FitPictureButton({this.onTap,this.transparent});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: transparent == true ? Colors.transparent : Colors.black,
      child: Icon(SimpleLineIcons.camera),
      foregroundColor: Colors.white,
      onPressed:onTap,
    );
  }
}
