import 'package:flutter/cupertino.dart';
import 'package:flutter_bili/core/hi_base_tab_state.dart';
import 'package:flutter_bili/http/dao/ranking_dao.dart';
import 'package:flutter_bili/model/ranking_mo.dart';
import 'package:flutter_bili/widget/video_large_card.dart';

import '../model/video_model.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;

  const RankingTabPage({Key? key, this.sort = 'like'}) : super(key: key);

  @override
  State<RankingTabPage> createState() => _RankingTabPageState();
}

class _RankingTabPageState
    extends HiBaseTabState<RankingTabPage, RankingMo, VideoMo> {
  @override
  get childContent => Container(
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 10),
            controller: scrollController,
            itemCount: dataList.length,
            itemBuilder: (buildContext, index) =>
                VideoLargeCard(videoModel: dataList[index])),
      );

  @override
  Future<RankingMo> getData(int pageIndex) async {
    var result = await RankingDao.get(
        sort: widget.sort, pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoMo> parseList(RankingMo result) {
    return result.list ?? [];
  }
}
