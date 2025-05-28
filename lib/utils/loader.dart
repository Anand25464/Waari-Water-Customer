import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:get/route_manager.dart';
import 'package:waari_water/utils/navigation.dart';


showLoader() {
  Widget progressIndicator;
  if (kIsWeb) {
    progressIndicator = const CircularProgressIndicator(

    );
  } else {
    progressIndicator = Platform.isAndroid
        ? const CircularProgressIndicator(

    )
        : const CupertinoActivityIndicator(
      radius: 14,
    );
  }

  return showDialog(
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2),
    context: Get.context!,
    builder: (_) => Center(child: progressIndicator),
  );
}

closeLoader(BuildContext context) {
  CustomNavigation.pop();
}