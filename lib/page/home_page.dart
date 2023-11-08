import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_state.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_bili/page/home_tab_page.dart';
import 'package:flutter_bili/page/profile_page.dart';
import 'package:flutter_bili/page/video_detail_page.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:flutter_bili/utils/color.dart';
import 'package:flutter_bili/utils/toast.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:flutter_bili/widget/hi_tab.dart';
import 'package:flutter_bili/widget/loading_container.dart';
import 'package:flutter_bili/widget/navigation_bar.dart' as nav;
import 'package:provider/provider.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../http/dao/home_dao.dart';
import '../model/home_mo.dart';
import '../model/video_model.dart';
import '../widget/navigation_bar.dart' as nav;

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  late RouteChangeListener listener;

  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  late TabController _tabController;
  bool _isLoading = true;
  Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(listener = (current, prev) {
      _currentPage = current.widget;
      if (widget == current.widget || current.widget is! HomePage) {
        print(
            '页面${(prev != null) ? "从${prev!.widget.toString()}" : ""} 切换到${current.widget.toString()}');
      } else if (prev != null &&
          (widget == prev.widget || prev.widget is HomePage)) {
        print('页面${prev.widget.toString()} 被压后台');
      }

      //当页面返回到首页，需恢复首页的状态栏样式
      //因为ProfilePage要实现沉浸式效果，所以排除
      if (prev?.widget is VideoDetailPage && current.widget is! ProfilePage) {
        changeStatusBar(
            color: Colors.white, statusStyle: nav.StatusStyle.DARK_CONTENT);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    HiNavigator.getInstance().removeListener(listener);
    super.dispose();
  }

  ///监听应用生命周期的变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(':didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.inactive: //非激活状态，将要进入到暂停态
        break;
      case AppLifecycleState.paused: //暂停态，压后台
        break;
      case AppLifecycleState.resumed: //从后台切换到前台
        //修改Android压后台，状态栏字体颜色变白的问题
        if (_currentPage is! VideoDetailPage) {
          changeStatusBar(
              color: Colors.white,
              statusStyle: nav.StatusStyle.DARK_CONTENT,
              context: context);
        }
        break;
      case AppLifecycleState.detached: //应用结束，app被销毁
        break;
    }
  }

  ///监听系统dark mode的变化
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    var themeProvider = context.read<ThemeProvider>();
    themeProvider.darkModeChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingContainer(
      isLoading: _isLoading,
      isCover: true,
      child: Column(
        children: [
          nav.NavigationBar(
            height: 50,
            child: _appBar(),
            color: Colors.white,
            statusStyle: nav.StatusStyle.DARK_CONTENT,
          ),
          Container(
            child: _tabBar(),
            //decoration和color只能选其一
            // color: Colors.white,
            decoration: bottomBoxShadow(context),
          ),
          Flexible(
              child: TabBarView(
            controller: _tabController,
            children: categoryList
                .map<HomeTabPage>((category) => HomeTabPage(
                    categoryName: category.name,
                    bannerList: category.name == '推荐' ? bannerList : null))
                .toList(),
          ))
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _tabBar() {
    return HiTab(
        tabController: _tabController,
        tabs: categoryList
            .map<Tab>(
              (category) => Tab(
                child: Padding(
                  padding: EdgeInsets.only(left: 2, right: 2),
                  child: Text(
                    category.name ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
            .toList(),
        fontSize: 16,
        borderWidth: 3,
        unselectedLabelColor: Colors.black54,
        insets: 15);
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get('推荐');
      // print('loadData(): $result');
      //tab长度变化后需要重现创建TabController
      _tabController =
          TabController(length: result.categoryList?.length ?? 0, vsync: this);
      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      showWarningToast(e.message);
    } on NeedLogin catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      showWarningToast(e.message);
    }
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3); //跳转到ProfilePage
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(23)),
              child: Image(
                image: AssetImage('images/avatar.png'),
                height: 46,
                width: 46,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.search, color: Colors.grey),
                decoration: BoxDecoration(color: Colors.grey[200]),
              ),
            ),
          )),
          Icon(Icons.explore_outlined, color: Colors.grey),
          InkWell(
            onTap: () {
              HiNavigator.getInstance().onJumpTo(RouteStatus.notice);
            },
            child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.mail_outline, color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
