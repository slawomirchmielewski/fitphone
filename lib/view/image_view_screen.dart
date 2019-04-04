import 'package:fitphone/model/photo_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ImageViewScreen extends StatelessWidget{

  final PhotoModel photo;

  ImageViewScreen({@required this.photo});

  @override
  Widget build(BuildContext context) {
    return photo == null ? Scaffold(body: Center(child: CircularProgressIndicator())) : Scaffold(
      appBar:  AppBar(
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(photo.getDate().toString(),style: Theme.of(context).textTheme.title.copyWith(
            fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: true,
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Container(
        child: Center(
          child: Hero(
            tag: photo.url,
            child: CachedNetworkImage(
              imageUrl: photo.url,
              fadeInDuration: Duration(seconds: 2),
            ),
          )
        ),
      ),
    );
    }

}