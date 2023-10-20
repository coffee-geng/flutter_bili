import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String message, {Toast? toastLength = Toast.LENGTH_LONG}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0);
}

showWarningToast(String message, {Toast toastLength = Toast.LENGTH_LONG}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
