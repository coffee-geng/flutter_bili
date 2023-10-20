import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoView extends StatefulWidget {
  final String url;
  final String? cover;
  final double aspectRatio;
  final bool autoPlay;
  final bool loop;

  const VideoView(
      {Key? key,
      required this.url,
      this.aspectRatio = 16 / 9,
      this.cover,
      this.autoPlay = true,
      this.loop = false})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final VideoPlayerController _videoPlayerController;
  late final ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: widget.autoPlay,
        looping: widget.loop);
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final playerHeight = screenWidth / widget.aspectRatio;
    return Container(
        width: screenWidth,
        height: playerHeight,
        color: Colors.grey,
        child: Chewie(controller: _chewieController));
  }
}
