import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

 void showToast({
  required String msg,
  Toast length = Toast.LENGTH_SHORT,
  ToastGravity gravity = ToastGravity.BOTTOM,
  int timeInSecForIosWeb = 1,
  Color backgroundColor = Colors.pink,
  Color textColor = Colors.yellow,
  double fontSize = 16.0,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: length,
    gravity: gravity,
    timeInSecForIosWeb: timeInSecForIosWeb,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}