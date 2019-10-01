import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatelessWidget {

  final String videoUrl;
  final String exerciseName;

  VideoView(this.videoUrl,this.exerciseName);

  @override
  Widget build(BuildContext context) {

    final String id = YoutubePlayer.convertUrlToId(videoUrl);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        textTheme: Theme.of(context).textTheme,
        title: Text(exerciseName),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: YoutubePlayer(
              context: context,
              videoId:id,
              flags: YoutubePlayerFlags(
                  hideControls: false,
                  hideFullScreenButton: true,
                  autoPlay: false,
                  showVideoProgressIndicator: true
              ),
              videoProgressIndicatorColor: Colors.amber,
              progressColors: ProgressColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
              onPlayerInitialized: (controller) {
                controller.forceHideAnnotation();
              }
          ),
        ),
      ),
    );
  }
}
