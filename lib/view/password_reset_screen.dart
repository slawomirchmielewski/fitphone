import 'package:fitphone/view_model/session_manager.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:fitphone/widget/fit_text_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class PasswordResetScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var sessionManager = Provider.of<SessionManager>(context);

    showIOSDialog(String result){
      showCupertinoDialog(context: context,builder: (context) => CupertinoAlertDialog(
        content: Text(result),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed:() => Navigator.pop(context)
          )
        ],
      ));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Container(
        padding: EdgeInsets.only(right: 32,left: 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 36),
              Text("Reset Password",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline.copyWith(
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 36),
              Center(child: Text("We just need your registered email adress to send you password reset.",textAlign: TextAlign.center)),
              SizedBox(height: 36),
              FitTextForm(icon: SimpleLineIcons.envelope,hint: "Email", onChange: (text) => sessionManager.setResetEmail(text),text: sessionManager.resetEmail),
              SizedBox(height: 72),
              FitButton(
                buttonText: "Restore Password",
                onTap: () async {
                  var result  = await sessionManager.sendPasswordResetRequest(sessionManager.resetEmail);
                  Platform.isIOS ? showIOSDialog(result) :  Toast.show(result, context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
