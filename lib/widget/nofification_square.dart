import 'package:flutter/material.dart';
import 'package:fitphone/utils/colors.dart';


class NotificationSquare extends StatelessWidget{

  final String image;
  final String title;
  final String subtitle;
  final Color backgroundColor;

  NotificationSquare({this.image = "",this.title = "Hello", this.subtitle = "Hello", this.backgroundColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
          gradient: LinearGradient(colors: [CustomColors.colorLightRed,CustomColors.colorViolet],begin: Alignment.centerLeft,end: Alignment.centerRight),
        // color: backgroundColor
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                width: 200,
                height: 200,
                top: 100,
                left: -50,
                child: ClipRect(
                  clipBehavior: Clip.antiAlias,
                  child: OverflowBox(
                    maxHeight: 200,
                    maxWidth: 200,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                width: 240,
                height: 240,
                top: -120,
                right: -50,
                child: ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: OverflowBox(
                    maxHeight: 240,
                    maxWidth: 240,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                width: 150,
                height: 150,
                bottom: -100,
                right: -50,
                child: ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: OverflowBox(
                    maxHeight: 150,
                    maxWidth: 150,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned.fill(child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(image),fit:BoxFit.cover)
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(title,style: Theme.of(context).textTheme.display3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          )),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(subtitle,style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: Colors.white
                          ),),
                        ),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

