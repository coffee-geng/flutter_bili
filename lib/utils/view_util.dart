import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
