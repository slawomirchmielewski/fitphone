import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';


class FitAlertDialog extends StatelessWidget {


  final Widget title;
  final Widget content;
  final List<Widget> actions;

  FitAlertDialog({
    this.title,
    this.content,
    this.actions});


  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? AlertDialog(
      title: title,
      content: content,
      actions: actions,

    ) : CupertinoAlertDialog(
      title: title,
      content: content,
      actions: actions,

    );
  }

}
