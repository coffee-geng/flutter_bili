import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bili/http/dao/login_dao.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/navigator/bottom_navigator.dart';
import 'package:flutter_bili/page/dark_mode_page.dart';
import 'package:flutter_bili/page/login_page.dart';
import 'package:flutter_bili/page/notice_page.dart';
import 'package:flutter_bili/page/registration_page.dart';
import 'package:flutter_bili/page/video_detail_page.dart';
import 'package:flutter_bili/provider/hi_provider.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/utils/hi_defend.dart';
import 'package:flutter_bili/utils/toast.dart';
import 'package:hi_cache/hi_cache.dart';
import 'navigator/hi_navigator.dart';
import 'package:provider/provider.dart';

void main() {
  HiDefend().run(BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routerDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: HiCache.preInit(),
        builder: (builderContext, asyncSnapshot) {
          final widget = asyncSnapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routerDelegate)
              : const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
          return MultiProvider(
              providers: topProviders,
              child: Consumer<ThemeProvider>(builder: (BuildContext context,
                  ThemeProvider themeProvider, Widget? child) {
                return MaterialApp(
                  home: widget,
                  theme: themeProvider.getTheme(),
                  darkTheme: themeProvider.getTheme(isDarkMode: true),
                  themeMode: themeProvider.getThemeMode(),
                  title: 'flutter bili',
                );
              }));
        });
  }

// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     home: widget,
//     theme: ThemeData(primarySwatch: white),
//   );
// }
}

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = '/';

  BiliRoutePath.detail() : location = '/detail';
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    HiNavigator.getInstance()
        .registerWithListener(RouteJumpListener((routeStatus, {args}) {
      if (routeStatus == RouteStatus.detail &&
          args != null &&
          args!.containsKey('videoMo')) {
        _videoModel = args!['videoMo'];
      }
      _routeStatus = routeStatus;
      notifyListeners();
    }));
  }

  List<Page> pages = [];
  VideoMo? _videoModel;
  RouteStatus _routeStatus = RouteStatus.home;

  /// 获取当前的路由状态，可以在这进行拦截，根据业务流程控制最终输出的路由状态
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return RouteStatus.login;
    }
    // 当有视频数据时，从首页直接调转到详情页
    else if (_routeStatus == RouteStatus.home && _videoModel != null) {
      return RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Widget build(BuildContext context) {
    //构建路由栈
    var tempPages = pages;
    var routeIndex = getPageIndex(tempPages, routeStatus);
    // 如果新路由状态存在于当前路由栈中，则必须先将此路由状态想及其剧栈顶的所有其他项都清除，然后再重现添加新的路由状态
    if (routeIndex >= 0) {
      tempPages = tempPages.sublist(0, routeIndex);
    }
    // 如果新路由状态是跳转到首页，则必须将当前路由栈全部清除，因为不能从首页再回退到其他任何页面
    if (routeStatus == RouteStatus.home) {
      tempPages.clear();
    }
    MaterialPage? page;
    if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.home) {
      page = pageWrap(BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(_videoModel!));
    } else if (routeStatus == RouteStatus.notice) {
      page = pageWrap(NoticePage());
    } else if (routeStatus == RouteStatus.dark_mode) {
      page = pageWrap(DarkModePage());
    }
    if (page != null) {
      tempPages = [...tempPages, page];
    }
    //当路由栈数据要更新时，感知路由页面的切换，从而通知监听的页面
    HiNavigator.getInstance().notifyRouteChangesToListener(tempPages, pages);

    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    pages = tempPages;
    return WillPopScope(
        // 修复Android物理返回键，无法返回上一页的问题
        // 等没有上一页可以返回了，则maybePop返回false
        onWillPop: () async =>
            !(await navigatorKey?.currentState?.maybePop() ?? false),
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              final widget = (route.settings as MaterialPage).child;
              // 在登录页面点击了返回键
              if (widget is LoginPage) {
                if (!hasLogin) {
                  showWarningToast('请先登录');
                  return false;
                }
              }
            }
            //在这可以控制是否可以返回上一页
            if (!route.didPop(result)) {
              return false;
            }
            //执行返回上一页时，必须将栈顶移除，表示当前页面出栈
            var tempPages = [...pages];
            pages.removeLast();
            //通知路由变化
            HiNavigator.getInstance()
                .notifyRouteChangesToListener(pages, tempPages);
            return true;
          },
        ));
  }

  /// 为Navigator设置一个KEY，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  GlobalKey<NavigatorState>? navigatorKey;

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {}
}
