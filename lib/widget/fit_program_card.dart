import 'package:fitphone/view/embaded_view/programs_view.dart';
import 'package:fitphone/view_model/programs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FitProgramCard extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    final ProgramsViewModel programsViewModel = Provider.of<ProgramsViewModel>(context);

    return ListTile(
      title: Text(programsViewModel.programInfo.primaryProgram != null ? programsViewModel.programInfo.primaryProgram : "No data",style: Theme.of(context).textTheme.headline.copyWith(
          fontWeight: FontWeight.w600
      ),),
      trailing: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProgramsView())),
        child: Chip(
          backgroundColor: Theme.of(context).primaryColor,
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Edit",style: Theme.of(context).textTheme.body1.copyWith(
              color: Colors.white
            ))
          )
        ),
      ),
    );
  }
}
