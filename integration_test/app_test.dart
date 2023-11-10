import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bili/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test login jump', (widgetTester) async {
    //构建应用
    app.main();

    //捕获一帧
    await widgetTester.pumpAndSettle();
    //通过key来查找注册按钮
    var registrationBtn = find.byKey(Key('registration'));
    //触发按钮的点击事件
    await widgetTester.tap(registrationBtn);
    //捕获一帧
    await widgetTester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));

    //判断是否跳转到了注册页
    expect(HiNavigator.getInstance().getCurrent()?.status,
        RouteStatus.registration);

    //获取返回按钮，并触发返回上一页
    var backBtn = find.byType(BackButton);
    await widgetTester.tap(backBtn);
    await widgetTester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
    //判断是否返回到登录页
    expect(HiNavigator.getInstance().getCurrent()?.status, RouteStatus.login);
  });
}
