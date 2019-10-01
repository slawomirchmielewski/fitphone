import 'package:flutter/material.dart';



class FitChipButton extends StatelessWidget {

  final String label;
  final VoidCallback onTap;

  FitChipButton({
    @required this.label,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Chip(
          backgroundColor: Theme.of(context).primaryColorLight,
          label: Text(label,style: Theme.of(context).textTheme.subtitle.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor)
          )
        )
    );
  }

}
