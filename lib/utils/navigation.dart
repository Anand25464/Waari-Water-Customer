import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';


class CustomNavigation {
  static push(Widget navigation, {bool fullScreenDialog = false}) async {
    return Navigator.push(
      Get.context!,
      CupertinoPageRoute(
        builder: (context) => navigation,
        fullscreenDialog: fullScreenDialog,
      ),
    );
  }

  static pushAndRemoveUntil(Widget navigation) async {
    return Navigator.of( Get.context!,)
        .pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => navigation),
            (Route<dynamic> route) => false);
  }

  static pushNamed(Widget navigation) {
    return Navigator.pushReplacement(
      Get.context!,
      CupertinoPageRoute(
        builder: (context) => navigation,
      ),
    );
  }

  static pop({bool closeOverlay = false, dynamic data}) async {
    return Navigator.pop( Get.context!,);
  }


}
