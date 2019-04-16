import 'package:flutter/material.dart';


class HelpScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0.0,
        title: Text("Help",style: Theme.of(context).textTheme.title.copyWith(
            fontWeight: FontWeight.bold
        ),),
        brightness: Theme.of(context).brightness,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                ListTile(title: Text("FitPhone"),subtitle: Text("Verison 0.1.0-Beta"),),
                ListTile(title: Text("Developer contact"),subtitle: Text("physiqonomics.service@gmail.com"),)
              ],
            ),
          )
      ),
    );
  }

}