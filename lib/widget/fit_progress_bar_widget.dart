import 'package:fitphone/view/account_activity_screen.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';


class FitProgressBarWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context,userViewModel,_) =>
      CardBase(
        //backgroundColor: Color(0xFFF5F7FB),
        iconColor:Colors.deepPurpleAccent,
        icon: Icons.trip_origin,
        title: "Account activity",
        onTap: (){
          showCupertinoModalPopup(context: context, builder: (context) => AccountActivityScreen());
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircularPercentIndicator(
                radius: MediaQuery.of(context).size.width * 0.4,
                lineWidth: 14,
                percent: userViewModel.user != null ? userViewModel.user.levelPercent : 0,
                animation: true,
                circularStrokeCap: CircularStrokeCap.values[1],
                progressColor: Color(0XFFB9FF1C),
                backgroundColor: Colors.grey[300].withOpacity(0.3),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(userViewModel.user != null ? "Level ${userViewModel.user.level}": "",style: Theme.of(context).textTheme.subhead.copyWith(
                        fontWeight: FontWeight.bold
                    ),),
                    Text(userViewModel.user != null ? "XP ${userViewModel.user.xp.round()} / ${userViewModel.user.maxXp.round()} " :" ",
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10
                        )),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: <Widget>[
                  Text(userViewModel.user != null ? userViewModel.user.getFirstName().toUpperCase() : "",style: Theme.of(context).textTheme.subhead.copyWith(
                      fontWeight: FontWeight.bold
                  ),),
                  Text(DateFormat.yMMMMd().format(DateTime.now()),style: Theme.of(context).textTheme.subtitle.copyWith(
                    fontSize: 12,
                    color: Colors.grey[700],
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

