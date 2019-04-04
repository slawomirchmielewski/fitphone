import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:fitphone/utils/colors.dart';

class CustomButton extends StatelessWidget{

  final String title;
  final Function onClick;

  CustomButton({this.title, this.onClick});


  final Widget progressIndicator = SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
  );

  @override
  Widget build(BuildContext context) {

    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    return StreamBuilder<LoadersState>(
      stream: applicationBloc.loaderState,
      initialData: LoadersState.Hidden,
      builder: (context,snapshot) =>
         GestureDetector(
           onTap: onClick,
           child:  Container(
             height: 48.0,
             width: double.infinity,
             decoration: BoxDecoration(
                 gradient: LinearGradient(colors: [CustomColors.colorLightRed,CustomColors.colorViolet],begin: Alignment.centerLeft,end: Alignment.centerRight),
                 borderRadius: BorderRadius.all(Radius.circular(25.0))
             ),
             child: Align(
               alignment: Alignment.center,
               child: snapshot.data == LoadersState.Visible ? progressIndicator : Text(title,style: Theme.of(context).textTheme.title.copyWith(
                   color: Colors.white
               ),),
             ),
           ),
         )
    );
  }

}