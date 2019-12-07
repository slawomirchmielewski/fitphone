import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/login_screen.dart';
import 'package:fitphone/view/main_screen.dart';
import 'package:fitphone/view/setup_screen.dart';
import 'package:fitphone/view/splash_screen.dart';
import 'package:fitphone/view_model/date_view_model.dart';
import 'package:fitphone/view_model/done_workouts_view_model.dart';
import 'package:fitphone/view_model/measurements_view_model.dart';
import 'package:fitphone/view_model/nutrtion_view_model.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/view_model/session_manager.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/setup_manager.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'enums/session_states.dart';


void main() {
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

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();


    /*_firebaseMessaging.autoInitEnabled();

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
    });*/
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionManager>(
          create: (context) => SessionManager(),
        ),
        ChangeNotifierProvider<UserViewModel>(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider<NutritionViewModel>(
          create: (context) => NutritionViewModel(),
        ),
        ChangeNotifierProvider<UIHelper>(
          create: (context) => UIHelper(),
        ),
        ChangeNotifierProvider<SetupManager>(
          create: (context) => SetupManager(),
        ),
        ChangeNotifierProvider<SettingsManager>(
          create: (context) => SettingsManager(),
        ),
        ChangeNotifierProvider<ProgramsViewModel>(
          create: (context) => ProgramsViewModel(),
        ),
        ChangeNotifierProvider<WeightViewModel>(
          create: (context) => WeightViewModel(),
        ),
        ChangeNotifierProvider<PhotosViewModel>(
          create: (context) => PhotosViewModel(),
        ),
        ChangeNotifierProvider<DoneWorkoutsViewModel>(
          create: (context) => DoneWorkoutsViewModel(),
        ),
        ChangeNotifierProvider<DateViewModel>(
          create: (context) => DateViewModel(),
        ),
        ChangeNotifierProvider<MeasurementsViewModel>(
          create: (context) => MeasurementsViewModel(),
        )

      ],
      child: Consumer<SettingsManager>(
        builder:(context,settingsManager,_) => MaterialApp(
            debugShowCheckedModeBanner: false,
            // themeMode: settingsManager.theme,
            title: MyApp.appName,
            darkTheme: ThemeData.dark().copyWith(
                primaryColor: kFitPrimary,
                accentColor: kFitPrimary,
                applyElevationOverlayColor: true,
                indicatorColor: kFitPrimary,
                cursorColor: kFitPrimary,
                cardColor: Colors.grey[900],
                textSelectionHandleColor: kFitPrimary,
                toggleableActiveColor: kFitPrimary,
                scaffoldBackgroundColor: Color(0xFF161616),
                dialogTheme: DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))) )


            ),
            theme: ThemeData.light().copyWith(
                primaryColor: kFitPrimary,
                dialogTheme: DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))) )

            ),
            home: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return true;
              },
              child: Consumer(
                  builder: (context,SessionManager sessionManager,_) {
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        // statusBarIconBrightness: Theme.of(context).brightness,
                        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor
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
      ),
    );
  }
}


