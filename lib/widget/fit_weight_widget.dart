import 'package:fitphone/view_model/ui_helper.dart';
import 'package:fitphone/view_model/weight_view_model.dart';
import 'package:fitphone/widget/base_widget/image_card_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class FitWeightWidget extends StatelessWidget {


  Widget _getWeightText(BuildContext context,WeightViewModel weightViewModel){

    if(weightViewModel.monthlyPercent == 0.0){
      return  RichText(
        maxLines: 2,
        text: TextSpan(
            style: Theme.of(context).textTheme.body1.copyWith(
              fontSize: 12
            ),
            children: <TextSpan>[
              TextSpan(text: "No weight change compare to last month")
            ]
        ),
      );
    }
    else if(weightViewModel.monthlyPercent > 0 && weightViewModel.monthlyPercent < 100.0){
      return RichText(
        maxLines: 2,
        text: TextSpan(
            style: Theme.of(context).textTheme.body1.copyWith(
                fontSize: 12
            ),
            children: <TextSpan>[
              TextSpan(text: "Good job! You have a "),
              TextSpan(text: "${(100 - weightViewModel.monthlyPercent)?.round()}% weight loss ",style: Theme.of(context).textTheme.body1.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700
              )),
              TextSpan(text: "compare to last month")
            ]
        ),
      );
    }
    else{
      return RichText(
        maxLines: 2,
        text: TextSpan(
            style: Theme.of(context).textTheme.body1.copyWith(
                fontSize: 12
            ),
            children: <TextSpan>[
              TextSpan(text: "Hmmm! You have a "),
              TextSpan(text: "${(weightViewModel.monthlyPercent - 100)?.round()}% weight gain ",style: Theme.of(context).textTheme.body1.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w700
              )),
              TextSpan(text: "compare to last month")
            ]
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    
    final WeightViewModel weightViewModel = Provider.of<WeightViewModel>(context);
    final UIHelper uiHelper = Provider.of<UIHelper>(context);


    return ImageCardBase(
        imagePath: "assets/weight_cover_image.png",
        title: "Weight",
        onTap: () => uiHelper.setBottomNavigationIndex(2),
        child: Container(
            child: _getWeightText(context, weightViewModel)
        ),
    );
  }
}
