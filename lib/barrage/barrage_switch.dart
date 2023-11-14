import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class BarrageSwitch extends StatefulWidget {
  //初始化时是否展开
  final bool initSwitch;

  //是否为输入中
  final bool beTyping;

  //点击BarrageInput输入框，获取输入焦点时的回调
  final VoidCallback onBarrageInputFocused;

  //BarrageSwitch组件展开或收缩切换时的回调
  final ValueChanged<bool> onBarrageSwitch;

  const BarrageSwitch(
      {Key? key,
      this.initSwitch = true,
      this.beTyping = false,
      required this.onBarrageInputFocused,
      required this.onBarrageSwitch})
      : super(key: key);

  @override
  State<BarrageSwitch> createState() => _BarrageSwitchState();
}

class _BarrageSwitchState extends State<BarrageSwitch> {
  bool _expand = false; //展开或收缩BarrageSwitch组件

  @override
  void initState() {
    super.initState();
    _expand = widget.initSwitch;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 28,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300)),
        child: Row(children: [_buildText(), _buildIcon()]));
  }

  _buildText() {
    var text = widget.beTyping ? '弹幕输入中' : '点我发弹幕';
    return _expand
        ? InkWell(
            onTap: () {
              widget.onBarrageInputFocused();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(text,
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          )
        : Container();
  }

  _buildIcon() {
    return InkWell(
      onTap: () {
        setState(() {
          _expand = !_expand;
        });
        widget.onBarrageSwitch(_expand);
      },
      child: Icon(
        Icons.live_tv_rounded,
        color: _expand ? primary : Colors.grey,
      ),
    );
  }
}
