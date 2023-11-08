import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/utils/color.dart';
import 'package:provider/provider.dart';

class DarkModePage extends StatefulWidget {
  const DarkModePage({Key? key}) : super(key: key);

  @override
  State<DarkModePage> createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  static const _ITEMS = [
    {"name": "跟随系统", "mode": ThemeMode.system},
    {"name": "开启", "mode": ThemeMode.dark},
    {"name": "关闭", "mode": ThemeMode.light},
  ];

  late ThemeProvider _themeProvider;
  var _currentItem;

  @override
  void initState() {
    super.initState();
    _themeProvider = context.read<ThemeProvider>();
    var currentThemeMode = _themeProvider.getThemeMode();
    _currentItem =
        _ITEMS.where((item) => item['mode'] == currentThemeMode).firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('夜间模式'), centerTitle: true),
        body: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              bool isSelected = false;
              if (_currentItem != null && _ITEMS[index] == _currentItem) {
                isSelected = true;
              }
              return InkWell(
                  onTap: () {
                    _themeProvider.setTheme(_ITEMS[index]['mode'] as ThemeMode);
                    setState(() {
                      _currentItem = _ITEMS[index];
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(_ITEMS[index]["name"] as String ?? '')),
                        Opacity(
                          opacity: isSelected ? 1 : 0,
                          child: Icon(Icons.done, color: primary),
                        )
                      ],
                    ),
                  ));
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: _ITEMS.length));
  }
}
