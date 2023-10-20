import 'package:flutter/material.dart';

class LoginEffect extends StatefulWidget {
  final bool protect;

  const LoginEffect({Key? key, this.protect = false}) : super(key: key);

  @override
  State<LoginEffect> createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image(true),
          Image(height: 90, width: 90, image: AssetImage('images/logo.png')),
          _image(false)
        ],
      ),
    );
  }

  _image(bool isLeftImage) {
    var headLeft = widget.protect
        ? 'images/head_left_protect.png'
        : 'images/head_left.png';
    var headRight = widget.protect
        ? 'images/head_right_protect.png'
        : 'images/head_right.png';
    return Image(
        height: 90, image: AssetImage(isLeftImage ? headLeft : headRight));
  }
}
