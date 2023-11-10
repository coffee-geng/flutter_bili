//进行widget测试时，该widget不能依赖其他第三方的库，而这里的dark_mode_page, ranking_page都依赖其他第三方的库，所以我们新建一个页面进行widget测试
import 'package:flutter/material.dart';
import 'package:flutter_bili/page/unknown_page.dart';
import 'package:flutter_test/flutter_test.dart';

///Widget测试
void main() {
  testWidgets('测试UnknownPage', (widgetTester) async {
    //因为UnknownPage返回的是Scafold页面，所以其外部必须包裹材料设计MaterialApp
    var app = MaterialApp(home: UnknownPage());
    await widgetTester.pumpWidget(app);
    //从页面里面找一个带404文本的text，findsOneWidget表示能够找到一个符号条件的元素
    expect(find.text('405'), findsOneWidget);
  });
}
