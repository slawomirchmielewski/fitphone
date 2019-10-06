import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/login_screen.dart';
import 'package:fitphone/view/main_screen.dart';
import 'package:fitphone/view/setup_screen.dart';
import 'package:fitphone/view/splash_screen.dart';
import 'package:fitphone/view_model/done_workouts_view_model.dart';
import 'package:fitphone/view_model/nutrtion_view_model.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/view_model/session_manager.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/setup_manager.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'enums/session_states.dart';
import 'dart:io';


void main() {

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MyApp()
  );
}

class MyApp extends StatefulWidget {

  static final appName = "FitPhone";
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.autoInitEnabled();

    _firebaseMessaging.configure(
      onLaunch: (Map<String,dynamic> message){
        print("on message $message");
        return null;
      },
      onMessage: (Map<String,dynamic> message){
        print("on message $message");
        return null;
      },
      onResume: (Map<String,dynamic> message){
        print("on message $message");
        return null;
      },

    );
    _firebaseMessaging.requestNotificationPermissions( const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionManager>(
          builder: (context) => SessionManager(),
        ),
        ChangeNotifierProvider<UserViewModel>(
          builder: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider<NutritionViewModel>(
          builder: (context) => NutritionViewModel(),
        ),
        ChangeNotifierProvider<UIHelper>(
          builder: (context) => UIHelper(),
        ),
        ChangeNotifierProvider<SetupManager>(
          builder: (context) => SetupManager(),
        ),
        ChangeNotifierProvider<SettingsManager>(
          builder: (context)=> SettingsManager(),
        ),
        ChangeNotifierProvider<ProgramsViewModel>(
          builder: (context)=> ProgramsViewModel(),
        ),
        ChangeNotifierProvider<WeightViewModel>(
          builder: (context)=> WeightViewModel(),
        ),
        ChangeNotifierProvider<PhotosViewModel>(
          builder: (context)=> PhotosViewModel(),
        ),
        ChangeNotifierProvider<DoneWorkoutsViewModel>(
          builder: (context)=> DoneWorkoutsViewModel(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: MyApp.appName,
        darkTheme: ThemeData(
          iconTheme: Theme.of(context).iconTheme.copyWith(
              color: kFitPrimaryLight
          ),
            primaryColor: kFitPrimaryLight,
            scaffoldBackgroundColor: kFitDarkScaffoldBackground,
            accentColor: kFitPrimaryLight,
            backgroundColor: kFitDarkScaffoldBackground,
            brightness: Brightness.dark,
            primaryColorLight: kFitGreyDark,
            cardColor: kFitDarkCard,
            bottomAppBarColor: kFitDarkCard,
            toggleableActiveColor: kFitPrimary,
            canvasColor: kFitDarkCard,
            dialogTheme: DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))) )


        ),
        theme: ThemeData(
          iconTheme: Theme.of(context).iconTheme.copyWith(
              color: kFitPrimary
          ),
          primaryColor: kFitPrimary,
          scaffoldBackgroundColor: kFitScaffoldBackground,
          accentColor: kFitPrimary,
          toggleableActiveColor: kFitPrimary,
          brightness: Brightness.light,
          primaryColorLight: kFitGreyLight,
          cardColor:kFitCard,
          bottomAppBarColor: kFitCard,
          dialogTheme: DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))) )

        ),
        home: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: Consumer(
              builder: (context,SessionManager sessionManager,_) {



                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: Theme.of(context).canvasColor
                ));


                switch(sessionManager.sessionState){
                  case SessionState.Uninitialized:
                    return SplashScreen();
                    break;
                  case SessionState.Unauthenticated:
                    return LoginScreen();
                    break;
                  case SessionState.Authenticated:
                    return MainScreen();
                    break;
                  case SessionState.Registered:
                    return SetupScreen();
                    break;
                  case SessionState.Authenticating:
                    return LoginScreen();
                    break;
                  default:
                    return LoginScreen();
                }
              }
          ),
        )
      ),
    );

  }
}


