import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/profile_screen.dart';
import 'package:fitphone/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class FitProfileImage extends StatelessWidget {
  final double radius;

  FitProfileImage({Key key, this.radius}) : super(key: key);

  static const double _radius = 24;
  static const double _padding = 16;

  @override
  Widget build(BuildContext context) {

    final UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    return GestureDetector(
      onTap: (){
       showCupertinoModalPopup(context: context, builder: (context) => ProfileScreen());
      },
      child: Padding(
        padding: const EdgeInsets.only(left: _padding, right: _padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            userViewModel.user != null
                ? CircleAvatar(
                    radius: radius ?? _radius,
                    backgroundColor: Theme.of(context).primaryColorLight,
                    backgroundImage: userViewModel.user.photoUrl != ""
                        ? CachedNetworkImageProvider(userViewModel.user.photoUrl)
                        : AssetImage("assets/placeholder_face.png"))
                : CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    radius: radius,
                  ),
          ],
        ),
      ),
    );
  }
}
