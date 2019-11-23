import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_color_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';


class AddFolderView extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    final PhotosViewModel photosViewModel = Provider.of<PhotosViewModel>(context);


    return Page(
      appBarTitle: Text("New Album"),
      automaticallyImplyLeading: true,
      actions: <Widget>[
        FlatButton(
          textColor: Theme.of(context).primaryColor,
          child: Text("Save"),
          onPressed: (){
            photosViewModel.addFolder().catchError((error) => print);
            Toast.show("New Folder Created", context);
            Navigator.pop(context);
          },
        )
      ],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  onChanged:(text) => photosViewModel.setTempFolderName(text) ,
                  decoration: InputDecoration(
                      hintText: "Add a title",
                      hintStyle: Theme.of(context).textTheme.title
                  ),
                ),
                SizedBox(height: 32),
                Text("Select color",style: Theme.of(context).textTheme.subhead.copyWith(
                    fontWeight: FontWeight.w700
                ),),
                SizedBox(height: 16),
                GridView.count(
                    shrinkWrap: true,
                    physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    crossAxisCount: 3,
                    children: List.generate(photosViewModel.colors.length, (index) => FitColorSelector(
                      value: photosViewModel.colors[index],
                      groupValue: int.parse(photosViewModel.temFolderColor),
                      onChange:(value) => photosViewModel.setTempFolderColor(value.toString()),
                    )
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
