import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/utils/color.dart';
import 'package:flutter_bili/utils/view_util.dart';

class BarrageInput extends StatelessWidget {
  final VoidCallback? onPopupClose;
  final _editorController = TextEditingController();

  BarrageInput({Key? key, this.onPopupClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          //点击空白区域，关闭弹框
          Expanded(
              child: GestureDetector(
            onTap: () {
              if (onPopupClose != null) {
                onPopupClose!();
              }
              Navigator.of(context).pop();
            },
            child: Container(color: Colors.transparent),
          )),
          SafeArea(
              child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      hiSpace(width: 15),
                      _buildInput(context),
                      _buildSendBtn(context)
                    ],
                  )))
        ],
      ),
    );
  }

  _buildInput(BuildContext context) {
    return Expanded(
        child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20)),
            child: TextField(
              autofocus: true,
              controller: _editorController,
              onSubmitted: (text) {
                _send(text, context);
              },
              cursorColor: primary,
              decoration: InputDecoration(
                  hintText: '发个友善的弹幕见证当下',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  isDense: true //彻底去除TextField的内边距),
                  ),
            )));
  }

  _buildSendBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        var text = _editorController.text.trim();
        _send(text, context);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(Icons.send_rounded, color: Colors.grey),
      ),
    );
  }

  ///发送消息
  void _send(String text, BuildContext context) {
    if (text.isNotEmpty) {
      if (onPopupClose != null) {
        onPopupClose!();
      }
      Navigator.of(context).pop(text);
    }
  }
}
