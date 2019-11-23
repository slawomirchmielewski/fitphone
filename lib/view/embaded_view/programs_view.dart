import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:fitphone/widget/base_widget/page.dart';
import 'package:fitphone/widget/fit_program_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgramsView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);

    return Page(
      appBarTitle: Text("Programs"),
      automaticallyImplyLeading: true,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        itemCount: programsViewModel.programs.length,
        itemBuilder: (context,index) => ListTile(
            title: FitProgramListTile(
                title: programsViewModel.programs[index].name,
                subtitle: programsViewModel.programs[index].getDate(),
                value: programsViewModel.programs[index].name,
                groupValue: programsViewModel.programInfo.primaryProgram,
                onChange: programsViewModel.setPrimaryProgram
            )
        ),
      ),
    );
  }
}
