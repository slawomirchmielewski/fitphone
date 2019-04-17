/*
import 'package:flutter/material.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';


class YouTubePlayer extends StatefulWidget {

  final String id ;

  YouTubePlayer({this.id = "Zu9RVJvnHyE"});

  @override
  _YouTubePlayerState createState() => _YouTubePlayerState();
}

class _YouTubePlayerState extends State<YouTubePlayer>  implements YouTubePlayerListener{


  FlutterYoutubeViewController flutterYoutubeViewController;


  @override
  Widget build(BuildContext context) {

    return Container(
      child: FlutterYoutubeView(
        onViewCreated: _onYoutubeCreated,
        listener: this,
        params: YoutubeParam(
            videoId: widget.id,
            showUI: true,
            startSeconds: 0.0),
      )
    );
  }

  @override
  void onCurrentSecond(double second) {
  }

  @override
  void onError(String error) {
    print((error.toString()));
  }

  @override
  void onReady() {
    print("Ready");
    flutterYoutubeViewController.pause();
  }

  @override
  void onStateChange(String state) {

  }

  @override
  void onVideoDuration(double duration) {
  }

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {

    flutterYoutubeViewController = controller;

  }

 @override
  void dispose() {
    flutterYoutubeViewController.pause();
    super.dispose();
  }

}
*/
