import 'package:fitphone/view/embaded_view/programs_view.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/widget/base_widget/card_base.dart';
import 'package:fitphone/widget/fit_chip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';


class FitProgramCard extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);
    bool newProgram = programsViewModel.programInfo.isNewProgramAvailable;

    Widget _buildActionButton(){

      if(programsViewModel.accountInfo.accountStatus == "Active") {
        if (programsViewModel.copyState == CopyState.idle) {
          return FitChipButton(
            label: "Get programs",
            onTap: () {
              programsViewModel.downloadPrograms();
            },
          );
        } else if (programsViewModel.copyState == CopyState.copy) {
          return Column(
            children: <Widget>[
              SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 0.6)),
            ],
          );
        }
      }

      return Container();

    }

    return CardBase(
      icon: newProgram == true ? Ionicons.ios_notifications: Ionicons.ios_list,
      iconColor: Colors.orangeAccent,
      title:newProgram == true ? "New programs available" : "Current program",
      action:newProgram == true ?  _buildActionButton() : null,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProgramsView()));
      },
      child: ListTile(
        leading: Image.asset("assets/program.png"),
        title: Text(programsViewModel.programInfo.primaryProgram !=null ? programsViewModel.programInfo.primaryProgram : "No data",style: Theme.of(context).textTheme.subhead.copyWith(
          fontWeight: FontWeight.w600
        ),),
      ),
    );
  }
}
