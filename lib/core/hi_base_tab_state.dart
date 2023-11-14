import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/hi_state.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:hi_base/color.dart';
import '../utils/toast.dart';

abstract class HiBaseTabState<T extends StatefulWidget, R, S> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  List<S> dataList = []; //将要绑定到列表组件的数据集合
  int pageIndex = 1;
  bool isLoading = false; //当正在加载列表时，不允许进行上拉加载更多操作

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final curScrollExtent = scrollController.position.pixels;
      final maxScrollExtent = scrollController.position.maxScrollExtent;
      //向上滑动页面，当列表的底部距离屏幕底部XX像素时，进行拉取更多数据的操作
      if (!isLoading &&
          maxScrollExtent > 0 &&
          maxScrollExtent - curScrollExtent < 300) {
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  ///子类实现的列表组件
  get childContent;

  ///获取对应页码的数据，就是子类loadData从服务端请求的数据，如HomeMo，VideoDetailMo等
  Future<R> getData(int pageIndex);

  ///子类提供一个从服务端返回的数据结果中提取出当前这个列表组件将要绑定的数据集合
  List<S> parseList(R result);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: RefreshIndicator(
            color: primary, onRefresh: loadData, child: childContent),
      ),
    );
  }

  Future<void> loadData({loadMore = false}) async {
    if (isLoading) {
      print('上次加载还没有完成...');
      return;
    }
    isLoading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    //使用currentIndex而不是直接使用pageIndex是因为防止加载失败时还要pageIndex--
    int currentIndex = pageIndex + (loadMore ? 1 : 0);

    try {
      var result = await getData(currentIndex);
      // print('loadData(): $result');

      var array = parseList(result) ?? [];
      setState(() {
        if (loadMore) {
          dataList = [...dataList, ...array];
          if (array.isNotEmpty) {
            pageIndex++; //加载成功后pageIndex才加一
          }
        } else {
          dataList = array;
        }
        Future.delayed(Duration(milliseconds: 500), () {
          isLoading = false;
        });
      });
    } on NeedAuth catch (e) {
      print(e);
      isLoading = false;
      showWarningToast(e.message);
    } on NeedLogin catch (e) {
      print(e);
      isLoading = false;
    } on HiNetError catch (e) {
      print(e);
      isLoading = false;
      showWarningToast(e.message);
    }
  }

  /// 使列表常驻内存，并使页面跳转后不被销毁
  @override
  bool get wantKeepAlive => true;
}
