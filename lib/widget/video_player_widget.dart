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


  YoutubePlayerController _controller = YoutubePlayerController();

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }


  @override
  void dispose() {
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final String id = YoutubePlayer.convertUrlToId(widget.url);

    Widget youtubePlayer = YoutubePlayer(
        context: context,
        videoId: id,
        flags: YoutubePlayerFlags(
          hideControls: widget.hideControls,
          autoPlay: false,
          showVideoProgressIndicator: true
        ),
        videoProgressIndicatorColor: Theme.of(context).primaryColor,
        progressColors: ProgressColors(
          playedColor:Theme.of(context).primaryColor,
          handleColor: Theme.of(context).primaryColor
        ),
        onPlayerInitialized: (controller) {
          var size = Size(widget.width,widget.height);
          _controller = controller;
          _controller.setSize(size);

        }
    );



    return youtubePlayer;

  }
}
