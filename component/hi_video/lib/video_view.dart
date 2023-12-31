import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:hi_base/color.dart';

import 'hi_video_controls.dart';

class VideoView extends StatefulWidget {
  final String url;
  final String? cover;
  final double aspectRatio;
  final bool autoPlay;
  final bool loop;
  final Widget? overlayUI;
  final Widget? barrageUI;

  const VideoView(
      {Key? key,
      required this.url,
      this.aspectRatio = 16 / 9,
      this.cover,
      this.autoPlay = true,
      this.loop = false,
      this.overlayUI,
      this.barrageUI})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final VideoPlayerController _videoPlayerController;
  late final ChewieController _chewieController;

  //封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover!),
      );

  //进度条颜色配置
  get _progressColors => ChewieProgressColors(
      playedColor: primary,
      handleColor: primary,
      backgroundColor: Colors.grey,
      bufferedColor: primary[50] ?? Colors.grey);

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: widget.autoPlay,
        looping: widget.loop,
        allowMuting: false,
        allowPlaybackSpeedChanging: true,
        placeholder: (widget.cover != null) ? _placeholder : null,
        aspectRatio: widget.aspectRatio,
        customControls: MaterialControls(
          showLoadingOnInitialize: false,
          showBigPlayIcon: false,
          bottomGradient: blackLinearGradient(),
          showOptionsButton: false,
          overlayUI: widget.overlayUI,
          barrageUI: widget.barrageUI,
        ),
        materialProgressColors: _progressColors);
    _chewieController.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    _chewieController.removeListener(_fullScreenListener);
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

  void _fullScreenListener() {
    // Size size = MediaQuery.of(context).size;
    // if (size.width > size.height) {
    //   OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    // }
  }
}
