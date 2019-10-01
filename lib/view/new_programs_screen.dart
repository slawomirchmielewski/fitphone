import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class NewProgramsScreen extends StatelessWidget {



  static const Color backgroundColor = Color(0xFFFFDFDB);
  static const Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {

    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);

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
            Image.asset("assets/dump_image.png",height: 80,fit: BoxFit.fitHeight,),
            SizedBox(height: 72),
            Text("New Programs available",style: Theme.of(context).textTheme.subhead.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor
            ),overflow: TextOverflow.clip,),
            SizedBox(height: 16),
            Text("Get new programs and set it as primary or dismiss to do it later",textAlign: TextAlign.center,style: Theme.of(context).textTheme.subtitle.copyWith(
              color: textColor
            )),
            SizedBox(height: 36),
            FitButton(
                backgroundColor: Colors.black,
                buttonText: "Get Programs",
                onTap: (){
                programsViewModel.downloadPrograms();
            }),
            SizedBox(height: 16),
            FlatButton(child: Text("DISMISS",style: Theme.of(context).textTheme.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor
            ),),onPressed: (){
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }
}
