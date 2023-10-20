import 'package:flutter_bili/http/request/home_request.dart';
import '../core/hi_net.dart';
import 'package:flutter_bili/model/home_mo.dart';

class HomeDao {
  //https://api.devio.org/uapi/fa/home/推荐?pageIndex=1&pageSize=10
  static get(String categoryName,
      {int pageIndex = 1, int pageSize = 10}) async {
    final request = HomeRequest();
    request.pathParams = categoryName;
    request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    // print(result);
    return HomeMo.fromJson(result['data']);
  }
}
