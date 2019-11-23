import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fitphone/view/embaded_view/record_measurements_view.dart';
import 'package:fitphone/view/embaded_view/record_weight_view.dart';
import 'package:fitphone/view/measurement_view.dart';
import 'package:fitphone/view_model/photos_view_model.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/action_button.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:fitphone/widget/base_widget/page_standard.dart';
import 'package:fitphone/widget/fit_charts_switcher.dart';
import 'package:fitphone/widget/fit_measurement_slider.dart';
import 'package:fitphone/widget/fit_photos_grid.dart';
import 'package:fitphone/widget/week_weight_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:rounded_modal/rounded_modal.dart';


class ProgressPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final String pageName = "Progress";

    return PageStandard(
      actions: <Widget>[
        ActionButton(
          icon: Icons.add,
          onPressed: (){
            showRoundedModalBottomSheet(
                color: Theme.of(context).canvasColor,
                radius: 15,
                context: context,
                builder: (context) => Container(
                  padding: EdgeInsets.only(top: 8,bottom: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text("Add weight"),
                        leading: Icon(Icons.network_check),
                        onTap: (){
                          Navigator.pop(context);
                          showCupertinoModalPopup(context: context, builder: (context) => RecordWeightView());
                        },
                      ),
                      ListTile(
                        title: Text("Add measurement"),
                        leading: Icon(Ionicons.ios_body),
                        onTap: (){
                          Navigator.pop(context);
                          showCupertinoModalPopup(context: context, builder: (context) => RecordMeasurementsView());
                        },
                      ),
                      Consumer<PhotosViewModel>(
                        builder: (context,photoViewModel,_) =>
                        ListTile(title: Text("Take new photo"),leading: Icon(Ionicons.ios_camera),
                        onTap: (){
                          photoViewModel.takePhoto();
                          Navigator.pop(context);
                        }),
                      ),
                      Consumer<PhotosViewModel>(
                        builder: (context,photoViewModel,_) =>
                        ListTile(title: Text("Chose photo from galery"),leading: Icon(Ionicons.ios_images),onTap: (){
                          photoViewModel.getPhoto();
                          Navigator.pop(context);
                        }),
                      )

                  ],
                ),
            ));
          },
        )
      ],
      title: Text(pageName),
      tabLength: 3,
      bottom: TabBar(
        isScrollable: false,
        indicator: new BubbleTabIndicator(
          indicatorHeight: 25.0,
          indicatorColor: Theme.of(context).primaryColor,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).primaryColor,
        labelStyle: Theme.of(context).textTheme.body1,
        tabs: <Widget>[
          Tab(text: "Weight"),
          Tab(text: "Measurements"),
          Tab(text: "Photos")

        ],
      ),
      child: TabBarView(
        children: <Widget>[
          SingleChildScrollView(child: FitChartsSwitcher()),
          SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: MeasurementView(),
          ),),
          SingleChildScrollView(child: FitPhotosGrid()),
        ],
      ),
    );
  }
}
