import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_color_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';


class AddFolderView extends Page {



  @override
  Widget build(BuildContext context) {

    final PhotosViewModel photosViewModel = Provider.of<PhotosViewModel>(context);

    final List<int> colors = [
      0xFFF7D488,
      0xFF00E8B5,
      0xFFA47963,
      0xFFA997DF,
      0xFFDCCFEC,
      0xFFFFE975,
      0xFF28C8E8,
      0XFFab1749,
      0xFFec8248,
      0xFF654bd6,
      0xFF73ab5c,
      0XFF7387b0
    ];

    return Page(
      appBarTitle: Text("New Album"),
      automaticallyImplyLeading: true,
      actions: <Widget>[
        FlatButton(
          textColor: Theme.of(context).primaryColor,
          child: Text("Save"),
          onPressed: (){
            photosViewModel.addFolder().then((_) => Toast.show("New Folder Created", context)).catchError((error) => print);
          },
        )
      ],
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
                    children: List.generate(colors.length, (index) => FitColorSelector(
                      value: colors[index],
                      groupValue: int.parse(photosViewModel.temFolderColor),
                      onChange:(value) => photosViewModel.setTempFolderColor(value.toString()),
                    )
                  )
                )
              ],
            ),
          )
      ],
    );
  }
}
