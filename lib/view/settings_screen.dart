import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/utils/statusbar_controller.dart';
import 'package:fitphone/view/help_screen.dart';
import 'package:fitphone/view/login_screen.dart';
import 'package:fitphone/widget/system_icon_icons.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final StatusBarController statusBarController = StatusBarController();

  @override
  Widget build(BuildContext context) {
    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    logoutUser(){
      userBloc.logoutUser().then((_){
        Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context) => LoginScreen()),(Route<dynamic> route) => false);
        userBloc.clearUserData();
        applicationBloc.cleanUserData();
      }).catchError((error)=> print);
    }

    return  Scaffold(
            appBar: AppBar(
              brightness: Theme.of(context).brightness,
              title: Text(
                "Settings",
                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold),
              ),
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor:
                  Color(Theme.of(context).scaffoldBackgroundColor.value),
              centerTitle: true,
              elevation: 0.0,
              automaticallyImplyLeading: true,
            ),
            body: SafeArea(
                child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: applicationBloc.darkThemeEnabled,
                  initialData: false,
                  builder: (context, snapshot) => ListTile(
                        title: Text("Dark Theme"),
                        subtitle: snapshot.data ? Text("On") : Text("Off"),
                        leading: Icon(SystemIcon.paint_brushes,
                            color: Theme.of(context).iconTheme.color),
                        trailing: Switch.adaptive(
                            value: snapshot.data,
                            activeColor: Theme.of(context).accentColor,
                            onChanged: applicationBloc.changeTheme),
                        dense: true,
                      ),
                ),
                ListTile(
                  title: Text("Help"),
                  leading: Icon(SystemIcon.info,color: Theme.of(context).iconTheme.color,),
                  dense: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()))

                ),

                ListTile(
                  title: Text("Logout",),
                  leading: Icon(SystemIcon.logout,color: Theme.of(context).iconTheme.color),
                  dense: true,
                  onTap: () => logoutUser()
                )
              ],
            )));
  }
}
