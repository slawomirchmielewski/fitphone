import 'package:fitphone/view/add_folder_view.dart';
import 'package:fitphone/view/all_folders_view.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_folder_widget.dart';
import 'package:fitphone/widget/fit_photos_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';

class PhotosPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final pageName = "Gallery";
    final PhotosViewModel photosViewModel = Provider.of<PhotosViewModel>(context);

    var iconColor = Theme.of(context).primaryColor;

    return Page(
      expandedHeight: 100,
      pageName:pageName,
      scrollable: true,
      actions: <Widget>[
        ActionButton(
          icon: Icons.add,
          onPressed: (){
            showRoundedModalBottomSheet(
                color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Theme.of(context).primaryColorLight : Colors.white,
                radius: 15,
                context: context,
                builder: (context) => Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(title: Text("Take new photo"),leading: Icon(Ionicons.ios_camera,color: iconColor),onTap: (){
                        photosViewModel.takePhoto();
                        Navigator.pop(context);
                      }),
                      ListTile(title: Text("Chose photo from galery"),leading: Icon(Ionicons.ios_images,color: iconColor),onTap: (){
                        photosViewModel.getPhoto();
                        Navigator.pop(context);

                      }),
                      ListTile(title: Text("Add album"),leading: Icon(Icons.create_new_folder,color: iconColor),onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddFolderView()));

                      })
                    ],
                  ),
                ));
          },
        )
      ],
      children: <Widget>[
       Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
           Row(
             children: <Widget>[
               Padding(
                 padding: const EdgeInsets.only(left: 16),
                 child: Text("My Albums",style: Theme.of(context).textTheme.subhead.copyWith(
                     fontWeight: FontWeight.w700
                 )),
               ),
               Spacer(),
               FlatButton(
                 materialTapTargetSize: MaterialTapTargetSize.padded,
                 child: Text("See all",style: Theme.of(context).textTheme.subtitle.copyWith(
                   color: Theme.of(context).primaryColor
                 ),),
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: ((context) => AllFoldersView())));
                 },
               )
             ],
           ),
           Container(
             height:160,
             child: ListView.builder(
                 padding: EdgeInsets.only(left: 16),
                 itemCount: photosViewModel.folders.length < 5 ? photosViewModel.folders.length : 5,
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (context,index) => FitFolderWidget(folder: photosViewModel.folders[index])
             ),
           ),

             SizedBox(height: 16),

             Padding(
               padding: const EdgeInsets.only(left: 16),
               child: Text("My Photos",style: Theme.of(context).textTheme.subhead.copyWith(
                   fontWeight: FontWeight.w700
               )),
             ),


             Padding(
               padding: const EdgeInsets.all(16),
               child: FitPhotosGrid(
                 photos: photosViewModel.photos,
               ),
             )
         ],
       )

      ],
    );
  }
}
