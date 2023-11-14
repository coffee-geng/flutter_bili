import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'barrage_mo.dart';

class BarrageViewUtil {
  static Widget barrageView(BarrageMo model) {
    switch (model.type) {
      case 1:
        return _barrageType1(model);
    }
    return _barrageDefaultType(model);
  }

  static Widget _barrageDefaultType(BarrageMo model) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.black26),
        padding: EdgeInsets.all(3),
        child: Text(model.content,
            style: TextStyle(fontSize: 12, color: Colors.white)),
      ),
    );
  }

  static Widget _barrageType1(BarrageMo model) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.orangeAccent)),
        child: Text(model.content,
            style: TextStyle(fontSize: 12, color: Colors.white)),
      ),
    );
  }
}
