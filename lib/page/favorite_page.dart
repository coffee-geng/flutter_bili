import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_base_tab_state.dart';
import 'package:flutter_bili/http/dao/favorite_dao.dart';
import 'package:flutter_bili/model/ranking_mo.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/page/video_detail_page.dart';
import 'package:flutter_bili/widget/video_large_card.dart';
import 'package:hi_base/hi_state.dart';
import 'package:flutter_bili/widget/navigation_bar.dart' as nav;

import '../navigator/hi_navigator.dart';
import '../utils/view_util.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState
    extends HiBaseTabState<FavoritePage, RankingMo, VideoMo> {
  late RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(
        listener = (RouteStatusInfo current, RouteStatusInfo? pre) {
      if (pre?.widget is! VideoDetailPage && current.widget is FavoritePage) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildNavigationBar(),
          Expanded(child: super.build(context))
        ],
      ),
    );
  }

  @override
  get childContent => ListView.builder(
      padding: EdgeInsets.only(top: 10),
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) =>
          VideoLargeCard(videoModel: dataList[index]));

  @override
  Future<RankingMo> getData(int pageIndex) async {
    RankingMo result =
        await FavoriteDao.favoriteList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoMo> parseList(RankingMo result) {
    return result.list ?? [];
  }

  _buildNavigationBar() {
    return nav.NavigationBar(
      child: Container(
        alignment: Alignment.center,
        child: Text('收藏', style: TextStyle(fontSize: 16)),
        decoration: bottomBoxShadow(context),
      ),
    );
  }
}
