import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPageController extends GetxController{

  var isSecondPage = false.obs;
  bool get getIsSecondPage => isSecondPage.value;
  set setIsSecondPage(bool val){
    isSecondPage.value = val;
    isSecondPage.refresh();
  }


  var isLastPage = false.obs;
  bool get getIsLastPage => isLastPage.value;
  set setIsLastPage(bool val){
    isLastPage.value = val;
    isLastPage.refresh();
  }
}
class MyBehavior extends ScrollBehavior   {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}