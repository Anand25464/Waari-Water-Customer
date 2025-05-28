
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetPinPage extends StatelessWidget {
  final String userMobile;
  
  const SetPinPage({super.key, required this.userMobile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set PIN',
          style: TextStyle(fontSize: 18.sp),
        ),
        toolbarHeight: 56.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Center(
          child: Text(
            'Set PIN for: $userMobile',
            style: TextStyle(fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
