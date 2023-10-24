import 'package:flutter_bili/model/video_model.dart';

class VideoDetailMo {
  bool? isFavorite;
  bool? isLike;
  VideoMo? videoInfo;
  List<VideoMo>? videoList;

  VideoDetailMo({this.isFavorite, this.isLike, this.videoInfo, this.videoList});

  VideoDetailMo.fromJson(Map<String, dynamic> json) {
    isFavorite = json['isFavorite'];
    isLike = json['isLike'];
    videoInfo = json['videoInfo'] != null
        ? new VideoMo.fromJson(json['videoInfo'])
        : null;
    if (json['videoList'] != null) {
      videoList = <VideoMo>[];
      json['videoList'].forEach((v) {
        videoList!.add(new VideoMo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFavorite'] = this.isFavorite;
    data['isLike'] = this.isLike;
    if (this.videoInfo != null) {
      data['videoInfo'] = this.videoInfo!.toJson();
    }
    if (this.videoList != null) {
      data['videoList'] = this.videoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
