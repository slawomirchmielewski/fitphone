import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';


class FitImage extends StatelessWidget {

  final double height;
  final double width;
  final String imageUrl;
  final BoxFit boxFit;
  final Color background;
  final double radius;

  FitImage({
    this.height = 120,
    this.width = 120,
    this.boxFit = BoxFit.cover,
    this.background,
    this.radius = 5,
    @required this.imageUrl
  }) : assert(imageUrl != null);


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: width,
        color: background ?? Theme.of(context).primaryColorLight,
        child: FadeInImage.memoryNetwork(
          fadeInDuration: const Duration(milliseconds: 50),
          fit: boxFit,
          width: width,
          height: height,
          placeholder: kTransparentImage,
          image: imageUrl,
        ),
      ),
    );
  }

  
}
