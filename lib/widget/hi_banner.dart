import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/navigator/hi_navigator.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import '../model/home_mo.dart';
import '../model/video_model.dart';

class HiBanner extends StatelessWidget {
  final List<BannerMo>? bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry? padding;

  const HiBanner(
      {Key? key, this.bannerList, this.bannerHeight = 160, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    double right = 10 + (padding != null ? padding!.horizontal / 2 : 0);
    return Swiper(
      itemCount: bannerList?.length ?? 0,
      autoplay: true,
      itemBuilder: (buildContext, index) {
        return bannerList?[index] != null
            ? _image(bannerList![index])
            : Container();
      },
      //自定义指示器
      pagination: SwiperPagination(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(bottom: 10, right: right),
          builder: DotSwiperPaginationBuilder(
              activeColor: Colors.white,
              color: Colors.white60,
              size: 6,
              activeSize: 8)),
    );
  }

  _image(BannerMo bannerMo) {
    return InkWell(
      onTap: () {
        print('点击了${bannerMo.url}');
        _handleClick(bannerMo);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: Image.network(bannerMo.cover, fit: BoxFit.cover),
        ),
      ),
    );
  }

  void _handleClick(BannerMo bannerMo) {
    if (bannerMo.type == 'video') {
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
          args: {'videoMo': VideoMo(vid: bannerMo.url)});
    } else {
      print('type: ${bannerMo.type} ,url: ${bannerMo.url}');
      HiNavigator.getInstance().openH5(bannerMo.url);
    }
  }
}
