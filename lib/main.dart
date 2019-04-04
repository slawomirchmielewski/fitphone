import 'package:fitphone/bloc/exercise_bloc.dart';
import 'package:fitphone/bloc/setup_bloc.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/view/splash_screen.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:fitphone/utils/statusbar_controller.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/application_bloc.dart';


void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child:BlocProvider<UserBloc>(
        bloc: UserBloc(),
        child: BlocProvider<SetupBloc>(
            bloc: SetupBloc(),
            child: BlocProvider<ExerciseBloc>(
                child: MyApp(),
                bloc: ExerciseBloc()),
      ),
  )));
}

class MyApp extends StatelessWidget {

  static final appName = "FitPhone";
  static final color = CustomColors.colorLightRed;

  final ThemeData lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: color,
    accentColor: color,
    backgroundColor: Colors.white,
    toggleableActiveColor: color,
    scaffoldBackgroundColor: CustomColors.colorLightBackground,
    dialogTheme: DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))) )
  );

  final ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: color,
    accentColor: color,
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: CustomColors.colorDarkBackground,
    dialogTheme: DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))) )
  );

  @override
  Widget build(BuildContext context) {
   
    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    final StatusBarController statusBarController = StatusBarController();

    return StreamBuilder(
          stream: applicationBloc.darkThemeEnabled,
          initialData: false,
          builder: (context,snapshot) {

              statusBarController.setTransparentStatusBar();
              statusBarController.enableDarkStatusBar();
              statusBarController.enableDarkNavigationBar();
              statusBarController.setNavigationBarColor(Colors.white);

              if(snapshot.data){
                statusBarController.enableLightStatusBar();
                statusBarController.enableLightNavigationBar();
                statusBarController.setNavigationBarColor(Colors.black);
              }

             SystemChannels.lifecycle.setMessageHandler((msg){
               if(msg == AppLifecycleState.resumed.toString() && snapshot.data){
                 statusBarController.enableLightStatusBar();
                 statusBarController.enableLightNavigationBar();
                 statusBarController.setNavigationBarColor(Colors.black);

               }else if(msg == AppLifecycleState.resumed.toString()){
                   statusBarController.enableDarkStatusBar();
                   statusBarController.enableDarkNavigationBar();
                   statusBarController.setNavigationBarColor(Colors.white);
               }
             });
             
            return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: appName,
                  theme: snapshot.data ? darkTheme : lightTheme,
                  home: FitSplashScreen()
      );}
    );
  }
}


