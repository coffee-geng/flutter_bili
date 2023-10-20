import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum StatusStyle { DARK_CONTENT, LIGHT_CONTENT }

class NavigationBar extends StatelessWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const NavigationBar(
      {Key? key,
      this.statusStyle = StatusStyle.DARK_CONTENT,
      this.color = Colors.white,
      this.height = 42,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _statusBarInit();

    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color),
      child: child,
    );
  }

  void _statusBarInit() {
    // 沉浸式状态栏样式
    // FlutterStatusbarManager.setColor(color, animated: false);
    // FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT
    //     ? StatusBarStyle.DARK_CONTENT
    //     : StatusBarStyle.LIGHT_CONTENT);
  }
}
