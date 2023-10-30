import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bili/core/hi_state.dart';
import 'package:flutter_bili/http/core/hi_error.dart';
import 'package:flutter_bili/http/dao/favorite_dao.dart';
import 'package:flutter_bili/http/dao/video_detail_dao.dart';
import 'package:flutter_bili/model/video_detail_mo.dart';
import 'package:flutter_bili/utils/toast.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:flutter_bili/widget/app_bar.dart';
import 'package:flutter_bili/widget/expandable_content.dart';
import 'package:flutter_bili/widget/video_header.dart';
import 'package:flutter_bili/widget/video_large_card.dart';
import 'package:flutter_bili/widget/video_toolbar.dart';
import 'package:flutter_bili/widget/video_view.dart';
import 'package:flutter_bili/widget/navigation_bar.dart' as nav;

import '../http/dao/like_dao.dart';
import '../model/video_model.dart';
import '../widget/hi_tab.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo videoModel;

  const VideoDetailPage(this.videoModel, {Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends HiState<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> _tabs = ['简介', '评论'];

  VideoDetailMo? _videoDetailMo;
  late VideoMo _videoMo;
  List<VideoMo> _videoList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    changeStatusBar(
        color: Colors.black, statusStyle: nav.StatusStyle.LIGHT_CONTENT);
    _videoMo = widget.videoModel;
    _loadDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: _videoMo.url != null
            ? Column(
                children: [
                  VideoView(
                    url: _videoMo.url!,
                    cover: _videoMo.cover,
                    overlayUI: videoAppBar(),
                  ),
                  _buildTabNavigation(),
                  Flexible(
                      child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDetailList(),
                      Container(
                        child: Text('敬请期待...'),
                      )
                    ],
                  ))
                ],
              )
            : Container());
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.live_tv_rounded, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabController: _tabController,
      tabs: _tabs.map<Tab>((item) {
        return Tab(
          text: item,
        );
      }).toList(),
      unselectedLabelColor: Colors.grey,
      fontSize: 14,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        ...buildContents(),
        ..._videoList
            .map((videoMo) => VideoLargeCard(videoModel: videoMo))
            .toList()
      ],
    );
  }

  buildContents() {
    return [
      if (_videoMo.owner != null)
        Container(
          child: VideoHeader(owner: _videoMo.owner!),
        ),
      ExpandableContent(videoModel: _videoMo),
      VideoToolbar(
        videoDetailMo: _videoDetailMo,
        videoMo: _videoMo,
        onLike: () => _doLikeOrUnlike(true),
        onUnlike: () => _doLikeOrUnlike(false),
        onFavorite: _doFavorite,
        onCoin: _doCoin,
        onShare: _doShare,
      )
    ];
  }

  _loadDetail() async {
    try {
      var result = await VideoDetailDao.get(_videoMo.vid);
      setState(() {
        _videoDetailMo = result;
        _videoMo = result.videoInfo;
        _videoList = result.videoList;
      });
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

  void _doLikeOrUnlike(bool isLike) async {
    if (_videoDetailMo == null) return;
    try {
      var result = await LikeDao.like(_videoMo.vid, isLike);
      print(result);
      setState(() {
        _videoDetailMo!.isLike = isLike;
        _videoMo.like = isLike ? _videoMo.like + 1 : _videoMo.like - 1;
      });
      showToast(result['msg']);
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

  void _doFavorite() async {
    if (_videoDetailMo == null) return;
    try {
      bool isFavorite = !(_videoDetailMo!.isFavorite ?? false);
      var result = await FavoriteDao.favorite(_videoMo.vid, isFavorite);
      print(result);
      setState(() {
        _videoDetailMo!.isFavorite = isFavorite;
        _videoMo.favorite =
            isFavorite ? _videoMo.favorite + 1 : _videoMo.favorite - 1;
      });
      showToast(result['msg']);
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

  void _doCoin() {}

  void _doShare() {}
}
