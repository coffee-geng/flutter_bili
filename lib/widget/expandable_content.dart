import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/model/video_model.dart';
import 'package:flutter_bili/utils/view_util.dart';
import 'package:intl/intl.dart';

class ExpandableContent extends StatefulWidget {
  final VideoMo videoModel;

  const ExpandableContent({Key? key, required this.videoModel})
      : super(key: key);

  @override
  State<ExpandableContent> createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with TickerProviderStateMixin {
  // static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  //可以通过begin,end指定动画的初始值和目标值，并且通过chain函数结合另一个缓动动画。CurveTween默认的动画初始值和目标值应该就是0-->1
  static final Animatable<double> _easeInTween =
      Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeIn));

  bool _expand = false;

  //用来管理Animation
  late AnimationController _controller;

  //生成的参与动画的值对象
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _controller.addListener(onValueAnimated);
  }

  @override
  void dispose() {
    _controller.removeListener(onValueAnimated);
    _controller.dispose();
    super.dispose();
  }

  onValueAnimated() {
    //监听动画值的变化
    print('动画值变为：${_heightFactor.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: [
          _buildTitle(),
          Padding(padding: EdgeInsets.only(bottom: 8)),
          _buildInfo(),
          _buildDescption()
        ],
      ),
    );
  }

  _buildTitle() {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //通过Expanded让Text获取最大宽度，以便显示省略号
          Expanded(
              child: Text(widget.videoModel.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
          Padding(padding: EdgeInsets.only(left: 15)),
          Icon(
              _expand
                  ? Icons.keyboard_arrow_up_sharp
                  : Icons.keyboard_arrow_down_sharp,
              color: Colors.grey,
              size: 16)
        ],
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  _buildInfo() {
    var style = TextStyle(fontSize: 12, color: Colors.grey);
    var createTime = DateTime.parse(widget.videoModel.createTime);
    var dateStr = DateFormat('MM-dd').format(createTime);
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.videoModel.view),
        Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconText(Icons.list_alt, widget.videoModel.reply),
        Padding(padding: EdgeInsets.only(left: 10)),
        Text('$dateStr', style: style)
      ],
    );
  }

  _buildDescption() {
    var child = _expand
        ? Text(widget.videoModel.desc,
            style: TextStyle(fontSize: 12, color: Colors.grey))
        : null;
    //构建动画
    return AnimatedBuilder(
        animation: _controller.view,
        child: child, //这个child的值将传递给builder中的child参数
        builder: (buildContext, child) {
          return Align(
            heightFactor: _heightFactor.value,
            alignment: Alignment.topCenter,
            //为了让描述内容居左，并且有上间距
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 8),
              child: child,
            ),
          );
        });
  }
}
