import 'package:fitphone/view/settings_screen.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/view_model/settings_manager.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_picture_button.dart';
import 'package:fitphone/widget/fit_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rounded_modal/rounded_modal.dart';


class ProfileScreen extends Page {
  @override
  Widget build(BuildContext context) {

    final UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    final SettingsManager settingsManager = Provider.of<SettingsManager>(context);

    final iconColor = Theme.of(context).iconTheme.color;

    return Page(
      pageName: "Profile",
      appBarTitle: Text("Profile"),
      automaticallyImplyLeading: true,
      actions: <Widget>[
        ActionButton(
          icon: Ionicons.ios_settings,
          onPressed: (){
            showCupertinoModalPopup(context: context, builder: (context)=> SettingsScreen());
          },
        )
      ],
      children: <Widget>[
        SizedBox(height: 64),
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                fit: StackFit.loose,
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Positioned(
                      child: FitProfileImage(radius: 68)
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: FitPictureButton(
                        transparent: true,
                        onTap: (){
                          showRoundedModalBottomSheet(
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Theme.of(context).primaryColorLight : Colors.white,
                              radius: 15,
                              context: context,
                              builder: (context) => Container(
                                padding: EdgeInsets.only(top: 8,bottom: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(title: Text("Take new photo"),leading: Icon(Ionicons.ios_camera,color: iconColor),onTap: (){
                                      userViewModel.takePhoto();
                                      Navigator.pop(context);
                                    }),
                                    ListTile(title: Text("Chose photo from galery"),leading: Icon(Ionicons.ios_images,color: iconColor),onTap: (){
                                      userViewModel.getPhoto();
                                      Navigator.pop(context);
                                    })
                                  ],
                                ),
                              ));
                        }),
                  )
                ],
                overflow: Overflow.visible,
              ),
              SizedBox(height: 32),
              Text(userViewModel.user != null ? userViewModel.user.name : "",style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 32),
              Consumer<ProgramsViewModel>(
                builder: (context,programViewModel,_) =>
                ListTile(leading: Icon(Ionicons.ios_unlock,color: Theme.of(context).iconTheme.color,),title: Text("Account status"),trailing: Text(programViewModel.accountInfo.accountStatus,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      fontWeight: FontWeight.w600
                  ),),),
              ),
              Divider(),
              ListTile(leading: Icon(Ionicons.ios_heart,color: Theme.of(context).iconTheme.color),title: Text("Active since"),trailing: Text(userViewModel.user != null ? userViewModel.user.getReadableDate() : "",
                style: Theme.of(context).textTheme.subhead.copyWith(
                    fontWeight: FontWeight.w600
                ),),),
              Divider(),
              ListTile(leading: Icon(Ionicons.ios_hourglass,color: Theme.of(context).iconTheme.color),title: Text("Day"),trailing: Text(userViewModel.day != null ? userViewModel.day.toString() : "",
                style: Theme.of(context).textTheme.subhead.copyWith(
                    fontWeight: FontWeight.w600
                ),),),
              Divider(),
              ListTile(leading: Icon(Ionicons.ios_speedometer,color: Theme.of(context).iconTheme.color),title: Text("Start weight"),
                trailing: Text(userViewModel.user != null ? "${settingsManager.getConvertedWeight(userViewModel.user.weight).round()} ${settingsManager.unitShortName}" : "",
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      fontWeight: FontWeight.w600
                  ),),),
              Divider(),
            ],
          ),
        )
      ]
    );
  }
}
