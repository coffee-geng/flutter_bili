import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HiDefend {
  run(Widget app) {
    //感知框架异常
    FlutterError.onError = (FlutterErrorDetails details) {
      //线上环境，走上报逻辑
      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        //开发期间，走Console抛出
        FlutterError.dumpErrorToConsole(details);
      }
    };
    runZonedGuarded(() {
      runApp(app);
    }, (error, stack) {
      _reportError(error, stack);
    });
  }

  ///通过接口上报异常
  void _reportError(Object error, StackTrace stack) {
    print('kReleaseMode: $kReleaseMode');
    print('catch error: $error');
  }
}
