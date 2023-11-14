import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'barrage_item.dart';
import 'barrage_mo.dart';
import 'barrage_view_util.dart';
import 'hi_socket.dart';

enum BarrageStatus { play, pause }

class HiBarrage extends StatefulWidget {
  final String vid;
  final int lineCount;
  final double top;
  final int speed;
  final bool autoplay;
  final Map<String, dynamic> headers;

  const HiBarrage(
      {Key? key,
      required this.vid,
      this.lineCount = 4,
      this.top = 0,
      this.speed = 800,
      this.autoplay = false,
      required this.headers})
      : super(key: key);

  @override
  State<HiBarrage> createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  late HiSocket _hiSocket;
  late double _width; //弹幕容器的宽高，一般就是背景视频的高宽
  late double _height;
  List<BarrageMo> _barrageModelList = []; //本地候选弹幕模型集合
  List<BarrageItem> _barrageWidgetList = []; //弹幕Item组件集合
  BarrageStatus? _barrageStatus; //当前正在播放弹幕还是暂停播放
  Timer? _timer; //用于定时控制从候选弹幕模型集合中取出弹幕，并播放到屏幕
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket(widget.headers);
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    _hiSocket.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double height = screenWidth * (9 / 16);
    _width = screenWidth;
    _height = height;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          Container(), //防止Stack的children为空
          ..._barrageWidgetList
        ],
      ),
    );
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    _barrageWidgetList.clear(); //清空屏幕上的弹幕
    //即使回调没有代码也能更新UI
    setState(() {});
    print('action: pause');
    _timer?.cancel();
  }

  @override
  void play() {
    print('action: play');
    _barrageStatus = BarrageStatus.play;
    if (_timer != null && _timer!.isActive) {
      //定时器已经启动
      return;
    }
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        //从候选集合中取出第一个弹幕模型，随着将其从集合中剔除
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
        print('stat: ${temp.content}');
      } else {
        //所有弹幕都发送完后，关闭定时器
        print('All barrages are sent.');
        _timer?.cancel();
      }
    });
  }

  @override
  void send(String message) {
    if (message == null || message.isEmpty) {
      return;
    }
    _hiSocket.send(message);
    //当在输入弹出框发送弹幕给服务器时，前端并没有立即从服务器接收到此弹幕消息，所以不得不使用下面的代码把弹幕显示在屏幕上
    //可能是个bug，临时这样改
    _handleMessage(
        [BarrageMo(content: message, vid: widget.vid, priority: 1, type: 1)]);
  }

  ///收到服务器返回的弹幕数据后，根据instant决定是否立即播放弹幕，还是排到候选列表末尾。
  ///barrageStatus初始的时候为空，当设置了autoplay，并且状态不是暂停态时，接收到数据也要播放。
  void _handleMessage(List<BarrageMo> value, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, value);
    } else {
      _barrageModelList.addAll(value);
    }
    if (_barrageStatus == BarrageStatus.play) {
      play();
    } else if (widget.autoplay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  void addBarrage(BarrageMo model) {
    double perRowHeight = 30;
    int newBarrageIndex = _barrageWidgetList.length;
    int line = newBarrageIndex %
        widget.lineCount; //当前处理的弹幕在第几行。如果有10个弹幕，总行数为4，则按0,1,2,3,0,1,2,3,0,1放置
    double top = widget.top + line * perRowHeight;
    //计算出弹幕的唯一ID
    String barrageId = '${_random.nextInt(10000)}:${model.content}';
    final newBarrageItem = BarrageItem(
      id: barrageId,
      top: top,
      child: BarrageViewUtil.barrageView(model),
      onComplete: _onComplete(barrageId),
    );
    _barrageWidgetList.add(newBarrageItem);
    setState(() {});
  }

  _onComplete(id) {
    print('done: $id');
    _barrageWidgetList.removeWhere((element) => element.id == id);
    setState(() {});
  }
}

abstract class IBarrage {
  void send(String message);

  void play();

  void pause();
}
