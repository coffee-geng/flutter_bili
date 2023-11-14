import 'package:flutter_bili/http/request/favorite_request.dart';
import 'package:flutter_bili/model/ranking_mo.dart';
import 'package:hi_net/hi_net.dart';
import 'package:hi_net/request/hi_base_request.dart';

class FavoriteDao {
  //https://api.devio.org/uapi/fa/favorite/BV1qt411j7fV
  static favorite(String vid, bool isCancel) async {
    HiBaseRequest request =
        isCancel ? CancelFavoriteRequest() : FavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

//https://api.devio.org/uapi/fa/favorites?pageIndex=1&pageSize=10
  static favoriteList({int pageIndex = 1, int pageSize = 10}) async {
    FavoriteListRequest request = FavoriteListRequest();
    request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    return RankingMo.fromJson(result['data']);
  }
}
