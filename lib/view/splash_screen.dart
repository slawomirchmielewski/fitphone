import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/view/main_hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/view/login_screen.dart';
import 'package:splashscreen/splashscreen.dart';



class FitSplashScreen extends StatelessWidget{

  

  @override
  Widget build(BuildContext context) {

    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return StreamBuilder(
      stream: userBloc.userCheck,
      builder: (context,snapshot) {
        return SplashScreen(
            seconds: 2,
            backgroundColor: Colors.white,
            photoSize: 80.0,
            title: Text(""),
            image: Image.asset("assets/logo.png"),
            navigateAfterSeconds: snapshot.hasData
                ? MainHubScreen()
                : LoginScreen()

        );
      });

  }

}


