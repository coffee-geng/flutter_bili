import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/utils/view_util.dart';

enum StatusStyle { DARK_CONTENT, LIGHT_CONTENT }

///可自定义样式的沉浸式导航栏
class NavigationBar extends StatefulWidget {
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
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  void initState() {
    super.initState();
    _statusBarInit();
  }

  @override
  Widget build(BuildContext context) {
    _statusBarInit();

    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: widget.color),
      child: widget.child,
    );
  }

  void _statusBarInit() {
    changeStatusBar(color: widget.color, statusStyle: widget.statusStyle);
  }
}
