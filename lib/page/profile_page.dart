import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/core/hi_state.dart';
import 'package:flutter_bili/http/dao/profile_dao.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:flutter_bili/widget/benefit_card.dart';
import 'package:flutter_bili/widget/course_card.dart';
import 'package:flutter_bili/widget/hi_banner.dart';

import '../http/core/hi_error.dart';
import '../model/profile_mo.dart';
import '../utils/toast.dart';
import '../widget/hi_blur.dart';
import '../widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends HiState<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileMo? _profileMo;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[_buildAppBar()];
            },
            body: ListView(
              padding: EdgeInsets.only(top: 10),
              children: [..._buildContentList()],
            )));
  }

  void loadData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      setState(() {
        _profileMo = result;
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

  _buildHead() {
    if (_profileMo == null) return Container();
    return HiFlexibleHeader(
        name: _profileMo!.name ?? '',
        face: _profileMo!.face ?? '',
        scrollController: _scrollController);
  }

  _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      //标题栏是否固定，当设置为false时，向上滚动屏幕会将标题栏移出屏幕之外
      pinned: true,
      //定义滚动的空间，即放置滚动组件标题栏及其背景组件的地方
      flexibleSpace: FlexibleSpaceBar(
        collapseMode:
            CollapseMode.parallax, //实现视差滚动效果：列表的滚动速度和图片的上移速度是不一致的，从而产生视差滚动效果
        titlePadding: EdgeInsets.only(left: 0),
        title: _buildHead(),
        //标题栏背后的背景层组件
        background: Stack(
          children: [
            Positioned.fill(
                child: cachedImage(
                    'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
            Positioned.fill(child: HiBlur(sigma: 20)),
            Positioned(child: _buildProfileTab(), bottom: 0, left: 0, right: 0)
          ],
        ),
      ),
    );
  }

  _buildProfileTab() {
    if (_profileMo == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _createIconText('收藏', _profileMo!.favorite ?? 0),
          _createIconText('点赞', _profileMo!.like ?? 0),
          _createIconText('浏览', _profileMo!.browsing ?? 0),
          _createIconText('金币', _profileMo!.coin ?? 0),
          _createIconText('粉丝', _profileMo!.fans ?? 0),
        ],
      ),
    );
  }

  _createIconText(String text, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 15, color: Colors.black87)),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  _buildContentList() {
    if (_profileMo == null) return [];
    return [
      _buildBanner(_profileMo!),
      CourseCard(courseList: _profileMo!.courseList ?? []),
      BenefitCard(benefitList: _profileMo!.benefitList ?? [])
    ];
  }

  _buildBanner(ProfileMo profileMo) {
    return HiBanner(
        bannerList: profileMo.bannerList,
        bannerHeight: 120,
        padding: EdgeInsets.only(left: 10, right: 10));
  }

  @override
  bool get wantKeepAlive => true;
}
