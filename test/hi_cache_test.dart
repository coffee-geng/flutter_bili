import 'package:flutter_test/flutter_test.dart';
import 'package:hi_cache/hi_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

///单元测试
void main() {
  test('测试HiCache', () async {
    //为了解决在运行测试过程中所报的异常： fix ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
    TestWidgetsFlutterBinding.ensureInitialized();
    //因为HiCache中用到了SharedPreference读写磁盘的，而单元测试不支持直接读写磁盘
    //如果不调用下面的代码，则会抛异常： fix MissingPluginException(No implementation found for method getAll on channel plugins. flutter.io/shared_preferences)
    SharedPreferences.setMockInitialValues({});
    await HiCache.preInit();
    var key = 'testHiCache', value = 'Hello';
    HiCache.getInstance().setString(key, value);
    expect(HiCache.getInstance().get(key), value);
  });
}
