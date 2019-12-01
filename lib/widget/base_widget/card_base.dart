import 'package:flutter/material.dart';


class CardBase extends StatelessWidget{
  
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  final Widget action;
  final Widget child;
  final double elevation;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final bool haveAction;

  CardBase({
    this.padding,
    this.child,
    this.elevation,
    this.onTap,
    this.title = "",
    this.icon,
    this.iconColor,
    this.action,
    this.backgroundColor,
    this.haveAction = true
  });

  static const double borderRadius = 20;
  static const double leftPadding = 0;
  static const double rightPadding = 0;
  static const double topPadding = 4;
  static const double bottomPadding = 4;

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding:  padding ?? EdgeInsets.only(
          left: leftPadding,
          right: rightPadding,
          top:topPadding,
          bottom:bottomPadding
      ),
      child: Material(
        type: MaterialType.card,
        color: Colors.transparent,
        elevation: 0,
        borderOnForeground:true ,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(borderRadius))),
        child: InkWell(
          onTap: onTap,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: child
            ),
          ),
        ),
      ),
    );
  }

  
}
