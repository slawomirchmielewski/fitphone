import 'package:flutter/material.dart';


class CustomBottomSheet extends StatelessWidget{

  @override
  Widget build(BuildContext context) {


    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
        color: Theme.of(context).backgroundColor,
      ),
      height: screenHeight * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
            ),
            height:56.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 36.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                )
              ],
            )),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  Container(
                    height: 500.0,
                    decoration: BoxDecoration(color: Colors.red),
                  ), 
                  Container(
                    height: 500.0,
                    decoration: BoxDecoration(color: Colors.black,
                  )), 
                  Container(
                    height: 500.0,
                    decoration: BoxDecoration(color: Colors.yellow),
                  )
                ],
              ),
            )
        ],

      )
    );
  }

}