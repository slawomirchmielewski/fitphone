import 'dart:math';

import 'package:fitphone/view/photo_view.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/widget/fit_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rounded_modal/rounded_modal.dart';


class FitPhotosGrid extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    
    final PhotosViewModel photosViewModel = Provider.of<PhotosViewModel>(context);


    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.view_module),
                      onPressed: () => photosViewModel.setPhotoView(PhotosView.Grid),
                      color: photosViewModel.photoView == PhotosView.Grid ? Theme.of(context).iconTheme.color : Colors.grey,
                    ),
                    SizedBox(width: 4),
                    IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.view_headline),
                      onPressed: () => photosViewModel.setPhotoView(PhotosView.List),
                      color: photosViewModel.photoView == PhotosView.List ? Theme.of(context).iconTheme.color : Colors.grey,
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
                  borderRadius: BorderRadius.circular(5)
                ),
              ),
              Container(
                child:  IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () => showRoundedModalBottomSheet(
                      color: Theme.of(context).cardColor,
                      radius: 15,
                      context: context,
                      builder: (context) => Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RadioListTile(
                              groupValue: photosViewModel.sortDescending,
                              value: false,
                              title: Text("Newest First"),
                              onChanged: (value) {
                                photosViewModel.sortPhotosList();
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile(
                              groupValue: photosViewModel.sortDescending,
                              value: true,
                              title: Text("Oldest First"),
                              onChanged: (value) {
                                photosViewModel.sortPhotosList();
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                    ))
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: photosViewModel.photoView == PhotosView.Grid ?  StaggeredGridView.countBuilder(
             physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
             shrinkWrap:true,
              itemCount: photosViewModel.photos.length,
              crossAxisCount: 4,
              itemBuilder: (context,index) => GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoView(photo:  photosViewModel.photos[index]))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FitImage(
                      radius: 0,
                      background: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
                      imageUrl: photosViewModel.photos[index].url,
                    ),
                    SizedBox(height: 4),
                    Text(photosViewModel.photos[index].name,style: Theme.of(context).textTheme.body1.copyWith(
                      fontSize: 12
                    )),
                    Text(DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(photosViewModel.photos[index].date)),style: Theme.of(context).textTheme.body1.copyWith(
                        fontSize: 10,
                        color: Colors.grey
                    ))
                  ],
                ),
              ),
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              crossAxisSpacing: 4,
              mainAxisSpacing: 8,
          ) : ListView.builder(
              physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
              shrinkWrap: true,
              itemCount: photosViewModel.photos.length,
              itemBuilder: (context,index) => ListTile(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoView(photo:  photosViewModel.photos[index]))),
                leading: Container(
                  height: 80,
                  width: 80,
                  child: FitImage(
                    radius: 5,
                    imageUrl: photosViewModel.photos[index].url,
                    background: Theme.of(context).canvasColor
                    ),
                ),
                title: Text(photosViewModel.photos[index].name),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(photosViewModel.photos[index].date))),
              )
          ),
        ),
      ],
    );
  }
}
