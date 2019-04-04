import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/utils/firebase_result.dart';
import 'package:fitphone/widget/custom_button.dart';
import 'package:fitphone/widget/system_icon_icons.dart';
import 'package:flutter/material.dart';


class ResetPasswordScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {


    UserBloc userBloc  = BlocProvider.of<UserBloc>(context);
    userBloc.setResetPasswordResult(null);
    userBloc.clearData();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Reset Password",style: Theme.of(context).textTheme.title,),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        brightness: Theme.of(context).brightness,
        elevation: 0.0,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(left: 32.0,right: 32.0,top: 8.0,bottom: 8.0),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 32.0),
                    Text("Forgot password ?", style: Theme.of(context).textTheme.headline.copyWith(
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 32.0),
                    Text("We just need your registered email address to \n send you password reset ",
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.body1),
                    SizedBox(height: 32),
                    StreamBuilder(
                      stream: userBloc.getEmail,
                      builder: (context,snapshot) =>
                          TextField(
                            onChanged: userBloc.setEmail,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                prefixIcon: Icon(SystemIcon.new_email_back_closed_envelope_symbol),
                                hintText: "Email",
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: snapshot.hasError ? snapshot.error : ""
                            ),
                          ),
                    ),
                    SizedBox(height: 16),
                    StreamBuilder<FirebaseResultCallback>(
                      stream: userBloc.getResetResult,
                      builder: (context,snapshot) => Text(
                        snapshot.hasData && snapshot.data.success ? "Reset password send" : "",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 32.0,),
                    CustomButton(
                        title: "Send",
                        onClick:userBloc.resetPassword
                    )
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }



}