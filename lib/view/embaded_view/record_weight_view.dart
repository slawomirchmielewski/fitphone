import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_weight_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';


class RecordWeightView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var pageName = "Add weight";

    var theme = Theme.of(context);

    TextStyle style = theme.textTheme.subtitle.copyWith(
      color: theme.primaryColor
    );

    return Page(
      automaticallyImplyLeading: true,
      appBarTitle: Text("Add weight"),
      pageName: pageName,
      actions: <Widget>[
        Consumer<WeightViewModel>(
          builder: (context,weightViewModel,_) =>
          FlatButton(
            child: Text("Save",style: style,),
            onPressed: (){
              weightViewModel.recordWeight().then((_){
              }).catchError((error) => print);
              Provider.of<UserViewModel>(context).addPoints(5);
              Toast.show("Weight added", context);
              Navigator.pop(context);
            },
          ),
        )
      ],
      children: <Widget>[
        SizedBox(height: 72),
        Center(child: Text(DateFormat.yMMMd().format(DateTime.now()),style: Theme.of(context).textTheme.headline)),
        Image.asset("assets/weight.png",height: 200,fit: BoxFit.fitHeight,),
        SizedBox(height: 16),
        Consumer<WeightViewModel>(
            builder: (context, weightViewModel,_) => Container(
              height: 220,
              child: FitWeightSlider(
                value: weightViewModel.weight,
                onDragging: (value) => weightViewModel.setWeight(value),
                onDragCompleted: (value) {},
              ),
            )
        )
      ],
    );
  }
}
