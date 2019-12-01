import 'package:fitphone/view_model/measurements_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_measurements_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MeasurementsYearView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MeasurementsViewModel measurementsViewModel = Provider.of<MeasurementsViewModel>(context);

    return Page(
        pageName: "hello",
        appBarTitle: Text("Year Body Measurements"),
        scrollable: true,
        automaticallyImplyLeading: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text("YEAR ACTIVITY",style: Theme.of(context).textTheme.body1.copyWith(
                  color: Colors.grey
              ),),
            ),
            SizedBox(height: 16),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                itemCount: measurementsViewModel.yearMeasurements.length,
                itemBuilder: (context,index){
                  return Container(
                      child: MeasurementsListTile(
                          measurements:  measurementsViewModel.yearMeasurements[index],
                          isYearTile: true,)
                  );
                }),
          ],
        )
    );
  }
}
