import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class LoginInput extends StatefulWidget {
  final String title;
  final String hint;
  final bool obsecureText;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<bool>? onFocusChanged;
  final bool lineStretch;
  final TextInputType? keyboardType; //文本框接受的键盘类型，全键盘或数字键盘

  const LoginInput(
      {Key? key,
      required this.title,
      required this.hint,
      this.obsecureText = false,
      this.onTextChanged,
      this.onFocusChanged,
      this.lineStretch = false,
      this.keyboardType})
      : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    //是否获取光标的监听
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (widget.onFocusChanged != null) {
        widget.onFocusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(widget.title, style: TextStyle(fontSize: 16)),
            ),
            _input()
          ],
        ),
        Padding(
            padding: EdgeInsets.only(left: widget.lineStretch ? 0 : 15),
            child: Divider(height: 1, thickness: 0.5))
      ],
    );
  }

  Widget _input() {
    return Expanded(
        child: TextField(
      focusNode: _focusNode,
      obscureText: widget.obsecureText,
      autofocus: !widget.obsecureText,
      onChanged: widget.onTextChanged,
      keyboardType: widget.keyboardType,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      cursorColor: primary,
      //输入框的样式
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, right: 20),
          border: InputBorder.none,
          hintText: widget.hint ?? "",
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
    ));
  }
}
