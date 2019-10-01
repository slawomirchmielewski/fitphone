import 'package:flutter/material.dart';


class ActionButton extends StatelessWidget {

  final IconData icon;
  final VoidCallback onPressed;

  ActionButton({this.icon,@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8,left: 8),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: IconButton(
          icon: Icon(icon) ??  Icon(Icons.add),
          color: Theme.of(context).primaryColor,
          onPressed: onPressed
        ),
      ),
    );
  }


}
