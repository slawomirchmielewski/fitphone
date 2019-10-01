import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class NewLevelScreen extends StatelessWidget {
  static const Color backgroundColor = Color(0xFFFFF7DB);
  static const Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {

    final UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor ,
        elevation: 0,
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
      ),
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/trophy_hand.png",height: 180,fit: BoxFit.fitHeight,),
            SizedBox(height: 72),
            Text("Congratulation",style: Theme.of(context).textTheme.display1.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor
            ),overflow: TextOverflow.clip,),
            SizedBox(height: 16),
            Text("You reached level ${userViewModel.user.level}",textAlign: TextAlign.center,style: Theme.of(context).textTheme.subhead.copyWith(
                color: textColor
            )),
            SizedBox(height:73),
            FitButton(
                backgroundColor: Colors.black,
                buttonText: "Ok",
                onTap: (){
                    Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }
}
