import 'package:flutter_bili/http/request/like_request.dart';
import 'package:hi_net/hi_net.dart';
import 'package:hi_net/request/hi_base_request.dart';

class LikeDao {
  //https://api.devio.org/uapi/fa/like/BV1qt411j7fV
  static like(String vid, bool isCancel) async {
    HiBaseRequest request = isCancel ? CancelLikeRequest() : LikeRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
