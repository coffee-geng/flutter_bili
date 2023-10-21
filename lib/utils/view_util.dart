import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_bili/widget/navigation_bar.dart';
import 'package:transparent_image/transparent_image.dart';

//带缓存的image
Widget cachedImage(String url, {double? width, double? height, BoxFit? fit}) {
  return CachedNetworkImage(
      height: height,
      width: width,
      placeholder: (
        BuildContext context,
        String url,
      ) =>
          Container(color: Colors.grey[200]),
      errorWidget: (
        BuildContext context,
        String url,
        dynamic error,
      ) =>
          Icon(Icons.error),
      imageUrl: url);
}

Widget cachedFadeInImage(String url,
    {double? width, double? height, BoxFit? fit}) {
  return FadeInImage(
    image: CachedNetworkImageProvider(url),
    placeholder: MemoryImage(kTransparentImage),
    width: width,
    height: height,
  );
}

//黑色线性渐变定义播放器底部颜色
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ]);
}

///修改状态栏
void changeStatusBar(
    {color = Colors.white,
    StatusStyle statusStyle = StatusStyle.DARK_CONTENT,
    BuildContext? context}) {
  // 沉浸式状态栏样式
  // FlutterStatusbarManager.setColor(color, animated: false);
  // FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT
  //     ? StatusBarStyle.DARK_CONTENT
  //     : StatusBarStyle.LIGHT_CONTENT);
  var brightness = statusStyle == StatusStyle.LIGHT_CONTENT
      ? Brightness.dark
      : Brightness.light;
  var iconBrightness =
      brightness == Brightness.light ? Brightness.dark : Brightness.light;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor:
          brightness == Brightness.light ? Colors.transparent : color,
      statusBarBrightness: brightness,
      statusBarIconBrightness: iconBrightness));
}
