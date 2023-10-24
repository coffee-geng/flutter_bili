import 'package:flutter_bili/http/request/base_request.dart';
import 'package:flutter_bili/http/request/favorite_request.dart';
import 'package:flutter_bili/http/request/like_request.dart';

import '../core/hi_net.dart';

class LikeDao {
  //https://api.devio.org/uapi/fa/like/BV1qt411j7fV
  static like(String vid, bool isCancel) async {
    BaseRequest request = isCancel ? CancelLikeRequest() : LikeRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
