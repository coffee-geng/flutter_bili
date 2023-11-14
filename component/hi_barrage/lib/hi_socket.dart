import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';
import 'barrage_mo.dart';

class HiSocket extends ISocket {
  static const _URL = 'wss://api.devio.org/uapi/fa/barrage/';
  IOWebSocketChannel? _channel;
  late final Map<String, dynamic> headers;
  late final ValueChanged<List<BarrageMo>> _callback;

  ///心跳间隔秒数。虽然webSocket是长连接，但是支持webSocket服务的Nginx默认有60秒的超时时间，当超过timeout客户端仍没请求，则会关闭连接
  ///所以需要在客户端使用心跳机制，定时发送请求，放在连接关闭
  int _intervalSecond = 50;

  HiSocket(this.headers);

  @override
  void close() {
    _channel?.sink.close();
  }

  @override
  ISocket listen(ValueChanged<List<BarrageMo>> callback) {
    _callback = callback;
    return this;
  }

  @override
  ISocket open(String vid) {
    _channel = IOWebSocketChannel.connect(_URL + vid,
        headers: headers, pingInterval: Duration(seconds: _intervalSecond));
    _channel?.stream.handleError((error) {
      print('连接发送错误：$error');
    }).listen((message) {
      _handleMessage(message);
    });
    return this;
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }

  ///处理服务端的返回
  void _handleMessage(message) {
    print('received: $message');
    var result = BarrageMo.fromJsonString(message);
    if (_callback != null) {
      _callback(result);
    }
  }
}

abstract class ISocket {
  ///和服务器建立连接。vid是视屏的ID
  ISocket open(String vid);

  ///发送弹幕
  ISocket send(String message);

  ///关闭连接
  void close();

  ///接收弹幕
  ISocket listen(ValueChanged<List<BarrageMo>> callback);
}
