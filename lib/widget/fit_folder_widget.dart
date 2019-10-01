import 'package:fitphone/model/folder_model.dart';
import 'package:fitphone/view/photos_folder_view.dart';
import 'package:flutter/material.dart';

class FitFolderWidget extends StatelessWidget {


  final Folder folder;

  FitFolderWidget({@required this.folder});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoFolderView(folder: folder)));
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            height: 120,
            width: 200,
            decoration: BoxDecoration(
                color: Color(folder.color) ?? Colors.grey[100],
                borderRadius: BorderRadius.circular(10)
            ),
            child:Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(folder.name,style: Theme.of(context).textTheme.subhead.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
