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

  static final Typography _typography = new Typography();

  static final TextTheme _textThemeWhite = _typography.white.copyWith(
    display4: _typography.white.display4.copyWith(fontFamily: "Rubik"),
    display3: _typography.white.display3.copyWith(fontFamily: "Rubik"),
    display2: _typography.white.display2.copyWith(fontFamily: "Rubik"),
    display1: _typography.white.display1.copyWith(fontFamily: "Rubik"),
    headline: _typography.white.headline.copyWith(fontFamily: "Rubik"),
    title: _typography.white.title.copyWith(fontFamily: "Rubik"),
    subhead: _typography.white.subhead.copyWith(fontFamily: "Rubik"),
    body2: _typography.white.body2.copyWith(fontFamily: "Rubik"),
    body1: _typography.white.body1.copyWith(fontFamily: "Rubik"),
    caption: _typography.white.caption.copyWith(fontFamily: "Rubik"),
    button: _typography.white.button.copyWith(fontFamily: "Rubik"),
  );

  static final TextTheme _textThemeBlack = _typography.black.copyWith(
    display4: _typography.black.display4.copyWith(fontFamily: "Rubik"),
    display3: _typography.black.display3.copyWith(fontFamily: "Rubik"),
    display2: _typography.black.display2.copyWith(fontFamily: "Rubik"),
    display1: _typography.black.display1.copyWith(fontFamily: "Rubik"),
    headline: _typography.black.headline.copyWith(fontFamily: "Rubik"),
    title: _typography.black.title.copyWith(fontFamily: "Rubik"),
    subhead: _typography.black.subhead.copyWith(fontFamily: "Rubik"),
    body2: _typography.black.body2.copyWith(fontFamily: "Rubik"),
    body1: _typography.black.body1.copyWith(fontFamily: "Rubik"),
    caption: _typography.black.caption.copyWith(fontFamily: "Rubik"),
    button: _typography.black.button.copyWith(fontFamily: "Rubik"),
  );



  final ThemeData lightTheme = ThemeData.light().copyWith(
    textTheme: _textThemeBlack,
    brightness: Brightness.light,
    primaryColorDark: CustomColors.colorLightBackground,
    primaryColor: color,
    accentColor: color,
    backgroundColor: Colors.white,
    toggleableActiveColor: color,
    cursorColor: color,
    scaffoldBackgroundColor: CustomColors.colorLightBackground,
    dialogTheme: DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))) )
  );

  final ThemeData darkTheme = ThemeData.dark().copyWith(
    textTheme: _textThemeWhite,
    brightness: Brightness.dark,
    primaryColorDark:CustomColors.colorDarkBackground,
    primaryColor: color,
    accentColor: color,
    cursorColor: color,
    backgroundColor: CustomColors.colorBlackDarker,
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


