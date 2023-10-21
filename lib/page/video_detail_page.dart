import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bili/core/hi_state.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:flutter_bili/widget/app_bar.dart';
import 'package:flutter_bili/widget/video_view.dart';
import 'package:flutter_bili/widget/navigation_bar.dart' as nav;

import '../model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo videoModel;

  const VideoDetailPage(this.videoModel, {Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends HiState<VideoDetailPage> {
  @override
  void initState() {
    super.initState();
    changeStatusBar(
        color: Colors.black, statusStyle: nav.StatusStyle.LIGHT_CONTENT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: 50),
        if (widget.videoModel.url != null)
          VideoView(
            url: widget.videoModel.url!,
            cover: widget.videoModel.cover,
            overlayUI: videoAppBar(),
          ),
        if (widget.videoModel.url != null)
          Text('视频详情页，vid: ${widget.videoModel.vid}'),
        if (widget.videoModel.url != null)
          Text('视频详情页，title: ${widget.videoModel.title}'),
      ],
    ));
  }
}
