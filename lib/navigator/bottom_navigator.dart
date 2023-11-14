import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/page/favorite_page.dart';
import 'package:flutter_bili/page/home_page.dart';
import 'package:flutter_bili/page/profile_page.dart';
import 'package:flutter_bili/page/ranking_page.dart';
import 'package:hi_base/color.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  var _currentIndex = 0;
  bool _hasBuild = false;
  static int initialPage = 0;

  final PageController _control = PageController(initialPage: initialPage);
  late final List<Widget> _tabPages;

  @override
  void initState() {
    super.initState();
    _tabPages = [
      HomePage(
        onJumpTo: (index) {
          _onTabChange(index, bottomChange: true);
        },
      ),
      RankingPage(),
      FavoritePage(),
      ProfilePage()
    ];
    HiNavigator.getInstance()
        .initBottomTabCurrentRoute(RouteStatus.home, _tabPages[initialPage]);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasBuild) {
      HiNavigator.getInstance()
          .onBottomTabChange(initialPage, _tabPages[initialPage]);
      _hasBuild = true;
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排名', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3),
        ],
        onTap: (index) {
          //让PageView展示对应的tab
          _onTabChange(index, bottomChange: true);
        },
        selectedItemColor: _activeColor,
      ),
      body: PageView(
        controller: _control,
        children: _tabPages,
        physics: NeverScrollableScrollPhysics(), //禁止PageView滑动页面
        onPageChanged: (index) {
          _onTabChange(index, bottomChange: false);
        },
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _defaultColor),
        activeIcon: Icon(icon, color: _activeColor),
        label: title);
  }

  //tab页切换时调用, bottomChange表示用户点击底部导航栏时切换页面并传入true；而当页面滑动后传入false
  _onTabChange(int tabIndex, {bool bottomChange = false}) {
    if (bottomChange) {
      _control.jumpToPage(tabIndex);
    } else {
      // 由于滑动/点击底部导航栏都会引起tab切换，并调用此方法，并且点击底部导航栏后会调用jumpToPage滑动页面，所以此方法可能会被调用两次
      // 我们只要在当PageView.onPageChanged回调函数调用此方法时去触发onBottomTabChange事件
      HiNavigator.getInstance()
          .onBottomTabChange(tabIndex, _tabPages[tabIndex]);
    }
    setState(() {
      _currentIndex = tabIndex; //更新底部导航栏中当前展示的tab的index
    });
  }
}
