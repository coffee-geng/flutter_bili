enum HttpMethod { GET, POST, DELETE }

/// 通过抽象类来封装基础请求
abstract class HiBaseRequest {
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

    print('url:${uri.toString()}');
    return uri.toString();
  }

  Map<String, String> queryParams = Map();

  // 添加参数，支持链式调用
  HiBaseRequest add(String k, Object v) {
    queryParams[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {};

  // 添加header
  HiBaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
