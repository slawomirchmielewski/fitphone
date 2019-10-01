import 'package:fitphone/model/folder_model.dart';
import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_photos_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class PhotoFolderView extends StatelessWidget {

  final Folder folder;


  PhotoFolderView({@required this.folder});


  @override
  Widget build(BuildContext context) {


    final PhotosViewModel photosViewModel= Provider.of<PhotosViewModel>(context);

    final double containerSize = MediaQuery.of(context).size.height * 0.9;

    return Page(
      automaticallyImplyLeading: true,
      appBarTitle: Text(folder.name),
      children: <Widget>[
        FutureBuilder<List<PhotoModel>>(
          initialData: [],
          future:  photosViewModel.getPhotoFromFolder(folder),
          builder: (context,AsyncSnapshot<List<PhotoModel>> snapshot){
            switch(snapshot.connectionState){

              case ConnectionState.none:
                return Container();
                break;
              case ConnectionState.waiting:
                return Container(
                  height: containerSize,
                  child: Center(child: CircularProgressIndicator()),
                );
                break;
              case ConnectionState.active:
                // TODO: Handle this case.
                break;
              case ConnectionState.done:
                if(snapshot.data.length == 0){
                  return Container(
                    height: containerSize,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                            opacity: 0.5,
                            child: Image.asset("assets/folder.png",width: 200, height: 200)
                        ),
                        SizedBox(height: 8),
                        Text("No photos in this folder",style: Theme.of(context).textTheme.subtitle.copyWith(
                          color: Colors.grey
                        ),)
                      ],
                    )
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16,left: 16),
                    child: FitPhotosGrid(photos: snapshot.data),
                  );
                }
                break;
            }
            return null;
          }
        )
      ],
    );
  }
}
