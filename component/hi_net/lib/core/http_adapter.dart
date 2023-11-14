import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../request/hi_base_request.dart';
import 'hi_error.dart';
import 'hi_net_adapter.dart';

class HttpAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    http.Response? response;
    var uri = request.url();
    var headers = request.header
        .map((key, value) => MapEntry(key, value?.toString() ?? ''));
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await http.get(Uri.parse(uri), headers: headers);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await http.post(Uri.parse(uri), body: request.queryParams);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await http.delete(Uri.parse(uri));
      }
    } on HttpException catch (e) {
      error = e;
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
      http.Response? response, HiBaseRequest request) {
    Utf8Decoder utf8decoder = const Utf8Decoder();
    var result = response != null
        ? json.decode(utf8decoder.convert(response!.bodyBytes))
        : null;
    return Future.value(HiNetResponse<T>(
        statusCode: response?.statusCode ?? -1,
        statusMessage: response?.reasonPhrase,
        request: request,
        data: result,
        extra: response));
  }
}
