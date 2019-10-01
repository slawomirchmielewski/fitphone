import 'package:flutter/material.dart';



class RoundedCardBase extends StatelessWidget {

  final String title;
  final String value;
  final String unit;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onAdditionalButtonTap;
  final bool additionalButtons;
  final IconData buttonIcon;
  final Color iconColor;
  final IconData icon;

  RoundedCardBase({
    this.title,
    this.value,
    this.unit = "",
    this.description,
    this.imageUrl,
    this.onTap,
    this.additionalButtons = false,
    this.buttonIcon,
    this.onAdditionalButtonTap,
    this.iconColor = Colors.black,
    this.icon
  });

  final double radius = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4,bottom: 4,left: 8,right: 8),
      child: Material(
        elevation: 0.2,
        color:Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          onTap: onTap,
          child: Container(
           // height: 150,
            width: double.infinity,
            margin: EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon,color: iconColor),
                    SizedBox(width: 8),
                    Text(title,style: Theme.of(context).textTheme.body1),
                  ]
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Container(
                        height: 60,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(value,style: Theme.of(context).textTheme.display1.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.title.color)),
                                Text(unit,style: Theme.of(context).textTheme.subtitle.copyWith(
                                  fontWeight: FontWeight.w500
                                )),
                                SizedBox(width: 16),
                                Text(description,style: Theme.of(context).textTheme.subtitle.copyWith(
                                    fontWeight: FontWeight.w600
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if(imageUrl != null)Image.asset(imageUrl,height: 60,width: 60)
                  ],
                ),
                if(additionalButtons == true)Divider(),
                if(additionalButtons == true)Center(
                    child: FlatButton(onPressed: onAdditionalButtonTap, child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add),
                          Text("Record weight",style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.w600
                          ),),
                        ],
                      )
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
