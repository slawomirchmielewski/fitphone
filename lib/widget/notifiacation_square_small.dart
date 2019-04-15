import 'package:flutter/material.dart';

class NotificationSquareSmall extends StatelessWidget {

  final String image;
  final String title;
  final String subtitle;

  NotificationSquareSmall({this.title,this.subtitle,this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4,bottom: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.only(right: 16,top: 8, bottom: 8),
          height: 150,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Image.asset(image,width: 80,height: 80),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(title,style: Theme.of(context).textTheme.display2.copyWith(
                      color: Theme.of(context).textTheme.title.color,
                      fontWeight: FontWeight.w700
                    ),),
                    Text(subtitle)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
