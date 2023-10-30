import 'package:flutter_bili/http/request/base_request.dart';
import 'package:flutter_bili/http/request/ranking_request.dart';
import 'package:flutter_bili/model/ranking_mo.dart';

import '../core/hi_net.dart';

class RankingDao {
  //https://api.devio.org/uapi/fa/ranking?sort=like&pageIndex=1&pageSize=10
  static get(
      {required String sort, int pageIndex = 0, int pageSize = 10}) async {
    BaseRequest request = RankingRequest();
    request
        .add('sort', sort)
        .add('pageIndex', pageIndex)
        .add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    return RankingMo.fromJson(result['data']);
  }
}
