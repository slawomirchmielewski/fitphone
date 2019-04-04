import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/utils/enums.dart';
import 'package:fitphone/utils/firebase_result.dart';
import 'package:fitphone/widget/system_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/widget/custom_button.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/setup_screen.dart';

class RegistrationScreen extends StatefulWidget{

  @override
  RegistrationScreenState createState() {
    return new RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {


  final TextEditingController _emailTextController = new TextEditingController();

  final TextEditingController _passwordTextController = new TextEditingController();

  final TextEditingController _nameTextController = new TextEditingController();

  final TextEditingController _passcodeTextController = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    Widget displayLogo(bool isDark){
        return isDark ? Image.asset("assets/logo_white.png" , width: 150, height: 100) : Image.asset("assets/logo.png" , width: 150, height: 100);
    }

    registerUser(){
      applicationBloc.setLoaderState(LoadersState.Visible);
      userBloc.registerUser().then((callback) {
        if(callback.success == true){
          userBloc.getObservableInfo();
          userBloc.getObservableWeightData();
          userBloc.getObservableImagesData();
          applicationBloc.setLoaderState(LoadersState.Hidden);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SetupScreen()));
        }
        else
        {
          _emailTextController.clear();
          _passwordTextController.clear();
          _nameTextController.clear();
          _passcodeTextController.clear();

          applicationBloc.setLoaderState(LoadersState.Hidden);
        }

      });
    }

    return Scaffold(
        body: StreamBuilder(
          stream: applicationBloc.darkThemeEnabled,
          initialData: false,
          builder: (context,snapshot) =>
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 32.0, left: 32.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                  children: <Widget>[
                    SizedBox(height: 32.0,),
                        displayLogo(snapshot.data),
                        SizedBox(height: 32.0,),
                        StreamBuilder(
                          stream: userBloc.getName,
                          builder: (context,snapshot) =>
                            TextField(
                            keyboardType: TextInputType.text,
                            onChanged: userBloc.setName,
                            controller: _nameTextController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(SystemIcon.user),
                              hintText: "Full Name",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                              errorText: snapshot.hasError ? snapshot.error.toString() : ""
                            ),
                          ),
                        ),
                      //  SizedBox(height: 8.0),
                        StreamBuilder(
                          stream: userBloc.getEmail,
                          builder:(context,snapshot) => TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: userBloc.setEmail,
                            controller: _emailTextController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(SystemIcon.new_email_back_closed_envelope_symbol),
                              hintText: "Email",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                              errorText: snapshot.hasError ? snapshot.error.toString() : ""
                            ),
                          ),
                        ),
                    //    SizedBox(height: 8.0),
                        StreamBuilder(
                          stream: userBloc.getPassword,
                          builder: (context,snapshot)=>
                          TextField(
                            onChanged: userBloc.setPassword,
                            keyboardType: TextInputType.text,
                            controller: _passwordTextController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(SystemIcon.lock),
                              hintText: "Password",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              filled: true,
                              errorText: snapshot.hasError ? snapshot.error.toString() : ""
                            ),
                          ),
                        ),
                      //  SizedBox(height: 8.0),
                        StreamBuilder(
                          stream: userBloc.getPasscode,
                          builder: (context,snapshot)=>
                          TextField(
                            onChanged: userBloc.setPasscode,
                            keyboardType: TextInputType.text,
                            controller: _passcodeTextController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(SystemIcon.shield),
                              hintText: "Passcode",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              filled: true,
                              errorText: snapshot.hasError ? snapshot.error.toString() : ""
                            ),
                          ),
                        ),
                         StreamBuilder<FirebaseResultCallback>(
                           stream: userBloc.getRegisterResult,
                           builder: (context,snapshot) =>
                               Text(snapshot.hasData && snapshot.data.success == false && snapshot.data.error !=null ? snapshot.data.error : "", style: TextStyle(color: CustomColors.colorRed),)
                         ),
                         SizedBox(height: 16.0),
                           StreamBuilder(
                             stream: userBloc.registerCheck,
                             builder: (context,snapshotReg) =>
                             CustomButton(
                              title: "Create Account",
                              onClick: () {
                                print(snapshotReg.data);
                                if(snapshotReg.data == true) registerUser();
                              }
                         ),
                           ),
                        SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already Member?"),
                            SizedBox(width: 8.0,),
                            FlatButton(
                              child: Text("Login"),
                              textColor: Theme.of(context).primaryColor,
                              onPressed: (){
                                  Navigator.pop(context);
                              },
                            )
                          ],
                        )
                  ],
                ),
              ),
            ),
          ),
          ),
        )
    );
  }
}