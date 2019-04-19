import 'dart:io';
import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/model/user_model.dart';
import 'package:fitphone/utils/weight_change_result.dart';
import 'package:fitphone/view/image_view_screen.dart';
import 'package:fitphone/view/photos_screen.dart';
import 'package:fitphone/widget/notifiacation_square_small.dart';
import 'package:fitphone/widget/notification_dialog.dart';
import 'package:fitphone/widget/nutrition_icons_icons.dart';
import 'package:fitphone/widget/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitphone/widget/nutrition_tile_small.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:image_cropper/image_cropper.dart';

class HomeScreen extends StatelessWidget {

  static const double PADDING = 16;

  void _takePhoto(UserBloc userBloc){
    var image = ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 640.0,maxHeight: 480.0);
    image.then((file){
      _cropImage(file,userBloc);
    });
  }


  void _getPhoto(UserBloc userBloc){
    var image = ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 640.0,maxHeight: 480.0);
    image.then((file){
      _cropImage(file, userBloc);
    });
  }

  void _takeSelfie(UserBloc userBloc){
    var image = ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 1920,maxHeight: 1080);
    image.then((file){
        userBloc.uploadSelfie(file);
    });
  }



  Future<Null> _cropImage(File imageFile, UserBloc userBloc) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

   userBloc.uploadProfilePicture(croppedFile);
  }


  Future<Null> _showImageDialog(BuildContext context, UserBloc userBloc){
    return showDialog(
        context:context,
        builder: (context) => SimpleDialog(
          title: Text("Change profile picture"),
          contentPadding: EdgeInsets.only(left: 8.0,right: 8.0,top: 24.0,bottom: 24.0),
          children: <Widget>[
            ListTile(
              title: Text("Take a new photo"),
              onTap:(){
                _takePhoto(userBloc);
                Navigator.pop(context);
                },
            ),
            ListTile(
              title: Text("Chose photo from galery"),
              onTap: () {
                _getPhoto(userBloc);
                Navigator.pop(context);
              },
            )
          ],
        )
    );
  }

  Widget _buildImage(BuildContext context , UserBloc userBloc){

    const double IMAGE_SIZE = 56;




    return StreamBuilder<User>(
      stream: userBloc.getUser,
      builder: (context,snapshot) => GestureDetector(
          onTap: () => _showImageDialog(context, userBloc),
          child: snapshot.hasData ?  CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundImage: snapshot.data.photoUrl != ""  ? CachedNetworkImageProvider(snapshot.data.photoUrl) : AssetImage("assets/placeholder_face.png")
          ) : CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          )
      ),
    );
  }

  Widget _buildLevelIndicator(BuildContext context , UserBloc userBloc , User user){
    return Container(
        child: Padding(
          padding: EdgeInsets.only(top: 32),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("LEVEL:  ${user.level}",style: Theme.of(context).textTheme.subhead.copyWith(
                        fontWeight: FontWeight.bold,
                        //color: Theme.of(context).primaryColor
                    ), ),
                    Text("${user.points}/${user.goalPoints}",style: Theme.of(context).textTheme.subhead.copyWith(
                        fontWeight: FontWeight.bold,
                       // color: Theme.of(context).primaryColor
                    ),)
                  ],
                ),
              ),
              SizedBox(height: 16),
              StreamBuilder<double>(
                stream: userBloc.getProgressBarValue,
                initialData: 0.0,
                builder: (context, snapshot) {
                  return LinearPercentIndicator(
                    animation: true,
                    alignment: MainAxisAlignment.start,
                    width: MediaQuery.of(context).size.width - 32,
                    lineHeight: 10,
                    animateFromLastPercent: true,
                    progressColor: Theme.of(context).accentColor,
                    backgroundColor: Colors.black12,
                    percent: snapshot.data,

                  );
                }
              )
            ],
          ),
        ),
    );
  }

  Widget _buildNutritionsWidget(BuildContext context, User user){
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 16,bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            NutritionTileSmall(icon: NutritionIcons.cauliflower,name: "Calories",value: user.calories,),
            NutritionTileSmall(icon: NutritionIcons.meat,name: "Protein",value: user.protein,),
            NutritionTileSmall(icon: NutritionIcons.cereal,name: "Carbs",value: user.carbs,),
            NutritionTileSmall(icon: NutritionIcons.papaya,name: "Fat",value: user.fat,),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final ApplicationBloc applicationBloc = BlocProvider.of(context);

    Future<void> showLevelDialog(){
      return showDialog(
          barrierDismissible: false,
          context:context,
          builder: (context) => NotificationDialog(
            imagePath: "assets/trophy_hand.png",
            subtilte: "New Level Reached",
            title: "Congratulation !",
            backgroundColor: Colors.lightBlueAccent,
            boxFit: BoxFit.contain,
            onTap: () => Navigator.pop(context),
          )
      );
    }

   Observable(userBloc.getLevelUpgradeNotification).first.then((data){
     if(data == true){
        showLevelDialog();
        userBloc.setLevelUpgradeNotification(false);
     }
    });


    return NotificationListener<OverscrollIndicatorNotification>(
               onNotification: (overscroll){
                 overscroll.disallowGlow();
               },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                centerTitle: true,
                forceElevated: true,
                floating: false,
                snap: false,
                pinned: false,
                automaticallyImplyLeading: false,
                brightness: Theme.of(context).brightness,
                textTheme: Theme.of(context).textTheme,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              SliverList(delegate: SliverChildListDelegate([
                  StreamBuilder<User>(
                    stream: userBloc.getUser,
                    builder: (context,userSnap){
                      if(!userSnap.hasData) return Container(
                        padding: EdgeInsets.all(PADDING),
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      );

                      return Container(
                        padding: EdgeInsets.only(left: PADDING, right: PADDING),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Text("Hi ${userSnap.data.getFirstName()}",style: Theme.of(context).textTheme.display1.copyWith(
                                        color: Theme.of(context).textTheme.title.color,
                                        fontWeight: FontWeight.bold,
                                    ),),
                                  ],
                                ),

                                _buildImage(context, userBloc)
                              ],
                            ),
                            _buildLevelIndicator(context, userBloc, userSnap.data),
                            _buildNutritionsWidget(context, userSnap.data),
                            Text("Activity",style: Theme.of(context).textTheme.headline.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                            SizedBox(height:16),

                            Column(
                              children: <Widget>[
                                StreamBuilder<WeightChangeResult>(
                                    stream: userBloc.getWeightChange,
                                    initialData: WeightChangeResult(value: 0,text: ""),
                                    builder: (context, snapshot) {
                                      return StreamBuilder<String>(
                                          stream: applicationBloc.getUnitText,
                                          initialData: "",
                                          builder: (context, unitSnap) {
                                            return NotificationSquareSmall(image:"assets/weight_new.png",title: "${snapshot.data.value.toStringAsPrecision(2)} ${unitSnap.data}",
                                                subtitle: snapshot.hasData ? snapshot.data.text : "");
                                          }
                                      );
                                    }
                                ),

                                NotificationSquareSmall(image:"assets/trophy.png",title: userSnap.data.workoutsCompleted.toString() ,subtitle: "Workouts complated",),

                              ],
                            ),

                            SizedBox(height:16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text("Photos",style: Theme.of(context).textTheme.headline.copyWith(
                                    fontWeight: FontWeight.bold,

                                )),
                                FlatButton(
                                  child: Text("All Photos",style: Theme.of(context).textTheme.subhead.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  )),
                                  onPressed: (){
                                    Navigator.push(context, SlideLeftRoute(widget: PhotosScreen()));
                                  },
                                )
                              ],
                            ),
                            SizedBox(height:16),
                            Container(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      _takeSelfie(userBloc);
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(color: Theme.of(context).textTheme.title.color,width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.transparent
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.camera),
                                          SizedBox(height: 4),
                                          Text("Add photo"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  StreamBuilder<List<PhotoModel>>(
                                    stream: userBloc.getPhotosList,
                                    builder: (context, selfieSnap) {

                                      if(!selfieSnap.hasData) return Container(height: 100,width: 100);

                                      return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: selfieSnap.data.length,
                                          itemBuilder: (context,index){
                                            return Padding(
                                              padding: const EdgeInsets.only(left: 4,right: 4),
                                              child: GestureDetector(
                                              onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context) => ImageViewScreen(photo: selfieSnap.data[index]))),
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Hero(
                                                      tag:  selfieSnap.data[index].url,
                                                      child: CachedNetworkImage(imageUrl: selfieSnap.data[index].url,fit: BoxFit.cover,
                                                          fadeInDuration: Duration(seconds: 3),
                                                          width: 120,
                                                          height:120,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      );
                                    }
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 32),
                          ],
                        ) ,
                      );
                    }
                  )
              ]))
            ],
          )
    );
  }
}
