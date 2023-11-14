import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:flutter_bili/utils/hi_constant.dart';
import 'package:hi_cache/hi_cache.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['system', 'light', 'dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  //初始化时，从操作系统读取的brightness作为程序当前的brightness。如果操作系统更改了暗黑模式，会调用darkModeChange方法判断程序当前brightness是否和操作系统一致。
  var _platformBrightness = PlatformDispatcher.instance.platformBrightness;

  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      // return SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void darkModeChange() {
    if (_platformBrightness != PlatformDispatcher.instance.platformBrightness) {
      _platformBrightness = PlatformDispatcher.instance.platformBrightness;
      notifyListeners(); //通知系统各监听了ThemeProvider对象的组件更新主题颜色
    }
  }

  ///获取主题模式
  ThemeMode getThemeMode() {
    //从本地缓存中获取ThemeMode
    String? theme = HiCache.getInstance().get(HiConstant.theme);
    switch (theme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    return _themeMode!;
  }

  ///获取主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
        primaryColor: isDarkMode ? HiColor.dark_bg : white,
        //Tab指示器的颜色
        indicatorColor: isDarkMode ? primary[50] : white,
        //页面背景色
        scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white);
    return themeData;
  }

  ///设置主题
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstant.theme, themeMode.value);
    // _themeMode = themeMode;
    notifyListeners();
  }
}
