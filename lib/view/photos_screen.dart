import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/bloc/user_bloc.dart';
import 'package:fitphone/model/photo_model.dart';
import 'package:fitphone/view/image_view_screen.dart';
import 'package:flutter/material.dart';

class PhotosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Photos",style: Theme.of(context).textTheme.title),
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
      child: StreamBuilder<List<PhotoModel>>(
          stream: userBloc.getPhotosList,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            if (snapshot.data.length == 0)
              return (Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/gallery.png")),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Don't have any photos",
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          color: Colors.grey,
                        ),
                  )
                ],
              )));

            return GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
              crossAxisCount: 3,
              children: List.generate(snapshot.data.length, (index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ImageViewScreen(photo: snapshot.data[index]))),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Hero(
                        tag: snapshot.data[index].url,
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data[index].url,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(seconds: 3),
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
    ));
  }
}
