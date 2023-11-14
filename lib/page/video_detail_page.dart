import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/barrage/barrage_switch.dart';
import 'package:hi_base/hi_state.dart';
import 'package:flutter_bili/http/dao/favorite_dao.dart';
import 'package:flutter_bili/http/dao/video_detail_dao.dart';
import 'package:flutter_bili/model/video_detail_mo.dart';
import 'package:flutter_bili/utils/hi_constant.dart';
import 'package:flutter_bili/utils/toast.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:flutter_bili/widget/app_bar.dart';
import 'package:flutter_bili/barrage/barrage_input.dart';
import 'package:flutter_bili/widget/expandable_content.dart';
import 'package:flutter_bili/widget/video_header.dart';
import 'package:flutter_bili/widget/video_large_card.dart';
import 'package:flutter_bili/widget/video_toolbar.dart';
import 'package:flutter_bili/widget/navigation_bar.dart' as nav;
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:hi_barrage/hi_barrage.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:hi_video/video_view.dart';
import '../http/dao/like_dao.dart';
import '../model/video_model.dart';
import 'package:hi_base/color.dart';
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
  var barrageKey = GlobalKey<HiBarrageState>();
  bool _inputPopupShowing = false; //输入弹出框及键盘是否展开

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    //黑色状态栏，仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: nav.StatusStyle.LIGHT_CONTENT);
    _videoMo = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: HiColor.dark_bg),
        body: _videoMo.url != null
            ? Column(
                children: [
                  VideoView(
                      url: _videoMo.url!,
                      cover: _videoMo.cover,
                      overlayUI: videoAppBar(),
                      barrageUI: HiBarrage(
                          key: barrageKey,
                          vid: _videoMo.id,
                          headers: HiConstant.headers(),
                          top: 10,
                          autoplay: true)),
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
    //使用Material实现阴影效果
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_tabBar(), _buildBarrageBtn()],
        ),
      ),
    );
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        beTyping: _inputPopupShowing,
        onBarrageInputFocused: () {
          setState(() {
            _inputPopupShowing = true;
          });
          HiOverlay.show(context,
              child: BarrageInput(
                onPopupClose: _onPopupClose,
              )).then((value) {
            print('输入框返回的内容：$value');
            barrageKey.currentState?.send(value ?? '');
          });
        },
        onBarrageSwitch: (open) {
          //展开或收缩BarrageSwitch组件
          if (open) {
            barrageKey.currentState?.play();
          } else {
            barrageKey.currentState?.pause();
          }
        });
  }

  void _onPopupClose() {
    setState(() {
      _inputPopupShowing = false;
    });
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
      bool isCancelFavorite = !isFavorite;
      var result = await FavoriteDao.favorite(_videoMo.vid, isCancelFavorite);
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
