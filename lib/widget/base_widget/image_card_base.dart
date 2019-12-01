import 'package:flutter/material.dart';



class ImageCardBase extends StatelessWidget {

  final String imagePath;
  final String title;
  final Widget child;
  final VoidCallback onTap;


  ImageCardBase({this.imagePath, this.child,this.onTap,this.title = ""});


  static const double borderRadius = 15;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          height: 260,
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(ImageCardBase.borderRadius),topRight: Radius.circular(ImageCardBase.borderRadius)),
                  child: Image.asset(imagePath,width: double.infinity,height: 150,fit: BoxFit.cover)
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(title,style: Theme.of(context).textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w600
                  )),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  child: child,
                )
              ],
            ),
          ),
      ),
    );
  }
}
