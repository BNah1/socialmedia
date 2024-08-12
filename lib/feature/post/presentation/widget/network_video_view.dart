
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoView extends StatefulWidget {
  const NetworkVideoView({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<NetworkVideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<NetworkVideoView> {
  late final VideoPlayerController _videoPlayerController;
  bool isPlaying = false;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((value) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio,child: Stack(children: [
      VideoPlayer(_videoPlayerController),
      Positioned(top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: IconButton(
            onPressed: (){
              if(isPlaying){
                _videoPlayerController.pause();
              }else{
                _videoPlayerController.play();
              }
              isPlaying = !isPlaying;
              setState(() {
              });
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 50,
              color: Colors.white,
            ),
          ))
    ],),);
  }
}
