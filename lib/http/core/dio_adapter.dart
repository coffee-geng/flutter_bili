import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/core/hi_net_adapter.dart';
import 'package:flutter_bili/http/request/base_request.dart';
import 'package:dio/dio.dart';

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    Response? response;
    var options = Options(headers: request.header);
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.queryParams, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio().delete(request.url(), options: options);
      }
    } on DioException catch (e) {
      error = e;
      response = e.response;
    }

    if (error != null) {
      // 抛出HiNetError
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: await buildRes(response, request));
    }
    return buildRes(response, request);
  }

  /// 构建HiNetResponse
  Future<HiNetResponse<T>> buildRes<T>(
      Response? response, BaseRequest request) {
    return Future.value(HiNetResponse<T>(
        statusCode: response?.statusCode ?? -1,
        statusMessage: response?.statusMessage,
        request: request,
        data: response?.data,
        extra: response));
  }
}
