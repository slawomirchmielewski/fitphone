import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FitNewProgramCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramsViewModel>(
      builder: (context,programsViewModel,_){
        if(programsViewModel.programInfo.isNewProgramAvailable){
          return Container(
            padding: EdgeInsets.only(bottom: 16,top: 16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Card(
           //   color: Colors.lightGreen[300],
              elevation: 0.3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        Text("New programs available",style: Theme.of(context).textTheme.title),
                        SizedBox(height: 8),
                        Text("Programs for next month are ready to download",maxLines: 2,textAlign: TextAlign.center,style: Theme.of(context).textTheme.body1.copyWith(
                        ),),
                      ],
                    ),
                  ),
                  OutlineButton.icon(
                    shape: StadiumBorder(side: BorderSide(
                      color: Colors.white
                    )) ,
                    onPressed: () => programsViewModel.downloadPrograms(),
                    splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
                    icon: Icon(Icons.get_app,color: Theme.of(context).primaryColor),
                    label: Text("Get programs",style: Theme.of(context).textTheme.body1.copyWith(
                    ),),

                  ),
                ],
              ),
            ),
          );
        }

        return Container();
      }
    );
  }
}
