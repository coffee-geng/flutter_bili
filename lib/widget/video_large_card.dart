import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/utils/format_util.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:provider/provider.dart';

class VideoLargeCard extends StatelessWidget {
  final VideoMo videoModel;

  const VideoLargeCard({Key? key, required this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return GestureDetector(
      onTap: () {
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.detail, args: {"videoMo": videoModel});
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
        padding: EdgeInsets.only(bottom: 6),
        height: 106,
        decoration: BoxDecoration(border: borderLine(context)),
        child:
            Row(children: [_itemImage(context), _buildContent(themeProvider)]),
      ),
    );
  }

  _itemImage(BuildContext context) {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(videoModel.cover,
              height: height, width: height * (16 / 9)),
          Positioned(
              bottom: 5,
              right: 15,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(2)),
                child: Text(durationTransform(videoModel.duration),
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ))
        ],
      ),
    );
  }

  _buildContent(ThemeProvider themeProvider) {
    var textColor = themeProvider.isDark() ? Colors.grey : Colors.black87;
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 5, left: 8, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(videoModel.title,
              style: TextStyle(fontSize: 12, color: textColor)),
          _buildBottomContent()
        ],
      ),
    ));
  }

  _buildBottomContent() {
    return Column(
      children: [
        _owner(),
        hiSpace(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...smallIconText(Icons.ondemand_video, videoModel.view),
                hiSpace(width: 5),
                ...smallIconText(Icons.list_alt, videoModel.reply)
              ],
            ),
            Icon(Icons.more_vert_sharp, color: Colors.grey, size: 15)
          ],
        )
      ],
    );
  }

  _owner() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.grey)),
          child: Text('UP',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontWeight: FontWeight.bold)),
        ),
        hiSpace(width: 8),
        Text(videoModel.owner.name,
            style: TextStyle(fontSize: 11, color: Colors.grey))
      ],
    );
  }
}
