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
        height: 100,
        width: 100,
        child: Card(
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(vale.toString(),style: Theme.of(context).textTheme.title),
                  Text("cm",style: Theme.of(context).textTheme.body1)
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
