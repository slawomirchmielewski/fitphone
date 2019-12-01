import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/fit_circular_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_fadein/flutter_fadein.dart';


class WelcomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var userViewModel = Provider.of<UserViewModel>(context);
    var uiHelper = Provider.of<UIHelper>(context);

    Future.delayed(Duration(milliseconds: 7000),() => uiHelper.setWelcomeButtonVisibility(true));

    String imageURI = MediaQuery.of(context).platformBrightness == Brightness.light ? 'assets/welcome_light.png' : 'assets/welcome_dark.png';

    return Container(
        padding: EdgeInsets.only(left: 16,right: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 72),
                Text("Welcome",style: Theme.of(context).textTheme.title),
                SizedBox(height: 8),
                Text(userViewModel.user != null ? userViewModel.user.getFirstName() : "Tom",style: Theme.of(context).textTheme.display1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.title.color
                )),
                SizedBox(height: 32),
                Center(child: FadeIn(child: Image.asset(imageURI,width: MediaQuery.of(context).size.width - 64,fit: BoxFit.fitWidth,))),
                SizedBox(height: 32),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: FadeAnimatedTextKit(
                      duration: Duration(milliseconds: 10000),
                      alignment: Alignment.center,
                      isRepeatingAnimation: true,
                      textAlign: TextAlign.center,
                      textStyle: Theme.of(context).textTheme.title,
                      text: [
                        " ",
                        "We are glad you joined us",
                        "Before we start, tell us somethink about you."
                    ],
                    ),
                  ),
                ),
                SizedBox(height: 64),
                uiHelper.isWelcomeButtonVisible ? Container(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                        child: FitCircularButton(onTap: () => uiHelper.setSetupPageIndex(1)))) : Container()
            ]),
          ),
        ),
      );
  }
}
