import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/utils/format_util.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class VideoCard extends StatelessWidget {
  final VideoMo? videoModel;

  const VideoCard({Key? key, this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(videoModel?.url);
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.detail, args: {'videoMo': videoModel});
      },
      child: _itemCard(context),
    );
  }

  _itemCard(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color textColor = themeProvider.isDark() ? Colors.white70 : Colors.black87;
    return SizedBox(
        height: 200,
        child: Card(
            //取消卡片默认边距
            margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (videoModel != null) _itemImage(videoModel!, context),
                  if (videoModel != null) _infoText(videoModel!, textColor)
                ],
              ),
            )));
  }

  _itemImage(VideoMo videoMo, BuildContext context) {
    final size = MediaQuery.of(context).size;
    //SingleChildScrollView.padding.left+right: 20
    //StraggeredGrid.crossAxisSpacing: 4
    //Card.margin.left_right: 8
    final sizeboxWidth = size.width - 20 - 4 - 8;
    return SizedBox(
        height: 122,
        width: sizeboxWidth,
        child: Stack(
          children: [
            cachedFadeInImage(videoMo.cover, fit: BoxFit.cover),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black54, Colors.transparent])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconText(Icons.ondemand_video, videoMo.view),
                      _iconText(Icons.favorite_border, videoMo.favorite),
                      _iconText(null, videoMo.duration)
                    ],
                  ),
                ))
          ],
        ));
  }

  _iconText(IconData? iconData, int view) {
    String labelText;
    if (iconData != null) {
      labelText = countFormat(view);
    } else {
      //时间格式化
      labelText = durationTransform(view);
    }
    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
            padding: EdgeInsets.only(left: iconData != null ? 3 : 0),
            child: Text(labelText,
                style: TextStyle(color: Colors.white, fontSize: 10)))
      ],
    );
  }

  _infoText(VideoMo videoMo, Color textColor) {
    return SizedBox(
        height: 70,
        child: Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(videoMo.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor, fontSize: 12)),
                _owner(videoMo.owner, textColor)
              ],
            )));
  }

  _owner(Owner owner, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: cachedImage(owner.face,
                    height: 24, width: 24, fit: BoxFit.cover)),
            Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(owner.name,
                    style: TextStyle(fontSize: 11, color: textColor)))
          ],
        ),
        Icon(Icons.more_vert_sharp, size: 15, color: Colors.grey)
      ],
    );
  }
}
