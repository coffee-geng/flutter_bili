import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/widget/hi_blur.dart';
import 'package:hi_base/view_util.dart';

import '../model/profile_mo.dart';

class BenefitCard extends StatelessWidget {
  final List<BenefitMo> benefitList;

  const BenefitCard({Key? key, required this.benefitList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 5, top: 15),
      child: Column(
        children: [_buildTitle(), _buildBenefitList(context, benefitList)],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text('增值服务',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          hiSpace(width: 10),
          Text('购买后登录慕课网再次点击打开查看',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
        ],
      ),
    );
  }

  _buildBenefitList(BuildContext context, List<BenefitMo> benefitList) {
    double screenWidth = MediaQuery.of(context).size.width;
    //计算出每个卡片的宽度，20是此组件的左右外边距和，5是卡片之间的间隙
    double cardWidth =
        (screenWidth - 20 - (benefitList.length - 1) * 5) / benefitList.length;
    double cardHeight = cardWidth * (9 / 16);
    return Row(
      children: benefitList
          .map((mo) => _buildCard(mo, cardWidth, height: cardHeight))
          .toList(),
    );
  }

  Widget _buildCard(BenefitMo mo, double width, {double? height}) {
    return InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.only(right: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              alignment: Alignment.center,
              width: width,
              height: 60,
              decoration: BoxDecoration(color: Colors.deepOrangeAccent),
              child: Stack(
                children: [
                  Positioned.fill(child: HiBlur(sigma: 20)),
                  Positioned.fill(
                      child: Center(
                    child: Text(
                      mo.name ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
