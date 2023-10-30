import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_base_tab_state.dart';
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

class _HomeTabPageState extends HiBaseTabState<HomeTabPage, HomeMo, VideoMo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  _banner() {
    return Container(
        child: HiBanner(
      padding: EdgeInsets.only(left: 5, right: 5),
      bannerList: widget.bannerList,
    ));
  }

  @override
  get childContent => SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            if (widget.bannerList != null && widget.bannerList!.isNotEmpty)
              StaggeredGridTile.fit(
                  crossAxisCellCount: 2,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: _banner(),
                  )),
            ...dataList
                .map((videoMo) => StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: VideoCard(videoModel: videoMo)))
                .toList()
          ],
        ),
      );

  @override
  Future<HomeMo> getData(int pageIndex) async {
    HomeMo result = await HomeDao.get(widget.categoryName ?? '',
        pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoMo> parseList(HomeMo result) {
    return result.videoList;
  }
}
