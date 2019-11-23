import 'package:fitphone/enums/session_states.dart';
import 'package:fitphone/view_model/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';


class FitAnimatedButton extends StatelessWidget {


  final String buttonText;
  final VoidCallback onTap;

  FitAnimatedButton({this.buttonText,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, SessionManager sessionManager ,_) => SizedBox(
        width: double.infinity,
        height: 48,
        child: ButtonTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          textTheme: ButtonTextTheme.primary,
          buttonColor: Theme.of(context).primaryColor,
          child: RaisedButton(
            highlightElevation: 0,
            elevation: 0,
            onPressed: onTap,
            child: sessionManager.sessionState != SessionState.Authenticating ? Text(buttonText,style: Theme.of(context).textTheme.subtitle.copyWith(
              color: Colors.white
            ),) : SizedBox(
                child: Platform.isIOS == true ? CupertinoActivityIndicator() : CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
                width: 20,
                height: 20,
            ),
          ),
        ),
      ),
    );
  }
}
