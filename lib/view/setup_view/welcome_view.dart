import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/utils/enums.dart';
import 'package:fitphone/widget/page_base.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/widget/animated_text.dart';



class WelcomeView extends PageBase {

  final String title;

  WelcomeView({@required this.title}) : super(title: title);

  @override
  Widget build(BuildContext context) {

    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    applicationBloc.setWeightUnit(WeightUnit.Kilogram);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedText(
            duration: 3,
            child: Text("Hello",style: Theme.of(context).textTheme.display2.copyWith(
              color: Theme.of(context).textTheme.title.color,
                fontWeight: FontWeight.w400
            ),),
          ),
          SizedBox(height: 8),
          AnimatedText(
            duration: 4,
            child: Text("Before we start lets set you up",style: Theme.of(context).textTheme.title.copyWith(
                color: Theme.of(context).textTheme.title.color,
                fontWeight: FontWeight.w300
              ),),
          ),
        ],
      ),
    );
  }

}