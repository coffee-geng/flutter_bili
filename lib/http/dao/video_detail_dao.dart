import 'package:flutter_bili/http/request/video_detail_request.dart';

import '../../model/video_detail_mo.dart';
import '../core/hi_net.dart';
import '../core/hi_net_adapter.dart';

class VideoDetailDao {
  //https://api.devio.org/uapi/fa/detail/BV1qt411j7fV
  static get(String vid) async {
    var request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == 0 && result['data'] != null) {
      return VideoDetailMo.fromJson(result['data']);
    }
    return null;
  }
}
