import 'package:flutter_bili/http/request/base_request.dart';
import 'package:flutter_bili/http/request/favorite_request.dart';

import '../core/hi_net.dart';

class FavoriteDao {
  //https://api.devio.org/uapi/fa/favorite/BV1qt411j7fV
  static favorite(String vid, bool isCancel) async {
    BaseRequest request =
        isCancel ? CancelFavoriteRequest() : FavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
