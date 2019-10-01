import 'package:fitphone/view/add_folder_view.dart';
import 'package:fitphone/view/photos_folder_view.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';


class AllFoldersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final PhotosViewModel photosViewModel = Provider.of<PhotosViewModel>(context);

    return Page(
      automaticallyImplyLeading: true,
      appBarTitle: Text("Albums"),
      actions: <Widget>[
        ActionButton(
          icon: Icons.add,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddFolderView())),
        )
      ],
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            itemCount: photosViewModel.folders.length,
            itemBuilder: (context,index) => ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoFolderView(folder: photosViewModel.folders[index]))),
              leading: CircleAvatar(
                backgroundColor: Color(photosViewModel.folders[index].color),
              ),
              title:Text(photosViewModel.folders[index].name),
              trailing: IconButton(
                icon:Icon(Ionicons.ios_trash),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) => FitAlertDialog(
                        title: Text("Delete Folder"),
                        content: Text("Are you sure you want to delete this album ?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Delete"),
                            onPressed: (){
                              photosViewModel.deleteFolder(photosViewModel.folders[index]);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
                },
              ),
            ),
        )
      ],
    );
  }
}
