import 'package:flutter_bili/model/video_model.dart';

class RankingMo {
  int? total;
  List<VideoMo>? list;

  RankingMo({this.total, this.list});

  RankingMo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = <VideoMo>[];
      json['list'].forEach((v) {
        list!.add(new VideoMo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
