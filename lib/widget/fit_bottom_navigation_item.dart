import 'package:flutter/material.dart';

class FitBottomNavigationItem extends StatelessWidget {

  final IconData icon;
  final Color selectedColor;
  final Color unselectedColor;
  final String name;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChange;

  FitBottomNavigationItem({
    @required this.icon,
    this.selectedColor,
    this.unselectedColor = Colors.grey,
    @required this.name,
    @required this.value,
    @required this.groupValue,
    @required this.onChange});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 15,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      onTap: onChange != null ?() {onChange(value);} : null,
      child: Container(
        width: 80,
        height: double.infinity,
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon,color: value == groupValue ? selectedColor : unselectedColor,size: 26,),
            SizedBox(height: 2),
            Text(name,style: Theme.of(context).textTheme.body1.copyWith(
              fontSize: 12,
              color: value == groupValue ? selectedColor: unselectedColor,

            ),)
          ],
        ),
      )

    );
  }
}
