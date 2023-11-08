import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:provider/provider.dart';

class DarkModeItem extends StatelessWidget {
  const DarkModeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    IconData iconData = themeProvider.isDark()
        ? Icons.nightlight_round
        : Icons.wb_sunny_rounded;
    return InkWell(
        onTap: () {
          HiNavigator.getInstance().onJumpTo(RouteStatus.dark_mode);
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 15, left: 15),
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              Text('夜间模式',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 2),
                child: Icon(iconData),
              )
            ],
          ),
        ));
  }
}
