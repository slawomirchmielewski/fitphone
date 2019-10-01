import 'package:fitphone/view_model/user_view_model.dart';
import 'package:fitphone/widget/rounded_card_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FitStrengthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Consumer<UserViewModel>(
      builder: (context,userViewModel,_) => RoundedCardBase(
        title: "Strenght",
        value: "15",
        unit: "kg",
        description: "Lifted last time",
        imageUrl: "assets/strenght.png",
        iconColor: Colors.lightBlue[500],
        icon: Icons.line_weight,
        onTap: (){},
      ),
    );
  }
}
