import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {


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
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

  YoutubePlayerController youtubePlayerController;


  @override
  void initState() {
    super.initState();

    youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url),
      flags:  YoutubePlayerFlags(
        autoPlay: false,
        hideControls: false
      ));
  }


  @override
  Widget build(BuildContext context) {
    Widget youtubePlayer = YoutubePlayer(
      controller: youtubePlayerController,
      showVideoProgressIndicator: true,
    );
    return youtubePlayer;
  }
}
