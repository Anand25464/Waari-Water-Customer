import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomNavigation {
  static push(Widget navigation, {bool fullScreenDialog = false}) async {
    return Navigator.push(
      navigatorKey.currentContext!,
      CupertinoPageRoute(
        builder: (context) => navigation,
        fullscreenDialog: fullScreenDialog,
      ),
    );
  }

  static pushAndRemoveUntil(Widget navigation) async {
    return Navigator.of(navigatorKey.currentContext!,)
        .pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => navigation),
            (Route<dynamic> route) => false);
  }

  static pushNamed(Widget navigation) {
    return Navigator.pushReplacement(
      navigatorKey.currentContext!,
      CupertinoPageRoute(
        builder: (context) => navigation,
      ),
    );
  }

  static pop({bool closeOverlay = false, dynamic data}) async {
    return Navigator.pop( navigatorKey.currentContext!,);
  }

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


}