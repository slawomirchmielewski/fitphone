import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:fitphone/utils/enums.dart';
import 'package:fitphone/utils/firebase_result.dart';
import 'package:fitphone/view/reset_password_screen.dart';
import 'package:fitphone/view/setup_screen.dart';
import 'package:fitphone/widget/system_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/widget/custom_button.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/register_screen.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/view/main_hub_screen.dart';

class LoginScreen extends StatefulWidget{

  @override
  LoginScreenState createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailTextController = new TextEditingController();
  final TextEditingController _passwordTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final ExerciseBloc exerciseBoc = BlocProvider.of<ExerciseBloc>(context);

    applicationBloc.setBottomBarIndex(0);

    Widget displayLogo(bool isDark){
        return isDark ? Image.asset("assets/logo_white.png" , width: 150, height: 100) : Image.asset("assets/logo.png" , width: 150, height: 100);
    }

    loginUser(){
      applicationBloc.setLoaderState(LoadersState.Visible);
      userBloc.loginUser().then((callback) {
        if(callback.success == true){
          userBloc.getUserUpdate();
          userBloc.getWeightUpdate();
          userBloc.getPhotosUpdate();
          applicationBloc.setUpBottomAppBar();
          applicationBloc.getWeightUnit();
          applicationBloc.setLoaderState(LoadersState.Hidden);
          exerciseBoc.getProgramsNames();
          exerciseBoc.getWorkouts();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainHubScreen()));
        }
        else{
          _passwordTextController.clear();
          _emailTextController.clear();
          applicationBloc.setLoaderState(LoadersState.Hidden);
        }
      });
    }

    return StreamBuilder(
        stream:applicationBloc.darkThemeEnabled,
        initialData: false,
        builder: (context, snapshot) => Scaffold(
        body: SafeArea(
            child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 32.0, left: 32.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                      SizedBox(height: 32.0,),
                      displayLogo(snapshot.data),
                      SizedBox(height: 32.0,),
                      StreamBuilder(
                        stream: userBloc.getEmail,
                        builder: (context,snapshot) =>
                        TextField(
                          onChanged: userBloc.setEmail,
                          autocorrect: false,
                          maxLines: 1,
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(SystemIcon.new_email_back_closed_envelope_symbol),
                            hintText: "Email",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            filled: true,
                            errorText: snapshot.hasError ? snapshot.error  : ""
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: userBloc.getPassword,
                        builder: (context,snapshot) =>
                        TextField(
                          onChanged: userBloc.setPassword,
                          keyboardType: TextInputType.text,
                          controller: _passwordTextController,
                          maxLines: 1,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(SystemIcon.lock),
                            hasFloatingPlaceholder: false,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            hintText: "Password",
                            errorText: snapshot.hasError ? snapshot.error : ""
                          ),
                        ),
                      ),
                    //  SizedBox(height: 16.0),
                      StreamBuilder<FirebaseResultCallback>(
                        stream: userBloc.getLoginResult,
                        builder: (context,snapshot)=>
                         Text(snapshot.hasData && snapshot.data.success == false ? "Invalid username or password" : "", style: TextStyle(color: CustomColors.colorRed),)
                      ),
                      SizedBox(height: 16.0),
                      FlatButton(
                        child: Text("Forgot my password"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
                        },
                      ),
                      SizedBox(height: 16.0),
                        CustomButton(
                          title: "Login",
                          onClick: () => loginUser()
                        ),
                      SizedBox(height: 32.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("New Member?"),
                          SizedBox(width: 8.0,),
                          FlatButton(
                            child: Text("Register"),
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()))
                          )
                        ],
                      )
                    ],
                  ),
            ),
            )
          ),
      ),
    )
    );
  }
}