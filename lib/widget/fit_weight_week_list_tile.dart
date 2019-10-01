import 'package:flutter/material.dart';




class FitWeightWeekListTile extends StatelessWidget {


  final int weekNumber;

  FitWeightWeekListTile({this.weekNumber});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(width: 16),
                    Text("Week $weekNumber",style: Theme.of(context).textTheme.subhead.copyWith(
                        fontWeight: FontWeight.bold)),
                    SizedBox(width: 16),
                    Text("From 22.05.2019 to 29.05.2019")
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text("89kg",style: Theme.of(context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.bold
                        ),),
                        Text("start")
                      ],
                    ),
                    SizedBox(width: 32),
                    Container(
                      height: 40,
                      width: 2,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(width: 32),
                    Column(
                      children: <Widget>[
                        Text("84kg",style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.bold)),
                        Text("end")
                      ],
                    ),

                  ],
                )
              ],
            ),
            SizedBox(
              width: 16,
            ),
            Flexible(
              flex: 1,
              child: Container(
                height: 100,

                ),
              ),
          ],
        ),
      )
    );
  }
}
