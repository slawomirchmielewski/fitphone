import 'dart:io';

import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/fit_alert_dialog.dart';
import 'package:fitphone/widget/fit_image.dart';
import 'package:fitphone/widget/fit_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:toast/toast.dart';



class PhotoView extends StatelessWidget {

  final PhotoModel photo;

  PhotoView({@required this.photo});
  
  
  Widget _buildFolderList(BuildContext context , PhotosViewModel photosViewModel){
    return ListView.builder(
        itemCount: photosViewModel.folders.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
        return Material(
          borderRadius: BorderRadius.circular(15),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:Color(photosViewModel.folders[index].color),
            ),
            title:Text(photosViewModel.folders[index].name),
            onTap: (){
                photosViewModel.addToFolder(photo, photosViewModel.folders[index]).then((_){
                  Toast.show("Photo moved to ${photosViewModel.folders[index].name}", context);
                  Navigator.pop(context);
                });
            },
          ),
        );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    final PhotosViewModel photosViewModel = Provider.of<PhotosViewModel>(context);

    String name = photo.name;

    showDeleteDialog(){
      showDialog(
          context: context,
          builder: (context) => FitAlertDialog(
            title: Text("Delete photo"),
            content: Text("Are you suru you want to delete this photo ?"),
            actions: <Widget>[
              FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context)
              ),
              FlatButton(
                  child: Text("Delete"),
                  onPressed: () {
                    photosViewModel.deletePhoto(photo).then((_) => {
                      Navigator.of(context).popUntil((route) => route.isFirst)
                    });
                  }
              )
            ],
          )
      );
    }


    editTitle(){
      showRoundedModalBottomSheet(
          context: context,
          color: Theme.of(context).cardColor,
          radius: 15,
          builder: (context) => Container(
              padding: EdgeInsets.all(16),
              height: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Edit name",style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.w700
                  )),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: TextField(
                          autofocus: true,
                          onChanged: photosViewModel.setTempPhotoName,
                          decoration: InputDecoration(
                            hintText: photo.name ?? "New name",
                            hintStyle: Theme.of(context).textTheme.subtitle
                          ),
                        ),
                      ),

                      ActionButton(
                        icon: Icons.done,
                        onPressed:() => photosViewModel.updateName(photo).then((_){
                          Toast.show("Name updated", context);
                          Navigator.pop(context);
                        }),
                      )
                    ],
                  )
                ],
              ),
          ));
    }

    moveToFolder(){
        showRoundedModalBottomSheet(
          context: context,
          color: Theme.of(context).cardColor,
          radius: 15,
          builder: (context) => Container(
            padding: EdgeInsets.all(16),
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("All albums",style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: FontWeight.w700
                )),
                SizedBox(height: 8),
                _buildFolderList(context, photosViewModel),
              ],
            )
        ));
    }




    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.edit),
            color: Colors.white,
            onPressed: editTitle,
          ),
          IconButton(
            icon:Icon(Icons.playlist_add),
            color: Colors.white,
            onPressed: moveToFolder,
          ),
          IconButton(
            icon:Icon(Ionicons.ios_trash),
            color: Colors.white,
            onPressed: showDeleteDialog,
          ),
        ],
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: Theme.of(context).iconTheme.copyWith(
          color: Colors.white
        ),

      ),
      body: Center(
        child: FitImage(
          background: Colors.transparent,
          boxFit: BoxFit.contain,
          height: double.infinity,
          width: double.infinity,
          imageUrl: photo.url,
        ),
      ),
      persistentFooterButtons: <Widget>[


      ],
    );
  }




}
