import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/provider/theme_provider.dart';
import 'package:hi_base/view_util.dart';
import 'package:provider/provider.dart';

import '../utils/view_util.dart';

///可动态改变title距离底部位置的header组件，并实现局部刷新，优化性能
class HiFlexibleHeader extends StatefulWidget {
  final String face;
  final String name;
  final ScrollController scrollController;

  const HiFlexibleHeader(
      {Key? key,
      required this.name,
      required this.face,
      required this.scrollController})
      : super(key: key);

  @override
  State<HiFlexibleHeader> createState() => _HiFlexibleHeaderState();
}

class _HiFlexibleHeaderState extends State<HiFlexibleHeader> {
  static const double MAX_BOTTOM = 40; //title相对header底部的最大距离
  static const double MIN_BOTTOM = 20; //title相对header底部的最小距离
  static const double MAX_OFFSET =
      80; //滚动屏幕的最大距离，即当滚动距离超过此值时，dyBottom达到MAX_BOTTOM
  double _dyBottom = MAX_BOTTOM; //动态计算出的title相对header底部的距离

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      double offset = widget.scrollController.offset;
      //计算出padding变化系数0~1
      double dyOffset = (MAX_OFFSET - offset) / MAX_OFFSET;
      //根据dyOffset算出具体的变化的padding值
      var dy = dyOffset * (MAX_BOTTOM - MIN_BOTTOM);
      //临界值保护
      if (dy > (MAX_BOTTOM - MIN_BOTTOM)) {
        dy = MAX_BOTTOM - MIN_BOTTOM;
      } else if (dy < 0) {
        dy = 0;
      }
      setState(() {
        //算出实际的padding
        _dyBottom = MIN_BOTTOM + dy;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _dyBottom, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: cachedImage(widget.face, width: 46, height: 46),
          ),
          hiSpace(width: 8),
          Text(widget.name, style: TextStyle(fontSize: 11))
        ],
      ),
    );
  }
}
