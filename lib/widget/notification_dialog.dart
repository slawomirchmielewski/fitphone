import 'package:flutter/material.dart';


class NotificationDialog extends StatelessWidget{

  final String imagePath;
  final String title;
  final String subtilte;
  final VoidCallback onTap;
  final Color backgroundColor;
  final BoxFit boxFit;

  NotificationDialog({this.imagePath= "",this.title= "",this.subtilte = "",this.onTap,this.backgroundColor,this.boxFit});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: backgroundColor,
      children: <Widget>[
        Container(
          height: 400 ,
          width: MediaQuery.of(context).size.width - 32,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(imagePath),fit:boxFit)
                ),
              ),
              Text(title,style: Theme.of(context).textTheme.headline.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              )),
              Text(subtilte,style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              )),
              RaisedButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.white,
                padding: EdgeInsets.only(left: 64,right: 64),
                elevation: 0,
                child:Text("Close",style: Theme.of(context).textTheme.body1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
                textColor: Colors.white,
                onPressed: onTap,
              )
            ],
          ),
        ),

      ],

    );
  }

}