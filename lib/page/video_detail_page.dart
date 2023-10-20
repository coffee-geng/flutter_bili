import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_state.dart';
import 'package:flutter_bili/widget/video_view.dart';

import '../model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo videoModel;

  const VideoDetailPage(this.videoModel, {Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends HiState<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('视频详情页，vid: ${widget.videoModel.vid}'),
          Text('视频详情页，title: ${widget.videoModel.title}'),
          if (widget.videoModel.url != null)
            VideoView(
              url: widget.videoModel.url!,
              cover: widget.videoModel.cover,
            )
        ],
      ),
    );
  }
}
