import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/bottom_navigator.dart';
import 'package:flutter_bili/page/home_page.dart';
import 'package:flutter_bili/page/login_page.dart';
import 'package:flutter_bili/page/registration_page.dart';
import 'package:flutter_bili/page/video_detail_page.dart';

///创建页面
pageWrap(Widget widget) {
  return MaterialPage(key: ValueKey(widget.hashCode), child: widget);
}

//自定义路由封装，路由状态
enum RouteStatus { login, registration, home, detail, unknown }

//建立路由状态与路由配置页面的对应关系
RouteStatus getRouteStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  }
  //BottomNavigator取得HomePage成为首页
  else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

// 获取指定路由状态在当前路由栈中的位置
// pages: 当前路由栈中的按序放置的所有路由页面
int getPageIndex(List<Page> pages, RouteStatus routeStatus) {
  for (var i = 0; i < pages.length; i++) {
    var status = getRouteStatus(pages[i] as MaterialPage);
    if (status == routeStatus) {
      return i;
    }
  }
  return -1;
}

class RouteStatusInfo {
  final RouteStatus status;
  final Widget widget;

  RouteStatusInfo(this.status, this.widget);
}

/// 监听路由页面跳转
/// 感知当前页面是否压后台
class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;

  HiNavigator._() {}

  static HiNavigator getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }
    return _instance!;
  }

  RouteJumpListener? _routeJumpListener;

  registerWithListener(RouteJumpListener listener) {
    _routeJumpListener = listener;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    if (_routeJumpListener != null) {
      _routeJumpListener!.onJumpTo(routeStatus, args: args);
    }
  }

  List<RouteChangeListener> _listeners = [];

  addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

//最近打开的页面
  RouteStatusInfo? _currentRouteStatusInfo;

  //底部导航栏中激活的页面
  RouteStatusInfo? _currentRouteFromBottomTab;

  initBottomTabCurrentRoute(RouteStatus status, Widget widget) {
    _currentRouteFromBottomTab = RouteStatusInfo(status, widget);
  }

  ///当路由栈数据发生变化后，调用此方法通知路由页面的变化
  notifyRouteChangesToListener(List<Page> currentPages, List<Page> prevPages) {
    if (currentPages == prevPages) {
      return;
    }
    if (currentPages.last is! MaterialPage) {
      return;
    }
    var current = RouteStatusInfo(
        getRouteStatus(currentPages.last as MaterialPage),
        (currentPages.last as MaterialPage).child);
    _notifyRouteChanges(current, _currentRouteStatusInfo);
  }

  void _notifyRouteChanges(RouteStatusInfo current, RouteStatusInfo? prev) {
    ///初始化页面，第一次切换到路由状态是home时，此方法传入的current是BottomNavigator，而不是具体某个tab页面
    if (current.widget is BottomNavigator &&
        _currentRouteFromBottomTab != null) {
      current = _currentRouteFromBottomTab!; //如果打开的是首页，则明确到首页具体的tab
    }
    _listeners.forEach((listener) {
      listener(current, prev);
    });
    _currentRouteStatusInfo = current;
  }

  ///当底部导航栏页面发生变化后，调用此方法通知路由页面的变化
  void onBottomTabChange(int tabIndex, Widget widget) {
    var newRouteInfo = RouteStatusInfo(RouteStatus.home, widget);
    _notifyRouteChanges(newRouteInfo, _currentRouteFromBottomTab);
    _currentRouteFromBottomTab = newRouteInfo;
  }
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

typedef RouteChangeListener = void Function(
    RouteStatusInfo current, RouteStatusInfo? prev);

abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

// 定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo; //这里声明的方法是由外界BiliRouteDelegate定义和传入的

  RouteJumpListener(this.onJumpTo);
}
