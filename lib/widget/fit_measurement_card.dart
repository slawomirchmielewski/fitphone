import 'package:flutter/material.dart';


class FitMeasurementCard extends StatelessWidget {

  final String name;
  final double vale;
  final VoidCallback onTap;

  FitMeasurementCard({@required this.name,@required this.vale,@required this.onTap});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.width *0.4,
        width: MediaQuery.of(context).size.width *0.4,
        child: Card(
          elevation: 0,
          color: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(vale.toString(),style: Theme.of(context).textTheme.display1.copyWith(
                    fontWeight: FontWeight.bold
                  )),
                  Text("cm",style: Theme.of(context).textTheme.body1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.display1.color
                  ))
                ],
              ),
              Text(name)
            ],
          ),
        ),
      ),
    );
  }
}
