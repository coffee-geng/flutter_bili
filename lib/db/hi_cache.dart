import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class HiCache {
  SharedPreferences? _prefs;

  HiCache._() {
    _init();
  }

  HiCache._pre(SharedPreferences prefs) {
    _prefs = prefs;
  }

  // 预初始化，防止在使用get时，prefs还未完成初始化
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  static HiCache? _instance;
  static HiCache getInstance() {
    if (_instance == null) {
      _instance = HiCache._();
    }
    return _instance!;
  }

  void _init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  setString(String key, String value) {
    _prefs?.setString(key, value);
  }

  setDouble(String key, double value) {
    _prefs?.setDouble(key, value);
  }

  setInt(String key, int value) {
    _prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    _prefs?.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    _prefs?.setStringList(key, value);
  }

  remove(String key) {
    _prefs?.remove(key);
  }

  T? get<T>(String key) {
    var result = _prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
}
