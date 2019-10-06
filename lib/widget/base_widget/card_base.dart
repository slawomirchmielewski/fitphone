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

  static const double borderRadius = 10;
  static const double leftPadding = 8;
  static const double rightPadding = 8;
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
        color:backgroundColor ?? Theme.of(context).primaryColorLight,
        elevation: elevation ?? 0,
        borderOnForeground:true ,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(borderRadius))),
        child: InkWell(
          onTap: onTap,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if(icon != null)Icon(icon,color: iconColor),
                      if(title !=null && icon !=null ) SizedBox(width: 16),
                      if(title != null) Text(title.toUpperCase(),style: Theme.of(context).textTheme.subtitle.copyWith(
                        color: Colors.grey[700]
                      ),),
                      if(title !=null && icon !=null ) Spacer(),
                      if(haveAction)
                      action != null ? action  : Icon(Icons.arrow_forward_ios,color: Colors.grey[700],size: 16,)
                    ],
                  ),
                  if(title !=null && icon !=null )SizedBox(height: 16),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
