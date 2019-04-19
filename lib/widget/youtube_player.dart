import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class VideoPlayer extends StatelessWidget {


  final String url;

  VideoPlayer(this.url);


  @override
  Widget build(BuildContext context) {


    print("Url $url");

    Widget youtubePlayer = YoutubePlayer(
        context: context,
        videoId: url,
        autoPlay: false,
        showVideoProgressIndicator: true,
        videoProgressIndicatorColor: Colors.amber,
        progressColors: ProgressColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onPlayerInitialized: (controller) {
        }
    );



    return youtubePlayer;

  }
}
