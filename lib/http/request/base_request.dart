import 'package:flutter_bili/http/dao/login_dao.dart';

import '../../utils/hi_constant.dart';

enum HttpMethod { GET, POST, DELETE }

/// 通过抽象类来封装基础请求
abstract class BaseRequest {
  // 查询参数 curl-X GET "https://api.devio.org/uapi/test/test?requestPrams=11" -H "accept: */*
  // PATH参数 curl-X GET "https://api.devio.org/uapi/test/test/1"
  var pathParams;
  var useHttps = true;

  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();

  // 请求的短路径
  String path();

  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接path参数
    if (pathParams != null) {
      if (pathStr.endsWith("/")) {
        //确保path与路径参数之间有一个反斜杠分隔
        pathStr = "$pathStr$pathParams";
      } else {
        pathStr = "$pathStr/$pathParams";
      }
    }
    // http和https的切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, queryParams);
    } else {
      uri = Uri.http(authority(), pathStr, queryParams);
    }

    if (needLogin()) {
      // 给需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }

    print('url:${uri.toString()}');
    return uri.toString();
  }

  // 定义此API接口是否需要先登录
  bool needLogin();

  Map<String, String> queryParams = Map();

  // 添加参数，支持链式调用
  BaseRequest add(String k, Object v) {
    queryParams[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = HiConstant.headers();

  // 添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
