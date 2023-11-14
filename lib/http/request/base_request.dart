import 'package:flutter_bili/http/dao/login_dao.dart';
import 'package:hi_net/request/hi_base_request.dart';
import '../../utils/hi_constant.dart';

/// 通过抽象类来封装基础请求
abstract class BaseRequest extends HiBaseRequest {
  @override
  String url() {
    if (needLogin()) {
      // 给需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    return super.url();
  }

  // 定义此API接口是否需要先登录
  bool needLogin();

  @override
  Map<String, dynamic> get header => HiConstant.headers();
}
