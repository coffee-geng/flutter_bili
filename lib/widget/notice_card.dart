import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/utils/format_util.dart';
import 'package:flutter_bili/utils/view_util.dart';

import '../model/home_mo.dart';
import '../model/video_model.dart';

///通知列表卡片
class NoticeCard extends StatelessWidget {
  final BannerMo bannerMo;

  const NoticeCard({Key? key, required this.bannerMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          handleBannerClick(bannerMo);
        },
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildIcon(), hiSpace(width: 10), _buildContents()],
          ),
        ));
  }

  void handleBannerClick(BannerMo bannerMo) {
    if (bannerMo.type == 'video') {
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
          args: {'videoMo': VideoMo(vid: bannerMo.url)});
    } else {
      print('type: ${bannerMo.type} ,url: ${bannerMo.url}');
      HiNavigator.getInstance().openH5(bannerMo.url);
    }
  }

  _buildIcon() {
    var iconData = bannerMo.type == 'video'
        ? Icons.ondemand_video_outlined
        : Icons.card_giftcard;
    return Icon(iconData, size: 30);
  }

  _buildContents() {
    return Flexible(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(bannerMo.title, style: TextStyle(fontSize: 16)),
            Text(dateToMonthAndDay(bannerMo.createTime))
          ],
        ),
        hiSpace(height: 5),
        Text(bannerMo.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis)
      ],
    ));
  }
}
