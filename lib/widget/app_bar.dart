import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///自定义顶部appbar
PreferredSizeWidget appBar(String title,
    {String? rightTitle, VoidCallback? rightButtonClick}) {
  return AppBar(
    centerTitle: false,
    titleSpacing: 0,
    title: Text(title, style: TextStyle(fontSize: 18)),
    leading: BackButton(),
    actions: [
      rightTitle != null
          ? InkWell(
              onTap: rightButtonClick,
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                alignment: Alignment.center,
                child: Text(rightTitle!,
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    textAlign: TextAlign.center),
              ),
            )
          : Container()
    ],
  );
}
