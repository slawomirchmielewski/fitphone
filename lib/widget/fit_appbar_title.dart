import 'package:fitphone/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FitAppBarTitle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var userViewModel = Provider.of<UserViewModel>(context);

    return Container(
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
          Text(userViewModel.user != null ? userViewModel.user.getFirstName() : "",style: Theme.of(context).textTheme.title.copyWith(
            fontWeight: FontWeight.bold
          ),),
          Text(userViewModel.user != null ?"Level ${userViewModel.user.level.toString()}" : "",style: Theme.of(context).textTheme.subtitle.copyWith(
            fontSize: 14
          ))
       ],
      ),
    );
  }
}
