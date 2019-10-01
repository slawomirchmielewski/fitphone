import 'package:fitphone/view/add_feedback_screen.dart';
import 'package:fitphone/view_model/session_manager.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:fitphone/enums/setup_enums.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final SessionManager sessionManager = Provider.of<SessionManager>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    final TextStyle titleStyle  = Theme.of(context).textTheme.subtitle;
    final Color iconsColor = Theme.of(context).iconTheme.color;

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
             ListTile(title: Text("Unit of weight",style: titleStyle,),subtitle: Text(settingsManager.unitShortName),onTap: (){
               showRoundedModalBottomSheet(
                   color: Theme.of(context).cardColor,
                   radius: 15,
                   context: context,
                   builder: (context) => Container(
                     padding: EdgeInsets.only(top: 8,bottom: 8),
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: <Widget>[
                         ListTile(
                             title: Text("Kilograms"),
                             leading: Icon(MaterialCommunityIcons.weight_kilogram,color:iconsColor),
                             onTap: (){
                           settingsManager.setUnits(Unit.Kilograms);
                           Navigator.pop(context);
                         }),
                         ListTile(
                             title: Text("Pounds"),
                             leading: Icon(MaterialCommunityIcons.weight_pound,color: iconsColor),
                             onTap: (){
                           settingsManager.setUnits(Unit.Pounds);
                           Navigator.pop(context);
                         })
                       ],
                     ),
                   ));
             },),
             ListTile(title: Text("Add Feedback",style: titleStyle,),onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddFeedbackScreen()));
             }),
             ListTile(title: Text("Logout",style: titleStyle.copyWith(
               color: Colors.red
             )),
               onTap: () {
                 Navigator.of(context).popUntil((route) => route.isFirst);
                 sessionManager.logoutUser();
               })
          ],
        ),
      ),
    );
  }
}
