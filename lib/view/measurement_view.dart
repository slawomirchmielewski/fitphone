import 'package:flutter/material.dart';


class MeasurementView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Hips"),
            trailing: Text("86cm"),
          ),
          ListTile(
            title: Text("Chest"),
            trailing: Text("123cm"),
          ),
          ListTile(
            title: Text("Waist"),
            trailing: Text("86cm"),
          ),
          ListTile(
            title: Text("Arm"),
            trailing: Text("35cm"),
          )
        ],
      ),
    );
  }
}
