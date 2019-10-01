import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/view/photo_view.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/widget/fit_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class FitPhotosGrid extends StatelessWidget {

  final List<PhotoModel> photos;

  FitPhotosGrid({
    @required this.photos,
  });

  @override
  Widget build(BuildContext context) {

    photos.sort((a,b) => a.date.compareTo(b.date));

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      childAspectRatio: 4/5 ,
      shrinkWrap: true,
      physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      children: List.generate(photos.length, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Consumer<PhotosViewModel>(
                 builder: (context,photosViewModel,_) =>
                     GestureDetector(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoView(photo: photos[index])));
                       },
                       child: FitImage(
                           width: 110,
                           height: 110,
                           boxFit: BoxFit.cover,
                           imageUrl: photos[index].url),
                     ),
               ),
               SizedBox(height: 2),
               Text(photos[index].name, style: Theme.of(context).textTheme.subtitle,),
               Text("${DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(photos[index].date))}", style: Theme.of(context).textTheme.body1.copyWith(
                   color: Colors.grey,
                   fontSize: 11
               ))
             ],
           )

          ],
        );
      }),
    );
  }
}
