import 'package:flutter/cupertino.dart';

class BarrageTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ValueChanged? onComplete;

  const BarrageTransition(
      {Key? key, required this.child, required this.duration, this.onComplete})
      : super(key: key);

  @override
  State<BarrageTransition> createState() => _BarrageTransitionState();
}

class _BarrageTransitionState extends State<BarrageTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: widget.duration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (widget.onComplete != null) {
                widget.onComplete!(''); //动画执行完毕之后的回调，参数dynamic可以是null之外的任意值
              }
            }
          });
    //定义从右向左的补间动画
    var begin = Offset(1.0, 0);
    var end = Offset(-1.0, 0);
    _animation =
        Tween<Offset>(begin: begin, end: end).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 修复动画状态错乱
  var _key = GlobalKey<_BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        key: _key, position: _animation, child: widget.child);
  }
}
