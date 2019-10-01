import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';



class AccountActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
        builder: (context,userViewModel,_){
          return Page(
            appBarTitle: Text("Account activity"),
            automaticallyImplyLeading: true,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 72),
                  Text(userViewModel.user != null ? userViewModel.user.name : "",style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.w700
                  )),
                  SizedBox(height: 8),
                  Text(userViewModel.day != null ? "Day ${userViewModel.day}" : "",style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w500
                  )),
                  SizedBox(height: 32),
                  CircularPercentIndicator(
                    radius: MediaQuery.of(context).size.width * 0.7,
                    lineWidth: MediaQuery.of(context).size.width * 0.09,
                    percent: userViewModel.user != null ? userViewModel.user.levelPercent : 0,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.values[1],
                    progressColor: Color(0XFFB9FF1C),
                    backgroundColor: Theme.of(context).primaryColorLight,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(userViewModel.user != null ? "Level ${userViewModel.user.level}": "",style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.bold
                        ),),
                        Text(userViewModel.user != null ? "XP ${userViewModel.user.xp.round()} / ${userViewModel.user.maxXp.round()} " :" ",
                            style: Theme.of(context).textTheme.subtitle.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 48),
                  Text(userViewModel.user !=null ?"${userViewModel.user.remainingPoints} points to next level" : "",style: Theme.of(context).textTheme.subhead,)
                ],
              )
            ],
          );
    });
  }
}
