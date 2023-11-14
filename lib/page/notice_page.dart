import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_base_tab_state.dart';
import 'package:flutter_bili/model/home_mo.dart';
import 'package:flutter_bili/model/notice_mo.dart';
import 'package:flutter_bili/widget/notice_card.dart';
import '../http/dao/notice_dao.dart';

///通知列表页
class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends HiBaseTabState<NoticePage, NoticeMo, BannerMo> {
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

  _buildNavigationBar() {
    return AppBar(
      title: Text('通知'),
    );
  }

  @override
  get childContent => ListView.builder(
      padding: EdgeInsets.only(top: 10),
      controller: scrollController,
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return NoticeCard(bannerMo: dataList[index]);
      });

  @override
  Future<NoticeMo> getData(int pageIndex) async {
    NoticeMo result =
        await NoticeDao.noticeList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<BannerMo> parseList(NoticeMo result) {
    return result.list;
  }
}
