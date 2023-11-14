import 'core/dio_adapter.dart';
import 'core/hi_error.dart';
import 'core/hi_net_adapter.dart';
import 'request/hi_base_request.dart';
import 'core/hi_interceptor.dart';

class HiNet {
  HiNet._();
  static HiNet? _instance;
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  HiErrorInterceptor? _hiErrorInterceptor;

  Future fire(HiBaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog(error);
    }

    var result = response?.data;
    // printLog(result);
    var statusCode = response?.statusCode;
    var hiError;
    switch (statusCode) {
      case 200:
        return result;
      case 401:
        hiError = NeedLogin();
        break;
      case 402:
        hiError = NeedAuth(result.toString(), data: result);
        break;
      default:
        //如果error不为空，则复用现有的errr
        hiError = error ??
            HiNetError(statusCode ?? -1, result.toString(), data: result);
        break;
    }
    //交给拦截器处理错误
    if (_hiErrorInterceptor != null) {
      _hiErrorInterceptor!(hiError);
    }
    return result;
  }

  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    // printLog('url: ${request.url()}');
    // printLog('method: ${request.httpMethod()}');
    // request.addHeader("token", "123");
    // printLog("header: ${request.header}");
    // return Future.value({
    //   "statusCode": 200,
    //   "data": {"code": 0, "message": "success"}
    // });

    // 使用Mock发送请求
    // HiNetAdapter adapter = MockAdapter();
    // 使用dio发送请求
    HiNetAdapter adapter = DioAdapter();
    return await adapter.send(request);
    // HiNetAdapter adapter = HttpAdapter();
    // return await adapter.send(request);
  }

  void printLog(log) {
    print('hi_net: ${log.toString()}');
  }

  void setErrorInterceptor(HiErrorInterceptor interceptor) {
    this._hiErrorInterceptor = interceptor;
  }
}
