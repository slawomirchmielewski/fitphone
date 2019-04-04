import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitphone/model/photo_model.dart';
import 'package:flutter/material.dart';


class ImagesFolder extends StatelessWidget{


  final List<PhotoModel> photos;
  final String date;


  ImagesFolder({@required this.photos,@required this.date});

  @override
  Widget build(BuildContext context) {

    Widget w;

    switch(photos.length){
      case 1:
        w = Container(
          width: 120,
          height: 140,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Card(
                    elevation: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(imageUrl: photos[0].url,fit: BoxFit.fill,
                          fadeInDuration: Duration(seconds: 3),
                          width: 80,
                          height: 60,
                      ),
                    ),
                  )
              ),
            ],
          ) ,
        );
        break;
      case 2:
        w = Container(
            width: 120,
            height: 140,
            child: Stack(
              children: <Widget>[
                Positioned(
                    bottom:25,
                    left: 25,
                    child: Card(
                      elevation: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(imageUrl: photos[1].url,fit: BoxFit.fill,
                            fadeInDuration: Duration(seconds: 3),
                            width: 80,
                            height: 60,
                        ),
                      ),
                    )
                ),

                Positioned(
                    bottom: 15,
                    left: 15,
                    child: Card(
                      elevation: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(imageUrl: photos[0].url,fit: BoxFit.fill,
                            fadeInDuration: Duration(seconds: 3),
                            width: 80,
                            height: 60,

                        ),
                      ),
                    )
                ),
              ],
            ) ,
        );
        break;
      default:
        w = Container(
          width: 120,
          height: 140,
          child: Stack(
            children: <Widget>[

              Positioned(
                  bottom:25,
                  left: 25,
                  child: Card(
                    elevation: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(imageUrl: photos[2].url,fit: BoxFit.fill,
                          fadeInDuration: Duration(seconds: 3),
                          width: 80,
                          height: 60,

                      ),
                    ),
                  )
              ),

              Positioned(
                  bottom: 15,
                  left: 15,
                  child: Card(
                    elevation: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(imageUrl: photos[1].url,fit: BoxFit.fill,
                          fadeInDuration: Duration(seconds: 3),
                          width: 80,
                          height: 60,

                      ),
                    ),
                  )
              ),
              Positioned(
                  bottom: 5,
                  left: 5 ,
                  child: Card(
                    elevation: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(imageUrl: photos[0].url,fit: BoxFit.fill,
                          fadeInDuration: Duration(seconds: 3),
                          width: 80,
                          height: 60,
                      ),
                    ),
                  )
              )
            ],
          ) ,
        );
        break;
    }


    return Card(
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      child: Container(
          height: 175,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               photos != null ? w : Container(),
              SizedBox(height: 8),
              Text(date != null ? date : "",style: Theme.of(context).textTheme.subtitle.copyWith(
                fontWeight: FontWeight.bold
              ),)
            ],
          )
      ),
    );
  }

}