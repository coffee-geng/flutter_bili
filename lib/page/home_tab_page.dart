import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_state.dart';
import 'package:flutter_bili/widget/hi_banner.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../http/core/hi_error.dart';
import '../http/dao/home_dao.dart';
import '../model/home_mo.dart';
import '../model/video_model.dart';
import '../utils/color.dart';
import '../utils/toast.dart';
import '../widget/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String? categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, this.categoryName, this.bannerList})
      : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends HiState<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoMo> videoList = [];
  int pageIndex = 1;
  bool isLoading = false; //当正在加载列表时，不允许进行上拉加载更多操作

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final curScrollExtent = _scrollController.position.pixels;
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      //向上滑动页面，当列表的底部距离屏幕底部XX像素时，进行拉取更多数据的操作
      if (!isLoading && maxScrollExtent - curScrollExtent < 300) {
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: RefreshIndicator(
            color: primary,
            onRefresh: loadData,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  if (widget.bannerList != null &&
                      widget.bannerList!.isNotEmpty)
                    StaggeredGridTile.fit(
                        crossAxisCellCount: 2,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: _banner(),
                        )),
                  ...videoList
                      .map((videoMo) => StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: VideoCard(videoModel: videoMo)))
                      .toList()
                ],
              ),
            ),
          )),
    );
  }

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(
          bannerList: widget.bannerList,
        ));
  }

  Future<void> loadData({loadMore = false}) async {
    isLoading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    //使用currentIndex而不是直接使用pageIndex是因为防止加载失败时还要pageIndex--
    int currentIndex = pageIndex + (loadMore ? 1 : 0);

    try {
      HomeMo result = await HomeDao.get(widget.categoryName ?? '',
          pageIndex: currentIndex, pageSize: 16);
      // print('loadData(): $result');

      var array = result.videoList ?? [];
      setState(() {
        if (loadMore) {
          videoList = [...videoList, ...array];
          if (array.isNotEmpty) {
            pageIndex++; //加载成功后pageIndex才加一
          }
        } else {
          videoList = array;
        }
        Future.delayed(Duration(milliseconds: 500), () {
          isLoading = false;
        });
      });
    } on NeedAuth catch (e) {
      print(e);
      isLoading = false;
      showWarningToast(e.message);
    } on NeedLogin catch (e) {
      print(e);
      isLoading = false;
    } on HiNetError catch (e) {
      print(e);
      isLoading = false;
      showWarningToast(e.message);
    }
  }

  /// 使列表常驻内存，并使页面跳转后不被销毁
  @override
  bool get wantKeepAlive => true;
}
