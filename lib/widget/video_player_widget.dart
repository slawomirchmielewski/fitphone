import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class VideoPlayer extends StatelessWidget {


  final String url;
  final bool hideControls;
  final double height;
  final double width;

  VideoPlayer(this.url, {
    this.hideControls = false,
    this.width,
    this.height
  });


  @override
  Widget build(BuildContext context) {

    final String id = YoutubePlayer.convertUrlToId(url);

    Widget youtubePlayer = YoutubePlayer(
        context: context,
        videoId: id,
        flags: YoutubePlayerFlags(
          hideControls: hideControls,
          autoPlay: false,
          showVideoProgressIndicator: true
        ),
        videoProgressIndicatorColor: Theme.of(context).primaryColor,
        progressColors: ProgressColors(
          playedColor:Theme.of(context).primaryColor,
          handleColor: Theme.of(context).primaryColor
        ),
        onPlayerInitialized: (controller) {
          var size = Size(width,height);
          controller.setSize(size);
        }
    );

    return youtubePlayer;

  }
}
