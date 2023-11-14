import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:provider/provider.dart';

import 'package:hi_base/color.dart';

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
  late StatusStyle _statusStyle;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
    _statusStyle = widget.statusStyle;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    if (themeProvider.isDark()) {
      _color = HiColor.dark_bg;
      _statusStyle = StatusStyle.LIGHT_CONTENT;
    } else {
      _color = widget.color;
      _statusStyle = StatusStyle.DARK_CONTENT;
    }
    _statusBarInit();

    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: _color),
      child: widget.child,
    );
  }

  void _statusBarInit() {
    changeStatusBar(color: _color, statusStyle: _statusStyle);
  }
}
