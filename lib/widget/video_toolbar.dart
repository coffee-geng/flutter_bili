import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/model/video_detail_mo.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/utils/color.dart';
import 'package:flutter_bili/utils/format_util.dart';
import 'package:flutter_bili/utils/view_util.dart';

class VideoToolbar extends StatelessWidget {
  final VideoDetailMo? videoDetailMo;
  final VideoMo videoMo;
  final VoidCallback? onLike;
  final VoidCallback? onUnlike;
  final VoidCallback? onCoin;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const VideoToolbar(
      {Key? key,
      this.videoDetailMo,
      required this.videoMo,
      this.onLike,
      this.onUnlike,
      this.onCoin,
      this.onFavorite,
      this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(border: borderLine(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(Icons.thumb_up_alt_rounded, videoMo.like,
              onClick: onLike, tint: videoDetailMo?.isLike),
          _buildIconText(Icons.thumb_down_alt_rounded, '不喜欢',
              onClick: onUnlike),
          _buildIconText(Icons.monetization_on, videoMo.coin, onClick: onCoin),
          _buildIconText(Icons.grade_rounded, videoMo.favorite,
              onClick: onFavorite, tint: videoDetailMo?.isFavorite),
          _buildIconText(Icons.share_rounded, videoMo.share, onClick: onShare)
        ],
      ),
    );
  }

  _buildIconText(IconData iconData, text, {onClick, bool? tint = false}) {
    if (text is int) {
      text = countFormat(text);
    } else if (text == null) {
      text = '';
    }
    tint = tint ?? false;
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Icon(iconData, color: tint ? primary : Colors.grey, size: 20),
          hiSpace(height: 5),
          Text(text, style: TextStyle(color: Colors.grey, fontSize: 12))
        ],
      ),
    );
  }
}
