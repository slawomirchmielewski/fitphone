import 'package:fitphone/view/add_feedback_screen.dart';
import 'package:fitphone/view_model/session_manager.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/widget/fit_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:fitphone/enums/setup_enums.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final SessionManager sessionManager = Provider.of<SessionManager>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    final TextStyle titleStyle  = Theme.of(context).textTheme.subtitle;

    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Settings"),
        automaticallyImplyLeading: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             ListTile(title: Text("Unit of weight",style: titleStyle,),subtitle: Text(settingsManager.unitsName),onTap: (){
               showRoundedModalBottomSheet(
                   color: Theme.of(context).canvasColor,
                   radius: 15,
                   context: context,
                   builder: (context) => Container(
                     padding: EdgeInsets.only(top: 8,bottom: 8),
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: <Widget>[
                         RadioListTile(
                           groupValue: settingsManager.units,
                           value: Unit.Kilograms,
                           title: Text("Kilogram"),
                           onChanged: (value) {
                             settingsManager.setUnits(Unit.Kilograms);
                             Navigator.pop(context);
                           },
                         ),
                         RadioListTile(
                           groupValue: settingsManager.units,
                           value: Unit.Pounds,
                           title: Text("Pounds"),
                           onChanged: (value) {
                             settingsManager.setUnits(Unit.Pounds);
                             Navigator.pop(context);
                           },
                         ),
                       ],
                     ),
                   ));
             },),

            /*ListTile(
              title: Text("Theme",style: titleStyle,),
              subtitle: Text(settingsManager.themeName) ,
              onTap: (){
              showRoundedModalBottomSheet(
                  color: Theme.of(context).canvasColor,
                  radius: 15,
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.only(top: 8,bottom: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RadioListTile(
                          groupValue: settingsManager.theme,
                          value: ThemeMode.light,
                          title: Text("Light"),
                          onChanged: (value) {
                            settingsManager.setTheme(ThemeMode.light);
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          groupValue: settingsManager.theme,
                          value: ThemeMode.dark,
                          title: Text("Dark"),
                          onChanged: (value) {
                            settingsManager.setTheme(ThemeMode.dark);
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile(
                          groupValue: settingsManager.theme,
                          value: ThemeMode.system,
                          title: Text("System"),
                          onChanged: (value) {
                            settingsManager.setTheme(ThemeMode.system);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ));
            },),*/
            ListTile(title: Text("About FitPhone",style: titleStyle,),onTap: (){
              showAboutDialog(
                  context: context,
                  applicationName: "FitPhone",
                  applicationVersion: "1.0",
                  applicationLegalese: "All graphic contents are downloaded from https://www.freepik.com"

              );
            }),
             ListTile(title: Text("Add Feedback",style: titleStyle,),onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddFeedbackScreen()));
             }),
             ListTile(title: Text("Logout",style: titleStyle.copyWith(
               color: Colors.red
             )),
               onTap: () {
                 showDialog(
                     context: context,
                     builder: (context) => FitAlertDialog(
                       title: Text(""),
                       content: Text("Are you sure you want to logout? "),
                       actions: <Widget>[
                         FlatButton(
                           child: Text("Cancel"),
                           onPressed: () => Navigator.pop(context),
                         ),
                         FlatButton(
                           child: Text("Logout"),
                           onPressed: () {
                             Navigator.of(context).popUntil((route) => route.isFirst);
                             sessionManager.logoutUser();
                           },
                         )

                       ],
                     )
                 );
               })
          ],
        ),
      ),
    );
  }
}
