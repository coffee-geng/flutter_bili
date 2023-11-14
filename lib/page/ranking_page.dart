import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/hi_state.dart';
import 'package:flutter_bili/http/dao/ranking_dao.dart';
import 'package:flutter_bili/page/ranking_tab_page.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:flutter_bili/widget/hi_tab.dart';
import 'package:flutter_bili/widget/navigation_bar.dart' as nav;
import 'package:hi_net/core/hi_error.dart';
import '../utils/toast.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends HiState<RankingPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  static const _TABS = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"}
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _TABS.length, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [_buildTabNavigation(), _buildTabView()]));
  }

  _buildTabNavigation() {
    return nav.NavigationBar(
      child: Container(
        alignment: Alignment.center,
        child: _tabBar(),
        decoration: bottomBoxShadow(context),
      ),
    );
  }

  _tabBar() {
    return HiTab(
        tabController: _tabController,
        tabs: _TABS
            .map((item) => Tab(
                  text: item['name'],
                ))
            .toList(),
        fontSize: 16,
        borderWidth: 3,
        unselectedLabelColor: Colors.black54);
  }

  _buildTabView() {
    return Flexible(
        child: TabBarView(
      controller: _tabController,
      children: _TABS
          .map((item) => RankingTabPage(
                sort: item['key'] as String,
              ))
          .toList(),
    ));
  }

  void _loadData() {
    try {
      var result = RankingDao.get(sort: 'like');
    } on NeedLogin catch (e) {
      print(e);
    } on NeedAuth catch (e) {
      print(e);
      showWarningToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarningToast(e.message);
    }
  }
}
