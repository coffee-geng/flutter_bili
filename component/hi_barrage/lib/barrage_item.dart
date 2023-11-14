import 'package:flutter/cupertino.dart';
import 'barrage_transition.dart';

class BarrageItem extends StatelessWidget {
  final String id; //某个弹幕组件的id
  final double top;
  final Widget child;
  final Duration duration;
  final ValueChanged? onComplete;

  const BarrageItem(
      {Key? key,
      required this.id,
      required this.top,
      required this.child,
      this.duration = const Duration(milliseconds: 9000),
      this.onComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: top,
        child: BarrageTransition(
          duration: duration,
          child: child,
        ));
  }
}
