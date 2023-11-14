import 'package:flutter_bili/http/request/ranking_request.dart';
import 'package:flutter_bili/model/ranking_mo.dart';
import 'package:hi_net/hi_net.dart';
import 'package:hi_net/request/hi_base_request.dart';

class RankingDao {
  //https://api.devio.org/uapi/fa/ranking?sort=like&pageIndex=1&pageSize=10
  static get(
      {required String sort, int pageIndex = 0, int pageSize = 10}) async {
    HiBaseRequest request = RankingRequest();
    request
        .add('sort', sort)
        .add('pageIndex', pageIndex)
        .add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    return RankingMo.fromJson(result['data']);
  }
}
