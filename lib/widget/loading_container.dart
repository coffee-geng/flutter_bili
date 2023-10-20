import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  bool isLoading;

  //true表示加载时，加载指示器重叠在组件之上；加载完成后，指示器隐藏
  //false表示加载时仅显示指示器，等完成加载后，指示器隐藏，组件显示
  bool isCover;

  LoadingContainer(
      {Key? key,
      required this.child,
      required this.isLoading,
      this.isCover = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCover) {
      return Stack(
        children: [child, if (isLoading) _lottie()],
      );
    } else {
      return isLoading ? Lottie.asset('assets/loading1.json') : child;
    }
  }

  _lottie() {
    return Container(
        child: Center(
      child: Lottie.asset('assets/loading1.json'),
    ));
  }
}
