import 'package:flutter/material.dart';


class CircleIndicator extends StatelessWidget {

  final int index;
  final int groupIndex;

  CircleIndicator({@required this.index, @required this.groupIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4,left:4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == groupIndex ? Theme.of(context).primaryColor : Colors.grey[400].withOpacity(0.5),
      ),
    );
  }
}
