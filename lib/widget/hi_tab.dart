import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:underline_indicator/underline_indicator.dart';

import 'package:hi_base/color.dart';
import 'package:provider/provider.dart';

class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController tabController;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color? unselectedLabelColor;

  const HiTab(
      {Key? key,
      required this.tabs,
      required this.tabController,
      this.fontSize = 10,
      this.borderWidth = 3,
      this.insets = 10,
      this.unselectedLabelColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var _unselectedLableColor =
        themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;
    return TabBar(
      controller: tabController,
      tabs: tabs,
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.round,
          borderSide: BorderSide(color: primary, width: borderWidth),
          insets: EdgeInsets.only(left: insets, right: insets)),
      isScrollable: true,
      labelColor: primary,
      unselectedLabelColor: _unselectedLableColor,
      labelStyle: TextStyle(fontSize: fontSize),
    );
  }
}
